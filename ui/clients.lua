-- This module take care of the clients and focus handling

-- Locks to permit applying of border color and width changing
local color_borders_lock = false
local draw_borders_lock = false

local function set_border_refreshing(s)
	color_borders_lock = not s
	draw_borders_lock = not s
end

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

	set_border_refreshing(false)

	-- Save mouse position
	local tmp_mouse = mouse.coords()

	-- Calculate new screen and move client to it
	local s = (c.screen + d) % screen.count()
	awful.client.movetoscreen(c, s)

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
	client.focus = c
	c:raise()

	set_border_refreshing(true)

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

-- Set button actions for clicks on clients
client_buttons = awful.util.table.join(
	-- Mouse1: raise and focus window
	awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
	-- Mod + Left Mouse: Move window
	awful.button({ modkey }, 1, function(c) 
		client.focus = c
		c:raise()
		awful.mouse.client.move(c)
	end),
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
			border_color = beautiful.border_normal,
			focus = true,
			buttons = client_buttons,
			keys = client_keys
		}
	},{
		-- Always show tilda on primary screen
		rule = { class = "Tilda" },
		properties = {
			border_width = 0,
			screen = primary_screen,
			opacity = 0.9
		}
	},{
		rule = { class = "Wine" },
		properties = {
			border_width = 0
		}
	},{
		rule = { class = "RAIL" },
		properties = {
			border_width = 0
		}
	}
}

-- Raise clients on focus
client.connect_signal("focus", function(c) c:raise() end)

-- Apply all rules for a specific property to a client
function apply_rule(c, what)
	local rules = awful.rules.rules
	for i,r in ipairs(rules) do
		if awful.rules.match(c, r.rule) then
			if what == "border_color" then
				c.border_color = r.properties.border_color or c.border_color
			elseif what == "border_width" then
				c.border_width = r.properties.border_width or c.border_width
			end
		end
	end
end

-- Choose the color of the border for a client
-- depending on its focused and ontop state.
function color_borders(c)
	-- Function can only be used once at a time
	if color_borders_lock then return end
	color_borders_lock = true

	-- Apply all border_color from rules
	apply_rule(c, "border_color")

	if c.ontop then
		c.border_color = beautiful.border_top_focus or "#FF0000"
	else
		if c == client.focus then
			c.border_color = beautiful.border_focus
		end
	end

	color_borders_lock = false
end

function draw_borders(c)
	-- Lock function
	if draw_borders_lock then return end
	draw_borders_lock = true


	if c.maximized_horizontal and c.maximized_vertical then
		if c.border_width ~= 0 then
			c.border_width = 0
			-- Need to remaximize it, so it will take the
			-- new border with in respect. Otherwise there
			-- would stay some blank area at the border.
			c.maximized_horizontal = false
			c.maximized_horizontal = true
			c.maximized_vertical = false
			c.maximized_vertical = true
		end
	else
		-- Apply all border_width from rules
		apply_rule(c, "border_width")
	end

	--c:redraw()

	draw_borders_lock = false
end

client.connect_signal("manage", function (c, startup)

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
	c:connect_signal("property::ontop", function() color_borders(c) end)
	c:connect_signal("property::maximized_horizontal", function() draw_borders(c) end)
	c:connect_signal("property::maximized_vertical", function() draw_borders(c) end)
	
	draw_borders(c)
	color_borders(c)
	
	-- Raise window on startup
	c:raise()
end)

client.connect_signal("focus", color_borders)
client.connect_signal("unfocus", color_borders)
