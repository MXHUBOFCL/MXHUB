do
	local lighting = game:GetService("Lighting")
	local boost = {
		on = false,
		saved = setmetatable({}, { __mode = "k" }),
		connection = nil,
		token = 0,
		quality = nil,
		shadows = nil,
	}

	local function save(inst, props)
		if boost.saved[inst] then
			return
		end
		local data = {}
		for _, prop in ipairs(props) do
			data[prop] = inst[prop]
		end
		boost.saved[inst] = data
	end

	local function reduce(inst)
		if inst:IsA("Terrain") then
			return
		end
		if inst:IsA("BasePart") then
			save(inst, { "Material", "Reflectance", "CastShadow" })
			inst.Material = Enum.Material.SmoothPlastic
			inst.Reflectance = 0
			inst.CastShadow = false
		elseif inst:IsA("Decal") or inst:IsA("Texture") then
			save(inst, { "Transparency" })
			inst.Transparency = 1
		elseif
			inst:IsA("ParticleEmitter")
			or inst:IsA("Trail")
			or inst:IsA("Beam")
			or inst:IsA("Smoke")
			or inst:IsA("Fire")
			or inst:IsA("Sparkles")
			or inst:IsA("PostEffect")
		then
			save(inst, { "Enabled" })
			inst.Enabled = false
		end
	end

	local function restore(saved, token)
		local count = 0
		for inst, data in pairs(saved) do
			if boost.token ~= token then
				break
			end
			pcall(function()
				for prop, value in pairs(data) do
					inst[prop] = value
				end
			end)
			count += 1
			if count % 400 == 0 then
				task.wait()
			end
		end
	end

	function MXHUB.FpsBoost(state)
		state = state == true
		if boost.on == state then
			return
		end
		boost.on = state
		boost.token += 1
		local token = boost.token

		if state then
			pcall(function()
				boost.shadows = lighting.GlobalShadows
				lighting.GlobalShadows = false
			end)
			pcall(function()
				boost.quality = settings().Rendering.QualityLevel
				settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
			end)
			boost.connection = workspace.DescendantAdded:Connect(function(inst)
				if boost.on then
					pcall(reduce, inst)
				end
			end)
			for _, inst in ipairs(lighting:GetChildren()) do
				pcall(reduce, inst)
			end
			task.spawn(function()
				local list = workspace:GetDescendants()
				for index, inst in ipairs(list) do
					if boost.token ~= token then
						return
					end
					pcall(reduce, inst)
					if index % 400 == 0 then
						task.wait()
					end
				end
			end)
			return
		end

		if boost.connection then
			boost.connection:Disconnect()
			boost.connection = nil
		end
		pcall(function()
			if boost.shadows ~= nil then
				lighting.GlobalShadows = boost.shadows
			end
			if boost.quality ~= nil then
				settings().Rendering.QualityLevel = boost.quality
			end
		end)
		local saved = boost.saved
		boost.saved = setmetatable({}, { __mode = "k" })
		task.spawn(restore, saved, token)
	end
end
