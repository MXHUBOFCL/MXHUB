if not tabconfig.Hidden then
	tab.Parent = scrolltab
end
tab.Name = "Tab"
tab.BorderSizePixel = 0
tab.LayoutOrder = layoutOrder
tab.Size = UDim2.new(1, -6, 0, 32)
local tabbg = roundbg(tab, design.Radius.Control, theme.TabActive)
tabbg.ImageTransparency = isFirstTab and 0 or 1

local tabbutton = instance.textbutton(tab)
tabbutton.Name = "TabButton"
tabbutton.Font = Enum.Font.GothamBold
tabbutton.Text = ""
tabbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
tabbutton.TextSize = 13
tabbutton.TextXAlignment = Enum.TextXAlignment.Left
tabbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabbutton.BackgroundTransparency = 1
tabbutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
tabbutton.BorderSizePixel = 0
tabbutton.Size = UDim2.new(1, 0, 1, 0)

local onOpenCallback
local onOpenRan = false

local function runOnOpen()
	if onOpenRan or not onOpenCallback then
		return
	end

	onOpenRan = true
	local ok, err = pcall(onOpenCallback)
	if not ok then
		warn("Tab OnOpen error:", err)
	end
end

local tabname = instance.textlabel(tab)
tabname.Name = "TabName"
tabname.Font = Enum.Font.GothamMedium
tabname.Text = tostring(tabconfig.Name)
tabname.TextColor3 = Color3.fromRGB(255, 255, 255)
tabname.TextSize = 13
tabname.TextTruncate = Enum.TextTruncate.AtEnd
tabname.TextXAlignment = Enum.TextXAlignment.Left
tabname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabname.BackgroundTransparency = 1
tabname.BorderColor3 = Color3.fromRGB(0, 0, 0)
tabname.BorderSizePixel = 0

local tabicon
local function settabicon(value)
	local has = value ~= nil and value ~= ""
	if has and not tabicon then
		tabicon = instance.imagelabel(tab)
		tabicon.Name = "TabIcon"
		tabicon.AnchorPoint = Vector2.new(0, 0.5)
		tabicon.Position = UDim2.new(0, 10, 0.5, 0)
		tabicon.Size = UDim2.new(0, 16, 0, 16)
		tabicon.BackgroundTransparency = 1
		tabicon.ImageColor3 = isFirstTab and theme.Accent or theme.SubText
	end
	if tabicon then
		tabicon.Visible = has
		if has then
			applyicon(tabicon, value, 48)
		end
	end
	tabname.Size = UDim2.new(1, -(has and 36 or 14), 1, 0)
	tabname.Position = UDim2.new(0, has and 34 or 12, 0, 0)
end

tabname.TextColor3 = isFirstTab and theme.Text or theme.SubText
settabicon(tabconfig.Icon)

if guiconfig.IconRail == true then
	tab.Size = UDim2.new(1, -6, 0, 32)
	tabname.Visible = false
	if tabicon then
		tabicon.AnchorPoint = Vector2.new(0.5, 0.5)
		tabicon.Position = UDim2.new(0.5, 0, 0.5, 0)
		tabicon.Size = UDim2.new(0, 18, 0, 18)
	end
end

if isFirstTab then
	layerspagelayout:JumpTo(scrollayers)
	local chooseframe = instance.frame(tab)
	chooseframe.Name = "ChooseFrame"
	chooseframe.BackgroundColor3 = theme.Text
	chooseframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
	chooseframe.BorderSizePixel = 0
	chooseframe.Position = UDim2.new(0, 2, 0, guiconfig.IconRail == true and 10 or 8)
	chooseframe.Size = UDim2.new(0, 1, 0, 12)

	local uistroke2 = instance.uistroke(chooseframe)
	uistroke2.Color = theme.Text
	uistroke2.Thickness = 1.6

	instance.uicorner(chooseframe)
end

local tabrec = {}
if isFirstTab then
	MX.Tab = tabrec
end
local subs = {}
local activesub = 1

local function activepage()
	local sub = subs[activesub]
	return sub and sub.Page or scrollayers
end

local function subnames()
	local names = {}
	for index, sub in ipairs(subs) do
		names[index] = sub.Name
	end
	return names
end

local function runsubopen(sub)
	local owner = sub and sub.Sections
	if owner and owner._RunOpen then
		pcall(owner._RunOpen, owner)
	end
end

local function activatesub(index)
	if not subs[index] then
		return
	end
	activesub = index
	layerspagelayout:JumpTo(subs[index].Page)
	if MX.Current == tabrec then
		MX.paintsub(index)
	end
	runsubopen(subs[index])
	if searchbox.Text ~= "" then
		runsearch()
	end
end

local function refreshsubbar()
	if #subs > 0 and MX.Tab == tabrec then
		MX.showsubbar(tabrec, subnames(), activesub, activatesub)
	end
end

local function selecttab()
	if tabconfig._SelectHook then
		return tabconfig._SelectHook()
	end
	if layerspagelayout.CurrentPage == activepage() then
		MX.Tab = tabrec
		refreshsubbar()
		runOnOpen()
		return
	end

	local framechoose
	for _, tabframe in ipairs(scrolltab:GetChildren()) do
		if tabframe.Name == "Tab" then
			local cf = tabframe:FindFirstChild("ChooseFrame")
			if cf then
				framechoose = cf
			end
			local tb = tabframe:FindFirstChild("Bg")
			if tb then
				tw(tb, { ImageTransparency = 1 }, 0.25)
			end
			local tn = tabframe:FindFirstChild("TabName")
			if tn then
				tw(tn, { TextColor3 = theme.SubText }, 0.25)
			end
			local ti = tabframe:FindFirstChild("TabIcon")
			if ti then
				tw(ti, { ImageColor3 = theme.SubText }, 0.25)
			end
		end
	end

	if not framechoose then
		return
	end

	tw(tabbg, { ImageTransparency = 0 }, 0.25)
	tw(tabname, { TextColor3 = theme.Text }, 0.25)
	if tabicon then
		tw(tabicon, { ImageColor3 = theme.Accent }, 0.25)
	end

	local indicatory = guiconfig.IconRail == true and 10 or 8
	local fromy = indicatory
	if framechoose.Parent and framechoose.Parent ~= tab then
		pcall(function()
			fromy = math.clamp(framechoose.AbsolutePosition.Y - tab.AbsolutePosition.Y, -300, 400)
		end)
	end
	framechoose.Parent = tab
	framechoose.Size = UDim2.new(0, 1, 0, 12)
	framechoose.Position = UDim2.new(0, 2, 0, fromy)
	tw(framechoose, { Position = UDim2.new(0, 2, 0, indicatory) }, 0.32)

	layerspagelayout:JumpTo(activepage())
	MX.Tab = tabrec
	if #subs > 0 then
		refreshsubbar()
	else
		MX.clearsubbar()
	end
	runOnOpen()
	runsubopen(subs[activesub])

	if searchbox.Text ~= "" then
		runsearch()
	end
end
tabbutton.Activated:Connect(selecttab)

local sections = {}
function sections:SetIcon(value)
	settabicon(value)
end
local countsection = 0

