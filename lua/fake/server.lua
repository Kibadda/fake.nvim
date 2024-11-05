local methods = vim.lsp.protocol.Methods

---@class fake.server
---@field handlers? table<string, fun(method: string, params: lsp.LSPAny): any>
---@field capabilities? table

---@param opts? fake.server
---@return fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
local function create_server(opts)
  opts = opts or {}
  local handlers = opts.handlers or {}

  local capabilities = {}

  for name in pairs(handlers) do
    for _, capability in ipairs(vim.lsp._request_name_to_capability[name] or {}) do
      capabilities[capability] = {}
    end
  end

  return function(dispatchers)
    ---@type vim.lsp.rpc.PublicClient
    ---@diagnostic disable-next-line:missing-fields
    local srv = {}
    local closing = false
    local request_id = 0

    function srv.request(method, params, callback)
      local handler = handlers[method]
      if handler then
        local response, err = handler(method, params)
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

return create_server {
  handlers = {
    [methods.textDocument_completion] = require "fake.handlers.snippets",
  },
}
