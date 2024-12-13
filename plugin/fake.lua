if vim.g.loaded_fake then
  return
end

vim.g.loaded_fake = 1

vim.lsp.enable "fakels"
