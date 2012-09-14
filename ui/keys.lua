-- In this module all shortcut keys and keyboard behavior is defined

-- Define Shortcuts
shortcuts = awful.util.table.join(
	-- Ctrl + Mod + Delete: restarts awesome
	awful.key({ modkey, "Control" }, "Delete", awesome.restart),
	-- Mod + End: Exit Awesome
	awful.key({ modkey }, "End", awesome.quit),
	awful.key({ modkey }, "e", function() awful.util.spawn("pcmanfm ~") end),

	-- Multimedia keys
	awful.key({ }, "XF86AudioPlay", function() awful.util.spawn("mpc toggle -q") end),
	awful.key({ }, "XF86AudioNext", function() awful.util.spawn("mpc next -q") end),
	awful.key({ }, "XF86AudioPrev", function() awful.util.spawn("mpc prev -q") end),
	awful.key({ modkey }, "XF86AudioPlay", function() 
		local song = awful.util.pread("mpc current"):sub(1,-2)
		if song:len() == 0 then
			song = "- nothing playing -"
		end
		naughty.notify({ text = song, title = "Currently playing:", timeout = 3 })
	end),

	-- Grun launcher
	awful.key({ modkey }, "space", function() awful.util.spawn("/usr/bin/python2 /home/timroes/code/pystart/pystart.py") end)
)

-- Set shortcut keys
root.keys(shortcuts)
