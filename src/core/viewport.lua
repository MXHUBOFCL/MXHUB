local function isMobileDevice()
	return sv.uis.TouchEnabled and not sv.uis.KeyboardEnabled and not sv.uis.MouseEnabled
end

local function currentViewportSize()
	local camera = workspace.CurrentCamera
	if camera then
		local ok, viewport = pcall(function() return camera.ViewportSize end)
		if ok and viewport and viewport.X > 0 and viewport.Y > 0 then
			return viewport
		end
	end
	return Vector2.new(1280, 720)
end

local isMobile = isMobileDevice()

local function fitscaleof(object)
	local scale = 1
	local node = object
	while node do
		local ok, found = pcall(function()
			return node:FindFirstChild("FitScale")
		end)
		if ok and found and found:IsA("UIScale") then
			scale = scale * found.Scale
		end
		node = node.Parent
	end
	return math.max(scale, 0.01)
end

local function safesize(width, height)
	local viewport = currentViewportSize()

	local x = width / viewport.X
	local y = height / viewport.Y

	if isMobile then
		x = math.min(x, 0.5)
		y = math.min(y, 0.3)
	end

	return UDim2.new(x, 0, y, 0)
end

