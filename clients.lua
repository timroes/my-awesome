-- This module take care of the clients and focus handling
module(..., package.seeall)

for s = 1, screen.count() do
	awful.tag({ 1 }, s, awful.layout.suit.flaoting)
end

-- Functions to move windows to other screen
local move_client = function(c, d)
	local tmp_mouse = mouse.coords()
	local s = (c.screen + d) % screen.count()
	awful.client.movetoscreen(c, s)
	c:raise()
	-- Restore mouse coordinate
	mouse.coords(tmp_mouse)
end

move_client_right = function(c) 
	move_client(c, 1)
end

move_client_left = function(c)
	move_client(c, -1)
end

-- Set button actions for clicks on clients
client_buttons = awful.util.table.join(
	-- Mouse1: raise and focus window
	awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
	-- Mod + Mouse1: Move window
	awful.button({ modkey }, 1, awful.mouse.client.move)
)

-- Set keyboard shortcuts for clients
client_keys = awful.util.table.join(
	awful.key({ modkey, }, "Up", function (c) c.fullscreen = not c.fullscreen end),
	awful.key({ modkey, }, "Down", function(c) c.minimized = true end),
	awful.key({ modkey, }, "Right", move_client_right),
	awful.key({ modkey, }, "Left", move_client_left)
)

awful.rules.rules = {
	-- All client
	{ 
		rule = { },
		properties = {
			focus = true,
			buttons = client_buttons,
			keys = client_keys
		}
	}
}

client.add_signal("manage", function (c, startup)
	-- Add a titlebar
	 awful.titlebar.add(c, { modkey = modkey })

	if not startup then
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
