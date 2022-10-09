local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/catppuccin/theme.lua")
local bling = require "lib.bling"
local dpi = beautiful.xresources.apply_dpi



awful.screen.connect_for_each_screen(function(s)
    s.taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        widget_template = {
            {
                {
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                   layout = wibox.layout.fixed.horizontal,
                },
                left  = 4,
                right = 4,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id('text_role')[1].markup = '<b> '..index..' </b>'
                self:connect_signal('mouse::enter', function()
    
                    -- BLING: Only show widget when there are clients in the tag
                    if #c3:clients() > 0 then
                        -- BLING: Update the widget with the new tag
                        awesome.emit_signal("bling::tag_preview::update", c3)
                        -- BLING: Show the widget
                        awesome.emit_signal("bling::tag_preview::visibility", s, true)
                    end
                end)
                self:connect_signal('mouse::leave', function()
    
                    -- BLING: Turn the widget off
                    awesome.emit_signal("bling::tag_preview::visibility", s, false)
    
                    if self.has_backup then self.bg = self.backup end
                end)
            end,
            update_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id('text_role')[1].markup = '<b> '..index..' </b>'
            end,
        },
        buttons = {
            awful.button({ }, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                                            if client.focus then
                                                client.focus:move_to_tag(t)
                                            end
                                        end),
            awful.button({ }, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                                            if client.focus then
                                                client.focus:toggle_tag(t)
                                            end
                                        end),
            awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
        },
   
    }
    
    
    bling.widget.tag_preview.enable {
        show_client_content = true,  -- Whether or not to show the client content
        x = 0,                       -- The x-coord of the popup
        y = 0,                       -- The y-coord of the popup
        scale = 0.2,                 -- The scale of the previews compared to the screen
        honor_padding = true,        -- Honor padding when creating widget size
        honor_workarea = true,       -- Honor work area when creating widget size
        placement_fn = function(c)    -- Place the widget using awful.placement (this overrides x & y)
            awful.placement.top_left(c, {
                margins = {
                    top = 31,
                    left = 0,
                }
            })
        end,
        background_widget = wibox.widget {    -- Set a background image (like a wallpaper) for the widget 
            image = beautiful.wallpaper,
            horizontal_fit_policy = "fit",
            vertical_fit_policy   = "fit",
            widget = wibox.widget.imagebox
        }
    }

end)




