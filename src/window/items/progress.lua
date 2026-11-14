function items:AddProgress(progressconfig)
	progressconfig = progressconfig or {}
	progressconfig.Title = progressconfig.Title or progressconfig.Name or "Progress"
	local min = tonumber(progressconfig.Min) or 0
	local max = math.max(tonumber(progressconfig.Max) or 100, min + 1e-9)
	local format = type(progressconfig.Format) == "function" and progressconfig.Format or nil

	local progressfunc = { Value = math.clamp(tonumber(progressconfig.Default) or min, min, max) }

	local row = instance.frame(sectionadd)
	row.Name = "Progress"
	row.BorderSizePixel = 0
	row.LayoutOrder = countitem
	row.Size = UDim2.new(1, 0, 0, 46)
	roundbg(row, design.Radius.Control, theme.Row)

	local description = contenttext(progressconfig)
	local ix = elementiconx(progressconfig)
	iconapi(progressfunc, elementicon(row, progressconfig.Icon, 17))

	local title = instance.textlabel(row)
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamMedium
	title.TextSize = design.Font.Label
	title.TextColor3 = theme.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.Position = UDim2.new(0, ix, 0, 9)
	title.Size = UDim2.new(1, -(ix + 84), 0, 16)
	title.Text = progressconfig.Title

	local readout = instance.textlabel(row)
	readout.Name = "Value"
	readout.BackgroundTransparency = 1
	readout.Font = Enum.Font.GothamBold
	readout.TextSize = 12
	readout.TextColor3 = theme.SubText
	readout.TextXAlignment = Enum.TextXAlignment.Right
	readout.AnchorPoint = Vector2.new(1, 0)
	readout.Position = UDim2.new(1, -design.Row.Pad, 0, 9)
	readout.Size = UDim2.new(0, 76, 0, 16)

	local track = instance.frame(row)
	track.Name = "Track"
	track.BorderSizePixel = 0
	track.BackgroundColor3 = theme.Track
	track.Position = UDim2.new(0, design.Row.Pad, 0, 32)
	track.Size = UDim2.new(1, -design.Row.Pad * 2, 0, 6)
	instance.uicorner(track).CornerRadius = UDim.new(1, 0)

	local fill = instance.frame(track)
	fill.Name = "Fill"
	fill.BorderSizePixel = 0
	fill.BackgroundColor3 = typeof(progressconfig.Color) == "Color3" and progressconfig.Color or theme.Accent
	fill.Size = UDim2.new(0, 0, 1, 0)
	instance.uicorner(fill).CornerRadius = UDim.new(1, 0)

	local function fractionof(value)
		return (value - min) / (max - min)
	end

	local function show(value, instant)
		local fraction = fractionof(value)
		readout.Text = format and tostring(format(value, fraction)) or string.format("%d%%", math.floor(fraction * 100 + 0.5))
		local size = UDim2.new(fraction, 0, 1, 0)
		if instant then
			fill.Size = size
		else
			tw(fill, { Size = size }, design.Anim.Slow)
		end
	end

	if description then
		local _, measure = attachcontent(row, description, ix, 27, design.Row.Pad)
		local function relayout()
			local y = 27 + measure() + 8
			track.Position = UDim2.new(0, design.Row.Pad, 0, y)
			row.Size = UDim2.new(1, 0, 0, y + 6 + 12)
		end
		relayout()
		watchwidth(row, relayout)
	end

	show(progressfunc.Value, true)

	function progressfunc:Set(value, instant)
		progressfunc.Value = math.clamp(tonumber(value) or progressfunc.Value, min, max)
		show(progressfunc.Value, instant == true)
	end

	function progressfunc:Get()
		return progressfunc.Value
	end

	function progressfunc:SetColor(color)
		if typeof(color) == "Color3" then
			fill.BackgroundColor3 = color
		end
	end

	registerSearchItem(progressconfig.Title, row, "Progress")
	countitem = countitem + 1
	yieldbuild()
	return progressfunc
end
