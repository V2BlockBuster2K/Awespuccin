local awful = require "awful"
local gears = require "gears"


local function get_mem()
	local script = [[
	free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -f 1 -d "."
	]]

	awful.spawn.easy_async_with_shell(script, function(mem_perc)
		mem_perc = mem_perc:match("%d+")
		awesome.emit_signal("signal::mem", mem_perc)
	end)
end

gears.timer {
	timeout = 4,
	call_now = true,
	autostart = true,
	callback = function()
		get_mem()
	end
}