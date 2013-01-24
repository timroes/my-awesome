-- Unload photoshop service manager
client.connect_signal("unmanage", function(c)

	if c.name == "Adobe Photoshop CS5.1" and c.type == "normal" then
		awful.util.spawn_with_shell("kill `ps x | grep ServiceManager | grep Adobe | cut -f1 -d' '`")
	end

end)
