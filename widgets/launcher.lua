module("widgets.launcher", package.seeall)

require("widgets.input")

local scr

local function search_window(qry)
-- todo
end

function start_launcher()

	local bg = beautiful.launcher_bg or beautiful.bg_normal or "#FFFFFF"
	local fg = beautiful.launcher_fg or beautiful.fg_normal or "#000000"
	local font = beautiful.launcher_input_font or beautiful.font or "sans 11"

	local w = wibox({ 
		fg = fg,
		bg = bg, 
		border_color = "#FF0000",
		border_width = 5
	})

	local input = widgets.input.create({
		font = font,
		bg = bg,
		fg = fg,
		onChange = search_window,
		onCancel = function(i)
			input = nil
			w.visible = false
		end,
		onEnter = function(i)
			debug("Start something")
			input = nil
			w.visible = false
		end
	})


	x = screen[scr].workarea.x + 400
	y = screen[scr].workarea.y + 50

	w.ontop = true
	w:geometry({ width = 500, height = 50, x = x, y = y })
	w.screen = 1
	w.opacity = 50
	w.widgets = { input, ["layout"] = awful.widget.layout.horizontal.leftright }
	w:geometry({ width = 500, height = 50, x = x, y = y })

end

function register(mod, key, s)

	if s == nil then
		scr = primary_screen
	else
		scr = s
	end

	shortcuts = awful.util.table.join(
		root.keys(),
		awful.key(mod, key, start_launcher)
	)

	root.keys(shortcuts)

end
