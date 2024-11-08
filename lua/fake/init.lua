local M = {}

---@type vim.lsp.Client?
local client

function M.start(buf)
  if vim.bo[buf].buftype ~= "" then
    return
  end

  local server = require "fake.server"

  if not client then
    local id = vim.lsp.start_client {
      name = "fakels",
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
