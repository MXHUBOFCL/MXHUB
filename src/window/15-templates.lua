do
	local t = instance.frame(nil)
	t.Name = "Toggle"
	t.BorderSizePixel = 0
	t.Size = UDim2.new(1, 0, 0, isMobile and 44 or 38)
	roundbg(t, 4, theme.Row)

	local ttitle = instance.textlabel(t)
	ttitle.Name = "ToggleTitle"
	ttitle.Font = Enum.Font.GothamMedium
	ttitle.TextSize = 12
	ttitle.TextColor3 = theme.Text
	ttitle.TextXAlignment = Enum.TextXAlignment.Left
	ttitle.TextYAlignment = Enum.TextYAlignment.Top
	ttitle.BackgroundTransparency = 1
	ttitle.Position = UDim2.new(0, 10, 0, 13)
	ttitle.Size = UDim2.new(1, -100, 0, 13)
	ttitle.TextTruncate = Enum.TextTruncate.AtEnd

	local tbutton = instance.textbutton(t)
	tbutton.Name = "ToggleButton"
	tbutton.Font = Enum.Font.SourceSans
	tbutton.Text = ""
	tbutton.BackgroundTransparency = 1
	tbutton.Size = UDim2.new(1, 0, 1, 0)

	local tfeature = instance.frame(t)
	tfeature.Name = "FeatureFrame"
	tfeature.AnchorPoint = Vector2.new(1, 0.5)
	tfeature.BackgroundColor3 = theme.Field
	tfeature.BackgroundTransparency = 0
	tfeature.BorderSizePixel = 0
	tfeature.Position = UDim2.new(1, -12, 0.5, 0)
	tfeature.Size = isMobile and UDim2.new(0, 40, 0, 22) or UDim2.new(0, 32, 0, 16)
	instance.uicorner(tfeature)

	local tstroke = instance.uistroke(tfeature)
	tstroke.Color = Color3.fromRGB(255, 255, 255)
	tstroke.Thickness = 1.5
	tstroke.Transparency = 0.9

	local tcircle = instance.frame(tfeature)
	tcircle.Name = "ToggleCircle"
	tcircle.BackgroundColor3 = theme.Text
	tcircle.BorderSizePixel = 0
	tcircle.Position = isMobile and UDim2.new(0, 3, 0, 3) or UDim2.new(0, 2, 0, 2)
	tcircle.Size = isMobile and UDim2.new(0, 16, 0, 16) or UDim2.new(0, 12, 0, 12)
	instance.uicorner(tcircle).CornerRadius = UDim.new(0, 12)

	templates.Toggle = t
end

