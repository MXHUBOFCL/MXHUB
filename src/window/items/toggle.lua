function items:AddToggle(toggleconfig)
	toggleconfig = toggleconfig or {}
	toggleconfig.Title = toggleconfig.Title or "Title"
	toggleconfig.Callback = toggleconfig.Callback or function() end

	local configkey = keyfor("Toggle_", toggleconfig)
	local toggletween = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local hubdefault = toggleconfig.Default and true or false
	local nosave = toggleconfig.NoSave == true

	local function savedpref()
		if nosave then
			return hubdefault
		end
		local v = config.data[configkey]
		if v ~= nil then
			return v == true
		end
		if config.loaded then
			return false
		end
		return hubdefault
	end

	local togglefunc = { Value = false, DefaultValue = hubdefault }

	local toggle = templates.Toggle:Clone()
	toggle.LayoutOrder = countitem
	toggle.Parent = sectionadd

	local toggletitle = toggle.ToggleTitle
	toggletitle.Text = toggleconfig.Title

	local togglebutton = toggle.ToggleButton
	local featureframe2 = toggle.FeatureFrame
	local uistroke8 = featureframe2.UIStroke
	local togglecircle = featureframe2.ToggleCircle

	local rowh = toggle.Size.Y.Offset
	local basey = rowh
	local description = contenttext(toggleconfig)
	local ix = elementiconx(toggleconfig)
	iconapi(togglefunc, elementicon(toggle, toggleconfig.Icon, description and 15.5 or math.floor(rowh / 2)))
	local haskey = toggleconfig.Keybind ~= false and (toggleconfig.Keybind ~= nil or guiconfig.ToggleKeybinds == true)
	local keyextra = haskey and 60 or 0
	toggletitle.Position = UDim2.new(0, ix, 0, description and 8 or math.floor((rowh - 13) / 2))
	toggletitle.Size = UDim2.new(1, -(ix + 60 + keyextra), 0, 13)
	if description then
		toggletitle.Position = UDim2.new(0, ix, 0, 8)
		local _, measure = attachcontent(toggle, description, ix, 24, 62 + keyextra)
		local function relayout()
			basey = math.max(rowh, 24 + measure() + 9)
			toggle.Size = UDim2.new(1, 0, 0, basey)
		end
		relayout()
		watchwidth(toggle, relayout)
	end

	local function render(value, instant)
		elevate()
		local titleColor = value and theme.Text or theme.OffText
		local circleColor = value and theme.KnobOn or theme.KnobOff

		local knob = togglecircle.Size.X.Offset
		local gap = math.floor((featureframe2.Size.Y.Offset - knob) / 2)
		local circlePosition = value and UDim2.new(0, featureframe2.Size.X.Offset - knob - gap, 0, gap)
			or UDim2.new(0, gap, 0, gap)
		local strokeColor = value and theme.ToggleOn or theme.ToggleOffStroke
		local strokeTransparency = 0
		local backgroundColor = value and theme.ToggleOn or theme.ToggleOff
		local backgroundTransparency = 0

		if instant then
			toggletitle.TextColor3 = titleColor
			togglecircle.Position = circlePosition
			togglecircle.BackgroundColor3 = circleColor
			uistroke8.Color = strokeColor
			uistroke8.Transparency = strokeTransparency
			featureframe2.BackgroundColor3 = backgroundColor
			featureframe2.BackgroundTransparency = backgroundTransparency
		else
			sv.ts:Create(toggletitle, toggletween, { TextColor3 = titleColor }):Play()
			sv.ts
				:Create(togglecircle, toggletween, {
					Position = circlePosition,
					BackgroundColor3 = circleColor,
				})
				:Play()
			sv.ts
				:Create(uistroke8, toggletween, {
					Color = strokeColor,
					Transparency = strokeTransparency,
				})
				:Play()
			sv.ts
				:Create(featureframe2, toggletween, {
					BackgroundColor3 = backgroundColor,
					BackgroundTransparency = backgroundTransparency,
				})
				:Play()
		end
	end

	local function apply(value, instant, save, fire)
		elevate()
		togglefunc.Value = value
		if save then
			if not nosave then
				config.data[configkey] = value
				autosave.touch()
			end
		end

		render(value, instant)
		if fire and typeof(toggleconfig.Callback) == "function" then
			task.spawn(function()
				elevate()
				local ok, err = pcall(toggleconfig.Callback, value)
				if not ok then
					warn("Toggle Callback error:", err)
				end
			end)
		end
	end

	togglebutton.Activated:Connect(function()
		togglefunc:Set(not togglefunc.Value)
	end)

	function togglefunc:Set(value, instant)
		apply(value and true or false, instant, true, true)
	end

	function togglefunc:LoadValue(value)
		self:Set(value, true)
	end

	function togglefunc:ResetValue()
		self:Set(hubdefault)
	end

	local keychip
	if haskey then
		local keyopt = toggleconfig.Keybind
		if type(keyopt) ~= "table" then
			keyopt = { Default = keyopt }
		end
		local keycfgkey = "ToggleKey_" .. configkey
		local keydefault = resolvekey(keyopt.Default)
		local savedkey = config.data[keycfgkey]
		local boundkey = savedkey ~= nil and resolvekey(savedkey) or keydefault
		local listening = false
		local listengen = 0
		local switchwidth = featureframe2.Size.X.Offset > 0 and featureframe2.Size.X.Offset or 32

		keychip = instance.textbutton(toggle)
		keychip.Name = "KeyChip"
		keychip.AnchorPoint = Vector2.new(1, 0.5)
		keychip.Position = UDim2.new(1, -(12 + switchwidth + 8), 0.5, 0)
		keychip.Size = UDim2.new(0, 40, 0, 20)
		keychip.AutoButtonColor = false
		keychip.Font = Enum.Font.GothamMedium
		keychip.TextSize = 10
		keychip.Text = ""
		keychip.BackgroundColor3 = theme.Field
		keychip.BorderSizePixel = 0
		instance.uicorner(keychip).CornerRadius = UDim.new(0, 5)
		local keystroke = instance.uistroke(keychip)
		keystroke.Color = Color3.fromRGB(255, 255, 255)
		keystroke.Thickness = 1
		keystroke.Transparency = 0.9

		local function renderkey()
			local text, color
			if listening then
				text, color = "...", guiconfig.Color
			elseif boundkey then
				text, color = keyname(boundkey), theme.Text
			else
				text, color = "None", theme.Dim
			end
			keychip.Text = text
			keychip.TextColor3 = color
			local okm, bounds = pcall(function()
				return sv.textservice:GetTextSize(text, 10, Enum.Font.GothamMedium, Vector2.new(200, 20))
			end)
			keychip.Size = UDim2.new(0, math.max(34, ((okm and bounds) and math.ceil(bounds.X) or 24) + 14), 0, 20)
		end

		local function bindkey(key)
			boundkey = key
			config.data[keycfgkey] = key and key.Name or "None"
			autosave.touch()
			renderkey()
		end

		local function setlistening(state)
			if listening == state then
				return
			end
			listening = state
			listengen = listengen + 1
			renderkey()
			if state then
				local gen = listengen
				task.delay(8, function()
					if listening and listengen == gen then
						setlistening(false)
					end
				end)
			end
		end

		keychip.Activated:Connect(function()
			setlistening(not listening)
		end)

		trackConnection(
			sv.uis.InputBegan:Connect(function(input, processed)
				if not toggle.Parent then
					return
				end
				if listening then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						if input.KeyCode == Enum.KeyCode.Escape then
							setlistening(false)
						elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
							setlistening(false)
							bindkey(nil)
						else
							setlistening(false)
							bindkey(resolvekey(input.KeyCode))
						end
					elseif
						input.UserInputType == Enum.UserInputType.MouseButton2
						or input.UserInputType == Enum.UserInputType.MouseButton3
					then
						setlistening(false)
						bindkey(input.UserInputType)
					end
					return
				end
				if processed or not boundkey or not inputmatches(input, boundkey) then
					return
				end
				togglefunc:Set(not togglefunc.Value)
			end),
			"togglekey.began." .. configkey
		)

		renderkey()
	end

	apply(savedpref(), true, true, true)

	countitem = countitem + 1
	yieldbuild()
	if not nosave then
		config.elements[configkey] = togglefunc
	end
	registerSearchItem(toggleconfig.Title, toggle, "Toggle")
	return togglefunc
end

