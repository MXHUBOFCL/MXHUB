local function buildcommunitypage(page, ctx)
	local order = 0
	local function nextorder()
		order = order + 1
		return order
	end

	local function notify(content)
		pcall(function()
			MXHUB:Notify({ Title = "MX HUB", Content = content, Duration = 4 })
		end)
	end

	local function corner(object, radius)
		instance.uicorner(object).CornerRadius = UDim.new(0, radius)
	end

	local function label(parent, text, font, size, color)
		local l = instance.textlabel(parent)
		l.BackgroundTransparency = 1
		l.BorderSizePixel = 0
		l.Text = text
		l.Font = font
		l.TextSize = size
		l.TextColor3 = color
		l.TextXAlignment = Enum.TextXAlignment.Left
		return l
	end

	local rowheight = isMobile and 40 or 36

	-- Heading: tile + judul, tinggi tetap, lebar mengikuti halaman.
	local head = instance.frame(page)
	head.Name = "CommunityHeading"
	head.BackgroundTransparency = 1
	head.BorderSizePixel = 0
	head.LayoutOrder = nextorder()
	head.Size = UDim2.new(1, 0, 0, 40)

	local headtile = instance.frame(head)
	headtile.BorderSizePixel = 0
	headtile.BackgroundColor3 = theme.Element
	headtile.Position = UDim2.new(0, 0, 0.5, -18)
	headtile.Size = UDim2.new(0, 36, 0, 36)
	corner(headtile, 10)
	local headicon = instance.imagelabel(headtile)
	headicon.BackgroundTransparency = 1
	headicon.BorderSizePixel = 0
	headicon.AnchorPoint = Vector2.new(0.5, 0.5)
	headicon.Position = UDim2.new(0.5, 0, 0.5, 0)
	headicon.Size = UDim2.new(0, 20, 0, 20)
	headicon.ImageColor3 = theme.Text
	applyicon(headicon, "globe", 48)

	local headtitle = label(head, "MX HUB COMMUNITY", Enum.Font.GothamBold, 16, theme.Text)
	headtitle.Position = UDim2.new(0, 46, 0, 2)
	headtitle.Size = UDim2.new(1, -46, 0, 20)
	headtitle.TextTruncate = Enum.TextTruncate.AtEnd
	local headsub = label(head, "Discord and donations, all in one place", Enum.Font.Gotham, 12, theme.SubText)
	headsub.Position = UDim2.new(0, 46, 0, 22)
	headsub.Size = UDim2.new(1, -46, 0, 16)
	headsub.TextTruncate = Enum.TextTruncate.AtEnd

	-- Kartu: tinggi otomatis (AutomaticSize), jadi aman saat window di-resize / dipakai di layar kecil.
	local function newcard(spec)
		local card = instance.frame(page)
		card.Name = "CommunityCard"
		card.LayoutOrder = nextorder()
		card.BorderSizePixel = 0
		card.BackgroundColor3 = theme.Row
		card.BackgroundTransparency = rowalpha
		card.Size = UDim2.new(1, 0, 0, 0)
		card.AutomaticSize = Enum.AutomaticSize.Y
		corner(card, 10)
		local stroke = instance.uistroke(card)
		stroke.Color = spec.accent
		stroke.Transparency = 0.8
		stroke.Thickness = 1

		local pad = instance.uipadding(card)
		pad.PaddingTop = UDim.new(0, 14)
		pad.PaddingBottom = UDim.new(0, 14)
		pad.PaddingLeft = UDim.new(0, 14)
		pad.PaddingRight = UDim.new(0, 14)
		local list = instance.uilistlayout(card)
		list.Padding = UDim.new(0, 10)
		list.SortOrder = Enum.SortOrder.LayoutOrder

		local top = instance.frame(card)
		top.BackgroundTransparency = 1
		top.BorderSizePixel = 0
		top.LayoutOrder = 1
		top.Size = UDim2.new(1, 0, 0, 38)

		local tile = instance.frame(top)
		tile.BorderSizePixel = 0
		tile.BackgroundColor3 = spec.accent:Lerp(theme.Card, 0.8)
		tile.Size = UDim2.new(0, 38, 0, 38)
		corner(tile, 10)
		local tilestroke = instance.uistroke(tile)
		tilestroke.Color = spec.accent
		tilestroke.Transparency = 0.7
		tilestroke.Thickness = 1
		local glyph = instance.imagelabel(tile)
		glyph.BackgroundTransparency = 1
		glyph.BorderSizePixel = 0
		glyph.AnchorPoint = Vector2.new(0.5, 0.5)
		glyph.Position = UDim2.new(0.5, 0, 0.5, 0)
		glyph.Size = UDim2.new(0, 22, 0, 22)
		glyph.ImageColor3 = spec.accent:Lerp(Color3.new(1, 1, 1), 0.25)
		applyicon(glyph, spec.icon, 48)

		local title = label(top, spec.title, Enum.Font.GothamBold, 15, theme.Text)
		title.Position = UDim2.new(0, 48, 0, 2)
		title.Size = UDim2.new(1, -48, 0, 18)
		title.TextTruncate = Enum.TextTruncate.AtEnd
		local tag = label(top, spec.tag, Enum.Font.GothamMedium, 11, theme.SubText)
		tag.Position = UDim2.new(0, 48, 0, 21)
		tag.Size = UDim2.new(1, -48, 0, 15)
		tag.TextTruncate = Enum.TextTruncate.AtEnd

		local desc = label(card, spec.description, Enum.Font.Gotham, 13, theme.SubText)
		desc.LayoutOrder = 2
		desc.TextWrapped = true
		desc.TextYAlignment = Enum.TextYAlignment.Top
		desc.Size = UDim2.new(1, 0, 0, 0)
		desc.AutomaticSize = Enum.AutomaticSize.Y

		local field = instance.frame(card)
		field.LayoutOrder = 3
		field.BorderSizePixel = 0
		field.BackgroundColor3 = theme.Field
		field.Size = UDim2.new(1, 0, 0, rowheight - 4)
		corner(field, 8)
		local fieldicon = instance.imagelabel(field)
		fieldicon.BackgroundTransparency = 1
		fieldicon.BorderSizePixel = 0
		fieldicon.AnchorPoint = Vector2.new(0, 0.5)
		fieldicon.Position = UDim2.new(0, 10, 0.5, 0)
		fieldicon.Size = UDim2.new(0, 14, 0, 14)
		fieldicon.ImageColor3 = theme.Dim
		applyicon(fieldicon, "link", 48)
		local urllabel = label(field, spec.url, Enum.Font.GothamMedium, 12, theme.Text)
		urllabel.TextTruncate = Enum.TextTruncate.AtEnd
		urllabel.Position = UDim2.new(0, 32, 0, 0)
		urllabel.Size = UDim2.new(1, -42, 1, 0)

		local button = instance.textbutton(card)
		button.LayoutOrder = 4
		button.AutoButtonColor = false
		button.BorderSizePixel = 0
		button.BackgroundColor3 = spec.accent
		button.Size = UDim2.new(1, 0, 0, rowheight)
		button.Font = Enum.Font.GothamBold
		button.TextSize = 13
		button.TextColor3 = spec.accentText
		button.Text = spec.button
		corner(button, 8)
		local hover = spec.accent:Lerp(Color3.new(1, 1, 1), 0.14)
		button.MouseEnter:Connect(function()
			tw(button, { BackgroundColor3 = hover }, 0.15)
		end)
		button.MouseLeave:Connect(function()
			tw(button, { BackgroundColor3 = spec.accent }, 0.2)
		end)
		local busy = false
		button.Activated:Connect(function()
			local copied = clipboardwrite(spec.url)
			notify(copied and (spec.done .. " link copied") or spec.url)
			if busy then
				return
			end
			busy = true
			button.Text = copied and "Copied!" or "Clipboard not supported"
			task.delay(1.5, function()
				busy = false
				if button.Parent then
					button.Text = spec.button
				end
			end)
		end)
		return card
	end

	newcard({
		icon = assets.Discord,
		title = "Discord",
		tag = "Community & support",
		description = "Join to ask questions, get help, talk about scripts, and hear about the latest updates first.",
		url = ctx.Discord,
		button = "Copy Discord Invite",
		done = "Discord",
		accent = Color3.fromRGB(88, 101, 242),
		accentText = Color3.fromRGB(255, 255, 255),
	})
	newcard({
		icon = "wallet",
		title = "Donate",
		tag = "Support development",
		description = "Help us keep building and updating quality premium scripts, so they stay free and keyless for everyone.",
		url = ctx.Donate,
		button = "Copy Donate Link",
		done = "Donate",
		accent = theme.Gold,
		accentText = Color3.fromRGB(20, 16, 6),
	})
end
