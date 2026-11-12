local MXLIB = loadstring(game:HttpGet("https://raw.githubusercontent.com/MXHUBOFCL/MXHUB/refs/heads/main/MXLIB.lua"))()

local window = MXLIB:CreateWindow({
	name = "Example",
	theme = "cobalt",
	home = false,
	community = false,
	translations = {
		fr = { ["Auto Sprint"] = "Sprint auto", ["Settings"] = "Réglages" },
		es = { ["Auto Sprint"] = "Sprint automático" },
	},
})

local tab = window:CreateTab({ name = "Appearance", icon = "palette" })

tab:CreateDropdown({
	name = "Theme",
	options = MXLIB.Theme.Names(),
	value = "Cobalt",
	callback = function(name)
		window:ChangeTheme(name)
	end,
})

tab:CreateButton({
	name = "Ember",
	callback = function()
		window:ChangeTheme("ember")
	end,
})

tab:CreateButton({
	name = "Français",
	callback = function()
		window:SetLanguage("fr")
	end,
})
