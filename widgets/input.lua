module("widgets.input", package.seeall)

function create(args)

	local inputbox = {}

	args = args or {}

	local text = args.text or ""
	local fg = args.fg or "#000000"
	local bg = args.bg or nil
	local font = args.font or "sans 11"
	local cur_invert = args.bg or "#AAAAAA"

	local onKeyPress = args.onKeyPress or nil
	local onChange = args.onChange or nil
	local onCancel = args.onCancel or nil
	local onEnter = args.onEnter or nil

	inputbox.text = text
	text = text .. "|"

	inputbox.widget = widget({ type = "textbox" })
	inputbox.widget.text = text
	inputbox.widget.font = font
	inputbox.widget.bg = bg
	inputbox.widget.fg = fg

	local cursor = text:len()
	local cur_blink = true
	
	local draw_cursor = function(t)
		local sign
		if cur_blink == true then
			sign = "|"
		else
			sign = "<span color='" .. cur_invert .. "'>|</span>"
		end
		t = t:sub(1, cursor - 1) .. sign .. t:sub(cursor)
		return t
	end

	local draw_text = function(withoutCursor)
		local text
		if withoutCursor then
			text = inputbox.text
		else
			text = draw_cursor(inputbox.text)
		end
		inputbox.widget.text = "<span font='" .. font .. "' color='" .. fg .. "'>" .. text .. "</span>"

	end

	local blink_timer = timer({ timeout = 1 })
	blink_timer:add_signal("timeout", function()
		cur_blink = not cur_blink
		draw_text()
	end)
	blink_timer:start()

	local move_cursor = function(d)
		cursor = cursor + d
		if cursor < 1 then 
			cursor = 1
		elseif cursor > inputbox.text:len() + 1 then
			cursor = inputbox.text:len() + 1
		end
	end

	local editText = function(t)
		local oldText = inputbox.text
		inputbox.text = t
		-- Move cursor
		cursor = cursor + (t:len() - oldText:len())
		-- draw cursor to textbox
		draw_text()
		if onChange then onChange(inputbox.text) end
	end


	keygrabber.run(function(mod, key, event)

		if event ~= "press" then return true end

		if onKeyPress then onKeyPress(mod, key) end

		if key == "Escape" then
			draw_text(true)
			blink_timer:stop()
			if onCancel then onCancel(inputbox) end
			return false
		end

		if key == "Return" or key == "KP_Enter" then
			draw_text(true)
			blink_timer:stop()
			if onEnter then onEnter(inputbox.text) end
			return false
		end

		local t = inputbox.text

		-- Delete character
		if key == "BackSpace" then
			t = t:sub(1,cursor - 2) .. t:sub(cursor) 
			editText(t)
		elseif key == "Delete" then
			t = t:sub(1, cursor - 1) .. t:sub(cursor + 1)
			editText(t)
			move_cursor(1)
			draw_text()
		end

		-- Move cursor
		if key == "Left" then
			move_cursor(-1)
			draw_text()
		end

		if key == "Right" then
			move_cursor(1)
			draw_text()
		end

		if key == "End" then
			move_cursor(99999)
			draw_text()
		end

		if key == "Home" then
			move_cursor(-99999)
			draw_text()
		end

		-- Input character
		if key:len() == 1 then
			local t = inputbox.text
			t = t .. key
			editText(t)
		end

		return true
	
	end)

	return inputbox

end
