local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local naughty = require "naughty"
local menubar = require "menubar"
local hotkeys_popup = require "awful.hotkeys_popup"
require "awful.hotkeys_popup.keys"
-- Clock

local clock = wibox.widget.textbox()
clock.font = beautiful.font_name.."11"
gears.timer {
	timeout = 60,
	autostart = true,
	call_now = true,
	callback = function()
		clock.markup = os.date(" %H:%M")
	end
}

--local month_calendar = awful.widget.calendar_popup.month()
--month_calendar.position = 
--month_calendar:attach( clock, "tm" )
--clock:connect_signal("button::release",
--function()
--	month_calendar.position = 'tm',
--	month_calendar:toggle() 
--end)

return clock
