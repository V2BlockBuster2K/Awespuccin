local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local naughty = require "naughty"
local menubar = require "menubar"
local hotkeys_popup = require "awful.hotkeys_popup"
require "awful.hotkeys_popup.keys"
-- Clock

local date = wibox.widget.textbox()
date.font = beautiful.font_name.."11"
gears.timer {
	timeout = 60,
	autostart = true,
	call_now = true,
	callback = function()
		date.markup = os.date(" %a %b %d")
	end
}


return date
