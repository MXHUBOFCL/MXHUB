local config = { gamefolder = nil, autoloadfile = nil, data = {}, elements = {}, version = nil, current = nil, loaded = false }

local metakeys = {
	["Input_Config Name"] = true,
	["Input_External Config"] = true,
}

local function packconfig(data)
	local out = {}
	for key, value in pairs(data or {}) do
		local keep = not metakeys[key]
		if value == false or value == nil then
			keep = false
		elseif type(value) == "string" and value:gsub("%s+", "") == "" then
			keep = false
		elseif type(value) == "table" and next(value) == nil then
			keep = false
		end
		if keep then
			out[key] = value
		end
	end
	return out
end

local function missingdefault(key, element)
	if key:match("^Toggle_") then
		return false
	elseif key:match("^Input_") then
		return ""
	elseif key:match("^Dropdown_") then
		if type(element.Value) == "table" then
			return {}
		end
		return nil
	end
	return nil
end
