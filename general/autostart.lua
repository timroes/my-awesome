module('general.autostart', package.seeall)

require('lfs')

function autostart(dir)
	for s in lfs.dir(dir) do
		local f = lfs.attributes(dir ..s)
		if f.mode == "file" then
			awful.util.spawn(dir .. s, false, math.floor(screen.count() / 2))
		end
	end
end

autostart(configpath .. "autostart/")
