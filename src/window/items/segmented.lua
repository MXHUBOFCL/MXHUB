function items:AddSegmented(segmentedconfig)
	segmentedconfig = segmentedconfig or {}
	segmentedconfig.Title = segmentedconfig.Title or segmentedconfig.Name or "Segmented"
	segmentedconfig.Callback = segmentedconfig.Callback or function() end

	local choices = {}
	for _, option in ipairs(segmentedconfig.Options or {}) do
		choices[#choices + 1] = tostring(option)
	end
	local configkey = keyfor("Segmented_", segmentedconfig)
	local nosave = segmentedconfig.NoSave == true
	local fallback = pickoption(choices, segmentedconfig.Default and tostring(segmentedconfig.Default), choices[1])

	local function savedpref()
		if nosave then
			return fallback
		end
		return pickoption(choices, config.data[configkey], fallback)
	end

	local segmentedfunc = { Value = savedpref(), DefaultValue = fallback }

	local row = instance.frame(sectionadd)
	row.Name = "Segmented"
	row.BorderSizePixel = 0
	row.LayoutOrder = countitem
	roundbg(row, design.Radius.Control, theme.Row)

	local description = contenttext(segmentedconfig)
	local ix = elementiconx(segmentedconfig)
	iconapi(segmentedfunc, elementicon(row, segmentedconfig.Icon, 18))

	local title = instance.textlabel(row)
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamMedium
	title.TextSize = design.Font.Label
	title.TextColor3 = theme.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.Position = UDim2.new(0, ix, 0, 10)
	title.Size = UDim2.new(1, -(ix + design.Row.Pad), 0, 16)
	title.Text = segmentedconfig.Title

	local track = instance.frame(row)
	track.Name = "Track"
	track.BorderSizePixel = 0
	track.BackgroundColor3 = theme.Field
	track.Position = UDim2.new(0, design.Row.Pad, 0, 34)
	track.Size = UDim2.new(1, -design.Row.Pad * 2, 0, 28)
	instance.uicorner(track).CornerRadius = UDim.new(0, design.Radius.Control)
	local trackstroke = instance.uistroke(track)
	trackstroke.Color = theme.Stroke
	trackstroke.Thickness = 1
	trackstroke.Transparency = 0.55

	local pill = instance.frame(track)
	pill.Name = "Selected"
	pill.BorderSizePixel = 0
	pill.BackgroundColor3 = theme.Accent
	instance.uicorner(pill).CornerRadius = UDim.new(0, design.Radius.Control - 2)

	local buttons = {}
	local count = math.max(#choices, 1)

	local function place(index, instant)
		local position = UDim2.new((index - 1) / count, 2, 0, 2)
		local size = UDim2.new(1 / count, -4, 1, -4)
		if instant then
			pill.Position, pill.Size = position, size
		else
			tw(pill, { Position = position, Size = size }, design.Anim.Normal)
		end
	end

	local function paint(selected, instant)
		for index, button in ipairs(buttons) do
			local on = choices[index] == selected
			local color = on and theme.AccentText or theme.SubText
			if instant then
				button.TextColor3 = color
			else
				tw(button, { TextColor3 = color }, design.Anim.Fast)
			end
			if on then
				place(index, instant)
			end
		end
	end

	local function apply(value, instant, notify)
		value = pickoption(choices, value, segmentedfunc.Value)
		if value == nil then
			return
		end
		local changed = value ~= segmentedfunc.Value
		segmentedfunc.Value = value
		paint(value, instant)
		if not nosave and (changed or notify) then
			config.data[configkey] = value
			autosave.touch()
		end
		if notify then
			firecallback(segmentedconfig.Callback, segmentedconfig.Title, value)
		end
	end

	local function build()
		for _, button in ipairs(buttons) do
			button:Destroy()
		end
		table.clear(buttons)
		count = math.max(#choices, 1)
		for index, choice in ipairs(choices) do
			local button = instance.textbutton(track)
			button.Name = "Option"
			button.BackgroundTransparency = 1
			button.AutoButtonColor = false
			button.ZIndex = 2
			button.Font = Enum.Font.GothamMedium
			button.TextSize = 12
			button.TextTruncate = Enum.TextTruncate.AtEnd
			button.Text = choice
			button.Position = UDim2.new((index - 1) / count, 0, 0, 0)
			button.Size = UDim2.new(1 / count, 0, 1, 0)
			button.MouseEnter:Connect(function()
				if choices[index] ~= segmentedfunc.Value then
					tw(button, { TextColor3 = theme.Text }, design.Anim.Fast)
				end
			end)
			button.MouseLeave:Connect(function()
				if choices[index] ~= segmentedfunc.Value then
					tw(button, { TextColor3 = theme.SubText }, design.Anim.Fast)
				end
			end)
			button.Activated:Connect(function()
				apply(choice, false, true)
			end)
			buttons[#buttons + 1] = button
		end
		pill.Visible = #choices > 0
		paint(segmentedfunc.Value, true)
	end

	if description then
		local _, measure = attachcontent(row, description, ix, 29, design.Row.Pad)
		local function relayout()
			local y = 29 + measure() + 8
			track.Position = UDim2.new(0, design.Row.Pad, 0, y)
			row.Size = UDim2.new(1, 0, 0, y + 36)
		end
		relayout()
		watchwidth(row, relayout)
	else
		row.Size = UDim2.new(1, 0, 0, 70)
	end

	build()

	function segmentedfunc:Set(value, instant)
		apply(value, instant == true, true)
	end

	function segmentedfunc:Get()
		return segmentedfunc.Value
	end

	function segmentedfunc:Refresh(options, keep)
		choices = {}
		for _, option in ipairs(options or {}) do
			choices[#choices + 1] = tostring(option)
		end
		segmentedfunc.Value = pickoption(choices, keep ~= false and segmentedfunc.Value or nil, choices[1])
		build()
	end

	registerSearchItem(segmentedconfig.Title, row, "Segmented")
	countitem = countitem + 1
	yieldbuild()
	if not nosave then
		config.elements[configkey] = segmentedfunc
	end
	return segmentedfunc
end
