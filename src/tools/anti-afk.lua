local afkconnection

function MXHUB.AntiAfk(state)
	if afkconnection then
		afkconnection:Disconnect()
		afkconnection = nil
	end
	local localplayer = sv.plrs.LocalPlayer
	if state == true and localplayer then
		afkconnection = localplayer.Idled:Connect(function()
			pcall(function()
				local virtualuser = game:GetService("VirtualUser")
				virtualuser:CaptureController()
				virtualuser:ClickButton2(Vector2.new())
			end)
		end)
	end
end
