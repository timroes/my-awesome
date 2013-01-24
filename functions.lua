_G.deb = function(obj)
	naughty.notify({ preset = naughty.config.presets.critical,
		title = "Debug Output",
		text = tostring(obj),
		position = "top_right"})
end

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

-- {{{ Change opacity of a client
local opacity_delta = 0.05

local function change_opacity(c, d)
	local o = c.opacity + d
	o = math.min(math.max(0.05, o), 1)
	c.opacity = o
	deb(c.opacity)
end

_G.opacity_up = function(c)
	change_opacity(c, opacity_delta)
end

_G.opacity_down = function(c)
	change_opacity(c, -opacity_delta)
end
-- }}}

_G.hspacer = function(size)
	local w = wibox.widget.textbox()
	w.width = size
	return w
end

_G.vspacer = function(size)
	local w = wibox.widget.imagebox()
	local im = image.argb32(1, size, nil)
	w.image = im
	return w
end

lfs = require("lfs") 

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

