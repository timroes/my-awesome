-- Start joystick for 'Spelunky'
client.add_signal("manage", function(c, startup)
	
	if c.name == "Spelunky" then
		awful.util.spawn("joy2key -config spelunky", false)
	end

end)
