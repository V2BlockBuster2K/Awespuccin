local awful = require "awful"

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag({"", "", "", "", "", ""}, s, awful.layout.layouts[1])
end)
