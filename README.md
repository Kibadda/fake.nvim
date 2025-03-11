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

Also supports project specific configuration. For this add a file named `.fake.lua` to the root of your project and set `vim.g.fake_local`.

```lua
vim.g.fake_local = {
  {
    snippets = {},
  },
}
```
