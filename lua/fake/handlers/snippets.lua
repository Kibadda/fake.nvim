return {
  ---@type lsp.ServerCapabilities
  capabilities = {
    completionProvider = {},
  },
  ---@type fun(_, params: lsp.CompletionParams): lsp.CompletionItem[]
  handler = function(_, params)
    local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
    local previous_word = vim.api
      .nvim_buf_get_text(bufnr, params.position.line, 0, params.position.line, params.position.character, {})[1]
      :match "(%S*)$"
    local filetype = vim.filetype.match { buf = bufnr }
    local config = require "fake.config"

    local result = {}

    ---@param snippets table<string, fake.snippets.snippet>
    local function add(snippets)
      for label, snippet in pairs(snippets or {}) do
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

    add(config.snippets.filetypes[filetype])
    add(config.snippets.global)

    return result
  end,
}
