function sections:AddSection(sectiontitletext, alwaysopen, side, sectionicon)
	local forcefull = false
	if type(sectiontitletext) == "table" then
		local opts = sectiontitletext
		forcefull = opts.Force == true
		sectiontitletext = opts.Title or opts.Name
		if alwaysopen == nil then
			alwaysopen = opts.Open ~= false and opts.AlwaysOpen ~= false
		end
		side = side or opts.Side or opts.Column
		sectionicon = sectionicon or opts.Icon
	end
	sectiontitletext = sectiontitletext or "Title"

	local rec = {
		Force = forcefull,
		Estimate = function()
			return 30
		end,
	}
	local sectiontween = TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local arrowtween = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

	local section = instance.frame(nil)
	section.Name = "Section"
	section.BackgroundColor3 = theme.Row
	section.BackgroundTransparency = rowalpha
	section.BorderSizePixel = 0
	section.ClipsDescendants = true
	section.Size = UDim2.new(1, 0, 0, 30)
	instance.uicorner(section).CornerRadius = UDim.new(0, 6)
	do
		local sectionstroke = instance.uistroke(section)
		sectionstroke.Color = theme.Stroke
		sectionstroke.Thickness = 1
		sectionstroke.Transparency = 0.45
	end
	do
		local parentframe, layoutorder = placesection(side, rec, countsection)
		section.LayoutOrder = layoutorder
		section.Parent = parentframe
	end

	local sectionreal = instance.frame(section)
	sectionreal.AnchorPoint = Vector2.new(0.5, 0)
	sectionreal.BackgroundColor3 = theme.Header
	sectionreal.BackgroundTransparency = bgAsset and 0.05 or rowalpha
	sectionreal.BorderSizePixel = 0
	sectionreal.Position = UDim2.new(0.5, 0, 0, 0)
	sectionreal.Size = UDim2.new(1, 0, 0, 30)

	local uicorner = instance.uicorner(sectionreal)
	uicorner.CornerRadius = UDim.new(0, 6)

	local sectionbutton = instance.textbutton(sectionreal)
	sectionbutton.Font = Enum.Font.SourceSans
	sectionbutton.Text = ""
	sectionbutton.BackgroundTransparency = 1
	sectionbutton.Size = UDim2.new(1, 0, 1, 0)

	local featureframe = instance.frame(sectionreal)
	featureframe.AnchorPoint = Vector2.new(1, 0.5)
	featureframe.BackgroundTransparency = 1
	featureframe.Position = UDim2.new(1, -5, 0.5, 0)
	featureframe.Size = UDim2.new(0, 20, 0, 20)

	local featureimg = instance.imagelabel(featureframe)
	applyicon(featureimg, "chevron-down", 48)
	featureimg.AnchorPoint = Vector2.new(0.5, 0.5)
	featureimg.BackgroundTransparency = 1
	featureimg.ImageColor3 = theme.SubText
	featureimg.Position = UDim2.new(0.5, 0, 0.5, 0)
	featureimg.Rotation = 0
	featureimg.Size = UDim2.new(0, 16, 0, 16)

	local sectiontitle = instance.textlabel(sectionreal)
	sectiontitle.Font = Enum.Font.GothamBold
	sectiontitle.Text = sectiontitletext
	sectiontitle.TextColor3 = theme.Text
	sectiontitle.TextSize = 13
	sectiontitle.TextXAlignment = Enum.TextXAlignment.Left
	sectiontitle.AnchorPoint = Vector2.new(0, 0.5)
	sectiontitle.BackgroundTransparency = 1
	sectiontitle.Position = UDim2.new(0, 10, 0.5, 0)
	sectiontitle.Size = UDim2.new(1, -50, 0, 13)
	sectiontitle.TextTruncate = Enum.TextTruncate.AtEnd
	sectiontitle.TextTruncate = Enum.TextTruncate.AtEnd

	local headericon
	local function setsectionicon(value)
		local has = value ~= nil and value ~= ""
		if has and not headericon then
			headericon = instance.imagelabel(sectionreal)
			headericon.Name = "SectionIcon"
			headericon.AnchorPoint = Vector2.new(0, 0.5)
			headericon.BackgroundTransparency = 1
			headericon.Position = UDim2.new(0, 10, 0.5, 0)
			headericon.Size = UDim2.new(0, 14, 0, 14)
			headericon.ImageColor3 = theme.SubText
		end
		if headericon then
			headericon.Visible = has
			if has then
				applyicon(headericon, value, 48)
			end
		end
		sectiontitle.Position = UDim2.new(0, has and 31 or 10, 0.5, 0)
		sectiontitle.Size = UDim2.new(1, has and -71 or -50, 0, 13)
	end
	setsectionicon(sectionicon)

	local sectionadd = instance.frame(section)
	sectionadd.AnchorPoint = Vector2.new(0.5, 0)
	sectionadd.BackgroundTransparency = 1
	sectionadd.BorderSizePixel = 0
	sectionadd.ClipsDescendants = true
	sectionadd.Position = UDim2.new(0.5, 0, 0, 30)
	sectionadd.Size = UDim2.new(1, 0, 0, 0)

	local uicorner8 = instance.uicorner(sectionadd)
	uicorner8.CornerRadius = UDim.new(0, 2)

	local bodypad = instance.uipadding(sectionadd)
	bodypad.PaddingTop = UDim.new(0, 5)
	bodypad.PaddingBottom = UDim.new(0, 7)
	bodypad.PaddingLeft = UDim.new(0, 7)
	bodypad.PaddingRight = UDim.new(0, 7)

	local uilistlayout2 = instance.uilistlayout(sectionadd)
	uilistlayout2.Padding = UDim.new(0, 4)
	uilistlayout2.SortOrder = Enum.SortOrder.LayoutOrder

	local color_normal = theme.Text
	local color_open = theme.Text

	local opensection = false
	local sectionResizeQueued = false

	local function updatesizesection(animate)
		if not opensection then
			return
		end

		local contentHeight = math.max(0, math.ceil(uilistlayout2.AbsoluteContentSize.Y / fitscaleof(uilistlayout2.Parent)))
		if contentHeight > 0 then
			contentHeight = contentHeight + 12
		end
		local sectionsizey = 30 + contentHeight
		sectiontitle.TextColor3 = color_open

		if animate and featureframe.Parent then
			sv.ts:Create(featureframe, arrowtween, { Rotation = 180 }):Play()
			sv.ts:Create(featureimg, arrowtween, { ImageColor3 = theme.Text }):Play()
			sv.ts:Create(section, sectiontween, { Size = UDim2.new(1, 0, 0, sectionsizey) }):Play()
			sv.ts:Create(sectionadd, sectiontween, { Size = UDim2.new(1, 0, 0, contentHeight) }):Play()
		else
			if featureframe.Parent then
				featureframe.Rotation = 180
				featureimg.ImageColor3 = theme.Text
			end
			section.Size = UDim2.new(1, 0, 0, sectionsizey)
			sectionadd.Size = UDim2.new(1, 0, 0, contentHeight)
		end

		updatesizescroll()
	end

	local function queueSectionResize()
		if sectionResizeQueued then
			return
		end

		sectionResizeQueued = true
		task.defer(function()
			sectionResizeQueued = false
			updatesizesection(false)
		end)
	end

	local function closesection(animate)
		if not opensection then
			return
		end
		opensection = false
		sectiontitle.TextColor3 = color_normal
		if animate then
			sv.ts:Create(featureframe, arrowtween, { Rotation = 0 }):Play()
			sv.ts:Create(featureimg, arrowtween, { ImageColor3 = theme.SubText }):Play()
			sv.ts:Create(section, sectiontween, { Size = UDim2.new(1, 0, 0, 30) }):Play()
			sv.ts:Create(sectionadd, sectiontween, { Size = UDim2.new(1, 0, 0, 0) }):Play()
		else
			featureframe.Rotation = 0
			featureimg.ImageColor3 = theme.SubText
			section.Size = UDim2.new(1, 0, 0, 30)
			sectionadd.Size = UDim2.new(1, 0, 0, 0)
		end
	end

	sectionbutton.Activated:Connect(function()
		if opensection then
			closesection(true)
		else
			opensection = true
			updatesizesection(true)
		end
	end)

	if alwaysopen then
		opensection = true
		updatesizesection(false)
	end

	uilistlayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(queueSectionResize)

	local items = {}
	function items:SetIcon(value)
		setsectionicon(value)
	end
	local countitem = 0

	rec.Estimate = function()
		if opensection then
			return 30 + countitem * 49
		end
		return 30
	end

	function items:PromoteToFull()
		promotesection(section, rec)
	end
	local currentSubSection = nil
	local buildStartTime = 0
	local frameThreshold = 0.012
	local function yieldbuild()
		if buildStartTime == 0 then
			buildStartTime = tick()
		end
		if (tick() - buildStartTime) > frameThreshold then
			task.wait()
			buildStartTime = tick()
		end
	end

	local function registerSearchItem(title, object, kind)
		title = tostring(title or "Item")

		local path = tabconfig.Name .. "/" .. sectiontitletext
		if currentSubSection then
			path = path .. "/" .. currentSubSection
		end
		path = path .. "/" .. title

		table.insert(searchItems, {
			Name = title,
			Path = path,
			TabIndex = scrollayers.LayoutOrder,
			Page = scrollayers,
			Section = section,
			Object = object,
			Kind = kind,
			TabName = tabconfig.Name,
			SectionName = sectiontitletext,
			Select = selecttab,
			Scroll = scrollayers,
			IsOpen = function()
				return opensection
			end,
			OpenSection = function()
				if not opensection then
					opensection = true
					updatesizesection()
				end
			end,
			CloseSection = function()
				closesection(false)
			end,
		})
	end

