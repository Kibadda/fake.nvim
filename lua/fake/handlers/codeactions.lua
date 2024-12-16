local handler = require "fake.handlers"

return {
  ---@type lsp.ServerCapabilities
  capabilities = {
    codeActionProvider = {},
  },
  ---@type fun(params: lsp.CodeActionParams): lsp.CodeAction[]
  handler = function(params)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
    local config = require "fake.config"

    local result = {}

    for _, data in ipairs(config) do
      if data.codeactions and handler.is_enabled(data, bufnr) then
        vim.list_extend(result, data.codeactions(bufnr))
      end
    end

    return result
  end,
}
