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
      if data.codeactions and (not data.enabled or data.enabled(bufnr)) then
        vim.list_extend(result, data.codeactions(bufnr))
      end
    end

    return result
  end,
}
