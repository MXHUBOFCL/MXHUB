local MX = { Tab = nil, Current = nil }
do
	local tabwidthpx = guiconfig["Tab Width"]

	local sidewidth = tabwidthpx + 10
	local sidepanel = instance.frame(main)
	sidepanel.Name = "SidePanel"
	sidepanel.BackgroundColor3 = theme.Sidebar
	sidepanel.BackgroundTransparency = 0
	sidepanel.BorderSizePixel = 0
	sidepanel.ZIndex = 0
	sidepanel.Size = UDim2.new(0, sidewidth, 1, 0)
	instance.uicorner(sidepanel).CornerRadius = uicorner.CornerRadius
	local sidefill = instance.frame(sidepanel)
	sidefill.Name = "Fill"
	sidefill.BackgroundColor3 = theme.Sidebar
	sidefill.BackgroundTransparency = 0
	sidefill.BorderSizePixel = 0
	sidefill.AnchorPoint = Vector2.new(1, 0)
	sidefill.Position = UDim2.new(1, 0, 0, 0)
	sidefill.Size = UDim2.new(0, 16, 1, 0)

	for _, glass in ipairs({ sidepanel, sidefill }) do
		local fade = instance.uigradient(glass)
		fade.Rotation = 90
		fade.Transparency = NumberSequence.new(0.08, 0.2)
	end

	glassblur(sidepanel)

	if not bgAsset then
		local contentpanel = instance.frame(main)
		contentpanel.Name = "ContentPanel"
		contentpanel.BackgroundColor3 = theme.Backdrop
		contentpanel.BorderSizePixel = 0
		contentpanel.ZIndex = -1
		contentpanel.Position = UDim2.new(0, sidewidth, 0, 0)
		contentpanel.Size = UDim2.new(1, -sidewidth, 1, 0)
		instance.uicorner(contentpanel).CornerRadius = uicorner.CornerRadius

		local contentjoin = instance.frame(main)
		contentjoin.Name = "ContentJoin"
		contentjoin.BackgroundColor3 = theme.Backdrop
		contentjoin.BorderSizePixel = 0
		contentjoin.ZIndex = -1
		contentjoin.Position = UDim2.new(0, sidewidth, 0, 0)
		contentjoin.Size = UDim2.new(0, 24, 1, 0)
	end

	local savebutton = instance.textbutton(top)
	savebutton.Name = "SaveButton"
	savebutton.Visible = false
	savebutton.Text = ""
	savebutton.AutoButtonColor = false
	savebutton.AnchorPoint = Vector2.new(0, 0.5)
	savebutton.Position = UDim2.new(0, tabwidthpx + 16, 0.5, 0)
	savebutton.Size = UDim2.new(0, 66, 0, 24)
	savebutton.BackgroundColor3 = theme.Pill
	savebutton.BorderSizePixel = 0
	instance.uicorner(savebutton).CornerRadius = UDim.new(0, 5)
	local savestroke = instance.uistroke(savebutton)
	savestroke.Color = theme.Stroke
	savestroke.Thickness = 1
	savestroke.Transparency = 0.1

	local saveicon = instance.imagelabel(savebutton)
	saveicon.Name = "Icon"
	saveicon.BackgroundTransparency = 1
	saveicon.AnchorPoint = Vector2.new(0, 0.5)
	saveicon.Position = UDim2.new(0, 10, 0.5, 0)
	saveicon.Size = UDim2.new(0, 12, 0, 12)
	saveicon.ImageColor3 = theme.SubText
	applyicon(saveicon, "save", 48)

	local savelabel = instance.textlabel(savebutton)
	savelabel.Name = "Label"
	savelabel.BackgroundTransparency = 1
	savelabel.Font = Enum.Font.GothamMedium
	savelabel.Text = "Save"
	savelabel.TextSize = 12
	savelabel.TextColor3 = theme.SubText
	savelabel.TextXAlignment = Enum.TextXAlignment.Left
	savelabel.Position = UDim2.new(0, 28, 0, 0)
	savelabel.Size = UDim2.new(1, -30, 1, 0)

	savebutton.MouseEnter:Connect(function()
		tw(savebutton, { BackgroundColor3 = theme.ElementHover }, 0.15)
		tw(savelabel, { TextColor3 = theme.Text }, 0.15)
		tw(saveicon, { ImageColor3 = theme.Accent }, 0.15)
	end)
	savebutton.MouseLeave:Connect(function()
		tw(savebutton, { BackgroundColor3 = theme.Pill }, 0.2)
		tw(savelabel, { TextColor3 = theme.SubText }, 0.2)
		tw(saveicon, { ImageColor3 = theme.SubText }, 0.2)
	end)
	savebutton.Activated:Connect(function()
		pcall(pesseffect, savebutton)
		config:savecurrent()
	end)

	local subbar = instance.frame(top)
	subbar.Name = "SubTabs"
	subbar.AnchorPoint = Vector2.new(0, 0.5)
	subbar.Position = UDim2.new(0, tabwidthpx + 16, 0.5, 0)
	subbar.Size = UDim2.new(0, 0, 0, 24)
	subbar.AutomaticSize = Enum.AutomaticSize.X
	subbar.BackgroundColor3 = theme.Pill
	subbar.BorderSizePixel = 0
	subbar.Visible = false
	instance.uicorner(subbar).CornerRadius = UDim.new(0, 5)
	local subbarstroke = instance.uistroke(subbar)
	subbarstroke.Color = theme.Stroke
	subbarstroke.Thickness = 1
	subbarstroke.Transparency = 0.1
	local subbarpad = instance.uipadding(subbar)
	subbarpad.PaddingLeft = UDim.new(0, 2)
	subbarpad.PaddingRight = UDim.new(0, 2)
	local subbarlayout = instance.uilistlayout(subbar)
	subbarlayout.FillDirection = Enum.FillDirection.Horizontal
	subbarlayout.SortOrder = Enum.SortOrder.LayoutOrder
	subbarlayout.VerticalAlignment = Enum.VerticalAlignment.Center
	subbarlayout.Padding = UDim.new(0, 2)

	local subbuttons = {}

	function MX.relayout()
		if not top.Parent then
			return
		end
		local scale = fitscaleof(top)
		local width = top.AbsoluteSize.X / scale
		local compact = width < 540
		savebutton.Size = UDim2.new(0, compact and 28 or 66, 0, 24)
		savelabel.Visible = not compact
		saveicon.Position = compact and UDim2.new(0.5, -6, 0.5, 0) or UDim2.new(0, 10, 0.5, 0)
		local subx = tabwidthpx + 16
		subbar.Position = UDim2.new(0, subx, 0.5, 0)
		local searchmax = isMobile and 110 or 150
		local used = 0
		if subbar.Visible then
			used = subbar.AbsoluteSize.X / scale + 12
		end
		local room = width - subx - used - 66 - 8
		searchbox.Size = UDim2.new(0, math.clamp(math.floor(room), 70, searchmax), 0, 24)
	end

	function MX.clearsubbar()
		if MX.Current == nil and not subbar.Visible then
			return
		end
		for _, entry in ipairs(subbuttons) do
			entry:Destroy()
		end
		table.clear(subbuttons)
		subbar.Visible = false
		MX.Current = nil
		MX.relayout()
	end

	function MX.paintsub(active)
		for index, button in ipairs(subbuttons) do
			local on = index == active
			tw(button, { BackgroundTransparency = on and 0 or 1, TextColor3 = on and theme.Text or theme.SubText }, 0.18)
		end
	end

	function MX.showsubbar(owner, names, active, pick)
		if MX.Current ~= owner or #subbuttons ~= #names then
			for _, entry in ipairs(subbuttons) do
				entry:Destroy()
			end
			table.clear(subbuttons)
			MX.Current = owner
			for index, name in ipairs(names) do
				local button = instance.textbutton(subbar)
				button.Name = "SubTab"
				button.LayoutOrder = index
				button.AutoButtonColor = false
				button.BorderSizePixel = 0
				button.BackgroundColor3 = theme.TabActive
				button.BackgroundTransparency = 1
				button.Font = Enum.Font.GothamMedium
				button.TextSize = 13
				button.Text = tostring(name)
				button.TextColor3 = theme.SubText
				button.AutomaticSize = Enum.AutomaticSize.X
				button.Size = UDim2.new(0, 0, 1, -4)
				instance.uicorner(button).CornerRadius = UDim.new(0, design.Radius.Control - 2)
				local padding = instance.uipadding(button)
				padding.PaddingLeft = UDim.new(0, 12)
				padding.PaddingRight = UDim.new(0, 12)
				button.Activated:Connect(function()
					pick(index)
				end)
				subbuttons[index] = button
			end
		end
		subbar.Visible = #names > 0
		MX.paintsub(active)
		MX.relayout()
	end

	local function queuerelayout()
		debounceResize("mx_top_relayout", MX.relayout, 0.03)
	end
	trackConnection(top:GetPropertyChangedSignal("AbsoluteSize"):Connect(queuerelayout), "mx.top.size")
	trackConnection(subbar:GetPropertyChangedSignal("AbsoluteSize"):Connect(queuerelayout), "mx.subbar.size")
	task.defer(MX.relayout)
end

