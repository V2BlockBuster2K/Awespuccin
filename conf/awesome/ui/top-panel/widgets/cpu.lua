local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi
local helpers = require "helpers"
-- Icon
local icon = wibox.widget.textbox()
icon.font = beautiful.font_name.."12.5"
icon.align = 'center'
icon.markup = "<span foreground='"..beautiful.xcolor9.."'></span>"

-- Uptime
local cpu = wibox.widget.textbox()
cpu.font = beautiful.font_name.."10"
cpu.align = 'center'


local function get_val()
	awesome.connect_signal("signal::cpu", function(cpu_perc)
			cpu.markup = tonumber(cpu_perc).. "%"
		end)
	end

get_val()


local full = wibox.widget {
	{
		{
	icon,
	cpu,
	spacing = dpi(8),
	layout = wibox.layout.fixed.horizontal,
		},
		left = 1,
		right = 0,
		layout = wibox.container.margin,
	},
	forced_width = 73, -- Makes it fixed and not Moves Whole Bar 
	layout = wibox.layout.fixed.horizontal,
}


return full

