local function stepprecision(step)
	local text = tostring(step)
	if text:find("e") or text:find("E") then
		text = string.format("%.12f", step):gsub("0+$", ""):gsub("%.$", "")
	end
	local dot = text:find("%.")
	return dot and (#text - dot) or 0
end

local function snapnumber(value, min, max, step, precision)
	value = math.clamp(tonumber(value) or min, min, max)
	value = math.clamp(math.floor(value / step + 0.5) * step, min, max)
	return tonumber(string.format("%." .. precision .. "f", value)) or min
end

local function numbertext(value, precision)
	value = tonumber(string.format("%." .. precision .. "f", value)) or 0
	if precision > 0 then
		return (string.format("%." .. precision .. "f", value):gsub("0+$", ""):gsub("%.$", ""))
	end
	return tostring(math.floor(value + 0.5))
end

local function pickoption(choices, value, fallback)
	for _, choice in ipairs(choices) do
		if choice == value then
			return choice
		end
	end
	return fallback
end
