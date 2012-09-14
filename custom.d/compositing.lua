-- Stop compositing when wine starts

composer = "compton"

client.add_signal("manage", function(c, startup)

	if c.class == "Wine" then
		awful.util.spawn("killall " .. composer)
	end

end)

-- Start compositing when last wine window is closed
client.add_signal("unmanage", function(c)

	local clients = client.get()

	for i,c in ipairs(clients) do
		if c.class:lower() == "wine" then
			return
		end
	end

	run_once(composer)

end)
