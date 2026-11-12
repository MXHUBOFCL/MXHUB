if getgenv().MXHUB_Running then
	if getgenv().MXHUB_ReopenPrompt then
		return
	end

	getgenv().MXHUB_ReopenPrompt = true

	local bind = Instance.new("BindableFunction")
	local result = nil

	bind.OnInvoke = function(answer)
		result = answer == "Re-Open"
	end

	pcall(function()
		sv.sg:SetCore("SendNotification", {
			Title = "MX HUB Already Opened",
			Text = "Destroy and Re-Open MX HUB?",
			Icon = assets.Logo,
			Duration = 10,
			Button1 = "Re-Open",
			Button2 = "Cancel",
			Callback = bind,
		})
	end)

	task.delay(10, function()
		if result == nil then
			result = false
		end
	end)

	repeat
		task.wait()
	until result ~= nil

	bind:Destroy()
	getgenv().MXHUB_ReopenPrompt = nil

	if not result then
		return
	end

	if getgenv().MXHUB_Instance then
		pcall(function()
			getgenv().MXHUB_Instance:DestroyGui()
		end)
	else
		for _, name in ipairs({
			"MXHUBUI",
			"ToggleUIButton",
			"PopupGui",
		}) do
			local old = sv.coregui:FindFirstChild(name)
			if old then
				old:Destroy()
			end
		end

		getgenv().MXHUB_Running = nil
		getgenv().MXHUB_ReopenPrompt = nil
		getgenv().MXHUB_Instance = nil
	end
end

getgenv().MXHUB_Running = true

