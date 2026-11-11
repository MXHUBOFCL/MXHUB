		return items
	end

	if tabconfig.Hidden then
		return sections
	end

	if not buildingsystem then
		usertabcount = usertabcount + 1
		table.insert(usertabnames, tabconfig.Name)
	end
	counttab = counttab + 1

	local safename = tabconfig.Name:gsub("%s+", "_")
	if _G[safename] == nil then
		_G[safename] = sections
	end
	return sections
end

