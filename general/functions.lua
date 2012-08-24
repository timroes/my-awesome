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

local opacity_delta = 0.05

local function change_opacity(c, d)
	local o = c.opacity + d
	o = math.min(math.max(0.05, o), 1)
	c.opacity = o
end

_G.opacity_up = function(c)
	change_opacity(c, opacity_delta)
end

_G.opacity_down = function(c)
	change_opacity(c, -opacity_delta)
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

require("lfs") 
-- {{{ Run programm once
local function processwalker()
   local function yieldprocess()
      for dir in lfs.dir("/proc") do
        -- All directories in /proc containing a number, represent a process
        if tonumber(dir) ~= nil then
          local f, err = io.open("/proc/"..dir.."/cmdline")
          if f then
            local cmdline = f:read("*all")
            f:close()
            if cmdline ~= "" then
              coroutine.yield(cmdline)
            end
          end
        end
      end
    end
    return coroutine.wrap(yieldprocess)
end

_G.run_once = function(process, cmd)
   assert(type(process) == "string")
   local regex_killer = {
      ["+"]  = "%+", ["-"] = "%-",
      ["*"]  = "%*", ["?"]  = "%?" }

   for p in processwalker() do
      if p:find(process:gsub("[-+?*]", regex_killer)) then
	 return
      end
   end
   return awful.util.spawn(cmd or process)
end
-- }}}

