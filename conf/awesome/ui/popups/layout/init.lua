local awful = require "awful"
local gears = require "gears"
local beautiful = require "beautiful"
local wibox = require "wibox"
local hotkeys_popup = require "awful.hotkeys_popup"

local ll = awful.widget.layoutlist {
    base_layout = wibox.widget {
        spacing         = 5,
        forced_num_cols = 4,
        layout          = wibox.layout.grid.vertical,
    },
    widget_template = {
        {
            {
                id            = 'icon_role',
                forced_height = 1,
                forced_width  = 1,
                widget        = wibox.widget.imagebox,
            },
            margins = 15,
            widget  = wibox.container.margin,
        },
        id              = 'background_role',
        forced_width    = 70,
        forced_height   = 70,
        shape           = gears.shape.rounded_rect,
        widget          = wibox.container.background,
    },
}

local layout_popup = awful.popup {
    widget = wibox.widget {
        ll,
        margins = 4, --border margins (padding)
        widget  = wibox.container.margin,
    },
    border_color = beautiful.border_normal,
    bg = beautiful.bg_normal,
    border_width = beautiful.border_width,
    placement    = awful.placement.centered,
    ontop        = true,
    visible      = false,
    shape        = gears.shape.rounded_rect
}
function gears.table.iterate_value(t, value, step_size, filter, start_at)
    local k = gears.table.hasitem(t, value, true, start_at)
    if not k then
        return
    end

    step_size = step_size or 1
    local new_key = gears.math.cycle(#t, k + step_size)

    if filter and not filter(t[new_key]) then
        for i = 1, #t do
            local k2 = gears.math.cycle(#t, new_key + i)
            if filter(t[k2]) then
                return t[k2], k2
            end
        end
        return
    end

    return t[new_key], new_key
end

-- Timer for Death of PopUp
layout_popup.timer = gears.timer { 
	timeout = 0.8,
	--autostart = true,
	single_shot = true,
	callback = function() 
		layout_popup.visible = false
	end
}

function layout_popup.changed()
	layout_popup.visible = true
	if not layout_popup.visible then layout_popup.timer:start() else
		layout_popup.timer:again()
	end
end
-- Mouse Support -- Disable if not Wanted --
layout_popup:connect_signal("mouse::enter", function() layout_popup.timer:stop() end)
layout_popup:connect_signal("mouse::leave", function() layout_popup.timer:start() end)
-- Make sure you remove the default Mod4+Space and Mod4+Shift+Space
-- keybindings before adding this.

awful.keygrabber {
    start_callback = function() layout_popup.visible = true  end,
    stop_callback  = function() layout_popup.visible = false end,
    export_keybindings = true,
    release_event = 'release',
    stop_key = {'Escape', 'Super_L', 'Super_R'},
    keybindings = {
        {{ modkey          } , ' ' , function()
            --layout_popup.timer:again()
            awful.layout.set(
                gears.table.iterate_value(ll.layouts, ll.current_layout, 1),
                --layout_popup.timer:start()
                layout_popup.changed()
            )

        end},

        {{ modkey, 'Shift' } , ' ' , function()
            --layout_popup.timer:again()
            awful.layout.set(
                gears.table.iterate_value(ll.layouts, ll.current_layout, -1),
                --layout_popup.timer:start()
                layout_popup.changed()
            )

        end},
    }
}

		