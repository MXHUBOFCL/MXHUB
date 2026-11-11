local moreblur = instance.frame(layers)
moreblur.Name = "MoreBlur"
moreblur.AnchorPoint = Vector2.new(1, 1)
moreblur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
moreblur.BackgroundTransparency = 1
moreblur.BorderColor3 = Color3.fromRGB(0, 0, 0)
moreblur.BorderSizePixel = 0
moreblur.ClipsDescendants = true
moreblur.Position = UDim2.new(1, 8, 1, 8)
moreblur.Size = UDim2.new(1, 154, 1, 54)
moreblur.Visible = false

local uicorner28 = instance.uicorner(moreblur)

local connectbutton = instance.textbutton(moreblur)
connectbutton.Name = "ConnectButton"
connectbutton.Font = Enum.Font.SourceSans
connectbutton.Text = ""
connectbutton.TextColor3 = Color3.fromRGB(0, 0, 0)
connectbutton.TextSize = 14
connectbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
connectbutton.BackgroundTransparency = 1
connectbutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
connectbutton.BorderSizePixel = 0
connectbutton.Size = UDim2.new(1, 0, 1, 0)

local dropdownselect = instance.frame(moreblur)
dropdownselect.Name = "DropdownSelect"
dropdownselect.AnchorPoint = Vector2.new(0, 0)
dropdownselect.BackgroundColor3 = theme.Element
dropdownselect.BackgroundTransparency = 0
dropdownselect.BorderColor3 = Color3.fromRGB(0, 0, 0)
dropdownselect.BorderSizePixel = 0
dropdownselect.LayoutOrder = 1
dropdownselect.Position = UDim2.new(0, 0, 0, 0)
dropdownselect.Size = UDim2.new(0, 160, 0, 0)
dropdownselect.ClipsDescendants = true

local uicorner36 = instance.uicorner(dropdownselect)
uicorner36.CornerRadius = UDim.new(0, 3)

local uistroke14 = instance.uistroke(dropdownselect)
uistroke14.Color = theme.Stroke
uistroke14.Thickness = 2.5
uistroke14.Transparency = 0.8

local dropdownselectreal = instance.frame(dropdownselect)
dropdownselectreal.Name = "DropdownSelectReal"
dropdownselectreal.AnchorPoint = Vector2.new(0.5, 0.5)
dropdownselectreal.BackgroundColor3 = theme.Card
dropdownselectreal.BackgroundTransparency = 0
dropdownselectreal.BorderColor3 = Color3.fromRGB(0, 0, 0)
dropdownselectreal.BorderSizePixel = 0
dropdownselectreal.LayoutOrder = 1
dropdownselectreal.Position = UDim2.new(0.5, 0, 0.5, 0)
dropdownselectreal.Size = UDim2.new(1, 1, 1, 1)

local dropdownfolder = instance.folder(dropdownselectreal)
dropdownfolder.Name = "DropdownFolder"

local droppagelayout = instance.uipagelayout(dropdownfolder)
droppagelayout.Name = "DropPageLayout"
droppagelayout.EasingDirection = Enum.EasingDirection.InOut
droppagelayout.EasingStyle = Enum.EasingStyle.Quad
droppagelayout.TweenTime = 0.01
droppagelayout.SortOrder = Enum.SortOrder.LayoutOrder
droppagelayout.FillDirection = Enum.FillDirection.Vertical
droppagelayout.Archivable = false

local popuptoken = 0

local POPUP_GAP = 4
local POPUP_MARGIN = 6
local POPUP_MAXH = isMobile and 240 or 210
local popupinfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local popup = { open = false, anchor = nil, contenth = 0, settle = 0, conn = nil, scroller = nil, arrow = nil }
local arrowinfo = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function turnarrow(arrow, open)
	if arrow and arrow.Parent then
		sv.ts:Create(arrow, arrowinfo, { Rotation = open and 180 or 0 }):Play()
	end
end

local function popupscale()
	return fitscaleof(moreblur)
end

