function guifunc:DestroyGui()
	disconnectAll()
	for key, timer in pairs(resizeDebounceTable) do
		if timer then
			task.cancel(timer)
		end
	end
	resizeDebounceTable = {}

	if sv.coregui:FindFirstChild("MXHUBUI") then
		mxhubui:Destroy()
	end

	if sv.coregui:FindFirstChild("ToggleUIButton") then
		sv.coregui.ToggleUIButton:Destroy()
	end

	if guifunc.Watermark then
		guifunc.Watermark:Destroy()
	end

	for _, child in ipairs(sv.coregui:GetChildren()) do
		if child.Name == "PopupGui" or child.Name == "NotifyGui" then
			pcall(function()
				child:Destroy()
			end)
		end
	end

	pcall(function()
		for _, callback in ipairs(MXHUB.UnloadCallbacks or {}) do
			pcall(callback)
		end
	end)
	pcall(MXHUB.FpsBoost, false)
	pcall(MXHUB.AntiAfk, false)
	MXHUB.Unloaded = true

	getgenv().MXHUB_Instance = nil
	getgenv().MXHUB_Running = nil
	getgenv().MXHUB_ReopenPrompt = nil
end

