connectbutton.Activated:Connect(closedropdownpopup)

local searchopened = {}

local function runsearch()
	local query = string.lower(searchbox.Text or "")
	local current = layerspagelayout.CurrentPage
	local seen = {}

	if query == "" then
		for section, closefn in pairs(searchopened) do
			pcall(closefn)
		end
		searchopened = {}
	end

	for _, data in ipairs(searchItems) do
		if query == "" or data.Page == current then
			local match = query == ""
				or string.find(string.lower(data.Name), query, 1, true) ~= nil
				or string.find(string.lower(data.Path), query, 1, true) ~= nil
			if data.Object then
				data.Object.Visible = match
			end
			if data.Section then
				local state = seen[data.Section]
				if not state then
					state = { any = false, open = data.OpenSection, close = data.CloseSection, isopen = data.IsOpen }
					seen[data.Section] = state
				end
				if match then
					state.any = true
				end
			end
		end
	end

	for section, state in pairs(seen) do
		section.Visible = query == "" or state.any
		if query ~= "" and state.any and state.open then
			local wasopen = state.isopen and state.isopen()
			if not wasopen then
				searchopened[section] = state.close
				pcall(state.open)
			end
		end
	end
end

searchbox:GetPropertyChangedSignal("Text"):Connect(function()
	debounceResize("search", runsearch, 0.05)
end)

