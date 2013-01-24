composer = "compton"

-- Stop compositing when wine starts
client.connect_signal("manage", function(c, startup)

	if c.class == "Wine" then
		awful.util.spawn("killall " .. composer)
	end

end)

-- Start compositing when last wine window is closed
client.connect_signal("unmanage", function(c)

	if not c.class or c.class:lower() ~= "wine" then
		return
	end

	local clients = client.get()

	for i,c in ipairs(clients) do
		if c.class:lower() == "wine" then
			return
		end
	end

	run_once(composer)

end)
