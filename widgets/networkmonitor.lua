local debug = debug
local io = io
local table = table
local timer = timer
local w = widget
local string = string
local math = math
local setmetatable = setmetatable

module("widgets.networkmonitor")

local function trim(s)
	return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end

local function split(s,re)
	local i1 = 1
	local ls = {}
	local append = table.insert
	if not re then re = '%s+' end
	if re == '' then return {s} end
	while true do
		local i2,i3 = s:find(re,i1)
		if not i2 then
			local last = s:sub(i1)
			if last ~= '' then append(ls,last) end
			if #ls == 1 and ls[1] == '' then
			return {}
		else
			return ls
		end
	end
	append(ls,s:sub(i1,i2-1))
	i1 = i3+1
	end
end

local function get_all_devices()
	local devices = {}
	for line in io.lines('/proc/net/dev') do
		local dev = line:match('^[%s]?[%s]?[%s]?[%s]?([%w]+):')
		if dev then
			devices[dev] = line
		end
	end

	return devices
end

local function round(num, prec)
	local mult = 10^(prec or 0)
	return math.floor(num * mult + 0.5) / mult
end

local last_stats = nil

local function get_device(dev)
	local devs = get_all_devices()
	local fields = split(trim(devs[dev]))
	local down = fields[2]
	local up = fields[10]
	local ret = nil
	if last_stats then
		local ddown = round((down - last_stats.down) / 1024, 1)
		local dup = round((up - last_stats.up) / 1024, 1)

		if ddown >= 0 and dup >= 0 then
			ret = { down = ddown, up = dup }
		end
	end

	last_stats = { up = up, down = down }

	return ret
end

local function create(_, dev)
	
	widget = w({ type = "textbox" })

	device = dev or 'lo'
	local refresh = timer({ timeout = 1 })
	refresh:add_signal('timeout', function(self)
		local dev = get_device(device)
		if dev then
			widget.text = string.format('↓ %05.1f ↑ %05.1f', dev.down, dev.up)
		end
	end)
	refresh:start()
	get_device('wlan0')

	return widget
end

setmetatable(_M, { __call = create })
