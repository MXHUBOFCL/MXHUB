local MXLIB = loadstring(game:HttpGet("https://raw.githubusercontent.com/MXHUBOFCL/MXLIB/refs/heads/main/MXLIB.lua"))()

local window = MXLIB:CreateWindow({
	name = "Example",
	version = "1.0.0",
	theme = "cobalt",
	community = true,
	home = true,
	settings = true,
})

window:CreateSection({ name = "General" })
local main = window:CreateTab({ name = "Home", icon = 93364949241311 })
local servers = window:CreateTab({ name = "Servers", icon = "rbxassetid://93364949241311" })
window:CreateTab({ name = "Combat" })

window:CreateSection({ name = "Reference" })
window:CreateTab({ name = "About" })

main:CreateSection({ name = "Character" })

main:CreateButton({
	name = "Reset character",
	callback = function()
		game.Players.LocalPlayer.Character:BreakJoints()
	end,
})

local sprint = main:CreateToggle({
	name = "Auto Sprint",
	flag = "AutoSprint",
	value = true,
	callback = function(value)
		print("Auto Sprint:", value)
	end,
})

main:CreateSlider({
	name = "Field of view",
	range = { 70, 120 },
	increment = 1,
	value = 90,
	suffix = "°",
	callback = function(value)
		workspace.CurrentCamera.FieldOfView = value
	end,
})

main:CreateDropdown({
	name = "Modules",
	multiSelect = true,
	options = { "Aimbot", "ESP", "Fly", "Noclip" },
	value = { "ESP" },
	callback = function(selected)
		print(selected)
	end,
})

main:CreateInput({
	name = "Max players",
	numeric = true,
	value = "16",
	placeholder = "Enter a number",
	callback = function(text)
		print("Committed:", text)
	end,
})

main:CreateKeybind({
	name = "Sprint",
	value = Enum.KeyCode.LeftShift,
	callback = function(key)
		print("Pressed", key)
	end,
})

main:CreateColorPicker({
	name = "Highlight",
	color = Color3.fromRGB(96, 205, 255),
	callback = function(color, alpha)
		print(color, alpha)
	end,
})

servers:CreateButton({
	name = "Alert",
	icon = getcustomasset("my-icons/alert.png"),
	callback = function()
		window:Notify({ title = "Alert", content = "Button with a custom icon.", duration = 4 })
	end,
})

sprint:Set(false)
