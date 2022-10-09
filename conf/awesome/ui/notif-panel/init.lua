local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local naughty = require("naughty")
local rubato = require("lib.rubato")
local dpi = beautiful.xresources.apply_dpi

local notifs_text = wibox.widget {
  font = beautiful.font .. " Bold 20",
  markup = "Notifications",
  halign = "center",
  widget = wibox.widget.textbox,
}

local notifs_clear = wibox.widget {
  markup = "<span foreground='" .. beautiful.xcolor10 .. "'> </span>",
  font = beautiful.font_name .. " Bold 21",
  align = "center",
  valign = "center",
  widget = wibox.widget.textbox,
}

notifs_clear:buttons(gears.table.join(awful.button({}, 1, function()
  _G.notif_center_reset_notifs_container()
end)))
helpers.ui.add_hover_cursor(notifs_clear, "hand2")

local notifs_empty = wibox.widget {
  {
    nil,
    {
      nil,
      {
        markup = "<span foreground='" .. beautiful.xcolorT2 .. "'>Nothing Here!</span>",
	 font = beautiful.font .. " Bold 17",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
      },
      layout = wibox.layout.align.vertical,
    },
    layout = wibox.layout.align.horizontal,
  },
  forced_height = 730,
  widget = wibox.container.background,
  bg = beautiful.xcolorS0,
  shape = helpers.ui.rrect(8),
}

local notifs_container = wibox.widget {
  spacing = 10,
  spacing_widget = {
    {
      shape = helpers.ui.rrect(8),
      widget = wibox.container.background,
    },
    top = 2,
    bottom = 2,
    left = 6,
    right = 6,
    widget = wibox.container.margin,
  },
  forced_width = 320,
  forced_height = 730, --430, --Use it like in notifs_empty else it will look weird
  layout = wibox.layout.fixed.vertical,
}

local remove_notifs_empty = true

notif_center_reset_notifs_container = function()
  notifs_container:reset(notifs_container)
  notifs_container:insert(1, notifs_empty)
  remove_notifs_empty = true
end

notif_center_remove_notif = function(box)
  notifs_container:remove_widgets(box)

  if #notifs_container.children == 0 then
    notifs_container:insert(1, notifs_empty)
    remove_notifs_empty = true
  end
end

local create_notif = function(icon, n, width)
  local time = os.date "%H:%M"
  local box = {}

  box = wibox.widget {
    {
      {
        {
          {
            image = icon,
            resize = true,
           clip_shape = helpers.ui.rrect(8),
            halign = "center",
            valign = "center",
            widget = wibox.widget.imagebox,
          },
          strategy = "exact",
          height = 50,
          width = 50,
          widget = wibox.container.constraint,
        },
        {
          {
            nil,
            {
              {
                {
                  step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                  speed = 50,
                  {
                    markup = n.title,
                    font = beautiful.font .. " Bold 9",
                    align = "left",
                    widget = wibox.widget.textbox,
                  },
                  forced_width = 140,
                  widget = wibox.container.scroll.horizontal,
                },
                nil,
                {
                  markup = "<span foreground='" .. beautiful.xcolorT2 .. "'>" .. time .. "</span>",
                  align = "right",
                  valign = "bottom",
                   font = beautiful.font .. " Bold 10",
                  widget = wibox.widget.textbox,
                },
                expand = "none",
                layout = wibox.layout.align.horizontal,
              },
              {
                markup = n.message,
                align = "left",
                forced_width = 165,
                widget = wibox.widget.textbox,
              },
              spacing = 3,
              layout = wibox.layout.fixed.vertical,
            },
            expand = "none",
            layout = wibox.layout.align.vertical,
          },
          left = 17,
          widget = wibox.container.margin,
        },
        layout = wibox.layout.align.horizontal,
      },
      margins = 15,
      widget = wibox.container.margin,
    },
    forced_height = 85,
    widget = wibox.container.background,
    bg = beautiful.xcolorS0,
    shape = helpers.ui.rrect(8),
  }

  box:buttons(gears.table.join(awful.button({}, 1, function()
    _G.notif_center_remove_notif(box)
  end)))

  return box
end

