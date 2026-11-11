local MXLIB = loadstring(game:HttpGet("https://raw.githubusercontent.com/MXHUBOFCL/MXLIB/refs/heads/main/MXLIB.lua"))()

local window = MXLIB:CreateWindow({ name = "Example" })
local tab = window:CreateTab({ name = "Media", icon = 93364949241311 })

tab:CreateSection({ name = "Banner" })

local banner = tab:CreateImage({
	image = 93364949241311,
	height = 150,
	fit = "cover",
	cornerRadius = 10,
	border = true,
})

tab:CreateSection({ name = "Icons", side = "left" })

local esp = tab:CreateToggle({
	name = "ESP",
	icon = "eye",
	value = true,
})

tab:CreateSlider({
	name = "Distance",
	icon = "rbxassetid://93364949241311",
	range = { 50, 500 },
	value = 200,
	suffix = " studs",
})

tab:CreateButton({
	name = "Swap icons",
	icon = getcustomasset("my-icons/alert.png"),
	callback = function()
		esp:SetIcon("eye-off")
		banner:SetFit("contain")
	end,
})

tab:CreateCharacter({ side = "right", height = 250 })

window:Notify({
	title = "Avatar",
	content = "Thumbnail icon.",
	icon = MXLIB.Image.Thumbnail("AvatarHeadShot", game.Players.LocalPlayer.UserId, 150),
})
