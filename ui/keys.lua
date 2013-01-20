-- In this module all shortcut keys and keyboard behavior is defined

-- Define Shortcuts
shortcuts = awful.util.table.join(
	root.keys(),
	-- Ctrl + Mod + Delete: restarts awesome
	awful.key({ modkey, "Control" }, "Delete", awesome.restart),
	-- Mod + End: Exit Awesome
	awful.key({ modkey }, "End", awesome.quit),
	awful.key({ modkey }, "z", function() awful.util.spawn("pcmanfm ~") end),
	awful.key({ modkey }, "l", function() awful.util.spawn("xscreensaver-command -lock") end),

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
	awful.key({ modkey }, "Delete", function() awful.util.spawn("mpc del 0") end),

	-- Start pystart
	awful.key({ modkey }, "space", function() awful.util.spawn("/usr/bin/python2 /home/timroes/code/pystart/pystart.py") end),

	-- Screenshots
	awful.key({  }, "Print", function() awful.util.spawn("screenshot win") end),
	awful.key({ modkey }, "Print", function() awful.util.spawn("screenshot scr") end)

)

-- Set shortcut keys
root.keys(shortcuts)
