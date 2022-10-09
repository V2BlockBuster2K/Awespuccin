---------------------------
-- Default awesome theme --
---------------------------
local gears = require ("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")

local themes_path = gfs.get_configuration_dir() .. "themes/"
local helpers = require ("helpers")

local theme = {}

-- Moche Color Theme from "github.com/catppuccin/catppuccin" --

-- Transparent Color --
theme.transparent = "#00000000"

-- Base -- 
theme.xcolorcrust = "#11111b"
theme.xcolormantle = "#181825"
theme.xcolorbase = "#1E1E2E"


-- Surface --
theme.xcolorS0 = "#313244"
theme.xcolorS1 = "#45475a"
theme.xcolorS2 = "#585b70"

-- Overlay --
theme.xcolorO0 = "#6c7086"
theme.xcolorO1 = "#7f849c"
theme.xcolorO2 = "#585b70"

-- Text --
theme.xcolorT0 = "#a6adc8"
theme.xcolorT1 = "#bac2de"
theme.xcolorT2 = "#cdd6f4"

-- Lavender --
theme.xcolor1 = "#b4befe"
-- Blue --
theme.xcolor2 = "#89b4fa"
-- Sapphire --
theme.xcolor3 = "#74c7ec"
-- Sky --
theme.xcolor4 = "#89dceb"
-- Teal -- 
theme.xcolor5 = "#94e2d5"
-- Green --
theme.xcolor6 = "#a6e3a1"
-- Yellow --
theme.xcolor7 = "#f9e2af"
-- Peach --
theme.xcolor8 = "#fab387"
-- Maroon --
theme.xcolor9 = "#eba0ac"
-- Red --
theme.xcolor10 = "#f38ba8"
-- Mauve --
theme.xcolor11 = "#cba6f7"
-- Pink --
theme.xcolor12 = "#f5c2e7"
-- Flamingo --
theme.xcolor13 = "#f2cdcd"
-- Rosewater --
theme.xcolor14 = "#f5e0dc"

theme.music = themes_path.."catppuccin/assets/music.png"
theme.volume_on = themes_path.."catppuccin/assets/volume-on.png"
theme.volume_off = themes_path.."catppuccin/assets/volume-off.png"
theme.pfp = themes_path.."catppuccin/assets/pfp.jpg"
theme.font          = "FiraCode Nerd Font 10"

theme.font_name = "FiraCode Nerd Font "

theme.titlebar_bg_focus = theme.xcolorbase
theme.titlebar_bg = theme.xcolorbase
theme.bg_normal     = theme.xcolorbase
theme.bg_focus      = theme.xcolorS0
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.xcolorT2 --Text Color
theme.fg_focus      = theme.xcolor5
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(10)
theme.border_width  = dpi(3)
theme.border_normal = theme.xcolorS0
theme.border_focus  = theme.xcolor5
theme.border_marked = "#91231c"

theme.menu_font = "FiraCode Nerd Font 12"
theme.menu_bg_focus = theme.xcolorbase
theme.menu_fg_focus = theme.xcolor2
theme.menu_border_width = dpi(2)
--theme.menu_border_radius = dpi()
theme.menu_border_color = theme.xcolorS0
--theme.menu_submenu_icon = themes_path.."catppuccin/submenu.png"
theme.submenu = "»  "
theme.menu_height = dpi(37)
theme.menu_width  = dpi(194)


theme.tasklist_bg_focus = theme.xcolorbase
theme.tasklist_fg_focus = theme.xcolor1
theme.tasklist_disable_icon = true
theme.tasklist_font = "FiraCode Nerd Font 11"

theme.taglist_spacing = dpi(2)
theme.taglist_bg_focus = theme.xcolorbase
theme.taglist_disable_icon = true
theme.taglist_font = "FiraCode Nerd Font 11"
theme.taglist_fg_focus = theme.xcolor2 --"#7e9dde"
theme.taglist_fg_empty = theme.xcolorS2
theme.taglist_fg_occupied = "#526c96"

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.xcolor2
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.taglist_fg_occupied
)

-- Edge Snap
theme.snap_bg = theme.xcolor5
theme.snap_border_width = dpi(5)
theme.snap_shape = helpers.ui.rrect(0)

-- Hotkey Popup
theme.hotkeys_shape = helpers.ui.rrect(12)
theme.hotkeys_border_color = theme.xcolor5
theme.hotkeys_modifiers_fg = theme.xcolorO2
theme.hotkeys_font = "FiraCode Nerd Font 9"
theme.hotkeys_description_font = "FiraCode Nerd Font 9"

-- Layoutlist 
theme.layoutlist_shape_selected = helpers.ui.rrect(7)

