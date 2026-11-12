local function elevate()
	local setfn = (type(setthreadidentity) == "function" and setthreadidentity)
		or (type(set_thread_identity) == "function" and set_thread_identity)
		or (type(setidentity) == "function" and setidentity)
		or (type(setthreadcontext) == "function" and setthreadcontext)
		or (type(set_thread_context) == "function" and set_thread_context)
		or (type(syn) == "table" and type(syn.set_thread_identity) == "function" and syn.set_thread_identity)
	if setfn then
		pcall(setfn, 8)
	end
end

local function hexcolor(color)
	return string.format(
		"#%02X%02X%02X",
		math.floor(color.R * 255 + 0.5),
		math.floor(color.G * 255 + 0.5),
		math.floor(color.B * 255 + 0.5)
	)
end

local function textheight(text, size, font, width, maxheight)
	local ok, bounds = pcall(function()
		return sv.textservice:GetTextSize(tostring(text or ""), size, font, Vector2.new(math.max(20, width), 100000))
	end)
	if ok and bounds and bounds.Y > 0 then
		return math.min(maxheight or 100000, math.ceil(bounds.Y) + 2)
	end
	return size
end

local function escaperich(text)
	return (tostring(text or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function stepfromfraction(fraction, min, max, step)
	return math.floor((min + math.clamp(fraction, 0, 1) * (max - min)) / step + 0.5) * step
end

local function searchmatch(text, query)
	query = tostring(query or ""):lower()
	return query == "" or tostring(text):lower():find(query, 1, true) ~= nil
end

local function clipboardwrite(text)
	local fn = setclipboard or toclipboard or set_clipboard or writeclipboard
	if type(fn) ~= "function" and type(Clipboard) == "table" then
		fn = Clipboard.set
	end
	if type(fn) ~= "function" then
		return false
	end
	return (pcall(fn, tostring(text)))
end

