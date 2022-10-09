local gears = require "gears"
local awful = require "awful"
local beautiful = require "beautiful"
local wibox = require "wibox"
local seperator = wibox.widget.textbox() 

seperator.font = beautiful.font_name.."14"
--seperator.text = "|"
seperator.markup = "<span foreground='"..beautiful.xcolorT2.."'>|</span>"

return seperator
