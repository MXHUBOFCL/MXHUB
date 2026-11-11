local hasActiveTab = false

function tabs:AddHeaderChip(chipconfig)
	if type(chipconfig) ~= "table" then
		chipconfig = { Text = tostring(chipconfig or "") }
	end
	local holder = top:FindFirstChild("Chips")
	if not holder then
		return nil
	end

	local chip = instance.frame(holder)
	chip.Name = "Chip"
	chip.LayoutOrder = tonumber(chipconfig.LayoutOrder) or #holder:GetChildren()
	chip.BackgroundColor3 = theme.Pill
	chip.BackgroundTransparency = 0.15
	chip.BorderSizePixel = 0
	chip.Size = UDim2.new(0, 0, 0, 22)
	chip.AutomaticSize = Enum.AutomaticSize.X
	instance.uicorner(chip).CornerRadius = UDim.new(1, 0)

	local chipstroke = instance.uistroke(chip)
	chipstroke.Color = theme.Stroke
	chipstroke.Thickness = 1
	chipstroke.Transparency = 0.35

	local chippad = instance.uipadding(chip)
	chippad.PaddingLeft = UDim.new(0, 7)
	chippad.PaddingRight = UDim.new(0, 8)

	local chiplayout = instance.uilistlayout(chip)
	chiplayout.FillDirection = Enum.FillDirection.Horizontal
	chiplayout.Padding = UDim.new(0, 4)
	chiplayout.SortOrder = Enum.SortOrder.LayoutOrder
	chiplayout.VerticalAlignment = Enum.VerticalAlignment.Center

	if chipconfig.Icon and chipconfig.Icon ~= "" then
		local chipicon = instance.imagelabel(chip)
		chipicon.LayoutOrder = 1
		chipicon.Size = UDim2.new(0, 12, 0, 12)
		chipicon.BackgroundTransparency = 1
		chipicon.ImageColor3 = chipconfig.Color or theme.SubText
		applyicon(chipicon, chipconfig.Icon, 48)
	end

	local chiptext = instance.textlabel(chip)
	chiptext.LayoutOrder = 2
	chiptext.Font = Enum.Font.GothamBold
	chiptext.TextSize = 11
	chiptext.TextColor3 = theme.SubText
	chiptext.BackgroundTransparency = 1
	chiptext.BorderSizePixel = 0
	chiptext.AutomaticSize = Enum.AutomaticSize.X
	chiptext.Size = UDim2.new(0, 0, 1, 0)
	chiptext.Text = tostring(chipconfig.Text or "")

	local chipobj = {}
	function chipobj:SetText(text)
		chiptext.Text = tostring(text)
	end
	function chipobj:SetVisible(visible)
		chip.Visible = visible and true or false
	end
	function chipobj:Destroy()
		chip:Destroy()
	end
	return chipobj
end

function tabs:AddTabHeader(headertext, order)
	headertext = tostring(headertext or "")
	local rail = guiconfig.IconRail == true
	local first = true
	for _, child in ipairs(scrolltab:GetChildren()) do
		if child:IsA("GuiObject") then
			first = false
			break
		end
	end

	local header = instance.frame(scrolltab)
	header.Name = "TabHeader"
	header.BackgroundTransparency = 1
	header.BorderSizePixel = 0
	header.LayoutOrder = tonumber(order) or (counttab * 2 - 1)
	header.Size = UDim2.new(1, -6, 0, rail and 8 or (first and 16 or 24))

	local label, line
	if rail then
		line = instance.frame(header)
		line.Name = "Divider"
		line.AnchorPoint = Vector2.new(0.5, 0.5)
		line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		line.BackgroundTransparency = 0.85
		line.BorderSizePixel = 0
		line.Position = UDim2.new(0.5, 0, 0.5, 0)
		line.Size = UDim2.new(0.6, 0, 0, 1)
		line.Visible = not first
	else
		label = instance.textlabel(header)
		label.Name = "HeaderText"
		label.Font = Enum.Font.GothamBold
		label.Text = headertext
		label.TextColor3 = theme.SubText
		label.TextTransparency = 0.2
		label.TextSize = 11
		label.TextTruncate = Enum.TextTruncate.AtEnd
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Bottom
		label.BackgroundTransparency = 1
		label.BorderSizePixel = 0
		label.Position = UDim2.new(0, 8, 0, 0)
		label.Size = UDim2.new(1, -14, 1, -4)
	end

	local headerfunc = {}
	function headerfunc:SetText(newtext)
		if label then
			label.Text = tostring(newtext)
		end
	end
	function headerfunc:Destroy()
		header:Destroy()
	end
	return headerfunc
