function MXHUB.ToastHolder()
	local gui = sv.coregui:FindFirstChild("NotifyGui")
	if not gui then
		gui = instance.screengui(sv.coregui)
		gui.Name = "NotifyGui"
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		gui.ResetOnSpawn = false
		gui.DisplayOrder = 9999
	end

	local holder = gui:FindFirstChild("NotifyTopLeft")
	if holder then
		return holder
	end

	holder = instance.frame(gui)
	holder.Name = "NotifyTopLeft"
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.AnchorPoint = Vector2.new(0, 0)
	holder.Position = UDim2.new(0, 14, 0, 14)
	holder.Size = UDim2.new(0, 250, 1, -28)
	local layout = instance.uilistlayout(holder)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Padding = UDim.new(0, 6)
	return holder
end

MXHUB.ToastState = {
	Serial = 0,
	Max = 6,
	Slide = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	Leave = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
}

local function buildnotify(cfg, top)
	elevate()
	local holder = MXHUB.ToastHolder()
	local toaststate = MXHUB.ToastState
	toaststate.Serial = toaststate.Serial + 1

	local width = 250
	local textsize = tonumber(cfg.TextSize) or 12
	local titlesize = tonumber(cfg.HeaderSize) or 13
	local accent = typeof(cfg.Color) == "Color3" and cfg.Color or theme.Accent
	local content = tostring(cfg.Content or "")
	local desc = tostring(cfg.Description or "")
	if desc == "Notification" then
		desc = ""
	end

	local toasts = {}
	for _, child in ipairs(holder:GetChildren()) do
		if child:IsA("Frame") then
			toasts[#toasts + 1] = child
		end
	end
	while #toasts >= toaststate.Max do
		local oldest = table.remove(toasts, 1)
		pcall(function()
			oldest:Destroy()
		end)
	end

	local hasicon = hasimage(cfg.Icon)
	local textx = hasicon and 38 or 14
	local bodyheight = 0
	if content ~= "" then
		bodyheight = math.max(textsize, textheight(content, textsize, Enum.Font.Gotham, width - textx - 14, textsize * 8))
	end
	local height = 9 + 16 + (bodyheight > 0 and (3 + bodyheight) or 0) + 12

	local wrapper = instance.frame(holder)
	wrapper.Name = "Toast"
	wrapper.LayoutOrder = toaststate.Serial
	wrapper.BackgroundTransparency = 1
	wrapper.BorderSizePixel = 0
	wrapper.Size = UDim2.new(1, 0, 0, height)

	local card = instance.frame(wrapper)
	card.Name = "Card"
	card.BackgroundColor3 = theme.Card
	card.BackgroundTransparency = 0.05
	card.BorderSizePixel = 0
	card.ClipsDescendants = true
	card.Position = UDim2.new(-1.25, 0, 0, 0)
	card.Size = UDim2.new(1, 0, 1, 0)
	instance.uicorner(card).CornerRadius = UDim.new(0, 6)
	local cardstroke = instance.uistroke(card)
	cardstroke.Color = Color3.fromRGB(255, 255, 255)
	cardstroke.Transparency = 0.92
	cardstroke.Thickness = 1

	local strip = instance.frame(card)
	strip.Name = "Accent"
	strip.BackgroundColor3 = accent
	strip.BorderSizePixel = 0
	strip.Size = UDim2.new(0, 3, 1, 0)

	local title = instance.textlabel(card)
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.BorderSizePixel = 0
	title.Font = Enum.Font.GothamBold
	title.RichText = true
	title.TextSize = titlesize
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextTruncate = Enum.TextTruncate.AtEnd
	title.Position = UDim2.new(0, textx, 0, 9)
	title.Size = UDim2.new(1, -(textx + 10), 0, 16)
	local titletext = escaperich(cfg.Title or "MX HUB")
	if desc ~= "" then
		titletext = titletext .. '  <font color="' .. hexcolor(accent) .. '">' .. escaperich(desc) .. "</font>"
	end
	title.Text = titletext

	local body
	if bodyheight > 0 then
		body = instance.textlabel(card)
		body.Name = "Body"
		body.BackgroundTransparency = 1
		body.BorderSizePixel = 0
		body.Font = Enum.Font.Gotham
		body.Text = content
		body.TextSize = textsize
		body.TextColor3 = theme.SubText
		body.TextWrapped = true
		body.TextXAlignment = Enum.TextXAlignment.Left
		body.TextYAlignment = Enum.TextYAlignment.Top
		body.Position = UDim2.new(0, textx, 0, 28)
		body.Size = UDim2.new(1, -(textx + 10), 0, bodyheight)
	end

	local toasticon
	local function seticon(value)
		local has = hasimage(value)
		if has and not toasticon then
			toasticon = instance.imagelabel(card)
			toasticon.Name = "Icon"
			toasticon.BackgroundTransparency = 1
			toasticon.Position = UDim2.new(0, 14, 0, 9)
			toasticon.Size = UDim2.new(0, 16, 0, 16)
			toasticon.ImageColor3 = accent
		end
		if toasticon then
			toasticon.Visible = has
			if has then
				applyicon(toasticon, value, 48)
			end
		end
	end
	seticon(cfg.Icon)

	local barback = instance.frame(card)
	barback.Name = "TimerTrack"
	barback.BackgroundColor3 = accent
	barback.BackgroundTransparency = 0.8
	barback.BorderSizePixel = 0
	barback.Position = UDim2.new(0, 0, 1, -2)
	barback.Size = UDim2.new(1, 0, 0, 2)
	local bar = instance.frame(barback)
	bar.Name = "Timer"
	bar.BackgroundColor3 = accent
	bar.BorderSizePixel = 0
	bar.Size = UDim2.new(1, 0, 1, 0)

	local hit = instance.textbutton(card)
	hit.Name = "Hit"
	hit.Text = ""
	hit.BackgroundTransparency = 1
	hit.BorderSizePixel = 0
	hit.Size = UDim2.new(1, 0, 1, 0)
	hit.ZIndex = 5

	local handle = {}
	local closed = false

	function handle:Close()
		if closed then
			return
		end
		closed = true
		pcall(function()
			sv.ts:Create(card, toaststate.Leave, { Position = UDim2.new(-1.25, 0, 0, 0) }):Play()
			sv.ts:Create(wrapper, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 0) }):Play()
		end)
		task.delay(0.27, function()
			pcall(function()
				wrapper:Destroy()
			end)
		end)
	end

	function handle:SetIcon(value)
		seticon(value)
	end

	function handle:SetContent(text)
		if body then
			body.Text = tostring(text or "")
		end
	end

	hit.Activated:Connect(function()
		handle:Close()
	end)

	sv.ts:Create(card, toaststate.Slide, { Position = UDim2.new(0, 0, 0, 0) }):Play()
	local life = math.max(0.5, tonumber(cfg.Delay) or 4)
	sv.ts:Create(bar, TweenInfo.new(life, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) }):Play()

	return handle
