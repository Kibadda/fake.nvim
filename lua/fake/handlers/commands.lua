local builtin = {}

function builtin.open_url(args)
  if not args.url then
    return
  end

  vim.ui.open(args.url)
end

local commands = vim.tbl_extend("force", {}, builtin, require("fake.config").commands)

return {
  ---@type lsp.ServerCapabilities
  capabilities = {
    executeCommandProvider = {
      commands = vim.tbl_keys(commands),
    },
  },
  ---@type fun(params: lsp.ExecuteCommandParams)
  handler = function(params)
    if commands[params.command] then
      commands[params.command](params.arguments)
    end
  end,
}
