-- Add any window name to the list, for which the screensaver should be suspended
local suspendfor = {
	"Mark of the Ninja",
	"Spelunky",
	"Isaac"
}

client.connect_signal("manage", function(c, startup)

	for _,v in pairs(suspendfor) do
		if v == c.name then
			awful.util.spawn("xdg-screensaver suspend 0x" .. string.format("%x", c.window), false) 
			break
		end
	end	

end)
