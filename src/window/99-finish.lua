	buildingsystem = false

	tabs.Notify = function(self, ...)
		return MXHUB:Notify(...)
	end
	tabs.Destroy = function()
		guifunc:DestroyGui()
	end

	return tabs
end