end

function tabs:_ensurecategory(cfg)
	local category = cfg.Category or cfg.Group
	if category == nil or category == "" or category == lasttabcategory then
		return
	end
	lasttabcategory = category
	tabs:AddTabHeader(category)
end

function tabs:AddTabLink(linkconfig)
	linkconfig = linkconfig or {}
	tabs:_ensurecategory(linkconfig)
	local rail = guiconfig.IconRail == true

	local entry = instance.frame(scrolltab)
	entry.Name = "TabLink"
	entry.BorderSizePixel = 0
	entry.LayoutOrder = counttab * 2
	entry.Size = UDim2.new(1, -6, 0, rail and 32 or 26)
	local entrybg = roundbg(entry, 4, theme.TabActive)
	entrybg.ImageTransparency = 1

	local entrybutton = instance.textbutton(entry)
	entrybutton.Name = "TabButton"
	entrybutton.Text = ""
	entrybutton.BackgroundTransparency = 1
	entrybutton.Size = UDim2.new(1, 0, 1, 0)

	local hasicon = linkconfig.Icon ~= nil and linkconfig.Icon ~= ""
	local entryicon
	if hasicon then
		entryicon = instance.imagelabel(entry)
		entryicon.Name = "TabIcon"
		entryicon.AnchorPoint = Vector2.new(rail and 0.5 or 0, 0.5)
		entryicon.Position = UDim2.new(rail and 0.5 or 0, rail and 0 or 8, 0.5, 0)
		entryicon.Size = rail and UDim2.new(0, 18, 0, 18) or UDim2.new(0, 14, 0, 14)
		entryicon.BackgroundTransparency = 1
		entryicon.ImageColor3 = theme.SubText
		applyicon(entryicon, linkconfig.Icon, 48)
	end

	local entryname
	if not rail then
		entryname = instance.textlabel(entry)
		entryname.Name = "LinkName"
		entryname.Font = Enum.Font.GothamBold
		entryname.Text = tostring(linkconfig.Name or linkconfig.Title or "Link")
		entryname.TextColor3 = theme.SubText
		entryname.TextSize = 13
		entryname.TextTruncate = Enum.TextTruncate.AtEnd
		entryname.TextXAlignment = Enum.TextXAlignment.Left
		entryname.BackgroundTransparency = 1
		entryname.BorderSizePixel = 0
		entryname.Size = UDim2.new(1, -(hasicon and 28 or 10), 1, 0)
		entryname.Position = UDim2.new(0, hasicon and 26 or 8, 0, 0)
	end

	local function glow(on)
		tw(entrybg, { ImageTransparency = on and 0.7 or 1 }, 0.15)
		if entryname then
			tw(entryname, { TextColor3 = on and theme.Text or theme.SubText }, 0.15)
		end
		if entryicon then
			tw(entryicon, { ImageColor3 = on and theme.Text or theme.SubText }, 0.15)
		end
	end
	entrybutton.MouseEnter:Connect(function()
		glow(true)
	end)
	entrybutton.MouseLeave:Connect(function()
		glow(false)
	end)

	entrybutton.Activated:Connect(function()
		pcall(pesseffect, entry)
		if typeof(linkconfig.Callback) == "function" then
			local ok, err = pcall(linkconfig.Callback)
			if not ok then
				warn("Tab link Callback error:", err)
			end
		elseif linkconfig.Link then
			if clipboardwrite(linkconfig.Link) then
				MXHUB:Notify({
					Title = tostring(linkconfig.Name or "Link"),
					Content = "Link copied to clipboard.",
					Duration = 3,
				})
			end
		end
	end)

	counttab = counttab + 1
	local linkfunc = {}
	function linkfunc:Destroy()
		entry:Destroy()
	end
	return linkfunc
end

