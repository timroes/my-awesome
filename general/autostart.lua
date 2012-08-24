module('general.autostart', package.seeall)

require('lfs')

function autostart(dir)
	for s in lfs.dir(dir) do
		local f = lfs.attributes(dir ..s)
		if f.mode == "file" then
			run_once(dir .. s)
		end
	end
end

autostart(configpath .. "autostart/")
