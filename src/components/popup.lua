local function popupbutton(parent, option, onpick)
	local style = tostring(option.Style or "default"):lower()
	local base, hover, textcolor
	if style == "primary" then
		base, hover, textcolor = theme.Accent, theme.Accent:Lerp(Color3.new(1, 1, 1), 0.14), theme.AccentText
	elseif style == "danger" then
		base, hover, textcolor = theme.Bad, theme.Bad:Lerp(Color3.new(1, 1, 1), 0.14), Color3.new(1, 1, 1)
	else
		base, hover, textcolor = theme.Element, theme.ElementHover, theme.Text
	end

	local button = instance.textbutton(parent)
	button.Name = "Option"
	button.AutoButtonColor = false
	button.BorderSizePixel = 0
	button.BackgroundColor3 = base
	button.AutomaticSize = Enum.AutomaticSize.X
	button.Size = UDim2.new(0, 0, 0, 34)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 12
	button.TextColor3 = textcolor
	button.Text = tostring(option.Text or "OK")
	instance.uicorner(button).CornerRadius = UDim.new(0, theme.Radius.control)
	local pad = instance.uipadding(button)
	pad.PaddingLeft = UDim.new(0, 16)
	pad.PaddingRight = UDim.new(0, 16)
	if style == "default" then
		local stroke = instance.uistroke(button)
		stroke.Color = theme.Stroke
		stroke.Thickness = 1
	end

	button.MouseEnter:Connect(function()
		tw(button, { BackgroundColor3 = hover }, 0.12)
	end)
	button.MouseLeave:Connect(function()
		tw(button, { BackgroundColor3 = base }, 0.18)
	end)
	button.Activated:Connect(function()
		onpick(option)
	end)
	return button
end

local function popupbox(parent, box, order)
	local frame = instance.frame(parent)
	frame.Name = "Box"
	frame.LayoutOrder = order
	frame.BorderSizePixel = 0
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	roundbg(frame, theme.Radius.control, theme.Row, true)
	local stroke = instance.uistroke(frame)
	stroke.Color = theme.Stroke
	stroke.Transparency = 0.45
	stroke.Thickness = 1

	local pad = instance.uipadding(frame)
	pad.PaddingTop = UDim.new(0, 12)
	pad.PaddingBottom = UDim.new(0, 12)
	pad.PaddingLeft = UDim.new(0, 12)
	pad.PaddingRight = UDim.new(0, 12)

	local row = instance.uilistlayout(frame)
	row.FillDirection = Enum.FillDirection.Horizontal
	row.SortOrder = Enum.SortOrder.LayoutOrder
	row.Padding = UDim.new(0, 10)

	local textwidth = UDim2.new(1, 0, 0, 0)
	if box.Icon ~= nil and box.Icon ~= "" then
		local icon = instance.imagelabel(frame)
		icon.Name = "Icon"
		icon.LayoutOrder = 1
		icon.BackgroundTransparency = 1
		icon.Size = UDim2.new(0, 22, 0, 22)
		icon.ImageColor3 = theme.Accent
		applyicon(icon, box.Icon, 48)
		textwidth = UDim2.new(1, -32, 0, 0)
	end

	local holder = instance.frame(frame)
	holder.Name = "Text"
	holder.LayoutOrder = 2
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.Size = textwidth
	holder.AutomaticSize = Enum.AutomaticSize.Y
	local stack = instance.uilistlayout(holder)
	stack.SortOrder = Enum.SortOrder.LayoutOrder
	stack.Padding = UDim.new(0, 3)

	local function line(text, font, size, color, layout)
		local label = instance.textlabel(holder)
		label.LayoutOrder = layout
		label.BackgroundTransparency = 1
		label.BorderSizePixel = 0
		label.Font = font
		label.TextSize = size
		label.TextColor3 = color
		label.TextWrapped = true
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.Size = UDim2.new(1, 0, 0, 0)
		label.AutomaticSize = Enum.AutomaticSize.Y
		label.Text = text
	end
	if box.Title and box.Title ~= "" then
		line(tostring(box.Title), Enum.Font.GothamBold, 13, theme.Text, 1)
	end
	if box.Description and box.Description ~= "" then
		line(tostring(box.Description), Enum.Font.Gotham, 12, theme.SubText, 2)
	end
end

