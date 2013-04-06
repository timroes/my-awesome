-- Start joystick for 'Binding of Isaac'
client.connect_signal("manage", function(c, startup)

	if c.name == "Isaac" then
		awful.util.spawn("joy2key 0x" .. string.format("%x", c.window) .. " -config isaac", false)
	end

end)
