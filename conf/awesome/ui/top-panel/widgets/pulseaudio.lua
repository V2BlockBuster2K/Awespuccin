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
icon.markup = "<span foreground='"..beautiful.xcolor2.."'>墳</span>"

-- Uptime
local pulseaudio = wibox.widget.textbox()
pulseaudio.font = beautiful.font_name.."10"
pulseaudio.align = 'center'


local function get_val()
	awesome.connect_signal("signal::volume", function(vol, muted)
		if muted then pulseaudio.markup = "muted" icon.markup = "<span foreground='"..beautiful.xcolor2.."'>婢</span>" else
			pulseaudio.markup = tonumber(vol).. "%" 
			icon.markup = "<span foreground='"..beautiful.xcolor2.."'>墳</span>"
		end
	end)
end

get_val()

local full = wibox.widget {
	{
		{
	icon,
	pulseaudio,
	spacing = dpi(8),
	layout = wibox.layout.fixed.horizontal,
		},
	left = dpi(5),
    right = 8,
    layout = wibox.container.margin,
	},
	forced_width = 73, --66,
	layout = wibox.layout.fixed.horizontal,
}

full:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awesome.emit_signal("action::toggle")
	end)
))
-- Update Function
local update_volume = function()  -- Sets the Volume Correct
	awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout) 
		pulseaudio.markup = tonumber(stdout:match("%d+")).. "%"
	
	-- Uncomment this if you wan't dynamic Icons --
	--	if tonumber(stdout:match("%d+")) < 10 then
	--		icon.markup = "<span foreground='"..beautiful.xcolor2.."'>奄</span>"
	--	elseif tonumber(stdout:match("%d+")) < 50  then
	--		icon.markup = "<span foreground='"..beautiful.xcolor2.."'>奔</span>"
	--	elseif tonumber(stdout:match("%d+")) < 100 then
	--		icon.markup = "<span foreground='"..beautiful.xcolor2.."'>墳</span>"
	--	else
	--	end
			

	end)
end

update_volume()
awesome.connect_signal("widget::update_vol", function()
	update_volume()
end)
awesome.connect_signal("widget::update_vol_pulse", function()
	update_volume()
end)
helpers.ui.add_hover_cursor(full, "hand2")

return full

