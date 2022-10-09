local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"

awful.screen.connect_for_each_screen(function(s)
    
    s.tasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.focused,
      --  buttons = {
      --       awful.button({ }, 1, function (c)
      --          c:activate { context = "tasklist", action = "toggle_minimization" }
      --      end),
      --      awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
      --      awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
      --      awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
    }
end)
