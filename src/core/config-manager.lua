local hasfs = type(isfolder) == "function" and type(makefolder) == "function"
if hasfs and not isfolder("MX HUB") then
	pcall(makefolder, "MX HUB")
end

function config.cleanname(name)
	name = tostring(name or "")
	name = name:gsub("[%c\\/:*?\"<>|]", "")
	name = name:gsub("%.%.+", "")
	name = name:gsub("^[%s%.]+", ""):gsub("[%s%.]+$", "")
	if #name > 48 then
		name = name:sub(1, 48):gsub("%s+$", "")
	end
	return name
end

function config:ensurefolders()
	if type(makefolder) ~= "function" or type(isfolder) ~= "function" then
		return false
	end
	pcall(function()
		if not isfolder("MX HUB") then
			makefolder("MX HUB")
		end
		if self.gamefolder and not isfolder(self.gamefolder) then
			makefolder(self.gamefolder)
		end
	end)
	local ok, exists = pcall(isfolder, self.gamefolder or "")
	return ok and exists == true
end

function config:getlist()
	local configs = {}

	if isfolder and listfiles and self.gamefolder and isfolder(self.gamefolder) then
		for _, filepath in pairs(listfiles(self.gamefolder)) do
			local filename = filepath:match("([^/\\]+)%.json$")
			if filename then
				table.insert(configs, filename)
			end
		end
	end

	table.sort(configs, function(a, b)
		return a:lower() < b:lower()
	end)
	return configs
end

function config:getautoload()
	if isfile and self.autoloadfile and isfile(self.autoloadfile) then
		local success, content = pcall(readfile, self.autoloadfile)

		if success and content and content ~= "" then
			return content:match("^%s*(.-)%s*$")
		end
	end

	return nil
end

function config:setautoload(name)
	name = config.cleanname(name)
	if name == "" then
		return false
	end
	self:ensurefolders()

	if writefile and self.autoloadfile then
		writefile(self.autoloadfile, tostring(name))
		print("[MX HUB] Autoload config set to: " .. tostring(name))
		return true
	end

	return false
end

function config:clearautoload()
	if delfile and self.autoloadfile and isfile(self.autoloadfile) then
		delfile(self.autoloadfile)
		print("[MX HUB] Autoload config cleared")
		return true
	end

	return false
end

function config:save(name)
	name = config.cleanname(name)
	if name == "" then
		warn("[MX HUB] Config name cannot be empty")
		return false
	end

	if not writefile or not self.gamefolder then
		return false
	end

	if not self:ensurefolders() then
		warn("[MX HUB] Could not create the config folder")
		return false
	end

	self.data._version = self.version

	local ok, err = pcall(function()
		local filepath = self.gamefolder .. "/" .. name .. ".json"
		writefile(filepath, sv.http:JSONEncode(packconfig(self.data)))
	end)
	if not ok then
		warn("[MX HUB] Config save failed: " .. tostring(err))
		return false
	end

	self.current = name
	return true
end

function config:savecurrent()
	local name = self.current
	if not name or name == "" then
		name = "default"
	end
	if self:save(name) then
		return name
	end
	return nil
end

function config:load(name)
	name = config.cleanname(name)
	if name == "" then
		warn("[MX HUB] Config name cannot be empty")
		return false
	end

	if not self.version then
		return false
	end

	local filepath = self.gamefolder .. "/" .. name .. ".json"

	if not isfile or not isfile(filepath) then
		warn("[MX HUB] Config file not found: " .. name)
		return false
	end

	local success, result = pcall(function()
		return sv.http:JSONDecode(readfile(filepath))
	end)

	if not success or type(result) ~= "table" then
		warn("[MX HUB] Failed to decode config")
		return false
	end

	if result._version ~= self.version then
		warn("[MX HUB] Config version mismatch")
		return false
	end

	self.data = result
	self.current = name
	self.loaded = true
	self:loadelements()

	print("[MX HUB] Config loaded: " .. name)
	return true
end

function config:delete(name)
	name = config.cleanname(name)
	if name == "" then
		warn("[MX HUB] Config name cannot be empty")
		return false
	end

	local filepath = self.gamefolder .. "/" .. name .. ".json"

	if not delfile or not isfile or not isfile(filepath) then
		warn("[MX HUB] Config file not found: " .. name)
		return false
	end

	delfile(filepath)
	print("[MX HUB] Config deleted: " .. name)

	if self:getautoload() == name then
		self:clearautoload()
	end

	if self.current == name then
		self.current = nil
	end

	return true
end

function config:loadelements()
	for key, element in pairs(self.elements) do
		if element.Set and not metakeys[key] then
			local value = self.data[key]
			local apply = value ~= nil
			if value == nil then
				value = missingdefault(key, element)
				apply = value ~= nil or key:match("^Dropdown_") ~= nil
			end
			if apply then
				local ok, err = pcall(function()
					if element.LoadValue then
						element:LoadValue(value)
					else
						element:Set(value, true)
					end
				end)
				if not ok then
					warn("[MX HUB] Config load failed for " .. tostring(key) .. ":", err)
				end
			end
		end
	end
end

function config:reset()
	self.data = {
		_version = self.version,
	}
	self.loaded = false

	for key, element in pairs(self.elements) do
		if element.Set then
			pcall(function()
				if element.ResetValue then

					element:ResetValue()
				elseif key:match("^Toggle_") then
					element:Set(false)
				elseif key:match("^Input_") then
					element:Set("")
				elseif key:match("^Dropdown_") then
					if type(element.Value) == "table" then
						element:Set({})
					else
						element:Set(nil)
					end
				end
			end)
		end
	end

	print("[MX HUB] Elements reset to defaults")
end

function config:loadexternal(json)
	if not json or json == "" then
		warn("[MX HUB] External config JSON is empty")
		return false
	end

	local success, data = pcall(function()
		return sv.http:JSONDecode(json)
	end)

	if not success or type(data) ~= "table" then
		warn("[MX HUB] External config JSON invalid")
		return false
	end

	if data._version and self.version and data._version ~= self.version then
		warn("[MX HUB] External config version mismatch")
		return false
	end

	self.data = data
	self.loaded = true
	self:loadelements()

	print("[MX HUB] External config loaded from JSON input")
	return true
end

