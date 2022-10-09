local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

-- Make Widgets
-----------------

-- Song's Title
local title = wibox.widget.textbox()
title.font = beautiful.font_name.."Medium 16"
title.align = "left"
title.valign = "bottom"

-- Song's Artist
local artist = wibox.widget.textbox()
artist.font = beautiful.font_name.."Regular 16"
artist.align = "left"
artist.valign = "bottom"

-- Song's Length
local length = wibox.widget.textbox()
length.font = beautiful.font_name.."Regular 14"
length.align = "center"
length.valign = "center"

-- Player's Button
local toggle = wibox.widget.textbox()
toggle.font = beautiful.font_name.."26"

toggle:buttons(gears.table.join(
	awful.button({}, 1, function() 
		awful.spawn("mpc toggle", false) 
		if toggle.markup:match("") then
			toggle.markup = "契"
		else
			toggle.markup = ""
		end
	end)
))

local next = wibox.widget.textbox()
next.font = beautiful.font_name.."26"
next.markup = "怜"

next:buttons(gears.table.join(
	awful.button({}, 1, function() awful.spawn("mpc next", false) end)
))

local back = wibox.widget.textbox()
back.font = beautiful.font_name.."26"
back.markup = "玲"

back:buttons(gears.table.join(
	awful.button({}, 1, function() awful.spawn("mpc prev", false) end)
))

-- Get data
awesome.connect_signal("signal::player", function(t, a, l, s)
	if not s:match("playing") then
		toggle.markup = "契"
	else
		toggle.markup = ""
	end

	title.markup = t
	artist.markup = a
	length.markup = l
end)

-- Grouping Widgets
---------------------

local buttons = wibox.widget {
	back,
	toggle,
	next,
	spacing = dpi(11),
	layout = wibox.layout.fixed.horizontal,
}

return wibox.widget {
	{
		nil,
		{
			title,
			artist,
			spacing = dpi(12),
			layout = wibox.layout.fixed.vertical,
		},
		expand = 'none',
		layout = wibox.layout.align.vertical,
	},
	{
		nil,
		nil,
		{
			length,
			{
				nil,
				buttons,
				expand = 'none',
				layout = wibox.layout.align.horizontal,
			},
			spacing = dpi(6),
			layout = wibox.layout.fixed.vertical,
		},
		top = 30,
		bottom = 0,
		layout = wibox.container.margin,
		--layout = wibox.layout.align.vertical,
	},
	layout = wibox.layout.flex.horizontal,
}
