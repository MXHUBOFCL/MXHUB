if type(getgenv) ~= "function" then
	getgenv = function()
		return _G
	end
end

local sv = {
	http = game:GetService("HttpService"),
	uis = game:GetService("UserInputService"),
	ts = game:GetService("TweenService"),
	plrs = game:GetService("Players"),
	coregui = game:GetService("CoreGui"),
	sg = game:GetService("StarterGui"),
	textservice = game:GetService("TextService"),
}

