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

  for i, data in ipairs(config) do
    ok, err = validate("fake." .. i, {
      enabled = { data.enabled, "function", true },
      snippets = { data.snippets, "table", true },
      codelenses = { data.codelenses, "function", true },
      codeactions = { data.codeactions, "function", true },
      commands = { data.commands, "table", true },
    })
    if not ok then
      return false, err
    end

    for name, snippet in vim.spairs(data.snippets or {}) do
      ok, err = validate("fake." .. i .. ".snippets." .. name, {
        name = { name, "string" },
        snippet = { snippet, { "string", "function" } },
      })
      if not ok then
        return false, err
      end
    end

    for name, command in vim.spairs(data.commands or {}) do
      ok, err = validate("fake." .. i .. ".command." .. name, {
        name = { name, "string" },
        command = { command, "function" },
      })
      if not ok then
        return false, err
      end
    end
  end

  return true
end

return M
