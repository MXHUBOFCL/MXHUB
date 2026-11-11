do
	local white, black = Color3.new(1, 1, 1), Color3.new(0, 0, 0)
	local basetheme = {}
	for key, value in pairs(theme) do
		if typeof(value) == "Color3" then
			basetheme[key] = value
		end
	end

	local LIGHTBG = Color3.fromRGB(243, 244, 248)

	local darktext, lighttext = Color3.fromRGB(14, 14, 17), Color3.fromRGB(255, 255, 253)

	local function luminance(color)
		local function linear(value)
			return value <= 0.03928 and value / 12.92 or ((value + 0.055) / 1.055) ^ 2.4
		end
		return 0.2126 * linear(color.R) + 0.7152 * linear(color.G) + 0.0722 * linear(color.B)
	end

	local function paintaccent(out, accent)
		local lum = luminance(accent)
		local overdark = (lum + 0.05) / (luminance(darktext) + 0.05)
		local overlight = (luminance(lighttext) + 0.05) / (lum + 0.05)
		local usedark = overdark >= overlight
		out.Accent = accent
		out.AccentText = usedark and darktext or lighttext
		out.ToggleOn = accent
		out.KnobOn = usedark and Color3.fromRGB(24, 26, 32) or Color3.fromRGB(254, 255, 255)
		out.SliderFill = accent
	end

	local function derive(bg, accent, light)
		local out
		if light then
			local function dn(amount)
				return bg:Lerp(black, amount)
			end
			local card = bg:Lerp(white, 0.6)
			out = {
				Backdrop = bg,
				Sidebar = dn(0.03),
				Card = card,
				Row = bg:Lerp(white, 0.5),
				Header = dn(0.045),
				Element = dn(0.03),
				Field = Color3.fromRGB(253, 253, 255),
				Inner = dn(0.03),
				Pill = card,
				TabActive = dn(0.075),
				Option = dn(0.02),
				ElementHover = dn(0.07),
				InnerHover = dn(0.07),
				Track = dn(0.11),
				Stroke = dn(0.1),
				StrokeSoft = dn(0.06),
				Bar = dn(0.2),
				ChatBg = card,
				Box = card,
				Mine = dn(0.06),
				Text = Color3.fromRGB(20, 22, 30),
				SubText = Color3.fromRGB(92, 98, 115),
				Dim = Color3.fromRGB(108, 114, 130),
				ToggleOff = dn(0.11),
				ToggleOffStroke = dn(0.2),
				OffText = Color3.fromRGB(120, 126, 145),
				KnobOff = Color3.fromRGB(255, 255, 251),
				KnobOn = Color3.fromRGB(254, 255, 255),
				SliderFill = Color3.fromRGB(40, 44, 58),
			}
		else
			local function up(amount)
				return bg:Lerp(white, amount)
			end
			out = {
				Backdrop = bg,
				Sidebar = bg:Lerp(black, 0.3),
				Card = up(0.04),
				Row = up(0.03),
				Header = up(0.06),
				Element = up(0.07),
				Field = up(0.06),
				Inner = up(0.07),
				Pill = up(0.05),
				TabActive = up(0.09),
				Option = up(0.05),
				ElementHover = up(0.11),
				InnerHover = up(0.12),
				Track = up(0.14),
				Stroke = up(0.12),
				StrokeSoft = up(0.07),
				Bar = up(0.2),
				ChatBg = up(0.03),
				Box = up(0.03),
				Mine = up(0.1),
				Text = basetheme.Text,
				SubText = basetheme.SubText,
				Dim = basetheme.Dim,
				ToggleOff = up(0.08),
				ToggleOffStroke = up(0.17),
				OffText = bg:Lerp(white, 0.45),
				KnobOff = bg:Lerp(white, 0.5),
				KnobOn = basetheme.KnobOn,
				SliderFill = basetheme.SliderFill,
			}
		end
		paintaccent(out, accent)
		return out
	end

	local themefile = "MX HUB/theme.json"
	theme.State = { Preset = "MX HUB", Accent = nil, Mode = "Dark" }

	local function find(name)
		local wanted = tostring(name or ""):lower()
		for _, preset in ipairs(presets) do
			if preset[1]:lower() == wanted then
				return preset
			end
		end
		return nil
	end

	local function parsehex(text)
		text = tostring(text or ""):gsub("%s", ""):gsub("^#", "")
		if #text == 8 then
			text = text:sub(1, 6)
		end
		if #text == 6 and text:match("^%x+$") then
			return Color3.fromRGB(tonumber(text:sub(1, 2), 16), tonumber(text:sub(3, 4), 16), tonumber(text:sub(5, 6), 16))
		end
		return nil
	end

	local function hex6(color)
		return string.format("%02X%02X%02X", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	end

	local function colorkey(color)
		return string.format("%d,%d,%d", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	end

	local function compose()
		local state = theme.State
		local preset = find(state.Preset) or presets[1]
		local accent = state.Accent or preset[3]
		if state.Mode == "Light" then
			return derive(LIGHTBG, accent, true)
		end
		if preset[4] then
			local out = {}
			for key, value in pairs(basetheme) do
				out[key] = value
			end
			paintaccent(out, accent)
			return out
		end
		return derive(preset[2], accent, false)
	end

	local function recolor(old)
		local map, any = {}, false
		for key, oldcolor in pairs(old) do
			local newcolor = theme[key]
			if typeof(newcolor) == "Color3" then
				local oldkey = colorkey(oldcolor)
				if oldkey ~= colorkey(newcolor) and map[oldkey] == nil then
					map[oldkey] = newcolor
					any = true
				end
			end
		end
		if not any then
			return
		end
		local function fix(inst, prop)
			local ok, current = pcall(function()
				return inst[prop]
			end)
			if ok and typeof(current) == "Color3" then
				local replacement = map[colorkey(current)]
				if replacement then
					inst[prop] = replacement
				end
			end
		end
		for _, name in ipairs({ "MXHUBUI", "ToggleUIButton", "NotifyGui", "PopupGui", "MXHUBWatermark" }) do
			local root = sv.coregui:FindFirstChild(name)
			if root then
				for _, d in ipairs(root:GetDescendants()) do
					if d:IsA("GuiObject") then
						fix(d, "BackgroundColor3")
						if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
							fix(d, "TextColor3")
						end
						if d:IsA("TextBox") then
							fix(d, "PlaceholderColor3")
						end
						if d:IsA("ImageLabel") or d:IsA("ImageButton") then
							fix(d, "ImageColor3")
						end
						if d:IsA("ScrollingFrame") then
							fix(d, "ScrollBarImageColor3")
						end
					elseif d:IsA("UIStroke") then
						fix(d, "Color")
					end
				end
			end
		end
	end

	local function persist()
		pcall(function()
			if type(writefile) ~= "function" then
				return
			end
			if type(isfolder) == "function" and not isfolder("MX HUB") then
				makefolder("MX HUB")
			end
			local state = theme.State
			writefile(themefile, sv.http:JSONEncode({
				preset = state.Preset,
				accent = state.Accent and hex6(state.Accent) or nil,
				mode = state.Mode,
			}))
		end)
	end

	theme.Api = {}

	function theme.Api.Names()
		local names = {}
		for _, preset in ipairs(presets) do
			names[#names + 1] = preset[1]
		end
		return names
	end

	function theme.Api.Accents()
		return accents
	end

	function theme.Api.ParseHex(text)
		return parsehex(text)
	end

	-- patch: { Preset = "Emerald", Accent = Color3 | false (clear), Mode = "Dark" | "Light" }
	function theme.Api.Set(patch, nosave)
		patch = patch or {}
		local state = theme.State
		if patch.Preset ~= nil then
			if not find(patch.Preset) then
				return false, "Unknown theme"
			end
			state.Preset = find(patch.Preset)[1]
		end
		if patch.Accent == false then
			state.Accent = nil
		elseif typeof(patch.Accent) == "Color3" then
			state.Accent = patch.Accent
		end
		if patch.Mode == "Dark" or patch.Mode == "Light" then
			state.Mode = patch.Mode
		end

		local old = {}
		for key, value in pairs(theme) do
			if typeof(value) == "Color3" then
				old[key] = value
			end
		end
		for key, value in pairs(compose()) do
			theme[key] = value
		end
		theme.Current = state.Preset
		local ok, err = pcall(recolor, old)
		if not ok then
			warn("[MX HUB] Theme recolor failed: " .. tostring(err))
		end
		if not nosave then
			persist()
		end
		return true, "Theme applied: " .. tostring(state.Preset) .. " / " .. tostring(state.Mode)
	end

	-- load the saved theme before any UI is built
	pcall(function()
		if type(isfile) ~= "function" or type(readfile) ~= "function" or not isfile(themefile) then
			return
		end
		local data = sv.http:JSONDecode(readfile(themefile))
		if type(data) ~= "table" then
			return
		end
		theme.Api.Set({
			Preset = type(data.preset) == "string" and find(data.preset) and data.preset or nil,
			Accent = type(data.accent) == "string" and parsehex(data.accent) or nil,
			Mode = data.mode,
		}, true)
	end)
end

