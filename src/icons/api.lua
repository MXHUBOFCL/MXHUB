function MXHUB:RegisterIcon(name, asset)
	if type(name) ~= "string" or normalizeiconname(name) == "" or asset == nil then
		return false
	end
	local value = resolveiconasset(asset)
	if not value then
		return false
	end
	customicons[normalizeiconname(name)] = value
	return true
end

function MXHUB:AddIconAlias(alias, target)
	if type(alias) ~= "string" or normalizeiconname(alias) == "" or target == nil then
		return false
	end
	customaliases[normalizeiconname(alias)] = target
	return true
end

function MXHUB:GetIconAsset(name)
	return resolveiconasset(name)
end

function MXHUB:ApplyIcon(image, name, size)
	return applyicon(image, name, size)
end

function MXHUB:SetUILocked(state)
	uilocked = state == true
end

function MXHUB:GetUILocked()
	return uilocked
end

function MXHUB:GetIconNames()
	local found, names = {}, {}
	local function add(key)
		if type(key) == "string" and key ~= "" and not found[key] then
			found[key] = true
			names[#names + 1] = key
		end
	end
	for key in pairs(iconnames) do add(key) end
	for key in pairs(lucidesprites) do add(key) end
	for key in pairs(iconaliases) do add(key) end
	for key in pairs(customicons) do add(key) end
	table.sort(names)
	return names
end

MXHUB.Image = {
	Normalize = resolveiconasset,
	Thumbnail = thumbnail,
	Apply = applyicon,
}
MXHUB.IconAssets = iconnames
MXHUB.IconAliases = iconaliases
MXHUB.IconRegistryCount = (function() local n = 0; for _ in pairs(MXHUB.IconAssets) do n += 1 end; return n end)()
MXHUB.IconRegistryVersion = "lucide-sheet+1457-registry-2026-11-06"

