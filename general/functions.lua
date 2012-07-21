module("general.functions", package.seeall)

_G.max_client = function(c)
	if c.maximized_horizontal == true and c.maximized_vertical == true then
		local s = c.screen
		c.maximized_horizontal = false
		c.maximized_vertical = false
		-- Restore screen, that windows is NOW on, not before maximizing
		c.screen = s
	else
		c.maximized_horizontal = true
		c.maximized_vertical = true
	end
end

_G.round_wibox_top_corners = function(wi, args)

	if not wi then return end

	if not args then return wi end

	if not args.left then args.left = 0 end
	if not args.right then args.right = 0 end

	local l = args.left
	local r = args.right
	local h = wi.height
	local w = wi.width

	local img = image.argb32(w, h, nil)
	img:draw_rectangle(0, 0, w, h,true,"#FFFFFF")
	-- Left corner
	img:draw_circle(l, l, l, l, true,"#000000")
	img:draw_rectangle(l, 0, w - (l + r), h, true, "#000000")
	img:draw_rectangle(0, l, w - r, h - l, true, "#000000")
	-- Left corner
	img:draw_circle(w - r, r, r, r, true, "#000000")
	img:draw_rectangle(l, r, w - l, h - r, true, "#000000")

	wi.shape_clip = img
	wi.shape_bounding = img

	return wi

end

_G.hspacer = function(size)
	local w = widget({ type = "textbox" })
	w.width = size
	return w
end

_G.vspacer = function(size)
	local w = widget({ type = "imagebox" })
	local im = image.argb32(1, size, nil)
	w.image = im
	return w
end
