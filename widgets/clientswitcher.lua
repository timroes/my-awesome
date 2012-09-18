local root = root
local awful = awful
local client = client
local ipairs = ipairs
local setmetatable = setmetatable
local keygrabber = keygrabber

module("widgets.clientswitcher")

local modk, switchk, oldclient, oldopacity
local lastontop
local lastabove
local lastbelow

-- Restore the state of the currently focused client.
-- This will restore the top, above, below state of the currently
-- focused client to the last saved state. This will be called,
-- before the switcher focuses the next client.
local function restore_state()
	if lastontop ~= nil then
		client.focus.ontop = lastontop
	end
	if lastabove ~= nil then
		client.focus.above = lastabove
	end
	if lastbelow ~= nil then
		client.focus.below = lastbelow
	end
end

-- Switch to the next client. Focus it, place it on top and
-- give it 100% opacity. All other clients will get low opacity.
local function next_client()

	-- All clients
	local clients = awful.client.visible()

	-- Restore ontop state of previous selected client
	restore_state()

	for i,c in ipairs(clients) do
		if c == client.focus then
			-- If we found focused client, focus next client in list.
			client.focus = clients[i % #clients + 1]
			-- Save state of focused client
			lastabove = client.focus.above
			lastbelow = client.focus.below
			lastontop = client.focus.ontop
			-- Overwrite state and set client ontop, to bring
			-- it to front above any other client.
			client.focus.ontop = false
			client.focus.ontop = true
			break
		end
	end

	-- Set opacity for all clients
	for i,c in ipairs(clients) do
		if c == client.focus then
			c.opacity = 1
		else
			c.opacity = 0.2
		end
	end
end

-- Restore opacity of all clients to their state before switching clients.
local function restore_opacity()
	for i,c in ipairs(awful.client.visible()) do
		if oldopacity[c.window] then
			c.opacity = oldopacity[c.window]
		end
	end
end

-- Start a new switching round. This function will be registered by the 
-- register function in the keys of root.
local function start_switching()

	-- Reset all previous saved states
	lastontop = nil
	lastabove = nil
	lastbelow = nil
	oldclient = client.focus
	oldopacity = {}

	-- Save current windows opacities
	for i,c in ipairs(awful.client.visible()) do
		oldopacity[c.window] = c.opacity
	end

	-- Run keygrabber
	keygrabber.run(function(mod, key, event)
		if key == switchk then
			if event == "press" then
				-- If the switch key is pressed switch to next client
				next_client()
			end
		elseif key == "Escape" then
			-- If Escape is pressed, reset focus to client, that had
			-- it, when the switching started
			restore_state()
			client.focus = oldclient
			restore_opacity()
			return false
		else
			-- If the modkey has been released finish switching.
			restore_state()
			-- Raise latest focused client
			client.focus:raise()
			restore_opacity()
			return false
		end

		return true
	end)
	next_client()
end

-- Register the client switcher to a special shortcut. The shortcut
-- is described by two keys. Its modkey and its switching key. As long
-- as you hold down the modkey you can press several times the switching key
-- to switch through all the clients. As soon as you release the modkey, the
-- switching will end. You can anytime press the escape key (while holding modkey)
-- to cancel the switching and go back to the focused client, when switching started.
-- @param modkey The modkey
-- @param switchkey The switching key
function register(_, modkey, switchkey)
	modk = modkey
	switchk = switchkey
	keys = awful.util.table.join(root.keys(), 
		awful.key({ modkey }, switchkey, start_switching)
	)
	root.keys(keys)
end

setmetatable(_M, { __call = register })
