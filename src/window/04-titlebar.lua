local top = instance.frame(main)
top.Name = "Top"
top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
top.BackgroundTransparency = 1
top.BorderColor3 = Color3.fromRGB(0, 0, 0)
top.BorderSizePixel = 0
top.Size = UDim2.new(1, 0, 0, 38)

local textlabel = instance.textlabel(top)
textlabel.Font = Enum.Font.GothamBlack
textlabel.Text = guiconfig.IconRail == true and "MX" or guiconfig.Title
textlabel.TextColor3 = theme.Text
textlabel.TextSize = 20
textlabel.TextXAlignment = Enum.TextXAlignment.Left
textlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textlabel.BackgroundTransparency = 1
textlabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
textlabel.BorderSizePixel = 0
textlabel.Size = UDim2.new(1, -100, 1, 0)
textlabel.Position = UDim2.new(0, 14, 0, 0)
textlabel.ZIndex = 2

local titleglow = instance.textlabel(top)
titleglow.Name = "TitleGlow"
titleglow.Font = Enum.Font.GothamBlack
titleglow.Text = textlabel.Text
titleglow.TextColor3 = theme.Accent
titleglow.TextSize = 20
titleglow.TextXAlignment = Enum.TextXAlignment.Left
titleglow.BackgroundTransparency = 1
titleglow.BorderSizePixel = 0
titleglow.ZIndex = 1
titleglow.Position = UDim2.new(0, 15, 0, 0)
titleglow.Size = UDim2.new(0, guiconfig["Tab Width"], 1, 0)

local uicorner1 = instance.uicorner(top)

local textlabel1 = instance.textlabel(top)
textlabel1.Font = Enum.Font.GothamBold
textlabel1.Text = guiconfig.Footer
textlabel1.TextColor3 = theme.SubText
textlabel1.TextSize = 14
textlabel1.TextXAlignment = Enum.TextXAlignment.Left
textlabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textlabel1.BackgroundTransparency = 1
textlabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
textlabel1.BorderSizePixel = 0
textlabel1.Visible = false

local headergap = math.clamp(tonumber(guiconfig.TitleGap) or 22, 8, 60)
local function measuretitle()
	local okm, bounds = pcall(function()
		return sv.textservice:GetTextSize(tostring(textlabel.Text), 20, Enum.Font.GothamBlack, Vector2.new(1000, 38))
	end)
	if okm and bounds and bounds.X > 0 then
		return math.ceil(bounds.X)
	end
	return math.ceil(textlabel.TextBounds.X)
end
local titlewidth = measuretitle()
do
	local sidew = guiconfig["Tab Width"] + 10
	local startx = math.max(math.floor((sidew - titlewidth) / 2), 4)
	textlabel.Position = UDim2.new(0, startx, 0, 0)
	textlabel.Size = UDim2.new(0, titlewidth + 2, 1, 0)
	titleglow.Position = UDim2.new(0, startx + 1, 0, 0)
	titleglow.Size = textlabel.Size
end
local footerx = 18 + titlewidth + headergap
textlabel1.TextTruncate = Enum.TextTruncate.AtEnd
textlabel1.Size = UDim2.new(1, -(footerx + 66 + (isMobile and 110 or 150) + 10), 1, 0)
textlabel1.Position = UDim2.new(0, footerx, 0, 0)

local headerdivider = instance.frame(top)
headerdivider.Name = "TitleDivider"
headerdivider.AnchorPoint = Vector2.new(0.5, 0.5)
headerdivider.BackgroundColor3 = theme.Stroke
headerdivider.BackgroundTransparency = 0.1
headerdivider.BorderSizePixel = 0
headerdivider.Position = UDim2.new(0, 18 + titlewidth + headergap / 2, 0.5, 0)
headerdivider.Size = UDim2.new(0, 1, 0, 14)
headerdivider.Visible = false

local close = instance.textbutton(top)
close.Name = "Close"
close.Font = Enum.Font.SourceSans
close.Text = ""
close.TextColor3 = Color3.fromRGB(0, 0, 0)
close.TextSize = 14
close.AnchorPoint = Vector2.new(1, 0.5)
close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
close.BackgroundTransparency = 1
close.BorderColor3 = Color3.fromRGB(0, 0, 0)
close.BorderSizePixel = 0
close.Position = UDim2.new(1, -8, 0.5, 0)
close.Size = UDim2.new(0, 25, 0, 25)

local imagelabel1 = instance.imagelabel(close)
applyicon(imagelabel1, "x", 48)
imagelabel1.AnchorPoint = Vector2.new(0.5, 0.5)
imagelabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
imagelabel1.BackgroundTransparency = 1
imagelabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
imagelabel1.BorderSizePixel = 0
imagelabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
imagelabel1.Size = UDim2.new(1, -8, 1, -8)

local min = instance.textbutton(top)
min.Name = "Min"
min.Font = Enum.Font.SourceSans
min.Text = ""
min.TextColor3 = Color3.fromRGB(0, 0, 0)
min.TextSize = 14
min.AnchorPoint = Vector2.new(1, 0.5)
min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
min.BackgroundTransparency = 1
min.BorderColor3 = Color3.fromRGB(0, 0, 0)
min.BorderSizePixel = 0
min.Position = UDim2.new(1, -38, 0.5, 0)
min.Size = UDim2.new(0, 25, 0, 25)

local imagelabel2 = instance.imagelabel(min)
applyicon(imagelabel2, "minus", 48)
imagelabel2.AnchorPoint = Vector2.new(0.5, 0.5)
imagelabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
imagelabel2.BackgroundTransparency = 1
imagelabel2.ImageTransparency = 0.2
imagelabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
imagelabel2.BorderSizePixel = 0
imagelabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
imagelabel2.Size = UDim2.new(1, -9, 1, -9)

local searchbox = instance.textbox(top)
searchbox.Name = "SearchBox"
searchbox.AnchorPoint = Vector2.new(1, 0.5)
searchbox.Position = UDim2.new(1, -66, 0.5, 0)
searchbox.Size = UDim2.new(0, isMobile and 110 or 150, 0, 24)
searchbox.BackgroundColor3 = theme.Pill
searchbox.BackgroundTransparency = 0
searchbox.BorderSizePixel = 0
searchbox.Font = Enum.Font.Gotham
searchbox.PlaceholderText = "Search"
searchbox.PlaceholderColor3 = theme.Dim
searchbox.Text = ""
searchbox.TextColor3 = theme.Text
searchbox.TextSize = 12
searchbox.TextXAlignment = Enum.TextXAlignment.Left
searchbox.ClearTextOnFocus = false
searchbox.ClipsDescendants = true
searchbox.TextTruncate = Enum.TextTruncate.AtEnd
instance.uicorner(searchbox).CornerRadius = UDim.new(1, 0)

local searchstroke = instance.uistroke(searchbox)
searchstroke.Color = theme.Stroke
searchstroke.Thickness = 1
searchstroke.Transparency = 0.35

local searchpad = instance.uipadding(searchbox)
searchpad.PaddingLeft = UDim.new(0, 26)
searchpad.PaddingRight = UDim.new(0, 10)

local searchicon = instance.imagelabel(searchbox)
searchicon.AnchorPoint = Vector2.new(0, 0.5)
searchicon.Position = UDim2.new(0, -17, 0.5, 0)
searchicon.Size = UDim2.new(0, 12, 0, 12)
searchicon.BackgroundTransparency = 1
searchicon.ImageColor3 = theme.Dim
applyicon(searchicon, "search", 48)

