---@class fake.data
---@field enabled? fun(buf: number): boolean
---@field filetype? string|string[]
---@field filename? string|string[]
---@field snippets? table<string, string|fun(): string>
---@field codelenses? fun(buf: number): lsp.CodeLens[]
---@field codeactions? fun(buf: number): lsp.CodeAction[]
---@field commands? table<string, fun(args: lsp.LSPAny)>

---@alias fake.config fake.data[]

---@type fake.config
local FakeDefaultConfig = {}

---@type fake.config | (fun(): fake.config) | nil
vim.g.fake = vim.g.fake

---@type fake.config
local opts = type(vim.g.fake) == "function" and vim.g.fake() or vim.g.fake or {}

---@type fake.config
local FakeConfig = vim.tbl_deep_extend("force", {}, FakeDefaultConfig, opts)

local cwd = vim.uv.cwd()
if vim.fn.filereadable(cwd .. "/.fake.lua") == 1 then
  local contents = vim.secure.read(cwd .. "/.fake.lua")
  if type(contents) == "string" then
    load(contents)()
    local local_opts = type(vim.g.fake_local) == "function" and vim.g.fake_local() or vim.g.fake_local or {}
    FakeConfig = vim.tbl_deep_extend("force", {}, FakeConfig, local_opts)
  end
end

local ok = require("fake.config.check").validate(FakeConfig)
if not ok then
  vim.notify("fake: there are errors in your config. see `:checkhealth fake`", vim.log.levels.ERROR)
end

return FakeConfig