notifs_container:buttons(gears.table.join(
  awful.button({}, 4, nil, function()
    if #notifs_container.children == 1 then
      return
    end
    notifs_container:insert(1, notifs_container.children[#notifs_container.children])
    notifs_container:remove(#notifs_container.children)
  end),

  awful.button({}, 5, nil, function()
    if #notifs_container.children == 1 then
      return
    end
    notifs_container:insert(#notifs_container.children + 1, notifs_container.children[1])
    notifs_container:remove(1)
  end)
))

notifs_container:insert(1, notifs_empty)

naughty.connect_signal("request::display", function(n)
  if #notifs_container.children == 1 and remove_notifs_empty then
    notifs_container:reset(notifs_container)
    remove_notifs_empty = false
  end

  local appicon = n.icon or n.app_icon
  if not appicon then
    appicon = beautiful.pfp  --notification_icon
  end

  notifs_container:insert(1, create_notif(appicon, n, width))
end)

local notifs = wibox.widget {
  {
    {
      {
      nil,
      notifs_text,
      notifs_clear,
      expand = "none",
      layout = wibox.layout.align.horizontal,
    },
    left = 5,
    right = 5,
    top = 7,
    bottom = 7,
    layout = wibox.container.margin,
  },
  widget = wibox.container.background,
  bg = beautiful.xcolorS0,
  shape = helpers.ui.rrect(8),
},
  notifs_container,
  spacing = 20,
  layout = wibox.layout.fixed.vertical,
}

local actions = wibox.widget {
  {
    {
     -- {
        {
          widget = require "ui.notif-panel.widgets.vol_slider",
        },
        {
          widget = require "ui.notif-panel.widgets.mic_slider",
        },
        layout = wibox.layout.flex.vertical,
        spacing = 1,
     -- },
     -- {
     --   { widget = require "ui.widgets.wifi" },
    --    layout = wibox.layout.flex.horizontal,
    --   spacing = 15,
     -- },
     -- layout = wibox.layout.flex.vertical,
     -- spacing = 30,
    },
    widget = wibox.container.margin,
    top = 20,
    bottom = 20,
    left = 35,
    right = 35,
  },
  forced_height = 120,
  widget = wibox.container.background,
  bg = beautiful.xcolorS0,
  shape = helpers.ui.rrect(8),
}

--local action = awful.popup { -- Replacing it with A wibar
--  widget = {
--    widget = wibox.container.margin,
--    margins = 30,
--    forced_width = 355,
--    forced_height = 690,
--    {
--     layout = wibox.layout.fixed.vertical,
--      notifs,
--      actions,
--    },
--  },
--  placement = function(c)
--    (awful.placement.left)(c, { margins = { bottom = 250, right = 60 } })
--  end,
--  ontop = true,
--  visible = false,
--  bg = beautiful.bg_normal,
--}
-- Sidebar
local action = wibox {
	visible = false,
	ontop = true,
	width = dpi(410),
	height = awful.screen.focused().geometry.height - dpi(100),
	y = dpi(60),
	bg = beautiful.bg_normal,
	border_width = dpi(3),
	border_color = beautiful.xcolorS0,
}

-- Sidebar widget setup
action : setup {
	{
    notifs,
    actions,
		spacing = dpi(20),
		layout = wibox.layout.fixed.vertical,
	},
	margins = { top = dpi(20), bottom = dpi(20), left = dpi(20), right = dpi(20)},
	widget = wibox.container.margin,
}


-- Slide animation
local slide = rubato.timed {
	pos = awful.screen.focused().geometry.x - awful.screen.focused().geometry.width, --dpi (1900),
	rate = 60,
	intro = 0.2,
	duration = 0.4,
	subscribed = function(pos) 
		action.x = awful.screen.focused().geometry.x - pos
	end
}

-- Timer of action's death 
action.timer = gears.timer {
	timeout = 0.5,
	single_shot = true,
	callback = function() 
		action.visible = not action.visible
	end
}
action.shape = function(cr,w,h)	--Rounded Corners
	gears.shape.rounded_rect(cr,w,h,14)
end
-- Toggle function
action.toggle = function()
	if action.visible then 
    --awesome.emit_signal("widget::update_vol") 
		slide.target = awful.screen.focused().geometry.x - awful.screen.focused().geometry.width
		action.timer:start()
	else
    awesome.emit_signal("widget::update_vol")
    awesome.emit_signal("widget::update_mic") 
		slide.target = awful.screen.focused().geometry.x - awful.screen.focused().geometry.width + action.width + dpi(25) --dpi(1465)
		action.visible = not action.visible
	end
end

-- Get signal to execute the function (if that makes sense)
awesome.connect_signal("action::toggle", function()
	action.toggle()
end)

return action


