---@class fake.config

---@class fake.internalconfig
local FakeDefaultConfig = {
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
