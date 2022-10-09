local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
local beautiful = require "beautiful"
local helpers = require "helpers"
local dpi = beautiful.xresources.apply_dpi

-- Menu
--local menu = wibox.widget.textbox()
--menu.font = "FiraCode Nerd Font 16"
--menu.markup = "ﰪ"
local menu = wibox.widget {
	{
	font = beautiful.font_name.."16",
	markup = "ﰪ",
	widget = wibox.widget.textbox(),
	},
	bottom = 2,
	widget = wibox.container.margin,
}

helpers.ui.add_hover_cursor(menu, "hand2")


menu:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awesome.emit_signal("sidebar::toggle")
	end)
))

return menu
