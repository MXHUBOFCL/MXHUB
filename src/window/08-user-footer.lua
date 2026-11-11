local userfooter = instance.frame(main)
userfooter.Name = "UserFooter"
userfooter.BackgroundColor3 = theme.Row
userfooter.BackgroundTransparency = rowalpha
userfooter.BorderSizePixel = 0
userfooter.AnchorPoint = Vector2.new(0, 1)
userfooter.Position = UDim2.new(0, 3, 1, -8)
userfooter.Size = UDim2.new(0, guiconfig["Tab Width"], 0, 46)
instance.uicorner(userfooter).CornerRadius = UDim.new(0, 8)
local footerstroke = instance.uistroke(userfooter)
footerstroke.Color = theme.Stroke
footerstroke.Thickness = 1
footerstroke.Transparency = 0.5

local localplayer = sv.plrs.LocalPlayer

local headshot = instance.imagelabel(userfooter)
headshot.Name = "Headshot"
headshot.BackgroundColor3 = theme.Field
headshot.BorderSizePixel = 0
headshot.AnchorPoint = Vector2.new(0, 0.5)
headshot.Position = UDim2.new(0, 8, 0.5, 0)
headshot.Size = UDim2.new(0, 30, 0, 30)
instance.uicorner(headshot).CornerRadius = UDim.new(1, 0)
if localplayer then
	headshot.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100", localplayer.UserId)
end

local onlinedot = instance.frame(userfooter)
onlinedot.Name = "Online"
onlinedot.AnchorPoint = Vector2.new(0.5, 0.5)
onlinedot.BackgroundColor3 = Color3.fromRGB(74, 222, 128)
onlinedot.BorderSizePixel = 0
onlinedot.Position = UDim2.new(0, 35, 0.5, 11)
onlinedot.Size = UDim2.new(0, 9, 0, 9)
instance.uicorner(onlinedot).CornerRadius = UDim.new(1, 0)
local dotstroke = instance.uistroke(onlinedot)
dotstroke.Color = theme.Row
dotstroke.Thickness = 2

local username = instance.textlabel(userfooter)
username.Name = "Username"
username.BackgroundTransparency = 1
username.Font = Enum.Font.GothamBold
username.TextColor3 = theme.Text
username.TextSize = 12
username.TextXAlignment = Enum.TextXAlignment.Left
username.TextTruncate = Enum.TextTruncate.AtEnd
username.Position = UDim2.new(0, 46, 0.5, -14)
username.Size = UDim2.new(1, -54, 0, 14)
if localplayer then
	username.Text = localplayer.DisplayName ~= "" and localplayer.DisplayName or localplayer.Name
else
	username.Text = "User"
end

local handlelabel = instance.textlabel(userfooter)
handlelabel.Name = "Handle"
handlelabel.BackgroundTransparency = 1
handlelabel.Font = Enum.Font.GothamMedium
handlelabel.TextColor3 = theme.SubText
handlelabel.TextSize = 11
handlelabel.TextXAlignment = Enum.TextXAlignment.Left
handlelabel.TextTruncate = Enum.TextTruncate.AtEnd
handlelabel.Position = UDim2.new(0, 46, 0.5, 1)
handlelabel.Size = UDim2.new(1, -54, 0, 13)
handlelabel.Text = localplayer and ("@" .. localplayer.Name) or ""
