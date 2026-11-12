local autosave = { enabled = false, delay = 1.5, ticket = 0 }

function autosave.touch()
	if not autosave.enabled then
		return
	end
	autosave.ticket += 1
	local ticket = autosave.ticket
	task.delay(autosave.delay, function()
		if ticket == autosave.ticket and autosave.enabled and not MXHUB.Unloaded then
			config:savecurrent()
		end
	end)
end
