-- Start joystick for 'Binding of Isaac'
client.connect_signal("manage", function(c, startup)

	if c.name == "Isaac" then
		awful.util.spawn("joy2key -config isaac", false)
	end

end)
