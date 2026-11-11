local guifunc = {}
getgenv().MXHUB_Instance = guifunc
local mxhubui = instance.screengui(sv.coregui)
mxhubui.Name = "MXHUBUI"
mxhubui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mxhubui.ResetOnSpawn = false

if guiconfig.Watermark ~= false then
	pcall(function()
		guifunc.Watermark = MXHUB:Watermark({
			Title = "MX HUB",
			Logo = guiconfig.WatermarkLogo or userPassedToggle or assets.LogoId,
			ShowTime = guiconfig.WatermarkTime,
			ShowFPS = guiconfig.WatermarkFPS,
			ShowPing = guiconfig.WatermarkPing,
		})
	end)
end

