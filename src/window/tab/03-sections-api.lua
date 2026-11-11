function sections:Select()
	selecttab()
end

function sections:GetPage()
	return scrollayers
end

function sections:_RunOpen()
	runOnOpen()
end

-- Sub-tabs (General / Advanced / Presets ...). The first call reuses this tab's own page,
-- every further call creates another page that is switched from the top bar.
function sections:AddSubTab(subname)
	if tabconfig.Hidden then
		return sections
	end
	subname = tostring(subname or ("Page " .. tostring(#subs + 1)))
	if #subs == 0 then
		subs[1] = { Name = subname, Page = scrollayers, Sections = sections }
		refreshsubbar()
		return sections
	end
	local index = #subs + 1
	local hidden = tabs:AddTab({
		Name = tabconfig.Name,
		Hidden = true,
		StartActive = false,
		LayoutOrder = layoutOrder,
		Grid = tabconfig.Grid,
		Columns = tabconfig.Columns,
		GridMinWidth = tabconfig.GridMinWidth,
		_SelectHook = function()
			selecttab()
			activatesub(index)
		end,
	})
	subs[index] = { Name = subname, Page = hidden:GetPage(), Sections = hidden }
	refreshsubbar()
	return hidden
end

function sections:AddLeftSection(title, open, icon)
	return sections:AddSection(title, open, "Left", icon)
end

function sections:AddRightSection(title, open, icon)
	return sections:AddSection(title, open, "Right", icon)
end

function sections:AddFullSection(title, open, icon)
	return sections:AddSection(title, open, "Full", icon)
end

function sections:OnOpen(callback)
	onOpenCallback = callback
	if isFirstTab then
		runOnOpen()
	end
	return self
end

