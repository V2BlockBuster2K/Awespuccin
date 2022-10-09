local awful = require "awful"
local gears = require "gears"
local beautiful = require "beautiful"
local bling = require "lib.bling"
local machi = require "lib.layout-machi"


-- Custom Layouts
local mstab = bling.layout.mstab
local centered = bling.layout.centered
local equal = bling.layout.equalarea
local deck = bling.layout.deck

machi.editor.nested_layouts = {
  ["0"] = deck,
  ["1"] = awful.layout.suit.spiral,
  ["2"] = awful.layout.suit.fair,
  ["3"] = awful.layout.suit.fair.horizontal,
}


-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.floating,
  awful.layout.suit.max,
  centered,
  mstab,
  equal,
  machi.default_layout,
   -- awful.layout.suit.floating,
--    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
   -- awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier,
--    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

client.connect_signal("manage", function (c)
        if awesome.startup
          and not c.size_hints.user_position
          and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes. 
            awful.placement.no_offscreen(c)
        end
    end)