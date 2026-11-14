function items:AddStepper(stepperconfig)
	stepperconfig = stepperconfig or {}
	stepperconfig.Title = stepperconfig.Title or stepperconfig.Name or "Stepper"
	stepperconfig.Callback = stepperconfig.Callback or function() end
	local step = math.max(tonumber(stepperconfig.Increment) or 1, 1e-9)
	local min = tonumber(stepperconfig.Min) or 0
	local max = math.max(tonumber(stepperconfig.Max) or 100, min)
	local precision = tonumber(stepperconfig.Precision) or stepprecision(step)
	local configkey = keyfor("Stepper_", stepperconfig)
	local nosave = stepperconfig.NoSave == true

	local function snap(value)
		return snapnumber(value, min, max, step, precision)
	end

	local hubdefault = snap(stepperconfig.Default)
	local function savedpref()
		if nosave then
			return hubdefault
		end
		local stored = tonumber(config.data[configkey])
		return stored and snap(stored) or hubdefault
	end

	local stepperfunc = { Value = savedpref(), DefaultValue = hubdefault }

	local row = instance.frame(sectionadd)
	row.Name = "Stepper"
	row.BorderSizePixel = 0
	row.LayoutOrder = countitem
	row.Size = UDim2.new(1, 0, 0, design.Row.Height)
	roundbg(row, design.Radius.Control, theme.Row)

	local description = contenttext(stepperconfig)
	local ix = elementiconx(stepperconfig)
	iconapi(stepperfunc, elementicon(row, stepperconfig.Icon, 20))

	local title = instance.textlabel(row)
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamMedium
	title.TextSize = design.Font.Label
	title.TextColor3 = theme.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.Position = UDim2.new(0, ix, 0, 12)
	title.Size = UDim2.new(1, -(ix + 128), 0, 16)
	title.Text = stepperconfig.Title

	local controls = instance.frame(row)
	controls.Name = "Controls"
	controls.BorderSizePixel = 0
	controls.BackgroundColor3 = theme.Field
	controls.AnchorPoint = Vector2.new(1, 0)
	controls.Position = UDim2.new(1, -design.Row.Pad, 0, 7)
	controls.Size = UDim2.new(0, 108, 0, 26)
	instance.uicorner(controls).CornerRadius = UDim.new(0, design.Radius.Control)
	local controlsstroke = instance.uistroke(controls)
	controlsstroke.Color = theme.Stroke
	controlsstroke.Thickness = 1
	controlsstroke.Transparency = 0.55

	local function stepbutton(text, side)
		local button = instance.textbutton(controls)
		button.Name = text == "+" and "Increase" or "Decrease"
		button.AutoButtonColor = false
		button.BackgroundTransparency = 1
		button.Font = Enum.Font.GothamBold
		button.TextSize = 15
		button.TextColor3 = theme.SubText
		button.Text = text
		button.Size = UDim2.new(0, 28, 1, 0)
		button.Position = side == "left" and UDim2.new(0, 0, 0, 0) or UDim2.new(1, -28, 0, 0)
		button.MouseEnter:Connect(function()
			tw(button, { TextColor3 = theme.Text }, design.Anim.Fast)
		end)
		button.MouseLeave:Connect(function()
			tw(button, { TextColor3 = theme.SubText }, design.Anim.Fast)
		end)
		return button
	end
	local minus, plus = stepbutton("-", "left"), stepbutton("+", "right")

	local box = instance.textbox(controls)
	box.BackgroundTransparency = 1
	box.ClearTextOnFocus = false
	box.Font = Enum.Font.GothamMedium
	box.TextSize = 12
	box.TextColor3 = theme.Text
	box.Position = UDim2.new(0, 28, 0, 0)
	box.Size = UDim2.new(1, -56, 1, 0)

	local function apply(value, notify)
		value = snap(value)
		local changed = value ~= stepperfunc.Value
		stepperfunc.Value = value
		box.Text = numbertext(value, precision)
		if not nosave and (changed or notify) then
			config.data[configkey] = value
			autosave.touch()
		end
		if notify and changed then
			firecallback(stepperconfig.Callback, stepperconfig.Title, value)
		end
	end

	local holding = 0
	local function hold(direction)
		holding += 1
		local ticket = holding
		apply(stepperfunc.Value + direction * step, true)
		task.delay(0.4, function()
			while ticket == holding and row.Parent do
				apply(stepperfunc.Value + direction * step, true)
				task.wait(0.07)
			end
		end)
	end
	local function release()
		holding += 1
	end

	for button, direction in pairs({ [minus] = -1, [plus] = 1 }) do
		button.MouseButton1Down:Connect(function()
			hold(direction)
		end)
		button.MouseButton1Up:Connect(release)
		button.MouseLeave:Connect(release)
	end
	box.FocusLost:Connect(function()
		local typed = tonumber(box.Text)
		apply(typed or stepperfunc.Value, true)
	end)

	if description then
		local _, measure = attachcontent(row, description, ix, 29, design.Row.Pad)
		local function relayout()
			row.Size = UDim2.new(1, 0, 0, math.max(29 + measure() + 10, design.Row.Height))
		end
		relayout()
		watchwidth(row, relayout)
	end

	apply(stepperfunc.Value, false)

	function stepperfunc:Set(value)
		apply(value, true)
	end

	function stepperfunc:Get()
		return stepperfunc.Value
	end

	registerSearchItem(stepperconfig.Title, row, "Stepper")
	countitem = countitem + 1
	yieldbuild()
	if not nosave then
		config.elements[configkey] = stepperfunc
	end
	return stepperfunc
end
