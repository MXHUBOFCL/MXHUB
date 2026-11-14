local MXLIB = loadstring(game:HttpGet("https://raw.githubusercontent.com/MXHUBOFCL/MXHUB/refs/heads/main/MXLIB.lua"))()

local window = MXLIB:CreateWindow({
	name = "Modules",
	discord = "https://discord.gg/G7FCTC2mEk",
	discordStats = true,
})

window:CreateSection({ name = "Controls" })
local tab = window:CreateTab({ name = "Elements", icon = "layout-grid" })

tab:CreateSection({ name = "Inputs", side = "left" })

tab:CreateSegmented({
	name = "Difficulty",
	options = { "Easy", "Normal", "Hard" },
	value = "Normal",
	callback = function(choice)
		print("Difficulty:", choice)
	end,
})

tab:CreateStepper({
	name = "Players",
	range = { 1, 32 },
	increment = 1,
	value = 8,
	callback = function(count)
		print("Players:", count)
	end,
})

tab:CreateKeybind({
	name = "Sprint",
	value = Enum.KeyCode.LeftShift,
	mode = "hold",
})

tab:CreateToggle({
	name = "Auto Farm",
	value = false,
	keybind = true,
})

tab:CreateSection({ name = "Status", side = "right" })

local progress = tab:CreateProgress({
	name = "Quest",
	range = { 0, 10 },
	value = 3,
	format = function(value)
		return string.format("%d / 10", value)
	end,
})

tab:CreateButton({
	name = "Advance quest",
	callback = function()
		progress:Set(math.min(progress:Get() + 1, 10))
	end,
})

window:ShowHotkeys(true)

local webhook = MXLIB.Webhook.New("https://discord.com/api/webhooks/123456789012345678/your-webhook-token")
if webhook then
	task.spawn(function()
		local ok, status, problem = webhook:Send({
			username = "MXLIB",
			embeds = { { title = "Loaded", description = "Script started.", color = Color3.fromRGB(96, 205, 255), timestamp = true } },
		})
		print(ok, status, problem)
	end)
end

task.spawn(function()
	local info, problem = MXLIB.Discord.Stats("https://discord.gg/G7FCTC2mEk")
	if info then
		print(info.Name, info.Online, info.Members)
	else
		print("Discord stats unavailable:", problem)
	end
end)
