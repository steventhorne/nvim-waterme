---@tag waterme.config
local Config = {}

local default_config = {
  interval = 900,
  message = "Time to drink water!",
}

---@class waterme.Config
---@field interval number Interval in seconds to notify the user to drink water
---@field message string Message to display to the user when it is time to drink water

function Config._format_default()
  local lines = { "Default values:", ">lua" }
  for line in vim.gsplit(vim.inspect(default_config), "\n", true) do
    table.insert(lines, "  " .. line)
  end
  table.insert(lines, "<")
  return lines
end

function Config.setup(opts)
  local opts = vim.tbl_deep_extend("keep", opts or {}, default_config)
  return opts
end

return Config
