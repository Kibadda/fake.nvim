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
    snippets = { config.snippets, "table" },
    commands = { config.commands, "table" },
  })
  if not ok then
    return false, err
  end

  for i, snippets in ipairs(config.snippets) do
    ok, err = validate("fake.snippets." .. i, {
      enabled = { snippets.enabled, "function", true },
      snippets = { snippets.snippets, "table" },
    })
    if not ok then
      return false, err
    end

    for name, snippet in vim.spairs(snippets.snippets) do
      ok, err = validate("fake.snippets." .. i .. "." .. name, {
        name = { name, "string" },
        snippet = { snippet, { "string", "function" } },
      })
      if not ok then
        return false, err
      end
    end
  end

  for name, command in vim.spairs(config.commands) do
    ok, err = validate("fake.commands." .. name, {
      name = { name, "string" },
      command = { command, "function" },
    })
    if not ok then
      return false, err
    end
  end

  return true
end

return M
