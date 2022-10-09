local awful = require "awful"
local gears = require "gears"
local beautiful = require "beautiful"
local wibox = require "wibox"

--- Rounded Corners Client Side ---
 -- Use Picom If you Can --
local function shapemanager(c)
   c.shape = function(cr, w, h)
      if not c.fullscreen and not c.maximized then
        gears.shape.rounded_rect(cr, w, h, 15)
    else
       gears.shape.rounded_rect(cr, w, h, 0)
      end
   end
end

--- Places every Floating Client in Middle ---
 -- if enabled lib.savefloats won't work --
--local function floatmanager(c)
--	if c.floating then
--	awful.placement.centered(c)   
--	end
--end

client.connect_signal("property::fullscreen", function(c) shapemanager(c) end)
--client.connect_signal("property::floating", function(c) floatmanager(c) end)
--client.connect_signal("request::geometry", function(c) shapemanager(c) end)
--client.connect_signal("request::activate", function(c) shapemanager(c) end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
			c:activate {context = "titlebar", action = "mouse_move"}
           -- c:emit_signal("request::activate", "titlebar", {raise = true})
           -- awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
			c:activate {context = "titlebar", action = "mouse_resize"}
           -- c:emit_signal("request::activate", "titlebar", {raise = true})
            --awful.mouse.client.resize(c)
        end)
    )

 local titlebar_top =  awful.titlebar(c, {
	size = 30,
	expand = "none",
})
 local left = {
	buttons = buttons,
	--awful.titlebar.widget.ontopbutton(c),
	layout  = wibox.layout.fixed.horizontal()
}
 local middle = {
	buttons = buttons,
    layout  = wibox.layout.fixed.horizontal()
}
 local right = {
	awful.titlebar.widget.maximizedbutton(c),
	awful.titlebar.widget.minimizebutton(c),
	awful.titlebar.widget.closebutton(c),
	spacing = 11.5,
	layout = wibox.layout.fixed.horizontal()
}

 titlebar_top : setup {
	{
		left,
		middle,
		right,
	    layout = wibox.layout.align.horizontal()
        },
	left = 13.5,
	right = 13.5,
	top = 7.4,
	bottom = 7.4,
       -- layout = wibox.layout.align.horizontal
       	layout = wibox.container.margin
    }
end)
