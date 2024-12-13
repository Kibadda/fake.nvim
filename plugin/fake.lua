if vim.g.loaded_fake then
  return
end

vim.g.loaded_fake = 1

vim.lsp.config.fakels = {
  name = "fakels",
  cmd = require "fake",
  reuse_client = function()
    return true
  end,
}
vim.lsp.enable "fakels"
