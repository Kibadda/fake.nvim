return {
  ---@type lsp.ServerCapabilities
  capabilities = {
    completionProvider = {},
  },
  ---@type fun(params: lsp.CompletionParams): lsp.CompletionItem[]
  handler = function(params)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
    local previous_word = vim.api
      .nvim_buf_get_text(bufnr, params.position.line, 0, params.position.line, params.position.character, {})[1]
      :match "(%S*)$"
    local config = require "fake.config"

    local result = {}

    for _, data in ipairs(config) do
      if data.snippets and (not data.enabled or data.enabled(bufnr)) then
        for label, snippet in pairs(data.snippets) do
          if vim.startswith(label, previous_word) then
            local text = snippet

            if type(text) ~= "string" then
              text = snippet()
            end

            ---@type lsp.CompletionItem
            local item = {
              label = label,
              kind = vim.lsp.protocol.CompletionItemKind.Snippet,
              insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
              insertText = text,
            }

            table.insert(result, item)
          end
        end
      end
    end

    return result
  end,
}
