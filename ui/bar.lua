volumeicon = require("widgets.volumeicon")
networkmonitor = require("widgets.networkmonitor")

-- Clock
clock = awful.widget.textclock("%a, %e. %b  %H:%M", 1)

clock_button = awful.util.table.join(
	awful.button({ }, 1, function() awful.util.spawn("chromium -app=https://www.google.com/calendar") end)
)

clock:buttons(clock_button)

-- Systray
systray = wibox.widget.systray()


-- 
tasklist_button = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			client.focus = c
			c:raise()
		end
	end),
	awful.button({ }, 2, function (c)
		c:kill()
	end)
)

tasklist = awful.widget.tasklist(primary_screen, awful.widget.tasklist.filter.allscreen, tasklist_button)

-- Create Taskbar
taskbar = awful.wibox({ position = "bottom", screen = primary_screen})

local right_lay = wibox.layout.fixed.horizontal()
right_lay:add(clock)
right_lay:add(systray)
right_lay:add(volumeicon())
right_lay:add(networkmonitor('wlan0'))

local lay = wibox.layout.align.horizontal()
lay:set_right(right_lay)
lay:set_middle(tasklist)

taskbar:set_widget(lay)
