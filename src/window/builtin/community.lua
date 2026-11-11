if guiconfig.Community ~= false or guiconfig.Home ~= false then
	pcall(function()
		tabs:AddTabHeader("Community", -3)
	end)
end

local communitytab
local discordinvite = tostring(guiconfig.Discord or "https://discord.gg/G7FCTC2mEk")
local donateurl = tostring(guiconfig.Donate or "https://sociabuzz.com/meowxhub/tribe")
if guiconfig.Community ~= false then
	pcall(function()
		communitytab = tabs:AddTab({ Name = "Community", Icon = "globe", LayoutOrder = -2, StartActive = false })
		buildcommunitypage(communitytab:GetPage(), {
			Discord = discordinvite,
			Donate = donateurl,
		})
	end)
end

if guiconfig.Home ~= false then
	pcall(function()
		local HomeTab = tabs:AddTab({ Name = "Home", Icon = "home", LayoutOrder = -1 })
		buildhomepage(HomeTab:GetPage(), {
			Footer = guiconfig.Footer,
			Version = guiconfig.HomeVersion or guiconfig.ScriptVersion,
			Logo = guiconfig.HomeLogo or userPassedToggle or assets.LogoId,
			Discord = discordinvite,
			OpenCommunity = communitytab and function()
				communitytab:Select()
			end or nil,
			ToggleKey = togglekey,
			HubName = guiconfig.HomeTitle or "MX HUB",
			OpenFeatures = openfeatures,
			GetFeatureInfo = function()
				local groups, total = collectfeatures()
				local names = {}
				for _, g in ipairs(groups) do
					names[#names + 1] = g.Name
				end
				return total, names
			end,
		})
	end)
end

