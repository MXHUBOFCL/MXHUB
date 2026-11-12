local glass = { users = 0, effect = nil }

local GLASS_NAME = "MXLIB_Glass"
local GLASS_DEPTH = 0.15

do
	local stale = game:GetService("Lighting"):FindFirstChild(GLASS_NAME)
	if stale then
		stale:Destroy()
	end
	local camera = workspace.CurrentCamera
	local leftover = camera and camera:FindFirstChild(GLASS_NAME)
	while leftover do
		leftover:Destroy()
		leftover = camera:FindFirstChild(GLASS_NAME)
	end
end

local function glassrect(camera, topleft, bottomright, depth)
	local cframe = camera.CFrame
	local look = cframe.LookVector
	local function project(point)
		local ray = camera:ScreenPointToRay(point.X, point.Y, 0)
		local reach = (depth - (ray.Origin - cframe.Position):Dot(look)) / ray.Direction:Dot(look)
		return cframe:PointToObjectSpace(ray.Origin + ray.Direction * reach)
	end
	local first, second = project(topleft), project(bottomright)
	return Vector2.new((first.X + second.X) / 2, (first.Y + second.Y) / 2),
		Vector2.new(math.abs(second.X - first.X), math.abs(second.Y - first.Y))
end

local function sharedeffect()
	if glass.effect and glass.effect.Parent then
		return glass.effect
	end
	local effect = Instance.new("DepthOfFieldEffect")
	effect.Name = GLASS_NAME
	effect.FarIntensity = 0
	effect.NearIntensity = 1
	effect.FocusDistance = 0
	effect.InFocusRadius = 1000
	effect.Parent = game:GetService("Lighting")
	glass.effect = effect
	return effect
end

local function glassblur(frame)
	if not workspace.CurrentCamera then
		return nil
	end

	local part = Instance.new("Part")
	part.Name = GLASS_NAME
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Material = Enum.Material.SmoothPlastic
	part.Color = Color3.new(0, 0, 0)
	part.Transparency = 1
	part.Size = Vector3.new(0.01, 0.01, 0.01)

	sharedeffect()
	glass.users += 1

	local alive = true
	local connections = {}
	local cameraconnections = {}

	local function isvisible()
		if not frame:IsDescendantOf(game) then
			return false
		end
		local node = frame
		while node do
			if node:IsA("ScreenGui") then
				return node.Enabled
			end
			if node:IsA("GuiObject") and not node.Visible then
				return false
			end
			node = node.Parent
		end
		return false
	end

	local function update()
		local camera = workspace.CurrentCamera
		if not alive or not camera then
			return
		end
		if not isvisible() or frame.AbsoluteSize.X <= 0 or frame.AbsoluteSize.Y <= 0 then
			part.Transparency = 1
			return
		end
		local topleft = frame.AbsolutePosition
		local center, size = glassrect(camera, topleft, topleft + frame.AbsoluteSize, GLASS_DEPTH)
		part.Parent = camera
		part.Size = Vector3.new(math.max(size.X, 0.001), math.max(size.Y, 0.001), 0.001)
		part.CFrame = camera.CFrame * CFrame.new(center.X, center.Y, -GLASS_DEPTH)
		part.Transparency = 0.97
	end

	local function safeupdate()
		local ok = pcall(update)
		if not ok then
			part.Transparency = 1
		end
	end

	local function bindcamera()
		for _, connection in ipairs(cameraconnections) do
			connection:Disconnect()
		end
		table.clear(cameraconnections)
		local camera = workspace.CurrentCamera
		if not camera then
			return
		end
		for _, property in ipairs({ "CFrame", "ViewportSize", "FieldOfView" }) do
			cameraconnections[#cameraconnections + 1] = camera:GetPropertyChangedSignal(property):Connect(safeupdate)
		end
		safeupdate()
	end

	for _, property in ipairs({ "AbsolutePosition", "AbsoluteSize" }) do
		connections[#connections + 1] = frame:GetPropertyChangedSignal(property):Connect(safeupdate)
	end
	local node = frame
	while node do
		if node:IsA("ScreenGui") then
			connections[#connections + 1] = node:GetPropertyChangedSignal("Enabled"):Connect(safeupdate)
			break
		end
		if node:IsA("GuiObject") then
			connections[#connections + 1] = node:GetPropertyChangedSignal("Visible"):Connect(safeupdate)
		end
		node = node.Parent
	end
	connections[#connections + 1] = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindcamera)
	bindcamera()

	local controller = {}
	function controller:Destroy()
		if not alive then
			return
		end
		alive = false
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		for _, connection in ipairs(cameraconnections) do
			connection:Disconnect()
		end
		part:Destroy()
		glass.users -= 1
		if glass.users <= 0 and glass.effect then
			glass.effect:Destroy()
			glass.effect = nil
		end
	end
	frame.Destroying:Connect(function()
		controller:Destroy()
	end)
	return controller
end
