function MXHUB:Window(guiconfig)
	guiconfig = guiconfig or {}
	MXHUB.Unloaded = false
	guiconfig.Title = "MX HUB"
	guiconfig.Footer = guiconfig.Footer or "MX HUB"
	local gamename = tostring(guiconfig.GameName or guiconfig.Footer or "")
	if gamename == "" or gamename == "MX HUB" then
		gamename = "Game " .. tostring(game.PlaceId)
	end
	guiconfig.Color = guiconfig.Color or theme.Accent
	guiconfig["Tab Width"] = guiconfig["Tab Width"] or (guiconfig.IconRail == true and 40 or 120)
	guiconfig.Version = guiconfig.Version or 1
	local function islogoid(value)
		local text = tostring(value or ""):gsub("%s+", ""):gsub("^rbxassetid://", "")
		return text == assets.LogoId
	end
	local function realimage(value)
		if value == nil or value == false or islogoid(value) then
			return nil
		end
		return value
	end
	guiconfig.WatermarkLogo = realimage(guiconfig.WatermarkLogo)
	guiconfig.HomeLogo = realimage(guiconfig.HomeLogo)
	local userPassedImage = realimage(guiconfig.Image)
	local userPassedToggle = realimage(guiconfig.ToggleImage or guiconfig.ToggleIcon or guiconfig.ButtonImage)
	guiconfig.Image = userPassedImage or assets.LogoId
	guiconfig.ImageSize = tonumber(guiconfig.ImageSize) or 48
	guiconfig.Community = guiconfig.Community ~= false
	guiconfig.Home = guiconfig.Home ~= false
	guiconfig.Settings = guiconfig.Settings ~= false
	guiconfig.LazyConfigTab = guiconfig.LazyConfigTab ~= false
	guiconfig.LoadUserThumbnail = guiconfig.LoadUserThumbnail ~= false
	guiconfig.ThumbnailDelay = tonumber(guiconfig.ThumbnailDelay) or 8

	local foldername = config.cleanname(guiconfig.ConfigFolder or gamename)
	if foldername == "" then
		foldername = "Game " .. tostring(game.PlaceId)
	end
	config.game = gamename
	config.gamefolder = "MX HUB/" .. foldername
	config.autoloadfile = config.gamefolder .. "/autoload.txt"
	config:ensurefolders()

	config.version = guiconfig.Version

	local autoloadname = config:getautoload()
	if autoloadname then
		config:load(autoloadname)
	else
		config.data = { _version = config.version }
	end