-- Tabs
theme.mstab_bar_height = 1
theme.mstab_dont_resize_slaves = true
theme.mstab_bar_padding = dpi(10)
theme.mstab_border_radius = dpi(6)
theme.mstab_bar_ontop = false
theme.mstab_tabbar_position = "top"
theme.mstab_tabbar_style = "default"
theme.mstab_bar_disable = true
--theme.tabbar_bg_focus = theme.xcolorS0
--theme.tabbar_bg_normal = theme.xcolorS0
--theme.tabbar_radius = dpi(6)

-- Layout Machi
theme.machi_switcher_border_color = theme.xcolorS0
theme.machi_switcher_border_opacity = 0.4
theme.machi_editor_border_color = theme.xcolorS1
theme.machi_editor_border_opacity = 0.4
theme.machi_editor_active_opacity = 0.4

-- Bling
theme.tag_preview_widget_border_radius = dpi(6)
theme.tag_preview_client_border_radius = dpi(6)
theme.tag_preview_client_opacity = 1
theme.tag_preview_client_bg = theme.xcolorbase
theme.tag_preview_client_border_color = theme.xcolorS0
theme.tag_preview_client_border_width = dpi(2)
theme.tag_preview_widget_border_color = theme.xcolor5
theme.tag_preview_widget_border_width = dpi(2)
theme.tag_preview_widget_margin = 4
-- Variables set for theming notifications:
-- notification_font
theme.notification_spacing = dpi(4)
theme.notification_bg = theme.xcolorbase
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."catppuccin/titlebar/unfocus.svg"
theme.titlebar_close_button_focus  = themes_path.."catppuccin/titlebar/close.svg"
theme.titlebar_close_button_normal_hover = themes_path.."catppuccin/titlebar/close_hover.svg"
theme.titlebar_close_button_focus_hover = themes_path.."catppuccin/titlebar/close_hover.svg"

theme.titlebar_minimize_button_normal = themes_path.."catppuccin/titlebar/unfocus.svg"
theme.titlebar_minimize_button_focus  = themes_path.."catppuccin/titlebar/minimize.svg"
theme.titlebar_minimize_button_normal_hover = themes_path.."catppuccin/titlebar/minimize_hover.svg"
theme.titlebar_minimize_button_focus_hover = themes_path.."catppuccin/titlebar/minimize_hover.svg"

theme.titlebar_ontop_button_normal_inactive = themes_path.."catppuccin/titlebar/unfocus.svg"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."catppuccin/titlebar/ontop.svg"

theme.titlebar_ontop_button_normal_active = themes_path.."catppuccin/titlebar/unfocus.svg"
theme.titlebar_ontop_button_focus_active  = themes_path.."catppuccin/titlebar/ontop.svg"

-- theme.titlebar_sticky_button_normal_inactive = themes_path.."catppuccin/titlebar/sticky_normal_inactive.png"
-- theme.titlebar_sticky_button_focus_inactive  = themes_path.."catppuccin/titlebar/sticky_focus_inactive.png"
-- theme.titlebar_sticky_button_normal_active = themes_path.."catppuccin/titlebar/sticky_normal_active.png"
-- theme.titlebar_sticky_button_focus_active  = themes_path.."catppuccin/titlebar/sticky_focus_active.png"

-- theme.titlebar_floating_button_normal_inactive = themes_path.."catppuccin/titlebar/floating_normal_inactive.png"
-- theme.titlebar_floating_button_focus_inactive  = themes_path.."catppuccin/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_active = themes_path.."catppuccin/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_active  = themes_path.."catppuccin/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_active = themes_path.."catppuccin/titlebar/unfocus.svg"
theme.titlebar_maximized_button_focus_active  = themes_path.."catppuccin/titlebar/maximize.svg"
theme.titlebar_maximized_button_normal_active_hover = themes_path.."catppuccin/titlebar/maximize_hover.svg"
theme.titlebar_maximized_button_focus_active_hover = themes_path.."catppuccin/titlebar/maximize_hover.svg"

theme.titlebar_maximized_button_normal_inactive = themes_path.."catppuccin/titlebar/unfocus.svg"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."catppuccin/titlebar/maximize.svg"
theme.titlebar_maximized_button_normal_inactive_hover = themes_path.."catppuccin/titlebar/maximize_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover = themes_path.."catppuccin/titlebar/maximize_hover.svg"

theme.wallpaper = themes_path.."catppuccin/buttons.png"

-- You can use your own layout icons like this:
theme.layout_floating = themes_path.."catppuccin/layouts/floating.png"
theme.layout_max = themes_path.."catppuccin/layouts/max.png"
theme.layout_tile = themes_path.."catppuccin/layouts/tile.png"
theme.layout_dwindle = themes_path.."catppuccin/layouts/dwindle.png"
theme.layout_centered = themes_path.."catppuccin/layouts/centered.png"
theme.layout_mstab = themes_path.."catppuccin/layouts/mstab.png"
theme.layout_equalarea = themes_path.."catppuccin/layouts/equalarea.png"
theme.layout_machi = themes_path.."catppuccin/layouts/machi.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Tela-circle-dark"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
