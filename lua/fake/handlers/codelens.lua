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

    for _, data in ipairs(config) do
      if data.codelenses and (not data.enabled or data.enabled(bufnr)) then
        vim.list_extend(result, data.codelenses(bufnr))
      end
    end

    return result
  end,
}
