local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
local beautiful = require "beautiful"
local rubato = require "lib.rubato"
local dpi = beautiful.xresources.apply_dpi

    
    local arrow = wibox.widget.textbox()
    arrow.font = beautiful.font_name.."13"
    arrow.markup = "»"

    local mysystray = wibox.widget.systray()
    mysystray.visible = true
    beautiful.systray_icon_spacing = dpi(4)
    --mysystray.base_size = beautiful.systray_icon_size


    local widget = wibox.widget({
        widget = wibox.container.constraint,
        strategy = "max",
        width = dpi(0),
        {
            widget = wibox.container.margin,
            margins = dpi(2),
            mysystray,
        },
    })
    widget.visible = true

local slide = rubato.timed {
   -- rate = 60,
    duration = 0.9,
    --easing = rubato.easing.linear,
    awestore_compat = true,
    subscribed = function(pos)
        widget.width = pos
    end,
}


local value = true

--slide.ended:subscribe(function()
--    if value then
--       -- widget.visible = false
--    end
--   end)

    arrow.toggle = function()
        if value == false then
            arrow.markup = "»"
            value = true
            slide:set(2)
        else
            arrow.markup = "«"
            slide:set(500)
            --widget.visible = true
            value = false
        end
    end

    --end)

    awesome.connect_signal("arrow::toggle", function()
        arrow.toggle()
    end)
    
arrow:buttons(gears.table.join(
        awful.button({ }, 1, function()
            awesome.emit_signal("arrow::toggle")
        end)
    ))	   
    


    local sys = wibox.widget({
        layout = wibox.layout.fixed.horizontal,
        arrow,
        widget,
        spacing = dpi(2)
    })
return sys
