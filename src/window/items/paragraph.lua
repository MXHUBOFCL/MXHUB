function items:AddParagraph(paragraphconfig)
	paragraphconfig = paragraphconfig or {}
	paragraphconfig.Title = paragraphconfig.Title or "Title"
	paragraphconfig.Content = paragraphconfig.Content or "Content"
	local paragraphfunc = {}

	local paragraph = instance.frame(sectionadd)
	paragraph.Name = "Paragraph"
	paragraph.BorderSizePixel = 0
	paragraph.LayoutOrder = countitem
	paragraph.Size = UDim2.new(1, 0, 0, 46)
	roundbg(paragraph, design.Radius.Control, theme.Row)

	local iconoffset = hasimage(paragraphconfig.Icon) and 30 or 10

	local paragraphtitle = instance.textlabel(paragraph)
	paragraphtitle.Name = "ParagraphTitle"
	paragraphtitle.Font = Enum.Font.GothamBold
	paragraphtitle.Text = paragraphconfig.Title
	paragraphtitle.TextColor3 = theme.Text
	paragraphtitle.TextSize = 13
	paragraphtitle.TextXAlignment = Enum.TextXAlignment.Left
	paragraphtitle.TextYAlignment = Enum.TextYAlignment.Top
	paragraphtitle.BackgroundTransparency = 1
	paragraphtitle.Position = UDim2.new(0, iconoffset, 0, 10)
	paragraphtitle.Size = UDim2.new(1, -(iconoffset + 10), 0, 13)
	paragraphtitle.TextTruncate = Enum.TextTruncate.AtEnd

	local paragraphcontent = instance.textlabel(paragraph)
	paragraphcontent.Name = "ParagraphContent"
	paragraphcontent.Font = Enum.Font.Gotham
	paragraphcontent.Text = paragraphconfig.Content
	paragraphcontent.TextColor3 = theme.Text
	paragraphcontent.TextSize = 13
	paragraphcontent.TextXAlignment = Enum.TextXAlignment.Left
	paragraphcontent.TextYAlignment = Enum.TextYAlignment.Top
	paragraphcontent.BackgroundTransparency = 1
	paragraphcontent.Position = UDim2.new(0, iconoffset, 0, 25)
	paragraphcontent.TextWrapped = true
	paragraphcontent.RichText = true
	paragraphcontent.Size = UDim2.new(1, -(iconoffset + 10), 0, 0)

	local paragraphicon
	local function seticon(value)
		local has = hasimage(value)
		if has and not paragraphicon then
			paragraphicon = instance.imagelabel(paragraph)
			paragraphicon.Name = "ParagraphIcon"
			paragraphicon.Size = UDim2.new(0, 20, 0, 20)
			paragraphicon.Position = UDim2.new(0, 8, 0, 12)
			paragraphicon.BackgroundTransparency = 1
		end
		if paragraphicon then
			paragraphicon.Visible = has
			if has then
				applyicon(paragraphicon, value, 48)
			end
		end
		iconoffset = has and 30 or 10
		paragraphtitle.Position = UDim2.new(0, iconoffset, 0, 10)
		paragraphtitle.Size = UDim2.new(1, -(iconoffset + 10), 0, 13)
		paragraphcontent.Position = UDim2.new(0, iconoffset, 0, 25)
		paragraphcontent.Size = UDim2.new(1, -(iconoffset + 10), 0, 0)
	end
	seticon(paragraphconfig.Icon)

	local paragraphbutton
	if paragraphconfig.ButtonText then
		paragraphbutton = instance.textbutton(paragraph)
		paragraphbutton.Position = UDim2.new(0, 10, 0, 42)
		paragraphbutton.Size = UDim2.new(1, -22, 0, 28)
		paragraphbutton.Font = Enum.Font.GothamMedium
		paragraphbutton.TextSize = 13
		paragraphbutton.TextTransparency = 0
		paragraphbutton.TextColor3 = theme.Text
		paragraphbutton.Text = paragraphconfig.ButtonText

		hoverbg(paragraphbutton, roundbg(paragraphbutton, design.Radius.Control, theme.Inner), theme.Inner, theme.InnerHover)

		if paragraphconfig.ButtonCallback then
			paragraphbutton.MouseButton1Click:Connect(paragraphconfig.ButtonCallback)
		end
	end

	local function updatesize()
		local textheight_ = paragraphcontent.TextBounds.Y
		local totalheight = textheight_ + 33
		if paragraphbutton then

			paragraphbutton.Position = UDim2.new(0, 10, 0, 25 + textheight_ + 8)
			totalheight = 25 + textheight_ + 8 + paragraphbutton.Size.Y.Offset + 10
		end
		paragraph.Size = UDim2.new(1, 0, 0, totalheight)
	end

	task.defer(updatesize)
	paragraphcontent:GetPropertyChangedSignal("TextBounds"):Connect(updatesize)

	paragraphcontent:GetPropertyChangedSignal("AbsoluteSize"):Connect(updatesize)

	function paragraphfunc:SetIcon(value)
		seticon(value)
		updatesize()
	end

	function paragraphfunc:SetContent(content)
		content = content or "Content"
		paragraphcontent.Text = content
		updatesize()
	end

	registerSearchItem(paragraphconfig.Title, paragraph)
	countitem = countitem + 1
	yieldbuild()
	return paragraphfunc
end

