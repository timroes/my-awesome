-- This module take care of the clients and focus handling
module("general.clients", package.seeall)

require("general.titlebar")

-- Yeah, I neither use tiling nor tags in awesome. 
-- Pretty much, what it was made for :)
for s = 1, screen.count() do
	awful.tag({ 1 }, s, awful.layout.suit.floating)
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

local move_client_right = function(c) 
	move_client(c, 1)
end

local move_client_left = function(c)
	move_client(c, -1)
end

local close = function(c)
	c:kill()
end


-- Set button actions for clicks on clients
client_buttons = awful.util.table.join(
	-- Mouse1: raise and focus window
	awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
	-- Mod + Left Mouse: Move window
	awful.button({ modkey }, 1, awful.mouse.client.move),
	-- Mod + Middle Mouse: Close client
	awful.button({ modkey }, 2, function(c) c:kill() end),
	-- Mod + Right Mouse: Resize window
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keyboard shortcuts for clients
client_keys = awful.util.table.join(
	awful.key({ modkey, }, "Up", max_client),
	awful.key({ modkey, }, "Down", function(c) c.minimized = true end),
	awful.key({ modkey, }, "Right", move_client_right),
	awful.key({ modkey, }, "Left", move_client_left),
	-- Alt + F4/Mod + Q: Close windows
	awful.key({ modkey }, "q", close),
	awful.key({ "Mod1" }, "F4", close),
	awful.key({ modkey }, "t", function(c) c.ontop = not c.ontop end)
)

awful.rules.rules = {
	-- All client
	{ 
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			focus = true,
			buttons = client_buttons,
			keys = client_keys
		}
	},{
		-- Always show tilda on primary screen
		rule = { class = "Tilda" },
		properties = {
			border_width = 0,
			screen = primary_screen
		}
	}
}


client.add_signal("manage", function (c, startup)

	-- Add a titlebar
	-- general.titlebar.create(c)

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

	-- Register listener for ontop change property
	c:add_signal("property::ontop", function() client_update(c) end)
	c:add_signal("property::maximized_horizontal", function() client_update(c) end)
	c:add_signal("property::maximized_vertical", function() client_update(c) end)

	client_update(c)
end)


-- todo rewrite and split up into 2 methods
function client_update(c)
	if c.ontop then
		c.border_color = beautiful.border_top_focus or "#FF0000"
	else
		if not c.maximized_horizontal or not c.maximized_vertical then
			if c == client.focus then
				c.border_color = beautiful.border_focus
			else
				c.border_color = beautiful.border_normal
			end
		else
			c.border_width = 0
		end
	end	
end


client.add_signal("focus", client_update)
client.add_signal("unfocus", client_update)
