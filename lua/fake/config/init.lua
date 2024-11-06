---@class fake.snippets
---@field enabled? fun(buf: number): boolean
---@field snippets table<string, string|fun(): string>

---@class fake.codelens
---@field enabled? fun(buf: number): boolean
---@field lenses fun(buf: number): lsp.CodeLens[]

---@class fake.config
---@field snippets fake.snippets[]
---@field commands table<string, fun(args: lsp.LSPAny)>
---@field codelenses fake.codelens[]

---@class fake.internalconfig
local FakeDefaultConfig = {
  snippets = {},
  commands = {},
  codelenses = {},
}

---@type fake.config | (fun(): fake.config) | nil
vim.g.fake = vim.g.fake

---@type fake.config
local opts = type(vim.g.fake) == "function" and vim.g.fake() or vim.g.fake or {}

---@type fake.internalconfig
local FakeConfig = vim.tbl_deep_extend("force", {}, FakeDefaultConfig, opts)

local check = require "fake.config.check"
local ok, err = check.validate(FakeConfig)
if not ok then
  vim.notify("fake: " .. err, vim.log.levels.ERROR)
end

return FakeConfig
