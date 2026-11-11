local function makedraggable(topbar, object)
	if isMobile then

		local viewport = currentViewportSize()
		draggable.defx = math.max(draggable.minx, math.min(draggable.mobilex, viewport.X - 24))
		draggable.defy = math.max(draggable.miny, math.min(draggable.mobiley, viewport.Y - 24))
	end

	object.Size = UDim2.new(0, draggable.defx, 0, draggable.defy)

	local fit = Instance.new("UIScale")
	fit.Name = "FitScale"
	fit.Parent = object

	local function adaptivefactor(viewport)
		if isMobile then
			return 1
		end
		local factor = math.min(viewport.X / 1920, viewport.Y / 1020)
		if factor > 0.9 and factor < 1.15 then
			return 1
		end
		return math.clamp(math.floor(factor * 20 + 0.5) / 20, 0.85, 1.75)
	end

	local function fitwindow()
		local screen = object.Parent
		if not screen or screen.AbsoluteSize.X == 0 or screen.AbsoluteSize.Y == 0 then
			return
		end
		local viewport = screen.AbsoluteSize
		local size = object.Size
		local scale = math.min(
			adaptivefactor(viewport) * (object:GetAttribute("MXScalable") and (sv.UserScale or 1) or 1),
			(viewport.X - 24) / math.max(size.X.Offset, 1),
			(viewport.Y - 24) / math.max(size.Y.Offset, 1)
		)
		fit.Scale = math.max(scale, 0.45)
	end

	local function clampwindow()
		local screen = object.Parent
		if not screen or screen.AbsoluteSize.X == 0 or screen.AbsoluteSize.Y == 0 then
			return
		end
		local viewport, scale = screen.AbsoluteSize, fit.Scale
		local limitx = math.max((viewport.X - object.Size.X.Offset * scale) / 2 / scale, 0)
		local limity = math.max((viewport.Y - object.Size.Y.Offset * scale) / 2 / scale, 0)
		local p = object.Position
		object.Position = UDim2.new(
			p.X.Scale,
			math.clamp(p.X.Offset, -limitx, limitx),
			p.Y.Scale,
			math.clamp(p.Y.Offset, -limity, limity)
		)
	end

	sv.Refits = sv.Refits or {}
	table.insert(sv.Refits, function()
		if object.Parent then
			fitwindow()
			clampwindow()
		end
	end)
	fitwindow()
	if object.Parent then
		trackConnection(
			object.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				fitwindow()
				clampwindow()
			end),
			"makedraggable.fit"
		)
	end

	local resizeConnection = nil
	local resizeHandles = {}
	local function makehandle(name, position, size, anchor, modex, modey)
		local handle = instance.frame(object)
		handle.Name = name
		handle.AnchorPoint = anchor
		handle.BackgroundTransparency = 1
		handle.BorderSizePixel = 0
		handle.Position = position
		handle.Size = size
		handle.ZIndex = 100
		handle.Active = true
		table.insert(resizeHandles, { handle, modex, modey })
		return handle
	end
	makehandle("ResizeRight", UDim2.new(1, 0, 0.5, -10), UDim2.new(0, isMobile and 14 or 8, 1, -44), Vector2.new(1, 0.5), 1, 0)
	makehandle("ResizeBottom", UDim2.new(0.5, -10, 1, 0), UDim2.new(1, -44, 0, isMobile and 14 or 8), Vector2.new(0.5, 1), 0, 1)
	local cornerhandle = makehandle("ResizeCorner", UDim2.new(1, 0, 1, 0), UDim2.new(0, isMobile and 30 or 24, 0, isMobile and 30 or 24), Vector2.new(1, 1), 1, 1)
	local dragConnection = nil

	trackConnection(
		topbar.InputBegan:Connect(function(input)
			if
				input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end

			if uilocked then
				return
			end
			draggable.dragging = true
			draggable.dragstart = input.Position
			draggable.startpos = object.Position

			if dragConnection then
				dragConnection:Disconnect()
			end
			dragConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					draggable.dragging = false
					dragConnection:Disconnect()
					dragConnection = nil
				end
			end)
		end),
		"makedraggable.drag.InputBegan"
	)

	trackConnection(
		topbar.InputChanged:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			then
				draggable.draginput = input
			end
		end),
		"makedraggable.drag.InputChanged"
	)

	for _, info in ipairs(resizeHandles) do
		local handle, modex, modey = info[1], info[2], info[3]
		trackConnection(
			handle.InputBegan:Connect(function(input)
				if
					input.UserInputType ~= Enum.UserInputType.MouseButton1
					and input.UserInputType ~= Enum.UserInputType.Touch
				then
					return
				end
				if uilocked then
					return
				end
				draggable.resizing = true
				draggable.resizestart = input.Position
				draggable.startsize = object.Size
				draggable.startpos2 = object.Position
				draggable.modex = modex
				draggable.modey = modey
				draggable.pendingresize = nil

				if resizeConnection then
					resizeConnection:Disconnect()
				end
				resizeConnection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						draggable.resizing = false
						draggable.pendingresize = nil
						clampwindow()
						resizeConnection:Disconnect()
						resizeConnection = nil
					end
				end)
			end),
			"makedraggable.resize.InputBegan"
		)
	end

	trackConnection(
		sv.uis.InputChanged:Connect(function(input)
			if draggable.dragging and input == draggable.draginput then
				draggable.pendingdrag = input.Position
			end
			if
				draggable.resizing
				and (
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				draggable.pendingresize = input.Position
			end
		end),
		"makedraggable.global.InputChanged"
	)

	trackConnection(
		game:GetService("RunService").RenderStepped:Connect(function()
			local drag = draggable.pendingdrag
			if drag then
				draggable.pendingdrag = nil
				local delta = (drag - draggable.dragstart) / fit.Scale
				object.Position = UDim2.new(
					draggable.startpos.X.Scale,
					draggable.startpos.X.Offset + delta.X,
					draggable.startpos.Y.Scale,
					draggable.startpos.Y.Offset + delta.Y
				)
			end

			local resize = draggable.pendingresize
			if resize and draggable.resizing then
				draggable.pendingresize = nil
				local delta = (resize - draggable.resizestart) / fit.Scale
				local viewport = object.Parent.AbsoluteSize / fit.Scale
				local startw, starth = draggable.startsize.X.Offset, draggable.startsize.Y.Offset
				local width = math.clamp(startw + delta.X * draggable.modex, draggable.minx, math.max(draggable.minx, viewport.X - 8))
				local height = math.clamp(starth + delta.Y * draggable.modey, draggable.miny, math.max(draggable.miny, viewport.Y - 8))
				object.Size = UDim2.new(0, width, 0, height)

				local p = draggable.startpos2
				object.Position = UDim2.new(
					p.X.Scale,
					p.X.Offset + (width - startw) / 2,
					p.Y.Scale,
					p.Y.Offset + (height - starth) / 2
				)

				clampwindow()
			end
		end),
		"makedraggable.render"
	)
end

