local keydisplay = {
	LeftControl = "LCtrl",
	RightControl = "RCtrl",
	LeftShift = "LShift",
	RightShift = "RShift",
	LeftAlt = "LAlt",
	RightAlt = "RAlt",
	Return = "Enter",
	Escape = "Esc",
	Backspace = "Bksp",
	Delete = "Del",
	Insert = "Ins",
	PageUp = "PgUp",
	PageDown = "PgDn",
	CapsLock = "Caps",
	Zero = "0",
	One = "1",
	Two = "2",
	Three = "3",
	Four = "4",
	Five = "5",
	Six = "6",
	Seven = "7",
	Eight = "8",
	Nine = "9",
	Backquote = "`",
	Minus = "-",
	Equals = "=",
	LeftBracket = "[",
	RightBracket = "]",
	BackSlash = "\\",
	Semicolon = ";",
	Quote = "'",
	Comma = ",",
	Period = ".",
	Slash = "/",
	MouseButton2 = "RMB",
	MouseButton3 = "MMB",
}

local function keyname(key)
	if not key then
		return "None"
	end
	return keydisplay[key.Name] or key.Name
end

local function resolvekey(value)
	if value == nil or value == false or value == "" or value == "None" then
		return nil
	end
	if typeof(value) == "EnumItem" then
		if value == Enum.KeyCode.Unknown then
			return nil
		end
		if value.EnumType == Enum.KeyCode then
			return value
		end
		if value == Enum.UserInputType.MouseButton2 or value == Enum.UserInputType.MouseButton3 then
			return value
		end
		return nil
	end
	local name = tostring(value):gsub("^Enum%.%a+%.", "")
	if name == "MouseButton2" or name == "MouseButton3" then
		return Enum.UserInputType[name]
	end
	local ok, key = pcall(function()
		return Enum.KeyCode[name]
	end)
	if ok and key and key ~= Enum.KeyCode.Unknown then
		return key
	end
	return nil
end

local function inputmatches(input, key)
	if not key then
		return false
	end
	if key.EnumType == Enum.KeyCode then
		return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key
	end
	return input.UserInputType == key
end

