local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local helpers = require ("helpers")

--- Volume OSD
--- ~~~~~~~~~~
local icon = wibox.widget({
	{
		id = 'icon2',
		image = beautiful.volume_on,
		resize = true,
		widget = wibox.widget.imagebox,
	},
	forced_height = dpi(150),
	top = dpi(12),
	bottom = dpi(12),
	widget = wibox.container.margin,
})
local icon3 = icon.icon2

local osd_header = wibox.widget({
	text = "Volume",
	font = beautiful.font_name .. "Bold 12",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox,
})

local osd_value = wibox.widget({
	text = "0%",
	font = beautiful.font_name .. "Bold 12",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local slider_osd = wibox.widget({
	nil,
	{
		id = "vol_osd_slider",
		bar_shape = gears.shape.rounded_rect,
		bar_height = dpi(12),
		bar_color = beautiful.xcolorS0,
		bar_active_color = beautiful.xcolor2,
		handle_color = beautiful.xcolor2,
		handle_shape = gears.shape.circle,
		handle_width = dpi(24),
		handle_border_color = "#00000012",
		handle_border_width = dpi(1),
		maximum = 100,
		widget = wibox.widget.slider,
	},
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical,
})

local vol_osd_slider = slider_osd.vol_osd_slider
vol_osd_slider:buttons(gears.table.join(
  awful.button({}, 4, nil, function()
		if vol_osd_slider:get_value() > 100 then
			vol_osd_slider:set_value(100)
			return
		end
		vol_osd_slider:set_value(vol_osd_slider:get_value() + 5)
	end),
	awful.button({}, 5, nil, function()
		if vol_osd_slider:get_value() < 0 then
			vol_osd_slider:set_value(0)
			return
		end
		vol_osd_slider:set_value(vol_osd_slider:get_value() - 5)
	end)
))

helpers.ui.add_hover_cursor(vol_osd_slider, "hand1")

local update_volume = function()  -- Sets the Volume Correct
	awful.spawn.easy_async_with_shell("pamixer --get-volume", function(stdout) 
		vol_osd_slider.value = tonumber(stdout:match("%d+"))
	end)
end
awesome.connect_signal("widget::update_vol", function()
	update_volume()
  end)
  
update_volume()
vol_osd_slider:connect_signal("property::value", function(_, new_value)
	local volume_level = vol_osd_slider:get_value()
	awful.spawn("pamixer --set-volume " .. new_value, false)

	-- Update textbox widget text
	osd_value.text = volume_level .. "%"

	-- Update the volume slider if values here change
	awesome.emit_signal("widget::update_vol_pulse")
	awesome.emit_signal("widget::update_vol_slider", volume_level)
	if awful.screen.focused().show_vol_osd then
		awesome.emit_signal("module::volume_osd:show", true)
	end
end)

vol_osd_slider:connect_signal("button::press", function()
	awful.screen.focused().show_vol_osd = true
end)

vol_osd_slider:connect_signal("mouse::enter", function()
	awful.screen.focused().show_vol_osd = true
end)

-- The emit will come from the volume-slider
awesome.connect_signal("module::volume_osd", function(volume)
	vol_osd_slider:set_value(volume)
end)

local volume_osd_height = dpi(250)
local volume_osd_width = dpi(250)

screen.connect_signal("request::desktop_decoration", function(s)
	local s = s or {}
	s.show_vol_osd = false

	s.volume_osd_overlay = awful.popup({
		type = "notification",
		screen = s,
		shape = helpers.ui.rrect(15),
		height = volume_osd_height,
		width = volume_osd_width,
		maximum_height = volume_osd_height,
		maximum_width = volume_osd_width,
		bg = beautiful.transparent,
		offset = dpi(5),
		border_width = dpi(3),
		border_color = beautiful.xcolorS0,
		ontop = true,
		visible = false,
		preferred_anchors = "middle",
		preferred_positions = { "left", "right", "top", "bottom" },
		widget = {
			{
				{
					layout = wibox.layout.fixed.vertical,
					{
						{
							layout = wibox.layout.align.horizontal,
							expand = "none",
							nil,
							icon,
							nil,
						},
						{
							layout = wibox.layout.fixed.vertical,
							spacing = dpi(5),
							{
								layout = wibox.layout.align.horizontal,
								expand = "none",
								osd_header,
								nil,
								osd_value,
							},
							slider_osd,
						},
						spacing = dpi(10),
						layout = wibox.layout.fixed.vertical,
					},
				},
				left = dpi(24),
				right = dpi(24),
				widget = wibox.container.margin,
			},
			bg = beautiful.xcolorbase,
			widget = wibox.container.background,
		},
	})

	-- Reset timer on mouse hover
	s.volume_osd_overlay:connect_signal("mouse::enter", function()
		awful.screen.focused().show_vol_osd = true
		awesome.emit_signal("module::volume_osd:rerun")
	end)
end)

local hide_osd = gears.timer({
	timeout = 1,
	autostart = true,
	callback = function()
		local focused = awful.screen.focused()
		focused.volume_osd_overlay.visible = false
		focused.show_vol_osd = false
	end,
})

awesome.connect_signal("module::volume_osd:rerun", function()
	if hide_osd.started then
		hide_osd:again()
	else
		hide_osd:start()
	end
end)

local placement_placer = function()
	local focused = awful.screen.focused()
	local volume_osd = focused.volume_osd_overlay
	awful.placement.centered(volume_osd)
end

-- Get Vol
function get_vol()
	script = 'pamixer --get-volume'
	script2 = 'pamixer --get-mute'
	awful.spawn.easy_async_with_shell(script, function(vol)
 	awful.spawn.easy_async_with_shell(script2, function(is_mute)
	 if is_mute:match("true") then muted = true else
		 muted = false
	 end

	 if muted then vol_osd_slider.bar_active_color = beautiful.xcolor10 vol_osd_slider.handle_color = beautiful.xcolor10 icon3.image = beautiful.volume_off else
		 vol_osd_slider.bar_active_color = beautiful.xcolor2 vol_osd_slider.handle_color = beautiful.xcolor2 icon3.image = beautiful.volume_on
	 end
 end)
end)
end

awesome.connect_signal("module::volume_osd:show", function(bool)
	placement_placer()
	awful.screen.focused().volume_osd_overlay.visible = bool
	if bool then
		awesome.emit_signal("module::volume_osd:rerun")
		awesome.emit_signal("module::brightness_osd:show", false)
	else
		if hide_osd.started then
			hide_osd:stop()
		end
	end
end)
local volume = {}
volume.increase = function()
	local script = [[
	pamixer -i 5
	]]

	awful.spawn(script, false)
	get_vol()
end

volume.decrease = function()
	local script = [[
	pamixer -d 5
	]]

	awful.spawn(script, false)
	get_vol()
end

volume.mute = function()
	local script = [[
	pamixer -t
	]]

	awful.spawn(script, false)
	get_vol()
end

return volume

