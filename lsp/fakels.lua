vim.lsp.config.fakels = {
  name = "fakels",
  cmd = require "fake",
  reuse_client = function()
    return true
  end,
}
