local M = {}

---@type vim.lsp.Client?
local client

local function should_attach(buf)
  if vim.bo[buf].buftype ~= "" then
    return false
  end

  local config = require "fake.config"

  if not vim.tbl_isempty(config.snippets.global) then
    return true
  end

  if config.snippets.filetypes[vim.bo[buf].filetype] then
    return true
  end

  return false
end

function M.start(buf)
  if not should_attach(buf) then
    return
  end

  local server = require "fake.server"

  if not client then
    local id = vim.lsp.start_client {
      name = "fake-lsp",
      cmd = server,
    }

    if id then
      client = vim.lsp.get_client_by_id(id)
    end
  end

  if client then
    vim.lsp.buf_attach_client(buf, client.id)
  end
end

return M
