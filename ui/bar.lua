require("widgets.volumeicon")
require("widgets.networkmonitor")

-- Clock
clock = awful.widget.textclock({ align = "right" }, "%a, %e. %b  %H:%M", 1)

clock_button = awful.util.table.join(
	awful.button({ }, 1, function() awful.util.spawn("chromium -app=https://www.google.com/calendar") end)
)

clock:buttons(clock_button)

-- Systray
systray = widget({ type = "systray" })


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

tasklist = awful.widget.tasklist(function (c) return awful.widget.tasklist.label.allscreen(c,1) end, tasklist_button)

-- Create Taskbar
taskbar = awful.wibox({ position = "bottom", screen = primary_screen})

taskbar.widgets = {
	widgets.networkmonitor('wlan0'),
	widgets.volumeicon(),
	systray,
	clock,
	tasklist,
	layout = awful.widget.layout.horizontal.rightleft
}

