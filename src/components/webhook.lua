MXHUB.Webhook = {}

do
	local hosts = { ["discord.com"] = true, ["discordapp.com"] = true, ["ptb.discord.com"] = true, ["canary.discord.com"] = true }
	local WINDOW, BURST = 2, 5
	local LIMITS = { content = 2000, username = 80, title = 256, description = 4096, name = 256, value = 1024, footer = 2048, author = 256 }
	local MAX_FIELDS, MAX_EMBEDS, MAX_EMBED_TOTAL = 25, 10, 6000

	local function cut(text, limit)
		text = tostring(text)
		if #text > limit then
			return text:sub(1, limit)
		end
		return text
	end

	local function colorvalue(color)
		if typeof(color) == "Color3" then
			return math.floor(color.R * 255 + 0.5) * 65536 + math.floor(color.G * 255 + 0.5) * 256 + math.floor(color.B * 255 + 0.5)
		end
		return tonumber(color)
	end

	local function httpsurl(value)
		return type(value) == "string" and value:match("^https://[%w%.%-_/%%?&=:#~+@,;]+$") ~= nil
	end

	function MXHUB.Webhook.Validate(url)
		if type(url) ~= "string" then
			return false
		end
		local host, path = url:match("^https://([%w%.]+)(/api/.+)$")
		if not host or not hosts[host] then
			return false
		end
		return path:match("^/api/webhooks/%d+/[%w_%-]+$") ~= nil or path:match("^/api/v%d+/webhooks/%d+/[%w_%-]+$") ~= nil
	end

	local function buildembed(source)
		if type(source) ~= "table" then
			return nil, "Embed must be a table"
		end
		local embed, total = {}, 0
		local function text(key, value, limit)
			if value ~= nil and value ~= "" then
				local clipped = cut(value, limit)
				total += #clipped
				embed[key] = clipped
			end
		end
		text("title", source.title, LIMITS.title)
		text("description", source.description, LIMITS.description)
		if httpsurl(source.url) then
			embed.url = source.url
		end
		local color = colorvalue(source.color)
		if color then
			embed.color = math.clamp(math.floor(color), 0, 16777215)
		end
		if source.timestamp == true then
			embed.timestamp = DateTime.now():ToIsoDate()
		elseif type(source.timestamp) == "string" then
			embed.timestamp = source.timestamp
		end
		if type(source.footer) == "table" or type(source.footer) == "string" then
			local footer = type(source.footer) == "table" and source.footer.text or source.footer
			if footer and footer ~= "" then
				local clipped = cut(footer, LIMITS.footer)
				total += #clipped
				embed.footer = { text = clipped }
			end
		end
		if type(source.author) == "table" and source.author.name then
			local clipped = cut(source.author.name, LIMITS.author)
			total += #clipped
			embed.author = { name = clipped }
		end
		if httpsurl(type(source.thumbnail) == "table" and source.thumbnail.url or source.thumbnail) then
			embed.thumbnail = { url = type(source.thumbnail) == "table" and source.thumbnail.url or source.thumbnail }
		end
		if httpsurl(type(source.image) == "table" and source.image.url or source.image) then
			embed.image = { url = type(source.image) == "table" and source.image.url or source.image }
		end
		if type(source.fields) == "table" then
			embed.fields = {}
			for _, field in ipairs(source.fields) do
				if #embed.fields >= MAX_FIELDS then
					break
				end
				if type(field) == "table" and field.name and field.value then
					local name, value = cut(field.name, LIMITS.name), cut(field.value, LIMITS.value)
					total += #name + #value
					embed.fields[#embed.fields + 1] = { name = name, value = value, inline = field.inline == true }
				end
			end
		end
		if total > MAX_EMBED_TOTAL then
			return nil, "Embed exceeds " .. MAX_EMBED_TOTAL .. " characters"
		end
		if next(embed) == nil then
			return nil, "Embed is empty"
		end
		return embed, total
	end

	function MXHUB.Webhook.Build(payload)
		if type(payload) == "string" then
			payload = { content = payload }
		end
		if type(payload) ~= "table" then
			return nil, "Payload must be a string or a table"
		end
		local body = {}
		if payload.allowMentions ~= true then
			body.allowed_mentions = { parse = {} }
		end
		if payload.content and payload.content ~= "" then
			body.content = cut(payload.content, LIMITS.content)
		end
		if payload.username and payload.username ~= "" then
			body.username = cut(payload.username, LIMITS.username)
		end
		if httpsurl(payload.avatar) then
			body.avatar_url = payload.avatar
		end
		if type(payload.embeds) == "table" then
			body.embeds = {}
			local grand = 0
			for _, source in ipairs(payload.embeds) do
				if #body.embeds >= MAX_EMBEDS then
					break
				end
				local embed, size = buildembed(source)
				if not embed then
					return nil, size
				end
				grand += size
				body.embeds[#body.embeds + 1] = embed
			end
			if grand > MAX_EMBED_TOTAL then
				return nil, "Embeds exceed " .. MAX_EMBED_TOTAL .. " characters together"
			end
		end
		if body.content == nil and (body.embeds == nil or #body.embeds == 0) then
			return nil, "Message needs content or an embed"
		end
		return body
	end

	function MXHUB.Webhook.New(url)
		if not MXHUB.Webhook.Validate(url) then
			return nil, "Invalid webhook URL (only discord.com webhooks are accepted)"
		end
		local hook = {}
		local sent = {}

		local function waitforslot()
			while true do
				local now = os.clock()
				while sent[1] and now - sent[1] >= WINDOW do
					table.remove(sent, 1)
				end
				if #sent < BURST then
					sent[#sent + 1] = now
					return
				end
				task.wait(WINDOW - (now - sent[1]) + 0.05)
			end
		end

		function hook:Send(payload)
			local body, problem = MXHUB.Webhook.Build(payload)
			if not body then
				return false, nil, problem
			end
			local request = httprequest()
			if not request then
				return false, nil, "No HTTP request function available in this executor"
			end
			local encoded = sv.http:JSONEncode(body)
			for attempt = 1, 3 do
				waitforslot()
				local ok, response = pcall(request, {
					Url = url,
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = encoded,
				})
				if not ok then
					return false, nil, tostring(response)
				end
				local status = tonumber(response.StatusCode) or 0
				if status >= 200 and status < 300 then
					return true, status
				end
				if status ~= 429 or attempt == 3 then
					return false, status, tostring(response.Body)
				end
				local retry = 1
				pcall(function()
					retry = tonumber(sv.http:JSONDecode(response.Body).retry_after) or 1
				end)
				task.wait(math.clamp(retry, 0.25, 10))
			end
			return false, 429, "Rate limited"
		end

		return hook
	end
end
