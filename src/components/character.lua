local function characterview(frame, options)
	options = options or {}
	local view = { Target = options.Target }
	local connections = {}
	local rendered = nil

	local viewport = Instance.new("ViewportFrame")
	viewport.Name = "Viewport"
	viewport.Size = UDim2.new(1, 0, 1, 0)
	viewport.BackgroundTransparency = 1
	viewport.BorderSizePixel = 0
	viewport.Ambient = Color3.fromRGB(170, 170, 185)
	viewport.LightColor = Color3.fromRGB(255, 255, 255)
	viewport.LightDirection = Vector3.new(-1, -1, -1)
	viewport.Active = true
	viewport.Parent = frame

	local function resolve()
		local target = view.Target
		if typeof(target) == "Instance" and target:IsA("Player") then
			return target
		end
		if type(target) == "number" then
			return sv.plrs:GetPlayerByUserId(target)
		end
		if type(target) == "string" and target ~= "" and target:lower() ~= "localplayer" then
			return sv.plrs:FindFirstChild(target)
		end
		return sv.plrs.LocalPlayer
	end

	local function clear()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		table.clear(connections)
		viewport:ClearAllChildren()
		viewport.CurrentCamera = nil
	end

	local function fallback(player)
		local picture = Instance.new("ImageLabel")
		picture.BackgroundTransparency = 1
		picture.AnchorPoint = Vector2.new(0.5, 0.5)
		picture.Position = UDim2.new(0.5, 0, 0.5, 0)
		picture.Size = UDim2.new(0, 90, 0, 90)
		picture.Parent = viewport
		if player then
			applyicon(picture, thumbnail("AvatarHeadShot", player.UserId, 150), 48)
		else
			applyicon(picture, "user", 48)
		end
	end

	function view:Render()
		clear()
		local player = resolve()
		local character = player and player.Character
		local model
		if character then
			pcall(function()
				character.Archivable = true
				model = character:Clone()
			end)
		end
		local root = model and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart)
		if not root then
			fallback(player)
			return false
		end

		for _, descendant in ipairs(model:GetDescendants()) do
			if descendant:IsA("BaseScript") or descendant:IsA("Sound") or descendant:IsA("ForceField") then
				descendant:Destroy()
			elseif descendant:IsA("BasePart") then
				descendant.Anchored = true
			end
		end
		local humanoid = model:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end
		model.Parent = viewport

		local camera = Instance.new("Camera")
		camera.FieldOfView = 28
		camera.Parent = viewport
		viewport.CurrentCamera = camera

		local boxcf, boxsize = model:GetBoundingBox()
		local center = boxcf.Position
		local distance = math.max(boxsize.Y, boxsize.X) / (2 * math.tan(math.rad(camera.FieldOfView / 2))) * 1.15
		local base = root.CFrame.Rotation
		local yaw = 20
		local function updatecamera()
			local rotation = base * CFrame.Angles(0, math.rad(yaw), 0)
			local position = center + rotation:VectorToWorldSpace(Vector3.new(0, boxsize.Y * 0.05, -distance))
			camera.CFrame = CFrame.lookAt(position, center)
		end
		updatecamera()

		local dragging, last = false, nil
		local function pointer(input)
			return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
		end
		connections[#connections + 1] = trackConnection(viewport.InputBegan:Connect(function(input)
			if pointer(input) then
				dragging, last = true, input.Position
			end
		end), "mx.character.began")
		connections[#connections + 1] = trackConnection(sv.uis.InputChanged:Connect(function(input)
			if dragging and last and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				yaw = yaw - (input.Position - last).X * 0.8
				last = input.Position
				updatecamera()
			end
		end), "mx.character.changed")
		connections[#connections + 1] = trackConnection(sv.uis.InputEnded:Connect(function(input)
			if pointer(input) then
				dragging = false
			end
		end), "mx.character.ended")
		return true
	end

	function view:SetTarget(target)
		self.Target = target
		self:Render()
	end

	function view:Destroy()
		clear()
		if rendered then
			rendered:Disconnect()
			rendered = nil
		end
		viewport:Destroy()
	end

	local player = resolve()
	if player then
		rendered = player.CharacterAdded:Connect(function()
			task.defer(function()
				if viewport.Parent then
					view:Render()
				end
			end)
		end)
	end
	view:Render()
	return view
end
