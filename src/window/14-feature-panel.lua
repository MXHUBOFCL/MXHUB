do
local featurepanel = nil
local kindicons = {
	Toggle = "toggle-right",
	Slider = "sliders-horizontal",
	Dropdown = "chevron-down",
	Keybind = "keyboard",
	Color = "palette",
	Button = "mouse-pointer-click",
}

function collectfeatures()
	local groups, byname, total = {}, {}, 0
	for _, d in ipairs(searchItems) do
		if d.Kind and d.TabName ~= "Home" and d.TabName ~= "Config" and d.TabName ~= "Settings" and d.Object and d.Object.Parent then
			local g = byname[d.TabName]
			if not g then
				g = { Name = d.TabName, Items = {} }
				byname[d.TabName] = g
				groups[#groups + 1] = g
			end
			g.Items[#g.Items + 1] = d
			total = total + 1
		end
	end
	return groups, total
end

function openfeatures()
	if featurepanel and featurepanel.Parent then
		return
	end
	local groups, total = collectfeatures()

	local overlay = instance.frame(dropshadowholder)
	overlay.Name = "FeaturesOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.45
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 50
	instance.uicorner(overlay).CornerRadius = UDim.new(0, 8)
	featurepanel = overlay

	local function closepanel()
		if overlay.Parent then
			overlay:Destroy()
		end
		featurepanel = nil
	end

	local backdrop = instance.textbutton(overlay)
	backdrop.BackgroundTransparency = 1
	backdrop.Text = ""
	backdrop.Size = UDim2.new(1, 0, 1, 0)
	backdrop.AutoButtonColor = false
	backdrop.Activated:Connect(closepanel)

	local card = instance.frame(overlay)
	card.Name = "FeaturesCard"
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Position = UDim2.new(0.5, 0, 0.5, 0)
	card.Size = UDim2.new(0.74, 0, 0.94, 0)
	card.BackgroundColor3 = theme.Card
	card.BorderSizePixel = 0
	card.Active = true
	instance.uicorner(card).CornerRadius = UDim.new(0, 14)
	local cardstroke = instance.uistroke(card)
	cardstroke.Color = theme.Stroke
	cardstroke.Thickness = 1
	local limit = instance.uisizeconstraint(card)
	limit.MaxSize = Vector2.new(520, 100000)

	local headicon = instance.imagelabel(card)
	headicon.BackgroundTransparency = 1
	headicon.Position = UDim2.new(0, 16, 0, 14)
	headicon.Size = UDim2.new(0, 18, 0, 18)
	headicon.ImageColor3 = theme.Text
	applyicon(headicon, "list-checks", 48)

	local headtitle = instance.textlabel(card)
	headtitle.BackgroundTransparency = 1
	headtitle.Position = UDim2.new(0, 44, 0, 10)
	headtitle.Size = UDim2.new(1, -90, 0, 16)
	headtitle.Font = Enum.Font.GothamBold
	headtitle.Text = "Features"
	headtitle.TextColor3 = theme.Text
	headtitle.TextSize = 14
	headtitle.TextXAlignment = Enum.TextXAlignment.Left

	local headsub = instance.textlabel(card)
	headsub.BackgroundTransparency = 1
	headsub.Position = UDim2.new(0, 44, 0, 27)
	headsub.Size = UDim2.new(1, -90, 0, 13)
	headsub.Font = Enum.Font.Gotham
	headsub.Text = string.format("%d features across %d tabs", total, #groups)
	headsub.TextColor3 = theme.SubText
	headsub.TextSize = 11
	headsub.TextXAlignment = Enum.TextXAlignment.Left

	local closebtn = instance.textbutton(card)
	closebtn.AnchorPoint = Vector2.new(1, 0)
	closebtn.Position = UDim2.new(1, -12, 0, 10)
	closebtn.Size = UDim2.new(0, 28, 0, 28)
	closebtn.BackgroundTransparency = 1
	closebtn.Text = ""
	closebtn.AutoButtonColor = false
	instance.uicorner(closebtn).CornerRadius = UDim.new(1, 0)
	local closeimg = instance.imagelabel(closebtn)
	closeimg.AnchorPoint = Vector2.new(0.5, 0.5)
	closeimg.Position = UDim2.new(0.5, 0, 0.5, 0)
	closeimg.Size = UDim2.new(0, 14, 0, 14)
	closeimg.BackgroundTransparency = 1
	closeimg.ImageColor3 = theme.SubText
	applyicon(closeimg, "x", 48)
	closebtn.MouseEnter:Connect(function()
		tw(closebtn, { BackgroundTransparency = 0, BackgroundColor3 = theme.Element }, 0.15)
	end)
	closebtn.MouseLeave:Connect(function()
		tw(closebtn, { BackgroundTransparency = 1 }, 0.15)
	end)
	closebtn.Activated:Connect(closepanel)

	local box = instance.textbox(card)
	box.Position = UDim2.new(0, 14, 0, 50)
	box.Size = UDim2.new(1, -28, 0, 30)
	box.BackgroundColor3 = theme.Pill
	box.BorderSizePixel = 0
	box.Font = Enum.Font.Gotham
	box.PlaceholderText = "Search features"
	box.PlaceholderColor3 = theme.Dim
	box.Text = ""
	box.TextColor3 = theme.Text
	box.TextSize = 12
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.ClearTextOnFocus = false
	box.ClipsDescendants = true
	instance.uicorner(box).CornerRadius = UDim.new(1, 0)
	local boxstroke = instance.uistroke(box)
	boxstroke.Color = theme.Stroke
	boxstroke.Transparency = 0.35
	local boxpad = instance.uipadding(box)
	boxpad.PaddingLeft = UDim.new(0, 32)
	boxpad.PaddingRight = UDim.new(0, 12)
	local boxicon = instance.imagelabel(box)
	boxicon.AnchorPoint = Vector2.new(0, 0.5)
	boxicon.Position = UDim2.new(0, -20, 0.5, 0)
	boxicon.Size = UDim2.new(0, 13, 0, 13)
	boxicon.BackgroundTransparency = 1
	boxicon.ImageColor3 = theme.Dim
	applyicon(boxicon, "search", 48)

	local list = instance.scrollingframe(card)
	list.Position = UDim2.new(0, 10, 0, 90)
	list.Size = UDim2.new(1, -20, 1, -98)
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.ScrollBarThickness = 3
	list.ScrollBarImageColor3 = theme.Track
	list.CanvasSize = UDim2.new(0, 0, 0, 0)
	list.AutomaticCanvasSize = Enum.AutomaticSize.Y
	list.ScrollingDirection = Enum.ScrollingDirection.Y
	local listlayout = instance.uilistlayout(list)
	listlayout.SortOrder = Enum.SortOrder.LayoutOrder
	listlayout.Padding = UDim.new(0, 1)
	local listpad = instance.uipadding(list)
	listpad.PaddingRight = UDim.new(0, 6)

	local function jumpto(d)
		closepanel()
		task.spawn(function()
			pcall(d.Select)
			pcall(d.OpenSection)
			task.wait(0.4)
			pcall(function()
				local scr, obj = d.Scroll, d.Object
				if scr and obj and obj.Parent then
					local y = (obj.AbsolutePosition.Y - scr.AbsolutePosition.Y) / fitscaleof(scr) + scr.CanvasPosition.Y - 8
					scr.CanvasPosition = Vector2.new(0, math.max(0, y))
				end
			end)
		end)
	end

	local order = 0
	local rows, headers = {}, {}
	for _, g in ipairs(groups) do
		order = order + 1
		local head = instance.frame(list)
		head.BackgroundTransparency = 1
		head.BorderSizePixel = 0
		head.LayoutOrder = order
		head.Size = UDim2.new(1, 0, 0, 34)
		local ring = instance.frame(head)
		ring.AnchorPoint = Vector2.new(0, 0.5)
		ring.Position = UDim2.new(0, 14, 0.5, 4)
		ring.Size = UDim2.new(0, 14, 0, 14)
		ring.BackgroundTransparency = 1
		instance.uicorner(ring).CornerRadius = UDim.new(1, 0)
		local ringstroke = instance.uistroke(ring)
		ringstroke.Color = theme.Text
		ringstroke.Thickness = 1.5
		local gname = instance.textlabel(head)
		gname.BackgroundTransparency = 1
		gname.Position = UDim2.new(0, 38, 0, 6)
		gname.Size = UDim2.new(1, -90, 1, -6)
		gname.Font = Enum.Font.GothamMedium
		gname.Text = string.upper(g.Name)
		gname.TextColor3 = theme.Text
		gname.TextSize = 11
		gname.TextXAlignment = Enum.TextXAlignment.Left
		local gcount = instance.textlabel(head)
		gcount.AnchorPoint = Vector2.new(1, 0)
		gcount.BackgroundTransparency = 1
		gcount.Position = UDim2.new(1, -12, 0, 6)
		gcount.Size = UDim2.new(0, 40, 1, -6)
		gcount.Font = Enum.Font.GothamMedium
		gcount.Text = tostring(#g.Items)
		gcount.TextColor3 = theme.SubText
		gcount.TextSize = 11
		gcount.TextXAlignment = Enum.TextXAlignment.Right
		local group = { Frame = head, Rows = {} }
		headers[#headers + 1] = group

		for _, d in ipairs(g.Items) do
			order = order + 1
			local row = instance.textbutton(list)
			row.LayoutOrder = order
			row.Size = UDim2.new(1, 0, 0, 42)
			row.BackgroundColor3 = theme.Element
			row.BackgroundTransparency = 1
			row.BorderSizePixel = 0
			row.Text = ""
			row.AutoButtonColor = false
			instance.uicorner(row).CornerRadius = UDim.new(0, 8)
			local ricon = instance.imagelabel(row)
			ricon.AnchorPoint = Vector2.new(0, 0.5)
			ricon.Position = UDim2.new(0, 14, 0.5, 0)
			ricon.Size = UDim2.new(0, 15, 0, 15)
			ricon.BackgroundTransparency = 1
			ricon.ImageColor3 = theme.SubText
			applyicon(ricon, kindicons[d.Kind], 48)
			local rname = instance.textlabel(row)
			rname.BackgroundTransparency = 1
			rname.Position = UDim2.new(0, 42, 0, 6)
			rname.Size = UDim2.new(1, -90, 0, 15)
			rname.Font = Enum.Font.GothamMedium
			rname.Text = d.Name
			rname.TextColor3 = theme.Text
			rname.TextSize = 12
			rname.TextXAlignment = Enum.TextXAlignment.Left
			rname.TextTruncate = Enum.TextTruncate.AtEnd
			local rsub = instance.textlabel(row)
			rsub.BackgroundTransparency = 1
			rsub.Position = UDim2.new(0, 42, 0, 22)
			rsub.Size = UDim2.new(1, -90, 0, 13)
			rsub.Font = Enum.Font.Gotham
			rsub.Text = tostring(d.SectionName or "")
			rsub.TextColor3 = theme.SubText
			rsub.TextSize = 11
			rsub.TextXAlignment = Enum.TextXAlignment.Left
			rsub.TextTruncate = Enum.TextTruncate.AtEnd
			local arrow = instance.imagelabel(row)
			arrow.AnchorPoint = Vector2.new(1, 0.5)
			arrow.Position = UDim2.new(1, -14, 0.5, 0)
			arrow.Size = UDim2.new(0, 12, 0, 12)
			arrow.BackgroundTransparency = 1
			arrow.ImageColor3 = theme.Dim
			applyicon(arrow, "arrow-up-right", 48)
			row.MouseEnter:Connect(function()
				tw(row, { BackgroundTransparency = 0 }, 0.12)
			end)
			row.MouseLeave:Connect(function()
				tw(row, { BackgroundTransparency = 1 }, 0.15)
			end)
			row.Activated:Connect(function()
				jumpto(d)
			end)
			local rec = {
				Frame = row,
				Text = string.lower(d.Name .. " " .. tostring(d.SectionName or "") .. " " .. tostring(d.TabName or "")),
			}
			rows[#rows + 1] = rec
			group.Rows[#group.Rows + 1] = rec
		end
	end

	box:GetPropertyChangedSignal("Text"):Connect(function()
		local q = string.lower(box.Text)
		for _, rec in ipairs(rows) do
			rec.Frame.Visible = q == "" or string.find(rec.Text, q, 1, true) ~= nil
		end
		for _, group in ipairs(headers) do
			local any = false
			for _, rec in ipairs(group.Rows) do
				if rec.Frame.Visible then
					any = true
					break
				end
			end
			group.Frame.Visible = any
		end
	end)
end
end

