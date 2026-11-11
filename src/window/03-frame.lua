local dropshadowholder = instance.frame(mxhubui)
dropshadowholder.Name = "DropShadowHolder"
dropshadowholder.BackgroundTransparency = 1
dropshadowholder.BorderSizePixel = 0
dropshadowholder.AnchorPoint = Vector2.new(0.5, 0.5)
dropshadowholder.Position = UDim2.new(0.5, 0, 0.5, 0)
dropshadowholder.ZIndex = 0
if isMobile then
	dropshadowholder.Size = safesize(470, 270)
else
	dropshadowholder.Size = safesize(640, 400)
end

dropshadowholder.Position = UDim2.new(0.5, 0, 0.5, 0)

local dropshadow = instance.frame(dropshadowholder)
dropshadow.Name = "Shell"
dropshadow.BackgroundTransparency = 1
dropshadow.BorderSizePixel = 0
dropshadow.AnchorPoint = Vector2.new(0.5, 0.5)
dropshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
dropshadow.Size = UDim2.new(1, 47, 1, 47)
dropshadow.ZIndex = 0

local bgRaw = guiconfig.Background
	or guiconfig.BackgroundImage
	or (userPassedImage and tostring(userPassedImage):gsub("%s+", "") ~= assets.LogoId and userPassedImage)
	or nil

local bgAsset = nil
if bgRaw then
	local s = iconstring(bgRaw)
	if s ~= "" and s:lower() ~= "none" and s:lower() ~= "false" then
		bgAsset = resolveiconasset(s)
	end
end

local main
if bgAsset then
	main = instance.imagelabel(dropshadow)
	main.Image = bgAsset
	main.ScaleType = Enum.ScaleType.Crop
	main.BackgroundTransparency = 0
	main.BackgroundColor3 = theme.Backdrop
	local dim = math.clamp(tonumber(guiconfig.ThemeDim or guiconfig.BackgroundDim) or 0.68, 0, 1)
	local gray = math.floor((1 - dim) * 255 + 0.5)
	main.ImageColor3 = Color3.fromRGB(gray, gray, gray)
	rowalpha = math.clamp(tonumber(guiconfig.RowTransparency or guiconfig.RowAlpha) or 0, 0, 0.9)
else
	rowalpha = 0
	main = instance.frame(dropshadow)
	main.BackgroundColor3 = theme.Backdrop
	main.BackgroundTransparency = 1
end

local mainstroke = instance.uistroke(main)
mainstroke.Color = theme.Stroke
mainstroke.Thickness = 1
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BorderColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(1, -47, 1, -47)

local uicorner = instance.uicorner(main)

if bgAsset then
	local scrim = instance.frame(main)
	scrim.Name = "Scrim"
	scrim.BackgroundColor3 = theme.Backdrop
	scrim.BackgroundTransparency = 0

	local scrimleft = math.clamp(tonumber(guiconfig.ThemeScrim) or 0.15, 0, 1)
	local scrimright = math.clamp(tonumber(guiconfig.ThemeScrimRight) or 0.55, 0, 1)
	local scrimgradient = instance.uigradient(scrim)
	scrimgradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, scrimleft),
		NumberSequenceKeypoint.new(0.3, math.min(1, scrimleft + 0.1)),
		NumberSequenceKeypoint.new(1, scrimright),
	})
	scrim.BorderSizePixel = 0
	scrim.Size = UDim2.new(1, 0, 1, 0)
	scrim.ZIndex = 0
	instance.uicorner(scrim).CornerRadius = uicorner.CornerRadius
end

