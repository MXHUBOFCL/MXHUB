dropshadowholder.Size = UDim2.new(0, 115 + textlabel.TextBounds.X + 1 + textlabel1.TextBounds.X, 0, 350)
if isMobile then
	draggable.mobilex = math.max(420, tonumber(guiconfig.MobileWidth) or draggable.mobilex)
	draggable.mobiley = math.max(260, tonumber(guiconfig.MobileHeight) or draggable.mobiley)
else

	draggable.defx = math.max(420, tonumber(guiconfig.Width) or draggable.defx)
	draggable.defy = math.max(260, tonumber(guiconfig.Height) or draggable.defy)
end
makedraggable(top, dropshadowholder)

