local customicons = {}
local customaliases = {}


local function normalizeiconname(name)
	return (tostring(name or "")
		:gsub("^%s+", "")
		:gsub("%s+$", "")
		:lower()
		:gsub("[_%s]+", "-"))
end

local iconfallback = {}
for key, value in pairs(iconfallbackdata) do
	iconfallback[normalizeiconname(key)] = value
end

local function iconstring(value)
	if type(value) == "number" then
		return string.format("%.0f", value)
	end
	return (tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function iconcandidates(raw)
	local key = normalizeiconname(raw)
	local list, seen = {}, {}
	local function push(value)
		value = normalizeiconname(value)
		if value ~= "" and not seen[value] then
			seen[value] = true
			list[#list + 1] = value
			return true
		end
		return false
	end
	local function expand(name, depth)
		local mapped = customaliases[name]
		if mapped == nil then
			mapped = iconaliases[name]
		end
		if type(mapped) == "string" then
			mapped = { mapped }
		end
		if type(mapped) == "table" then
			for _, target in ipairs(mapped) do
				if push(target) and depth < 4 then
					expand(normalizeiconname(target), depth + 1)
				end
			end
		end
	end
	expand(key, 0)
	push(key)
	return list
end

local function setimage(image, asset, offset, rect)
	return (pcall(function()
		image.Image = asset or ""
		image.ImageRectOffset = offset or Vector2.new(0, 0)
		image.ImageRectSize = rect or Vector2.new(0, 0)
	end))
end


local function standaloneasset(candidates)
	for _, candidate in ipairs(candidates) do
		local custom = customicons[candidate]
		if custom then
			return custom
		end
	end
	for _, candidate in ipairs(candidates) do
		local fallback = iconfallback[candidate]
		if fallback then
			return fallback
		end
	end
	local registry = iconnames
	for _, candidate in ipairs(candidates) do
		local direct = registry[candidate]
		if type(direct) == "string" and direct ~= "" then
			return direct
		end
	end
	return nil
end

local function directiconstring(raw)
	if raw:match("^%d+$") then
		return "rbxassetid://" .. raw
	end
	local lower = raw:lower()
	if lower:match("^rbxassetid://") or lower:match("^rbxasset://") or lower:match("^https?://") or lower:match("^rbxthumb://") then
		return raw
	end
	return nil
end

local function resolveiconasset(icon)
	local raw = iconstring(icon)
	if raw == "" then
		return nil
	end
	return directiconstring(raw) or standaloneasset(iconcandidates(raw))
end

local function hasimage(value)
	return value ~= nil and value ~= ""
end

local contentprovider = game:GetService("ContentProvider")

local function thumbnail(kind, id, width, height)
	width = tonumber(width) or 150
	return string.format("rbxthumb://type=%s&id=%.0f&w=%d&h=%d", tostring(kind or "AvatarHeadShot"), tonumber(id) or 0, width, tonumber(height) or width)
end

local applyicon

local function guardimage(image, source)
	image:SetAttribute("mxsource", source)
	task.spawn(function()
		pcall(function()
			contentprovider:PreloadAsync({ image }, function(_, status)
				if status ~= Enum.AssetFetchStatus.Success and image.Parent and image:GetAttribute("mxsource") == source then
					applyicon(image, "image-off", 48)
				end
			end)
		end)
	end)
end

function applyicon(image, icon, size)
	if not image then
		return false
	end
	image:SetAttribute("mxsource", nil)
	local raw = iconstring(icon)
	if raw == "" then
		setimage(image, "")
		return false
	end
	local direct = directiconstring(raw)
	if direct then
		local shown = setimage(image, direct)
		if not direct:lower():match("^rbxasset://") then
			guardimage(image, direct)
		end
		return shown
	end
	local candidates = iconcandidates(raw)
	for _, candidate in ipairs(candidates) do
		local custom = customicons[candidate]
		if custom then
			return setimage(image, custom)
		end
	end
	if (tonumber(size) or 48) <= 64 then
		for _, candidate in ipairs(candidates) do
			local baked = bakedsprites[candidate]
			if baked then
				return setimage(
					image,
					"rbxassetid://" .. tostring(baked[1]),
					Vector2.new(baked[4], baked[5]),
					Vector2.new(baked[2], baked[3])
				)
			end
		end
	end
	for _, candidate in ipairs(candidates) do
		local sprite = lucidesprites[candidate]
		if sprite then
			return setimage(image, "rbxassetid://" .. tostring(sprite[1]), Vector2.new(sprite[2], sprite[3]), Vector2.new(48, 48))
		end
	end
	local asset = standaloneasset(candidates)
	setimage(image, asset or "")
	return asset ~= nil
end
