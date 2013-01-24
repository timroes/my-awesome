local debug = debug
local client = client
local ipairs = ipairs
local table = table
local tostring = tostring

module("widgets.history")

local history = { }

local remove = function(value)
	for i,v in ipairs(history) do
		if v == value then
			table.remove(history, i)
		end
	end
end

local focused = function(c) 
	remove(c)
	table.insert(history, c)
end

local unmanaged = function(c)
	remove(c)
	if #history > 0 then
		client.focus = history[#history]
	end
end

-- Enable a history over all screens instead the normal
-- awesome history, that handles screens separately.
-- To have this working correctly you should NOT include
-- the awful.autofocus module.
function allclients() 
	client.connect_signal('focus', focused)
	client.connect_signal('unmanage', unmanaged)
end
