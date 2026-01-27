return {
  name = "fake",
  cmd = require "fake",
  reuse_client = function()
    return true
  end,
}