local function popupgeometry()
	local scale = popupscale()
	local origin = moreblur.AbsolutePosition
	local anchor = popup.anchor
	local ax = (anchor.AbsolutePosition.X - origin.X) / scale
	local ay = (anchor.AbsolutePosition.Y - origin.Y) / scale
	local aw = anchor.AbsoluteSize.X / scale
	local ah = anchor.AbsoluteSize.Y / scale

	local areaLeft = (layers.AbsolutePosition.X - origin.X) / scale
	local areaTop = (layers.AbsolutePosition.Y - origin.Y) / scale
	local areaRight = areaLeft + layers.AbsoluteSize.X / scale
	local areaBottom = areaTop + layers.AbsoluteSize.Y / scale

	local want = math.min(popup.contenth, POPUP_MAXH)
	local below = areaBottom - (ay + ah + POPUP_GAP) - POPUP_MARGIN
	local above = (ay - POPUP_GAP) - areaTop - POPUP_MARGIN
	local goup = want > below and above > below
	local height = math.max(40, math.min(want, goup and above or below))

	local maxwidth = math.max(areaRight - areaLeft - POPUP_MARGIN * 2, 60)
	local width = math.min(math.max(aw, 120), maxwidth)
	local x = math.clamp(ax, areaLeft + POPUP_MARGIN, math.max(areaLeft + POPUP_MARGIN, areaRight - POPUP_MARGIN - width))
	return x, goup and (ay - POPUP_GAP) or (ay + ah + POPUP_GAP), width, height, goup
end

local function popupapply(withsize)
	local x, y, width, height, goup = popupgeometry()
	dropdownselect.AnchorPoint = Vector2.new(0, goup and 1 or 0)
	dropdownselect.Position = UDim2.fromOffset(x, y)
	if withsize then
		dropdownselect.Size = UDim2.fromOffset(width, height)
	end
	return width, height
end

local function popupunlock()
	if popup.scroller then
		popup.scroller.ScrollingEnabled = true
		popup.scroller = nil
	end
	if popup.conn then
		popup.conn:Disconnect()
		popup.conn = nil
	end
end

local function closedropdownpopup()
	if not popup.open then
		return
	end
	popup.open = false
	popup.anchor = nil
	turnarrow(popup.arrow, false)
	popup.arrow = nil
	popupunlock()
	popuptoken = popuptoken + 1
	local token = popuptoken
	sv.ts:Create(dropdownselect, popupinfo, { Size = UDim2.fromOffset(dropdownselect.AbsoluteSize.X / popupscale(), 0) }):Play()
	task.delay(0.18, function()
		if popuptoken == token then
			moreblur.Visible = false
		end
	end)
end

local function opendropdownpopup(index, anchor, contenth, arrow)
	popuptoken = popuptoken + 1
	popupunlock()
	if popup.arrow and popup.arrow ~= arrow then
		turnarrow(popup.arrow, false)
	end
	popup.arrow = arrow
	turnarrow(arrow, true)
	droppagelayout:JumpToIndex(index)

	popup.open = true
	popup.anchor = anchor
	popup.contenth = contenth
	moreblur.Visible = true

	local width, height = popupapply(false)
	dropdownselect.Size = UDim2.fromOffset(width, 0)
	popup.settle = os.clock() + 0.2
	sv.ts:Create(dropdownselect, popupinfo, { Size = UDim2.fromOffset(width, height) }):Play()

	local scroller = anchor:FindFirstAncestorWhichIsA("ScrollingFrame")
	if scroller and scroller.ScrollingEnabled then
		popup.scroller = scroller
		scroller.ScrollingEnabled = false
	end

	popup.conn = game:GetService("RunService").RenderStepped:Connect(function()
		local field = popup.anchor
		if not popup.open or not field or not field:IsDescendantOf(layers) then
			closedropdownpopup()
			return
		end
		local box = popup.scroller
		if box then
			local centre = field.AbsolutePosition + field.AbsoluteSize / 2
			local from, size = box.AbsolutePosition, box.AbsoluteSize
			if centre.X < from.X or centre.Y < from.Y or centre.X > from.X + size.X or centre.Y > from.Y + size.Y then
				closedropdownpopup()
				return
			end
		end
		popupapply(os.clock() >= popup.settle)
	end)
end

local function refitdropdownpopup(anchor, contenth)
	if not popup.open or popup.anchor ~= anchor then
		return
	end
	popup.contenth = contenth
	local _, _, width, height = popupgeometry()
	popup.settle = os.clock() + 0.2
	sv.ts:Create(dropdownselect, popupinfo, { Size = UDim2.fromOffset(width, height) }):Play()
end

