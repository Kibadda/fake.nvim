local builtin = {}

function builtin.open_url(args)
  if not args.url then
    return
  end

  vim.ui.open(args.url)
end

local commands = vim.deepcopy(builtin)

for _, data in ipairs(require "fake.config") do
  if data.commands then
    commands = vim.tbl_extend("error", commands, data.commands)
  end
end

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
