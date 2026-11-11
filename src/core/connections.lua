local allConnections = {}
local resizeDebounceTable = {}

local function trackConnection(conn, name)
	if not conn then
		return nil
	end
	table.insert(allConnections, { conn = conn, name = name or "unnamed" })
	return conn
end

local function disconnectAll()
	for _, entry in ipairs(allConnections) do
		if entry.conn then
			pcall(function()
				entry.conn:Disconnect()
			end)
		end
	end
	allConnections = {}
end

local function debounceResize(key, callback, delay)
	delay = delay or 0.1
	if resizeDebounceTable[key] then
		task.cancel(resizeDebounceTable[key])
	end
	resizeDebounceTable[key] = task.delay(delay, function()
		pcall(function()
			callback()
		end)
		resizeDebounceTable[key] = nil
	end)
end

