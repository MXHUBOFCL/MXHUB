local draggable = {
	dragging = false,
	resizing = false,
	draginput = nil,
	resizeinput = nil,
	dragstart = nil,
	resizestart = nil,
	startpos = nil,
	startsize = nil,
	minx = 420,
	miny = 260,
	defx = 720,
	defy = 470,
	mobilex = 600,
	mobiley = 400,
}

local sliderDrag = { active = nil, lastUpdateTime = 0 }
local sliderUpdateThrottle = 1 / 60

trackConnection(
	sv.uis.InputChanged:Connect(function(input)
		local active = sliderDrag.active
		if not active then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then

			if
				active.input
				and active.input.UserInputType == Enum.UserInputType.MouseButton1
				and not sv.uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			then
				sliderDrag.active = nil
				active.hidebubble()
				return
			end
		elseif input.UserInputType == Enum.UserInputType.Touch then

			if active.input ~= input then
				return
			end
		else
			return
		end
		local now = tick()
		if (now - sliderDrag.lastUpdateTime) > sliderUpdateThrottle then
			active.setfromx(input.Position.X)
			sliderDrag.lastUpdateTime = now
		end
	end),
	"global.sliderDrag.InputChanged"
)

trackConnection(
	sv.uis.InputEnded:Connect(function(input)
		local active = sliderDrag.active
		if not active then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or (input.UserInputType == Enum.UserInputType.Touch and input == active.input)
		then
			sliderDrag.active = nil
			active.hidebubble()
		end
	end),
	"global.sliderDrag.InputEnded"
)

for _, class in ipairs(classes) do
	instance[class:lower()] = function(parent)
		local obj = Instance.new(class)
		obj.Parent = parent
		return obj
	end
end

local sliceimage = assets.Slice
local rowalpha = 0

