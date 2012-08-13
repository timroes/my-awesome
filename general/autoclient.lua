module("general.autoclient", package.seeall)

-- Use this function to do something (start other programs, etc.) when clients gets managed.
client.add_signal("manage", function(c, startup)

	-- Start joystick and suspend screensaver for 'Binding of Isaac'
	if c.name == "Isaac" then
		awful.util.spawn("joy2key -config isaac", false)
		awful.util.spawn("xdg-screensaver suspend 0x" .. string.format("%x", c.window), false) 
	end

end)
