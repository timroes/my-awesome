module("general.titlebar", package.seeall)

-- Private data
local data = setmetatable({}, { __mode = 'k' })

create = function(c)
	t = wibox({ 
		height = awesome.font_height + 6
	})

	icon = widget({ type = "imagebox" })

	title = widget({ 
		type = "textbox", 
		name = "title" 
	})
	t.widgets = { 
		vspacer(1),
		{
			hspacer(10), 
			icon,
			title, 
			layout = awful.widget.layout.horizontal.leftright 
		},
		vspacer(1),
		layout = awful.widget.layout.vertical.flex
	}
	c.titlebar = t
	t.width = 150
	icon.width = 20
	c.titlebar = round_wibox_top_corners(c.titlebar, { left = 11, right = 11 })

	c:add_signal("property::icon", update)
	c:add_signal("property::name", update)
	c:add_signal("property::sticky", update)
	c:add_signal("property::floating", update)
	c:add_signal("property::ontop", update)
	c:add_signal("property::maximized_vertical", update)
	c:add_signal("property::maximized_horizontal", update)
	update(c)

end

remove = function(c)
	c.titlebar = nil
end

function update(c)

	local t = c.titlebar
	if not t then return end

	t.widgets[2][2].image = c.icon
	t.widgets[2][3].text = awful.util.escape(c.name)

	-- Set fg and bg colors
	if client.focus == c then
		t.bg = beautiful.titlebar_bg_focus or "#FFFFFF"
		t.fg = beautiful.titlebar_fg_focus or "#000000"
	else
		t.bg = beautiful.titlebar_bg_normal or "#000000"
		t.fg = beautiful.titlebar_fg_normal or "#FFFFFF"
	end

end

client.add_signal("focus", update)
client.add_signal("unfocus", update)
