---@alias fake.snippets.snippet string|fun(): string

---@class fake.snippets
---@field global table<string, fake.snippets.snippet>
---@field filetypes table<string, fake.snippets.snippet>

---@class fake.config
---@field snippets fake.snippets

---@class fake.internalconfig
local FakeDefaultConfig = {
  snippets = {
    global = {},
    filetypes = {},
  },
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
