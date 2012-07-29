-- Use this pathes within the script
configpath = os.getenv("HOME") .. "/.config/awesome/"
themepath = configpath .. "theme/"
-- Set your primary monitor (for taskbar, opening windows, etc.)
primary_screen = 1

-- Include user awesome config dir into package path
package.path = package.path .. ";" .. configpath .. "general/?.lua" 
package.path = package.path .. ";" .. configpath .. "widgets/?.lua"

-- Include libs
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Include theme
beautiful.init(themepath .. "theme.lua")

debug = function(txt)
	naughty.notify({ preset = naughty.config.presets.critical,
		title = "Debug Output",
		text = txt,
		position = "top_right"})
end

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- require functions
require("general.functions")

-- Set modifier key for all operations
modkey = "Mod4"

-- Focus and client handling
require("general.clients")

-- Autoclient
require("general.autoclient")

-- Shortcuts and keyboard behavior
require("general.keys")

-- Taskbar
require("general.bar")

-- Tools
require("general.tools")

-- Autostart
require("general.autostart")
