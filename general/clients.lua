-- This module take care of the clients and focus handling
module("general.clients", package.seeall)

-- Yeah, I neither use tiling nor tags in awesome. 
-- Pretty much, what it was made for :)
for s = 1, screen.count() do
	awful.tag({ 1 }, s, awful.layout.suit.floating)
end

-- Functions to move windows to other screen.
-- @param c The client to move to another screen.
-- @param d The direction to move (positive numbers for next 
-- 	screens, negtive for previous).
local move_client = function(c, d)
	-- Save currently focused client and mouse position
	local focus = client.focus
	local tmp_mouse = mouse.coords()

	-- Calculate new screen and move client to it
	local s = (c.screen + d) % screen.count()
	awful.client.movetoscreen(c, s)
	c:raise()

	-- Remaximize it on that screen (to take care of bars on that screen)
	if c.maximized_horizontal then
		local s = c.screen
		c.maximized_horizontal = false
		c.screen = s
		c.maximized_horizontal = true
	end
	if c.maximized_vertical then
		local s = c.screen
		c.maximized_vertical = false
		c.screen = s
		c.maximized_vertical = true
	end

	-- Restore mouse coordinate and focused client
	-- By chance it looses the focused client within this function
	mouse.coords(tmp_mouse)
	client.focus = focus
end

-- Move a client to the next screen.
-- @param c The client to move.
local move_client_right = function(c) 
	move_client(c, 1)
end

-- Move a client to the previous screen.
-- @param c The client to move.
local move_client_left = function(c)
	move_client(c, -1)
end

-- Close a client.
-- @param c Client to close.
local close = function(c)
	c:kill()
end

local opacity_delta = 0.05

local function change_opacity(c, d)
	local o = c.opacity + d
	o = math.min(math.max(0.05, o), 1)
	c.opacity = o
end

local function opacity_up(c)
	change_opacity(c, opacity_delta)
end

local function opacity_down(c)
	change_opacity(c, -opacity_delta)
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
	awful.key({ modkey }, "t", function(c) c.ontop = not c.ontop end),
	-- Change transparency
	awful.key({ modkey }, "KP_Add", opacity_up),
	awful.key({ modkey }, "KP_Subtract", opacity_down)
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
	
	-- Raise window on startup
	c:raise()
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
