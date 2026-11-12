function items:AddConfigPanel()
	items:PromoteToFull()
	local selected = config.current or ""
	local ready = false
	task.defer(function()
		ready = true
	end)

	local status = items:AddParagraph({ Title = "Config Manager", Content = "" })
	local namebox, picker, loadonstart

	local function describe()
		local loaded = config:getautoload()
		status:SetContent(
			"Game: " .. tostring(config.game or "?")
				.. "  |  Active: " .. (config.current or "None")
				.. "  |  Load on start: " .. (loaded or "Off")
		)
		if loadonstart then
			loadonstart:Set(loaded ~= nil)
		end
	end

	local function refreshlist()
		if picker then
			picker:Refresh(config:getlist(), false)
		end
	end

	local function choose(name)
		selected = name or ""
		if selected ~= "" and namebox then
			namebox:Set(selected)
		end
	end

	items:AddSubSection("Profile")

	picker = items:AddDropdown({
		Title = "Config",
		Multi = false,
		NoSave = true,
		Options = config:getlist(),
		Callback = function(value)
			if ready then
				choose(value)
			end
		end,
	})

	namebox = items:AddInput({
		Title = "Name",
		Placeholder = "New or existing config",
		NoSave = true,
		Default = selected,
	})

	items:AddButton({
		Title = "Save",
		SubTitle = "Load",
		Callback = function()
			local name = namebox.Value or ""
			if name ~= "" and config:save(name) then
				selected = name
				refreshlist()
				describe()
			end
		end,
		SubCallback = function()
			if selected ~= "" and config:load(selected) then
				describe()
			end
		end,
	})

	items:AddButton({
		Title = "Overwrite",
		SubTitle = "Delete",
		Callback = function()
			if selected ~= "" and config:save(selected) then
				refreshlist()
				describe()
			end
		end,
		SubCallback = function()
			if selected ~= "" and config:delete(selected) then
				selected = ""
				refreshlist()
				describe()
			end
		end,
	})

	items:AddSubSection("Automation")

	items:AddToggle({
		Title = "Auto Save",
		Content = "Saves the active config shortly after any change",
		NoSave = true,
		Default = MXHUB.GetAutoSave(),
		Callback = function(state)
			if not ready then
				return
			end
			MXHUB.SetAutoSave(state)
			if state then
				config:savecurrent()
				refreshlist()
				describe()
			end
		end,
	})

	loadonstart = items:AddToggle({
		Title = "Load on Start",
		Content = "Loads the selected config automatically next time",
		NoSave = true,
		Default = config:getautoload() ~= nil,
		Callback = function(state)
			if not ready then
				return
			end
			local active = config:getautoload()
			if state and active ~= nil and (selected == "" or active == selected) then
				return
			end
			if not state and active == nil then
				return
			end
			if state then
				local name = selected ~= "" and selected or config.current or "default"
				config:save(name)
				config:setautoload(name)
				selected = name
				refreshlist()
			else
				config:clearautoload()
			end
			describe()
		end,
	})

	items:AddSubSection("Share")

	local jsonbox = items:AddInput({
		Title = "Config JSON",
		Placeholder = "Paste a copied config here",
		NoSave = true,
	})

	items:AddButton({
		Title = "Copy",
		SubTitle = "Import",
		Callback = function()
			config.data._version = config.version
			clipboardwrite(sv.http:JSONEncode(packconfig(config.data)))
		end,
		SubCallback = function()
			local json = jsonbox.Value or ""
			if json == "" then
				return
			end
			config:reset()
			local ok, err = pcall(function()
				config:loadexternal(json)
			end)
			if ok then
				describe()
			else
				warn(err)
			end
		end,
	})

	items:AddSubSection("Reset")

	items:AddButton({
		Title = "Reset All To Default",
		Callback = function()
			config:reset()
			describe()
		end,
	})

	describe()
	return {
		UpdateStatus = describe,
		RefreshList = refreshlist,
	}
end
