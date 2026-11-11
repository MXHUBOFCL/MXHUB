do
	local searchwidth = isMobile and 110 or 150
	local chips = instance.frame(top)
	chips.Name = "Chips"
	chips.BackgroundTransparency = 1
	chips.BorderSizePixel = 0
	chips.AnchorPoint = Vector2.new(1, 0.5)
	chips.Position = UDim2.new(1, -(66 + searchwidth + 8), 0.5, 0)
	chips.Size = UDim2.new(0, 0, 0, 22)
	chips.AutomaticSize = Enum.AutomaticSize.X

	local chiplist = instance.uilistlayout(chips)
	chiplist.FillDirection = Enum.FillDirection.Horizontal
	chiplist.Padding = UDim.new(0, 4)
	chiplist.SortOrder = Enum.SortOrder.LayoutOrder
	chiplist.VerticalAlignment = Enum.VerticalAlignment.Center
	chiplist.HorizontalAlignment = Enum.HorizontalAlignment.Right

	chips:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		textlabel1.TextTruncate = Enum.TextTruncate.AtEnd
		local reserved = 66 + searchwidth + 8 + chips.AbsoluteSize.X / fitscaleof(chips) + 8
		textlabel1.Size = UDim2.new(1, -(footerx + reserved), 1, 0)
	end)
end