do
	local s = instance.frame(nil)
	s.Name = "Slider"
	s.BorderSizePixel = 0
	s.Size = UDim2.new(1, 0, 0, 58)
	roundbg(s, 4, theme.Row)

	local stitle = instance.textlabel(s)
	stitle.Name = "SliderTitle"
	stitle.Font = Enum.Font.GothamMedium
	stitle.TextColor3 = theme.Text
	stitle.TextSize = 12
	stitle.TextXAlignment = Enum.TextXAlignment.Left
	stitle.TextYAlignment = Enum.TextYAlignment.Center
	stitle.BackgroundTransparency = 1
	stitle.Position = UDim2.new(0, 10, 0, 7)
	stitle.Size = UDim2.new(1, -58, 0, 20)
	stitle.TextTruncate = Enum.TextTruncate.AtEnd

	local sholder = instance.frame(s)
	sholder.Name = "SliderInputHolder"
	sholder.AnchorPoint = Vector2.new(1, 0)
	sholder.Position = UDim2.new(1, -10, 0, 7)
	sholder.Size = UDim2.new(0, 32, 0, 20)
	roundbg(sholder, 4, theme.Field)

	local sinput = instance.textbox(sholder)
	sinput.Name = "SliderInput"
	sinput.Font = Enum.Font.GothamMedium
	sinput.Text = ""
	sinput.TextColor3 = Color3.fromRGB(255, 255, 255)
	sinput.TextSize = 11
	sinput.TextScaled = true
	sinput.TextXAlignment = Enum.TextXAlignment.Center
	sinput.TextYAlignment = Enum.TextYAlignment.Center
	sinput.BackgroundTransparency = 1
	sinput.ClearTextOnFocus = false
	sinput.Size = UDim2.new(1, -6, 1, 0)
	sinput.Position = UDim2.new(0, 3, 0, 0)

	local sinputconstraint = instance.uitextsizeconstraint(sinput)
	sinputconstraint.MinTextSize = 7
	sinputconstraint.MaxTextSize = 11

	local sbar = instance.frame(s)
	sbar.Name = "SliderBar"
	sbar.BackgroundColor3 = theme.Bar
	sbar.BackgroundTransparency = 0
	sbar.Position = UDim2.new(0, 10, 0, 39)
	sbar.Size = UDim2.new(1, -20, 0, 5)
	sbar.Active = true
	instance.uicorner(sbar).CornerRadius = UDim.new(1, 0)

	local sfill = instance.frame(sbar)
	sfill.Name = "SliderFill"
	sfill.BackgroundColor3 = theme.SliderFill
	sfill.BorderSizePixel = 0
	sfill.Size = UDim2.new(0, 0, 1, 0)
	instance.uicorner(sfill).CornerRadius = UDim.new(1, 0)

	local scircle = instance.frame(sbar)
	scircle.Name = "SliderCircle"
	scircle.AnchorPoint = Vector2.new(0.5, 0.5)
	scircle.BackgroundColor3 = theme.SliderFill
	scircle.Position = UDim2.new(0, 0, 0.5, 0)
	scircle.Size = UDim2.new(0, 12, 0, 12)
	scircle.Active = true
	scircle.ZIndex = 4
	instance.uicorner(scircle).CornerRadius = UDim.new(1, 0)

	local scirclestroke = instance.uistroke(scircle)
	scirclestroke.Color = Color3.fromRGB(255, 255, 255)
	scirclestroke.Transparency = 0.45
	scirclestroke.Thickness = 1

	local sbubble = instance.frame(sbar)
	sbubble.Name = "ValueBubble"
	sbubble.AnchorPoint = Vector2.new(0.5, 1)
	sbubble.BackgroundColor3 = theme.Element
	sbubble.BackgroundTransparency = 0
	sbubble.Position = UDim2.new(0, 0, 0, -10)
	sbubble.Size = UDim2.new(0, 48, 0, 22)
	sbubble.Visible = false
	sbubble.ZIndex = 20
	instance.uicorner(sbubble).CornerRadius = UDim.new(0, 5)

	local sbubbletext = instance.textlabel(sbubble)
	sbubbletext.Name = "BubbleText"
	sbubbletext.BackgroundTransparency = 1
	sbubbletext.Size = UDim2.new(1, -6, 1, 0)
	sbubbletext.Position = UDim2.new(0, 3, 0, 0)
	sbubbletext.Font = Enum.Font.GothamBold
	sbubbletext.TextColor3 = Color3.fromRGB(255, 255, 255)
	sbubbletext.TextSize = 11
	sbubbletext.TextScaled = true
	sbubbletext.TextXAlignment = Enum.TextXAlignment.Center
	sbubbletext.TextYAlignment = Enum.TextYAlignment.Center
	sbubbletext.ZIndex = 21

	local sbubbleconstraint = instance.uitextsizeconstraint(sbubbletext)
	sbubbleconstraint.MinTextSize = 7
	sbubbleconstraint.MaxTextSize = 11

	templates.Slider = s
end

do
	local o = instance.frame(nil)
	o.Name = "Option"
	o.Size = UDim2.new(1, 0, 0, 30)
	roundbg(o, 3, theme.Option).ImageTransparency = 1

	local obutton = instance.textbutton(o)
	obutton.Name = "OptionButton"
	obutton.BackgroundTransparency = 1
	obutton.Size = UDim2.new(1, 0, 1, 0)
	obutton.Text = ""

	local otext = instance.textlabel(o)
	otext.Name = "OptionText"
	otext.Font = Enum.Font.GothamBold
	otext.TextSize = 13
	otext.TextColor3 = theme.Text
	otext.BackgroundTransparency = 1
	otext.TextXAlignment = Enum.TextXAlignment.Left
	otext.TextTruncate = Enum.TextTruncate.AtEnd

	local ochoose = instance.frame(o)
	ochoose.Name = "ChooseFrame"
	ochoose.AnchorPoint = Vector2.new(0, 0.5)
	ochoose.BackgroundColor3 = guiconfig.Color
	ochoose.Position = UDim2.new(0, 2, 0.5, 0)
	ochoose.Size = UDim2.new(0, 0, 0, 0)

	local ochoosestroke = instance.uistroke(ochoose)
	ochoosestroke.Color = guiconfig.Color
	ochoosestroke.Thickness = 1.6
	ochoosestroke.Transparency = 1
	instance.uicorner(ochoose)

	templates.DropdownOption = o
end

