local apitab = {}
apitab.__index = apitab

local function options(value)
	if type(value) == "table" then
		return value
	end
	return { name = value }
end

local function titleof(opts, fallback)
	return tostring(opts.name or opts.title or fallback)
end

local function sideof(value)
	local text = tostring(value or "full"):lower()
	return (text:gsub("^%l", string.upper))
end

local function remember(self, flag, element)
	if flag ~= nil and type(element) == "table" then
		self._window.flags[flag] = element
	end
	return element
end

function apitab:_target()
	if not self._section then
		self._section = self._tab:AddSection({ Title = self._name, Side = "Full" })
	end
	return self._section
end

function apitab:CreateSection(opts)
	opts = options(opts)
	self._section = self._tab:AddSection({
		Title = titleof(opts, "Section"),
		Open = opts.open ~= false,
		Side = sideof(opts.side),
		Icon = opts.icon,
	})
	return self
end

function apitab:CreateSubTab(name)
	self._tab = self._tab:AddSubTab(name)
	self._section = nil
	return self
end

function apitab:CreateButton(opts)
	opts = options(opts)
	return self:_target():AddButton({
		Title = titleof(opts, "Button"),
		Callback = opts.callback,
		Icon = opts.icon,
	})
end

function apitab:CreateToggle(opts)
	opts = options(opts)
	return remember(self, opts.flag, self:_target():AddToggle({
		Title = titleof(opts, "Toggle"),
		Flag = opts.flag,
		Default = opts.value == true,
		NoSave = opts.save == false,
		Callback = opts.callback,
		Keybind = opts.keybind,
		Icon = opts.icon,
		Content = opts.description,
	}))
end

function apitab:CreateSlider(opts)
	opts = options(opts)
	local range = type(opts.range) == "table" and opts.range or { 0, 100 }
	return remember(self, opts.flag, self:_target():AddSlider({
		Title = titleof(opts, "Slider"),
		Flag = opts.flag,
		Min = range[1],
		Max = range[2],
		Increment = opts.increment or 1,
		Default = opts.value or range[1],
		Suffix = opts.suffix,
		Icon = opts.icon,
		Callback = opts.callback,
		Content = opts.description,
	}))
end

function apitab:CreateDropdown(opts)
	opts = options(opts)
	local multi = opts.multiSelect == true
	local value = opts.value
	if multi and type(value) == "string" then
		value = { value }
	elseif not multi and type(value) == "table" then
		value = value[1]
	end
	return remember(self, opts.flag, self:_target():AddDropdown({
		Title = titleof(opts, "Dropdown"),
		Flag = opts.flag,
		Options = opts.options or {},
		Default = value,
		Multi = multi,
		NoSave = opts.save == false,
		Icon = opts.icon,
		Callback = opts.callback,
		Content = opts.description,
	}))
end

function apitab:CreateInput(opts)
	opts = options(opts)
	local numeric = opts.numeric == true
	local callback = opts.callback
	local element
	local lastvalid = tostring(opts.value or "")
	element = self:_target():AddInput({
		Title = titleof(opts, "Input"),
		Flag = opts.flag,
		Default = lastvalid,
		Placeholder = opts.placeholder,
		Icon = opts.icon,
		NoSave = opts.save == false,
		Content = opts.description,
		Callback = function(text)
			if numeric and text ~= "" and tonumber(text) == nil then
				if element then
					element:Set(lastvalid)
				end
				return
			end
			lastvalid = tostring(text)
			if type(callback) == "function" then
				callback(text)
			end
		end,
	})
	return remember(self, opts.flag, element)
end

function apitab:CreateKeybind(opts)
	opts = options(opts)
	local callback = opts.callback
	local element
	element = self:_target():AddKeybind({
		Title = titleof(opts, "Keybind"),
		Flag = opts.flag,
		Default = opts.value,
		Mode = opts.mode,
		Icon = opts.icon,
		Content = opts.description,
		Callback = function()
			if type(callback) == "function" then
				callback(element and element.Value or opts.value)
			end
		end,
		ChangedCallback = opts.changed,
	})
	return remember(self, opts.flag, element)
end

function apitab:CreateColorPicker(opts)
	opts = options(opts)
	local callback = opts.callback
	return remember(self, opts.flag, self:_target():AddColorPicker({
		Title = titleof(opts, "Color"),
		Flag = opts.flag,
		Default = opts.color,
		Icon = opts.icon,
		Content = opts.description,
		Callback = function(color)
			if type(callback) == "function" then
				callback(color, 1)
			end
		end,
	}))
end

function apitab:CreateImage(opts)
	opts = options(opts)
	return self:_target():AddImage({
		Image = opts.image or opts.icon or opts.source,
		Title = opts.name,
		Height = opts.height,
		Width = opts.width,
		Fit = opts.fit,
		Align = opts.align,
		AspectRatio = opts.aspectRatio,
		CornerRadius = opts.cornerRadius,
		Transparency = opts.transparency,
		Color = opts.color,
		Border = opts.border,
		Background = opts.background,
	})
end

function apitab:CreateCharacter(opts)
	opts = options(opts)
	local section = self._tab:AddSection({
		Title = opts.name or "",
		Side = sideof(opts.side or "right"),
		Open = true,
	})
	return section:AddCharacter({
		Target = opts.target,
		Height = opts.height,
		Title = opts.label,
	})
end

function apitab:SetIcon(value)
	self._tab:SetIcon(value)
	return self
end

function apitab:SetSectionIcon(value)
	if self._section then
		self._section:SetIcon(value)
	end
	return self
end

function apitab:CreateSegmented(opts)
	opts = options(opts)
	return remember(self, opts.flag, self:_target():AddSegmented({
		Title = titleof(opts, "Segmented"),
		Flag = opts.flag,
		Options = opts.options or {},
		Default = opts.value,
		Callback = opts.callback,
		Icon = opts.icon,
		Content = opts.description,
		NoSave = opts.save == false,
	}))
end

function apitab:CreateStepper(opts)
	opts = options(opts)
	local range = type(opts.range) == "table" and opts.range or { 0, 100 }
	return remember(self, opts.flag, self:_target():AddStepper({
		Title = titleof(opts, "Stepper"),
		Flag = opts.flag,
		Min = range[1],
		Max = range[2],
		Increment = opts.increment or 1,
		Default = opts.value or range[1],
		Callback = opts.callback,
		Icon = opts.icon,
		Content = opts.description,
		NoSave = opts.save == false,
	}))
end

function apitab:CreateProgress(opts)
	opts = options(opts)
	local range = type(opts.range) == "table" and opts.range or { 0, 100 }
	return self:_target():AddProgress({
		Title = titleof(opts, "Progress"),
		Min = range[1],
		Max = range[2],
		Default = opts.value or range[1],
		Format = opts.format,
		Color = opts.color,
		Icon = opts.icon,
		Content = opts.description,
	})
end

function apitab:CreateParagraph(opts)
	opts = options(opts)
	return self:_target():AddParagraph({
		Title = tostring(opts.name or opts.title or ""),
		Content = tostring(opts.content or opts.description or ""),
		Icon = opts.icon,
	})
end

function apitab:CreateLabel(opts)
	opts = options(opts)
	return self:_target():AddParagraph({ Title = titleof(opts, ""), Content = "" })
end

function apitab:CreateDivider()
	return self:_target():AddDivider()
end

function apitab:Select()
	self._tab:Select()
end
