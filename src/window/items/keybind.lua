function items:AddKeybind(keybindconfig)
	keybindconfig = keybindconfig or {}
	keybindconfig.Title = keybindconfig.Title or keybindconfig.Name or "Keybind"
	keybindconfig.Callback = keybindconfig.Callback or function() end
	local changedcallback = keybindconfig.ChangedCallback or keybindconfig.OnChanged or function() end

	local configkey = keyfor("Keybind_", keybindconfig)
	local mode = tostring(keybindconfig.Mode or "Press"):lower()
	if mode ~= "toggle" and mode ~= "hold" then
		mode = "press"
	end
	local hubdefault = resolvekey(keybindconfig.Default)


	local keybindfunc = { Value = nil, Mode = mode, State = false, DefaultValue = hubdefault, Listening = false }

	local row = instance.frame(sectionadd)
	row.Name = "Keybind"
	row.BorderSizePixel = 0
	row.LayoutOrder = countitem
	row.Size = UDim2.new(1, 0, 0, 46)
	roundbg(row, design.Radius.Control, theme.Row)

	local title = instance.textlabel(row)
	title.Name = "KeybindTitle"
	title.Font = Enum.Font.GothamMedium
	title.Text = tostring(keybindconfig.Title)
	title.TextSize = 12
	title.TextColor3 = theme.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextYAlignment = Enum.TextYAlignment.Top
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 10, 0, 15)
	title.Size = UDim2.new(1, -100, 0, 13)

	local chip = instance.textbutton(row)
	chip.Name = "KeyChip"
	chip.AnchorPoint = Vector2.new(1, 0.5)
	chip.Position = UDim2.new(1, -12, 0.5, 0)
	chip.Size = UDim2.new(0, 56, 0, 24)
	chip.AutoButtonColor = false
	chip.Font = Enum.Font.GothamBold
	chip.Text = ""
	chip.TextSize = 12
	chip.TextColor3 = theme.Text
	chip.BackgroundColor3 = theme.Field
	chip.BackgroundTransparency = 0
	chip.BorderSizePixel = 0
	instance.uicorner(chip).CornerRadius = UDim.new(0, 5)
	local chipstroke = instance.uistroke(chip)
	chipstroke.Color = Color3.fromRGB(255, 255, 255)
	chipstroke.Thickness = 1
	chipstroke.Transparency = 0.9

	local basey = 46
	local description = contenttext(keybindconfig)
	local ix = elementiconx(keybindconfig)
	iconapi(keybindfunc, elementicon(row, keybindconfig.Icon, description and 15.5 or 21.5))
	title.Position = UDim2.new(0, ix, 0, description and 9 or 15)
	title.Size = UDim2.new(1, -(ix + 90), 0, 13)
	if description then
		title.Position = UDim2.new(0, ix, 0, 9)
		local _, measure = attachcontent(row, description, ix, 26, 96)
		local function relayout()
			basey = math.max(46, 26 + measure() + 10)
			row.Size = UDim2.new(1, 0, 0, basey)
		end
		relayout()
		watchwidth(row, relayout)
	end

	local listengen = 0
	local hovering = false

	local function chipwidth(text)
		local okm, bounds = pcall(function()
			return sv.textservice:GetTextSize(text, 12, Enum.Font.GothamBold, Vector2.new(300, 24))
		end)
		return math.max(46, ((okm and bounds) and math.ceil(bounds.X) or 30) + 22)
	end

	local function render(instant)
		local text, textcolor, strokecolor, stroketrans
		if keybindfunc.Listening then
			text, textcolor, strokecolor, stroketrans = "...", guiconfig.Color, guiconfig.Color, 0
		elseif keybindfunc.Value then
			text, textcolor = keyname(keybindfunc.Value), theme.Text
			strokecolor, stroketrans = Color3.fromRGB(255, 255, 255), 0.9
		else
			text, textcolor = "None", theme.Dim
			strokecolor, stroketrans = Color3.fromRGB(255, 255, 255), 0.9
		end
		chip.Text = text
		local size = UDim2.new(0, chipwidth(text), 0, 24)
		local bg = hovering and theme.InnerHover or theme.Field
		if instant then
			chip.TextColor3 = textcolor
			chip.Size = size
			chip.BackgroundColor3 = bg
			chipstroke.Color = strokecolor
			chipstroke.Transparency = stroketrans
		else
			tw(chip, { TextColor3 = textcolor, Size = size, BackgroundColor3 = bg }, 0.2)
			tw(chipstroke, { Color = strokecolor, Transparency = stroketrans }, 0.2)
		end
	end

	local function setlistening(state)
		if keybindfunc.Listening == state then
			return
		end
		keybindfunc.Listening = state
		listengen = listengen + 1
		render(false)
		if state then
			local gen = listengen
			task.delay(8, function()
				if keybindfunc.Listening and listengen == gen then
					setlistening(false)
				end
			end)
		end
	end

	local function apply(key, instant, save, notify)
		keybindfunc.Value = key
		hotkeys.touch()
		keybindfunc.State = false
		if save then
			config.data[configkey] = key and key.Name or "None"
			autosave.touch()
		end
		render(instant)
		if notify then
			elevate()
			local ok, err = pcall(changedcallback, key)
			if not ok then
				warn("Keybind ChangedCallback error:", err)
			end
		end
	end

	local function fire(...)
		firecallback(keybindconfig.Callback, keybindconfig.Title, ...)
	end

	local function savedpref()
		local saved = config.data[configkey]
		if saved ~= nil then
			return resolvekey(saved)
		end
		return hubdefault
	end

	function keybindfunc:Set(value, instant)
		setlistening(false)
		apply(resolvekey(value), instant, true, true)
	end

	function keybindfunc:LoadValue(value)
		self:Set(value, true)
	end

	function keybindfunc:ResetValue()
		self:Set(hubdefault)
	end

	function keybindfunc:Get()
		return keybindfunc.Value
	end

	function keybindfunc:GetName()
		return keyname(keybindfunc.Value)
	end

	function keybindfunc:GetState()
		return keybindfunc.State
	end

	function keybindfunc:SetMode(newmode)
		newmode = tostring(newmode or ""):lower()
		if newmode == "toggle" or newmode == "hold" or newmode == "press" then
			mode = newmode
			keybindfunc.Mode = newmode
			keybindfunc.State = false
		end
	end

	chip.Activated:Connect(function()
		setlistening(not keybindfunc.Listening)
	end)

	chip.MouseEnter:Connect(function()
		hovering = true
		tw(chip, { BackgroundColor3 = theme.InnerHover }, 0.15)
	end)

	chip.MouseLeave:Connect(function()
		hovering = false
		tw(chip, { BackgroundColor3 = theme.Field }, 0.2)
	end)

	local holding = false

	trackConnection(
		sv.uis.InputBegan:Connect(function(input, processed)
			if not row.Parent then
				return
			end
			if keybindfunc.Listening then
				local picked = nil
				if input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode == Enum.KeyCode.Escape then
						setlistening(false)
						return
					elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
						setlistening(false)
						apply(nil, false, true, true)
						return
					end
					picked = resolvekey(input.KeyCode)
				elseif
					input.UserInputType == Enum.UserInputType.MouseButton2
					or input.UserInputType == Enum.UserInputType.MouseButton3
				then
					picked = input.UserInputType
				end
				if picked then
					setlistening(false)
					apply(picked, false, true, true)
				end
				return
			end
			if processed or not inputmatches(input, keybindfunc.Value) then
				return
			end
			if mode == "toggle" then
				keybindfunc.State = not keybindfunc.State
				fire(keybindfunc.State)
			elseif mode == "hold" then
				holding = true
				fire(true)
			else
				fire(keybindfunc.Value)
			end
		end),
		"keybind.began." .. configkey
	)

	trackConnection(
		sv.uis.InputEnded:Connect(function(input)
			if holding and inputmatches(input, keybindfunc.Value) then
				holding = false
				fire(false)
			end
		end),
		"keybind.ended." .. configkey
	)

	apply(savedpref(), true, true, false)

	countitem = countitem + 1
	yieldbuild()
	config.elements[configkey] = keybindfunc
	local hotkeyid = hotkeys.register(keybindconfig.Title, function()
		return keybindfunc.Value and keyname(keybindfunc.Value), keybindfunc.Mode
	end)
	row.Destroying:Connect(function()
		hotkeys.unregister(hotkeyid)
	end)

	registerSearchItem(keybindconfig.Title, row, "Keybind")
	return keybindfunc
end

items.AddKeyPicker = items.AddKeybind
items.AddBind = items.AddKeybind

