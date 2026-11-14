function items:AddCharacter(characterconfig)
	characterconfig = characterconfig or {}

	local box = instance.frame(sectionadd)
	box.Name = "Character"
	box.BorderSizePixel = 0
	box.LayoutOrder = countitem
	box.Size = UDim2.new(1, 0, 0, tonumber(characterconfig.Height) or 240)
	box.ClipsDescendants = true
	roundbg(box, design.Radius.Control, theme.Row)
	local boxstroke = instance.uistroke(box)
	boxstroke.Color = theme.Stroke
	boxstroke.Transparency = 0.5
	boxstroke.Thickness = 1

	local view = characterview(box, { Target = characterconfig.Target })

	local namelabel
	if characterconfig.Label ~= false then
		local label = instance.textlabel(box)
		label.Name = "Name"
		label.BackgroundTransparency = 1
		label.AnchorPoint = Vector2.new(0.5, 1)
		label.Position = UDim2.new(0.5, 0, 1, -8)
		label.Size = UDim2.new(1, -16, 0, 14)
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 11
		label.TextColor3 = theme.SubText
		label.TextTruncate = Enum.TextTruncate.AtEnd
		label.Text = tostring(characterconfig.Title or "")
		label.Visible = label.Text ~= ""
		namelabel = label
	end

	box.Destroying:Connect(function()
		view:Destroy()
	end)

	registerSearchItem(tostring(characterconfig.Title or "Character"), box, "Character")
	countitem = countitem + 1
	yieldbuild()

	local characterfunc = {}
	function characterfunc:SetTarget(target)
		view:SetTarget(target)
	end
	function characterfunc:Refresh()
		view:Render()
	end
	function characterfunc:SetTitle(text)
		if namelabel then
			namelabel.Text = tostring(text or "")
			namelabel.Visible = namelabel.Text ~= ""
		end
	end
	return characterfunc
end
