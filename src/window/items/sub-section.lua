function items:AddSubSection(sectiontext)
	sectiontext = tostring(sectiontext or "Sub Section")

	local subsection = instance.frame(sectionadd)
	subsection.Name = "SubSection"
	subsection.BackgroundTransparency = 1
	subsection.Size = UDim2.new(1, 0, 0, 28)
	subsection.LayoutOrder = countitem

	local caption = sectiontext:upper()
	local label = instance.textlabel(subsection)
	label.AnchorPoint = Vector2.new(0, 0.5)
	label.Position = UDim2.new(0, 10, 0.5, 2)
	label.Size = UDim2.new(0, 200, 0, 14)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = caption
	label.TextColor3 = theme.SubText
	label.TextSize = design.Font.Caption
	label.TextXAlignment = Enum.TextXAlignment.Left

	local labelwidth = math.ceil(sv.textservice:GetTextSize(caption, design.Font.Caption, Enum.Font.GothamBold, Vector2.new(1000, 14)).X)
	label.Size = UDim2.new(0, labelwidth + 2, 0, 14)

	local rule = instance.frame(subsection)
	rule.Name = "Rule"
	rule.AnchorPoint = Vector2.new(0, 0.5)
	rule.BackgroundColor3 = theme.Stroke
	rule.BackgroundTransparency = 0.55
	rule.BorderSizePixel = 0
	rule.Position = UDim2.new(0, labelwidth + 20, 0.5, 2)
	rule.Size = UDim2.new(1, -(labelwidth + 30), 0, 1)

	countitem = countitem + 1
	currentSubSection = sectiontext
	return subsection
end
