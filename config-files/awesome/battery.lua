local naughty = require("naughty")
local beautiful = require("beautiful")

function readBatFile(adapter, ...)
  local basepath = "/sys/class/power_supply/"..adapter.."/"
  for i, name in pairs({...}) do
    file = io.open(basepath..name, "r")
    if file then
      local str = file:read()
      file:close()
      return str
    end
  end
end

function batteryInfo(adapter)
  local fh = io.open("/sys/class/power_supply/"..adapter.."/present", "r")
  if fh == nil then
    description = "A/C  "
  else
    local cur = readBatFile(adapter, "charge_now", "energy_now")
    local cap = readBatFile(adapter, "charge_full", "energy_full")
    local sta = readBatFile(adapter, "status")
    description = ""
    battery = (cur / cap)

    if sta:match("Charging") then
    elseif sta:match("Discharging") then
      if tonumber(battery) < 0.15 then
        naughty.notify({ title    = "Battery Warning"
               , text     = "Battery low!".."  "..battery.."  ".."left!"
               , timeout  = 5
               , position = "top_right"
               , fg       = beautiful.fg_focus
               , bg       = beautiful.bg_focus
        })
      end
    else
      -- If we are neither charging nor discharging, assume that we are on A/C
      description = "A/C  "
    end
  end
  return '  [<span color="#FFFF00">'..description..battery..' ⚡</span>]  '
end
