if guiconfig.Settings then
	local ConfigTab = tabs:AddTab({
		Name = "Settings",
		Icon = "settings",
		LayoutOrder = 1000000,
		StartActive = false,
	})
	local SettingsGeneral = ConfigTab:AddSubTab("General")
	local SettingsConfigs = ConfigTab:AddSubTab("Configs")

	do
		local InterfaceSection = ConfigTab:AddSection("Interface", true, "Left", "settings")
		InterfaceSection:AddToggle({
			Title = "Lock UI",
			Flag = "LockUI",
			Default = false,
			Callback = function(state)
				uilocked = state == true
			end,
		})
		InterfaceSection:AddToggle({
			Title = "Show Watermark",
			Flag = "ShowWatermark",
			Default = true,
			Callback = function(state)
				if guifunc.Watermark then
					guifunc.Watermark:SetVisible(state)
				end
			end,
		})

		local ToolsSection = ConfigTab:AddSection("Tools", true, "Left", "wrench")
		ToolsSection:AddToggle({
			Title = "Anti AFK",
			Flag = "AntiAfk",
			Default = false,
			Content = "Stops the idle kick",
			Callback = function(state)
				MXHUB.AntiAfk(state == true)
			end,
		})
		ToolsSection:AddToggle({
			Title = "FPS Boost",
			Flag = "FpsBoost",
			Default = false,
			Content = "Lower graphics for more FPS. Restored when turned off",
			Callback = function(state)
				MXHUB.FpsBoost(state == true)
			end,
		})

		local ThemeSection = ConfigTab:AddSection("Theme", true, "Right", "palette")
		local live = false
		task.defer(function()
			live = true
		end)
		local function apply(patch)
			if not live then
				return
			end
			theme.Api.Set(patch)
		end

		ThemeSection:AddDropdown({
			Title = "Theme",
			Flag = "ThemePick",
			Multi = false,
			NoSave = true,
			Options = theme.Api.Names(),
			Default = theme.State.Preset or "MX HUB",
			Callback = function(value)
				if value then
					apply({ Preset = value, Accent = false })
				end
			end,
		})

		local accentnames, accentcolors = { "Default" }, {}
		for _, accent in ipairs(theme.Api.Accents()) do
			accentnames[#accentnames + 1] = accent[1]
			accentcolors[accent[1]] = accent[2]
		end
		ThemeSection:AddDropdown({
			Title = "Accent",
			Flag = "ThemeAccent",
			Multi = false,
			NoSave = true,
			Options = accentnames,
			Default = "Default",
			Callback = function(value)
				if value then
					apply({ Accent = accentcolors[value] or false })
				end
			end,
		})

		ThemeSection:AddDropdown({
			Title = "Mode",
			Flag = "ThemeMode",
			Multi = false,
			NoSave = true,
			Options = { "Dark", "Light" },
			Default = theme.State.Mode or "Dark",
			Callback = function(value)
				if value then
					apply({ Mode = value })
				end
			end,
		})

		ThemeSection:AddInput({
			Title = "Custom Accent (hex)",
			Flag = "ThemeCustomAccent",
			Placeholder = "#1ED760",
			NoSave = true,
			Callback = function(value)
				local text = tostring(value or "")
				if text == "" then
					return
				end
				local color = theme.Api.ParseHex(text)
				if color then
					apply({ Accent = color })
				end
			end,
		})

		ThemeSection:AddButton({
			Title = "Reset Theme",
			Callback = function()
				theme.Api.Set({ Preset = "MX HUB", Accent = false, Mode = "Dark" })
			end,
		})
	end

	local function buildConfigTab()
		local ConfigSection = SettingsConfigs:AddSection("Config Manager", true, "Full", "save")
		ConfigSection:AddConfigPanel()
	end

	if guiconfig.LazyConfigTab then
		SettingsConfigs:OnOpen(buildConfigTab)
	else
		buildConfigTab()
	end
end

