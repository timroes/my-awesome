-- In this module all shortcut keys and keyboard behavior is defined
module("general.keys", package.seeall)

-- Function for next window
next_client = function ()
	clients = awful.client.visible()
	for i,c in ipairs(clients) do
		-- If we found focused client, focus next client
		if c == client.focus then
			client.focus = clients[i % #clients + 1]
			client.focus:raise()
			return
		end
	end
end

-- Define Shortcuts
shortcuts = awful.util.table.join(
	-- Ctrl + Mod + Delete: restarts awesome
	awful.key({ modkey, "Control" }, "Delete", awesome.restart),
	-- Alt + Tab: next doch
	awful.key({ "Mod1" }, "Tab", next_client),
	-- Mod + End: Exit Awesome
	awful.key({ modkey }, "End", awesome.quit),
	awful.key({ modkey }, "d", function() debug("Msg") end),

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
	awful.key({ modkey }, "space", function() awful.util.spawn("grun") end)
)

-- Set shortcut keys
root.keys(shortcuts)
