-------------------------------
--  "Red" awesome theme  --
--    By dud   --
-------------------------------

-- {{{ Main
theme = {}
theme.wallpaper_cmd = { "awsetbg /home/michal/.config/awesome/themes/red/red-wallpaper.jpg" }
-- }}}

-- {{{ Styles
theme.font      = "Inconsolata 9"

-- {{{ Colors
theme.fg_normal = "#DCDCCC"
theme.fg_focus  = "#FF0000"
theme.fg_urgent = "#CC9393"
theme.bg_normal = "#0D0E0D"
theme.bg_focus  = "#0D0E0D"
theme.bg_urgent = "#3F3F3F"
-- }}}

-- {{{ Borders
theme.border_width  = "1"
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#FF0000"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "15"
theme.menu_width  = "125"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = "/home/michal/.config/awesome/themes/red/taglist/squarefz.png"
theme.taglist_squares_unsel = "/home/michal/.config/awesome/themes/red/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = "/home/michal/.config/awesome/themes/red/awesome-icon.png"
theme.menu_submenu_icon      = "/home/michal/.config/awesome/themes/red/submenu.png"
theme.tasklist_floating_icon = "/home/michal/.config/awesome/themes/red/tasklist/floatingw.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = "/home/michal/.config/awesome/themes/red/layouts/tile.png"
theme.layout_tileleft   = "/home/michal/.config/awesome/themes/red/layouts/tileleft.png"
theme.layout_tilebottom = "/home/michal/.config/awesome/themes/red/layouts/tilebottom.png"
theme.layout_tiletop    = "/home/michal/.config/awesome/themes/red/layouts/tiletop.png"
theme.layout_fairv      = "/home/michal/.config/awesome/themes/red/layouts/fairv.png"
theme.layout_fairh      = "/home/michal/.config/awesome/themes/red/layouts/fairh.png"
theme.layout_spiral     = "/home/michal/.config/awesome/themes/red/layouts/spiral.png"
theme.layout_dwindle    = "/home/michal/.config/awesome/themes/red/layouts/dwindle.png"
theme.layout_max        = "/home/michal/.config/awesome/themes/red/layouts/max.png"
theme.layout_fullscreen = "/home/michal/.config/awesome/themes/red/layouts/fullscreen.png"
theme.layout_magnifier  = "/home/michal/.config/awesome/themes/red/layouts/magnifier.png"
theme.layout_floating   = "/home/michal/.config/awesome/themes/red/layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = "/home/michal/.config/awesome/themes/red/titlebar/close_focus.png"
theme.titlebar_close_button_normal = "/home/michal/.config/awesome/themes/red/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = "/home/michal/.config/awesome/themes/red/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = "/home/michal/.config/awesome/themes/red/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = "/home/michal/.config/awesome/themes/red/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = "/home/michal/.config/awesome/themes/red/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = "/home/michal/.config/awesome/themes/red/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = "/home/michal/.config/awesome/themes/red/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = "/home/michal/.config/awesome/themes/red/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = "/home/michal/.config/awesome/themes/red/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = "/home/michal/.config/awesome/themes/red/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = "/home/michal/.config/awesome/themes/red/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = "/home/michal/.config/awesome/themes/red/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = "/home/michal/.config/awesome/themes/red/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = "/home/michal/.config/awesome/themes/red/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = "/home/michal/.config/awesome/themes/red/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = "/home/michal/.config/awesome/themes/red/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = "/home/michal/.config/awesome/themes/red/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