end

function MXHUB:MakeNotify(notifyconfig)
	notifyconfig = notifyconfig or {}
	notifyconfig.Title = tostring(notifyconfig.Title or "MX HUB")
	notifyconfig.Description = tostring(notifyconfig.Description or "Notification")
	notifyconfig.Content = tostring(notifyconfig.Content or "Content")
	notifyconfig.Color = notifyconfig.Color or theme.Accent
	notifyconfig.Time = tonumber(notifyconfig.Time) or 0.5
	notifyconfig.Delay = tonumber(notifyconfig.Delay) or 5

	if MXHUB.NotificationsEnabled == false and not notifyconfig.Force then
		return {
			Close = function() end,
			SetContent = function() end,
		}
	end

	local handle = buildnotify(notifyconfig, false)
	task.delay(notifyconfig.Delay, function()
		handle:Close()
	end)
	return handle
end

local function mxhub(msg, delay, color, title, desc)
	return MXHUB:MakeNotify({
		Title = title or "MX HUB",
		Description = desc or "Notification",
		Content = msg or "Content",
		Color = color or theme.Accent,
		Delay = delay or 4,
	})
end

function MXHUB:Notify(notifyconfig)
	notifyconfig = notifyconfig or {}
	return MXHUB:MakeNotify({
		Title = notifyconfig.Title or notifyconfig[1] or "MX HUB",
		Description = notifyconfig.Description or notifyconfig.Desc or "Notification",
		Content = notifyconfig.Content or notifyconfig.Text or notifyconfig[2] or "",
		Color = notifyconfig.Color or theme.Accent,
		Delay = tonumber(notifyconfig.Duration or notifyconfig.Delay or notifyconfig.Time or notifyconfig[3]) or 4,
		Icon = notifyconfig.Icon,
		Force = notifyconfig.Force,
	})
end

local WatermarkGui