function MXHUB:Popup(popupconfig)
	popupconfig = popupconfig or {}
	elevate()

	local previous = sv.coregui:FindFirstChild("PopupGui")
	if previous then
		previous:Destroy()
	end

	local gui = instance.screengui(sv.coregui)
	gui.Name = "PopupGui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 10000

	local backdrop = instance.textbutton(gui)
	backdrop.Name = "Backdrop"
	backdrop.Text = ""
	backdrop.AutoButtonColor = false
	backdrop.BorderSizePixel = 0
	backdrop.BackgroundColor3 = Color3.new(0, 0, 0)
	backdrop.BackgroundTransparency = 1
	backdrop.Size = UDim2.fromScale(1, 1)

	local dialog = instance.canvasgroup(gui)
	dialog.Name = "Dialog"
	dialog.AnchorPoint = Vector2.new(0.5, 0.5)
	dialog.Position = UDim2.new(0.5, 0, 0.5, 18)
	dialog.Size = UDim2.new(0.92, 0, 0, 0)
	dialog.AutomaticSize = Enum.AutomaticSize.Y
	dialog.BackgroundColor3 = theme.Card
	dialog.BorderSizePixel = 0
	dialog.GroupTransparency = 1
	instance.uicorner(dialog).CornerRadius = UDim.new(0, theme.Radius.card)
	local limit = instance.uisizeconstraint(dialog)
	limit.MaxSize = Vector2.new(430, math.huge)
	local border = instance.uistroke(dialog)
	border.Color = theme.Stroke
	border.Thickness = 1

	local pad = instance.uipadding(dialog)
	pad.PaddingTop = UDim.new(0, 18)
	pad.PaddingBottom = UDim.new(0, 18)
	pad.PaddingLeft = UDim.new(0, 18)
	pad.PaddingRight = UDim.new(0, 18)
	local stack = instance.uilistlayout(dialog)
	stack.SortOrder = Enum.SortOrder.LayoutOrder
	stack.Padding = UDim.new(0, 10)

	local order = 0
	local function nextorder()
		order += 1
		return order
	end
	local function heading(text, font, size, color)
		local label = instance.textlabel(dialog)
		label.LayoutOrder = nextorder()
		label.BackgroundTransparency = 1
		label.BorderSizePixel = 0
		label.Font = font
		label.TextSize = size
		label.TextColor3 = color
		label.TextWrapped = true
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Size = UDim2.new(1, 0, 0, 0)
		label.AutomaticSize = Enum.AutomaticSize.Y
		label.Text = text
	end
	if popupconfig.Title and popupconfig.Title ~= "" then
		heading(tostring(popupconfig.Title), Enum.Font.GothamBold, 18, theme.Text)
	end
	if popupconfig.Subtitle and popupconfig.Subtitle ~= "" then
		heading(tostring(popupconfig.Subtitle), Enum.Font.GothamMedium, 12, theme.SubText)
	end
	for _, box in ipairs(popupconfig.Boxes or {}) do
		popupbox(dialog, box, nextorder())
	end

	local actions = instance.frame(dialog)
	actions.Name = "Options"
	actions.LayoutOrder = nextorder()
	actions.BackgroundTransparency = 1
	actions.BorderSizePixel = 0
	actions.Size = UDim2.new(1, 0, 0, 34)
	local actionlayout = instance.uilistlayout(actions)
	actionlayout.FillDirection = Enum.FillDirection.Horizontal
	actionlayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	actionlayout.SortOrder = Enum.SortOrder.LayoutOrder
	actionlayout.Padding = UDim.new(0, 8)

	local popupfunc = { Open = true }
	local closed = false
	local escape

	local function close(option)
		if closed then
			return
		end
		closed = true
		popupfunc.Open = false
		if escape then
			escape:Disconnect()
		end
		tw(backdrop, { BackgroundTransparency = 1 }, 0.18)
		tw(dialog, { GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 10) }, 0.18)
		task.delay(0.2, function()
			gui:Destroy()
		end)
		local callback = (option and option.Callback) or popupconfig.OnClose
		if type(callback) == "function" then
			local ok, err = pcall(callback, option and option.Text)
			if not ok then
				warn("Popup callback error:", err)
			end
		end
	end
	popupfunc.Close = function()
		close(nil)
	end

	local options = popupconfig.Options
	if type(options) ~= "table" or #options == 0 then
		options = { { Text = "OK", Style = "primary" } }
	end
	for index, option in ipairs(options) do
		local button = popupbutton(actions, option, close)
		button.LayoutOrder = index
	end

	if popupconfig.Dismissable ~= false then
		backdrop.Activated:Connect(popupfunc.Close)
		escape = sv.uis.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Escape then
				close(nil)
			end
		end)
	end
	gui.Destroying:Connect(function()
		if escape then
			escape:Disconnect()
		end
	end)

	tw(backdrop, { BackgroundTransparency = 0.45 }, 0.2)
	tw(dialog, { GroupTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0) }, 0.28)
	return popupfunc
end
