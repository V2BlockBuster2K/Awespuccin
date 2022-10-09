local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local helpers = require("helpers")
local playerctl_daemon = require("signals.playerctl")

---- Music Player
---- ~~~~~~~~~~~~

local music_text = wibox.widget({
	font = beautiful.font_name .. "Medium 10",
	valign = "center",
	widget = wibox.widget.textbox,
})

local music_art = wibox.widget({
	image = beautiful.music,
	resize = true,
	widget = wibox.widget.imagebox,
})

local music_art_container = wibox.widget({
	music_art,
	forced_height = dpi(200),
	forced_width = dpi(200),
	widget = wibox.container.background,
})

local filter_color = {
	type = "linear",
	from = { 0, 0 },
	to = { 0, 160 },
	stops = { { 0, beautiful.xcolorS0 .. "cc" }, { 1, beautiful.xcolorS0 } },
}

local music_art_filter = wibox.widget({
	{
		bg = filter_color,
		forced_height = dpi(120),
		forced_width = dpi(120),
		widget = wibox.container.background,
	},
	direction = "east",
	widget = wibox.container.rotate,
})

local music_title = wibox.widget({
	font = beautiful.font_name .. "Regular 13",
	valign = "center",
	widget = wibox.widget.textbox,
})

local music_artist = wibox.widget({
	font = beautiful.font_name .. "Bold 16",
	valign = "center",
	widget = wibox.widget.textbox,
})

--- Volume Control
local function volume_control()
	local volume_bar = wibox.widget({
		max_value = 100,
		value = 100,
		bar_height = dpi(12),
		bar_width = dpi(4),
		shape = helpers.ui.rrect(6),
		bar_shape = helpers.ui.rrect(6),
		color = beautiful.xcolor2,
		background_color = beautiful.xcolorS0,
		border_width = 0,
		widget = wibox.widget.progressbar,
	})

	-- Update bar
	local function set_slider_value(self, volume)
		volume_bar.value = volume * 100
	end

	playerctl_daemon:connect_signal("volume", set_slider_value)

	volume_bar:connect_signal("button::press", function()
		playerctl_daemon:disconnect_signal("volume", set_slider_value)
	end)

	volume_bar:connect_signal("button::release", function()
		playerctl_daemon:connect_signal("volume", set_slider_value)
	end)

	local volume = wibox.widget({
		volume_bar,
		direction = "east",
		widget = wibox.container.rotate,
	})

	volume:buttons(gears.table.join(
		-- Scroll - Increase or decrease volume
		awful.button({}, 4, function()
			awful.spawn.with_shell("playerctl volume 0.05+")
		end),
		awful.button({}, 5, function()
			awful.spawn.with_shell("playerctl volume 0.05-")
		end)
	))

	return volume
end
-- Player's Button
local toggle = wibox.widget.textbox()
toggle.font = beautiful.font_name.."26"

toggle:buttons(gears.table.join(
	awful.button({}, 1, function() playerctl_daemon:play_pause() end)
))

local next = wibox.widget.textbox()
next.font = beautiful.font_name.."26"
next.markup = "怜"

next:buttons(gears.table.join(
	awful.button({}, 1, function() playerctl_daemon:next()  end)
))

local back = wibox.widget.textbox()
back.font = beautiful.font_name.."26"
back.markup = "玲"

back:buttons(gears.table.join(
	awful.button({}, 1, function() playerctl_daemon:previous()  end)
))

local function music()
	return wibox.widget({
		{
			{
				music_art_container,
				music_art_filter,
				layout = wibox.layout.stack,
			},
			{
				{
					{
						music_text,
						helpers.ui.vertical_pad(dpi(15)),
						{

							{
								widget = wibox.container.scroll.horizontal,
								step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
								fps = 60,
								speed = 75,
								music_artist,
							},
							{
								widget = wibox.container.scroll.horizontal,
								step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
								fps = 60,
								speed = 75,
								music_title,
							},
							forced_width = dpi(170),
							layout = wibox.layout.fixed.vertical,
						},
						layout = wibox.layout.fixed.vertical,
					},
					nil,
					{
						{
							back,
							toggle,
							next,
							spacing = dpi(25),
							layout = wibox.layout.fixed.horizontal,
						},
						forced_height = dpi(70),
						top = dpi(10),
						bottom = dpi(10),
						right = dpi(10),
						left = dpi(115),
						widget = wibox.container.margin,
					},
					expand = "none",
					layout = wibox.layout.align.vertical,
				},
				top = dpi(9),
				bottom = dpi(9),
				left = dpi(10),
				right = dpi(10),
				widget = wibox.container.margin,
			},
			layout = wibox.layout.stack,
		},
		forced_width = dpi(350),
		shape = helpers.ui.prrect(8, false, true, true, false),
		bg = beautiful.xcolorS0,
		widget = wibox.container.background,
	})
end

local music_widget = wibox.widget({
	{
		{
			music(),
			{
				volume_control(),
				margins = { top = dpi(0), bottom = dpi(0), left = dpi(10), right = dpi(10) },
				widget = wibox.container.margin,
			},
			layout = wibox.layout.align.horizontal,
		},
		forced_height = dpi(150),
		bg = beautiful.xcolorbase,
		shape = helpers.ui.rrect(8),
		widget = wibox.container.background,
	},
	left = dpi(20),
	right = dpi(10),
	color = "#FF000000",
	widget = wibox.container.margin,
})

--- playerctl
--- -------------
playerctl_daemon:connect_signal("metadata", function(_, title, artist, album_path, __, ___, ____)
	if title == "" then
		title = "Nothing Playing"
	end
	if artist == "" then
		artist = "Nothing Playing"
	end
	if album_path == "" then
		album_path = beautiful.music
	end

	music_art:set_image(gears.surface.load_uncached(album_path))
	music_title:set_markup_silently(helpers.ui.colorize_text(title, beautiful.xcolorT2))
	music_artist:set_markup_silently(helpers.ui.colorize_text(artist, beautiful.xcolor2))
end)

playerctl_daemon:connect_signal("playback_status", function(_, playing, __)
	if playing then
		music_text:set_markup_silently(helpers.ui.colorize_text("Now Playing", beautiful.xcolorO0 )) --"#666c79"
		toggle.markup = helpers.ui.colorize_text("", beautiful.xcolor2 )
	else
		music_text:set_markup_silently(helpers.ui.colorize_text("Music", beautiful.xcolorO0 ))
		toggle.markup = helpers.ui.colorize_text("契", beautiful.xcolor2 )
	end
end)

return music_widget
