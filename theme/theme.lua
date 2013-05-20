-- The style of the interface

theme = {}

theme.font          = "Roboto Light 11"

theme.bg_normal     = "#333333"
theme.bg_focus      = "#505050"
theme.bg_urgent     = "#33B5E5"
theme.bg_minimize   = "#333333"

theme.fg_normal     = "#BBBBBB"
theme.fg_focus      = "#BBBBBB"
theme.fg_urgent     = "#000000"
theme.fg_minimize   = "#666666"

theme.border_width  = "1"
theme.border_normal = "#333333"
theme.border_focus  = "#33B5E5"
theme.border_marked = "#339933"

-- Taskswitcher theme
theme.switcher_bg	= "#FFFFFF"
theme.switch_border	= "#000000"

-- Launcher
theme.launcher_bg 	= "#FFFFFF"
theme.launcher_fg	= "#000000"
theme.launcher_input_font = "sans 16"

-- Titlebar
theme.titlebar_bg_normal = "#666666"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"o

-- You can use your own command to set your wallpaper
theme.wallpaper =  themepath .. "images/background.jpg" 

return theme
