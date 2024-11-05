# fake.nvim
simple in process language server

Currently provides following features:

- snippets

## Configuration
To change the default configuration, set `vim.g.fake`.

Default config:
```lua
vim.g.fake = {
  snippets = {
    global = {},
    filetypes = {},
  },
}
```
