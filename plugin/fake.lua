if vim.g.loaded_fake then
  return
end

vim.g.loaded_fake = 1

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("FakeNvim", { clear = true }),
  callback = function(args)
    require("fake").start(args.buf)
  end,
})
