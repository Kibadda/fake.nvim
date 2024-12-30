if vim.g.loaded_fake then
  return
end

vim.g.loaded_fake = 1

vim.lsp.config.fake = {
  name = "fake",
  cmd = require "fake",
  reuse_client = function()
    return true
  end,
}
vim.lsp.enable "fake"
