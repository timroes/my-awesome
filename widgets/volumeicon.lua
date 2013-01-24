local setmetatable = setmetatable
local w = require("wibox")
local math = math
local io = io
local tostring = tostring
local awful = require("awful")
local root = root
local string = {
	format = string.format,
	match = string.match
}

module("widgets.volumeicon")

local widget

local function get_volume()

	local fd = io.popen("amixer -- sget Master")
	if not fd then return end

	local status = fd:read("*all")
	fd:close()

	local mute = string.match(status, "%[(o[^%]]+)%]")
	local m = (mute == "off")
	
	local stat = {
		vol = string.match(status, "%[(%d*)%%%]"),
		mute = m
	}

	return stat

end

local function update()

	local status = get_volume() or { vol = 0, mute = true }
	local format

	if not status.mute then
		format = "[%s%%]"
	else
		format = "[%s<span color='red'>M</span>]"
	end

	widget:set_text(string.format(format, status.vol))

end

local function mute()
	awful.util.spawn("amixer -q sset Master toggle")
	update()
end

local function volume(d)

	if d >= 0 then
		sign = "+"
	else
		sign = "-"
		d = math.abs(d)
	end

	awful.util.spawn("amixer -q sset Master " .. tostring(d) .. sign)
	update()

end

-- Create a volume information widget and enable the media hotkeys
-- for volume control.
local function create(_)
	
	widget = w.widget.textbox()
	update()

	widget:buttons(awful.util.table.join(
		awful.button({ }, 1, mute),
		awful.button({ }, 3, function() awful.util.spawn("xterm alsamixer") end),
		awful.button({ }, 4, function() volume(2) end),
		awful.button({ }, 5, function() volume(-2) end)
	))

	shortcuts = awful.util.table.join(
		root.keys(),
		awful.key({ }, "XF86AudioRaiseVolume", function() volume(5) end),
		awful.key({ }, "XF86AudioLowerVolume", function() volume(-5) end),
		awful.key({ }, "XF86AudioMute", mute)
	)

	root.keys(shortcuts)

	return widget

end

setmetatable(_M, { __call = create })
