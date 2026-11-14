function items:AddButton(buttonconfig)
	buttonconfig = buttonconfig or {}
	buttonconfig.Title = buttonconfig.Title or "Confirm"
	buttonconfig.Callback = buttonconfig.Callback or function() end
	buttonconfig.SubTitle = buttonconfig.SubTitle or nil
	buttonconfig.SubCallback = buttonconfig.SubCallback or function() end

	local button = instance.frame(sectionadd)
	button.BorderSizePixel = 0
	button.Size = UDim2.new(1, 0, 0, isMobile and 46 or 40)
	button.LayoutOrder = countitem
	roundbg(button, design.Radius.Control, theme.Row)

	local padding = 3
	local gap = 4

	local mainbutton = instance.textbutton(button)
	mainbutton.Font = Enum.Font.GothamMedium
	mainbutton.Text = tostring(buttonconfig.Title)
	mainbutton.TextSize = isMobile and 12 or 11
	mainbutton.TextTruncate = Enum.TextTruncate.AtEnd
	mainbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
	mainbutton.TextTransparency = 0.3
	mainbutton.AutoButtonColor = false
	mainbutton.ZIndex = 10
	hoverbg(mainbutton, roundbg(mainbutton, design.Radius.Control, theme.Inner), theme.Inner, theme.InnerHover)

	if buttonconfig.SubTitle then
		mainbutton.Size = UDim2.new(0.5, -padding - gap, 1, -10)
		mainbutton.Position = UDim2.new(0, padding, 0, 5)
	else
		mainbutton.Size = UDim2.new(1, -padding * 2, 1, -10)
		mainbutton.Position = UDim2.new(0, padding, 0, 5)
	end

	local textpad = instance.uipadding(mainbutton)
	local buttonicon
	local function seticon(value)
		local has = hasimage(value)
		if has and not buttonicon then
			buttonicon = instance.imagelabel(mainbutton)
			buttonicon.Name = "ButtonIcon"
			buttonicon.BackgroundTransparency = 1
			buttonicon.AnchorPoint = Vector2.new(0, 0.5)
			buttonicon.Position = UDim2.new(0, 10, 0.5, 0)
			buttonicon.Size = UDim2.new(0, 16, 0, 16)
			buttonicon.ZIndex = 11
			buttonicon.ImageColor3 = theme.SubText
		end
		if buttonicon then
			buttonicon.Visible = has
			if has then
				applyicon(buttonicon, value, 48)
			end
		end
		textpad.PaddingLeft = UDim.new(0, has and 24 or 0)
	end
	seticon(buttonconfig.Icon)

	mainbutton.MouseButton1Down:Connect(function()
		pcall(pesseffect, mainbutton)
	end)

	mainbutton.MouseButton1Click:Connect(function()
		firecallback(buttonconfig.Callback, buttonconfig.Title)
	end)

	local buttons = { mainbutton }

	if buttonconfig.SubTitle then
		local subbutton = instance.textbutton(button)
		subbutton.Font = Enum.Font.GothamMedium
		subbutton.Text = tostring(buttonconfig.SubTitle)
		subbutton.TextSize = isMobile and 12 or 11
		subbutton.TextTruncate = Enum.TextTruncate.AtEnd
		subbutton.TextTransparency = 0.3
		subbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
		subbutton.Size = UDim2.new(0.5, -padding - gap, 1, -10)
		subbutton.Position = UDim2.new(0.5, gap, 0, 5)
		subbutton.AutoButtonColor = false
		subbutton.ZIndex = 10
		hoverbg(subbutton, roundbg(subbutton, design.Radius.Control, theme.Inner), theme.Inner, theme.InnerHover)

		subbutton.MouseButton1Down:Connect(function()
			pcall(pesseffect, subbutton)
		end)

		subbutton.MouseButton1Click:Connect(function()
			firecallback(buttonconfig.SubCallback, buttonconfig.SubTitle)
		end)
		buttons[#buttons + 1] = subbutton
	end

	local searchname = tostring(buttonconfig.Title)
	if buttonconfig.SubTitle then
		searchname = searchname .. " / " .. tostring(buttonconfig.SubTitle)
	end
	registerSearchItem(searchname, button, "Button")
	countitem = countitem + 1
	yieldbuild()

	local buttonfunc = {}
	function buttonfunc:SetTitle(text)
		mainbutton.Text = tostring(text)
	end
	function buttonfunc:SetIcon(value)
		seticon(value)
	end
	function buttonfunc:SetIconColor(color)
		if buttonicon and typeof(color) == "Color3" then
			buttonicon.ImageColor3 = color
		end
	end
	return buttonfunc
end

