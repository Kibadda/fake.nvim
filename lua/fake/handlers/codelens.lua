return {
  ---@type lsp.ServerCapabilities
  capabilities = {
    codeLensProvider = {},
  },
  ---@type fun(params: lsp.CodeLensParams): lsp.CodeLens[]
  handler = function(params)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
    local config = require "fake.config"

    local result = {}

    for _, codelenses in ipairs(config.codelenses) do
      if not codelenses.enabled or codelenses.enabled(bufnr) then
        vim.list_extend(result, codelenses.lenses(bufnr))
      end
    end

    return result
  end,
}
