local awful = require "awful"
local gears = require "gears"


local function get_cpu()
	local script = [[
	echo $[100-$(vmstat 1 2|tail -1|awk '{print $15}')]
	]]

	awful.spawn.easy_async_with_shell(script, function(cpu_perc)
		cpu_perc = cpu_perc:match("%d+")
		awesome.emit_signal("signal::cpu", cpu_perc)
	end)
end

gears.timer {
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = function()
		get_cpu()
	end
}