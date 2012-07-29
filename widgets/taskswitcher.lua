module("widgets.taskswitcher", package.seeall)

local widget = require("widget")
local root = require("root")
local screen = require("screen")
local awful = require("awful")
require("awful.client")
local wibox = require("awful.wibox")
local naughty = require("naughty")
local math = require("math")
local b = require("beautiful")
local image = require("image")

-- Chooses the first of the three
-- given parameters, that is not nil and
-- returns it.
local choose = function(a, b, c)
	if a then
		return a
	elseif b then
		return b
	else
		return c
	end
end

local w
local img

-- This function scaled a given image to the
-- given size. The resulting image will be squared
-- and the source image, scaled down to the squared
-- area.
local scale_image = function(img, size)
	local resized, larger, smaller, spacer
	local fill = "#FF0000"

	if img.width > img.height then
		larger = img.width
		smaller = img.height
		spacer = math.ceil((larger - smaller) / 2)
		-- Square it
		resized = img:crop(0, -spacer, larger, larger)
		-- Fill spacing
		resized:draw_rectangle(0, 0, larger, spacer, true, fill)
		resized:draw_rectangle(0, spacer + smaller, larger, resized.height, true, fill)
		-- Resize
		resized = resized:crop_and_scale(0, 0, larger, larger, size, size, resized)
	else
		larger = img.height
		smaller = img.width
		spacer = math.ceil((larger - smaller) / 2)
		-- Square it
		resized = img:crop(-spacer, 0, larger, larger)
		-- Fill spacing
		resized:draw_rectangle(0, 0, spacer, larger, true, fill)
		resized:draw_rectangle(spacer + smaller, 0, resized.width, larger, true, fill)
		-- Resize
		resized = resized:crop_and_scale(0, 0, larger, larger, size, size, resized)
	end


	return resized
end

-- This will invoke the switcher.
local start_switcher = function()

	local comp = function(cmd, pos, ncomp, shell)
		debug("test")
		return "Test", 2
	end

	awful.prompt.run({ prompt = "Bitte mal machen"}, p.widget, function(c) debug("test: " .. tostring(c)) end, comp)
	keygrabber.stop()
	p.widget.text = "|"
	keygrabber.run(function(mod, key, ev)
		if key == "Escape" then
			return false
		end
		
		if ev ~= "release" or key:len() > 1 then
			return true
		end

		p.widget.text = string.sub(p.widget.text, 0, -2)  .. key .. "|"
		return true
	end)

	--s = awful.widget.launcher({ })
	--w.widgets = { s }
	--local im = client.focus.content
	--if not im then
	--debug(" no preview image ")
	--	return
	--end
	--img.bg = w.bg
	--img.image = scale_image(im, 300)
end

local make_padding = function(wi, padding)
	tmpx = wi.x
	tmpy = wi.y

	inner = wibox()
	inner.bg = wi.bg
	inner.opacity = 0
	inner.border_color = "#FF0000"
	inner.border_width = 1
	inner.height = wi.height - 2*padding
	inner.width = wi.width - 2*padding
	inner.ontop = true

	local tmp_w
	for k,v in ipairs(wi.widgets) do
		tmp_w = awful.util.table.join(
			tmp_w,
			{ v }
		)
	end
	inner.widgets = tmp_w
	wi.widgets = { inner }

	for k,v in ipairs(wi.widgets) do
		debug ( " -- " .. tostring(k) .. ": " .. tostring(v))
	end
	for k,v in ipairs(inner.widgets) do
		debug (tostring(k) .. ": " .. tostring(v))
	end

	wi.x = tmpx
	wi.y = tmpy
	inner.x = tmpx + padding
	inner.y = tmpy + padding

	return wi
end

local create_widget = function()
	w = wibox()
	-- TODO: calculate correct positions
	w.width = 700
	w.height = 350
	w.x = 500
	w.y = 350
	w.ontop = true

	-- Set BG color
	w.bg = choose(b.switcher_bg,b.bg_normal,"#FFFFFF")
	-- Set border color
	w.border_color = choose(b.switcher_border,b.border_normal,"#CCCCCC")

	img = widget({ type = "imagebox" })
	img.width = 400
	img.height = 400
	img.bg = "#FF0000"
		
	p = awful.widget.prompt()

	w.widgets = { p }
	
	--w = make_padding(w, 15)

end

function register(mod, key, s)
	
	if s == nil then
		s = primary_screen
	end

	-- Register for given shortcut
	shortcut = awful.util.table.join(
		root.keys(),
		awful.key(mod, key, start_switcher)
	)
	root.keys(shortcut)

	-- Generate widget
	create_widget()
	
end