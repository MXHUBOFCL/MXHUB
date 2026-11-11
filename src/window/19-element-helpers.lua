local usedkeys = {}

local function keyfor(prefix, elementconfig)
	local key = prefix .. tostring(elementconfig.Flag or elementconfig.Title)
	if usedkeys[key] then
		warn(string.format("[MX HUB] Duplicate config key %q: these elements share one saved value. Give one of them a unique Flag.", key))
	end
	usedkeys[key] = true
	return key
end

local CONTENT_FONT = Enum.Font.Gotham
local CONTENT_SIZE = 12

local function contenttext(elementconfig)
	local text = elementconfig.Content or elementconfig.Desc or elementconfig.Description
	if text == nil then
		return nil
	end
	text = tostring(text)
	if text:gsub("%s+", "") == "" then
		return nil
	end
	return text
end

local function attachcontent(row, text, x, y, rightinset)
	local label = instance.textlabel(row)
	label.Name = "Content"
	label.BackgroundTransparency = 1
	label.Font = CONTENT_FONT
	label.RichText = true
	label.Text = text
	label.TextColor3 = theme.SubText
	label.TextSize = CONTENT_SIZE
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Position = UDim2.new(0, x, 0, y)
	label.Size = UDim2.new(1, -(x + rightinset), 0, CONTENT_SIZE)
	local function measure()
		local width = row.AbsoluteSize.X / fitscaleof(row)
		if width <= 1 then
			width = layers.AbsoluteSize.X / fitscaleof(layers)
		end
		if width <= 1 then
			width = 440
		end
		local height = textheight(text, CONTENT_SIZE, CONTENT_FONT, width - x - rightinset, 400)
		label.Size = UDim2.new(1, -(x + rightinset), 0, height)
		return height
	end
	return label, measure
end

local ICONSLOT = 22

local function elementiconx(cfg)
	return (cfg and hasimage(cfg.Icon)) and (10 + ICONSLOT) or 10
end

local function elementicon(row, value, center)
	local slot = { shifted = hasimage(value) }

	function slot.SetColor(color)
		if slot.image and typeof(color) == "Color3" then
			slot.image.ImageColor3 = color
		end
	end

	function slot.Set(newvalue)
		local has = hasimage(newvalue)
		if has and not slot.image then
			local img = instance.imagelabel(row)
			img.Name = "ElementIcon"
			img.BackgroundTransparency = 1
			img.AnchorPoint = Vector2.new(0, 0.5)
			img.Position = UDim2.new(0, 10, 0, center)
			img.Size = UDim2.new(0, 14, 0, 14)
			img.ImageColor3 = theme.SubText
			slot.image = img
		end
		if slot.image then
			slot.image.Visible = has
			if has then
				applyicon(slot.image, newvalue, 48)
			end
		end
		if has ~= slot.shifted then
			slot.shifted = has
			local delta = has and ICONSLOT or -ICONSLOT
			local from = has and 10 or (10 + ICONSLOT)
			for _, child in ipairs(row:GetChildren()) do
				if child:IsA("TextLabel") then
					local pos, size = child.Position, child.Size
					if pos.X.Scale == 0 and pos.X.Offset == from then
						child.Position = UDim2.new(0, pos.X.Offset + delta, pos.Y.Scale, pos.Y.Offset)
						child.Size = UDim2.new(size.X.Scale, size.X.Offset - delta, size.Y.Scale, size.Y.Offset)
					end
				end
			end
		end
	end

	slot.Set(value)
	return slot
end

local function iconapi(func, slot)
	function func:SetIcon(value)
		slot.Set(value)
	end
	function func:SetIconColor(color)
		slot.SetColor(color)
	end
end

local function watchwidth(row, relayout)
	local lastwidth = -1
	local queued = false
	row:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local width = math.floor(row.AbsoluteSize.X + 0.5)
		if width == lastwidth or width <= 1 or queued then
			return
		end
		lastwidth = width
		queued = true
		task.defer(function()
			queued = false
			relayout()
		end)
	end)
end

