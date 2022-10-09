local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
local beautiful = require "beautiful"
local helpers = require "helpers"
local dpi = beautiful.xresources.apply_dpi

-- Menu
local menu = wibox.widget.textbox()
menu.font = beautiful.font_name.."16"
menu.markup = "<span foreground='"..beautiful.xcolor10.."'></span>"


menu:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awesome.emit_signal("module::exit_screen:show")
	end)
))

return menu
