local function buildhomepage(page, ctx)
	local Players = game:GetService("Players")
	local lp = Players.LocalPlayer
	local order = 0
	local function nextorder()
		order = order + 1
		return order
	end

	local function addcorner(object, radius)
		instance.uicorner(object).CornerRadius = UDim.new(0, radius)
	end

	local function newcard(height)
		local card = instance.frame(page)
		card.Name = "HomeCard"
		card.LayoutOrder = nextorder()
		card.BorderSizePixel = 0
		card.BackgroundColor3 = theme.Row
		card.Size = UDim2.new(1, 0, 0, height)
		card.ClipsDescendants = true
		addcorner(card, 8)
		local stroke = instance.uistroke(card)
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Transparency = 0.93
		stroke.Thickness = 1
		return card
	end

	local function label(parent, str, size, font, color, position, dimension, align)
		local l = instance.textlabel(parent)
		l.BackgroundTransparency = 1
		l.BorderSizePixel = 0
		l.Text = str
		l.TextSize = size
		l.Font = font
		l.TextColor3 = color
		l.TextXAlignment = align or Enum.TextXAlignment.Left
		l.TextTruncate = Enum.TextTruncate.AtEnd
		l.Position = position
		l.Size = dimension
		return l
	end

	local function glyph(parent, name, px, position, color)
		local img = instance.imagelabel(parent)
		img.BackgroundTransparency = 1
		img.BorderSizePixel = 0
		img.Position = position
		img.Size = UDim2.new(0, px, 0, px)
		img.ImageColor3 = color or theme.Text
		applyicon(img, name, 48)
		return img
	end

	local function hover(button, normal, over)
		button.MouseEnter:Connect(function()
			tw(button, { BackgroundColor3 = over }, 0.15)
		end)
		button.MouseLeave:Connect(function()
			tw(button, { BackgroundColor3 = normal }, 0.2)
		end)
	end

	local function notify(title, content)
		pcall(function()
			MXHUB:Notify({ Title = title, Content = content, Duration = 4 })
		end)
	end

	local function copy(text, done)
		local ok = clipboardwrite(text)
		notify("MX HUB", ok and done or "Clipboard is not supported by this executor")
	end

	local gamename = tostring(ctx.Footer or "")
	if gamename == "" then
		gamename = "this game"
	end

	local head = instance.frame(page)
	head.Name = "HomeHeading"
	head.BackgroundTransparency = 1
	head.BorderSizePixel = 0
	head.LayoutOrder = nextorder()
	head.Size = UDim2.new(1, 0, 0, 34)
	glyph(head, "home", 20, UDim2.new(0, 4, 0.5, -10), theme.Text)
	local headtext = label(head, "Welcome to " .. tostring(ctx.HubName or "MX HUB") .. "!", 16, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 32, 0, 0), UDim2.new(1, -36, 1, 0))

	local welcome = newcard(112)
	label(welcome, "WELCOME BACK", 10, Enum.Font.GothamMedium, theme.SubText, UDim2.new(0, 14, 0, 12), UDim2.new(1, -140, 0, 12))
	local shownname = lp and lp.DisplayName or "Player"
	local shownuser = lp and ("@" .. lp.Name) or ""
	local namelabel = label(welcome, shownname, 22, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 14, 0, 26), UDim2.new(1, -130, 0, 28))
	local userlabel = label(welcome, shownuser, 12, Enum.Font.Gotham, theme.SubText, UDim2.new(0, 14, 0, 56), UDim2.new(1, -130, 0, 14))

	local avatar = instance.imagelabel(welcome)
	avatar.Name = "Avatar"
	avatar.BackgroundTransparency = 1
	avatar.AnchorPoint = Vector2.new(1, 1)
	avatar.Position = UDim2.new(1, -6, 1, 4)
	avatar.Size = UDim2.new(0, 104, 0, 104)
	avatar.ScaleType = Enum.ScaleType.Fit
	if lp then
		avatar.Image = string.format("rbxthumb://type=AvatarBust&id=%d&w=150&h=150", lp.UserId)
	end

	local chiprow = instance.frame(welcome)
	chiprow.BackgroundTransparency = 1
	chiprow.BorderSizePixel = 0
	chiprow.Position = UDim2.new(0, 14, 0, 80)
	chiprow.Size = UDim2.new(1, -130, 0, 24)
	local chiplayout = instance.uilistlayout(chiprow)
	chiplayout.FillDirection = Enum.FillDirection.Horizontal
	chiplayout.SortOrder = Enum.SortOrder.LayoutOrder
	chiplayout.VerticalAlignment = Enum.VerticalAlignment.Center
	chiplayout.Padding = UDim.new(0, 6)

	local function chip(iconname, text, width, layoutorder, tint)
		local b = instance.textbutton(chiprow)
		b.Text = ""
		b.AutoButtonColor = false
		b.BorderSizePixel = 0
		b.LayoutOrder = layoutorder
		b.BackgroundColor3 = theme.Field
		b.Size = UDim2.new(0, width, 0, 24)
		addcorner(b, 12)
		local icon = glyph(b, iconname, 12, UDim2.new(0, 8, 0.5, -6), tint or theme.SubText)
		label(b, text, 11, Enum.Font.GothamMedium, theme.SubText, UDim2.new(0, 25, 0, 0), UDim2.new(1, -29, 1, 0))
		hover(b, theme.Field, theme.InnerHover)
		return b, icon
	end

	local namehidden, avatarhidden = false, false
	local namechip, nameicon = chip("eye", "Name", 66, 1)
	namechip.Activated:Connect(function()
		namehidden = not namehidden
		namelabel.Text = namehidden and "*****" or shownname
		userlabel.Text = namehidden and "@*****" or shownuser
		applyicon(nameicon, namehidden and "eye-off" or "eye", 48)
	end)
	local avatarchip, avataricon = chip("user", "Avatar", 74, 2)
	avatarchip.Activated:Connect(function()
		avatarhidden = not avatarhidden
		avatar.Visible = not avatarhidden
		applyicon(avataricon, avatarhidden and "user-x" or "user", 48)
	end)

	local stats = newcard(136)
	local HIST, CHART_H = 24, 28

	local function metric(xscale, title)
		local holder = instance.frame(stats)
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		holder.Position = UDim2.new(xscale, 0, 0, 0)
		holder.Size = UDim2.new(0.5, 0, 0, 96)
		label(holder, title, 11, Enum.Font.GothamMedium, theme.SubText, UDim2.new(0, 14, 0, 10), UDim2.new(0, 60, 0, 12))
		local value = label(holder, "0", 22, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 14, 0, 24), UDim2.new(0.6, 0, 0, 26))
		value.RichText = true
		local range = label(holder, "min 0  avg 0  max 0", 10, Enum.Font.Gotham, theme.SubText, UDim2.new(1, -10, 0, 10), UDim2.new(0.62, 0, 0, 12), Enum.TextXAlignment.Right)
		range.AnchorPoint = Vector2.new(1, 0)
		local chart = instance.frame(holder)
		chart.BackgroundTransparency = 1
		chart.BorderSizePixel = 0
		chart.Position = UDim2.new(0, 14, 0, 58)
		chart.Size = UDim2.new(1, -24, 0, CHART_H)
		local chartlayout = instance.uilistlayout(chart)
		chartlayout.FillDirection = Enum.FillDirection.Horizontal
		chartlayout.SortOrder = Enum.SortOrder.LayoutOrder
		chartlayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		chartlayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		chartlayout.Padding = UDim.new(0, 2)
		local bars = {}
		for i = 1, HIST do
			local bar = instance.frame(chart)
			bar.BorderSizePixel = 0
			bar.LayoutOrder = i
			bar.BackgroundColor3 = theme.Track
			bar.Size = UDim2.new(0, 4, 0, 2)
			bar.Visible = false
			bars[i] = bar
		end
		return { Value = value, Range = range, Bars = bars }
	end

	local fpsmetric = metric(0, "FPS")
	local pingmetric = metric(0.5, "Ping")

	local divider = instance.frame(stats)
	divider.BorderSizePixel = 0
	divider.BackgroundColor3 = theme.Stroke
	divider.BackgroundTransparency = 0.4
	divider.Position = UDim2.new(0, 14, 0, 98)
	divider.Size = UDim2.new(1, -28, 0, 1)

	local function bigstat(xscale, caption)
		local v = label(stats, "-", 15, Enum.Font.GothamBold, theme.Text, UDim2.new(xscale, 14, 0, 104), UDim2.new(0.5, -20, 0, 16))
		label(stats, caption, 10, Enum.Font.Gotham, theme.SubText, UDim2.new(xscale, 14, 0, 121), UDim2.new(0.5, -20, 0, 12))
		return v
	end
	local playersvalue = bigstat(0, "Players")
	local sessionvalue = bigstat(0.5, "Session")

	local gamecard = newcard(142)
	local gameicon = instance.imagelabel(gamecard)
	gameicon.Name = "GameIcon"
	gameicon.BackgroundColor3 = theme.Field
	gameicon.BorderSizePixel = 0
	gameicon.Position = UDim2.new(0, 14, 0, 12)
	gameicon.Size = UDim2.new(0, 44, 0, 44)
	gameicon.ScaleType = Enum.ScaleType.Crop
	addcorner(gameicon, 8)
	pcall(function()
		gameicon.Image = string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", game.GameId)
	end)
	local gamenamelabel = label(gamecard, gamename, 13, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 66, 0, 14), UDim2.new(1, -80, 0, 16))
	local gamesub = label(gamecard, "", 11, Enum.Font.Gotham, theme.SubText, UDim2.new(0, 66, 0, 33), UDim2.new(1, -80, 0, 14))

	local buttonrow = instance.frame(gamecard)
	buttonrow.BackgroundTransparency = 1
	buttonrow.BorderSizePixel = 0
	buttonrow.Position = UDim2.new(0, 14, 0, 66)
	buttonrow.Size = UDim2.new(1, -28, 0, 52)
	local rowlayout = instance.uilistlayout(buttonrow)
	rowlayout.FillDirection = Enum.FillDirection.Horizontal
	rowlayout.SortOrder = Enum.SortOrder.LayoutOrder
	rowlayout.Padding = UDim.new(0, 6)

	local function actionbutton(iconname, text, layoutorder, callback)
		local b = instance.textbutton(buttonrow)
		b.Text = ""
		b.AutoButtonColor = false
		b.BorderSizePixel = 0
		b.LayoutOrder = layoutorder
		b.BackgroundColor3 = theme.Field
		b.Size = UDim2.new(0.5, -3, 1, 0)
		addcorner(b, 8)
		local icon = glyph(b, iconname, 16, UDim2.new(0.5, -8, 0, 9), theme.Text)
		label(b, text, 11, Enum.Font.GothamMedium, theme.SubText, UDim2.new(0, 0, 0, 30), UDim2.new(1, 0, 0, 14), Enum.TextXAlignment.Center)
		hover(b, theme.Field, theme.InnerHover)
		b.Activated:Connect(callback)
		return b
	end

	local function teleport(jobid)
		local ok, err = pcall(function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobid, lp)
		end)
		if not ok then
			notify("MX HUB", "Teleport failed: " .. tostring(err))
		end
	end

	actionbutton("refresh-cw", "Rejoin", 1, function()
		if #Players:GetPlayers() <= 1 then
			pcall(function()
				game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
			end)
		else
			teleport(game.JobId)
		end
	end)
	actionbutton("copy", "Job ID", 2, function()
		copy(tostring(game.JobId), "Job ID copied")
	end)

	local jobid = tostring(game.JobId)
	local shortjob = #jobid > 14 and (jobid:sub(1, 8) .. ".." .. jobid:sub(-4)) or (jobid ~= "" and jobid or "-")
	label(gamecard, "Job " .. shortjob .. "  ·  Place " .. tostring(game.PlaceId), 10, Enum.Font.Gotham, theme.Dim, UDim2.new(0, 14, 0, 124), UDim2.new(1, -28, 0, 12))

	local links = newcard(112)
	label(links, "LINKS", 10, Enum.Font.GothamMedium, theme.SubText, UDim2.new(0, 14, 0, 10), UDim2.new(1, -28, 0, 12))

	local function linkrow(y, iconname, title, sub, actionicon, action)
		glyph(links, iconname, 18, UDim2.new(0, 14, 0, y + 11), theme.Text)
		label(links, title, 12, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 44, 0, y + 4), UDim2.new(1, -100, 0, 14))
		local sublabel = label(links, sub, 11, Enum.Font.Gotham, theme.SubText, UDim2.new(0, 44, 0, y + 20), UDim2.new(1, -100, 0, 14))
		local b = instance.textbutton(links)
		b.Text = ""
		b.AutoButtonColor = false
		b.BorderSizePixel = 0
		b.BackgroundColor3 = theme.Field
		b.AnchorPoint = Vector2.new(1, 0)
		b.Position = UDim2.new(1, -14, 0, y + 6)
		b.Size = UDim2.new(0, 28, 0, 28)
		addcorner(b, 14)
		glyph(b, actionicon, 14, UDim2.new(0.5, -7, 0.5, -7), theme.Text)
		hover(b, theme.Field, theme.InnerHover)
		b.Activated:Connect(action)
		return sublabel
	end

	local discordurl = tostring(ctx.Discord or "")
	linkrow(26, "globe", "Community", ctx.OpenCommunity and "Discord, Donate" or discordurl, ctx.OpenCommunity and "chevron-right" or "copy", function()
		if ctx.OpenCommunity then
			ctx.OpenCommunity()
		else
			copy(discordurl, "Link copied")
		end
	end)
	local linedivider = instance.frame(links)
	linedivider.BorderSizePixel = 0
	linedivider.BackgroundColor3 = theme.Stroke
	linedivider.BackgroundTransparency = 0.4
	linedivider.Position = UDim2.new(0, 14, 0, 68)
	linedivider.Size = UDim2.new(1, -28, 0, 1)
	local featuresub = linkrow(72, "list-checks", "Feature list", "...", "chevron-right", function()
		if ctx.OpenFeatures then
			ctx.OpenFeatures()
		end
	end)

	local footer = instance.frame(page)
	footer.Name = "HomeFooter"
	footer.BackgroundTransparency = 1
	footer.BorderSizePixel = 0
	footer.LayoutOrder = nextorder()
	footer.Size = UDim2.new(1, 0, 0, 30)
	local dot = instance.frame(footer)
	dot.BorderSizePixel = 0
	dot.BackgroundColor3 = theme.Good
	dot.Position = UDim2.new(0, 8, 0.5, -4)
	dot.Size = UDim2.new(0, 8, 0, 8)
	addcorner(dot, 4)
	local executor = "Unknown"
	pcall(function()
		local name = identifyexecutor and identifyexecutor()
		if name then
			executor = tostring(name)
		end
	end)
	local execlabel = label(footer, string.format('<font color="#EEEEF3"><b>%s</b></font>  <font color="#A2A2AE">Executor detected</font>', executor), 12, Enum.Font.Gotham, theme.SubText, UDim2.new(0, 24, 0, 0), UDim2.new(1, -150, 1, 0))
	execlabel.RichText = true
	local keychip = instance.frame(footer)
	keychip.BorderSizePixel = 0
	keychip.BackgroundColor3 = theme.Field
	keychip.AnchorPoint = Vector2.new(1, 0.5)
	keychip.Position = UDim2.new(1, -4, 0.5, 0)
	keychip.Size = UDim2.new(0, 48, 0, 22)
	addcorner(keychip, 11)
	label(keychip, keyname(ctx.ToggleKey), 11, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), Enum.TextXAlignment.Center)
	local hint = label(footer, "Tap the logo or", 11, Enum.Font.Gotham, theme.SubText, UDim2.new(1, -58, 0, 0), UDim2.new(0, 100, 1, 0), Enum.TextXAlignment.Right)
	hint.AnchorPoint = Vector2.new(1, 0)

	local ping = 0
	fpsmeter.start()

	local fpshist, pinghist = {}, {}
	local fpsstat = { min = math.huge, max = 0, sum = 0, n = 0 }
	local pingstat = { min = math.huge, max = 0, sum = 0, n = 0 }

	local function record(hist, stat, value)
		table.insert(hist, value)
		if #hist > HIST then
			table.remove(hist, 1)
		end
		stat.min = math.min(stat.min, value)
		stat.max = math.max(stat.max, value)
		stat.sum = stat.sum + value
		stat.n = stat.n + 1
	end

	local function paint(m, hist, stat, unit, floor, qualitycolor)
		local current = hist[#hist] or 0
		m.Value.Text = string.format('%d <font size="12" color="#A2A2AE">%s</font>', current, unit)
		m.Range.Text = string.format(
			"min %d  avg %d  max %d",
			stat.min == math.huge and 0 or stat.min,
			stat.n > 0 and math.floor(stat.sum / stat.n + 0.5) or 0,
			stat.max
		)
		local scale = math.max(stat.max, floor, 1)
		for i, bar in ipairs(m.Bars) do
			local v = hist[#hist - (#m.Bars - i)]
			if v then
				bar.Visible = true
				bar.Size = UDim2.new(0, 4, 0, math.max(2, math.floor(CHART_H * math.clamp(v / scale, 0, 1))))
				bar.BackgroundColor3 = qualitycolor(v)
			else
				bar.Visible = false
			end
		end
	end

	local function fpscolor(v)
		return v >= 50 and theme.Good or (v >= 30 and theme.Gold or theme.Bad)
	end
	local function pingcolor(v)
		return v <= 100 and theme.Good or (v <= 200 and theme.Gold or theme.Bad)
	end

	local function formatsession(seconds)
		seconds = math.floor(seconds)
		if seconds < 60 then
			return seconds .. "s"
		elseif seconds < 3600 then
			return string.format("%dm %02ds", math.floor(seconds / 60), seconds % 60)
		end
		return string.format("%dh %02dm", math.floor(seconds / 3600), math.floor(seconds % 3600 / 60))
	end

	local creator = ""
	task.spawn(function()
		local ok, info = pcall(function()
			return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
		end)
		if ok and type(info) == "table" then
			if info.Name then
				gamenamelabel.Text = tostring(info.Name)
			end
			if type(info.Creator) == "table" and info.Creator.Name then
				creator = tostring(info.Creator.Name)
			end
		end
	end)

	task.spawn(function()
		local started = os.clock()
		while page.Parent do
			pcall(function()
				ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
			end)
			record(fpshist, fpsstat, fpsmeter.value)
			record(pinghist, pingstat, ping)
			paint(fpsmetric, fpshist, fpsstat, "fps", 60, fpscolor)
			paint(pingmetric, pinghist, pingstat, "ms", 150, pingcolor)

			local count, maxplayers = #Players:GetPlayers(), Players.MaxPlayers
			playersvalue.Text = string.format("%d/%d", count, maxplayers)
			sessionvalue.Text = formatsession(os.clock() - started)
			gamesub.Text = (creator ~= "" and ("by " .. creator .. "  ·  ") or "") .. string.format("%d/%d players", count, maxplayers)
			local features, names = ctx.GetFeatureInfo()
			featuresub.Text = string.format("%d features across %d tabs", features, #names)
			task.wait(0.5)
		end
	end)
end
