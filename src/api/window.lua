local apiwindow = {}
apiwindow.__index = apiwindow

function apiwindow:CreateSection(opts)
	opts = type(opts) == "table" and opts or { name = opts }
	self._category = tostring(opts.name or opts.title or "")
	return self
end

function apiwindow:CreateTab(opts)
	opts = type(opts) == "table" and opts or { name = opts }
	local name = tostring(opts.name or opts.title or "Tab")
	local tab = self._engine:AddTab({
		Name = name,
		Icon = opts.icon,
		Category = self._category,
	})
	return setmetatable({ _window = self, _tab = tab, _name = name }, apitab)
end

function apiwindow:Popup(opts)
	opts = opts or {}
	local boxes = {}
	for _, box in ipairs(opts.boxes or {}) do
		boxes[#boxes + 1] = { Title = box.title, Description = box.description, Icon = box.icon }
	end
	local choices = {}
	for _, choice in ipairs(opts.options or {}) do
		choices[#choices + 1] = { Text = choice.text, Style = choice.style, Callback = choice.callback }
	end
	return MXHUB:Popup({
		Title = opts.title,
		Subtitle = opts.subtitle,
		Boxes = boxes,
		Options = choices,
		Dismissable = opts.dismissable,
		OnClose = opts.onClose,
	})
end

function apiwindow:ChangeTheme(name, accent)
	local patch = { Preset = name }
	if accent ~= nil then
		patch.Accent = typeof(accent) == "Color3" and accent or MXHUB.Theme.ParseHex(accent) or false
	end
	return MXHUB.Theme.Set(patch)
end

function apiwindow:SetLanguage(name)
	return MXHUB.SetLanguage and MXHUB.SetLanguage(languagenames[name] or name)
end

function apiwindow:GetFlag(flag)
	local element = self.flags[flag]
	return element and element.Value
end

function apiwindow:ShowHotkeys(state)
	MXHUB.ShowHotkeys(state ~= false)
	return self
end

function apiwindow:OnUnload(callback)
	MXHUB:OnUnload(callback)
	return self
end

function apiwindow:Destroy()
	self._engine.Destroy()
end

function MXHUB:CreateWindow(opts)
	opts = type(opts) == "table" and opts or { name = opts }

	for code, entries in pairs(opts.translations or {}) do
		self:AddTranslations(languagenames[code] or code, entries)
	end

	local themefile = "MX HUB/theme.json"
	local hassaved = type(isfile) == "function" and isfile(themefile)
	if opts.theme and not hassaved then
		self.Theme.Set({ Preset = opts.theme }, true)
	end

	local engine = self:Window({
		Footer = opts.name,
		GameName = opts.configFolder or opts.name,
		ConfigFolder = opts.configFolder,
		Version = opts.configVersion,
		HomeVersion = opts.version,
		HomeLogo = opts.logo,
		HomeTitle = opts.homeTitle,
		Image = opts.image,
		ToggleImage = opts.icon,
		Background = opts.background,
		Color = opts.accent,
		MenuKey = opts.menuKey,
		IconRail = opts.iconRail,
		ToggleKeybinds = opts.toggleKeybinds,
		Community = opts.community,
		Home = opts.home,
		Settings = opts.settings,
		Discord = opts.discord,
		DiscordStats = opts.discordStats,
		Donate = opts.donate,
		Watermark = opts.watermark,
		Width = opts.width,
		Height = opts.height,
	})

	local window = setmetatable({ _engine = engine, flags = {} }, apiwindow)
	if opts.language then
		window:SetLanguage(opts.language)
	end
	return window
end
