local awful = require "awful"
local gears = require "gears"


local function get_uptime()
	local script = [[
		uptime -p | sed 's/up\s*//g' | sed 's/\s*days/d/g' | sed 's/\s*day/d/g' | sed 's/\s*hours/h/g' | sed 's/\s*hour/h/g' | sed 's/\s*minutes/m/g' | sed 's/\s*minute/m/g'
	]]

	awful.spawn.easy_async_with_shell(script, function(uptime)
		uptime = string.gsub(uptime, "\n", "")
		--uptime = uptime:match("%d+")
		awesome.emit_signal("signal::uptime", uptime)
	end)
end
awesome.connect_signal("widget::update_uptime", function()
	get_uptime()
end)
get_uptime()