MXHUB.Discord = {}

do
	local cache = {}
	local TTL = 60

	function MXHUB.Discord.ParseInvite(value)
		if type(value) ~= "string" then
			return nil
		end
		value = value:match("^%s*(.-)%s*$")
		local code = value:match("^https?://discord%.gg/([%w%-]+)")
			or value:match("^https?://discord%.com/invite/([%w%-]+)")
			or value:match("^https?://discordapp%.com/invite/([%w%-]+)")
			or value:match("^discord%.gg/([%w%-]+)")
		if not code and value:match("^[%w%-]+$") then
			code = value
		end
		if code and #code >= 2 and #code <= 32 then
			return code
		end
		return nil
	end

	function MXHUB.Discord.Stats(invite, force)
		local code = MXHUB.Discord.ParseInvite(invite)
		if not code then
			return nil, "Not a Discord invite"
		end
		local hit = cache[code]
		if hit and not force and os.clock() - hit.at < TTL then
			return hit.info
		end
		local request = httprequest()
		if not request then
			return nil, "No HTTP request function available in this executor"
		end
		local ok, response = pcall(request, {
			Url = "https://discord.com/api/v10/invites/" .. code .. "?with_counts=true",
			Method = "GET",
		})
		if not ok then
			return nil, tostring(response)
		end
		local status = tonumber(response.StatusCode) or 0
		if status == 404 then
			return nil, "Invite not found"
		elseif status == 429 then
			return nil, "Rate limited, try again later"
		elseif status ~= 200 then
			return nil, "Discord answered " .. tostring(status)
		end
		local decoded, data = pcall(function()
			return sv.http:JSONDecode(response.Body)
		end)
		if not decoded or type(data) ~= "table" then
			return nil, "Unreadable response"
		end
		local info = {
			Code = code,
			Name = type(data.guild) == "table" and data.guild.name or nil,
			Members = tonumber(data.approximate_member_count),
			Online = tonumber(data.approximate_presence_count),
		}
		if not info.Members then
			return nil, "Response has no member count"
		end
		cache[code] = { at = os.clock(), info = info }
		return info
	end
end
