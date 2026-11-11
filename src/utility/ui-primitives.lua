local function roundbg(parent, radius, color, native)
	if native or parent:IsA("TextButton") then
		parent.BackgroundColor3 = color
		parent.BackgroundTransparency = rowalpha
		parent.BorderSizePixel = 0
		local corner = parent:FindFirstChildOfClass("UICorner") or instance.uicorner(parent)
		corner.CornerRadius = UDim.new(0, radius)
		return setmetatable({}, {
			__index = function(_, key)
				if key == "ImageColor3" then
					return parent.BackgroundColor3
				elseif key == "ImageTransparency" then
					return parent.BackgroundTransparency
				end
				return nil
			end,
			__newindex = function(_, key, value)
				if key == "ImageColor3" then
					parent.BackgroundColor3 = value
				elseif key == "ImageTransparency" then
					parent.BackgroundTransparency = value
				end
			end,
		})
	end
	parent.BackgroundTransparency = 1
	local bg = instance.imagelabel(parent)
	bg.Name = "Bg"
	bg.BackgroundTransparency = 1
	bg.BorderSizePixel = 0
	bg.ImageTransparency = rowalpha
	bg.Image = sliceimage
	bg.ScaleType = Enum.ScaleType.Slice
	bg.SliceCenter = Rect.new(100, 100, 100, 100)
	bg.SliceScale = radius / 100
	bg.ImageColor3 = color
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.ZIndex = 0
	return bg
end

local function hoverbg(button, bg, normal, hover)
	button.MouseEnter:Connect(function()
		bg.ImageColor3 = hover
	end)
	button.MouseLeave:Connect(function()
		bg.ImageColor3 = normal
	end)
	button.MouseButton1Down:Connect(function()
		bg.ImageColor3 = normal
	end)
	button.MouseButton1Up:Connect(function()
		bg.ImageColor3 = hover
	end)
end

local function pesseffect(button)
	local scale = button:FindFirstChild("PressScale")
	if not scale then
		scale = Instance.new("UIScale")
		scale.Name = "PressScale"
		scale.Parent = button
	end
	sv.ts:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.96 }):Play()
	task.delay(0.08, function()
		if scale.Parent then
			sv.ts:Create(scale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
		end
	end)
end

local function tw(object, props, duration, style, direction)
	if not object then
		return
	end
	local ok = pcall(function()
		sv.ts
			:Create(
				object,
				TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
				props
			)
			:Play()
	end)
	if not ok then
		for key, value in pairs(props) do
			pcall(function()
				object[key] = value
			end)
		end
	end
end

