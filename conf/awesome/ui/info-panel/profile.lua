local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
local beautiful = require "beautiful"
local helpers = require "helpers"

local dpi = beautiful.xresources.apply_dpi
local user1 = os.getenv('USER')


-- Create Widgets
-------------------

-- Pfp
local pfp = wibox.widget.imagebox()
pfp.image = beautiful.pfp
pfp.clip_shape = gears.shape.circle
pfp.forced_width = dpi(130)
pfp.forced_height = dpi(130)

-- User
local user = wibox.widget.textbox()
user.font = beautiful.font_name.."SemiBold 18"
user.align = 'left'
user.markup = "<span foreground='"..beautiful.fg_normal.."'>"..user1.."</span>"

-- Hostname
local hostname = wibox.widget.textbox()
hostname.font = beautiful.font_name.."Regular 14"
hostname.align = 'left'

awful.spawn.easy_async_with_shell("echo $HOST", function(stdout)
	hostname.markup = "<span foreground='"..beautiful.xcolor1.."'>".."@"..tostring(stdout).."</span>"
end)

-- Battery
local uptimeosd = wibox.widget.textbox()
uptimeosd.font = beautiful.font_name.."12"
uptimeosd.align = "center"


-- Get data 4 widgets!
awesome.connect_signal("signal::uptime", function(uptime)
	uptimeosd.markup = "<span foreground='"..beautiful.fg_normal.."'>".."up "..uptime.."</span>"
end)


-- Spacing horizontally
local space = wibox.widget {
	forced_height = dpi(6),
	layout = wibox.layout.align.horizontal
}
local shutdown = wibox.widget {
	{
		{
	font = beautiful.font_name.."30",
	markup = "<span foreground='"..beautiful.xcolor10.."'>".."".."</span>",
	align = center,
	valign = center,
	widget = wibox.widget.textbox,
		},
	top = dpi(9),
	bottom = dpi(9),
	left = dpi(11),
	right = dpi(11),
	widget = wibox.container.margin,
	},
	bg = beautiful.xcolorS1,
	shape = helpers.ui.rrect(8),
	widget = wibox.container.background,
}

local reboot = wibox.widget {
	{
		{
	font = beautiful.font_name.."30",
	markup = "<span foreground='"..beautiful.xcolor2.."'>".."".."</span>",
	align = center,
	valign = center,
	widget = wibox.widget.textbox,
		},
	top = dpi(9),
	bottom = dpi(9),
	left = dpi(11),
	right = dpi(11),
	widget = wibox.container.margin,
	},
	bg = beautiful.xcolorS1,
	shape = helpers.ui.rrect(8),
	widget = wibox.container.background,
}
shutdown:connect_signal("mouse::enter", function() 
	shutdown.bg = beautiful.xcolorS2
end)

shutdown:connect_signal("mouse::leave", function()
	shutdown.bg = beautiful.xcolorS1
end)

reboot:connect_signal("mouse::enter", function() 
	reboot.bg = beautiful.xcolorS2
end)

reboot:connect_signal("mouse::leave", function()
	reboot.bg = beautiful.xcolorS1
end)

shutdown:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awesome.emit_signal("module::exit_screen:show")
	end)
))

reboot:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awful.spawn.with_shell("loginctl reboot")
	end)
))

-- Grouping widgets
---------------------
local buttons = wibox.widget {
	{
	reboot,
	shutdown,
	spacing = dpi(8),
	layout = wibox.layout.fixed.horizontal,
	},
	top = 10,
	left = 57,
	widget = wibox.container.margin,
}

local name = wibox.widget {
	{
	user,
	hostname,
	spacing = dpi(4),
	layout = wibox.layout.fixed.vertical,
	},
	left = 0,
	widget = wibox.container.margin,
}
local uptimebox = wibox.widget {
	{
		{
	uptimeosd,
	spacing = dpi(2),
	layout = wibox.layout.fixed.vertical,
		},
		top = 3,
		bottom = 3,
		widget = wibox.container.margin,
	},
--	bg = beautiful.xcolorS1,
	bg = beautiful.xcolorS0,
	shape = helpers.ui.rrect(7),
	widget = wibox.container.background,
}



-- The Profile Widget
return wibox.widget {
	{
		{
			pfp,
			uptimebox,
			--battery,
			spacing = dpi(20),
			layout = wibox.layout.fixed.vertical,
		},
		layout = wibox.layout.fixed.vertical,
	},
	{
		{
		name,
		buttons,
		layout = wibox.layout.fixed.vertical,
		},
		top = 30,
		layout = wibox.container.margin,
	},
	spacing = dpi(30),
	layout = wibox.layout.fixed.horizontal,
}
