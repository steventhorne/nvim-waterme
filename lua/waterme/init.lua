--- *nvim-waterme* Reminder to hydrate yourself
--- *Waterme*
---
--- GPL-3.0 License Copyright (c) 2024 Steven Thorne
---
--- ============================================================================== 
---
--- Features:
--- - Set up in-editor reminders to hydrate yourself.
---
--- # Setup ~
---
--- This plugin doesn't require setup, but optional configuration
--- exists to improve your experience.
--- Setup with `require('nvim-waterme'.setup({})` (replace `{}` with
--- your `config` table).
---
--- See |Waterme.config| for `config` structure and default values.
---

-- Plugin module
local Waterme = {}
-- Helper module
local H = {}

-- Plugin implementation

--- Configure Waterme
---
---@param config table|nil Module config table. See |Waterme.config|.
---
---@usage >lua
---   require("nvim-waterme").setup() -- use default config
---   -- OR
---   require("nvim-waterme").setup({}) -- replace {} with your config table
--- <
function Waterme.setup(config)
  _G.Waterme = Waterme

  config = H.setup_config(config)
  H.apply_config(config)

  Waterme.schedule_notify(Waterme.config.interval)
end

--- Plugin config
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
Waterme.config = {
  -- How often the notification should appear (in seconds)
  interval = 900,
  message = "Time to drink water!",
}
--minidoc_afterlines_end


--- Schedule function for waterme. Schedules a timer to notify the user to drink water.
---@param delay number Delay (in seconds) before notifying the user to drink water
function Waterme.schedule_notify(delay)
  local timer = vim.uv.new_timer()
  timer:start(delay * 1000, 0, vim.schedule_wrap(Waterme.notify))
end

--- Notify function for waterme. Displays a notification to the user to drink water.
function Waterme.notify()
  local success, result = pcall(require, "notify")

  if success then
    local hl = vim.api.nvim_get_hl(0, { name = 'WatermeNormal' })
    local prev = vim.api.nvim_get_hl(0, { name = 'NotifyINFOBorder' })

    vim.api.nvim_set_hl(0, 'NotifyINFOBorder', { fg = hl.fg, bg = prev.bg })
    result.notify(Waterme.config.message, "info", { title = "Waterme" })
    vim.api.nvim_set_hl(0, 'NotifyINFOBorder', prev)
  else
    vim.notify(Waterme.config.message)
  end

  Waterme.schedule_notify(Waterme.config.interval)
end

-- Helper implementation
H.default_config = vim.deepcopy(Waterme.config)

H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("interval", config.interval, "number")
  H.check_type("message", config.message, "string")

  return config
end

H.apply_config = function(config)
  Waterme.config = config
end

H.error = function(msg) error("(Waterme) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

return Waterme
