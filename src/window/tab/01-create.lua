function tabs:AddTab(tabconfig)
	tabconfig = tabconfig or {}
	tabconfig.Name = tabconfig.Name or "Tab"
	if not tabconfig.Hidden then
		tabs:_ensurecategory(tabconfig)
	end

	local tabIndex = counttab

	local layoutOrder = tonumber(tabconfig.LayoutOrder) or (tabIndex * 2)
	local isFirstTab = not hasActiveTab and tabconfig.StartActive ~= false
	if isFirstTab then
		hasActiveTab = true
	end

	local scrollayers = instance.scrollingframe(layersfolder)
	scrollayers.Name = "ScrolLayers"
	scrollayers.ScrollBarImageColor3 = theme.Bar
	scrollayers.ScrollBarImageTransparency = 0.15
	scrollayers.ScrollBarThickness = 3
	scrollayers.VerticalScrollBarInset = Enum.ScrollBarInset.None
	scrollayers.Active = true
	scrollayers.LayoutOrder = layoutOrder
	scrollayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	scrollayers.BackgroundTransparency = 1
	scrollayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	scrollayers.BorderSizePixel = 0
	scrollayers.Size = UDim2.new(1, 0, 1, 0)

	local uilistlayout1 = instance.uilistlayout(scrollayers)
	uilistlayout1.Padding = UDim.new(0, 3)
	uilistlayout1.SortOrder = Enum.SortOrder.LayoutOrder

	local function updatesizescroll()
		scrollayers.CanvasSize = UDim2.new(0, 0, 0, math.ceil(uilistlayout1.AbsoluteContentSize.Y / fitscaleof(scrollayers)) + 8)
	end

	uilistlayout1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updatesizescroll)

	local gridon = guiconfig.Grid ~= false and tabconfig.Grid ~= false and tabconfig.Columns ~= 1
	local gridmin = tonumber(tabconfig.GridMinWidth or guiconfig.GridMinWidth) or 380
	local gridgap = tonumber(guiconfig.GridGap) or 6
	local rowcount = 0
	local holders = {}
	local activeholder = nil

	local function applyholdermode(holder)
		local wide = gridon and scrollayers.AbsoluteSize.X / fitscaleof(scrollayers) >= gridmin
		if holder.Wide == wide then
			return
		end
		holder.Wide = wide
		if wide then
			holder.Layout.FillDirection = Enum.FillDirection.Horizontal
			holder.Layout.Padding = UDim.new(0, gridgap)
			holder.Left.Size = UDim2.new(0.5, -gridgap / 2, 0, 0)
			holder.Right.Size = UDim2.new(0.5, -gridgap / 2, 0, 0)
			holder.Left.Visible = true
			holder.Right.Visible = true
		else
			holder.Layout.FillDirection = Enum.FillDirection.Vertical
			holder.Layout.Padding = UDim.new(0, 5)
			holder.Left.Size = UDim2.new(1, 0, 0, 0)
			holder.Right.Size = UDim2.new(1, 0, 0, 0)
			holder.Left.Visible = holder.LeftCount > 0
			holder.Right.Visible = holder.RightCount > 0
		end
	end

	local function touchholder(holder)
		holder.Wide = nil
		applyholdermode(holder)
	end

	local function newholder()
		rowcount = rowcount + 1
		local holder = { LeftCount = 0, RightCount = 0, LeftRecs = {}, RightRecs = {} }
		local frame = instance.frame(scrollayers)
		frame.Name = "Columns"
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.LayoutOrder = rowcount * 10
		frame.Size = UDim2.new(1, 0, 0, 0)
		frame.AutomaticSize = Enum.AutomaticSize.Y
		holder.Frame = frame
		holder.Layout = instance.uilistlayout(frame)
		holder.Layout.SortOrder = Enum.SortOrder.LayoutOrder
		holder.Layout.VerticalAlignment = Enum.VerticalAlignment.Top

		local function makecolumn(name, order)
			local column = instance.frame(frame)
			column.Name = name
			column.BackgroundTransparency = 1
			column.BorderSizePixel = 0
			column.LayoutOrder = order
			column.Size = UDim2.new(0.5, -gridgap / 2, 0, 0)
			column.AutomaticSize = Enum.AutomaticSize.Y
			local columnlayout = instance.uilistlayout(column)
			columnlayout.SortOrder = Enum.SortOrder.LayoutOrder
			columnlayout.Padding = UDim.new(0, 5)
			return column
		end

		holder.Left = makecolumn("Left", 1)
		holder.Right = makecolumn("Right", 2)
		holders[#holders + 1] = holder
		applyholdermode(holder)
		return holder
	end

	scrollayers:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		for _, holder in ipairs(holders) do
			applyholdermode(holder)
		end
	end)

	local function estimateheight(recs)
		local total = 0
		for _, rec in ipairs(recs) do
			if not rec.Removed then
				total = total + rec.Estimate() + 5
			end
		end
		return total
	end

	local function placesection(side, rec, legacyorder)
		side = tostring(side or ""):lower()
		if not gridon then
			return scrollayers, legacyorder
		end
		if rec.Force and (side == "full" or side == "wide" or side == "both" or side == "all") then
			rowcount = rowcount + 1
			activeholder = nil
			return scrollayers, rowcount * 10
		end
		local holder = activeholder
		if not holder then
			holder = newholder()
			activeholder = holder
		end
		local column
		if side == "left" or side == "l" then
			column = "Left"
		elseif side == "right" or side == "r" then
			column = "Right"
		else
			column = estimateheight(holder.LeftRecs) <= estimateheight(holder.RightRecs) and "Left" or "Right"
		end
		rec.Holder = holder
		rec.Column = column
		local order
		if column == "Left" then
			holder.LeftCount = holder.LeftCount + 1
			order = holder.LeftCount
			table.insert(holder.LeftRecs, rec)
		else
			holder.RightCount = holder.RightCount + 1
			order = holder.RightCount
			table.insert(holder.RightRecs, rec)
		end
		touchholder(holder)
		return holder[column], order
	end

	local function promotesection(section, rec)
		if not gridon or not rec or section.Parent == scrollayers then
			return
		end
		local holder = rec.Holder
		rec.Removed = true
		if holder then
			local order = holder.Frame.LayoutOrder + 1
			if rec.Column == "Left" then
				holder.LeftCount = holder.LeftCount - 1
			else
				holder.RightCount = holder.RightCount - 1
			end
			if activeholder == holder then
				activeholder = nil
			end
			section.LayoutOrder = order
			section.Parent = scrollayers
			if holder.LeftCount + holder.RightCount <= 0 then
				local at = table.find(holders, holder)
				if at then
					table.remove(holders, at)
				end
				holder.Frame:Destroy()
			else
				touchholder(holder)
			end
		else
			section.Parent = scrollayers
		end
	end

	local tab = instance.frame(nil)
