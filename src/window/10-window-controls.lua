min.Activated:Connect(function()
	dropshadowholder.Visible = false
end)

close.Activated:Connect(function()
	local overlay = instance.frame(dropshadowholder)
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.3
	overlay.ZIndex = 50

	local dialog = instance.frame(overlay)
	dialog.Size = UDim2.new(0, 300, 0, 150)
	dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
	dialog.BackgroundColor3 = theme.Card
	dialog.BackgroundTransparency = 0
	dialog.BorderSizePixel = 0
	dialog.ZIndex = 51
	local uicorner3 = instance.uicorner(dialog)
	uicorner3.CornerRadius = UDim.new(0, 8)
	local dialogstroke = instance.uistroke(dialog)
	dialogstroke.Color = theme.Stroke
	dialogstroke.Thickness = 1

	local title = instance.textlabel(dialog)
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 40)
	title.Position = UDim2.new(0, 0, 0, 4)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.Text = "MX HUB Window"
	title.TextSize = 22
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.ZIndex = 52

	local message = instance.textlabel(dialog)
	message.Name = "Message"
	message.Size = UDim2.new(1, -20, 0, 60)
	message.Position = UDim2.new(0, 10, 0, 30)
	message.BackgroundTransparency = 1
	message.Font = Enum.Font.Gotham
	message.Text = "Do you want to close this window?\nYou will not be able to open it again"
	message.TextSize = 14
	message.TextColor3 = theme.SubText
	message.TextWrapped = true
	message.ZIndex = 52

	local yes = instance.textbutton(dialog)
	yes.Name = "Yes"
	yes.Size = UDim2.new(0.45, -10, 0, 35)
	yes.Position = UDim2.new(0.05, 0, 1, -55)
	yes.BackgroundColor3 = theme.Element
	yes.BackgroundTransparency = 0
	yes.AutoButtonColor = true
	yes.Text = "Yes"
	yes.Font = Enum.Font.GothamBold
	yes.TextSize = 15
	yes.TextColor3 = Color3.fromRGB(255, 255, 255)
	yes.TextTransparency = 0.3
	yes.ZIndex = 52
	local yescorner = instance.uicorner(yes)
	yescorner.CornerRadius = UDim.new(0, 6)

	local cancel = instance.textbutton(dialog)
	cancel.Name = "Cancel"
	cancel.Size = UDim2.new(0.45, -10, 0, 35)
	cancel.Position = UDim2.new(0.5, 10, 1, -55)
	cancel.BackgroundColor3 = theme.Element
	cancel.BackgroundTransparency = 0
	cancel.AutoButtonColor = true
	cancel.Text = "Cancel"
	cancel.Font = Enum.Font.GothamBold
	cancel.TextSize = 15
	cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
	cancel.TextTransparency = 0.3
	cancel.ZIndex = 52
	local cancelcorner = instance.uicorner(cancel)
	cancelcorner.CornerRadius = UDim.new(0, 6)

	yes.MouseButton1Click:Connect(function()
		guifunc:DestroyGui()
	end)

	cancel.MouseButton1Click:Connect(function()
		overlay:Destroy()
	end)
end)

local togglekey = typeof(guiconfig.MenuKey) == "EnumItem" and guiconfig.MenuKey or Enum.KeyCode.F3
trackConnection(
	sv.uis.InputBegan:Connect(function(input, gpe)
		if gpe then
			return
		end
		if input.KeyCode == togglekey then
			if dropshadowholder then
				dropshadowholder.Visible = not dropshadowholder.Visible
			end
		end
	end),
	"window.togglekey"
)

