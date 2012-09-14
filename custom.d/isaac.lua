-- Start joystick and suspend screensaver for 'Binding of Isaac'
client.add_signal("manage", function(c, startup)

	if c.name == "Isaac" then
		awful.util.spawn("joy2key -config isaac", false)
		awful.util.spawn("xdg-screensaver suspend 0x" .. string.format("%x", c.window), false) 
	end

end)
