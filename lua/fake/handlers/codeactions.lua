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

    for _, codeactions in ipairs(config.codeactions) do
      if not codeactions.enabled or codeactions.enabled(bufnr) then
        vim.list_extend(result, codeactions.codeactions(bufnr))
      end
    end

    return result
  end,
}
