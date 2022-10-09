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
icon.markup = "<span foreground='"..beautiful.xcolor7.."'></span>"

-- Uptime
local disk = wibox.widget.textbox()
disk.font = beautiful.font_name.."10"
disk.align = 'center'


local function get_val()
	awesome.connect_signal("signal::disk", function(disk_perc)
			disk.markup = tonumber(disk_perc).. "%" 
		end)
	end


get_val()


local full = wibox.widget {
	{
	icon,
	disk,
	spacing = dpi(8),
	layout = wibox.layout.fixed.horizontal,
	},
	left = 1,
    right = 8,
    layout = wibox.container.margin
}


return full

