local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local user_vars = require "user_variables"
local microphone = user_vars.widget.mic.name

local slider = wibox.widget {
  bar_shape = helpers.ui.rrect(9),
  bar_height = 6,
  bar_color = beautiful.xcolorbase,
  bar_active_color = beautiful.xcolor2,
  handle_shape = gears.shape.circle,
  handle_color = beautiful.xcolor2,
  handle_width = 12,
  value = 75,
  forced_width = dpi(239),
  widget = wibox.widget.slider,
}

local osd_value = wibox.widget {
  text = "0%",
  font = beautiful.font_name.."10",
  widget = wibox.widget.textbox(),
}
local icon = wibox.widget {
markup = helpers.ui.colorize_text("", beautiful.xcolor2),
font = beautiful.font_name.."14",
align = "center",
valign = "center",
widget = wibox.widget.textbox(),
}

local function get_val()
	awesome.connect_signal("signal::mic", function(vol, muted)
		if muted then  icon.markup = "<span foreground='"..beautiful.xcolor2.."'></span>" icon.font = beautiful.font_name.."14" else
			--v_slider.color = beautiful.xcolor2
			icon.markup = "<span foreground='"..beautiful.xcolor2.."'></span>" icon.font = beautiful.font_name.."17"
		end
	end)
end

get_val()

icon:buttons(gears.table.join(
	awful.button({ }, 1, function()
    local script = [[
      pamixer --source ]] ..microphone.. [[ -t
      ]]
    
      awful.spawn(script, false)
      awesome.emit_signal("widget::update_mic")
	end)
))


slider:buttons(gears.table.join(
  awful.button({}, 4, nil, function()
		if slider:get_value() > 100 then
			slider:set_value(100)
			return
		end
		slider:set_value(slider:get_value() + 5)
	end),
	awful.button({}, 5, nil, function()
		if slider:get_value() < 0 then
			slider:set_value(0)
			return
		end
		slider:set_value(slider:get_value() - 5)
	end)
))

helpers.ui.add_hover_cursor(slider, "hand1")
helpers.ui.add_hover_cursor(icon, "hand2")

local mic_slider = wibox.widget {
  {
    {
  layout = wibox.layout.fixed.horizontal,
  icon,
    },
    left = 0,
    right = dpi(14),
    top = 5,
    bottom = 5,
    layout = wibox.container.margin
  },
  slider,
  layout = wibox.layout.fixed.horizontal,
  {
    {
  layout = wibox.layout.fixed.horizontal,
  osd_value,
    },
    left = dpi(3),
    right = 0,
    top = 0,
    bottom = 0,
    layout = wibox.container.margin
  },
 -- layout = wibox.layout.fixed.horizontal,
 -- spacing = 0,
}

local update_microphone = function()  -- Sets the Volume Correct
	awful.spawn.easy_async_with_shell("pamixer --source " ..microphone.. " --get-volume", function(stdout) 
		slider.value = tonumber(stdout:match("%d+"))
	end)
end

awesome.connect_signal("widget::update_mic", function()
  update_microphone()
end)

--slider:connect_signal("property::value", function(_, vol) 
--	awful.spawn("pamixer --set-volume ".. vol, false)
--end)

--awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout)
--	local value = string.gsub(stdout, "^%s*(.-)%s*$", "%1")
--	vol_slider.value = tonumber(value)
--end)

slider:connect_signal("property::value", function(_, new_value)
--	vol_slider.value = new_value
	awful.spawn("pamixer --source " ..microphone.. " --set-volume " .. new_value, false)
  local volume_level = slider:get_value()
  osd_value.text = volume_level .. "%"
end)
return mic_slider
