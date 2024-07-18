---@text
--- A simple plugin to remind you to drink water.

local config = require("waterme.config")

---@class waterme
local waterme = {}

local global_config

--- Configure waterme
---   See: ~
---       |waterme.Config|
---
---@param opts waterme.Config|nil
---@eval return require('waterme.config')._format_default()
function waterme.setup(opts)
  global_config = config.setup(opts)

  waterme.schedule_notify(global_config.interval)
end

--- Schedule function for waterme. Schedules a timer to notify the user to drink water.
---@param interval number Interval in seconds to notify the user to drink water
function waterme.schedule_notify(interval)
  local timer = vim.uv.new_timer()
  timer:start(interval * 1000, 0, vim.schedule_wrap(waterme.notify))
end

--- Notify function for waterme. Displays a notification to the user to drink water.
function waterme.notify()
  local hl = vim.api.nvim_get_hl(0, { name = 'WatermeNormal' })
  local prev = vim.api.nvim_get_hl(0, { name = 'NotifyINFOBorder' })

  vim.api.nvim_set_hl(0, 'NotifyINFOBorder', { fg = hl.fg, bg = prev.bg })
  require("notify").notify(global_config.message, "info", { fg = hl.fg, bg = prev.bg })
  vim.api.nvim_set_hl(0, 'NotifyINFOBorder', prev)

  waterme.schedule_notify(global_config.interval)
end

return waterme
