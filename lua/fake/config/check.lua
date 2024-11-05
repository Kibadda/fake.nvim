local M = {}

--- small wrapper around vim.validate
---@param path string
---@param tbl table
---@return boolean
---@return string?
local function validate(path, tbl)
  local prefix = "invalid config: "
  local ok, err = pcall(vim.validate, tbl)
  return ok or false, prefix .. (err and path .. "." .. err or path)
end

--- validate given config
---@param config fake.internalconfig
---@return boolean
---@return string?
function M.validate(config)
  local ok, err

  ok, err = validate("fake", {
    snippets = { config.snippets, "table", true },
  })
  if not ok then
    return false, err
  end

  ok, err = validate("fake.snippets", {
    global = { config.snippets.global, "table", true },
    filetypes = { config.snippets.filetypes, "table", true },
  })
  if not ok then
    return false, err
  end

  for name, snippet in vim.spairs(config.snippets.global or {}) do
    ok, err = validate("fake.global." .. name, {
      name = { name, "string" },
      snippet = { snippet, { "string", "function" } },
    })
    if not ok then
      return false, err
    end
  end

  for filetype, snippets in vim.spairs(config.snippets.filetypes or {}) do
    ok, err = validate("fake.filetypes." .. filetype, {
      filetype = { filetype, "string" },
      snippets = { snippets, "table" },
    })
    if not ok then
      return false, err
    end

    for name, snippet in vim.spairs(snippets) do
      ok, err = validate("fake.filetypes." .. filetype .. "." .. name, {
        name = { name, "string" },
        snippet = { snippet, { "string", "function" } },
      })
      if not ok then
        return false, err
      end
    end
  end

  return true
end

return M
