local MXLIB = loadstring(game:HttpGet("https://raw.githubusercontent.com/MXHUBOFCL/MXHUB/refs/heads/main/MXLIB.lua"))()

local window = MXLIB:CreateWindow({ name = "Example" })

window:Popup({
	title = "What's new",
	subtitle = "Version 2.1",
	boxes = {
		{ title = "Modal popups", description = "A new centred dialog.", icon = 93364949241311 },
		{ title = "Faster reveals", description = "Pages open instantly." },
	},
	options = {
		{ text = "Later" },
		{ text = "Got it", style = "primary" },
	},
})
