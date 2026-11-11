local layerstab = instance.frame(main)
layerstab.Name = "LayersTab"
layerstab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
layerstab.BackgroundTransparency = 1
layerstab.BorderColor3 = Color3.fromRGB(0, 0, 0)
layerstab.BorderSizePixel = 0
layerstab.Position = UDim2.new(0, 3, 0, 50)
layerstab.Size = UDim2.new(0, guiconfig["Tab Width"], 1, -112)

local uicorner2 = instance.uicorner(layerstab)
uicorner2.CornerRadius = UDim.new(0, 2)

local decideframe = instance.frame(main)
decideframe.Name = "DecideFrame"
decideframe.AnchorPoint = Vector2.new(0.5, 0)
decideframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
decideframe.BackgroundTransparency = 0.85
decideframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
decideframe.BorderSizePixel = 0
decideframe.Position = UDim2.new(0.5, 0, 0, 38)
decideframe.Size = UDim2.new(1, 0, 0, 1)

local decidesaparator = instance.frame(layerstab)
decidesaparator.Name = "DecideSaparator"
decidesaparator.AnchorPoint = Vector2.new(1, 0)
decidesaparator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
decidesaparator.BackgroundTransparency = 0.85
decidesaparator.BorderColor3 = Color3.fromRGB(0, 0, 0)
decidesaparator.BorderSizePixel = 0
decidesaparator.Position = UDim2.new(1, 3, 0, -11)
decidesaparator.Size = UDim2.new(0, 1, 1, 73)
decidesaparator.Rotation = 0

local layers = instance.frame(main)
layers.Name = "Layers"
layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
layers.BackgroundTransparency = 1
layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
layers.BorderSizePixel = 0
layers.Position = UDim2.new(0, guiconfig["Tab Width"] + 13, 0, 40)
layers.Size = UDim2.new(1, -(guiconfig["Tab Width"] + 20), 1, -50)

local uicorner6 = instance.uicorner(layers)
uicorner6.CornerRadius = UDim.new(0, 2)

local layersreal = instance.frame(layers)
layersreal.Name = "LayersReal"
layersreal.AnchorPoint = Vector2.new(0, 1)
layersreal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
layersreal.BackgroundTransparency = 1
layersreal.BorderColor3 = Color3.fromRGB(0, 0, 0)
layersreal.BorderSizePixel = 0
layersreal.ClipsDescendants = true
layersreal.Position = UDim2.new(0, 0, 1, 0)
layersreal.Size = UDim2.new(1, 0, 1, 0)

local layersfolder = instance.folder(layersreal)
layersfolder.Name = "LayersFolder"

local layerspagelayout = instance.uipagelayout(layersfolder)
layerspagelayout.Name = "LayersPageLayout"
layerspagelayout.SortOrder = Enum.SortOrder.LayoutOrder
layerspagelayout.TweenTime = 0
layerspagelayout.EasingDirection = Enum.EasingDirection.InOut
layerspagelayout.EasingStyle = Enum.EasingStyle.Quad
layerspagelayout.GamepadInputEnabled = false
layerspagelayout.ScrollWheelInputEnabled = false
layerspagelayout.TouchInputEnabled = false

local scrolltab = instance.scrollingframe(layerstab)
scrolltab.Name = "ScrollTab"
scrolltab.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolltab.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
scrolltab.ScrollBarThickness = 0
scrolltab.Active = true
scrolltab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scrolltab.BackgroundTransparency = 1
scrolltab.BorderColor3 = Color3.fromRGB(0, 0, 0)
scrolltab.BorderSizePixel = 0
scrolltab.Size = UDim2.new(1, 0, 1, 0)

local uilistlayout = instance.uilistlayout(scrolltab)
uilistlayout.Padding = UDim.new(0, 1)
uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

local scrolltabpad = instance.uipadding(scrolltab)
scrolltabpad.PaddingTop = UDim.new(0, 4)
scrolltabpad.PaddingLeft = UDim.new(0, 6)
scrolltabpad.PaddingRight = UDim.new(0, 6)

local function updatesize1()
	scrolltab.CanvasSize = UDim2.new(0, 0, 0, math.ceil(uilistlayout.AbsoluteContentSize.Y / fitscaleof(scrolltab)) + 8)
end

trackConnection(
	uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		debounceResize("tabscroll_resize", updatesize1, 0.05)
	end),
	"tabscroll.propertychanged"
)
updatesize1()

