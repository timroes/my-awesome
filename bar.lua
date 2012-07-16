module(..., package.seeall)

-- Clock
clock = awful.widget.textclock({ align = "right" }, "%e. %b  %H:%M", 1)

-- Systray
systray = widget({ type = "systray" })


-- Tasklist
tasklist_button = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			client.focus = c
			c:raise()
		end
	end)
)

tasklist = awful.widget.tasklist(function (c) return awful.widget.tasklist.label.allscreen(c,1) end, tasklist_button)

-- Create Taskbar
taskbar = awful.wibox({ position = "bottom", screen = math.floor(screen.count() / 2) })

taskbar.widgets = {
	systray,
	clock,
	tasklist,
	layout = awful.widget.layout.horizontal.rightleft
}
