function items:AddImage(imageconfig)
	imageconfig = imageconfig or {}
	local fittypes = {
		contain = Enum.ScaleType.Fit,
		fit = Enum.ScaleType.Fit,
		cover = Enum.ScaleType.Crop,
		crop = Enum.ScaleType.Crop,
		stretch = Enum.ScaleType.Stretch,
	}

	local holder = instance.frame(sectionadd)
	holder.Name = "Image"
	holder.BorderSizePixel = 0
	holder.LayoutOrder = countitem
	holder.Size = UDim2.new(1, 0, 0, tonumber(imageconfig.Height) or 140)
	holder.ClipsDescendants = true
	if imageconfig.Background == false then
		holder.BackgroundTransparency = 1
		instance.uicorner(holder).CornerRadius = UDim.new(0, tonumber(imageconfig.CornerRadius) or 6)
	else
		roundbg(holder, tonumber(imageconfig.CornerRadius) or 6, typeof(imageconfig.Background) == "Color3" and imageconfig.Background or theme.Row)
	end

	local border
	if imageconfig.Border then
		border = instance.uistroke(holder)
		border.Color = typeof(imageconfig.Border) == "Color3" and imageconfig.Border or theme.Stroke
		border.Transparency = 0.4
		border.Thickness = 1
	end

	local picture = instance.imagelabel(holder)
	picture.Name = "Picture"
	picture.BackgroundTransparency = 1
	picture.BorderSizePixel = 0
	picture.ImageTransparency = tonumber(imageconfig.Transparency) or 0
	picture.ImageColor3 = typeof(imageconfig.Color) == "Color3" and imageconfig.Color or Color3.new(1, 1, 1)
	local corner = instance.uicorner(picture)
	corner.CornerRadius = UDim.new(0, tonumber(imageconfig.CornerRadius) or 6)
	local ratio = instance.uiaspectratioconstraint(picture)
	ratio.AspectType = Enum.AspectType.FitWithinMaxSize
	ratio.DominantAxis = Enum.DominantAxis.Height

	local state = {
		Width = tonumber(imageconfig.Width),
		Align = tostring(imageconfig.Align or "center"):lower(),
	}

	local function layout()
		local width = state.Width
		picture.Size = width and UDim2.new(0, width, 1, 0) or UDim2.new(1, 0, 1, 0)
		local alignx = state.Align == "left" and 0 or (state.Align == "right" and 1 or 0.5)
		picture.AnchorPoint = Vector2.new(alignx, 0.5)
		picture.Position = UDim2.new(alignx, 0, 0.5, 0)
	end

	local function setfit(mode)
		picture.ScaleType = fittypes[tostring(mode or "contain"):lower()] or Enum.ScaleType.Fit
	end

	local function setratio(value)
		local number = tonumber(value)
		ratio.Enabled = number ~= nil and number > 0
		if ratio.Enabled then
			ratio.AspectRatio = number
		end
	end

	setfit(imageconfig.Fit)
	setratio(imageconfig.AspectRatio)
	layout()
	applyicon(picture, imageconfig.Image or imageconfig.Icon, 512)

	registerSearchItem(tostring(imageconfig.Title or "Image"), holder, "Image")
	countitem = countitem + 1
	yieldbuild()

	local imagefunc = { Instance = picture }
	function imagefunc:SetImage(value)
		applyicon(picture, value, 512)
	end
	function imagefunc:SetIcon(value)
		applyicon(picture, value, 512)
	end
	function imagefunc:SetColor(color)
		if typeof(color) == "Color3" then
			picture.ImageColor3 = color
		end
	end
	function imagefunc:SetTransparency(value)
		picture.ImageTransparency = math.clamp(tonumber(value) or 0, 0, 1)
	end
	function imagefunc:SetFit(mode)
		setfit(mode)
	end
	function imagefunc:SetAspectRatio(value)
		setratio(value)
	end
	function imagefunc:SetSize(width, height)
		state.Width = tonumber(width)
		if tonumber(height) then
			holder.Size = UDim2.new(1, 0, 0, tonumber(height))
		end
		layout()
	end
	return imagefunc
end
