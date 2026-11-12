function items:AddConfigPanel()
	items:PromoteToFull()
	local selectedconfigname = config.current or ""
	local configdropdown

	local function setdropdownlist(dropdown, list)
		if dropdown and dropdown.Refresh then
			dropdown:Refresh(list)
		elseif dropdown and dropdown.SetValues then
			dropdown:SetValues(list, dropdown.Value)
		end
	end

	local function refreshconfiglist()
		setdropdownlist(configdropdown, config:getlist())
	end

	local saveparagraph = items:AddParagraph({
		Title = "Config Manager",
		Content = "Game: " .. tostring(config.game or "?") .. "  |  Profile: " .. (config.current or "None"),
	})

	local function updatestatus()
		saveparagraph:SetContent("Game: " .. tostring(config.game or "?") .. "  |  Profile: " .. (config.current or "None"))
	end

	local confignameinput = items:AddInput({
		Title = "Config Name",
		Placeholder = "Write config name here",
	})

	configdropdown = items:AddDropdown({
		Title = "Select Config",
		Multi = false,
		Options = config:getlist(),
		Callback = function(value)
			selectedconfigname = value or ""
			if selectedconfigname ~= "" then
				confignameinput:Set(selectedconfigname)
			end
		end,
	})

	items:AddButton({
		Title = "Save Config",
		SubTitle = "Load Config",
		Callback = function()
			local input = config.elements["Input_Config Name"]
			local name = input and input.Value or ""

			if name == "" then
				return
			end

			if config:save(name) then
				selectedconfigname = name
				refreshconfiglist()
				updatestatus()
			end
		end,
		SubCallback = function()
			if selectedconfigname == "" then
				return
			end

			if config:load(selectedconfigname) then
				updatestatus()
			end
		end,
	})

	items:AddButton({
		Title = "Delete Config",
		SubTitle = "Override Config",
		Callback = function()
			if selectedconfigname == "" then
				return
			end

			if config:delete(selectedconfigname) then
				selectedconfigname = ""

				if configdropdown then
					configdropdown:Refresh(config:getlist(), false)
				end
				updatestatus()
			end
		end,
		SubCallback = function()
			if selectedconfigname == "" then
				return
			end

			if config:save(selectedconfigname) then
				refreshconfiglist()
				updatestatus()
			end
		end,
	})

	items:AddSubSection("Auto-Load Configuration")

	local autostatus = items:AddParagraph({
		Title = "Auto Load Status",
		Content = "Auto Load: " .. (config:getautoload() or "None"),
	})

	items:AddButton({
		Title = "Set Auto Load",
		SubTitle = "Clear Auto Load",
		Callback = function()
			if selectedconfigname == "" then
				return
			end

			if config:setautoload(selectedconfigname) then
				autostatus:SetContent("Auto Load: " .. selectedconfigname)
			end
		end,
		SubCallback = function()
			if config:clearautoload() then
				autostatus:SetContent("Auto Load: None")
			end
		end,
	})

	items:AddSubSection("Folder Management")

	items:AddButton({
		Title = "Export Config",
		Callback = function()
			config.data._version = config.version
			local json = sv.http:JSONEncode(packconfig(config.data))

			clipboardwrite(json)
		end,
	})

	items:AddInput({
		Title = "External Config",
		Placeholder = "Paste raw JSON config here",
	})

	items:AddButton({
		Title = "Import Config",
		Callback = function()
			local input = config.elements["Input_External Config"]
			local json = input and input.Value

			if not json or json == "" then
				return
			end

			config:reset()

			local ok, err = pcall(function()
				config:loadexternal(json)
			end)

			if ok then
				updatestatus()
			else
				warn(err)
			end
		end,
	})

	items:AddSubSection("Reset Configuration")

	items:AddButton({
		Title = "Reset All To Default",
		Callback = function()
			config:reset()
			updatestatus()
		end,
	})

	return {
		UpdateStatus = updatestatus,
		RefreshList = refreshconfiglist,
	}
end

