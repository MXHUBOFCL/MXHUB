function items:AddSubSection(sectiontext)
	sectiontext = sectiontext or "Sub Section"

	local subsection = instance.frame(sectionadd)
	subsection.Name = "SubSection"
	subsection.BackgroundTransparency = 1
	subsection.Size = UDim2.new(1, 0, 0, 22)
	subsection.LayoutOrder = countitem

	local background = instance.frame(subsection)
	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	background.BackgroundTransparency = 1
	background.BorderSizePixel = 0
	instance.uicorner(background).CornerRadius = UDim.new(0, 6)

	local label = instance.textlabel(subsection)
	label.AnchorPoint = Vector2.new(0, 0.5)
	label.Position = UDim2.new(0, 10, 0.5, 0)
	label.Size = UDim2.new(1, -20, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = tostring(sectiontext)
	label.TextColor3 = theme.SubText
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left

	countitem = countitem + 1
	currentSubSection = tostring(sectiontext)
	return subsection
end

