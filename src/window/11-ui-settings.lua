do
	local lighting = game:GetService("Lighting")
	local uipath = "MX HUB/ui.json"
	local uistate = { language = "English", scale = "Auto", menukey = "F3", autosave = false }
	autosave.enabled = false
	local i18n = MXHUB.I18n

	local staleblur = lighting:FindFirstChild("MXHUB_Blur")
	if staleblur then
		staleblur:Destroy()
	end

	pcall(function()
		if type(isfile) == "function" and type(readfile) == "function" and isfile(uipath) then
			local data = sv.http:JSONDecode(readfile(uipath))
			if type(data) == "table" then
				for key, value in pairs(data) do
					if uistate[key] ~= nil and type(value) == type(uistate[key]) then
						uistate[key] = value
					end
				end
			end
		end
	end)

	autosave.enabled = uistate.autosave == true

	local function saveui()
		pcall(function()
			if type(writefile) ~= "function" then
				return
			end
			if type(isfolder) == "function" and not isfolder("MX HUB") then
				makefolder("MX HUB")
			end
			writefile(uipath, sv.http:JSONEncode(uistate))
		end)
	end

	local function make(class, parent, props)
		local obj = Instance.new(class)
		for key, value in pairs(props) do
			obj[key] = value
		end
		obj.Parent = parent
		return obj
	end

	-- ------------------------------------------------ menu key
	local function keycodeof(name)
		local ok, code = pcall(function()
			return Enum.KeyCode[name]
		end)
		if ok and typeof(code) == "EnumItem" then
			return code
		end
		return nil
	end
	local savedkey = keycodeof(uistate.menukey)
	if savedkey then
		togglekey = savedkey
	end

	-- ------------------------------------------------ menu scale
	dropshadowholder:SetAttribute("MXScalable", true)
	local function applyscale()
		local factor = tonumber(uistate.scale)
		sv.UserScale = factor and math.clamp(factor, 0.6, 1.6) or 1
		for _, refit in ipairs(sv.Refits or {}) do
			pcall(refit)
		end
	end
	applyscale()

	-- ------------------------------------------------ language
	local function translate(inst)
		local class = inst.ClassName
		local prop, origattr, trattr
		if class == "TextLabel" or class == "TextButton" then
			prop, origattr, trattr = "Text", "MXOrig", "MXTr"
		elseif class == "TextBox" then
			prop, origattr, trattr = "PlaceholderText", "MXPOrig", "MXPTr"
		else
			return
		end
		if inst:GetAttribute("MXNoTranslate") then
			return
		end
		local dict = i18n.Dict[i18n.Current]
		local english = i18n.Current == "English"
		local cur = inst[prop]
		local orig = inst:GetAttribute(origattr)
		if orig == nil then
			if english or not (dict and dict[cur]) then
				return
			end
			orig = cur
			inst:SetAttribute(origattr, cur)
		else
			local prev = inst:GetAttribute(trattr)
			if cur ~= orig and cur ~= prev then
				if english or not (dict and dict[cur]) then
					inst:SetAttribute(origattr, nil)
					inst:SetAttribute(trattr, nil)
					return
				end
				orig = cur
				inst:SetAttribute(origattr, cur)
			end
		end
		local target = orig
		if not english and dict and dict[orig] then
			target = dict[orig]
		end
		if target ~= cur then
			inst[prop] = target
		end
		inst:SetAttribute(trattr, target)
	end

	local languagerun = 0
	local function applylanguage()
		languagerun = languagerun + 1
		local id = languagerun
		task.spawn(function()
			local list = mxhubui:GetDescendants()
			for index, inst in ipairs(list) do
				if id ~= languagerun or MXHUB.Unloaded then
					return
				end
				pcall(translate, inst)
				if index % 400 == 0 then
					task.wait()
				end
			end
		end)
	end
	MXHUB.RefreshLanguage = applylanguage

	local languagepending = false
	trackConnection(
		mxhubui.DescendantAdded:Connect(function()
			if i18n.Current == "English" or languagepending then
				return
			end
			languagepending = true
			task.delay(0.15, function()
				languagepending = false
				if i18n.Current ~= "English" and not MXHUB.Unloaded then
					applylanguage()
				end
			end)
		end),
		"mx.i18n.added"
	)

	local refreshvalues
	MXHUB.SetAutoSave = function(state)
		autosave.enabled = state == true
		uistate.autosave = autosave.enabled
		saveui()
	end

	MXHUB.GetAutoSave = function()
		return autosave.enabled
	end

	MXHUB.SetLanguage = function(name)
		if not table.find(i18n.Languages, name) then
			return false
		end
		i18n.Current = name
		uistate.language = name
		saveui()
		applylanguage()
		if refreshvalues then
			refreshvalues()
		end
		return true
	end
	if table.find(i18n.Languages, uistate.language) then
		i18n.Current = uistate.language
		if i18n.Current ~= "English" then
			task.delay(0.6, applylanguage)
		end
	end

	-- ------------------------------------------------ popup shell
	local PW, ROWH, SUBROW = 236, 30, 26
	local POPX = guiconfig["Tab Width"] + 18
	local SUBX = POPX + PW + 6

	local catcher = make("TextButton", main, {
		Name = "ProfileCatcher",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 18,
		Visible = false,
	})

	local popup = make("Frame", main, {
		Name = "ProfilePopup",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, POPX, 1, -8),
		Size = UDim2.new(0, PW, 0, 0),
		BackgroundColor3 = theme.Card,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 20,
		ClipsDescendants = true,
	})
	make("UICorner", popup, { CornerRadius = UDim.new(0, 10) })
	make("UIStroke", popup, { Color = theme.Stroke, Thickness = 1, Transparency = 0.2 })

	local scroll = make("ScrollingFrame", popup, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = theme.Bar,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	})
	make("UIListLayout", scroll, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) })
	make("UIPadding", scroll, {
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
	})

	local head = make("Frame", scroll, { LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1 })
	local avatar = make("ImageLabel", head, {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 2, 0.5, 0),
		Size = UDim2.new(0, 34, 0, 34),
		BackgroundColor3 = theme.Field,
		BorderSizePixel = 0,
		Image = headshot.Image,
	})
	make("UICorner", avatar, { CornerRadius = UDim.new(1, 0) })
	local pname = make("TextLabel", head, {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Position = UDim2.new(0, 44, 0, 7),
		Size = UDim2.new(1, -46, 0, 16),
		Text = username.Text,
	})
	local prole = make("TextLabel", head, {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextColor3 = theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Position = UDim2.new(0, 44, 0, 25),
		Size = UDim2.new(1, -46, 0, 14),
		Text = handlelabel.Text,
	})
	make("Frame", scroll, {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = theme.Stroke,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
	})

	local function addrow(order, iconname, title, danger)
		local button = make("TextButton", scroll, {
			Name = "Row",
			LayoutOrder = order,
			Size = UDim2.new(1, 0, 0, ROWH),
			BackgroundColor3 = theme.ElementHover,
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			BorderSizePixel = 0,
		})
		make("UICorner", button, { CornerRadius = UDim.new(0, 6) })
		local icon = make("ImageLabel", button, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 8, 0.5, 0),
			Size = UDim2.new(0, 14, 0, 14),
			ImageColor3 = danger and theme.Bad or theme.SubText,
		})
		applyicon(icon, iconname, 48)
		make("TextLabel", button, {
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			TextSize = 12,
			TextColor3 = danger and theme.Bad or theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Position = UDim2.new(0, 30, 0, 0),
			Size = UDim2.new(0.5, -30, 1, 0),
			Text = title,
		})
		local value = make("TextLabel", button, {
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(0.5, -22, 1, 0),
			Text = "",
		})
		if not danger then
			local chevron = make("ImageLabel", button, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -6, 0.5, 0),
				Size = UDim2.new(0, 11, 0, 11),
				ImageColor3 = theme.Dim,
			})
			applyicon(chevron, "chevron-right", 48)
		end
		button.MouseEnter:Connect(function()
			tw(button, { BackgroundTransparency = 0.6 }, 0.12)
		end)
		button.MouseLeave:Connect(function()
			tw(button, { BackgroundTransparency = 1 }, 0.15)
		end)
		return button, value
	end

	-- ------------------------------------------------ sub menu (option list)
	local sub = make("Frame", main, {
		Name = "ProfileSub",
		BackgroundColor3 = theme.Card,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 128, 0, 40),
		Visible = false,
		ZIndex = 22,
		ClipsDescendants = true,
	})
	make("UICorner", sub, { CornerRadius = UDim.new(0, 8) })
	make("UIStroke", sub, { Color = theme.Stroke, Thickness = 1, Transparency = 0.2 })
	local subscroll = make("ScrollingFrame", sub, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = theme.Bar,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	})
	make("UIListLayout", subscroll, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1) })
	make("UIPadding", subscroll, {
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 4),
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4),
	})

	local scalesub
	local subrow
	local subitems = {}
	local subwidth, subtop = 128, 0

	local subheader = make("TextLabel", sub, {
		Name = "Header",
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = theme.Dim,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 12, 0, 8),
		Size = UDim2.new(1, -24, 0, 12),
		Visible = false,
		ZIndex = 23,
	})
	local subsearch = make("Frame", sub, {
		Name = "Search",
		BackgroundColor3 = theme.Field,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -12, 0, 26),
		Visible = false,
		ZIndex = 23,
	})
	make("UICorner", subsearch, { CornerRadius = UDim.new(0, 6) })
	make("UIStroke", subsearch, { Color = theme.Stroke, Thickness = 1, Transparency = 0.4 })
	local searchicon = make("ImageLabel", subsearch, {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 8, 0.5, 0),
		Size = UDim2.new(0, 12, 0, 12),
		ImageColor3 = theme.Dim,
		ZIndex = 24,
	})
	applyicon(searchicon, "search", 48)
	local searchbox = make("TextBox", subsearch, {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 26, 0, 0),
		Size = UDim2.new(1, -32, 1, 0),
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = theme.Text,
		PlaceholderText = "Search",
		PlaceholderColor3 = theme.Dim,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Text = "",
		ZIndex = 24,
	})

	local function placepanel(panel, width, height)
		local scale = fitscaleof(main)
		local mainh = main.AbsoluteSize.Y / scale
		local mainw = main.AbsoluteSize.X / scale
		height = math.min(height, mainh - 16)
		local rowy = (subrow.AbsolutePosition.Y - main.AbsolutePosition.Y) / scale
		local y = math.clamp(rowy, 8, math.max(mainh - height - 8, 8))
		local x = math.clamp(SUBX, 8, math.max(mainw - width - 8, 8))
		panel.Position = UDim2.new(0, x, 0, y)
		panel.Size = UDim2.new(0, width, 0, height)
	end

	local function relayout()
		local shown = 0
		for _, entry in ipairs(subitems) do
			if entry.item.Visible then
				shown += 1
			end
		end
		placepanel(sub, subwidth, subtop + shown * (SUBROW + 1) + 10)
		subscroll.Position = UDim2.new(0, 0, 0, subtop)
		subscroll.Size = UDim2.new(1, 0, 1, -subtop)
	end

	searchbox:GetPropertyChangedSignal("Text"):Connect(function()
		for _, entry in ipairs(subitems) do
			entry.item.Visible = searchmatch(entry.label, searchbox.Text)
		end
		subscroll.CanvasPosition = Vector2.new(0, 0)
		if sub.Visible then
			relayout()
		end
	end)

	local function showoptions(row, options, current, onpick, settings)
		settings = settings or {}
		if sub.Visible and subrow == row then
			sub.Visible = false
			return
		end
		scalesub.Visible = false
		subrow = row
		subwidth = settings.width or 128
		local titleheight = settings.title and 24 or 0
		subtop = titleheight + (settings.search and 34 or 0)
		subheader.Text = settings.title or ""
		subheader.Visible = settings.title ~= nil
		subsearch.Position = UDim2.new(0, 6, 0, titleheight + 4)
		subsearch.Visible = settings.search == true
		searchbox.Text = ""

		for _, entry in ipairs(subitems) do
			entry.item:Destroy()
		end
		table.clear(subitems)

		for index, option in ipairs(options) do
			local selected = option.value == current
			local item = make("TextButton", subscroll, {
				LayoutOrder = index,
				Size = UDim2.new(1, 0, 0, SUBROW),
				BackgroundColor3 = theme.TabActive,
				BackgroundTransparency = selected and 0.2 or 1,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Font = Enum.Font.GothamMedium,
				TextSize = 12,
				TextColor3 = selected and theme.Text or theme.SubText,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = option.label,
			})
			make("UICorner", item, { CornerRadius = UDim.new(0, 5) })
			make("UIPadding", item, { PaddingLeft = UDim.new(0, option.color and 26 or 8) })
			if option.color then
				local dot = make("Frame", item, {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, -18, 0.5, 0),
					Size = UDim2.new(0, 12, 0, 12),
					BackgroundColor3 = option.color,
					BorderSizePixel = 0,
				})
				make("UICorner", dot, { CornerRadius = UDim.new(1, 0) })
			end
			item.MouseEnter:Connect(function()
				if not selected then
					tw(item, { BackgroundTransparency = 0.6 }, 0.1)
				end
			end)
			item.MouseLeave:Connect(function()
				if not selected then
					tw(item, { BackgroundTransparency = 1 }, 0.12)
				end
			end)
			item.Activated:Connect(function()
				sub.Visible = false
				onpick(option.value)
			end)
			subitems[#subitems + 1] = { item = item, label = option.label }
		end
		subscroll.CanvasPosition = Vector2.new(0, 0)
		relayout()
		sub.Visible = true
	end

	-- ------------------------------------------------ menu scale slider
	local SCALE_MIN, SCALE_MAX, SCALE_STEP = 50, 150, 5
	scalesub = make("Frame", main, {
		Name = "ProfileScale",
		BackgroundColor3 = theme.Card,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 188, 0, 64),
		Visible = false,
		ZIndex = 22,
	})
	make("UICorner", scalesub, { CornerRadius = UDim.new(0, 8) })
	make("UIStroke", scalesub, { Color = theme.Stroke, Thickness = 1, Transparency = 0.2 })
	make("TextLabel", scalesub, {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = theme.Dim,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = "MENU SCALE",
		Position = UDim2.new(0, 12, 0, 10),
		Size = UDim2.new(0, 90, 0, 12),
		ZIndex = 23,
	})
	local scalereadout = make("TextLabel", scalesub, {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = theme.Text,
		TextXAlignment = Enum.TextXAlignment.Right,
		Position = UDim2.new(1, -48, 0, 9),
		Size = UDim2.new(0, 36, 0, 14),
		ZIndex = 23,
	})
	local autochip = make("TextButton", scalesub, {
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		Text = "AUTO",
		Position = UDim2.new(1, -92, 0, 9),
		Size = UDim2.new(0, 40, 0, 14),
		ZIndex = 23,
	})
	local scaletrack = make("Frame", scalesub, {
		BackgroundColor3 = theme.Track,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 14, 0, 42),
		Size = UDim2.new(1, -28, 0, 4),
		ZIndex = 23,
	})
	make("UICorner", scaletrack, { CornerRadius = UDim.new(1, 0) })
	local scalefill = make("Frame", scaletrack, {
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		ZIndex = 24,
	})
	make("UICorner", scalefill, { CornerRadius = UDim.new(1, 0) })
	local scaleknob = make("Frame", scaletrack, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 12, 0, 12),
		ZIndex = 25,
	})
	make("UICorner", scaleknob, { CornerRadius = UDim.new(1, 0) })
	local scalehit = make("TextButton", scalesub, {
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Position = UDim2.new(0, 8, 0, 30),
		Size = UDim2.new(1, -16, 0, 28),
		ZIndex = 26,
	})

	local previewpercent
	local function currentpercent()
		local factor = tonumber(uistate.scale)
		return factor and math.clamp(math.floor(factor * 100 + 0.5), SCALE_MIN, SCALE_MAX) or 100
	end
	local function paintscale()
		local percent = previewpercent or currentpercent()
		local fraction = (percent - SCALE_MIN) / (SCALE_MAX - SCALE_MIN)
		scalefill.Size = UDim2.new(fraction, 0, 1, 0)
		scaleknob.Position = UDim2.new(fraction, 0, 0.5, 0)
		scalereadout.Text = tostring(percent)
		autochip.TextColor3 = tonumber(uistate.scale) and theme.Dim or theme.Accent
	end

	local draggingscale = false
	local function previewfromx(x)
		local width = scaletrack.AbsoluteSize.X
		if width <= 0 then
			return
		end
		local fraction = math.clamp((x - scaletrack.AbsolutePosition.X) / width, 0, 1)
		previewpercent = stepfromfraction(fraction, SCALE_MIN, SCALE_MAX, SCALE_STEP)
		paintscale()
	end
	local function commitscale()
		if previewpercent then
			uistate.scale = tostring(previewpercent / 100)
			previewpercent = nil
			saveui()
			applyscale()
			refreshvalues()
			paintscale()
		end
	end
	local function ispointer(input)
		return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
	end
	scalehit.InputBegan:Connect(function(input)
		if ispointer(input) then
			draggingscale = true
			previewfromx(input.Position.X)
		end
	end)
	trackConnection(sv.uis.InputChanged:Connect(function(input)
		if draggingscale and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			previewfromx(input.Position.X)
		end
	end), "profile.scale.changed")
	trackConnection(sv.uis.InputEnded:Connect(function(input)
		if draggingscale and ispointer(input) then
			draggingscale = false
			commitscale()
		end
	end), "profile.scale.ended")
	autochip.Activated:Connect(function()
		uistate.scale = "Auto"
		previewpercent = nil
		saveui()
		applyscale()
		refreshvalues()
		paintscale()
	end)

	local function showscale(row)
		if scalesub.Visible and subrow == row then
			scalesub.Visible = false
			return
		end
		sub.Visible = false
		subrow = row
		previewpercent = nil
		paintscale()
		placepanel(scalesub, 188, 64)
		scalesub.Visible = true
	end

	-- ------------------------------------------------ colour picker (floating, mouse + touch)
	local picker
	local pickerconns = {}
	local function closepicker()
		if picker then
			picker:Destroy()
			picker = nil
		end
		for _, conn in ipairs(pickerconns) do
			conn:Disconnect()
		end
		table.clear(pickerconns)
	end

	local function openpicker(initial, onchange)
		closepicker()
		local hue, sat, val = initial:ToHSV()
		local alpha = 1
		local PWD, PHT = 208, 206

		local frame = make("Frame", main, {
			Name = "ColorPicker",
			Size = UDim2.new(0, PWD, 0, PHT),
			BackgroundColor3 = theme.Card,
			BorderSizePixel = 0,
			ZIndex = 30,
			Active = true,
		})
		picker = frame
		make("UICorner", frame, { CornerRadius = UDim.new(0, 10) })
		make("UIStroke", frame, { Color = theme.Stroke, Thickness = 1, Transparency = 0.1 })

		local scale = fitscaleof(main)
		local mw, mh = main.AbsoluteSize.X / scale, main.AbsoluteSize.Y / scale
		frame.Position = UDim2.new(
			0,
			math.clamp(SUBX, 8, math.max(mw - PWD - 8, 8)),
			0,
			math.clamp(mh - PHT - 70, 8, math.max(mh - PHT - 8, 8))
		)

		local square = make("Frame", frame, {
			Position = UDim2.new(0, 10, 0, 10),
			Size = UDim2.new(1, -20, 0, 100),
			BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Active = true,
		})
		make("UICorner", square, { CornerRadius = UDim.new(0, 6) })
		local whitelayer = make("Frame", square, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
		})
		make("UIGradient", whitelayer, {
			Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }),
		})
		local blacklayer = make("Frame", square, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 2,
		})
		make("UIGradient", blacklayer, {
			Rotation = 90,
			Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
		})
		local sqknob = make("Frame", square, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 12, 0, 12),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			ZIndex = 4,
		})
		make("UICorner", sqknob, { CornerRadius = UDim.new(1, 0) })
		make("UIStroke", sqknob, { Color = Color3.fromRGB(0, 0, 0), Thickness = 1, Transparency = 0.4 })

		local huebar = make("Frame", frame, {
			Position = UDim2.new(0, 10, 0, 120),
			Size = UDim2.new(1, -20, 0, 12),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			Active = true,
		})
		make("UICorner", huebar, { CornerRadius = UDim.new(1, 0) })
		make("UIGradient", huebar, {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
				ColorSequenceKeypoint.new(0.1667, Color3.fromRGB(255, 255, 0)),
				ColorSequenceKeypoint.new(0.3333, Color3.fromRGB(0, 255, 0)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
				ColorSequenceKeypoint.new(0.6667, Color3.fromRGB(0, 0, 255)),
				ColorSequenceKeypoint.new(0.8333, Color3.fromRGB(255, 0, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
			}),
		})
		local hueknob = make("Frame", huebar, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 8, 0, 16),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			ZIndex = 3,
		})
		make("UICorner", hueknob, { CornerRadius = UDim.new(0, 3) })
		make("UIStroke", hueknob, { Color = Color3.fromRGB(0, 0, 0), Thickness = 1, Transparency = 0.4 })

		local alphabase = make("Frame", frame, {
			Position = UDim2.new(0, 10, 0, 140),
			Size = UDim2.new(1, -20, 0, 12),
			BackgroundColor3 = theme.Field,
			BorderSizePixel = 0,
			Active = true,
		})
		make("UICorner", alphabase, { CornerRadius = UDim.new(1, 0) })
		local alphafill = make("Frame", alphabase, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = initial,
			BorderSizePixel = 0,
		})
		make("UICorner", alphafill, { CornerRadius = UDim.new(1, 0) })
		make("UIGradient", alphafill, {
			Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
		})
		local alphaknob = make("Frame", alphabase, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 8, 0, 16),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			ZIndex = 3,
		})
		make("UICorner", alphaknob, { CornerRadius = UDim.new(0, 3) })
		make("UIStroke", alphaknob, { Color = Color3.fromRGB(0, 0, 0), Thickness = 1, Transparency = 0.4 })

		make("TextLabel", frame, {
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextColor3 = theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Position = UDim2.new(0, 10, 0, 168),
			Size = UDim2.new(0, 28, 0, 24),
			Text = "HEX",
		})
		local swatch = make("Frame", frame, {
			Position = UDim2.new(0, 40, 0, 172),
			Size = UDim2.new(0, 16, 0, 16),
			BackgroundColor3 = initial,
			BorderSizePixel = 0,
		})
		make("UICorner", swatch, { CornerRadius = UDim.new(0, 4) })
		local hexbox = make("TextBox", frame, {
			BackgroundTransparency = 1,
			ClearTextOnFocus = false,
			Font = Enum.Font.GothamMedium,
			TextSize = 12,
			TextColor3 = theme.Text,
			PlaceholderColor3 = theme.Dim,
			PlaceholderText = "#RRGGBBAA",
			TextXAlignment = Enum.TextXAlignment.Left,
			Position = UDim2.new(0, 62, 0, 168),
			Size = UDim2.new(0, 94, 0, 24),
			Text = "",
		})
		local pct = make("TextLabel", frame, {
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			TextSize = 11,
			TextColor3 = theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Right,
			Position = UDim2.new(1, -56, 0, 168),
			Size = UDim2.new(0, 46, 0, 24),
			Text = "100%",
		})

		local function currentcolor()
			return Color3.fromHSV(hue, sat, val)
		end

		local lastemit, emitpending = 0, false
		local function emit(final)
			local now = os.clock()
			if final or now - lastemit > 0.12 then
				lastemit = now
				emitpending = false
				pcall(onchange, currentcolor(), alpha, final == true)
			elseif not emitpending then
				emitpending = true
				task.delay(0.13, function()
					if emitpending and frame.Parent then
						emitpending = false
						lastemit = os.clock()
						pcall(onchange, currentcolor(), alpha, false)
					end
				end)
			end
		end

		local function refresh(fromhex)
			local color = currentcolor()
			square.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
			sqknob.Position = UDim2.new(sat, 0, 1 - val, 0)
			hueknob.Position = UDim2.new(hue, 0, 0.5, 0)
			alphaknob.Position = UDim2.new(alpha, 0, 0.5, 0)
			alphafill.BackgroundColor3 = color
			swatch.BackgroundColor3 = color
			pct.Text = string.format("%d%%", math.floor(alpha * 100 + 0.5))
			if not fromhex then
				hexbox.Text = string.format(
					"#%02X%02X%02X%02X",
					math.floor(color.R * 255 + 0.5),
					math.floor(color.G * 255 + 0.5),
					math.floor(color.B * 255 + 0.5),
					math.floor(alpha * 255 + 0.5)
				)
			end
		end
		refresh()

		local dragging
		local function track(input)
			if dragging == "sv" then
				local pos, size = square.AbsolutePosition, square.AbsoluteSize
				sat = math.clamp((input.Position.X - pos.X) / math.max(size.X, 1), 0, 1)
				val = 1 - math.clamp((input.Position.Y - pos.Y) / math.max(size.Y, 1), 0, 1)
			elseif dragging == "hue" then
				local pos, size = huebar.AbsolutePosition, huebar.AbsoluteSize
				hue = math.clamp((input.Position.X - pos.X) / math.max(size.X, 1), 0, 1)
			elseif dragging == "alpha" then
				local pos, size = alphabase.AbsolutePosition, alphabase.AbsoluteSize
				alpha = math.clamp((input.Position.X - pos.X) / math.max(size.X, 1), 0, 1)
			else
				return
			end
			refresh()
			emit(false)
		end

		local function begin(target)
			return function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = target
					track(input)
				end
			end
		end
		square.InputBegan:Connect(begin("sv"))
		huebar.InputBegan:Connect(begin("hue"))
		alphabase.InputBegan:Connect(begin("alpha"))

		local movedconn = sv.uis.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				track(input)
			end
		end)
		local endedconn = sv.uis.InputEnded:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				dragging = nil
				emit(true)
			end
		end)
		pickerconns[#pickerconns + 1] = trackConnection(movedconn, "mx.picker.moved")
		pickerconns[#pickerconns + 1] = trackConnection(endedconn, "mx.picker.ended")

		hexbox.FocusLost:Connect(function()
			local text = hexbox.Text:gsub("%s", ""):gsub("^#", "")
			if (#text == 6 or #text == 8) and text:match("^%x+$") then
				local r = tonumber(text:sub(1, 2), 16)
				local g = tonumber(text:sub(3, 4), 16)
				local b = tonumber(text:sub(5, 6), 16)
				hue, sat, val = Color3.fromRGB(r, g, b):ToHSV()
				if #text == 8 then
					alpha = tonumber(text:sub(7, 8), 16) / 255
				end
				refresh()
				emit(true)
			else
				refresh()
			end
		end)
	end

	-- ------------------------------------------------ rows
	local langrow, langvalue = addrow(10, "globe", "Language")
	local scalerow, scalevalue = addrow(11, "maximize-2", "Menu Scale")
	local stylerow, stylevalue = addrow(12, "palette", "Style")
	local themerow, themevalue = addrow(13, "layers", "Theme")
	local keyrow, keyvalue = addrow(14, "keyboard", "Menu Key")
	local unloadrow = addrow(15, "power", "Unload", true)

	local styleswatch = make("Frame", stylerow, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -24, 0.5, 0),
		Size = UDim2.new(0, 14, 0, 14),
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
	})
	make("UICorner", styleswatch, { CornerRadius = UDim.new(0, 4) })

	refreshvalues = function()
		langvalue.Text = i18n.Current
		local factor = tonumber(uistate.scale)
		scalevalue.Text = factor and (math.floor(factor * 100 + 0.5) .. "%") or "Auto"
		stylevalue.Text = ""
		themevalue.Text = theme.State.Preset
		keyvalue.Text = togglekey.Name
		pname.Text = username.Text
		prole.Text = handlelabel.Text
	end

	local capturing
	local function stopcapture()
		if capturing then
			capturing:Disconnect()
			capturing = nil
		end
	end
	local reserved = {
		[Enum.KeyCode.W] = true,
		[Enum.KeyCode.A] = true,
		[Enum.KeyCode.S] = true,
		[Enum.KeyCode.D] = true,
		[Enum.KeyCode.Space] = true,
		[Enum.KeyCode.Return] = true,
		[Enum.KeyCode.Slash] = true,
		[Enum.KeyCode.Tab] = true,
	}

	local function closeall()
		stopcapture()
		closepicker()
		sub.Visible = false
		scalesub.Visible = false
		catcher.Visible = false
		if popup.Visible then
			tw(popup, { Size = UDim2.new(0, PW, 0, 0) }, 0.15)
			task.delay(0.16, function()
				if not catcher.Visible then
					popup.Visible = false
				end
			end)
		end
	end

	langrow.Activated:Connect(function()
		local options = {}
		for _, name in ipairs(i18n.Languages) do
			options[#options + 1] = { label = name, value = name }
		end
		showoptions(langrow, options, i18n.Current, function(value)
			MXHUB.SetLanguage(value)
		end, { title = "LANGUAGE", search = true, width = 184 })
	end)

	scalerow.Activated:Connect(function()
		showscale(scalerow)
	end)

	stylerow.Activated:Connect(function()
		local options = {}
		for _, accent in ipairs(theme.Api.Accents()) do
			options[#options + 1] = { label = accent[1], value = accent[1], color = accent[2] }
		end
		options[#options + 1] = { label = "Custom", value = "Custom", color = theme.Accent }
		showoptions(stylerow, options, "", function(value)
			if value == "Custom" then
				openpicker(theme.Accent, function(color, _, final)
					theme.Api.Set({ Accent = color }, not final)
					refreshvalues()
				end)
				return
			end
			for _, accent in ipairs(theme.Api.Accents()) do
				if accent[1] == value then
					theme.Api.Set({ Accent = accent[2] })
				end
			end
			refreshvalues()
		end, { title = "STYLE", width = 140 })
	end)

	themerow.Activated:Connect(function()
		local options = {}
		for _, preset in ipairs(theme.Api.Presets()) do
			options[#options + 1] = { label = preset[1], value = preset[1], color = preset[2] }
		end
		showoptions(themerow, options, theme.State.Preset, function(value)
			theme.Api.Set({ Preset = value, Accent = false })
			refreshvalues()
		end, { title = "THEME", width = 150 })
	end)

	keyrow.Activated:Connect(function()
		if capturing then
			stopcapture()
			refreshvalues()
			return
		end
		sub.Visible = false
		scalesub.Visible = false
		keyvalue.Text = "Press a key..."
		capturing = trackConnection(
			sv.uis.InputBegan:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.Keyboard then
					return
				end
				stopcapture()
				local code = input.KeyCode
				if code == Enum.KeyCode.Escape or code == Enum.KeyCode.Unknown then
					refreshvalues()
					return
				end
				if reserved[code] then
					refreshvalues()
					return
				end
				togglekey = code
				uistate.menukey = code.Name
				saveui()
				refreshvalues()
			end),
			"mx.keycapture"
		)
	end)

	unloadrow.Activated:Connect(function()
		closeall()
		guifunc:DestroyGui()
	end)

	-- ------------------------------------------------ character preview (ViewportFrame, drag to rotate)
	-- ------------------------------------------------ open / close
	local function openpopup()
		refreshvalues()
		local scale = fitscaleof(main)
		local mainh = main.AbsoluteSize.Y / scale
		local mainw = main.AbsoluteSize.X / scale
		local height = math.clamp(math.min(300, mainh - 24), 120, 300)
		local x = math.clamp(POPX, 8, math.max(mainw - PW - 8, 8))
		SUBX = x + PW + 6
		popup.Position = UDim2.new(0, x, 1, -8)
		catcher.Visible = true
		popup.Size = UDim2.new(0, PW, 0, 0)
		popup.Visible = true
		tw(popup, { Size = UDim2.new(0, PW, 0, height) }, 0.2)
	end

	local footerhit = make("TextButton", userfooter, {
		Name = "ProfileButton",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 6,
	})
	local footerarrow = make("ImageLabel", userfooter, {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -6, 0.5, 0),
		Size = UDim2.new(0, 12, 0, 12),
		ImageColor3 = theme.SubText,
		ZIndex = 7,
	})
	applyicon(footerarrow, "chevron-right", 48)

	footerhit.Activated:Connect(function()
		if catcher.Visible then
			closeall()
		else
			openpopup()
		end
	end)
	catcher.Activated:Connect(closeall)
	trackConnection(
		dropshadowholder:GetPropertyChangedSignal("Visible"):Connect(function()
			if not dropshadowholder.Visible then
				closeall()
			end
		end),
		"mx.profile.hide"
	)

	refreshvalues()
end

