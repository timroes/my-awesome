-- In this module all shortcut keys and keyboard behavior is defined
module(..., package.seeall)

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
	awful.key({ "Mod1" }, "Tab", next_client)
)

-- Set shortcut keys
root.keys(shortcuts)
