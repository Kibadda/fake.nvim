local M = {}

--- validate given config
---@param config fake.config
---@return boolean
---@return string[]
function M.validate(config)
  local errors = {}

  --- small wrapper around vim.validate
  ---@param name string
  ---@param value any
  ---@param types any|any[]
  ---@param optional? boolean
  ---@return boolean
  local function validate(name, value, types, optional)
    local ok, err = pcall(vim.validate, name, value, types, optional)

    if not ok then
      table.insert(errors, err)
    end

    return ok
  end

  for i, data in ipairs(config) do
    validate("fake." .. i .. ".enabled", data.enabled, "function", true)
    validate("fake." .. i .. ".filetype", data.filetype, { "string", "table" }, true)
    validate("fake." .. i .. ".filename", data.filename, { "string", "table" }, true)
    validate("fake." .. i .. ".codelenses", data.codelenses, "function", true)
    validate("fake." .. i .. ".codeactions", data.codeactions, "function", true)

    if validate("fake." .. i .. ".snippets", data.snippets, "table", true) and data.snippets then
      for name, snippet in vim.spairs(data.snippets) do
        validate("fake." .. i .. ".snippets." .. tostring(name), name, "string")
        validate("fake." .. i .. ".snippets." .. tostring(name) .. ".snippet", snippet, { "string", "function" })
      end
    end

    if validate("fake." .. i .. ".commands", data.commands, "table", true) and data.commands then
      for name, command in vim.spairs(data.commands) do
        validate("fake." .. i .. ".commands." .. tostring(name), name, "string")
        validate("fake." .. i .. ".commands." .. tostring(name) .. ".command", command, "function")
      end
    end
  end

  return #errors == 0, errors
end

return M
