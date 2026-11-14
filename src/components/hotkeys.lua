local hotkeys = { entries = {}, lastid = 0 }

local HOTKEYS_NAME = "HotkeysGui"
local ROW_HEIGHT = 24

local overlay = { gui = nil, panel = nil, list = nil, connections = {} }

local function hotkeyrows()
	local rows = {}
	for _, entry in pairs(hotkeys.entries) do
		local key, mode = entry.describe()
		if key and key ~= "" and key ~= "None" then
			rows[#rows + 1] = { title = entry.title, key = key, mode = mode or "Press" }
		end
	end
	table.sort(rows, function(a, b)
		return a.title:lower() < b.title:lower()
	end)
	return rows
end

local function modelabel(mode)
	local text = tostring(mode)
	return text:sub(1, 1):upper() .. text:sub(2):lower()
end

local function rebuild()
	if not overlay.list then
		return
	end
	for _, child in ipairs(overlay.list:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	local rows = hotkeyrows()
	overlay.panel.Visible = true
	for index, entry in ipairs(rows) do
		local row = instance.frame(overlay.list)
		row.Name = "Hotkey"
		row.LayoutOrder = index
		row.BackgroundTransparency = 1
		row.BorderSizePixel = 0
		row.Size = UDim2.new(1, 0, 0, ROW_HEIGHT)
		local function cell(text, x, width, align, color, font)
			local label = instance.textlabel(row)
			label.BackgroundTransparency = 1
			label.Font = font or Enum.Font.GothamMedium
			label.TextSize = 12
			label.TextColor3 = color
			label.TextXAlignment = align
			label.TextTruncate = Enum.TextTruncate.AtEnd
			label.Position = x
			label.Size = width
			label.Text = text
		end
		cell(entry.title, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, -6, 1, 0), Enum.TextXAlignment.Left, theme.Text)
		cell(entry.key, UDim2.new(0.5, 0, 0, 0), UDim2.new(0.25, 0, 1, 0), Enum.TextXAlignment.Center, theme.SubText)
		cell(modelabel(entry.mode), UDim2.new(0.75, 0, 0, 0), UDim2.new(0.25, 0, 1, 0), Enum.TextXAlignment.Right, theme.Dim)
	end
	overlay.empty.Visible = #rows == 0
end

function hotkeys.register(title, describe)
	hotkeys.lastid += 1
	hotkeys.entries[hotkeys.lastid] = { title = tostring(title), describe = describe }
	rebuild()
	return hotkeys.lastid
end

function hotkeys.unregister(id)
	hotkeys.entries[id] = nil
	rebuild()
end

function hotkeys.touch()
	rebuild()
end

local function closeoverlay()
	for _, connection in ipairs(overlay.connections) do
		connection:Disconnect()
	end
	table.clear(overlay.connections)
	if overlay.gui then
		overlay.gui:Destroy()
	end
	overlay.gui, overlay.panel, overlay.list, overlay.empty = nil, nil, nil, nil
end

function MXHUB.ShowHotkeys(state)
	if state ~= true then
		closeoverlay()
		return
	end
	if overlay.gui then
		return
	end
	elevate()

	local gui = instance.screengui(sv.coregui)
	gui.Name = HOTKEYS_NAME
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 50

	local panel = instance.frame(gui)
	panel.Name = "Panel"
	panel.BackgroundColor3 = theme.Card
	panel.BackgroundTransparency = 0.04
	panel.BorderSizePixel = 0
	panel.Position = UDim2.new(0, 24, 0.5, -90)
	panel.Size = UDim2.new(0, 236, 0, 0)
	panel.AutomaticSize = Enum.AutomaticSize.Y
	instance.uicorner(panel).CornerRadius = UDim.new(0, design.Radius.Card)
	local stroke = instance.uistroke(panel)
	stroke.Color = theme.Stroke
	stroke.Thickness = 1
	stroke.Transparency = 0.3
	local layout = instance.uilistlayout(panel)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local header = instance.frame(panel)
	header.Name = "Header"
	header.LayoutOrder = 0
	header.BackgroundTransparency = 1
	header.Size = UDim2.new(1, 0, 0, 36)
	local icon = instance.imagelabel(header)
	icon.BackgroundTransparency = 1
	icon.AnchorPoint = Vector2.new(0, 0.5)
	icon.Position = UDim2.new(0, 12, 0.5, 0)
	icon.Size = UDim2.new(0, 14, 0, 14)
	icon.ImageColor3 = theme.Accent
	applyicon(icon, "keyboard", 48)
	local title = instance.textlabel(header)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 13
	title.TextColor3 = theme.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Position = UDim2.new(0, 34, 0, 0)
	title.Size = UDim2.new(1, -46, 1, 0)
	title.Text = "Hotkeys"

	local columns = instance.frame(panel)
	columns.Name = "Columns"
	columns.LayoutOrder = 1
	columns.BackgroundTransparency = 1
	columns.Size = UDim2.new(1, 0, 0, 20)
	local columnpad = instance.uipadding(columns)
	columnpad.PaddingLeft = UDim.new(0, 12)
	columnpad.PaddingRight = UDim.new(0, 12)
	for _, spec in ipairs({
		{ "Function", UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 1, 0), Enum.TextXAlignment.Left },
		{ "Key", UDim2.new(0.5, 0, 0, 0), UDim2.new(0.25, 0, 1, 0), Enum.TextXAlignment.Center },
		{ "Mode", UDim2.new(0.75, 0, 0, 0), UDim2.new(0.25, 0, 1, 0), Enum.TextXAlignment.Right },
	}) do
		local label = instance.textlabel(columns)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamBold
		label.TextSize = 10
		label.TextColor3 = theme.Dim
		label.TextXAlignment = spec[4]
		label.Position = spec[2]
		label.Size = spec[3]
		label.Text = spec[1]:upper()
	end

	local list = instance.frame(panel)
	list.Name = "List"
	list.LayoutOrder = 2
	list.BackgroundTransparency = 1
	list.Size = UDim2.new(1, 0, 0, 0)
	list.AutomaticSize = Enum.AutomaticSize.Y
	local listpad = instance.uipadding(list)
	listpad.PaddingLeft = UDim.new(0, 12)
	listpad.PaddingRight = UDim.new(0, 12)
	listpad.PaddingBottom = UDim.new(0, 10)
	local listlayout = instance.uilistlayout(list)
	listlayout.SortOrder = Enum.SortOrder.LayoutOrder

	local empty = instance.textlabel(panel)
	empty.Name = "Empty"
	empty.LayoutOrder = 3
	empty.BackgroundTransparency = 1
	empty.Font = Enum.Font.Gotham
	empty.TextSize = 12
	empty.TextColor3 = theme.Dim
	empty.Size = UDim2.new(1, 0, 0, 28)
	empty.Text = "No keys bound yet"

	overlay.gui, overlay.panel, overlay.list, overlay.empty = gui, panel, list, empty

	local dragging, startpoint, origin = false, nil, nil
	local function pointer(input)
		return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
	end
	overlay.connections[#overlay.connections + 1] = header.InputBegan:Connect(function(input)
		if pointer(input) then
			dragging, startpoint, origin = true, input.Position, panel.Position
		end
	end)
	overlay.connections[#overlay.connections + 1] = sv.uis.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - startpoint
			panel.Position = UDim2.new(origin.X.Scale, origin.X.Offset + delta.X, origin.Y.Scale, origin.Y.Offset + delta.Y)
		end
	end)
	overlay.connections[#overlay.connections + 1] = sv.uis.InputEnded:Connect(function(input)
		if dragging and pointer(input) then
			dragging = false
		end
	end)
	rebuild()
end

function MXHUB.IsHotkeysShown()
	return overlay.gui ~= nil
end
