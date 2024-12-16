local M = {}

---@param data fake.data
---@param buf integer
---@return boolean
function M.is_enabled(data, buf)
  local filetypes = data.filetype or {}
  if type(filetypes) ~= "table" then
    filetypes = { filetypes }
  end
  local filenames = data.filename or {}
  if type(filenames) ~= "table" then
    filenames = { filenames }
  end
  return (not data.enabled or data.enabled(buf))
    and (not data.filetype or vim.tbl_contains(filetypes, vim.bo[buf].filetype))
    and (not data.filename or vim.tbl_contains(filenames, vim.fs.basename(vim.api.nvim_buf_get_name(buf))))
end

return M
