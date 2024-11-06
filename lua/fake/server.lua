local methods = vim.lsp.protocol.Methods

---@class fake.server
---@field handlers? table<string, fun(params: lsp.LSPAny): any>
---@field capabilities? table

---@param opts? fake.server
---@return fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
local function server(opts)
  opts = opts or {}
  local handlers = opts.handlers or {}
  local capabilities = opts.capabilities or {}

  return function(dispatchers)
    ---@type vim.lsp.rpc.PublicClient
    ---@diagnostic disable-next-line:missing-fields
    local srv = {}
    local closing = false
    local request_id = 0

    function srv.request(method, params, callback)
      local handler = handlers[method]
      if handler then
        local response, err = handler(params)
        callback(err, response)
      elseif method == methods.initialize then
        callback(nil, {
          capabilities = capabilities,
        })
      elseif method == methods.shutdown then
        callback(nil, nil)
      end

      request_id = request_id + 1

      return true, request_id
    end

    function srv.notify(method, _)
      if method == methods.exit then
        dispatchers.on_exit(0, 15)
      end
      return true
    end

    function srv.is_closing()
      return closing
    end

    function srv.terminate()
      closing = true
    end

    return srv
  end
end

local snippets = require "fake.handlers.snippets"
local commands = require "fake.handlers.commands"

return server {
  capabilities = vim.tbl_deep_extend("error", snippets.capabilities, commands.capabilities),
  handlers = {
    [methods.textDocument_completion] = snippets.handler,
    [methods.workspace_executeCommand] = commands.handler,
  },
}
