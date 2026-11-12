function items:AddDropdown(dropdownconfig)
	dropdownconfig = dropdownconfig or {}
	dropdownconfig.Title = dropdownconfig.Title or "Title"
	dropdownconfig.Multi = dropdownconfig.Multi or false
	dropdownconfig.Advanced = dropdownconfig.Advanced or false
	dropdownconfig.Options = dropdownconfig.Options or {}
	dropdownconfig.Callback = dropdownconfig.Callback or function() end
	local multi = dropdownconfig.Multi

	local function normalize(value)
		if multi then
			local out = {}
			if type(value) == "table" then
				for _, v in ipairs(value) do
					out[#out + 1] = v
				end
			end
			return out
		end
		if type(value) == "table" then
			return value[1]
		end
		if value == "" then
			return nil
		end
		return value
	end

	local function sameselection(a, b)
		if multi then
			if #a ~= #b then
				return false
			end
			for i = 1, #a do
				if a[i] ~= b[i] then
					return false
				end
			end
			return true
		end
		return a == b
	end

	local configkey = keyfor("Dropdown_", dropdownconfig)
	local hubdefault = normalize(dropdownconfig.Default)
	local nosave = dropdownconfig.NoSave == true

	local function savedpref()
		if nosave then
			return normalize(hubdefault)
		end
		local v = config.data[configkey]
		if v ~= nil then
			return normalize(v)
		end
		if config.loaded then
			return normalize(nil)
		end
		return normalize(hubdefault)
	end

	local dropdownfunc = {
		Value = savedpref(),
		Options = dropdownconfig.Options,
		DefaultValue = normalize(hubdefault),
	}

	local function parseOption(option)
		local label, desc, img, value

		if typeof(option) == "table" then
			if option.Label and option.Value ~= nil then
				label = tostring(option.Label)
				value = option.Value
				desc = option.Description or option.Desc or option[2]
				img = option.Image or option.Icon or option[3]
			else
				label = tostring(option[1] or option.Title or option.Name or "Option")
				desc = option[2] or option.Description or option.Desc
				img = option[3] or option.Image or option.Icon
				value = option.Value ~= nil and option.Value or label
			end
		else
			label = tostring(option)
			value = option
		end

		if img and type(img) == "number" then
			img = "rbxassetid://" .. tostring(img)
		elseif img and type(img) == "string" and img ~= "" and not img:find("rbxassetid://") then
			img = "rbxassetid://" .. img
		end

		return label, desc, img, value
	end

	local dropdown = instance.frame(sectionadd)
	dropdown.Name = "Dropdown"
	dropdown.BorderSizePixel = 0
	dropdown.LayoutOrder = countitem
	dropdown.Size = UDim2.new(1, 0, 0, 60)
	roundbg(dropdown, 4, theme.Row)

	local dropdownbutton = instance.textbutton(dropdown)
	dropdownbutton.Name = "ToggleButton"
	dropdownbutton.Text = ""
	dropdownbutton.BackgroundTransparency = 1
	dropdownbutton.Size = UDim2.new(1, 0, 1, 0)

	local dropdowntitle = instance.textlabel(dropdown)
	dropdowntitle.Name = "DropdownTitle"
	dropdowntitle.Font = Enum.Font.GothamMedium
	dropdowntitle.Text = dropdownconfig.Title
	dropdowntitle.TextColor3 = theme.Text
	dropdowntitle.TextSize = 12
	dropdowntitle.TextXAlignment = Enum.TextXAlignment.Left
	dropdowntitle.TextYAlignment = Enum.TextYAlignment.Top
	dropdowntitle.TextTruncate = Enum.TextTruncate.AtEnd
	dropdowntitle.BackgroundTransparency = 1
	dropdowntitle.Position = UDim2.new(0, 10, 0, 8)
	dropdowntitle.Size = UDim2.new(1, -20, 0, 13)

	local selectoptionsframe = instance.frame(dropdown)
	selectoptionsframe.Name = "SelectOptionsFrame"
	selectoptionsframe.AnchorPoint = Vector2.new(0, 0)
	selectoptionsframe.Position = UDim2.new(0, 10, 0, 26)
	selectoptionsframe.Size = UDim2.new(1, -20, 0, 26)
	selectoptionsframe.LayoutOrder = countdropdown
	roundbg(selectoptionsframe, 5, Color3.fromRGB(15, 15, 18))

	local optionselecting = instance.textlabel(selectoptionsframe)
	optionselecting.Name = "OptionSelecting"
	optionselecting.Font = Enum.Font.GothamMedium
	optionselecting.Text = dropdownconfig.Multi and "Select Options" or "Select Option"
	optionselecting.TextColor3 = Color3.fromRGB(255, 255, 255)
	optionselecting.TextSize = 11
	optionselecting.TextTransparency = 0.5
	optionselecting.TextXAlignment = Enum.TextXAlignment.Left
	optionselecting.AnchorPoint = Vector2.new(0, 0.5)
	optionselecting.BackgroundTransparency = 1
	optionselecting.Position = UDim2.new(0, 9, 0.5, 0)
	optionselecting.Size = UDim2.new(1, -30, 1, -8)

	local optionimg = instance.imagelabel(selectoptionsframe)
	optionimg.Name = "OptionImg"
	applyicon(optionimg, "chevron-down", 48)
	optionimg.ImageColor3 = theme.Text
	optionimg.AnchorPoint = Vector2.new(0.5, 0.5)
	optionimg.BackgroundTransparency = 1
	optionimg.Position = UDim2.new(1, -14, 0.5, 0)
	optionimg.Rotation = 0
	optionimg.Size = UDim2.new(0, 16, 0, 16)

	local basey = 60
	local description = contenttext(dropdownconfig)
	local ix = elementiconx(dropdownconfig)
	iconapi(dropdownfunc, elementicon(dropdown, dropdownconfig.Icon, 16))
	dropdowntitle.Position = UDim2.new(0, ix, 0, 8)
	dropdowntitle.Size = UDim2.new(1, -(ix + 10), 0, 13)
	if description then
		local _, measure = attachcontent(dropdown, description, ix, 25, 10)
		local function relayout()
			local fieldy = 25 + measure() + 6
			selectoptionsframe.Position = UDim2.new(0, 10, 0, fieldy)
			basey = fieldy + 26 + 8
			dropdown.Size = UDim2.new(1, 0, 0, basey)
		end
		relayout()
		watchwidth(dropdown, relayout)
	end

	local dropdowncontainer = instance.frame(dropdownfolder)
	dropdowncontainer.Size = UDim2.new(1, 0, 1, 0)
	dropdowncontainer.BackgroundTransparency = 1

	local searchbox = instance.textbox(dropdowncontainer)
	searchbox.Name = "SearchBox"
	searchbox.PlaceholderText = "Search"
	searchbox.Font = Enum.Font.GothamBold
	searchbox.Text = ""
	searchbox.TextSize = 12
	searchbox.TextColor3 = Color3.fromRGB(255, 255, 255)
	searchbox.BackgroundColor3 = theme.Element
	searchbox.BackgroundTransparency = 0
	searchbox.BorderSizePixel = 0
	searchbox.Size = UDim2.new(1, 0, 0, 25)
	searchbox.Position = UDim2.new(0, 0, 0, 0)
	searchbox.ClearTextOnFocus = false

	local scrollselect = instance.scrollingframe(dropdowncontainer)
	scrollselect.Name = "ScrollSelect"
	scrollselect.Size = UDim2.new(1, 0, 1, -30)
	scrollselect.Position = UDim2.new(0, 0, 0, 30)
	scrollselect.ScrollBarImageColor3 = theme.Track
	scrollselect.ScrollBarImageTransparency = 0.2
	scrollselect.BorderSizePixel = 0
	scrollselect.BackgroundTransparency = 1
	scrollselect.ScrollBarThickness = 3
	scrollselect.CanvasSize = UDim2.new(0, 0, 0, 0)

	local uilistlayout = instance.uilistlayout(scrollselect)
	uilistlayout.Padding = UDim.new(0, 3)
	uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder

	uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollselect.CanvasSize = UDim2.new(0, 0, 0, math.ceil(uilistlayout.AbsoluteContentSize.Y / fitscaleof(scrollselect)))
	end)

	local optionlist = {}
	local built = false

	local function isselected(value)
		if multi then
			return table.find(dropdownfunc.Value, value) ~= nil
		end
		return dropdownfunc.Value ~= nil and dropdownfunc.Value == value
	end

	local function paint(entry, instant)
		local drop = entry.frame
		if not drop or not drop.Parent then
			return
		end
		local selected = isselected(entry.value)
		local targetSize = selected and UDim2.new(0, 1, 0, 12) or UDim2.new(0, 0, 0, 0)
		local targetStroke = selected and 0 or 1
		local targetBackground = selected and 0 or 1
		local stroke = drop.ChooseFrame:FindFirstChild("UIStroke")

		if instant then
			drop.ChooseFrame.Size = targetSize
			if stroke then
				stroke.Transparency = targetStroke
			end
			drop.Bg.ImageTransparency = targetBackground
		else
			local info = TweenInfo.new(selected and 0.2 or 0.1)
			sv.ts:Create(drop.ChooseFrame, info, { Size = targetSize }):Play()
			if stroke then
				sv.ts:Create(stroke, info, { Transparency = targetStroke }):Play()
			end
			sv.ts:Create(drop.Bg, info, { ImageTransparency = targetBackground }):Play()
		end
	end

	local function updatetext()
		local texts, matched = {}, {}
		for _, entry in ipairs(optionlist) do
			if isselected(entry.value) then
				texts[#texts + 1] = entry.label
				matched[entry.value] = true
			end
		end

		local picks = multi and dropdownfunc.Value or { dropdownfunc.Value }
		for _, v in ipairs(picks) do
			if v ~= nil and not matched[v] then
				texts[#texts + 1] = tostring(v)
			end
		end
		optionselecting.Text = (#texts == 0) and (multi and "Select Options" or "Select Option")
			or table.concat(texts, ", ")
	end

	local function fire()
		if typeof(dropdownconfig.Callback) ~= "function" then
			return
		end
		elevate()
		local ok, err
		if multi then
			ok, err = pcall(dropdownconfig.Callback, normalize(dropdownfunc.Value))
		else
			ok, err = pcall(dropdownconfig.Callback, dropdownfunc.Value ~= nil and tostring(dropdownfunc.Value) or "")
		end
		if not ok then
			warn("Dropdown Callback error:", err)
		end
	end

	local function apply(value, instant, save, dofire)
		elevate()
		dropdownfunc.Value = normalize(value)
		if save then
			if not nosave then
				config.data[configkey] = multi and normalize(dropdownfunc.Value) or dropdownfunc.Value
				autosave.touch()
			end
		end
		for _, entry in ipairs(optionlist) do
			paint(entry, instant)
		end
		updatetext()
		if dofire then
			fire()
		end
	end

	local searchvisible = false
	local function contentheight()
		local total, shown = 0, 0
		for _, entry in ipairs(optionlist) do
			if entry.frame and entry.frame.Visible then
				total = total + entry.frame.Size.Y.Offset + 3
				shown = shown + 1
			end
		end
		if shown == 0 then
			total = 33
		end
		return total - 3 + 8 + (searchvisible and 30 or 0)
	end

	local function applyfilter()
		if not built then
			return
		end
		local query = string.lower(searchbox.Text)
		for _, entry in ipairs(optionlist) do
			if entry.frame then
				entry.frame.Visible = query == ""
					or string.find(string.lower(entry.label), query, 1, true) ~= nil
					or (entry.desc ~= nil and string.find(string.lower(tostring(entry.desc)), query, 1, true) ~= nil)
			end
		end
		scrollselect.CanvasSize = UDim2.new(0, 0, 0, math.ceil(uilistlayout.AbsoluteContentSize.Y / fitscaleof(scrollselect)))
		refitdropdownpopup(selectoptionsframe, contentheight())
	end

	searchbox:GetPropertyChangedSignal("Text"):Connect(applyfilter)

	local function buildoption(entry)
		local useAdvanced = dropdownconfig.Advanced and (entry.desc or entry.img)
		local height = useAdvanced and 30 or (isMobile and 36 or 30)
		local leftPadding = entry.img and 42 or 8
		local textX = useAdvanced and math.max(8, leftPadding - 10) or leftPadding

		local optionframe = templates.DropdownOption:Clone()
		optionframe.Size = UDim2.new(1, 0, 0, height)
		optionframe.Parent = scrollselect

		local optionbutton = optionframe.OptionButton
		local optiontext = optionframe.OptionText
		optiontext.Text = entry.label
		optiontext.Position = UDim2.new(0, textX, 0, useAdvanced and 1 or math.floor((height - 13) / 2))
		optiontext.Size = UDim2.new(1, -(textX + 20), 0, 13)

		if entry.img then
			local icon = instance.imagelabel(optionframe)
			icon.Name = "OptionIcon"
			icon.Image = entry.img
			icon.BackgroundTransparency = 1
			icon.Position = UDim2.new(0, 8, 0.5, -14)
			icon.Size = UDim2.new(0, 28, 0, 28)
			icon.ScaleType = Enum.ScaleType.Fit
			instance.uicorner(icon).CornerRadius = UDim.new(0, 5)
		end

		if useAdvanced and entry.desc then
			local optiondesc = instance.textlabel(optionframe)
			optiondesc.Name = "OptionDesc"
			optiondesc.Font = Enum.Font.GothamBold
			optiondesc.Text = tostring(entry.desc)
			optiondesc.TextSize = 10
			optiondesc.TextTransparency = 0.3
			optiondesc.TextColor3 = Color3.fromRGB(255, 255, 255)
			optiondesc.Position = UDim2.new(0, textX, 0, 11)
			optiondesc.Size = UDim2.new(1, -(textX + 20), 0, 10)
			optiondesc.BackgroundTransparency = 1
			optiondesc.TextXAlignment = Enum.TextXAlignment.Left
			optiondesc.TextTruncate = Enum.TextTruncate.AtEnd
		end

		optionbutton.Activated:Connect(function()
			if multi then
				local sel = normalize(dropdownfunc.Value)
				local idx = table.find(sel, entry.value)
				if idx then
					table.remove(sel, idx)
				else
					table.insert(sel, entry.value)
				end
				apply(sel, false, true, true)
			else
				apply(entry.value, false, true, true)
				closedropdownpopup()
			end
		end)

		entry.frame = optionframe
	end

	local function buildall()
		if built then
			return
		end
		built = true
		for _, entry in ipairs(optionlist) do
			buildoption(entry)
			paint(entry, true)
		end
	end

	local function setoptions(list)
		for _, entry in ipairs(optionlist) do
			if entry.frame then
				entry.frame:Destroy()
			end
		end
		optionlist = {}
		for _, option in ipairs(list or {}) do
			local label, desc, img, value = parseOption(option)
			local entry = { label = label, desc = desc, img = img, value = value }
			optionlist[#optionlist + 1] = entry
			if built then
				buildoption(entry)
			end
		end
		dropdownfunc.Options = list or {}
	end

	dropdownbutton.Activated:Connect(function()
		buildall()

		searchvisible = #optionlist > 8
		searchbox.Text = ""
		searchbox.Visible = searchvisible
		scrollselect.Position = UDim2.new(0, 0, 0, searchvisible and 30 or 4)
		scrollselect.Size = UDim2.new(1, 0, 1, searchvisible and -30 or -8)
		applyfilter()
		opendropdownpopup(selectoptionsframe.LayoutOrder, selectoptionsframe, contentheight(), optionimg)
	end)

	function dropdownfunc:Clear()
		setoptions({})
		dropdownfunc.Value = normalize(nil)
		updatetext()
	end

	function dropdownfunc:AddOption(option)
		local label, desc, img, value = parseOption(option)
		local entry = { label = label, desc = desc, img = img, value = value }
		optionlist[#optionlist + 1] = entry
		if built then
			buildoption(entry)
			paint(entry, true)
			applyfilter()
		end
		updatetext()
	end

	function dropdownfunc:Set(value, instant)
		apply(value, instant, true, true)
	end

	function dropdownfunc:SetValue(val)
		self:Set(val)
	end

	function dropdownfunc:GetValue()
		return self.Value
	end

	function dropdownfunc:SetValues(newlist, selecting, instant)
		setoptions(newlist or {})
		apply(selecting, instant, true, true)
		applyfilter()
	end

	function dropdownfunc:Refresh(newlist, keep)
		setoptions(newlist or {})
		if keep == false then
			local cleared = normalize(nil)
			apply(cleared, true, true, not sameselection(normalize(dropdownfunc.Value), cleared))
		else
			apply(dropdownfunc.Value, true, false, false)
		end
		applyfilter()
	end

	function dropdownfunc:LoadValue(value)
		self:Set(value, true)
	end

	function dropdownfunc:ResetValue()
		self:Set(normalize(hubdefault))
	end

	setoptions(dropdownconfig.Options)
	apply(dropdownfunc.Value, true, true, true)

	countitem = countitem + 1
	countdropdown = countdropdown + 1
	yieldbuild()
	if not nosave then
		config.elements[configkey] = dropdownfunc
	end
	registerSearchItem(dropdownconfig.Title, dropdown, "Dropdown")
	return dropdownfunc
end
