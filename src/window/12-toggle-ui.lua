function guifunc:ToggleUI()
	local screengui = instance.screengui(sv.coregui)
	screengui.Name = "ToggleUIButton"
	screengui.IgnoreGuiInset = true
	screengui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local mainbutton = instance.imagelabel(screengui)
	mainbutton.Size = UDim2.new(0, guiconfig.ImageSize, 0, guiconfig.ImageSize)
	mainbutton.Position = UDim2.new(0, 20, 0, 100)
	mainbutton.BackgroundTransparency = 1
	local toggleIcon = userPassedToggle or (not bgAsset and userPassedImage) or assets.LogoId
	local toggleStr = resolveiconasset(toggleIcon) or assets.Logo
	mainbutton.Image = toggleStr
	mainbutton.ScaleType = Enum.ScaleType.Crop

	local uicorner = instance.uicorner(mainbutton)
	uicorner.CornerRadius = UDim.new(0, 6)

	local button = instance.textbutton(mainbutton)
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = ""

	local MARGIN = 0
	local moved = false
	local dragging = false
	local dragstart, startpos, draginput

	local function clampbutton()
		local bounds = screengui.AbsoluteSize
		if bounds.X <= 0 or bounds.Y <= 0 then
			return
		end
		local size = tonumber(guiconfig.ImageSize) or 50
		local x = mainbutton.Position.X.Scale * bounds.X + mainbutton.Position.X.Offset
		local y = mainbutton.Position.Y.Scale * bounds.Y + mainbutton.Position.Y.Offset
		x = math.clamp(x, MARGIN, math.max(MARGIN, bounds.X - size - MARGIN))
		y = math.clamp(y, MARGIN, math.max(MARGIN, bounds.Y - size - MARGIN))
		mainbutton.Position = UDim2.fromOffset(x, y)
	end
	screengui:GetPropertyChangedSignal("AbsoluteSize"):Connect(clampbutton)
	task.defer(clampbutton)

	button.MouseButton1Click:Connect(function()

		if moved then
			return
		end
		if dropshadowholder then
			dropshadowholder.Visible = not dropshadowholder.Visible
		end
	end)

	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			moved = false
			if uilocked then
				return
			end
			dragging = true
			dragstart = input.Position
			startpos = mainbutton.Position
			draginput = input
		end
	end)

	trackConnection(
		sv.uis.InputChanged:Connect(function(input)
			if not dragging then
				return
			end
			if input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and input == draginput) then
				local delta = input.Position - dragstart
				if not moved and delta.Magnitude < 6 then
					return
				end
				moved = true
				mainbutton.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
				clampbutton()
			end
		end),
		"togglebutton.drag"
	)
	trackConnection(
		sv.uis.InputEnded:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input == draginput) then
				dragging = false
			end
		end),
		"togglebutton.drag.end"
	)
end

guifunc:ToggleUI()

