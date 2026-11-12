local WatermarkGui

function MXHUB:Watermark(wmconfig)
	wmconfig = wmconfig or {}
	local title = tostring(wmconfig.Title or "MX HUB")
	local showtime = wmconfig.ShowTime ~= false
	local showfps = wmconfig.ShowFPS ~= false
	local showping = wmconfig.ShowPing ~= false

	local parent = sv.coregui
	pcall(function()
		local ok, hidden = pcall(function()
			return gethui()
		end)
		if ok and hidden then
			parent = hidden
		end
	end)
	pcall(function()
		local old = parent:FindFirstChild("MXHUBWatermark") or sv.coregui:FindFirstChild("MXHUBWatermark")
		if old then
			old:Destroy()
		end
	end)

	local gui = instance.screengui(parent)
	gui.Name = "MXHUBWatermark"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 9000
	gui.IgnoreGuiInset = true
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
		elseif protect_gui then
			protect_gui(gui)
		end
	end)
	WatermarkGui = gui

	local pill = instance.frame(gui)
	pill.Name = "Pill"
	pill.AnchorPoint = Vector2.new(0.5, 0)
	pill.Position = wmconfig.Position or UDim2.new(0.5, 0, 0, 64)
	pill.Size = UDim2.new(0, 0, 0, isMobile and 30 or 34)
	pill.AutomaticSize = Enum.AutomaticSize.X
	pill.BackgroundColor3 = theme.Card
	pill.BackgroundTransparency = 0.08
	pill.BorderSizePixel = 0
	pill.Active = true
	instance.uicorner(pill).CornerRadius = UDim.new(0, 8)
	local pillstroke = instance.uistroke(pill)
	pillstroke.Color = theme.Stroke
	pillstroke.Thickness = 1

	local pad = instance.uipadding(pill)
	pad.PaddingLeft = UDim.new(0, 12)
	pad.PaddingRight = UDim.new(0, 14)

	local layout = instance.uilistlayout(pill)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)

	local logo = instance.imagelabel(pill)
	logo.Name = "Logo"
	logo.LayoutOrder = 1
	logo.BackgroundTransparency = 1
	logo.Size = UDim2.new(0, 20, 0, 20)
	logo.ScaleType = Enum.ScaleType.Fit
	instance.uicorner(logo).CornerRadius = UDim.new(0, 4)
	local function setlogo(value)
		if value == nil or value == false or value == "" then
			logo.Visible = false
			return
		end
		logo.Visible = true
		applyicon(logo, value, 96)
	end
	setlogo(wmconfig.Logo)

	local label = instance.textlabel(pill)
	label.Name = "Info"
	label.LayoutOrder = 2
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(0, 0, 1, 0)
	label.AutomaticSize = Enum.AutomaticSize.X
	label.Font = Enum.Font.GothamMedium
	label.TextSize = isMobile and 12 or 13
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.RichText = true
	label.TextXAlignment = Enum.TextXAlignment.Left

	local ping = 0
	local function refresh()
		local sep = '<font color="#7A7A86">|</font>'
		local parts = { title }
		if showtime then
			table.insert(parts, os.date("%H:%M:%S"))
		end
		if showfps then
			table.insert(parts, string.format("%d FPS", fpsmeter.value))
		end
		if showping then
			table.insert(parts, string.format("%dms", ping))
		end
		label.Text = table.concat(parts, "  " .. sep .. "  ")
	end

	fpsmeter.start()

	task.spawn(function()
		while pill.Parent do
			pcall(function()
				ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
			end)
			refresh()
			task.wait(0.5)
		end
	end)
	refresh()

	local MARGIN = 0
	local function clampwm()
		local bounds, size = gui.AbsoluteSize, pill.AbsoluteSize
		if bounds.X <= 0 or size.X <= 0 then
			return
		end
		local pos, anchor = pill.Position, pill.AnchorPoint
		local x = pos.X.Scale * bounds.X + pos.X.Offset
		local y = pos.Y.Scale * bounds.Y + pos.Y.Offset
		local minx, miny = anchor.X * size.X + MARGIN, anchor.Y * size.Y + MARGIN
		local maxx = bounds.X - (1 - anchor.X) * size.X - MARGIN
		local maxy = bounds.Y - (1 - anchor.Y) * size.Y - MARGIN
		x = math.clamp(x, minx, math.max(minx, maxx))
		y = math.clamp(y, miny, math.max(miny, maxy))
		pill.Position = UDim2.fromOffset(x, y)
	end
	pill:GetPropertyChangedSignal("AbsoluteSize"):Connect(clampwm)
	gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(clampwm)

	local dragstart, startpos, draginput = nil, nil, nil
	pill.InputBegan:Connect(function(input)
		if uilocked then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragstart = input.Position
			startpos = pill.Position
			draginput = input
		end
	end)
	trackConnection(
		sv.uis.InputChanged:Connect(function(input)
			if
				dragstart
				and (input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and input == draginput))
			then
				local delta = input.Position - dragstart
				pill.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
				clampwm()
			end
		end),
		"watermark.drag.changed"
	)
	trackConnection(
		sv.uis.InputEnded:Connect(function(input)
			if dragstart and (input.UserInputType == Enum.UserInputType.MouseButton1 or input == draginput) then
				dragstart = nil
			end
		end),
		"watermark.drag.ended"
	)

	local handle = {}
	function handle:SetVisible(state)
		gui.Enabled = state ~= false
	end
	function handle:SetTitle(text)
		title = tostring(text or title)
		refresh()
	end
	function handle:SetLogo(value)
		setlogo(value)
	end
	function handle:Destroy()
		pcall(function()
			gui:Destroy()
		end)
	end
	handle.Gui = gui
	return handle
end

