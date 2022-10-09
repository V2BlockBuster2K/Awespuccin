local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"

local vol_sc = 'pamixer --get-volume'
local mute_sc = 'pamixer --get-mute'

local function get_vol()
	awful.spawn.easy_async_with_shell(vol_sc, function(vol)
		awful.spawn.easy_async_with_shell(mute_sc, function(mute)
			if mute:match("false") then 
				muted = false
			else
				muted = true
			end

			awesome.emit_signal("signal::volume", vol, muted)
		end)
	end)
end
awesome.connect_signal("widget::update_vol", function() -- Needs to be Updated if muted! For Pulseaudio Widget
get_vol()
end)
--gears.timer {
--	timeout = 10,
--	call_now = true,
--	autostart = true,
--	callback = function()
--		get_vol()
--	end
--}
get_vol()


