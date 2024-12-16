# fake.nvim
simple in process language server

Currently provides following features:

- snippets
- commands
- codelenses
- codeactions

## Configuration
To change the default configuration, set `vim.g.fake`.

Default config:
```lua
vim.g.fake = {
  {
    enabled = function() return true end,
    filetype = {},
    filename = {},
    snippets = {},
    commands = {},
    codelenses = {},
    codeactions = {},
  },
}
```
