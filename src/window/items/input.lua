function items:AddInput(inputconfig)
	inputconfig = inputconfig or {}
	inputconfig.Title = inputconfig.Title or "Title"
	inputconfig.Placeholder = inputconfig.Placeholder or "Write your input here"
	inputconfig.Callback = inputconfig.Callback or function() end

	local configkey = keyfor("Input_", inputconfig)
	local hubdefault = tostring(inputconfig.Default or "")
	local nosave = inputconfig.NoSave == true
	local function savedpref()
		if nosave then
			return hubdefault
		end
		local v = config.data[configkey]
		if v ~= nil then
			return tostring(v)
		end
		if config.loaded and not metakeys[configkey] then
			return ""
		end
		return hubdefault
	end

	local inputfunc = { Value = savedpref(), DefaultValue = hubdefault }

	local inputcontainer = instance.frame(sectionadd)
	inputcontainer.BorderSizePixel = 0
	inputcontainer.LayoutOrder = countitem
	inputcontainer.Size = UDim2.new(1, 0, 0, 58)
	roundbg(inputcontainer, 4, theme.Row)

	local inputtitle = instance.textlabel(inputcontainer)
	inputtitle.Font = Enum.Font.GothamMedium
	inputtitle.Text = inputconfig.Title
	inputtitle.TextSize = 12
	inputtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	inputtitle.TextXAlignment = Enum.TextXAlignment.Left
	inputtitle.BackgroundTransparency = 1
	inputtitle.Position = UDim2.new(0, 10, 0, 6)
	inputtitle.Size = UDim2.new(1, -20, 0, 14)
	inputtitle.TextTruncate = Enum.TextTruncate.AtEnd

	local inputtextbox = instance.textbox(inputcontainer)
	inputtextbox.Font = Enum.Font.GothamBold
	inputtextbox.PlaceholderText = inputconfig.Placeholder
	inputtextbox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
	inputtextbox.TextTransparency = 0.4
	inputtextbox.Text = inputfunc.Value
	inputtextbox.TextSize = 11
	inputtextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
	inputtextbox.BackgroundColor3 = theme.Field
	inputtextbox.BackgroundTransparency = 0
	inputtextbox.TextXAlignment = Enum.TextXAlignment.Left
	inputtextbox.ClearTextOnFocus = false
	inputtextbox.Position = UDim2.new(0, 10, 0, 26)
	inputtextbox.Size = UDim2.new(1, -20, 0, 24)
	inputtextbox.ClipsDescendants = true
	inputtextbox.TextTruncate = Enum.TextTruncate.AtEnd

	local padding = instance.uipadding(inputtextbox)
	padding.PaddingLeft = UDim.new(0, 4)

	local basey = 58
	local description = contenttext(inputconfig)
	local ix = elementiconx(inputconfig)
	iconapi(inputfunc, elementicon(inputcontainer, inputconfig.Icon, 13))
	inputtitle.Position = UDim2.new(0, ix, 0, 6)
	inputtitle.Size = UDim2.new(1, -(ix + 10), 0, 14)
	if description then
		local _, measure = attachcontent(inputcontainer, description, ix, 23, 10)
		local function relayout()
			local boxy = 23 + measure() + 5
			inputtextbox.Position = UDim2.new(0, 10, 0, boxy)
			basey = boxy + 32
			inputcontainer.Size = UDim2.new(1, 0, 0, basey)
		end
		relayout()
		watchwidth(inputcontainer, relayout)
	end

	inputtextbox.Focused:Connect(function()
		inputtextbox.CursorPosition = #inputtextbox.Text + 1
	end)

	local suppress = false
	local function applyinput(value, fire, save)
		elevate()
		value = tostring(value == nil and "" or value)
		inputfunc.Value = value
		suppress = true
		inputtextbox.Text = value
		suppress = false
		if save and not nosave then
			config.data[configkey] = value
			autosave.touch()
		end
		if fire and typeof(inputconfig.Callback) == "function" then
			elevate()
			local ok, err = pcall(inputconfig.Callback, value)
			if not ok then
				warn("Input Callback error:", err)
			end
		end
	end

	function inputfunc:Set(value)
		applyinput(value, true, true)
	end

	function inputfunc:LoadValue(value)
		self:Set(value)
	end

	function inputfunc:ResetValue()
		self:Set(hubdefault)
	end

	inputtextbox:GetPropertyChangedSignal("Text"):Connect(function()
		if suppress then
			return
		end
		inputfunc.Value = inputtextbox.Text
		if not nosave then
			config.data[configkey] = inputtextbox.Text
			autosave.touch()
		end
	end)

	inputtextbox.FocusLost:Connect(function()
		inputfunc:Set(inputtextbox.Text)
	end)

	applyinput(inputfunc.Value, true, true)

	countitem = countitem + 1
	yieldbuild()
	if not nosave then
		config.elements[configkey] = inputfunc
	end
	registerSearchItem(inputconfig.Title, inputcontainer)
	return inputfunc
end

