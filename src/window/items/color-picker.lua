function items:AddColorPicker(colorconfig)
	colorconfig = colorconfig or {}
	colorconfig.Title = colorconfig.Title or colorconfig.Name or "Color"
	colorconfig.Callback = colorconfig.Callback or function() end

	local configkey = keyfor("Color_", colorconfig)

	local function parsecolor(value)
		if typeof(value) == "Color3" then
			return value
		end
		if type(value) == "string" then
			local hex = value:gsub("^#", "")
			if #hex == 3 then
				hex = hex:gsub(".", "%0%0")
			end
			if #hex == 6 and hex:match("^%x+$") then
				return Color3.fromRGB(
					tonumber(hex:sub(1, 2), 16),
					tonumber(hex:sub(3, 4), 16),
					tonumber(hex:sub(5, 6), 16)
				)
			end
		end
		return nil
	end

	local function tohex(color)
		return string.format(
			"%02X%02X%02X",
			math.floor(color.R * 255 + 0.5),
			math.floor(color.G * 255 + 0.5),
			math.floor(color.B * 255 + 0.5)
		)
	end

	local hubdefault = parsecolor(colorconfig.Default) or Color3.fromRGB(255, 255, 255)
	local hue, sat, val = hubdefault:ToHSV()
	local colorfunc = { Value = hubdefault, DefaultValue = hubdefault, Opened = false }

	local PANEL_HEIGHT = 148
	local basey = 46

	local row = instance.frame(sectionadd)
	row.Name = "ColorPicker"
	row.BorderSizePixel = 0
	row.ClipsDescendants = true
	row.LayoutOrder = countitem
	row.Size = UDim2.new(1, 0, 0, basey)
	roundbg(row, 4, theme.Row)

	local title = instance.textlabel(row)
	title.Name = "ColorTitle"
	title.Font = Enum.Font.GothamBold
	title.Text = tostring(colorconfig.Title)
	title.TextSize = 13
	title.TextColor3 = theme.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextYAlignment = Enum.TextYAlignment.Top
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 10, 0, 15)
	title.Size = UDim2.new(1, -80, 0, 13)

	local swatch = instance.textbutton(row)
	swatch.Name = "Swatch"
	swatch.AnchorPoint = Vector2.new(1, 0.5)
	swatch.Position = UDim2.new(1, -12, 0, basey / 2)
	swatch.Size = UDim2.new(0, 26, 0, 26)
	swatch.AutoButtonColor = false
	swatch.Text = ""
	swatch.BorderSizePixel = 0
	swatch.BackgroundColor3 = hubdefault
	instance.uicorner(swatch).CornerRadius = UDim.new(1, 0)
	local swatchstroke = instance.uistroke(swatch)
	swatchstroke.Color = Color3.fromRGB(255, 255, 255)
	swatchstroke.Thickness = 1
	swatchstroke.Transparency = 0.8

	local panel = instance.frame(row)
	panel.Name = "Panel"
	panel.BackgroundTransparency = 1
	panel.BorderSizePixel = 0
	panel.Position = UDim2.new(0, 0, 0, basey)
	panel.Size = UDim2.new(1, 0, 0, PANEL_HEIGHT)
	panel.Visible = false

	local svbox = instance.frame(panel)
	svbox.Name = "SV"
	svbox.BorderSizePixel = 0
	svbox.Position = UDim2.new(0, 10, 0, 4)
	svbox.Size = UDim2.new(1, -58, 0, 100)
	svbox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
	instance.uicorner(svbox).CornerRadius = UDim.new(0, 4)

	local whiteoverlay = instance.frame(svbox)
	whiteoverlay.BorderSizePixel = 0
	whiteoverlay.Size = UDim2.new(1, 0, 1, 0)
	whiteoverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	instance.uicorner(whiteoverlay).CornerRadius = UDim.new(0, 4)
	local whitegradient = instance.uigradient(whiteoverlay)
	whitegradient.Transparency =
		NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })

	local blackoverlay = instance.frame(svbox)
	blackoverlay.BorderSizePixel = 0
	blackoverlay.Size = UDim2.new(1, 0, 1, 0)
	blackoverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	instance.uicorner(blackoverlay).CornerRadius = UDim.new(0, 4)
	local blackgradient = instance.uigradient(blackoverlay)
	blackgradient.Rotation = 90
	blackgradient.Transparency =
		NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })

	local svhit = instance.textbutton(svbox)
	svhit.Name = "Hit"
	svhit.BackgroundTransparency = 1
	svhit.Text = ""
	svhit.Size = UDim2.new(1, 0, 1, 0)

	local svcursor = instance.frame(svbox)
	svcursor.Name = "Cursor"
	svcursor.AnchorPoint = Vector2.new(0.5, 0.5)
	svcursor.Size = UDim2.new(0, 10, 0, 10)
	svcursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	svcursor.BorderSizePixel = 0
	instance.uicorner(svcursor).CornerRadius = UDim.new(1, 0)
	local svcursorstroke = instance.uistroke(svcursor)
	svcursorstroke.Color = Color3.fromRGB(0, 0, 0)
	svcursorstroke.Thickness = 1.5

	local huebar = instance.frame(panel)
	huebar.Name = "Hue"
	huebar.BorderSizePixel = 0
	huebar.Position = UDim2.new(1, -38, 0, 4)
	huebar.Size = UDim2.new(0, 18, 0, 100)
	huebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	instance.uicorner(huebar).CornerRadius = UDim.new(0, 4)
	local huegradient = instance.uigradient(huebar)
	huegradient.Rotation = 90
	huegradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
	})

	local huehit = instance.textbutton(huebar)
	huehit.Name = "Hit"
	huehit.BackgroundTransparency = 1
	huehit.Text = ""
	huehit.Size = UDim2.new(1, 0, 1, 0)

	local huecursor = instance.frame(huebar)
	huecursor.Name = "Cursor"
	huecursor.AnchorPoint = Vector2.new(0.5, 0.5)
	huecursor.Size = UDim2.new(1, 4, 0, 4)
	huecursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	huecursor.BorderSizePixel = 0
	instance.uicorner(huecursor).CornerRadius = UDim.new(0, 2)
	local huecursorstroke = instance.uistroke(huecursor)
	huecursorstroke.Color = Color3.fromRGB(0, 0, 0)
	huecursorstroke.Thickness = 1

	local hexbox = instance.textbox(panel)
	hexbox.Name = "Hex"
	hexbox.Position = UDim2.new(0, 10, 0, 112)
	hexbox.Size = UDim2.new(0, 96, 0, 26)
	hexbox.BackgroundColor3 = theme.Field
	hexbox.BorderSizePixel = 0
	hexbox.ClearTextOnFocus = false
	hexbox.Font = Enum.Font.GothamBold
	hexbox.PlaceholderText = "#RRGGBB"
	hexbox.TextColor3 = theme.Text
	hexbox.TextSize = 12
	hexbox.Text = "#" .. tohex(hubdefault)
	instance.uicorner(hexbox).CornerRadius = UDim.new(0, 5)

	local description = contenttext(colorconfig)
	local ix = elementiconx(colorconfig)
	iconapi(colorfunc, elementicon(row, colorconfig.Icon, description and 15.5 or 21.5))
	title.Position = UDim2.new(0, ix, 0, description and 9 or 15)
	title.Size = UDim2.new(1, -(ix + 70), 0, 13)
	local function currentheight()
		return colorfunc.Opened and (basey + PANEL_HEIGHT) or basey
	end
	local function applyheight(animate)
		swatch.Position = UDim2.new(1, -12, 0, basey / 2)
		panel.Position = UDim2.new(0, 0, 0, basey)
		if colorfunc.Opened then
			panel.Visible = true
		elseif animate then
			task.delay(0.32, function()
				if not colorfunc.Opened then
					panel.Visible = false
				end
			end)
		else
			panel.Visible = false
		end
		local size = UDim2.new(1, 0, 0, currentheight())
		if animate then
			tw(row, { Size = size }, 0.3)
		else
			row.Size = size
		end
	end
	if description then
		title.Position = UDim2.new(0, ix, 0, 9)
		local _, measure = attachcontent(row, description, ix, 26, 64)
		local function relayout()
			basey = math.max(46, 26 + measure() + 10)
			applyheight(false)
		end
		relayout()
		watchwidth(row, relayout)
	end

	local function render()
		svbox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		svcursor.Position = UDim2.new(sat, 0, 1 - val, 0)
		huecursor.Position = UDim2.new(0.5, 0, hue, 0)
		swatch.BackgroundColor3 = colorfunc.Value
		if not hexbox:IsFocused() then
			hexbox.Text = "#" .. tohex(colorfunc.Value)
		end
	end

	local function commit(save, notify)
		colorfunc.Value = Color3.fromHSV(hue, sat, val)
		if save then
			config.data[configkey] = tohex(colorfunc.Value)
			autosave.touch()
		end
		render()
		if notify then
			elevate()
			local ok, err = pcall(colorconfig.Callback, colorfunc.Value)
			if not ok then
				warn("ColorPicker Callback error:", err)
			end
		end
	end

	local function setcolor(color, notify)
		local h, s, v = color:ToHSV()
		if s > 0.001 and v > 0.001 then
			hue = h
		end
		sat, val = s, v
		commit(true, notify)
	end

	function colorfunc:Set(value)
		local color = parsecolor(value)
		if color then
			setcolor(color, true)
		end
	end

	function colorfunc:LoadValue(value)
		self:Set(value)
	end

	function colorfunc:ResetValue()
		self:Set(hubdefault)
	end

	function colorfunc:Get()
		return colorfunc.Value
	end

	function colorfunc:GetHex()
		return "#" .. tohex(colorfunc.Value)
	end

	function colorfunc:SetOpen(state)
		colorfunc.Opened = state == true
		applyheight(true)
	end

	local function pointer(input)
		local pos = Vector2.new(input.Position.X, input.Position.Y)
		local gui = row:FindFirstAncestorOfClass("ScreenGui")
		if gui and gui.IgnoreGuiInset then
			local okinset, inset = pcall(function()
				return game:GetService("GuiService"):GetGuiInset()
			end)
			if okinset then
				pos = pos + inset
			end
		end
		return pos
	end

	local dragging = nil
	local function drag(input)
		local pos = pointer(input)
		if dragging == "sv" then
			local abs, size = svbox.AbsolutePosition, svbox.AbsoluteSize
			sat = math.clamp((pos.X - abs.X) / math.max(size.X, 1), 0, 1)
			val = 1 - math.clamp((pos.Y - abs.Y) / math.max(size.Y, 1), 0, 1)
			commit(true, true)
		elseif dragging == "hue" then
			local abs, size = huebar.AbsolutePosition, huebar.AbsoluteSize
			hue = math.clamp((pos.Y - abs.Y) / math.max(size.Y, 1), 0, 1)
			commit(true, true)
		end
	end

	local function isdown(input)
		return input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
	end

	svhit.InputBegan:Connect(function(input)
		if not isdown(input) then
			return
		end
		dragging = "sv"
		drag(input)
	end)
	huehit.InputBegan:Connect(function(input)
		if not isdown(input) then
			return
		end
		dragging = "hue"
		drag(input)
	end)

	trackConnection(
		sv.uis.InputChanged:Connect(function(input)
			if
				dragging
				and (
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				drag(input)
			end
		end),
		"colorpicker.changed." .. configkey
	)
	trackConnection(
		sv.uis.InputEnded:Connect(function(input)
			if dragging and isdown(input) then
				dragging = nil
			end
		end),
		"colorpicker.ended." .. configkey
	)

	hexbox.FocusLost:Connect(function()
		local color = parsecolor(hexbox.Text)
		if color then
			setcolor(color, true)
		else
			render()
		end
	end)

	swatch.Activated:Connect(function()
		colorfunc:SetOpen(not colorfunc.Opened)
	end)

	local saved = config.data[configkey]
	local startcolor = parsecolor(saved) or hubdefault
	do
		local h, s, v = startcolor:ToHSV()
		hue, sat, val = h, s, v
	end
	commit(true, false)

	countitem = countitem + 1
	yieldbuild()
	config.elements[configkey] = colorfunc
	registerSearchItem(colorconfig.Title, row, "Color")
	return colorfunc
end

items.AddColorpicker = items.AddColorPicker
items.AddColor = items.AddColorPicker

