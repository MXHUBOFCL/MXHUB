function items:AddDivider()
	local divider = instance.frame(sectionadd)
	divider.Name = "Divider"
	divider.AnchorPoint = Vector2.new(0.5, 0)
	divider.Position = UDim2.new(0.5, 0, 0, 0)
	divider.Size = UDim2.new(1, 0, 0, 2)
	divider.BackgroundColor3 = guiconfig.Color
	divider.BackgroundTransparency = 0
	divider.BorderSizePixel = 0
	divider.LayoutOrder = countitem

	local gradient = instance.uigradient(divider)
	gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.8),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(1, 0.8),
	})

	instance.uicorner(divider).CornerRadius = UDim.new(0, 2)

	countitem = countitem + 1
	return divider
end

