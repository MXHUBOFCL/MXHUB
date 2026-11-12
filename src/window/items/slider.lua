function items:AddSlider(sliderconfig)
	sliderconfig = sliderconfig or {}
	sliderconfig.Title = sliderconfig.Title or sliderconfig.Name or "Slider"
	sliderconfig.Increment = tonumber(sliderconfig.Increment) or 1
	sliderconfig.Min = tonumber(sliderconfig.Min) or 0
	sliderconfig.Max = tonumber(sliderconfig.Max) or 100
	sliderconfig.Default = tonumber(sliderconfig.Default) or sliderconfig.Min
	sliderconfig.Callback = sliderconfig.Callback or function() end

	local configkey = keyfor("Slider_", sliderconfig)

	local function getprecision(step)
		local s = tostring(step)
		if s:find("e") or s:find("E") then
			s = string.format("%.12f", step):gsub("0+$", ""):gsub("%.$", "")
		end

		local dot = s:find("%.")
		return dot and (#s - dot) or 0
	end

	local precision = tonumber(sliderconfig.Precision) or getprecision(sliderconfig.Increment)
	local suffix = tostring(sliderconfig.Suffix or "")

	local function roundtoincrement(value)
		local step = sliderconfig.Increment
		return math.floor((value / step) + 0.5) * step
	end

	local function formatnumber(value)
		value = tonumber(string.format("%." .. precision .. "f", value)) or 0

		if precision > 0 then
			return string.format("%." .. precision .. "f", value):gsub("0+$", ""):gsub("%.$", "")
		end

		return tostring(math.floor(value + 0.5))
	end

	local function clampvalue(value)
		value = tonumber(value) or sliderconfig.Min
		value = math.clamp(value, sliderconfig.Min, sliderconfig.Max)
		value = roundtoincrement(value)
		value = math.clamp(value, sliderconfig.Min, sliderconfig.Max)
		value = tonumber(string.format("%." .. precision .. "f", value)) or sliderconfig.Min
		return value
	end

	local hubdefault = clampvalue(sliderconfig.Default)
	local haspref = config.data[configkey] ~= nil
	local function savedpref()
		local v = tonumber(config.data[configkey])
		return v and clampvalue(v) or hubdefault
	end

	local sliderfunc = {
		Value = savedpref(),
		DefaultValue = hubdefault,
	}

	local slider = templates.Slider:Clone()
	slider.LayoutOrder = countitem
	slider.Parent = sectionadd

	local slidertitle = slider.SliderTitle
	slidertitle.Text = sliderconfig.Title

	local inputholder = slider.SliderInputHolder
	local textbox = inputholder.SliderInput

	local sliderframe = slider.SliderBar
	local sliderfill = sliderframe.SliderFill
	local slidercircle = sliderframe.SliderCircle
	local circlestroke = slidercircle.UIStroke
	local bubble = sliderframe.ValueBubble
	local bubbletext = bubble.BubbleText

	local basey = 58
	local description = contenttext(sliderconfig)
	local ix = elementiconx(sliderconfig)
	iconapi(sliderfunc, elementicon(slider, sliderconfig.Icon, 17))
	slidertitle.Position = UDim2.new(0, ix, 0, 7)
	slidertitle.Size = UDim2.new(1, -(ix + 48), 0, 20)
	if description then
		local _, measure = attachcontent(slider, description, ix, 31, 20)
		local function relayout()
			local bary = 31 + measure() + 8
			sliderframe.Position = UDim2.new(0, 10, 0, bary)
			basey = bary + 19
			slider.Size = UDim2.new(1, 0, 0, basey)
		end
		relayout()
		watchwidth(slider, relayout)
	end

	local dragging = false
	local setting = false

	local function getpercent(value)
		if sliderconfig.Max == sliderconfig.Min then
			return 0
		end

		return math.clamp((value - sliderconfig.Min) / (sliderconfig.Max - sliderconfig.Min), 0, 1)
	end

	local function updatebubble(percent, value)
		bubble.Position = UDim2.new(percent, 0, 0, -10)
		bubbletext.Text = tostring(value)
	end

	local function showbubble()
		bubble.Visible = true

		sv.ts
			:Create(slidercircle, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 14, 0, 14),
			})
			:Play()

		sv.ts
			:Create(bubble, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.15,
				Size = UDim2.new(0, 48, 0, 22),
			})
			:Play()
	end

	local function hidebubble()
		sv.ts
			:Create(slidercircle, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 12, 0, 12),
			})
			:Play()

		sv.ts
			:Create(bubble, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 48, 0, 22),
			})
			:Play()

		task.delay(0.15, function()
			if not dragging then
				bubble.Visible = false
			end
		end)
	end

	local filltween, circletween
	local lastfired = nil
	local lastcall, pendingvalue, flushqueued = 0, nil, false

	local function cancelvisual()
		if filltween then
			filltween:Cancel()
			filltween = nil
		end
		if circletween then
			circletween:Cancel()
			circletween = nil
		end
	end

	local function apply(value, fire, save)
		elevate()
		value = clampvalue(value)

		sliderfunc.Value = value
		if save then
			config.data[configkey] = value
			autosave.touch()
		end

		local percent = getpercent(value)
		local formatted = formatnumber(value)

		setting = true
		textbox.Text = formatted
		setting = false

		updatebubble(percent, formatted .. suffix)

		if dragging then

			cancelvisual()
			sliderfill.Size = UDim2.new(percent, 0, 1, 0)
			slidercircle.Position = UDim2.new(percent, 0, 0.5, 0)
		else
			cancelvisual()
			local info = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			filltween = sv.ts:Create(sliderfill, info, { Size = UDim2.new(percent, 0, 1, 0) })
			circletween = sv.ts:Create(slidercircle, info, { Position = UDim2.new(percent, 0, 0.5, 0) })
			filltween:Play()
			circletween:Play()
		end

		if fire and typeof(sliderconfig.Callback) == "function" then

			if dragging and lastfired == value then
				return
			end
			if dragging and (tick() - lastcall) < 0.06 then
				pendingvalue = value
				if not flushqueued then
					flushqueued = true
					task.delay(0.07, function()
						flushqueued = false
						if pendingvalue ~= nil then
							local v = pendingvalue
							pendingvalue = nil
							lastfired = v
							lastcall = tick()
							task.spawn(function()
								elevate()
								local okf, errf = pcall(sliderconfig.Callback, v)
								if not okf then
									warn("Slider Callback error:", errf)
								end
							end)
						end
					end)
				end
				return
			end
			pendingvalue = nil
			lastfired = value
			lastcall = tick()
			task.spawn(function()
				elevate()
				local ok, err = pcall(sliderconfig.Callback, value)
				if not ok then
					warn("Slider Callback error:", err)
				end
			end)
		end
	end

	local function setfromx(x)
		local width = math.max(sliderframe.AbsoluteSize.X, 1)
		local percent = math.clamp((x - sliderframe.AbsolutePosition.X) / width, 0, 1)
		local value = sliderconfig.Min + ((sliderconfig.Max - sliderconfig.Min) * percent)

		sliderfunc:Set(value)
	end

	function sliderfunc:Set(value, nocallback)
		apply(value, not nocallback, true)
	end

	function sliderfunc:LoadValue(value)
		self:Set(value, false)
	end

	function sliderfunc:ResetValue()
		self:Set(hubdefault)
	end

	local function startdrag(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			showbubble()
			setfromx(input.Position.X)
			sliderDrag.active = {
				input = input,
				setfromx = setfromx,
				hidebubble = function()
					dragging = false
					hidebubble()
				end,
			}
		end
	end

	sliderframe.InputBegan:Connect(startdrag)
	slidercircle.InputBegan:Connect(startdrag)

	local grab = instance.frame(sliderframe)
	grab.Name = "GrabArea"
	grab.AnchorPoint = Vector2.new(0.5, 0.5)
	grab.BackgroundTransparency = 1
	grab.BorderSizePixel = 0
	grab.Position = UDim2.new(0.5, 0, 0.5, 0)
	grab.Size = UDim2.new(1, 14, 0, isMobile and 32 or 22)
	grab.Active = true
	grab.ZIndex = 3
	grab.InputBegan:Connect(startdrag)

	textbox.Focused:Connect(function()
		showbubble()
	end)

	textbox.FocusLost:Connect(function()
		if setting then
			return
		end

		local text = textbox.Text:gsub(",", ".")
		local value = tonumber(text)

		if value then
			sliderfunc:Set(value)
		else
			textbox.Text = formatnumber(sliderfunc.Value)
		end

		hidebubble()
	end)

	apply(sliderfunc.Value, haspref, true)

	countitem = countitem + 1
	yieldbuild()
	config.elements[configkey] = sliderfunc
	registerSearchItem(sliderconfig.Title, slider, "Slider")
	return sliderfunc
end

