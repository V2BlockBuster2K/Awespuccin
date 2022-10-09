local naughty = require("naughty")
local playerctl_daemon = require("signals.playerctl")
local beautiful = require("beautiful")
playerctl_daemon:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	if album_path == "" then -- Sets Image for Notification --
		album_path = beautiful.music
	end

	if new == true then
		naughty.notify({
			app_name = "Music",
			title = title,
			text = artist,
			image = album_path,
		})
	end
end)
