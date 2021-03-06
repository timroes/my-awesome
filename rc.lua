-- {{{ Include awesome libs
-- Standard awesome library
awful = require("awful")
awful.rules = require("awful.rules")
wibox = require("wibox")
gears = require("gears")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
-- }}}

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
    awesome.connect_signal("debug::error", function (err)
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

-- {{{ Basic configuration
-- Configure pathes
configpath = os.getenv("HOME") .. "/.config/awesome/"
themepath = configpath .. "theme/"
-- Include user awesome config dir into package path
package.path = package.path .. ";" .. configpath .. "widgets/?.lua"
-- Initialize theme
beautiful.init(themepath .. "theme.lua")
-- Set your primary monitor (for taskbar, opening windows, etc.)
primary_screen = 1
-- Set modifier key for all operations
modkey = "Mod4"
-- }}}

-- Clear all shortcuts before including any file
root.keys({ })

-- Include general functions 
dofile(configpath .. 'functions.lua')

-- {{{ Include all ui elements
dofile(configpath .. 'ui/wallpaper.lua')
dofile(configpath .. 'ui/clients.lua')
dofile(configpath .. 'ui/bar.lua')
dofile(configpath .. 'ui/keys.lua')
dofile(configpath .. 'ui/tools.lua')
-- }}}

lfs = require('lfs')
-- {{{ Load custom scripts from custom.d directory
customdir = configpath .. 'custom.d/'
for s in lfs.dir(customdir) do
	local f = lfs.attributes(customdir .. s)
	if s:sub(-4) == ".lua" and f.mode == "file" then
		dofile(customdir .. s)
	end
end
-- }}}

-- {{{ Autostart all executables from start.d directory
startdir = configpath .. 'start.d/'
for s in lfs.dir(startdir) do
	local f = lfs.attributes(startdir .. s)
	-- Exclude README file
	if s ~= "README" and f.mode == "file" then
		run_once(startdir .. s)
	end
end
-- }}}
