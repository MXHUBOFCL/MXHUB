local fpsmeter = { value = 60 }

do
	local frames, last, started = 0, os.clock(), false
	function fpsmeter.start()
		if started then
			return
		end
		started = true
		trackConnection(
			game:GetService("RunService").RenderStepped:Connect(function()
				frames += 1
				local now = os.clock()
				if now - last >= 0.5 then
					fpsmeter.value = math.floor(frames / (now - last) + 0.5)
					frames, last = 0, now
				end
			end),
			"fps-meter"
		)
	end
end
