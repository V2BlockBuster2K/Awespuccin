local awful = require "awful"
local beautiful = require "beautiful"

local launcher = awful.widget.launcher({ image = beautiful.awesome_icon, 
                                     menu = mymainmenu })

return launcher