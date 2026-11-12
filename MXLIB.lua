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

local assets = {
	Logo = "rbxassetid://80269995911245",
	LogoId = "80269995911245",
	Slice = "rbxassetid://3570695787",
	Discord = "rbxassetid://127606113874611",
}
local theme = {
	Accent = Color3.fromRGB(245, 247, 252),
	AccentText = Color3.fromRGB(14, 16, 22),
	Backdrop = Color3.fromRGB(20, 22, 27),
	Sidebar = Color3.fromRGB(14, 16, 21),
	Card = Color3.fromRGB(25, 27, 33),
	Element = Color3.fromRGB(27, 30, 38),
	ElementHover = Color3.fromRGB(34, 37, 47),
	Track = Color3.fromRGB(44, 48, 62),
	Stroke = Color3.fromRGB(42, 45, 57),
	StrokeSoft = Color3.fromRGB(31, 34, 43),
	Text = Color3.fromRGB(232, 236, 244),
	SubText = Color3.fromRGB(150, 156, 172),
	Dim = Color3.fromRGB(112, 119, 138),
	Good = Color3.fromRGB(72, 205, 141),
	Bad = Color3.fromRGB(238, 92, 100),
	Gold = Color3.fromRGB(240, 178, 78),
	Blue = Color3.fromRGB(96, 165, 250),
	Row = Color3.fromRGB(24, 26, 32),
	Header = Color3.fromRGB(23, 25, 31),
	Inner = Color3.fromRGB(27, 30, 38),
	InnerHover = Color3.fromRGB(35, 38, 48),
	Field = Color3.fromRGB(17, 19, 25),
	Bar = Color3.fromRGB(56, 61, 80),
	Pill = Color3.fromRGB(22, 24, 30),
	TabActive = Color3.fromRGB(33, 36, 46),
	Option = Color3.fromRGB(19, 21, 27),
	ChatBg = Color3.fromRGB(15, 17, 23),
	Mine = Color3.fromRGB(29, 32, 42),
	Mention = Color3.fromRGB(38, 33, 22),
	Box = Color3.fromRGB(15, 17, 23),
	Radius = { window = 12, card = 10, control = 8, chip = 6, tile = 7 },
	Gutter = 14,
	ToggleOn = Color3.fromRGB(245, 247, 252),
	ToggleOff = Color3.fromRGB(27, 30, 38),
	ToggleOffStroke = Color3.fromRGB(50, 56, 74),
	OffText = Color3.fromRGB(118, 125, 144),
	KnobOff = Color3.fromRGB(136, 144, 166),
	SliderFill = Color3.fromRGB(245, 247, 252),
	KnobOn = Color3.fromRGB(22, 24, 30),
	Current = "MX HUB",
}

local presets = {
	{ "MX HUB", Color3.fromRGB(20, 22, 27), Color3.fromRGB(245, 247, 252), true },
	{ "Emerald", Color3.fromRGB(18, 18, 18), Color3.fromRGB(30, 215, 96) },
	{ "Indigo", Color3.fromRGB(30, 31, 34), Color3.fromRGB(88, 101, 242) },
	{ "Midnight Purple", Color3.fromRGB(12, 9, 22), Color3.fromRGB(139, 92, 246) },
	{ "Crimson", Color3.fromRGB(16, 8, 9), Color3.fromRGB(239, 68, 68) },
	{ "Ocean", Color3.fromRGB(6, 14, 20), Color3.fromRGB(34, 211, 238) },
	{ "Sakura", Color3.fromRGB(20, 10, 16), Color3.fromRGB(244, 114, 182) },
	{ "Sunset", Color3.fromRGB(18, 10, 6), Color3.fromRGB(249, 115, 22) },
	{ "Mono", Color3.fromRGB(10, 10, 10), Color3.fromRGB(225, 225, 225) },
	{ "Cobalt", Color3.fromRGB(7, 12, 26), Color3.fromRGB(56, 128, 255) },
	{ "Ember", Color3.fromRGB(17, 9, 7), Color3.fromRGB(255, 94, 43) },
}
local accents = {
	{ "Blue", Color3.fromRGB(77, 125, 255) },
	{ "Purple", Color3.fromRGB(139, 92, 246) },
	{ "Red", Color3.fromRGB(239, 68, 68) },
	{ "Green", Color3.fromRGB(34, 197, 94) },
	{ "Cyan", Color3.fromRGB(34, 211, 238) },
	{ "Orange", Color3.fromRGB(249, 115, 22) },
}
do
	local white, black = Color3.new(1, 1, 1), Color3.new(0, 0, 0)
	local basetheme = {}
	for key, value in pairs(theme) do
		if typeof(value) == "Color3" then
			basetheme[key] = value
		end
	end

	local LIGHTBG = Color3.fromRGB(243, 244, 248)

	local darktext, lighttext = Color3.fromRGB(14, 14, 17), Color3.fromRGB(255, 255, 253)

	local function luminance(color)
		local function linear(value)
			return value <= 0.03928 and value / 12.92 or ((value + 0.055) / 1.055) ^ 2.4
		end
		return 0.2126 * linear(color.R) + 0.7152 * linear(color.G) + 0.0722 * linear(color.B)
	end

	local function paintaccent(out, accent)
		local lum = luminance(accent)
		local overdark = (lum + 0.05) / (luminance(darktext) + 0.05)
		local overlight = (luminance(lighttext) + 0.05) / (lum + 0.05)
		local usedark = overdark >= overlight
		out.Accent = accent
		out.AccentText = usedark and darktext or lighttext
		out.ToggleOn = accent
		out.KnobOn = usedark and Color3.fromRGB(24, 26, 32) or Color3.fromRGB(254, 255, 255)
		out.SliderFill = accent
	end

	local function derive(bg, accent, light)
		local out
		if light then
			local function dn(amount)
				return bg:Lerp(black, amount)
			end
			local card = bg:Lerp(white, 0.6)
			out = {
				Backdrop = bg,
				Sidebar = dn(0.03),
				Card = card,
				Row = bg:Lerp(white, 0.5),
				Header = dn(0.045),
				Element = dn(0.03),
				Field = Color3.fromRGB(253, 253, 255),
				Inner = dn(0.03),
				Pill = card,
				TabActive = dn(0.075),
				Option = dn(0.02),
				ElementHover = dn(0.07),
				InnerHover = dn(0.07),
				Track = dn(0.11),
				Stroke = dn(0.1),
				StrokeSoft = dn(0.06),
				Bar = dn(0.2),
				ChatBg = card,
				Box = card,
				Mine = dn(0.06),
				Text = Color3.fromRGB(20, 22, 30),
				SubText = Color3.fromRGB(92, 98, 115),
				Dim = Color3.fromRGB(108, 114, 130),
				ToggleOff = dn(0.11),
				ToggleOffStroke = dn(0.2),
				OffText = Color3.fromRGB(120, 126, 145),
				KnobOff = Color3.fromRGB(255, 255, 251),
				KnobOn = Color3.fromRGB(254, 255, 255),
				SliderFill = Color3.fromRGB(40, 44, 58),
			}
		else
			local function up(amount)
				return bg:Lerp(white, amount)
			end
			out = {
				Backdrop = bg,
				Sidebar = bg:Lerp(black, 0.3),
				Card = up(0.04),
				Row = up(0.03),
				Header = up(0.06),
				Element = up(0.07),
				Field = up(0.06),
				Inner = up(0.07),
				Pill = up(0.05),
				TabActive = up(0.09),
				Option = up(0.05),
				ElementHover = up(0.11),
				InnerHover = up(0.12),
				Track = up(0.14),
				Stroke = up(0.12),
				StrokeSoft = up(0.07),
				Bar = up(0.2),
				ChatBg = up(0.03),
				Box = up(0.03),
				Mine = up(0.1),
				Text = basetheme.Text,
				SubText = basetheme.SubText,
				Dim = basetheme.Dim,
				ToggleOff = up(0.08),
				ToggleOffStroke = up(0.17),
				OffText = bg:Lerp(white, 0.45),
				KnobOff = bg:Lerp(white, 0.5),
				KnobOn = basetheme.KnobOn,
				SliderFill = basetheme.SliderFill,
			}
		end
		paintaccent(out, accent)
		return out
	end

	local themefile = "MX HUB/theme.json"
	theme.State = { Preset = "MX HUB", Accent = nil, Mode = "Dark" }

	local function find(name)
		local wanted = tostring(name or ""):lower()
		for _, preset in ipairs(presets) do
			if preset[1]:lower() == wanted then
				return preset
			end
		end
		return nil
	end

	local function parsehex(text)
		text = tostring(text or ""):gsub("%s", ""):gsub("^#", "")
		if #text == 8 then
			text = text:sub(1, 6)
		end
		if #text == 6 and text:match("^%x+$") then
			return Color3.fromRGB(tonumber(text:sub(1, 2), 16), tonumber(text:sub(3, 4), 16), tonumber(text:sub(5, 6), 16))
		end
		return nil
	end

	local function hex6(color)
		return string.format("%02X%02X%02X", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	end

	local function colorkey(color)
		return string.format("%d,%d,%d", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	end

	local function compose()
		local state = theme.State
		local preset = find(state.Preset) or presets[1]
		local accent = state.Accent or preset[3]
		if state.Mode == "Light" then
			return derive(LIGHTBG, accent, true)
		end
		if preset[4] then
			local out = {}
			for key, value in pairs(basetheme) do
				out[key] = value
			end
			paintaccent(out, accent)
			return out
		end
		return derive(preset[2], accent, false)
	end

	local function recolor(old)
		local map, any = {}, false
		for key, oldcolor in pairs(old) do
			local newcolor = theme[key]
			if typeof(newcolor) == "Color3" then
				local oldkey = colorkey(oldcolor)
				if oldkey ~= colorkey(newcolor) and map[oldkey] == nil then
					map[oldkey] = newcolor
					any = true
				end
			end
		end
		if not any then
			return
		end
		local function fix(inst, prop)
			local ok, current = pcall(function()
				return inst[prop]
			end)
			if ok and typeof(current) == "Color3" then
				local replacement = map[colorkey(current)]
				if replacement then
					inst[prop] = replacement
				end
			end
		end
		for _, name in ipairs({ "MXHUBUI", "ToggleUIButton", "PopupGui", "MXHUBWatermark" }) do
			local root = sv.coregui:FindFirstChild(name)
			if root then
				for _, d in ipairs(root:GetDescendants()) do
					if d:IsA("GuiObject") then
						fix(d, "BackgroundColor3")
						if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
							fix(d, "TextColor3")
						end
						if d:IsA("TextBox") then
							fix(d, "PlaceholderColor3")
						end
						if d:IsA("ImageLabel") or d:IsA("ImageButton") then
							fix(d, "ImageColor3")
						end
						if d:IsA("ScrollingFrame") then
							fix(d, "ScrollBarImageColor3")
						end
					elseif d:IsA("UIStroke") then
						fix(d, "Color")
					end
				end
			end
		end
	end

	local function persist()
		pcall(function()
			if type(writefile) ~= "function" then
				return
			end
			if type(isfolder) == "function" and not isfolder("MX HUB") then
				makefolder("MX HUB")
			end
			local state = theme.State
			writefile(themefile, sv.http:JSONEncode({
				preset = state.Preset,
				accent = state.Accent and hex6(state.Accent) or nil,
				mode = state.Mode,
			}))
		end)
	end

	theme.Api = {}

	function theme.Api.Names()
		local names = {}
		for _, preset in ipairs(presets) do
			names[#names + 1] = preset[1]
		end
		return names
	end

	function theme.Api.Accents()
		return accents
	end

	function theme.Api.ParseHex(text)
		return parsehex(text)
	end

	-- patch: { Preset = "Emerald", Accent = Color3 | false (clear), Mode = "Dark" | "Light" }
	function theme.Api.Set(patch, nosave)
		patch = patch or {}
		local state = theme.State
		if patch.Preset ~= nil then
			if not find(patch.Preset) then
				return false, "Unknown theme"
			end
			state.Preset = find(patch.Preset)[1]
		end
		if patch.Accent == false then
			state.Accent = nil
		elseif typeof(patch.Accent) == "Color3" then
			state.Accent = patch.Accent
		end
		if patch.Mode == "Dark" or patch.Mode == "Light" then
			state.Mode = patch.Mode
		end

		local old = {}
		for key, value in pairs(theme) do
			if typeof(value) == "Color3" then
				old[key] = value
			end
		end
		for key, value in pairs(compose()) do
			theme[key] = value
		end
		theme.Current = state.Preset
		local ok, err = pcall(recolor, old)
		if not ok then
			warn("[MX HUB] Theme recolor failed: " .. tostring(err))
		end
		if not nosave then
			persist()
		end
		return true, "Theme applied: " .. tostring(state.Preset) .. " / " .. tostring(state.Mode)
	end

	-- load the saved theme before any UI is built
	pcall(function()
		if type(isfile) ~= "function" or type(readfile) ~= "function" or not isfile(themefile) then
			return
		end
		local data = sv.http:JSONDecode(readfile(themefile))
		if type(data) ~= "table" then
			return
		end
		theme.Api.Set({
			Preset = type(data.preset) == "string" and find(data.preset) and data.preset or nil,
			Accent = type(data.accent) == "string" and parsehex(data.accent) or nil,
			Mode = data.mode,
		}, true)
	end)
end

local function elevate()
	local setfn = (type(setthreadidentity) == "function" and setthreadidentity)
		or (type(set_thread_identity) == "function" and set_thread_identity)
		or (type(setidentity) == "function" and setidentity)
		or (type(setthreadcontext) == "function" and setthreadcontext)
		or (type(set_thread_context) == "function" and set_thread_context)
		or (type(syn) == "table" and type(syn.set_thread_identity) == "function" and syn.set_thread_identity)
	if setfn then
		pcall(setfn, 8)
	end
end

local function hexcolor(color)
	return string.format(
		"#%02X%02X%02X",
		math.floor(color.R * 255 + 0.5),
		math.floor(color.G * 255 + 0.5),
		math.floor(color.B * 255 + 0.5)
	)
end

local function textheight(text, size, font, width, maxheight)
	local ok, bounds = pcall(function()
		return sv.textservice:GetTextSize(tostring(text or ""), size, font, Vector2.new(math.max(20, width), 100000))
	end)
	if ok and bounds and bounds.Y > 0 then
		return math.min(maxheight or 100000, math.ceil(bounds.Y) + 2)
	end
	return size
end

local function escaperich(text)
	return (tostring(text or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function clipboardwrite(text)
	local fn = setclipboard or toclipboard or set_clipboard or writeclipboard
	if type(fn) ~= "function" and type(Clipboard) == "table" then
		fn = Clipboard.set
	end
	if type(fn) ~= "function" then
		return false
	end
	return (pcall(fn, tostring(text)))
end

local iconaliases = {
	main = { "home", "house" },
	home = { "home", "house" },
	config = "settings",
	settings = "settings",
	player = "user",
	visual = "eye",
	esp = { "scan-eye", "eye" },
	info = "info",
	close = "x",
	search = "search",
	copy = "copy",
	lock = "lock",
	players = "users",
	next = "chevron-right",
	back = "chevron-left",
	prev = "chevron-left",
	up = "chevron-up",
	down = "chevron-down",
	left = "chevron-left",
	right = "chevron-right",
	house = { "home", "house" },
	menu = "menu",
	dashboard = "layout-dashboard",
	misc = "layout-grid",
	other = "layout-grid",
	more = "ellipsis",
	list = "list",
	layers = "layers",
	setting = "settings",
	gear = "settings",
	cog = "settings",
	options = "sliders-horizontal",
	preferences = "sliders-horizontal",
	tweaks = "sliders-horizontal",
	toggle = "toggle-right",
	power = "power",
	help = { "help-circle", "circle-help" },
	question = { "help-circle", "circle-help" },
	warning = { "alert-triangle", "triangle-alert" },
	warn = { "alert-triangle", "triangle-alert" },
	alert = { "alert-triangle", "triangle-alert" },
	error = { "alert-circle", "circle-alert" },
	success = "check",
	ok = "check",
	check = "check",
	done = "check",
	x = "x",
	add = "plus",
	plus = "plus",
	remove = "minus",
	minus = "minus",
	delete = "trash-2",
	trash = "trash-2",
	edit = "pencil",
	rename = "pencil",
	paste = "clipboard",
	save = "save",
	load = "download",
	download = "download",
	upload = "upload",
	reload = "refresh-cw",
	reset = { "rotate-ccw", "undo-2" },
	undo = "undo-2",
	redo = "redo-2",
	link = "link",
	external = "external-link",
	share = "share-2",
	find = "search",
	filter = "filter",
	sort = "arrow-up-down",
	unlock = "unlock",
	keyround = { "key-round", "key" },
	keybind = "keyboard",
	keyboard = "keyboard",
	license = { "badge-check", "check-circle" },
	verified = { "badge-check", "check-circle" },
	verify = { "badge-check", "check-circle" },
	shield = "shield",
	protect = "shield",
	security = "shield",
	safe = "shield",
	god = "shield-check",
	godmode = "shield-check",
	admin = "shield-check",
	antiban = "shield-alert",
	anticheat = "shield-alert",
	fingerprint = "fingerprint",
	account = { "user-circle", "circle-user" },
	profile = { "user-circle", "circle-user" },
	owner = "crown",
	donator = "crown",
	premium = "crown",
	vip = "crown",
	chat = "message-circle",
	message = "send",
	send = "send",
	forum = "messages-square",
	community = "messages-square",
	announce = "megaphone",
	megaphone = "megaphone",
	bell = "bell",
	notify = "bell",
	notification = "bell",
	mail = "mail",
	email = "mail",
	phone = "phone",
	heart = "heart",
	like = "heart",
	favorite = "star",
	star = "star",
	farm = "sprout",
	grow = "sprout",
	plant = "sprout",
	seed = "sprout",
	harvest = "sprout",
	crop = "sprout",
	water = "droplet",
	tractor = "tractor",
	food = "carrot",
	vegetable = "carrot",
	fruit = "apple",
	cook = "chef-hat",
	coffee = "coffee",
	fishing = "fish",
	fish = "fish",
	egg = "egg",
	eggs = "egg",
	pet = "paw-print",
	pets = "paw-print",
	auto = "repeat",
	automation = "repeat",
	loop = "repeat",
	shop = "shopping-cart",
	cart = "shopping-cart",
	store = "store",
	market = "store",
	bag = "backpack",
	inventory = "backpack",
	backpack = "backpack",
	money = "coins",
	cash = "coins",
	coin = "coins",
	coins = "coins",
	bank = "banknote",
	wallet = "wallet",
	gem = "gem",
	gems = "gem",
	diamond = "gem",
	credit = "credit-card",
	card = "credit-card",
	payment = "credit-card",
	gift = "gift",
	reward = "gift",
	rewards = "gift",
	redeem = "gift",
	chest = "package",
	crate = "package",
	loot = "package",
	drop = "package",
	drops = "package",
	box = "package",
	boxes = "boxes",
	trophy = "trophy",
	win = "trophy",
	leaderboard = "trophy",
	rank = "trophy",
	medal = "medal",
	achievement = "medal",
	achievements = "medal",
	award = "award",
	combat = "swords",
	fight = "swords",
	pvp = "swords",
	attack = "swords",
	weapon = "sword",
	sword = "sword",
	melee = "sword",
	gun = "crosshair",
	shoot = "crosshair",
	shooter = "crosshair",
	aim = "crosshair",
	aimbot = "crosshair",
	silentaim = "crosshair",
	crosshair = "crosshair",
	target = "target",
	bomb = "bomb",
	kill = "skull",
	killaura = "skull",
	skull = "skull",
	death = "skull",
	enemy = { "skull", "ghost" },
	monster = { "skull", "ghost" },
	boss = { "skull", "ghost" },
	mob = { "skull", "ghost" },
	health = "heart-pulse",
	hp = "heart-pulse",
	heal = "heart-pulse",
	regen = "heart-pulse",
	armor = "shield",
	defense = "shield",
	radar = "radar",
	minimap = "radar",
	scan = "scan",
	scanner = "scan",
	detect = "scan-line",
	speed = "gauge",
	fast = "gauge",
	walkspeed = "gauge",
	performance = "gauge",
	fps = "gauge",
	jump = "chevrons-up",
	jumppower = "chevrons-up",
	highjump = "chevrons-up",
	fly = "plane",
	flight = "plane",
	noclip = "ghost",
	ghost = "ghost",
	run = "footprints",
	sprint = "footprints",
	walk = "footprints",
	swim = "waves",
	climb = "mountain",
	infinite = "infinity",
	inf = "infinity",
	teleport = "map-pin",
	tp = "map-pin",
	location = "map-pin",
	waypoint = "map-pin",
	map = "map",
	navigate = "navigation",
	navigation = "navigation",
	compass = "compass",
	world = "globe",
	globe = "globe",
	hop = "shuffle",
	serverhop = "shuffle",
	rejoin = "log-in",
	join = "log-in",
	login = "log-in",
	leave = "log-out",
	quit = "log-out",
	logout = "log-out",
	visuals = "eye",
	wallhack = "eye",
	view = "eye",
	hide = "eye-off",
	color = "palette",
	colour = "palette",
	theme = "palette",
	palette = "palette",
	light = "sun",
	lighting = "sun",
	brightness = "sun",
	fullbright = "sun",
	dark = "moon",
	afk = "moon",
	night = "moon",
	fog = "cloud-fog",
	weather = "cloud-sun",
	sky = "cloud",
	camera = "camera",
	cam = "camera",
	freecam = "camera",
	fov = { "aperture", "zoom-in" },
	zoom = "zoom-in",
	video = "video",
	record = "video",
	image = "image",
	photo = "image",
	texture = "image",
	fx = "sparkles",
	effects = "sparkles",
	particles = "sparkles",
	sparkle = "sparkles",
	magic = { "wand-sparkles", "wand-2", "wand" },
	wand = { "wand-sparkles", "wand-2", "wand" },
	fire = "flame",
	flame = "flame",
	ice = "snowflake",
	snow = "snowflake",
	wind = "wind",
	lightning = "zap",
	thunder = "zap",
	zap = "zap",
	music = "music",
	audio = "volume-2",
	sound = "volume-2",
	volume = "volume-2",
	mute = "volume-x",
	mic = "mic",
	headphones = "headphones",
	tool = "wrench",
	tools = "wrench",
	build = "wrench",
	builder = "wrench",
	hammer = "hammer",
	craft = "hammer",
	crafting = "hammer",
	pickaxe = "pickaxe",
	mine = "pickaxe",
	mining = "pickaxe",
	axe = "axe",
	chop = "axe",
	wood = "axe",
	magnet = "magnet",
	collect = "magnet",
	grab = "magnet",
	autocollect = "magnet",
	mouse = "mouse-pointer-click",
	click = "mouse-pointer-click",
	autoclick = "mouse-pointer-click",
	clicker = "mouse-pointer-click",
	cursor = "mouse-pointer-2",
	game = "gamepad-2",
	games = "gamepad-2",
	gamepad = "gamepad-2",
	joystick = "joystick",
	dice = "dices",
	roll = "dices",
	random = "dices",
	luck = "dices",
	gamble = "dices",
	puzzle = "puzzle",
	rocket = "rocket",
	boost = "rocket",
	launch = "rocket",
	ship = "ship",
	boat = "ship",
	car = "car",
	vehicle = "car",
	drive = "car",
	bike = "bike",
	bot = "bot",
	npc = "bot",
	ai = "bot",
	robot = "bot",
	quest = "scroll",
	quests = "scroll",
	mission = "scroll",
	tasks = "list-checks",
	todo = "list-checks",
	checklist = "list-checks",
	event = "calendar",
	events = "calendar",
	calendar = "calendar",
	time = "clock",
	clock = "clock",
	timer = "timer",
	cooldown = "timer",
	hourglass = "hourglass",
	wait = "hourglass",
	stat = { "bar-chart-3", "chart-column", "bar-chart" },
	stats = { "bar-chart-3", "chart-column", "bar-chart" },
	statistics = { "bar-chart-3", "chart-column", "bar-chart" },
	analytics = { "bar-chart-3", "chart-column", "bar-chart" },
	chart = { "line-chart", "chart-line" },
	graph = { "line-chart", "chart-line" },
	pie = { "pie-chart", "chart-pie" },
	activity = "activity",
	status = "activity",
	ping = "wifi",
	latency = "wifi",
	lag = "wifi",
	wifi = "wifi",
	network = "wifi",
	server = "server",
	database = "database",
	data = "database",
	cpu = "cpu",
	ram = "memory-stick",
	memory = "memory-stick",
	battery = "battery",
	code = "code",
	script = "code",
	terminal = "terminal",
	console = "terminal",
	bug = "bug",
	debug = "bug",
	webhook = "webhook",
	api = "webhook",
	folder = "folder",
	file = "file",
	book = "book-open",
	guide = "book-open",
	tutorial = "book-open",
	docs = "book-open",
	note = "sticky-note",
	notes = "sticky-note",
	bookmark = "bookmark",
	hash = "hash",
	flag = "flag",
	pin = "pin",
	text = "type",
	font = "type",
	idea = "lightbulb",
	tip = "lightbulb",
	lightbulb = "lightbulb",
	play = "play",
	tt = "tiktok",
	strip = "min",
	["alert-triangle"] = "triangle-alert",
	banned = "ban",
	yt = "youtube",
	ig = "instagram",
	fb = "facebook",
	tg = "telegram",
	wa = "whatsapp",
	gh = "github",
	tw = "twitter",
	snap = "snapchat",
	rbx = "roblox",
	refresh = "refresh-cw",
	key = "key",
	exit = "log-out",
	hand = "hand",
	tag = "tag",
}
local iconfallbackdata = {
	["home"] = "rbxassetid://6340513838",
	["menu"] = "rbxassetid://6340513838",
	["settings"] = "rbxassetid://70386228443175",
	["cog"] = "rbxassetid://70386228443175",
	["eye"] = "rbxassetid://14321059114",
	["user"] = "rbxassetid://108483430622128",
	["users"] = "rbxassetid://12120698352",
	["shopping-cart"] = "rbxassetid://128874923961846",
	["store"] = "rbxassetid://4985385964",
	["backpack"] = "rbxassetid://8601111810",
	["sword"] = "rbxassetid://82472368671405",
	["swords"] = "rbxassetid://82472368671405",
	["repeat"] = "rbxassetid://122032243989747",
	["refresh-cw"] = "rbxassetid://122032243989747",
	["map-pin"] = "rbxassetid://17824309485",
	["compass"] = "rbxassetid://125300760963399",
	["gamepad-2"] = "rbxassetid://84173963561612",
	["scroll"] = "rbxassetid://114127804740858",
	["crosshair"] = "rbxassetid://12614416478",
	["bar-chart"] = "rbxassetid://12094445329",
	["activity"] = "rbxassetid://12094445329",
	["star"] = "rbxassetid://107005941750079",
	["skull"] = "rbxassetid://17313330026",
	["credit-card"] = "rbxassetid://18747025078",
	["scan"] = "rbxassetid://109869955247116",
	["search"] = "rbxassetid://8447654914",
	["alert-triangle"] = "rbxassetid://73186275216515",
	["help-circle"] = "rbxassetid://17510196486",
	["lightbulb"] = "rbxassetid://16833255748",
	["info"] = "rbxassetid://16833255748",
	["messages-square"] = "rbxassetid://12120698352",
	["zap"] = "rbxassetid://13321880293",
	["droplet"] = "rbxassetid://100076212630732",
	["play"] = "rbxassetid://108886429866687",
	["chevron-right"] = "rbxassetid://12662718374",
	["fish"] = "rbxassetid://97167558235554",
	["globe"] = "rbxassetid://137601480983962",
	["mouse-pointer-click"] = "rbxassetid://7734010488",
	["egg"] = "rbxassetid://8601111810",
	["gift"] = "rbxassetid://18747025078",
	["x"] = "rbxassetid://123534719795959",
}
local iconnames = {
	["aarrow-down"] = "rbxassetid://81511422394984",
	["aarrow-up"] = "rbxassetid://90750275722500",
	["accessibility"] = "rbxassetid://139193658545460",
	["activity"] = "rbxassetid://129777652823284",
	["ad"] = "rbxassetid://124912522832899",
	["air-vent"] = "rbxassetid://102959133081584",
	["airplay"] = "rbxassetid://119921013066692",
	["alarge-small"] = "rbxassetid://95765337935420",
	["alarm-clock"] = "rbxassetid://108373302167668",
	["alarm-clock-check"] = "rbxassetid://137869689232135",
	["alarm-clock-off"] = "rbxassetid://73838241842297",
	["alarm-smoke"] = "rbxassetid://125238481213081",
	["album"] = "rbxassetid://83399183259923",
	["alert-circle"] = "rbxassetid://71414046391706",
	["align-center"] = "rbxassetid://96280055308404",
	["align-center-horizontal"] = "rbxassetid://128738739772606",
	["align-end-horizontal"] = "rbxassetid://132768635514797",
	["align-horizontal-distribute-center"] = "rbxassetid://100015781145075",
	["align-horizontal-distribute-start"] = "rbxassetid://138216543738634",
	["align-horizontal-justify-end"] = "rbxassetid://124769697533117",
	["align-horizontal-space-around"] = "rbxassetid://91034719990509",
	["align-justify"] = "rbxassetid://87451985481538",
	["align-left"] = "rbxassetid://80147230072438",
	["align-right"] = "rbxassetid://83254552438899",
	["align-start-horizontal"] = "rbxassetid://113971961505616",
	["align-vertical-distribute-center"] = "rbxassetid://115924527067795",
	["align-vertical-distribute-start"] = "rbxassetid://79936548747711",
	["align-vertical-justify-end"] = "rbxassetid://129489764386430",
	["align-vertical-space-around"] = "rbxassetid://118857332802192",
	["ambulance"] = "rbxassetid://85285947979110",
	["ampersand"] = "rbxassetid://121751443544893",
	["ampersands"] = "rbxassetid://86850465666164",
	["amphora"] = "rbxassetid://140509291774820",
	["anchor"] = "rbxassetid://125834209745488",
	["angle"] = "rbxassetid://104188933026136",
	["angry"] = "rbxassetid://108026058440807",
	["annoyed"] = "rbxassetid://130464816908467",
	["antenna"] = "rbxassetid://136938775307185",
	["anvil"] = "rbxassetid://109874353642479",
	["aperture"] = "rbxassetid://120363639924463",
	["app-window"] = "rbxassetid://109277815797987",
	["archive"] = "rbxassetid://139602987211399",
	["archive-arrow-down"] = "rbxassetid://109337369142985",
	["archive-restore"] = "rbxassetid://97426422648219",
	["archive-x"] = "rbxassetid://73653285057420",
	["armchair"] = "rbxassetid://119861925922232",
	["arrow-big-down"] = "rbxassetid://91738627554668",
	["arrow-big-down-dash"] = "rbxassetid://93138152638413",
	["arrow-big-left"] = "rbxassetid://93240342664419",
	["arrow-big-right"] = "rbxassetid://78470903142504",
	["arrow-big-right-dash"] = "rbxassetid://84544425339531",
	["arrow-big-up"] = "rbxassetid://95239552412677",
	["arrow-big-up-dash"] = "rbxassetid://126036447132942",
	["arrow-down"] = "rbxassetid://102162327267489",
	["arrow-down-1-0"] = "rbxassetid://82950979009414",
	["arrow-down-from-line"] = "rbxassetid://71251116649072",
	["arrow-down-left"] = "rbxassetid://89083307820760",
	["arrow-down-right"] = "rbxassetid://88996429937108",
	["arrow-down-to-line"] = "rbxassetid://93329269788886",
	["arrow-down-wide-narrow"] = "rbxassetid://80310297690516",
	["arrow-left"] = "rbxassetid://127497508343664",
	["arrow-left-from-line"] = "rbxassetid://115152701869157",
	["arrow-left-right"] = "rbxassetid://79551100359361",
	["arrow-right"] = "rbxassetid://112908667401263",
	["arrow-right-from-line"] = "rbxassetid://122518017879115",
	["arrow-right-to-line"] = "rbxassetid://101786477972851",
	["arrow-up"] = "rbxassetid://139006410779568",
	["arrow-up-1-0"] = "rbxassetid://114642011321115",
	["arrow-up-down"] = "rbxassetid://129748557220690",
	["arrow-up-from-dot"] = "rbxassetid://87497166392230",
	["arrow-up-left"] = "rbxassetid://75592789330962",
	["arrow-up-right"] = "rbxassetid://136577642010176",
	["arrow-up-to-line"] = "rbxassetid://100832611149856",
	["arrow-up-z-a"] = "rbxassetid://113045867742716",
	["asterisk"] = "rbxassetid://112964184665991",
	["astroid"] = "rbxassetid://87526284420375",
	["at-sign"] = "rbxassetid://120741010328582",
	["atom"] = "rbxassetid://104782664409251",
	["audio-lines"] = "rbxassetid://90662964724523",
	["audio-lines-x"] = "rbxassetid://117372061787010",
	["audio-waveform"] = "rbxassetid://130367508884723",
	["award"] = "rbxassetid://131504205383916",
	["axe"] = "rbxassetid://94566803267078",
	["axis-3d"] = "rbxassetid://84103666277824",
	["azerbaijani-manat"] = "rbxassetid://80713924121862",
	["baby"] = "rbxassetid://83293773705366",
	["backpack"] = "rbxassetid://115599315933926",
	["bacon"] = "rbxassetid://138302255872123",
	["badge"] = "rbxassetid://133126245526015",
	["badge-alert"] = "rbxassetid://115562605121250",
	["badge-cent"] = "rbxassetid://82762665763271",
	["badge-check"] = "rbxassetid://111661521032393",
	["badge-euro"] = "rbxassetid://109249359034465",
	["badge-help"] = "rbxassetid://76110977081167",
	["badge-indian-rupee"] = "rbxassetid://131712333771954",
	["badge-info"] = "rbxassetid://105956407040096",
	["badge-minus"] = "rbxassetid://120951665671025",
	["badge-percent"] = "rbxassetid://132238057758792",
	["badge-plus"] = "rbxassetid://78428315687401",
	["badge-pound-sterling"] = "rbxassetid://93357445973317",
	["badge-swiss-franc"] = "rbxassetid://80073528115955",
	["badge-x"] = "rbxassetid://125907007851840",
	["baggage-claim"] = "rbxassetid://78284711820152",
	["ball-wave"] = "rbxassetid://127994652369904",
	["ban"] = "rbxassetid://135474435972214",
	["banana"] = "rbxassetid://124495460332364",
	["bandage"] = "rbxassetid://140411544660002",
	["bangladeshi-taka"] = "rbxassetid://134998689658090",
	["banknote"] = "rbxassetid://106681350777295",
	["banknote-arrow-up"] = "rbxassetid://85619326409596",
	["banknote-x"] = "rbxassetid://123252208874119",
	["bar-chart"] = "rbxassetid://90808101931930",
	["bar-chart-3"] = "rbxassetid://78466152352250",
	["barcode"] = "rbxassetid://95056292889611",
	["barrel"] = "rbxassetid://104841046595772",
	["baseline"] = "rbxassetid://121412610364424",
	["bath"] = "rbxassetid://139782187053972",
	["battery"] = "rbxassetid://113547141968289",
	["battery-charging"] = "rbxassetid://120311155576691",
	["battery-full"] = "rbxassetid://96506902736356",
	["battery-low"] = "rbxassetid://89052596110561",
	["battery-medium"] = "rbxassetid://124270382971805",
	["battery-warning"] = "rbxassetid://126890180678300",
	["beaker"] = "rbxassetid://114339911473571",
	["bean"] = "rbxassetid://77780439697794",
	["bean-off"] = "rbxassetid://125082269504025",
	["bed"] = "rbxassetid://117322573627108",
	["bed-double"] = "rbxassetid://100102904383553",
	["bed-single"] = "rbxassetid://120276431107512",
	["beef"] = "rbxassetid://136130681645007",
	["beef-off"] = "rbxassetid://133736179388483",
	["beer"] = "rbxassetid://73383213854311",
	["beer-off"] = "rbxassetid://121115064923357",
	["bell"] = "rbxassetid://71114364716796",
	["bell-check"] = "rbxassetid://83370136040135",
	["bell-dot"] = "rbxassetid://73416279582905",
	["bell-electric"] = "rbxassetid://110558840558608",
	["bell-minus"] = "rbxassetid://94240199734072",
	["bell-off"] = "rbxassetid://123558885024246",
	["bell-plus"] = "rbxassetid://76401429215083",
	["bell-ring"] = "rbxassetid://135007176351232",
	["between-horizontal-start"] = "rbxassetid://123866607483740",
	["between-vertical-start"] = "rbxassetid://117922904423506",
	["biceps-flexed"] = "rbxassetid://117283301089381",
	["bike"] = "rbxassetid://77189932050433",
	["binary"] = "rbxassetid://131462191707295",
	["binoculars"] = "rbxassetid://135662215208263",
	["biohazard"] = "rbxassetid://111937398490926",
	["bird"] = "rbxassetid://98775973850531",
	["bitcoin"] = "rbxassetid://125909181706178",
	["blend"] = "rbxassetid://124232109586989",
	["blender"] = "rbxassetid://90824223772589",
	["blinds"] = "rbxassetid://89993148137102",
	["blocks"] = "rbxassetid://84694397426202",
	["bluetooth"] = "rbxassetid://126518723147368",
	["bluetooth-connected"] = "rbxassetid://134541780463208",
	["bluetooth-off"] = "rbxassetid://81282815415943",
	["bluetooth-searching"] = "rbxassetid://90202516201724",
	["bold"] = "rbxassetid://97455814383879",
	["bolt"] = "rbxassetid://107655167938840",
	["bomb"] = "rbxassetid://101101819413314",
	["bone"] = "rbxassetid://80560202447557",
	["book"] = "rbxassetid://102005862253727",
	["book-a"] = "rbxassetid://105139363740324",
	["book-audio"] = "rbxassetid://108093824405425",
	["book-check"] = "rbxassetid://98888969359073",
	["book-copy"] = "rbxassetid://89560134640370",
	["book-dashed"] = "rbxassetid://127243447943441",
	["book-down"] = "rbxassetid://127488699221482",
	["book-exclamation-point"] = "rbxassetid://118323809639539",
	["book-headphones"] = "rbxassetid://132345042712075",
	["book-heart"] = "rbxassetid://102457355314466",
	["book-image"] = "rbxassetid://73894677253207",
	["book-key"] = "rbxassetid://87283978558170",
	["book-lock"] = "rbxassetid://114197134752361",
	["book-marked"] = "rbxassetid://109788692374058",
	["book-minus"] = "rbxassetid://122049936632846",
	["book-open"] = "rbxassetid://110168950016014",
	["book-open-text"] = "rbxassetid://74023960455844",
	["book-plus"] = "rbxassetid://71822625907711",
	["book-text"] = "rbxassetid://113255747773824",
	["book-type"] = "rbxassetid://107913313137688",
	["book-up"] = "rbxassetid://86583078922956",
	["book-up-2"] = "rbxassetid://73274809694460",
	["book-user"] = "rbxassetid://73850417605700",
	["book-x"] = "rbxassetid://87270170499407",
	["bookmark"] = "rbxassetid://90064277337826",
	["bookmark-check"] = "rbxassetid://97146274566361",
	["bookmark-minus"] = "rbxassetid://79615629646723",
	["bookmark-off"] = "rbxassetid://98210709207776",
	["bookmark-plus"] = "rbxassetid://102227613335355",
	["bookmark-x"] = "rbxassetid://75643133317581",
	["boom-box"] = "rbxassetid://111625066538313",
	["bot"] = "rbxassetid://99061973776066",
	["bot-off"] = "rbxassetid://76617131783178",
	["bottle-wine"] = "rbxassetid://129612660129334",
	["box"] = "rbxassetid://92306150025686",
	["boxes"] = "rbxassetid://70736240401001",
	["boxes-linked"] = "rbxassetid://105020224747834",
	["braces"] = "rbxassetid://110612426836547",
	["brackets"] = "rbxassetid://95389833036665",
	["brain"] = "rbxassetid://79276032136126",
	["brain-circuit"] = "rbxassetid://90481236159057",
	["brain-cog"] = "rbxassetid://138096329983771",
	["brick-wall"] = "rbxassetid://77940415050793",
	["brick-wall-fire"] = "rbxassetid://74190077552244",
	["bridge"] = "rbxassetid://132281999754833",
	["briefcase"] = "rbxassetid://73213492629149",
	["briefcase-business"] = "rbxassetid://130759214250151",
	["briefcase-medical"] = "rbxassetid://98761091599350",
	["briefcase-plus"] = "rbxassetid://101249389245120",
	["broccoli"] = "rbxassetid://79049889354663",
	["broom-sparkles"] = "rbxassetid://126662311970735",
	["brush"] = "rbxassetid://72168067589759",
	["bubbles"] = "rbxassetid://84172453904852",
	["bug"] = "rbxassetid://74805847743468",
	["bug-off"] = "rbxassetid://103947570705070",
	["bug-play"] = "rbxassetid://83947649055653",
	["building"] = "rbxassetid://82593177031259",
	["building-2"] = "rbxassetid://98023280496317",
	["bus"] = "rbxassetid://125250463081031",
	["bus-front"] = "rbxassetid://94394056189449",
	["cable"] = "rbxassetid://129462538307160",
	["cable-car"] = "rbxassetid://97135886683691",
	["cake"] = "rbxassetid://74919405756557",
	["cake-slice"] = "rbxassetid://77258204614561",
	["calculator"] = "rbxassetid://91053428917041",
	["calendar"] = "rbxassetid://82007715651176",
	["calendar-1"] = "rbxassetid://87357769777073",
	["calendar-arrow-down"] = "rbxassetid://75958554807222",
	["calendar-arrow-right"] = "rbxassetid://83845490712472",
	["calendar-check"] = "rbxassetid://97369316404386",
	["calendar-check-2"] = "rbxassetid://93630558822047",
	["calendar-chevrons-right"] = "rbxassetid://79954766064606",
	["calendar-clock"] = "rbxassetid://126323151205261",
	["calendar-cog"] = "rbxassetid://115968850971511",
	["calendar-days"] = "rbxassetid://77460378817676",
	["calendar-fold"] = "rbxassetid://83577596627364",
	["calendar-heart"] = "rbxassetid://75220519740210",
	["calendar-minus"] = "rbxassetid://126699820209528",
	["calendar-off"] = "rbxassetid://115107652845530",
	["calendar-plus"] = "rbxassetid://113225761727613",
	["calendar-plus-2"] = "rbxassetid://102714327706682",
	["calendar-range"] = "rbxassetid://72319588061698",
	["calendar-search"] = "rbxassetid://78360107727506",
	["calendar-sync"] = "rbxassetid://119690033086735",
	["calendar-x"] = "rbxassetid://105884404120482",
	["calendars"] = "rbxassetid://110860919494769",
	["calender"] = "rbxassetid://72797835657796",
	["camera"] = "rbxassetid://108784779780325",
	["camera-off"] = "rbxassetid://131618272934389",
	["can-soda"] = "rbxassetid://97469281806720",
	["candy"] = "rbxassetid://81318398561147",
	["candy-cane"] = "rbxassetid://101694504107309",
	["candy-off"] = "rbxassetid://84033641695367",
	["cannabis"] = "rbxassetid://122671803755328",
	["captions"] = "rbxassetid://104105283471077",
	["captions-off"] = "rbxassetid://137309632367514",
	["car"] = "rbxassetid://73362479746554",
	["car-battery"] = "rbxassetid://98474401242687",
	["car-front"] = "rbxassetid://79725766608060",
	["car-taxi-front"] = "rbxassetid://135638588342050",
	["caravan"] = "rbxassetid://124028265781656",
	["carrot"] = "rbxassetid://107614005262808",
	["carton"] = "rbxassetid://117126516349487",
	["case-lower"] = "rbxassetid://140113699222857",
	["case-sensitive"] = "rbxassetid://84492781283808",
	["case-upper"] = "rbxassetid://125528120128799",
	["cassette-tape"] = "rbxassetid://71051137741463",
	["cast"] = "rbxassetid://74126329876253",
	["castle"] = "rbxassetid://75244796597162",
	["cat"] = "rbxassetid://80370526311146",
	["cctv"] = "rbxassetid://104015407402141",
	["cctv-off"] = "rbxassetid://121071787075706",
	["chart-area"] = "rbxassetid://134649998850400",
	["chart-bar"] = "rbxassetid://70563930028245",
	["chart-bar-decreasing"] = "rbxassetid://85030233744258",
	["chart-bar-stacked"] = "rbxassetid://86099756252023",
	["chart-candlestick"] = "rbxassetid://139566038902398",
	["chart-column"] = "rbxassetid://111830663297769",
	["chart-column-big"] = "rbxassetid://106544997064962",
	["chart-column-increasing"] = "rbxassetid://94446417643856",
	["chart-gantt"] = "rbxassetid://104076131112974",
	["chart-line"] = "rbxassetid://109234924016039",
	["chart-network"] = "rbxassetid://77113303085909",
	["chart-no-axes-column"] = "rbxassetid://97949111930419",
	["chart-no-axes-column-increasing"] = "rbxassetid://79280822182353",
	["chart-no-axes-gantt"] = "rbxassetid://97819346034879",
	["chart-pie"] = "rbxassetid://76914843609004",
	["chart-radar"] = "rbxassetid://110446465758205",
	["chart-scatter"] = "rbxassetid://78335629673234",
	["chart-spline"] = "rbxassetid://105124678694841",
	["check"] = "rbxassetid://112785408343879",
	["check-check"] = "rbxassetid://97776243340794",
	["check-circle"] = "rbxassetid://100107514346344",
	["chef-hat"] = "rbxassetid://94894744765773",
	["cherry"] = "rbxassetid://120574767076922",
	["chess-bishop"] = "rbxassetid://105900535316054",
	["chess-knight"] = "rbxassetid://90596374384086",
	["chess-queen"] = "rbxassetid://107540556059402",
	["chevron-down"] = "rbxassetid://134453186120862",
	["chevron-first"] = "rbxassetid://119272918506539",
	["chevron-last"] = "rbxassetid://86884144662872",
	["chevron-left"] = "rbxassetid://115410849041663",
	["chevron-right"] = "rbxassetid://105663993771988",
	["chevron-up"] = "rbxassetid://72363861091750",
	["chevrons-down"] = "rbxassetid://100851223342436",
	["chevrons-down-up"] = "rbxassetid://92333445059745",
	["chevrons-left"] = "rbxassetid://101073398362263",
	["chevrons-left-right-ellipsis"] = "rbxassetid://139106418347266",
	["chevrons-right"] = "rbxassetid://88964234951016",
	["chevrons-up"] = "rbxassetid://105789376005170",
	["chevrons-up-down"] = "rbxassetid://88846133893911",
	["church"] = "rbxassetid://132029043551928",
	["cigarette"] = "rbxassetid://127940368214589",
	["cigarette-off"] = "rbxassetid://135958514322075",
	["circle"] = "rbxassetid://120403011678591",
	["circle-alert"] = "rbxassetid://103772274227052",
	["circle-arrow-down"] = "rbxassetid://122014907024785",
	["circle-arrow-left"] = "rbxassetid://138529496487540",
	["circle-arrow-out-down-right"] = "rbxassetid://138646283695618",
	["circle-arrow-out-up-right"] = "rbxassetid://88967356624319",
	["circle-arrow-up"] = "rbxassetid://116635656705277",
	["circle-check"] = "rbxassetid://71872877750642",
	["circle-check-big"] = "rbxassetid://135698737539552",
	["circle-chevron-left"] = "rbxassetid://135764317174936",
	["circle-chevron-up"] = "rbxassetid://90105297298499",
	["circle-chevrons-left"] = "rbxassetid://94974946581539",
	["circle-chevrons-up"] = "rbxassetid://78002035441696",
	["circle-dashed"] = "rbxassetid://92570233342968",
	["circle-divide"] = "rbxassetid://127949763272070",
	["circle-dollar-sign"] = "rbxassetid://95675950901074",
	["circle-dot"] = "rbxassetid://73497738052057",
	["circle-ellipsis"] = "rbxassetid://118789314192477",
	["circle-equal"] = "rbxassetid://132112500036399",
	["circle-euro"] = "rbxassetid://103042081357034",
	["circle-fading-check"] = "rbxassetid://101317450472555",
	["circle-fading-plus"] = "rbxassetid://91509244379189",
	["circle-gauge"] = "rbxassetid://119110493295147",
	["circle-help"] = "rbxassetid://107636029431024",
	["circle-letter-b"] = "rbxassetid://78852307504941",
	["circle-letter-e"] = "rbxassetid://106204131979721",
	["circle-letter-g"] = "rbxassetid://120193405330538",
	["circle-letter-i"] = "rbxassetid://112927845923885",
	["circle-letter-k"] = "rbxassetid://122958023466493",
	["circle-letter-l"] = "rbxassetid://73622612235895",
	["circle-letter-n"] = "rbxassetid://132280641235593",
	["circle-letter-p-off"] = "rbxassetid://78623984845429",
	["circle-letter-r"] = "rbxassetid://123286135053124",
	["circle-letter-t"] = "rbxassetid://129953935880619",
	["circle-letter-v"] = "rbxassetid://87244409461927",
	["circle-letter-x"] = "rbxassetid://136660975199058",
	["circle-letter-z"] = "rbxassetid://100582566494261",
	["circle-minus"] = "rbxassetid://110403231167535",
	["circle-off"] = "rbxassetid://126412652604045",
	["circle-parking"] = "rbxassetid://125343171345276",
	["circle-pause"] = "rbxassetid://81404553763873",
	["circle-percent"] = "rbxassetid://131510979506214",
	["circle-play"] = "rbxassetid://103279092287483",
	["circle-plus"] = "rbxassetid://72384325603423",
	["circle-pound-sterling"] = "rbxassetid://74990754508745",
	["circle-power"] = "rbxassetid://126821209973377",
	["circle-slash"] = "rbxassetid://104630891355880",
	["circle-small"] = "rbxassetid://72496391409633",
	["circle-stop"] = "rbxassetid://117998434335338",
	["circle-user"] = "rbxassetid://128301603749918",
	["circle-user-round"] = "rbxassetid://76881385907040",
	["circle-x"] = "rbxassetid://73382395365341",
	["circuit-board"] = "rbxassetid://76896389606217",
	["citrus"] = "rbxassetid://73563100500609",
	["clapperboard"] = "rbxassetid://75597089273080",
	["clef-bass"] = "rbxassetid://136881188872078",
	["clipboard"] = "rbxassetid://98487531786795",
	["clipboard-check"] = "rbxassetid://91018334691405",
	["clipboard-clock"] = "rbxassetid://109541083150536",
	["clipboard-copy"] = "rbxassetid://110511635660442",
	["clipboard-list"] = "rbxassetid://71766940389907",
	["clipboard-minus"] = "rbxassetid://125025643075708",
	["clipboard-paste"] = "rbxassetid://110827418381394",
	["clipboard-pen"] = "rbxassetid://84678729842895",
	["clipboard-plus"] = "rbxassetid://125435864331949",
	["clipboard-type"] = "rbxassetid://130531674627708",
	["clipboard-x"] = "rbxassetid://82624155426113",
	["clock"] = "rbxassetid://124680551076134",
	["clock-1"] = "rbxassetid://91795220202559",
	["clock-10"] = "rbxassetid://79547657610585",
	["clock-11"] = "rbxassetid://94782824528298",
	["clock-12"] = "rbxassetid://79039711404175",
	["clock-2"] = "rbxassetid://99267804583458",
	["clock-3"] = "rbxassetid://111615662137806",
	["clock-5"] = "rbxassetid://117939074681429",
	["clock-6"] = "rbxassetid://96677602814319",
	["clock-7"] = "rbxassetid://96596735690970",
	["clock-8"] = "rbxassetid://83531711840058",
	["clock-9"] = "rbxassetid://136512114599036",
	["clock-alert"] = "rbxassetid://118353402971829",
	["clock-arrow-down"] = "rbxassetid://101548201702154",
	["clock-arrow-right"] = "rbxassetid://93993301922631",
	["clock-check"] = "rbxassetid://100451199536922",
	["clock-plus"] = "rbxassetid://81405639923184",
	["closed-caption"] = "rbxassetid://102471181114858",
	["cloud"] = "rbxassetid://96013046625898",
	["cloud-alert"] = "rbxassetid://134948830097570",
	["cloud-check"] = "rbxassetid://120236862565587",
	["cloud-cog"] = "rbxassetid://108827824184475",
	["cloud-download"] = "rbxassetid://91851639063999",
	["cloud-drizzle"] = "rbxassetid://84075590635830",
	["cloud-fog"] = "rbxassetid://139693315501238",
	["cloud-hail"] = "rbxassetid://82639739873276",
	["cloud-lightning"] = "rbxassetid://118286603382616",
	["cloud-moon"] = "rbxassetid://89906084902333",
	["cloud-off"] = "rbxassetid://83712289352162",
	["cloud-rain"] = "rbxassetid://71125341321211",
	["cloud-rain-wind"] = "rbxassetid://133127876658202",
	["cloud-snow"] = "rbxassetid://72535284793910",
	["cloud-sun"] = "rbxassetid://96027958781419",
	["cloud-sync"] = "rbxassetid://122828340028751",
	["cloud-upload"] = "rbxassetid://90311132596707",
	["cloudy"] = "rbxassetid://117755479167555",
	["clover"] = "rbxassetid://74575593209596",
	["club"] = "rbxassetid://127163282905378",
	["code"] = "rbxassetid://81935826319286",
	["code-xml"] = "rbxassetid://130481920814421",
	["coffee"] = "rbxassetid://100291682873770",
	["cog"] = "rbxassetid://130234804759573",
	["coins"] = "rbxassetid://78171189116579",
	["columns-2"] = "rbxassetid://124210281735846",
	["columns-3"] = "rbxassetid://125853290029624",
	["columns-4"] = "rbxassetid://134096000180653",
	["combine"] = "rbxassetid://102428605453915",
	["command"] = "rbxassetid://99872148691019",
	["compass"] = "rbxassetid://109978400552300",
	["component"] = "rbxassetid://138558922071123",
	["computer"] = "rbxassetid://126100417284119",
	["concierge-bell"] = "rbxassetid://109878351280593",
	["cone"] = "rbxassetid://70997062440302",
	["construction"] = "rbxassetid://88159661018009",
	["contact"] = "rbxassetid://122550253251243",
	["contact-round"] = "rbxassetid://88834433612898",
	["container"] = "rbxassetid://77516017905137",
	["contrast"] = "rbxassetid://136039924399041",
	["cookie"] = "rbxassetid://88017119101820",
	["cooking-pot"] = "rbxassetid://93132439506446",
	["copy"] = "rbxassetid://87114077864895",
	["copy-check"] = "rbxassetid://95695145710607",
	["copy-minus"] = "rbxassetid://107932755298661",
	["copy-plus"] = "rbxassetid://135968905951580",
	["copy-slash"] = "rbxassetid://120968957227772",
	["copy-x"] = "rbxassetid://140378020546167",
	["copyleft"] = "rbxassetid://125718043861426",
	["copyright"] = "rbxassetid://127659900135205",
	["corner-down-left"] = "rbxassetid://72409438902863",
	["corner-down-right"] = "rbxassetid://117140629572888",
	["corner-left-up"] = "rbxassetid://89824822636467",
	["corner-right-up"] = "rbxassetid://102534049569602",
	["corner-up-right"] = "rbxassetid://76812813872131",
	["cpu"] = "rbxassetid://92695898445356",
	["creative-commons"] = "rbxassetid://124634678728710",
	["credit-card"] = "rbxassetid://123183355487317",
	["credit-card-check"] = "rbxassetid://122836762382551",
	["credit-card-plus"] = "rbxassetid://100665019190963",
	["credit-card-x"] = "rbxassetid://138385229835165",
	["croissant"] = "rbxassetid://123932308230331",
	["crop"] = "rbxassetid://79664892478340",
	["cross"] = "rbxassetid://111058703856406",
	["crosshair"] = "rbxassetid://81556293555772",
	["crown"] = "rbxassetid://84787387626561",
	["cuboid"] = "rbxassetid://114675684310697",
	["cup-soda"] = "rbxassetid://97031743051800",
	["currency"] = "rbxassetid://103696974007481",
	["cylinder"] = "rbxassetid://79483987828569",
	["dam"] = "rbxassetid://100416292660262",
	["database"] = "rbxassetid://129944073540132",
	["database-arrow-down"] = "rbxassetid://132600257760011",
	["database-backup"] = "rbxassetid://140684124807738",
	["database-check"] = "rbxassetid://83236301431806",
	["database-minus"] = "rbxassetid://130248669893509",
	["database-search"] = "rbxassetid://128495924828250",
	["database-zap"] = "rbxassetid://137810874763440",
	["decimals-arrow-left"] = "rbxassetid://123270541012311",
	["delete"] = "rbxassetid://80795444840756",
	["diagram-flow-horizontal"] = "rbxassetid://95552482538923",
	["diagram-flow-vertical"] = "rbxassetid://75967595181485",
	["diameter"] = "rbxassetid://100990941459576",
	["diamond"] = "rbxassetid://110315308842811",
	["diamond-minus"] = "rbxassetid://73276565437068",
	["diamond-percent"] = "rbxassetid://112956979262085",
	["diamond-plus"] = "rbxassetid://91354719111983",
	["dice-1"] = "rbxassetid://111732792535516",
	["dice-2"] = "rbxassetid://100836831907746",
	["dice-3"] = "rbxassetid://133090891863976",
	["dice-4"] = "rbxassetid://79876115127649",
	["dice-5"] = "rbxassetid://129824034875794",
	["dice-6"] = "rbxassetid://109935169112513",
	["dices"] = "rbxassetid://93785443973014",
	["diff"] = "rbxassetid://94068954968297",
	["disc"] = "rbxassetid://132583987701328",
	["disc-2"] = "rbxassetid://87346870088967",
	["disc-3"] = "rbxassetid://117371752735916",
	["disc-album"] = "rbxassetid://126475650953042",
	["divide"] = "rbxassetid://117932419090730",
	["dna"] = "rbxassetid://71413900259588",
	["dna-off"] = "rbxassetid://89601195558710",
	["dock"] = "rbxassetid://110759237141508",
	["dog"] = "rbxassetid://101424496146012",
	["dollar-sign"] = "rbxassetid://93238790708931",
	["donut"] = "rbxassetid://112108512226227",
	["door-closed"] = "rbxassetid://110719550560164",
	["door-closed-cog"] = "rbxassetid://90694894867828",
	["door-closed-package"] = "rbxassetid://81814231335974",
	["door-open"] = "rbxassetid://95544243461878",
	["dot"] = "rbxassetid://80125278650599",
	["download"] = "rbxassetid://122670295288304",
	["drafting-compass"] = "rbxassetid://120636720225084",
	["drama"] = "rbxassetid://112265782568244",
	["drill"] = "rbxassetid://127456572794429",
	["drone"] = "rbxassetid://83141279228701",
	["droplet"] = "rbxassetid://128262567868066",
	["droplets"] = "rbxassetid://134906294552623",
	["drum"] = "rbxassetid://122329318101164",
	["drumstick"] = "rbxassetid://111121096860677",
	["dumbbell"] = "rbxassetid://101981604346221",
	["ear"] = "rbxassetid://105803761352399",
	["ear-off"] = "rbxassetid://99944287462408",
	["earbuds"] = "rbxassetid://128837717125160",
	["earth"] = "rbxassetid://97770795190370",
	["earth-lock"] = "rbxassetid://139120702113450",
	["eclipse"] = "rbxassetid://112247891753054",
	["egg"] = "rbxassetid://86852678810259",
	["egg-fried"] = "rbxassetid://133107158698440",
	["egg-off"] = "rbxassetid://108231514767725",
	["eighth-note"] = "rbxassetid://92675911792579",
	["ellipse"] = "rbxassetid://96976992925957",
	["ellipsis"] = "rbxassetid://105460963723680",
	["ellipsis-vertical"] = "rbxassetid://92834614779070",
	["engine"] = "rbxassetid://122355935350786",
	["equal"] = "rbxassetid://119431479349773",
	["equal-approximately"] = "rbxassetid://107401741548172",
	["equal-not"] = "rbxassetid://74999900368612",
	["eraser"] = "rbxassetid://107802905732167",
	["ethernet-port"] = "rbxassetid://84603325007605",
	["euro"] = "rbxassetid://104081887585109",
	["ev-charger"] = "rbxassetid://101242226835514",
	["exit"] = "rbxassetid://103507990954018",
	["expand"] = "rbxassetid://101684401485816",
	["external-link"] = "rbxassetid://87944612288981",
	["eye"] = "rbxassetid://87823613684549",
	["eye-closed"] = "rbxassetid://117549871240323",
	["eye-off"] = "rbxassetid://115808552395447",
	["face-slightly-smiling-plus"] = "rbxassetid://71393984632095",
	["factory"] = "rbxassetid://135670453908103",
	["fan"] = "rbxassetid://111863267067234",
	["fast-forward"] = "rbxassetid://78203061660941",
	["feather"] = "rbxassetid://103094489625819",
	["fence"] = "rbxassetid://129982639065886",
	["ferris-wheel"] = "rbxassetid://130806843473603",
	["file"] = "rbxassetid://97964464200847",
	["file-archive"] = "rbxassetid://111325864087854",
	["file-audio"] = "rbxassetid://92336883838390",
	["file-axis-3-d"] = "rbxassetid://125742651489708",
	["file-badge"] = "rbxassetid://124777065470579",
	["file-box"] = "rbxassetid://109691532362199",
	["file-chart-column"] = "rbxassetid://75071167425943",
	["file-chart-line"] = "rbxassetid://82387477340069",
	["file-check"] = "rbxassetid://85196416949266",
	["file-check-corner"] = "rbxassetid://126919292152828",
	["file-clock"] = "rbxassetid://107332863061743",
	["file-code"] = "rbxassetid://121194498874081",
	["file-cog"] = "rbxassetid://140650920620379",
	["file-database"] = "rbxassetid://113551814099800",
	["file-diff"] = "rbxassetid://114548821885202",
	["file-digit"] = "rbxassetid://123592894488176",
	["file-down"] = "rbxassetid://134276627641342",
	["file-heart"] = "rbxassetid://118353661416960",
	["file-image"] = "rbxassetid://124225025336675",
	["file-input"] = "rbxassetid://127245967711401",
	["file-json"] = "rbxassetid://103401692603997",
	["file-key"] = "rbxassetid://89800738313610",
	["file-lock"] = "rbxassetid://77469354222215",
	["file-minus"] = "rbxassetid://108397857214669",
	["file-music"] = "rbxassetid://106326853133928",
	["file-output"] = "rbxassetid://97241075148368",
	["file-pen"] = "rbxassetid://125094589936339",
	["file-plus"] = "rbxassetid://87378111572655",
	["file-plus-corner"] = "rbxassetid://106518853478190",
	["file-question"] = "rbxassetid://87307452436555",
	["file-scan"] = "rbxassetid://85607228796766",
	["file-search"] = "rbxassetid://123876802584306",
	["file-signature"] = "rbxassetid://140691983906379",
	["file-sliders"] = "rbxassetid://112115119870837",
	["file-spreadsheet"] = "rbxassetid://119607979414557",
	["file-stack"] = "rbxassetid://139623307672107",
	["file-symlink"] = "rbxassetid://135489525103437",
	["file-terminal"] = "rbxassetid://111380664140126",
	["file-text"] = "rbxassetid://78111116498067",
	["file-type"] = "rbxassetid://79529974323684",
	["file-type-corner"] = "rbxassetid://129711714158462",
	["file-up"] = "rbxassetid://94004922582448",
	["file-user"] = "rbxassetid://92849845220808",
	["file-video"] = "rbxassetid://72622233452644",
	["file-volume"] = "rbxassetid://76387412110000",
	["file-volume-2"] = "rbxassetid://72498732457844",
	["file-warning"] = "rbxassetid://74962438232973",
	["file-x"] = "rbxassetid://120533348938600",
	["files"] = "rbxassetid://113496237273283",
	["film"] = "rbxassetid://85166144297002",
	["filter"] = "rbxassetid://87266709805671",
	["filter-x"] = "rbxassetid://87462917955220",
	["fingerprint"] = "rbxassetid://103570994334125",
	["fire-extinguisher"] = "rbxassetid://106906341208706",
	["fish"] = "rbxassetid://74868123963122",
	["fish-off"] = "rbxassetid://129610521539276",
	["fish-symbol"] = "rbxassetid://75424965893187",
	["fishing-hook"] = "rbxassetid://97712616170278",
	["flag"] = "rbxassetid://85238132062093",
	["flag-off"] = "rbxassetid://80270751817524",
	["flag-triangle-left"] = "rbxassetid://116863755374017",
	["flame"] = "rbxassetid://105701414644779",
	["flame-kindling"] = "rbxassetid://140551477635172",
	["flashlight"] = "rbxassetid://128077964916576",
	["flashlight-off"] = "rbxassetid://107772849918643",
	["flask-conical"] = "rbxassetid://73918435640797",
	["flask-conical-off"] = "rbxassetid://124550738560865",
	["flask-round"] = "rbxassetid://106955785495737",
	["flip-horizontal"] = "rbxassetid://96845692930460",
	["flip-vertical"] = "rbxassetid://126097163532721",
	["flower"] = "rbxassetid://112568492643035",
	["flower-2"] = "rbxassetid://102681177157760",
	["focus"] = "rbxassetid://77476158720119",
	["fold-horizontal"] = "rbxassetid://125009115188798",
	["fold-vertical"] = "rbxassetid://88056416395407",
	["folder"] = "rbxassetid://114120616619004",
	["folder-archive"] = "rbxassetid://109208532270092",
	["folder-check"] = "rbxassetid://110133266236690",
	["folder-clock"] = "rbxassetid://131590168493139",
	["folder-closed"] = "rbxassetid://93832113160743",
	["folder-code"] = "rbxassetid://111148488416844",
	["folder-cog"] = "rbxassetid://106246784818309",
	["folder-dot"] = "rbxassetid://131485236438806",
	["folder-down"] = "rbxassetid://80273289801251",
	["folder-git"] = "rbxassetid://113153665943983",
	["folder-git-2"] = "rbxassetid://93741406560079",
	["folder-heart"] = "rbxassetid://97371061558051",
	["folder-input"] = "rbxassetid://78228043145608",
	["folder-kanban"] = "rbxassetid://84635784811345",
	["folder-key"] = "rbxassetid://111652615487653",
	["folder-lock"] = "rbxassetid://71719248858031",
	["folder-minus"] = "rbxassetid://99247987180969",
	["folder-open"] = "rbxassetid://128680936474800",
	["folder-output"] = "rbxassetid://87270983134295",
	["folder-pen"] = "rbxassetid://88599374142429",
	["folder-plus"] = "rbxassetid://131270298838953",
	["folder-root"] = "rbxassetid://109128072396190",
	["folder-search"] = "rbxassetid://124012647101631",
	["folder-search-2"] = "rbxassetid://99466172464285",
	["folder-symlink"] = "rbxassetid://92924056619808",
	["folder-sync"] = "rbxassetid://115880214544240",
	["folder-tree"] = "rbxassetid://123004612552567",
	["folder-up"] = "rbxassetid://136387545322045",
	["folder-users"] = "rbxassetid://78001605827915",
	["folder-x"] = "rbxassetid://88389834057669",
	["folders"] = "rbxassetid://133602873700523",
	["footprints"] = "rbxassetid://75109137786226",
	["forklift"] = "rbxassetid://76397938354229",
	["form"] = "rbxassetid://134691938961758",
	["forward"] = "rbxassetid://115480838927614",
	["frame"] = "rbxassetid://108453787383371",
	["frown"] = "rbxassetid://75571061114851",
	["fuel"] = "rbxassetid://93800517833115",
	["fullscreen"] = "rbxassetid://70557312852700",
	["galaxy"] = "rbxassetid://96401696556968",
	["gallery-horizontal"] = "rbxassetid://73617109605991",
	["gallery-thumbnails"] = "rbxassetid://71762867010853",
	["gallery-vertical"] = "rbxassetid://101871980761169",
	["gallery-vertical-end"] = "rbxassetid://96561697438306",
	["gamepad"] = "rbxassetid://115830987009989",
	["gamepad-2"] = "rbxassetid://115456712682344",
	["gap-horizontal"] = "rbxassetid://124827765023986",
	["gauge"] = "rbxassetid://91938166866248",
	["gavel"] = "rbxassetid://88087740904515",
	["gem"] = "rbxassetid://99314744260718",
	["georgian-lari"] = "rbxassetid://138887024395595",
	["germ-off"] = "rbxassetid://112561265936267",
	["ghost"] = "rbxassetid://116566265038704",
	["gift"] = "rbxassetid://97147804710032",
	["git-branch"] = "rbxassetid://96978313452303",
	["git-branch-plus"] = "rbxassetid://104882271796336",
	["git-commit-vertical"] = "rbxassetid://111924509481766",
	["git-compare"] = "rbxassetid://130630338413562",
	["git-fork"] = "rbxassetid://99391654789693",
	["git-graph"] = "rbxassetid://76395284839805",
	["git-merge"] = "rbxassetid://102593816091496",
	["git-merge-conflict"] = "rbxassetid://92198542583310",
	["git-pull-request"] = "rbxassetid://139123623597205",
	["git-pull-request-closed"] = "rbxassetid://126843589193906",
	["git-pull-request-create-arrow"] = "rbxassetid://72836277728628",
	["glass-water"] = "rbxassetid://117143003402616",
	["glasses"] = "rbxassetid://104147413693277",
	["globe"] = "rbxassetid://109305976030076",
	["globe-ban"] = "rbxassetid://94798073458513",
	["globe-code"] = "rbxassetid://123655824136650",
	["globe-lock"] = "rbxassetid://117194764623660",
	["globe-plus"] = "rbxassetid://117549668023127",
	["goal"] = "rbxassetid://125092427094501",
	["gpu"] = "rbxassetid://108934083321434",
	["grab"] = "rbxassetid://95513827544831",
	["graduation-cap"] = "rbxassetid://126727683919795",
	["grape"] = "rbxassetid://97733933828720",
	["graph-star"] = "rbxassetid://73770941848500",
	["grid-2x2-check"] = "rbxassetid://107305894931031",
	["grid-2x2-x"] = "rbxassetid://82992717375753",
	["grid-3x2"] = "rbxassetid://139202535523049",
	["grip"] = "rbxassetid://101157266521567",
	["grip-horizontal"] = "rbxassetid://126769659454205",
	["grip-vertical"] = "rbxassetid://101898477224602",
	["group"] = "rbxassetid://117464342231678",
	["guitar"] = "rbxassetid://80854582068997",
	["guitar-electric"] = "rbxassetid://111750428433164",
	["hamburger"] = "rbxassetid://91833553506044",
	["hammer"] = "rbxassetid://74209651187073",
	["hand-coins"] = "rbxassetid://127887523175477",
	["hand-heart"] = "rbxassetid://136813004835220",
	["hand-helping"] = "rbxassetid://92913206376382",
	["handbag"] = "rbxassetid://73723102005031",
	["handshake"] = "rbxassetid://117437086814640",
	["hard-drive"] = "rbxassetid://133635175398623",
	["hard-drive-download"] = "rbxassetid://74447451782009",
	["hard-drive-upload"] = "rbxassetid://139419539505370",
	["hard-hat"] = "rbxassetid://102267028530925",
	["hash"] = "rbxassetid://80991904984908",
	["haze"] = "rbxassetid://118984186282833",
	["hd"] = "rbxassetid://125320522608068",
	["hdmi-port"] = "rbxassetid://126259897650962",
	["headphone-off"] = "rbxassetid://127560122569109",
	["headphones"] = "rbxassetid://83226379616461",
	["headset"] = "rbxassetid://85638574609070",
	["heart"] = "rbxassetid://133287402014465",
	["heart-crack"] = "rbxassetid://105517912114469",
	["heart-handshake"] = "rbxassetid://105146268952060",
	["heart-off"] = "rbxassetid://118921409089418",
	["heart-plus"] = "rbxassetid://83719153509912",
	["heart-pulse"] = "rbxassetid://106703444545952",
	["heart-x"] = "rbxassetid://72338527738136",
	["heater"] = "rbxassetid://119497317028295",
	["help-circle"] = "rbxassetid://98441209490221",
	["hexagon"] = "rbxassetid://101401491640135",
	["highlighter"] = "rbxassetid://139476313519865",
	["hiking-stick"] = "rbxassetid://103336632472318",
	["history"] = "rbxassetid://91764753023292",
	["home"] = "rbxassetid://105823546951854",
	["hop"] = "rbxassetid://91324344863422",
	["hop-off"] = "rbxassetid://80496145935901",
	["hospital"] = "rbxassetid://137291821924618",
	["hot-air-balloon"] = "rbxassetid://117574378778302",
	["hotel"] = "rbxassetid://116564404807001",
	["hourglass"] = "rbxassetid://115619743836926",
	["house"] = "rbxassetid://85748294927998",
	["house-cog"] = "rbxassetid://109531192061186",
	["house-plug"] = "rbxassetid://91472268980339",
	["house-plus"] = "rbxassetid://121925504638906",
	["house-wifi"] = "rbxassetid://73832110068968",
	["ice-cream-bowl"] = "rbxassetid://101969472296180",
	["id-card"] = "rbxassetid://111393369482609",
	["id-card-lanyard"] = "rbxassetid://72526475861586",
	["image"] = "rbxassetid://124095928340921",
	["image-minus"] = "rbxassetid://104741722103618",
	["image-play"] = "rbxassetid://83740667844814",
	["image-up"] = "rbxassetid://134026283265288",
	["images"] = "rbxassetid://117304723939122",
	["import"] = "rbxassetid://136020734313325",
	["inbox"] = "rbxassetid://139552635086283",
	["indian-rupee"] = "rbxassetid://82500696156933",
	["infinity"] = "rbxassetid://122386584391290",
	["info"] = "rbxassetid://121488542549160",
	["italic"] = "rbxassetid://87309928387589",
	["iteration-ccw"] = "rbxassetid://140581037752423",
	["iv-bag"] = "rbxassetid://124538322856368",
	["joystick"] = "rbxassetid://111627189902515",
	["kanban"] = "rbxassetid://91193973350645",
	["kayak"] = "rbxassetid://109402125510045",
	["key"] = "rbxassetid://90699527652018",
	["key-round"] = "rbxassetid://85079157266787",
	["key-square"] = "rbxassetid://81868657301716",
	["keyboard"] = "rbxassetid://98033071152509",
	["keyboard-off"] = "rbxassetid://71494444049987",
	["lamp"] = "rbxassetid://134810782146625",
	["lamp-ceiling"] = "rbxassetid://140039481205380",
	["lamp-desk"] = "rbxassetid://121596247533177",
	["lamp-wall-down"] = "rbxassetid://99618586358827",
	["land-plot"] = "rbxassetid://131358023954107",
	["landmark"] = "rbxassetid://138805420387777",
	["languages"] = "rbxassetid://128830286033051",
	["laptop"] = "rbxassetid://114329635830797",
	["laptop-minimal-check"] = "rbxassetid://79521832437926",
	["lasso"] = "rbxassetid://86104754317879",
	["lasso-select"] = "rbxassetid://114576198370011",
	["laugh"] = "rbxassetid://91937028674105",
	["layer-arrow-up"] = "rbxassetid://93624546262142",
	["layers"] = "rbxassetid://129417646084829",
	["layers-arrow-down"] = "rbxassetid://104431889315712",
	["layers-minus"] = "rbxassetid://94095384524684",
	["layout-arrow-down"] = "rbxassetid://128260477036748",
	["layout-dashboard"] = "rbxassetid://110658586115552",
	["layout-freeform"] = "rbxassetid://120735959370478",
	["layout-grid"] = "rbxassetid://108537796141618",
	["layout-list"] = "rbxassetid://114464836097584",
	["layout-panel-top"] = "rbxassetid://116805500595895",
	["leaf"] = "rbxassetid://126665505489243",
	["leafy-green"] = "rbxassetid://92893016838651",
	["lectern"] = "rbxassetid://136024499891860",
	["lens-concave"] = "rbxassetid://108492570266994",
	["library"] = "rbxassetid://119070218664004",
	["life-buoy"] = "rbxassetid://94924464282510",
	["ligature"] = "rbxassetid://137283440071995",
	["lightbulb"] = "rbxassetid://75878691396665",
	["lightbulb-off"] = "rbxassetid://99934036383506",
	["line-chart"] = "rbxassetid://103585088809310",
	["line-dot-bottom-vertical"] = "rbxassetid://90301962665329",
	["line-dot-right-horizontal"] = "rbxassetid://139208870352876",
	["line-height"] = "rbxassetid://85346131528397",
	["line-style"] = "rbxassetid://119289024049547",
	["link"] = "rbxassetid://92584824042072",
	["link-2-off"] = "rbxassetid://113459454438685",
	["list"] = "rbxassetid://89951088706493",
	["list-check"] = "rbxassetid://91164319882305",
	["list-checks"] = "rbxassetid://82519543798972",
	["list-chevrons-up-down"] = "rbxassetid://120384890344316",
	["list-collapse"] = "rbxassetid://72100644580662",
	["list-filter"] = "rbxassetid://96021940328871",
	["list-indent-decrease"] = "rbxassetid://134511205175810",
	["list-minus"] = "rbxassetid://86248266083866",
	["list-ordered"] = "rbxassetid://115936825759372",
	["list-plus"] = "rbxassetid://98073117829027",
	["list-restart"] = "rbxassetid://105523060449770",
	["list-sort-descending"] = "rbxassetid://123879039739087",
	["list-todo"] = "rbxassetid://133943892278865",
	["list-video"] = "rbxassetid://90637137723937",
	["loader"] = "rbxassetid://128486250911535",
	["loader-circle"] = "rbxassetid://110711152937847",
	["locate"] = "rbxassetid://130557686018477",
	["locate-fixed"] = "rbxassetid://79633389661086",
	["location-edit"] = "rbxassetid://72898898505039",
	["lock"] = "rbxassetid://115706221987040",
	["lock-keyhole"] = "rbxassetid://82505939033164",
	["lock-open"] = "rbxassetid://135731823598256",
	["log-in"] = "rbxassetid://99923953035945",
	["log-out"] = "rbxassetid://84224458794931",
	["logs"] = "rbxassetid://103045902666426",
	["lollipop"] = "rbxassetid://82103679953399",
	["luggage"] = "rbxassetid://95002562452777",
	["magnet"] = "rbxassetid://81589960159528",
	["mail"] = "rbxassetid://131482237286723",
	["mail-badge"] = "rbxassetid://107748598973963",
	["mail-clock"] = "rbxassetid://111645384111805",
	["mail-exclamation-point"] = "rbxassetid://97306475691219",
	["mail-open"] = "rbxassetid://72776901986304",
	["mail-pen"] = "rbxassetid://137236082683287",
	["mail-question-mark"] = "rbxassetid://111276917261672",
	["mail-x"] = "rbxassetid://124655110881436",
	["mailbox"] = "rbxassetid://78478068212010",
	["mails"] = "rbxassetid://128842367945203",
	["map"] = "rbxassetid://135288609184801",
	["map-minus"] = "rbxassetid://101378580887858",
	["map-pin"] = "rbxassetid://87472020159248",
	["map-pin-check-inside"] = "rbxassetid://133078294405730",
	["map-pin-minus"] = "rbxassetid://116347822436242",
	["map-pin-off"] = "rbxassetid://113088069994878",
	["map-pin-plus-inside"] = "rbxassetid://124689768528692",
	["map-pin-x"] = "rbxassetid://123630794849457",
	["map-pinned"] = "rbxassetid://109405861239218",
	["margin"] = "rbxassetid://125317666940774",
	["margin-horizontal"] = "rbxassetid://135847449242218",
	["margin-right"] = "rbxassetid://111024034461093",
	["margin-vertical"] = "rbxassetid://100949758914940",
	["mars-stroke"] = "rbxassetid://72338472830863",
	["maximize"] = "rbxassetid://71182004407947",
	["medal"] = "rbxassetid://87710991666819",
	["megaphone"] = "rbxassetid://109704822664163",
	["megaphone-off"] = "rbxassetid://92818895330261",
	["meh"] = "rbxassetid://93096944881506",
	["memory-stick"] = "rbxassetid://95285675226826",
	["menu"] = "rbxassetid://101293963411970",
	["merge"] = "rbxassetid://137504877674265",
	["message-circle"] = "rbxassetid://94954628171965",
	["message-circle-code"] = "rbxassetid://102142506592098",
	["message-circle-dashed"] = "rbxassetid://98408064970369",
	["message-circle-exclamation-point"] = "rbxassetid://126026345397855",
	["message-circle-more"] = "rbxassetid://97224085118592",
	["message-circle-plus"] = "rbxassetid://124369173324717",
	["message-circle-reply"] = "rbxassetid://116284931967084",
	["message-circle-x"] = "rbxassetid://75877394703856",
	["message-square-check"] = "rbxassetid://124782925736490",
	["message-square-dashed"] = "rbxassetid://131152349073439",
	["message-square-dot"] = "rbxassetid://131289768836297",
	["message-square-heart"] = "rbxassetid://97337370436561",
	["message-square-more"] = "rbxassetid://130331034371877",
	["message-square-plus"] = "rbxassetid://102042805216646",
	["message-square-reply"] = "rbxassetid://80170811456799",
	["message-square-text"] = "rbxassetid://94635966058642",
	["messages-circle"] = "rbxassetid://116324040442420",
	["messages-square"] = "rbxassetid://130540158348493",
	["metronome"] = "rbxassetid://95375029104947",
	["mic"] = "rbxassetid://71979225796861",
	["mic-off"] = "rbxassetid://84472306930294",
	["mic-vocal"] = "rbxassetid://80248251068659",
	["microchip"] = "rbxassetid://129731217315942",
	["microscope"] = "rbxassetid://84649836186252",
	["microwave"] = "rbxassetid://95474542603247",
	["midi-port"] = "rbxassetid://91459177225761",
	["milestone"] = "rbxassetid://78424572928840",
	["milk"] = "rbxassetid://100121519731934",
	["min"] = "rbxassetid://85650607503632",
	["minimize"] = "rbxassetid://93954469210175",
	["minimize-2"] = "rbxassetid://101140045474370",
	["minus"] = "rbxassetid://73284215293227",
	["mirror-round"] = "rbxassetid://103604242403037",
	["monitor"] = "rbxassetid://136083179409650",
	["monitor-check"] = "rbxassetid://99735039685717",
	["monitor-cog"] = "rbxassetid://89285518248895",
	["monitor-down"] = "rbxassetid://138906781433904",
	["monitor-pause"] = "rbxassetid://123970024585344",
	["monitor-play"] = "rbxassetid://101993491775913",
	["monitor-speaker"] = "rbxassetid://113396472021960",
	["monitor-up"] = "rbxassetid://123414635939645",
	["moon"] = "rbxassetid://90882363938707",
	["moon-star"] = "rbxassetid://101024073156864",
	["mop-sparkles"] = "rbxassetid://132285999088973",
	["motorbike"] = "rbxassetid://118629227410900",
	["mountain"] = "rbxassetid://139778268308948",
	["mouse"] = "rbxassetid://76037789142568",
	["mouse-left"] = "rbxassetid://96060971840080",
	["mouse-pointer"] = "rbxassetid://79988972958092",
	["mouse-pointer-2"] = "rbxassetid://135411936379957",
	["mouse-pointer-ban"] = "rbxassetid://101535459898122",
	["mouse-pointer-click"] = "rbxassetid://128663738763924",
	["move"] = "rbxassetid://103535486642025",
	["move-diagonal"] = "rbxassetid://107481621087851",
	["move-down"] = "rbxassetid://106478294570658",
	["move-down-right"] = "rbxassetid://74269052926227",
	["move-left"] = "rbxassetid://102427175177868",
	["move-up"] = "rbxassetid://86402262681776",
	["move-up-right"] = "rbxassetid://107273031937680",
	["music"] = "rbxassetid://107917201853777",
	["navigation"] = "rbxassetid://80120635990216",
	["navigation-2"] = "rbxassetid://96134923051721",
	["navigation-off"] = "rbxassetid://92264867712408",
	["netflix"] = "rbxassetid://88612633915477",
	["network"] = "rbxassetid://100105883992852",
	["newspaper"] = "rbxassetid://99455267198727",
	["nfc"] = "rbxassetid://135322725831456",
	["non-binary"] = "rbxassetid://102312879426614",
	["notebook"] = "rbxassetid://85786769662789",
	["notebook-pen"] = "rbxassetid://83059998932832",
	["notebook-text"] = "rbxassetid://99954641968129",
	["notepad-text-dashed"] = "rbxassetid://137479579645959",
	["nut"] = "rbxassetid://125936149715999",
	["nut-off"] = "rbxassetid://127528679051814",
	["octagon"] = "rbxassetid://124793819746756",
	["octagon-minus"] = "rbxassetid://135071098541844",
	["octagon-x"] = "rbxassetid://99738390242940",
	["omega"] = "rbxassetid://140361164988582",
	["option"] = "rbxassetid://126662693547523",
	["orbit"] = "rbxassetid://101654224633830",
	["origami"] = "rbxassetid://90392397093668",
	["package"] = "rbxassetid://70808040563321",
	["package-2"] = "rbxassetid://104524849004662",
	["package-check"] = "rbxassetid://131314919582512",
	["package-open"] = "rbxassetid://77960646754069",
	["package-plus"] = "rbxassetid://112444629264857",
	["package-search"] = "rbxassetid://88149698332921",
	["paint-bucket"] = "rbxassetid://119540270721903",
	["paintbrush"] = "rbxassetid://136960202295392",
	["paintbrush-vertical"] = "rbxassetid://96864226620487",
	["palette"] = "rbxassetid://88330131483473",
	["panel-bottom"] = "rbxassetid://132597929814107",
	["panel-bottom-inactive"] = "rbxassetid://109313843851562",
	["panel-left"] = "rbxassetid://118012453756391",
	["panel-left-inactive"] = "rbxassetid://73904583517727",
	["panel-left-right-dashed"] = "rbxassetid://114137248069678",
	["panel-right-close"] = "rbxassetid://128565803254797",
	["panel-right-open"] = "rbxassetid://89745777678395",
	["panel-top-bottom-dashed"] = "rbxassetid://78405788932179",
	["panel-top-inactive"] = "rbxassetid://136480177068715",
	["panels-left-bottom"] = "rbxassetid://92533215262060",
	["panels-top-bottom"] = "rbxassetid://137553907186107",
	["panels-top-left"] = "rbxassetid://92348222256240",
	["paperclip"] = "rbxassetid://134138352192673",
	["parasol"] = "rbxassetid://95674877185457",
	["parentheses"] = "rbxassetid://83203939116346",
	["parking-meter"] = "rbxassetid://134924700895754",
	["pause"] = "rbxassetid://138486480884743",
	["paw-print"] = "rbxassetid://101720595896885",
	["pc-case"] = "rbxassetid://97477997962835",
	["pen"] = "rbxassetid://84469396279676",
	["pen-off"] = "rbxassetid://85873487874890",
	["pencil"] = "rbxassetid://114393839512598",
	["pencil-line"] = "rbxassetid://86144556222081",
	["pencil-ruler"] = "rbxassetid://122168421720219",
	["pentagon"] = "rbxassetid://115251578259721",
	["percent"] = "rbxassetid://79973769711704",
	["perfume-bottle"] = "rbxassetid://89726051870622",
	["person-standing"] = "rbxassetid://72439236682307",
	["phone"] = "rbxassetid://116381459468308",
	["phone-forwarded"] = "rbxassetid://114203922981536",
	["phone-log"] = "rbxassetid://91272228257888",
	["phone-off"] = "rbxassetid://89037432994723",
	["pi"] = "rbxassetid://106301322940734",
	["piano"] = "rbxassetid://129742692593445",
	["pickaxe"] = "rbxassetid://86372985097131",
	["picture-in-picture"] = "rbxassetid://137001301971008",
	["pie-chart"] = "rbxassetid://102878058278097",
	["piggy-bank"] = "rbxassetid://94582854613665",
	["pilcrow"] = "rbxassetid://137074703236510",
	["pilcrow-left"] = "rbxassetid://74283136284028",
	["pin"] = "rbxassetid://89732112111788",
	["pipette"] = "rbxassetid://90344448206581",
	["pizza"] = "rbxassetid://81782080505323",
	["plane"] = "rbxassetid://79550585239400",
	["plane-landing"] = "rbxassetid://127126961364297",
	["plant-pot"] = "rbxassetid://138817967637727",
	["play"] = "rbxassetid://91870278489859",
	["play-off"] = "rbxassetid://77929864186513",
	["playing-cards"] = "rbxassetid://106266466111887",
	["plug"] = "rbxassetid://103159410485852",
	["plug-2"] = "rbxassetid://101288032939192",
	["plus"] = "rbxassetid://134686674330168",
	["pocket-knife"] = "rbxassetid://135621920357921",
	["podcast"] = "rbxassetid://111727901256648",
	["pointer"] = "rbxassetid://92968917664489",
	["pointer-off"] = "rbxassetid://140652998694632",
	["popcorn"] = "rbxassetid://127361808980114",
	["popsicle"] = "rbxassetid://115271896256073",
	["power"] = "rbxassetid://96759747793123",
	["power-off"] = "rbxassetid://115137256223459",
	["presentation"] = "rbxassetid://75921832843520",
	["printer"] = "rbxassetid://132247020770701",
	["printer-check"] = "rbxassetid://130419949970215",
	["projector"] = "rbxassetid://130683197593747",
	["proportions"] = "rbxassetid://75665630545309",
	["puzzle"] = "rbxassetid://73616547154133",
	["pyramid"] = "rbxassetid://79381754945945",
	["qr-code"] = "rbxassetid://116648573557659",
	["quote"] = "rbxassetid://84936742420504",
	["rabbit"] = "rbxassetid://70851893925086",
	["radar"] = "rbxassetid://77605037861191",
	["radiation"] = "rbxassetid://120119027700076",
	["radical"] = "rbxassetid://136004715349023",
	["radio"] = "rbxassetid://139867744312634",
	["radio-off"] = "rbxassetid://73528589033925",
	["radio-tower"] = "rbxassetid://128776861412555",
	["radius"] = "rbxassetid://100210387364406",
	["rainbow"] = "rbxassetid://110826842121149",
	["rat"] = "rbxassetid://106969095593198",
	["ratio"] = "rbxassetid://139670103744647",
	["receipt"] = "rbxassetid://139601228135367",
	["receipt-euro"] = "rbxassetid://140204477156219",
	["receipt-japanese-yen"] = "rbxassetid://121884819319931",
	["receipt-russian-ruble"] = "rbxassetid://109335867120640",
	["receipt-text"] = "rbxassetid://94360165336804",
	["rectangle-circle"] = "rbxassetid://98659338040658",
	["rectangle-goggles"] = "rbxassetid://91439995988264",
	["rectangle-vertical"] = "rbxassetid://74798177238205",
	["recycle"] = "rbxassetid://96542748602626",
	["redo"] = "rbxassetid://124650359567226",
	["redo-2"] = "rbxassetid://121721798665616",
	["refresh"] = "rbxassetid://98800121108540",
	["refresh-ccw"] = "rbxassetid://129004229870106",
	["refresh-ccw-dot"] = "rbxassetid://132901563447848",
	["refresh-cw"] = "rbxassetid://98516552938441",
	["refrigerator"] = "rbxassetid://134770621083349",
	["regex"] = "rbxassetid://136748303065987",
	["remove-formatting"] = "rbxassetid://135373024298065",
	["repeat"] = "rbxassetid://97528828969118",
	["repeat-2"] = "rbxassetid://120303385934094",
	["replace"] = "rbxassetid://109509388177727",
	["replace-all"] = "rbxassetid://76241056450118",
	["reply"] = "rbxassetid://123111620060490",
	["rewind"] = "rbxassetid://83247169264231",
	["ribbon"] = "rbxassetid://90130269639782",
	["road"] = "rbxassetid://81918478497432",
	["robot-vacuum"] = "rbxassetid://136409573890197",
	["rocket"] = "rbxassetid://80049282094240",
	["roller-coaster"] = "rbxassetid://132245722106469",
	["rotate-3-d"] = "rbxassetid://98308218474270",
	["rotate-ccw"] = "rbxassetid://102354191074235",
	["rotate-ccw-square"] = "rbxassetid://137770006961497",
	["rotate-cw-clock"] = "rbxassetid://106607591841527",
	["rotate-cw-square"] = "rbxassetid://105287292575454",
	["route"] = "rbxassetid://105411857256167",
	["router"] = "rbxassetid://116180044589325",
	["rows-2"] = "rbxassetid://93049835444906",
	["rss"] = "rbxassetid://92371758541998",
	["rugby-ball"] = "rbxassetid://71912119151354",
	["ruler"] = "rbxassetid://132022880159449",
	["sailboat"] = "rbxassetid://92200703691424",
	["salad"] = "rbxassetid://80294129194362",
	["sandwich"] = "rbxassetid://112642438034792",
	["satellite"] = "rbxassetid://84163807675786",
	["satellite-dish"] = "rbxassetid://128632074450392",
	["save"] = "rbxassetid://125831044245604",
	["save-all"] = "rbxassetid://117084708123701",
	["save-off"] = "rbxassetid://101349863046935",
	["save-plus"] = "rbxassetid://121479806438070",
	["scale"] = "rbxassetid://96106626634654",
	["scale-3-d"] = "rbxassetid://76274920465459",
	["scaling"] = "rbxassetid://76448087156572",
	["scan"] = "rbxassetid://109672950934872",
	["scan-box"] = "rbxassetid://109735924034829",
	["scan-eye"] = "rbxassetid://104463277735388",
	["scan-face"] = "rbxassetid://86460149857234",
	["scan-line"] = "rbxassetid://119049508446807",
	["school"] = "rbxassetid://106013612329988",
	["scissors"] = "rbxassetid://71668869730150",
	["scooter"] = "rbxassetid://99280712220974",
	["screen-share"] = "rbxassetid://124823016278410",
	["screen-share-off"] = "rbxassetid://126020098080741",
	["scroll"] = "rbxassetid://81706078779855",
	["scroll-text"] = "rbxassetid://74839146979848",
	["search"] = "rbxassetid://92235876975968",
	["search-code"] = "rbxassetid://71386417123320",
	["search-slash"] = "rbxassetid://91938050530887",
	["section"] = "rbxassetid://114830219068954",
	["send"] = "rbxassetid://112005740210993",
	["send-horizontal"] = "rbxassetid://133924671037187",
	["separator-horizontal"] = "rbxassetid://105323020821707",
	["server"] = "rbxassetid://94546658233639",
	["server-cog"] = "rbxassetid://107179337767713",
	["server-nas"] = "rbxassetid://125527114281066",
	["server-plus"] = "rbxassetid://140277161120319",
	["settings"] = "rbxassetid://107127587897937",
	["shapes"] = "rbxassetid://109339920638042",
	["share"] = "rbxassetid://128706483541378",
	["share-2"] = "rbxassetid://72299568019210",
	["sheet"] = "rbxassetid://121193302760902",
	["shell"] = "rbxassetid://120525594361564",
	["shelving-unit"] = "rbxassetid://117141488882472",
	["shield"] = "rbxassetid://118026060456989",
	["shield-alert"] = "rbxassetid://110503962322145",
	["shield-check"] = "rbxassetid://113004178808809",
	["shield-cog"] = "rbxassetid://98612318471400",
	["shield-cog-corner"] = "rbxassetid://90053361140968",
	["shield-half"] = "rbxassetid://138976130714555",
	["shield-house"] = "rbxassetid://120841939117306",
	["shield-lock"] = "rbxassetid://114216353752080",
	["shield-off"] = "rbxassetid://103908277824862",
	["shield-question-mark"] = "rbxassetid://125570053257076",
	["ship"] = "rbxassetid://113809220223654",
	["ship-cargo"] = "rbxassetid://107520885950640",
	["shirt"] = "rbxassetid://91731270778434",
	["shopping-bag"] = "rbxassetid://82933500140658",
	["shopping-basket"] = "rbxassetid://140621290861002",
	["shopping-cart"] = "rbxassetid://88685299908221",
	["shopping-cart-plus"] = "rbxassetid://108220000092450",
	["shovel"] = "rbxassetid://93924116209517",
	["shredder"] = "rbxassetid://126614558664762",
	["shrimp-off"] = "rbxassetid://102995313521889",
	["shrink"] = "rbxassetid://108483588542104",
	["shrub"] = "rbxassetid://121826155822745",
	["shuffle"] = "rbxassetid://126320590322200",
	["sigma"] = "rbxassetid://138463328876338",
	["signal"] = "rbxassetid://137492597866692",
	["signal-low"] = "rbxassetid://89922247858882",
	["signal-zero"] = "rbxassetid://70835919205407",
	["signature"] = "rbxassetid://74006071363549",
	["signpost"] = "rbxassetid://115460984178972",
	["siren"] = "rbxassetid://72455451731236",
	["siren-off"] = "rbxassetid://93304799919887",
	["skip-back"] = "rbxassetid://139579591307981",
	["skip-forward"] = "rbxassetid://119444974251506",
	["skull"] = "rbxassetid://115504394945904",
	["slash"] = "rbxassetid://136619989984884",
	["slice"] = "rbxassetid://109453108669771",
	["sliders-horizontal"] = "rbxassetid://139056783894432",
	["sliders-vertical"] = "rbxassetid://114751953305890",
	["smartphone"] = "rbxassetid://112513767091089",
	["smartphone-charging"] = "rbxassetid://91258855811175",
	["smartphone-user-round"] = "rbxassetid://112459792837331",
	["smile"] = "rbxassetid://118056658217421",
	["snail"] = "rbxassetid://101883355929442",
	["snowflake"] = "rbxassetid://110155593412847",
	["sofa"] = "rbxassetid://81162585710300",
	["solar-panel"] = "rbxassetid://95918106574345",
	["soup"] = "rbxassetid://96378711079617",
	["space"] = "rbxassetid://98379933748459",
	["spade"] = "rbxassetid://98205336309088",
	["sparkle"] = "rbxassetid://108270340062929",
	["sparkles"] = "rbxassetid://111244852594385",
	["speaker"] = "rbxassetid://115610865176105",
	["spell-check-2"] = "rbxassetid://115245872480368",
	["spline"] = "rbxassetid://130202614377544",
	["spline-pointer"] = "rbxassetid://95736925494457",
	["split"] = "rbxassetid://114267840572453",
	["spray-can"] = "rbxassetid://137136312989937",
	["sprout"] = "rbxassetid://131265988985288",
	["square"] = "rbxassetid://106563278151858",
	["square-arrow-down"] = "rbxassetid://117798763934453",
	["square-arrow-down-right"] = "rbxassetid://113254818428093",
	["square-arrow-out-down-left"] = "rbxassetid://106047122030497",
	["square-arrow-out-up-left"] = "rbxassetid://73519902768548",
	["square-arrow-right"] = "rbxassetid://125342610139313",
	["square-arrow-right-exit"] = "rbxassetid://132300972293234",
	["square-arrow-up-left"] = "rbxassetid://95668976514215",
	["square-asterisk"] = "rbxassetid://111413185137019",
	["square-chart-gantt"] = "rbxassetid://81997210359196",
	["square-check"] = "rbxassetid://97750998222102",
	["square-chevron-down"] = "rbxassetid://84529082666094",
	["square-chevron-right"] = "rbxassetid://124934169867878",
	["square-chevrons-down"] = "rbxassetid://116272332933156",
	["square-chevrons-right"] = "rbxassetid://101881241962142",
	["square-code"] = "rbxassetid://113547013813084",
	["square-dashed"] = "rbxassetid://132707009406130",
	["square-dashed-bottom-code"] = "rbxassetid://95345043442448",
	["square-dashed-mouse-pointer"] = "rbxassetid://111915570410256",
	["square-dashed-text"] = "rbxassetid://79828306956534",
	["square-dashed-x"] = "rbxassetid://120087514177417",
	["square-dimensions"] = "rbxassetid://114750156117495",
	["square-dot"] = "rbxassetid://86210271900832",
	["square-exclamation-point"] = "rbxassetid://81966157144297",
	["square-kanban"] = "rbxassetid://140573867465188",
	["square-library"] = "rbxassetid://101138143050197",
	["square-minus"] = "rbxassetid://90709781279941",
	["square-off"] = "rbxassetid://94781345913635",
	["square-padding-bottom"] = "rbxassetid://80005870693205",
	["square-padding-left"] = "rbxassetid://110081454856745",
	["square-padding-top"] = "rbxassetid://80975860592747",
	["square-pause"] = "rbxassetid://87290801941244",
	["square-percent"] = "rbxassetid://114350530812381",
	["square-pilcrow"] = "rbxassetid://130754148659332",
	["square-plus"] = "rbxassetid://104474878096828",
	["square-radical"] = "rbxassetid://130155400650892",
	["square-round-corner"] = "rbxassetid://93757814633686",
	["square-sigma"] = "rbxassetid://134341293464449",
	["square-sparkles"] = "rbxassetid://115804862345445",
	["square-split-vertical"] = "rbxassetid://136575373652368",
	["square-stack"] = "rbxassetid://122287707593432",
	["square-stop"] = "rbxassetid://72842514043902",
	["square-text"] = "rbxassetid://118073801311767",
	["square-user-round"] = "rbxassetid://136005531426514",
	["square-x"] = "rbxassetid://136452913976889",
	["squares-intersect"] = "rbxassetid://83643841840402",
	["squares-unite"] = "rbxassetid://98846120984237",
	["squircle"] = "rbxassetid://128326433936820",
	["squirrel"] = "rbxassetid://109085393674649",
	["stamp"] = "rbxassetid://132562864477033",
	["star"] = "rbxassetid://97840425603091",
	["star-check"] = "rbxassetid://138590492018848",
	["star-minus"] = "rbxassetid://70604314719905",
	["star-plus"] = "rbxassetid://80817815737708",
	["step-back"] = "rbxassetid://123059605549656",
	["stethoscope"] = "rbxassetid://119502281015704",
	["sticker"] = "rbxassetid://115089523666602",
	["sticky-note"] = "rbxassetid://120984987437120",
	["sticky-note-check"] = "rbxassetid://136255506437505",
	["sticky-note-off"] = "rbxassetid://138697180527794",
	["sticky-note-x"] = "rbxassetid://130159981269900",
	["sticky-notes"] = "rbxassetid://111380974741385",
	["store"] = "rbxassetid://99306635365353",
	["stretch-horizontal"] = "rbxassetid://70438284462122",
	["strikethrough"] = "rbxassetid://86676118329832",
	["subscript"] = "rbxassetid://132053964342282",
	["summary"] = "rbxassetid://112121588749605",
	["sun"] = "rbxassetid://133073268377990",
	["sun-medium"] = "rbxassetid://84453522265940",
	["sun-snow"] = "rbxassetid://118081876588549",
	["sunrise"] = "rbxassetid://88873011535799",
	["sunset"] = "rbxassetid://110027209856629",
	["superscript"] = "rbxassetid://138938752474089",
	["swiss-franc"] = "rbxassetid://132055762075908",
	["sword"] = "rbxassetid://106927353156630",
	["swords"] = "rbxassetid://96861126351000",
	["table"] = "rbxassetid://98052839553632",
	["table-2"] = "rbxassetid://71327491632446",
	["table-cells-split"] = "rbxassetid://104423276909604",
	["table-of-contents"] = "rbxassetid://100665910177680",
	["table-rows-split"] = "rbxassetid://116923963610683",
	["tablet"] = "rbxassetid://108681665836771",
	["tablets"] = "rbxassetid://82047420301384",
	["tag"] = "rbxassetid://138244821789151",
	["tag-plus"] = "rbxassetid://98836221332279",
	["tags"] = "rbxassetid://99862259680249",
	["tally-1"] = "rbxassetid://140249616768442",
	["tally-3"] = "rbxassetid://72068503919259",
	["tally-5"] = "rbxassetid://95608603492122",
	["tangent"] = "rbxassetid://133742027821785",
	["target"] = "rbxassetid://121767269149303",
	["telescope"] = "rbxassetid://99516284183308",
	["tent"] = "rbxassetid://82869277470904",
	["terminal"] = "rbxassetid://128550645227371",
	["text"] = "rbxassetid://101393329183121",
	["text-align-justify-end"] = "rbxassetid://114028749582427",
	["text-align-justify-start"] = "rbxassetid://78236236221944",
	["text-cursor"] = "rbxassetid://103079050000186",
	["text-initial"] = "rbxassetid://88793896520007",
	["text-search"] = "rbxassetid://119867484436418",
	["theater"] = "rbxassetid://131761145544303",
	["thermometer"] = "rbxassetid://140077067578827",
	["thermometer-snowflake"] = "rbxassetid://73967236615315",
	["thumbs-down"] = "rbxassetid://131432725196630",
	["thumbs-up"] = "rbxassetid://130608505747404",
	["tic-tac-toe"] = "rbxassetid://121812538124486",
	["ticket"] = "rbxassetid://116772047592516",
	["ticket-minus"] = "rbxassetid://134776491278645",
	["ticket-plus"] = "rbxassetid://132445510622755",
	["ticket-x"] = "rbxassetid://95281531670245",
	["tickets"] = "rbxassetid://71396397526144",
	["timeline"] = "rbxassetid://83797806155455",
	["timer"] = "rbxassetid://107976868521154",
	["timer-reset"] = "rbxassetid://84621158499988",
	["toggle-left"] = "rbxassetid://107456165208207",
	["toggle-right"] = "rbxassetid://139240012042416",
	["toilet"] = "rbxassetid://130385340244950",
	["tool-case"] = "rbxassetid://128604457820732",
	["toothbrush"] = "rbxassetid://75036137127851",
	["tornado"] = "rbxassetid://89690838794429",
	["torus"] = "rbxassetid://118605960155074",
	["touchpad"] = "rbxassetid://95331252208192",
	["touchpad-off"] = "rbxassetid://120026305415610",
	["tower-control"] = "rbxassetid://83103129720858",
	["tractor"] = "rbxassetid://100723119349208",
	["traffic-cone"] = "rbxassetid://122798687473462",
	["train-front"] = "rbxassetid://110361341587755",
	["train-track"] = "rbxassetid://106216410188513",
	["tram-front"] = "rbxassetid://128755370100322",
	["trash"] = "rbxassetid://131522121867499",
	["trash-2"] = "rbxassetid://125499833744432",
	["trash-off"] = "rbxassetid://98881215835677",
	["tree-palm"] = "rbxassetid://94108791007573",
	["trees"] = "rbxassetid://105007678603715",
	["trending-down"] = "rbxassetid://88139816939940",
	["trending-up"] = "rbxassetid://71348608042685",
	["trending-up-down"] = "rbxassetid://106887830000606",
	["triangle"] = "rbxassetid://109658057917446",
	["triangle-alert"] = "rbxassetid://103933916315065",
	["triangle-right"] = "rbxassetid://99956722358092",
	["triangles-centerline-dashed-vertical"] = "rbxassetid://118419679958444",
	["trophy"] = "rbxassetid://115978771993339",
	["truck"] = "rbxassetid://139662246789456",
	["turntable"] = "rbxassetid://94569085905086",
	["turtle"] = "rbxassetid://136169082922765",
	["tv"] = "rbxassetid://137678622602095",
	["tv-minimal-play"] = "rbxassetid://107839713789170",
	["type"] = "rbxassetid://127324920888539",
	["umbrella"] = "rbxassetid://117564189852123",
	["umbrella-off"] = "rbxassetid://95634016550546",
	["underline"] = "rbxassetid://137915909856143",
	["undo"] = "rbxassetid://107293313418086",
	["undo-2"] = "rbxassetid://91921819882471",
	["unfold-horizontal"] = "rbxassetid://89059832514303",
	["ungroup"] = "rbxassetid://135706819287252",
	["university"] = "rbxassetid://125239434702456",
	["unlink"] = "rbxassetid://108826500103947",
	["unlink-2"] = "rbxassetid://130995193775535",
	["unlock"] = "rbxassetid://89372202371850",
	["unplug"] = "rbxassetid://92360624656548",
	["upload"] = "rbxassetid://86023226727319",
	["usb"] = "rbxassetid://122804572325370",
	["user"] = "rbxassetid://93274002075202",
	["user-check"] = "rbxassetid://85387394342872",
	["user-circle"] = "rbxassetid://90466007043907",
	["user-cog"] = "rbxassetid://128454190832023",
	["user-group"] = "rbxassetid://80887116215108",
	["user-pen"] = "rbxassetid://127198827992083",
	["user-plus"] = "rbxassetid://116052702353478",
	["user-round-arrow-left"] = "rbxassetid://106934134575247",
	["user-round-cog"] = "rbxassetid://74963489818808",
	["user-round-group"] = "rbxassetid://93199112052365",
	["user-round-minus"] = "rbxassetid://103439324847252",
	["user-round-plus"] = "rbxassetid://119027934458409",
	["user-round-shield"] = "rbxassetid://99382070594431",
	["user-round-x"] = "rbxassetid://109869289027260",
	["user-shield"] = "rbxassetid://134537948572897",
	["user-x"] = "rbxassetid://134217198876817",
	["users"] = "rbxassetid://91378780144071",
	["users-collaboration"] = "rbxassetid://125833279269745",
	["users-round-collaboration"] = "rbxassetid://139471071113740",
	["utensils"] = "rbxassetid://130070224866136",
	["van"] = "rbxassetid://115540457569985",
	["variable"] = "rbxassetid://87635846743618",
	["vault"] = "rbxassetid://102502938478197",
	["vector-square"] = "rbxassetid://133322071010059",
	["vegan"] = "rbxassetid://139618904012406",
	["venus"] = "rbxassetid://128897313220332",
	["vibrate"] = "rbxassetid://104388319921667",
	["vibrate-off"] = "rbxassetid://102227234517704",
	["video"] = "rbxassetid://71440411244495",
	["videotape"] = "rbxassetid://129937539308186",
	["view"] = "rbxassetid://125270839291066",
	["virus"] = "rbxassetid://121922908966473",
	["voicemail"] = "rbxassetid://127618338629956",
	["volleyball"] = "rbxassetid://125313725323358",
	["volume"] = "rbxassetid://73184127215691",
	["volume-1"] = "rbxassetid://112668210923195",
	["volume-2"] = "rbxassetid://118326457372237",
	["volume-off"] = "rbxassetid://100731766630586",
	["volume-x"] = "rbxassetid://85056517883394",
	["vote"] = "rbxassetid://112604212049663",
	["wallet"] = "rbxassetid://124947853325021",
	["wallet-minimal"] = "rbxassetid://90297960980687",
	["wallpaper"] = "rbxassetid://77530812546602",
	["wand"] = "rbxassetid://106542655413899",
	["wand-sparkles"] = "rbxassetid://94126167073405",
	["warehouse"] = "rbxassetid://127267717486473",
	["watch"] = "rbxassetid://135473279342681",
	["waves"] = "rbxassetid://87854975300485",
	["waves-arrow-down"] = "rbxassetid://83098789515304",
	["waves-ladder"] = "rbxassetid://119518591610832",
	["waves-vertical"] = "rbxassetid://139348313492835",
	["waypoints"] = "rbxassetid://94005143123885",
	["webcam"] = "rbxassetid://129724233271161",
	["webhook"] = "rbxassetid://125593147396152",
	["webhook-off"] = "rbxassetid://70559674551136",
	["weight"] = "rbxassetid://73473911970856",
	["wheat"] = "rbxassetid://79398114816115",
	["wheat-off"] = "rbxassetid://120556475720694",
	["whole-word"] = "rbxassetid://102475525041169",
	["wifi"] = "rbxassetid://75873756419124",
	["wifi-high"] = "rbxassetid://72557789173031",
	["wifi-low"] = "rbxassetid://116766189819733",
	["wifi-pen"] = "rbxassetid://130805293611539",
	["wifi-zero"] = "rbxassetid://108717836578431",
	["wind"] = "rbxassetid://125784799689748",
	["wind-arrow-up"] = "rbxassetid://130454473656370",
	["workflow"] = "rbxassetid://123909872923844",
	["worm"] = "rbxassetid://94169604614817",
	["wrench"] = "rbxassetid://104489382753799",
	["wrench-off"] = "rbxassetid://135301105430435",
	["x"] = "rbxassetid://96397817290804",
	["zap"] = "rbxassetid://125793680758204",
	["zap-off"] = "rbxassetid://109605333859843",
	["zodiac-aries"] = "rbxassetid://89992929661686",
	["zodiac-capricorn"] = "rbxassetid://135133113999129",
	["zodiac-leo"] = "rbxassetid://123371987872005",
	["zodiac-ophiuchus"] = "rbxassetid://98287342870598",
	["zodiac-sagittarius"] = "rbxassetid://127170950409677",
	["zodiac-taurus"] = "rbxassetid://91190830769306",
	["zoom-in"] = "rbxassetid://95368645283001",
	["zoom-out"] = "rbxassetid://84560435649370",
}
local bakedsprites = {
	["alert"] = { 16898613869, 48, 48, 967, 0 },
	["arrow-big-up"] = { 16898612629, 48, 48, 918, 306 },
	["arrow-right"] = { 16898612629, 48, 48, 453, 820 },
	["arrow-up"] = { 16898612629, 48, 48, 967, 355 },
	["award"] = { 16898612629, 48, 48, 918, 661 },
	["backpack"] = { 16898612629, 48, 48, 710, 869 },
	["badge"] = { 16898612629, 48, 48, 918, 661 },
	["ban"] = { 16898612629, 48, 48, 196, 967 },
	["bar-chart-3"] = { 16898612629, 48, 48, 918, 759 },
	["bell"] = { 16898612819, 48, 48, 820, 257 },
	["bolt"] = { 16898613869, 48, 48, 918, 906 },
	["box"] = { 16898612819, 48, 48, 771, 196 },
	["box-select"] = { 16898612819, 48, 48, 820, 147 },
	["branch"] = { 16898613353, 48, 48, 918, 906 },
	["brick-wall"] = { 16898612819, 48, 48, 918, 306 },
	["chart"] = { 16898612629, 48, 48, 918, 759 },
	["check"] = { 16898612819, 48, 48, 710, 869 },
	["chevron-down"] = { 16898612819, 48, 48, 196, 918 },
	["chevron-left"] = { 16898612819, 48, 48, 404, 967 },
	["chevron-right"] = { 16898612819, 48, 48, 869, 759 },
	["chevron-up"] = { 16898612819, 48, 48, 710, 918 },
	["chevrons-right"] = { 16898612819, 48, 48, 967, 710 },
	["circle-dollar-sign"] = { 16898613044, 48, 48, 257, 771 },
	["clock"] = { 16898613044, 48, 48, 771, 661 },
	["close"] = { 16898613869, 48, 48, 869, 906 },
	["cloud"] = { 16898613044, 48, 48, 918, 306 },
	["code"] = { 16898613044, 48, 48, 355, 869 },
	["coin"] = { 16898613044, 48, 48, 257, 771 },
	["crosshair"] = { 16898613044, 48, 48, 453, 869 },
	["crown"] = { 16898613044, 48, 48, 404, 918 },
	["cube"] = { 16898612819, 48, 48, 771, 196 },
	["dots"] = { 16898613353, 48, 48, 771, 49 },
	["ellipsis"] = { 16898613353, 48, 48, 771, 49 },
	["esp"] = { 16898613699, 48, 48, 771, 857 },
	["expand"] = { 16898613613, 48, 48, 771, 563 },
	["eye"] = { 16898613353, 48, 48, 771, 563 },
	["filter"] = { 16898613353, 48, 48, 612, 869 },
	["flame"] = { 16898613353, 48, 48, 967, 306 },
	["flask"] = { 16898613353, 48, 48, 453, 820 },
	["flask-conical"] = { 16898613353, 48, 48, 453, 820 },
	["fly"] = { 16898613699, 48, 48, 98, 820 },
	["folder"] = { 16898613353, 48, 48, 404, 967 },
	["gauge"] = { 16898613353, 48, 48, 771, 955 },
	["gear"] = { 16898613777, 48, 48, 771, 257 },
	["ghost"] = { 16898613353, 48, 48, 869, 906 },
	["git-branch"] = { 16898613353, 48, 48, 918, 906 },
	["grid"] = { 16898613509, 48, 48, 918, 404 },
	["heart"] = { 16898613509, 48, 48, 661, 771 },
	["hitbox"] = { 16898613699, 48, 48, 967, 196 },
	["hourglass"] = { 16898613509, 48, 48, 49, 918 },
	["info"] = { 16898613509, 48, 48, 612, 869 },
	["jump"] = { 16898612629, 48, 48, 918, 306 },
	["keyboard"] = { 16898613509, 48, 48, 453, 820 },
	["layers"] = { 16898613509, 48, 48, 98, 967 },
	["layout-grid"] = { 16898613509, 48, 48, 918, 404 },
	["link"] = { 16898613509, 48, 48, 918, 453 },
	["locate-fixed"] = { 16898613509, 48, 48, 967, 759 },
	["lock"] = { 16898613509, 48, 48, 918, 857 },
	["log-out"] = { 16898613509, 48, 48, 820, 955 },
	["logout"] = { 16898613509, 48, 48, 820, 955 },
	["magnet"] = { 16898613509, 48, 48, 967, 906 },
	["map-pin"] = { 16898613613, 48, 48, 820, 257 },
	["maximize"] = { 16898613613, 48, 48, 771, 563 },
	["minus"] = { 16898613613, 48, 48, 771, 196 },
	["noclip"] = { 16898612819, 48, 48, 820, 147 },
	["orbit"] = { 16898613613, 48, 48, 967, 612 },
	["palette"] = { 16898613613, 48, 48, 453, 918 },
	["pin"] = { 16898613613, 48, 48, 820, 257 },
	["plane"] = { 16898613699, 48, 48, 98, 820 },
	["plus"] = { 16898613699, 48, 48, 257, 918 },
	["power"] = { 16898613699, 48, 48, 820, 147 },
	["radar"] = { 16898613699, 48, 48, 820, 404 },
	["refresh"] = { 16898613699, 48, 48, 404, 869 },
	["refresh-cw"] = { 16898613699, 48, 48, 404, 869 },
	["scan"] = { 16898613699, 48, 48, 967, 196 },
	["scan-line"] = { 16898613699, 48, 48, 771, 857 },
	["search"] = { 16898613699, 48, 48, 918, 857 },
	["settings"] = { 16898613777, 48, 48, 771, 257 },
	["shield"] = { 16898613777, 48, 48, 869, 0 },
	["signal"] = { 16898613777, 48, 48, 918, 0 },
	["skull"] = { 16898613777, 48, 48, 49, 869 },
	["sliders"] = { 16898613777, 48, 48, 820, 355 },
	["sliders-horizontal"] = { 16898613777, 48, 48, 820, 355 },
	["sparkle"] = { 16898613777, 48, 48, 918, 49 },
	["sparkles"] = { 16898613777, 48, 48, 918, 49 },
	["star"] = { 16898613777, 48, 48, 967, 147 },
	["swords"] = { 16898613777, 48, 48, 967, 759 },
	["target"] = { 16898613044, 48, 48, 453, 869 },
	["teleport"] = { 16898613869, 48, 48, 771, 857 },
	["tracer"] = { 16898613509, 48, 48, 967, 759 },
	["triangle-alert"] = { 16898613869, 48, 48, 967, 0 },
	["user"] = { 16898613869, 48, 48, 661, 869 },
	["users"] = { 16898613869, 48, 48, 967, 98 },
	["wall"] = { 16898612819, 48, 48, 918, 306 },
	["wand"] = { 16898613869, 48, 48, 453, 918 },
	["wand-sparkles"] = { 16898613869, 48, 48, 453, 918 },
	["waypoints"] = { 16898613869, 48, 48, 771, 857 },
	["x"] = { 16898613869, 48, 48, 869, 906 },
	["zap"] = { 16898613869, 48, 48, 918, 906 },
}
local lucidesprites = {
	["a-arrow-down"] = { 16898612629, 771, 0 },
	["a-arrow-up"] = { 16898612629, 0, 771 },
	["a-large-small"] = { 16898612629, 771, 257 },
	["accessibility"] = { 16898612629, 257, 771 },
	["activity"] = { 16898612629, 514, 771 },
	["activity-square"] = { 16898612629, 771, 514 },
	["air-vent"] = { 16898612629, 820, 0 },
	["airplay"] = { 16898612629, 771, 49 },
	["alarm-check"] = { 16898612629, 49, 771 },
	["alarm-clock"] = { 16898612629, 257, 820 },
	["alarm-clock-check"] = { 16898612629, 0, 820 },
	["alarm-clock-minus"] = { 16898612629, 820, 257 },
	["alarm-clock-off"] = { 16898612629, 771, 306 },
	["alarm-clock-plus"] = { 16898612629, 306, 771 },
	["alarm-minus"] = { 16898612629, 820, 514 },
	["alarm-plus"] = { 16898612629, 771, 563 },
	["alarm-smoke"] = { 16898612629, 563, 771 },
	["album"] = { 16898612629, 514, 820 },
	["alert-circle"] = { 16898612629, 869, 0 },
	["alert-octagon"] = { 16898612629, 820, 49 },
	["alert-triangle"] = { 16898612629, 771, 98 },
	["align-center"] = { 16898612629, 0, 869 },
	["align-center-horizontal"] = { 16898612629, 98, 771 },
	["align-center-vertical"] = { 16898612629, 49, 820 },
	["align-end-horizontal"] = { 16898612629, 869, 257 },
	["align-end-vertical"] = { 16898612629, 820, 306 },
	["align-horizontal-distribute-center"] = { 16898612629, 771, 355 },
	["align-horizontal-distribute-end"] = { 16898612629, 355, 771 },
	["align-horizontal-distribute-start"] = { 16898612629, 306, 820 },
	["align-horizontal-justify-center"] = { 16898612629, 257, 869 },
	["align-horizontal-justify-end"] = { 16898612629, 869, 514 },
	["align-horizontal-justify-start"] = { 16898612629, 820, 563 },
	["align-horizontal-space-around"] = { 16898612629, 771, 612 },
	["align-horizontal-space-between"] = { 16898612629, 612, 771 },
	["align-justify"] = { 16898612629, 563, 820 },
	["align-left"] = { 16898612629, 514, 869 },
	["align-right"] = { 16898612629, 918, 0 },
	["align-start-horizontal"] = { 16898612629, 869, 49 },
	["align-start-vertical"] = { 16898612629, 820, 98 },
	["align-vertical-distribute-center"] = { 16898612629, 771, 147 },
	["align-vertical-distribute-end"] = { 16898612629, 147, 771 },
	["align-vertical-distribute-start"] = { 16898612629, 98, 820 },
	["align-vertical-justify-center"] = { 16898612629, 49, 869 },
	["align-vertical-justify-end"] = { 16898612629, 0, 918 },
	["align-vertical-justify-start"] = { 16898612629, 918, 257 },
	["align-vertical-space-around"] = { 16898612629, 869, 306 },
	["align-vertical-space-between"] = { 16898612629, 820, 355 },
	["ambulance"] = { 16898612629, 771, 404 },
	["ampersand"] = { 16898612629, 404, 771 },
	["ampersands"] = { 16898612629, 355, 820 },
	["anchor"] = { 16898612629, 306, 869 },
	["angry"] = { 16898612629, 257, 918 },
	["annoyed"] = { 16898612629, 918, 514 },
	["antenna"] = { 16898612629, 869, 563 },
	["anvil"] = { 16898612629, 820, 612 },
	["aperture"] = { 16898612629, 771, 661 },
	["app-window"] = { 16898612629, 612, 820 },
	["app-window-mac"] = { 16898612629, 661, 771 },
	["apple"] = { 16898612629, 563, 869 },
	["archive"] = { 16898612629, 918, 49 },
	["archive-restore"] = { 16898612629, 514, 918 },
	["archive-x"] = { 16898612629, 967, 0 },
	["area-chart"] = { 16898612629, 869, 98 },
	["armchair"] = { 16898612629, 820, 147 },
	["arrow-big-down"] = { 16898612629, 196, 771 },
	["arrow-big-down-dash"] = { 16898612629, 771, 196 },
	["arrow-big-left"] = { 16898612629, 98, 869 },
	["arrow-big-left-dash"] = { 16898612629, 147, 820 },
	["arrow-big-right"] = { 16898612629, 0, 967 },
	["arrow-big-right-dash"] = { 16898612629, 49, 918 },
	["arrow-big-up"] = { 16898612629, 918, 306 },
	["arrow-big-up-dash"] = { 16898612629, 967, 257 },
	["arrow-down"] = { 16898612629, 967, 49 },
	["arrow-down-0-1"] = { 16898612629, 869, 355 },
	["arrow-down-1-0"] = { 16898612629, 820, 404 },
	["arrow-down-a-z"] = { 16898612629, 771, 453 },
	["arrow-down-circle"] = { 16898612629, 453, 771 },
	["arrow-down-from-line"] = { 16898612629, 404, 820 },
	["arrow-down-left"] = { 16898612629, 257, 967 },
	["arrow-down-left-from-circle"] = { 16898612629, 355, 869 },
	["arrow-down-left-square"] = { 16898612629, 306, 918 },
	["arrow-down-narrow-wide"] = { 16898612629, 967, 514 },
	["arrow-down-right"] = { 16898612629, 820, 661 },
	["arrow-down-right-from-circle"] = { 16898612629, 918, 563 },
	["arrow-down-right-square"] = { 16898612629, 869, 612 },
	["arrow-down-square"] = { 16898612629, 771, 710 },
	["arrow-down-to-dot"] = { 16898612629, 710, 771 },
	["arrow-down-to-line"] = { 16898612629, 661, 820 },
	["arrow-down-up"] = { 16898612629, 612, 869 },
	["arrow-down-wide-narrow"] = { 16898612629, 563, 918 },
	["arrow-down-z-a"] = { 16898612629, 514, 967 },
	["arrow-left"] = { 16898612629, 98, 918 },
	["arrow-left-circle"] = { 16898612629, 918, 98 },
	["arrow-left-from-line"] = { 16898612629, 869, 147 },
	["arrow-left-right"] = { 16898612629, 820, 196 },
	["arrow-left-square"] = { 16898612629, 196, 820 },
	["arrow-left-to-line"] = { 16898612629, 147, 869 },
	["arrow-right"] = { 16898612629, 453, 820 },
	["arrow-right-circle"] = { 16898612629, 49, 967 },
	["arrow-right-from-line"] = { 16898612629, 967, 306 },
	["arrow-right-left"] = { 16898612629, 918, 355 },
	["arrow-right-square"] = { 16898612629, 869, 404 },
	["arrow-right-to-line"] = { 16898612629, 820, 453 },
	["arrow-up"] = { 16898612629, 967, 355 },
	["arrow-up-0-1"] = { 16898612629, 404, 869 },
	["arrow-up-1-0"] = { 16898612629, 355, 918 },
	["arrow-up-a-z"] = { 16898612629, 306, 967 },
	["arrow-up-circle"] = { 16898612629, 967, 563 },
	["arrow-up-down"] = { 16898612629, 918, 612 },
	["arrow-up-from-dot"] = { 16898612629, 869, 661 },
	["arrow-up-from-line"] = { 16898612629, 820, 710 },
	["arrow-up-left"] = { 16898612629, 661, 869 },
	["arrow-up-left-from-circle"] = { 16898612629, 771, 759 },
	["arrow-up-left-square"] = { 16898612629, 710, 820 },
	["arrow-up-narrow-wide"] = { 16898612629, 612, 918 },
	["arrow-up-right"] = { 16898612629, 918, 147 },
	["arrow-up-right-from-circle"] = { 16898612629, 563, 967 },
	["arrow-up-right-square"] = { 16898612629, 967, 98 },
	["arrow-up-square"] = { 16898612629, 869, 196 },
	["arrow-up-to-line"] = { 16898612629, 196, 869 },
	["arrow-up-wide-narrow"] = { 16898612629, 147, 918 },
	["arrow-up-z-a"] = { 16898612629, 98, 967 },
	["arrows-up-from-line"] = { 16898612629, 918, 404 },
	["asterisk"] = { 16898612629, 869, 453 },
	["at-sign"] = { 16898612629, 453, 869 },
	["atom"] = { 16898612629, 404, 918 },
	["audio-lines"] = { 16898612629, 355, 967 },
	["audio-waveform"] = { 16898612629, 967, 612 },
	["award"] = { 16898612629, 918, 661 },
	["axe"] = { 16898612629, 869, 710 },
	["axis-3d"] = { 16898612629, 820, 759 },
	["baby"] = { 16898612629, 771, 808 },
	["backpack"] = { 16898612629, 710, 869 },
	["badge"] = { 16898612629, 661, 967 },
	["badge-alert"] = { 16898612629, 661, 918 },
	["badge-cent"] = { 16898612629, 612, 967 },
	["badge-check"] = { 16898612629, 967, 147 },
	["badge-dollar-sign"] = { 16898612629, 918, 196 },
	["badge-euro"] = { 16898612629, 196, 918 },
	["badge-help"] = { 16898612629, 147, 967 },
	["badge-indian-rupee"] = { 16898612629, 967, 404 },
	["badge-info"] = { 16898612629, 918, 453 },
	["badge-japanese-yen"] = { 16898612629, 453, 918 },
	["badge-minus"] = { 16898612629, 404, 967 },
	["badge-percent"] = { 16898612629, 967, 661 },
	["badge-plus"] = { 16898612629, 918, 710 },
	["badge-pound-sterling"] = { 16898612629, 869, 759 },
	["badge-russian-ruble"] = { 16898612629, 820, 808 },
	["badge-swiss-franc"] = { 16898612629, 771, 857 },
	["badge-x"] = { 16898612629, 710, 918 },
	["baggage-claim"] = { 16898612629, 967, 196 },
	["ban"] = { 16898612629, 196, 967 },
	["banana"] = { 16898612629, 967, 453 },
	["banknote"] = { 16898612629, 453, 967 },
	["bar-chart"] = { 16898612629, 967, 759 },
	["bar-chart-2"] = { 16898612629, 967, 710 },
	["bar-chart-3"] = { 16898612629, 918, 759 },
	["bar-chart-4"] = { 16898612629, 869, 808 },
	["bar-chart-big"] = { 16898612629, 820, 857 },
	["bar-chart-horizontal"] = { 16898612629, 710, 967 },
	["bar-chart-horizontal-big"] = { 16898612629, 771, 906 },
	["barcode"] = { 16898612629, 918, 808 },
	["baseline"] = { 16898612629, 869, 857 },
	["bath"] = { 16898612629, 820, 906 },
	["battery"] = { 16898612629, 967, 857 },
	["battery-charging"] = { 16898612629, 771, 955 },
	["battery-full"] = { 16898612629, 967, 808 },
	["battery-low"] = { 16898612629, 918, 857 },
	["battery-medium"] = { 16898612629, 869, 906 },
	["battery-warning"] = { 16898612629, 820, 955 },
	["beaker"] = { 16898612629, 918, 906 },
	["bean"] = { 16898612629, 967, 906 },
	["bean-off"] = { 16898612629, 869, 955 },
	["bed"] = { 16898612819, 771, 0 },
	["bed-double"] = { 16898612629, 918, 955 },
	["bed-single"] = { 16898612629, 967, 955 },
	["beef"] = { 16898612819, 0, 771 },
	["beer"] = { 16898612819, 257, 771 },
	["beer-off"] = { 16898612819, 771, 257 },
	["bell"] = { 16898612819, 820, 257 },
	["bell-dot"] = { 16898612819, 771, 514 },
	["bell-electric"] = { 16898612819, 514, 771 },
	["bell-minus"] = { 16898612819, 820, 0 },
	["bell-off"] = { 16898612819, 771, 49 },
	["bell-plus"] = { 16898612819, 49, 771 },
	["bell-ring"] = { 16898612819, 0, 820 },
	["between-horizontal-end"] = { 16898612819, 771, 306 },
	["between-horizontal-start"] = { 16898612819, 306, 771 },
	["between-vertical-end"] = { 16898612819, 257, 820 },
	["between-vertical-start"] = { 16898612819, 820, 514 },
	["bike"] = { 16898612819, 771, 563 },
	["binary"] = { 16898612819, 563, 771 },
	["biohazard"] = { 16898612819, 514, 820 },
	["bird"] = { 16898612819, 869, 0 },
	["bitcoin"] = { 16898612819, 820, 49 },
	["blend"] = { 16898612819, 771, 98 },
	["blinds"] = { 16898612819, 98, 771 },
	["blocks"] = { 16898612819, 49, 820 },
	["bluetooth"] = { 16898612819, 771, 355 },
	["bluetooth-connected"] = { 16898612819, 0, 869 },
	["bluetooth-off"] = { 16898612819, 869, 257 },
	["bluetooth-searching"] = { 16898612819, 820, 306 },
	["bold"] = { 16898612819, 355, 771 },
	["bolt"] = { 16898612819, 306, 820 },
	["bomb"] = { 16898612819, 257, 869 },
	["bone"] = { 16898612819, 869, 514 },
	["book"] = { 16898612819, 820, 612 },
	["book-a"] = { 16898612819, 820, 563 },
	["book-audio"] = { 16898612819, 771, 612 },
	["book-check"] = { 16898612819, 612, 771 },
	["book-copy"] = { 16898612819, 563, 820 },
	["book-dashed"] = { 16898612819, 514, 869 },
	["book-down"] = { 16898612819, 918, 0 },
	["book-headphones"] = { 16898612819, 869, 49 },
	["book-heart"] = { 16898612819, 820, 98 },
	["book-image"] = { 16898612819, 771, 147 },
	["book-key"] = { 16898612819, 147, 771 },
	["book-lock"] = { 16898612819, 98, 820 },
	["book-marked"] = { 16898612819, 49, 869 },
	["book-minus"] = { 16898612819, 0, 918 },
	["book-open"] = { 16898612819, 820, 355 },
	["book-open-check"] = { 16898612819, 918, 257 },
	["book-open-text"] = { 16898612819, 869, 306 },
	["book-plus"] = { 16898612819, 771, 404 },
	["book-text"] = { 16898612819, 404, 771 },
	["book-type"] = { 16898612819, 355, 820 },
	["book-up"] = { 16898612819, 257, 918 },
	["book-up-2"] = { 16898612819, 306, 869 },
	["book-user"] = { 16898612819, 918, 514 },
	["book-x"] = { 16898612819, 869, 563 },
	["bookmark"] = { 16898612819, 514, 918 },
	["bookmark-check"] = { 16898612819, 771, 661 },
	["bookmark-minus"] = { 16898612819, 661, 771 },
	["bookmark-plus"] = { 16898612819, 612, 820 },
	["bookmark-x"] = { 16898612819, 563, 869 },
	["boom-box"] = { 16898612819, 967, 0 },
	["bot"] = { 16898612819, 869, 98 },
	["bot-message-square"] = { 16898612819, 918, 49 },
	["box"] = { 16898612819, 771, 196 },
	["box-select"] = { 16898612819, 820, 147 },
	["boxes"] = { 16898612819, 196, 771 },
	["braces"] = { 16898612819, 147, 820 },
	["brackets"] = { 16898612819, 98, 869 },
	["brain"] = { 16898612819, 967, 257 },
	["brain-circuit"] = { 16898612819, 49, 918 },
	["brain-cog"] = { 16898612819, 0, 967 },
	["brick-wall"] = { 16898612819, 918, 306 },
	["briefcase"] = { 16898612819, 771, 453 },
	["briefcase-business"] = { 16898612819, 869, 355 },
	["briefcase-medical"] = { 16898612819, 820, 404 },
	["bring-to-front"] = { 16898612819, 453, 771 },
	["brush"] = { 16898612819, 404, 820 },
	["bug"] = { 16898612819, 257, 967 },
	["bug-off"] = { 16898612819, 355, 869 },
	["bug-play"] = { 16898612819, 306, 918 },
	["building"] = { 16898612819, 918, 563 },
	["building-2"] = { 16898612819, 967, 514 },
	["bus"] = { 16898612819, 820, 661 },
	["bus-front"] = { 16898612819, 869, 612 },
	["cable"] = { 16898612819, 710, 771 },
	["cable-car"] = { 16898612819, 771, 710 },
	["cake"] = { 16898612819, 612, 869 },
	["cake-slice"] = { 16898612819, 661, 820 },
	["calculator"] = { 16898612819, 563, 918 },
	["calendar"] = { 16898612819, 355, 918 },
	["calendar-check"] = { 16898612819, 967, 49 },
	["calendar-check-2"] = { 16898612819, 514, 967 },
	["calendar-clock"] = { 16898612819, 918, 98 },
	["calendar-days"] = { 16898612819, 869, 147 },
	["calendar-fold"] = { 16898612819, 820, 196 },
	["calendar-heart"] = { 16898612819, 196, 820 },
	["calendar-minus"] = { 16898612819, 98, 918 },
	["calendar-minus-2"] = { 16898612819, 147, 869 },
	["calendar-off"] = { 16898612819, 49, 967 },
	["calendar-plus"] = { 16898612819, 918, 355 },
	["calendar-plus-2"] = { 16898612819, 967, 306 },
	["calendar-range"] = { 16898612819, 869, 404 },
	["calendar-search"] = { 16898612819, 820, 453 },
	["calendar-x"] = { 16898612819, 404, 869 },
	["calendar-x-2"] = { 16898612819, 453, 820 },
	["camera"] = { 16898612819, 967, 563 },
	["camera-off"] = { 16898612819, 306, 967 },
	["candlestick-chart"] = { 16898612819, 918, 612 },
	["candy"] = { 16898612819, 771, 759 },
	["candy-cane"] = { 16898612819, 869, 661 },
	["candy-off"] = { 16898612819, 820, 710 },
	["cannabis"] = { 16898612819, 710, 820 },
	["captions"] = { 16898612819, 612, 918 },
	["captions-off"] = { 16898612819, 661, 869 },
	["car"] = { 16898612819, 918, 147 },
	["car-front"] = { 16898612819, 563, 967 },
	["car-taxi-front"] = { 16898612819, 967, 98 },
	["caravan"] = { 16898612819, 869, 196 },
	["carrot"] = { 16898612819, 196, 869 },
	["case-lower"] = { 16898612819, 147, 918 },
	["case-sensitive"] = { 16898612819, 98, 967 },
	["case-upper"] = { 16898612819, 967, 355 },
	["cassette-tape"] = { 16898612819, 918, 404 },
	["cast"] = { 16898612819, 869, 453 },
	["castle"] = { 16898612819, 453, 869 },
	["cat"] = { 16898612819, 404, 918 },
	["cctv"] = { 16898612819, 355, 967 },
	["check"] = { 16898612819, 710, 869 },
	["check-check"] = { 16898612819, 967, 612 },
	["check-circle"] = { 16898612819, 869, 710 },
	["check-circle-2"] = { 16898612819, 918, 661 },
	["check-square"] = { 16898612819, 771, 808 },
	["check-square-2"] = { 16898612819, 820, 759 },
	["chef-hat"] = { 16898612819, 661, 918 },
	["cherry"] = { 16898612819, 612, 967 },
	["chevron-down"] = { 16898612819, 196, 918 },
	["chevron-down-circle"] = { 16898612819, 967, 147 },
	["chevron-down-square"] = { 16898612819, 918, 196 },
	["chevron-first"] = { 16898612819, 147, 967 },
	["chevron-last"] = { 16898612819, 967, 404 },
	["chevron-left"] = { 16898612819, 404, 967 },
	["chevron-left-circle"] = { 16898612819, 918, 453 },
	["chevron-left-square"] = { 16898612819, 453, 918 },
	["chevron-right"] = { 16898612819, 869, 759 },
	["chevron-right-circle"] = { 16898612819, 967, 661 },
	["chevron-right-square"] = { 16898612819, 918, 710 },
	["chevron-up"] = { 16898612819, 710, 918 },
	["chevron-up-circle"] = { 16898612819, 820, 808 },
	["chevron-up-square"] = { 16898612819, 771, 857 },
	["chevrons-down"] = { 16898612819, 967, 196 },
	["chevrons-down-up"] = { 16898612819, 661, 967 },
	["chevrons-left"] = { 16898612819, 967, 453 },
	["chevrons-left-right"] = { 16898612819, 196, 967 },
	["chevrons-right"] = { 16898612819, 967, 710 },
	["chevrons-right-left"] = { 16898612819, 453, 967 },
	["chevrons-up"] = { 16898612819, 869, 808 },
	["chevrons-up-down"] = { 16898612819, 918, 759 },
	["chrome"] = { 16898612819, 820, 857 },
	["church"] = { 16898612819, 771, 906 },
	["cigarette"] = { 16898612819, 967, 759 },
	["cigarette-off"] = { 16898612819, 710, 967 },
	["circle"] = { 16898613044, 771, 355 },
	["circle-alert"] = { 16898612819, 918, 808 },
	["circle-arrow-down"] = { 16898612819, 869, 857 },
	["circle-arrow-left"] = { 16898612819, 820, 906 },
	["circle-arrow-out-down-left"] = { 16898612819, 771, 955 },
	["circle-arrow-out-down-right"] = { 16898612819, 967, 808 },
	["circle-arrow-out-up-left"] = { 16898612819, 918, 857 },
	["circle-arrow-out-up-right"] = { 16898612819, 869, 906 },
	["circle-arrow-right"] = { 16898612819, 820, 955 },
	["circle-arrow-up"] = { 16898612819, 967, 857 },
	["circle-check"] = { 16898612819, 869, 955 },
	["circle-check-big"] = { 16898612819, 918, 906 },
	["circle-chevron-down"] = { 16898612819, 967, 906 },
	["circle-chevron-left"] = { 16898612819, 918, 955 },
	["circle-chevron-right"] = { 16898612819, 967, 955 },
	["circle-chevron-up"] = { 16898613044, 771, 0 },
	["circle-dashed"] = { 16898613044, 0, 771 },
	["circle-divide"] = { 16898613044, 771, 257 },
	["circle-dollar-sign"] = { 16898613044, 257, 771 },
	["circle-dot"] = { 16898613044, 514, 771 },
	["circle-dot-dashed"] = { 16898613044, 771, 514 },
	["circle-ellipsis"] = { 16898613044, 820, 0 },
	["circle-equal"] = { 16898613044, 771, 49 },
	["circle-fading-plus"] = { 16898613044, 49, 771 },
	["circle-gauge"] = { 16898613044, 0, 820 },
	["circle-help"] = { 16898613044, 820, 257 },
	["circle-minus"] = { 16898613044, 771, 306 },
	["circle-off"] = { 16898613044, 306, 771 },
	["circle-parking"] = { 16898613044, 820, 514 },
	["circle-parking-off"] = { 16898613044, 257, 820 },
	["circle-pause"] = { 16898613044, 771, 563 },
	["circle-percent"] = { 16898613044, 563, 771 },
	["circle-play"] = { 16898613044, 514, 820 },
	["circle-plus"] = { 16898613044, 869, 0 },
	["circle-power"] = { 16898613044, 820, 49 },
	["circle-slash"] = { 16898613044, 98, 771 },
	["circle-slash-2"] = { 16898613044, 771, 98 },
	["circle-stop"] = { 16898613044, 49, 820 },
	["circle-user"] = { 16898613044, 869, 257 },
	["circle-user-round"] = { 16898613044, 0, 869 },
	["circle-x"] = { 16898613044, 820, 306 },
	["circuit-board"] = { 16898613044, 355, 771 },
	["citrus"] = { 16898613044, 306, 820 },
	["clapperboard"] = { 16898613044, 257, 869 },
	["clipboard"] = { 16898613044, 49, 869 },
	["clipboard-check"] = { 16898613044, 869, 514 },
	["clipboard-copy"] = { 16898613044, 820, 563 },
	["clipboard-edit"] = { 16898613044, 771, 612 },
	["clipboard-list"] = { 16898613044, 612, 771 },
	["clipboard-minus"] = { 16898613044, 563, 820 },
	["clipboard-paste"] = { 16898613044, 514, 869 },
	["clipboard-pen"] = { 16898613044, 869, 49 },
	["clipboard-pen-line"] = { 16898613044, 918, 0 },
	["clipboard-plus"] = { 16898613044, 820, 98 },
	["clipboard-signature"] = { 16898613044, 771, 147 },
	["clipboard-type"] = { 16898613044, 147, 771 },
	["clipboard-x"] = { 16898613044, 98, 820 },
	["clock"] = { 16898613044, 771, 661 },
	["clock-1"] = { 16898613044, 0, 918 },
	["clock-10"] = { 16898613044, 918, 257 },
	["clock-11"] = { 16898613044, 869, 306 },
	["clock-12"] = { 16898613044, 820, 355 },
	["clock-2"] = { 16898613044, 771, 404 },
	["clock-3"] = { 16898613044, 404, 771 },
	["clock-4"] = { 16898613044, 355, 820 },
	["clock-5"] = { 16898613044, 306, 869 },
	["clock-6"] = { 16898613044, 257, 918 },
	["clock-7"] = { 16898613044, 918, 514 },
	["clock-8"] = { 16898613044, 869, 563 },
	["clock-9"] = { 16898613044, 820, 612 },
	["cloud"] = { 16898613044, 918, 306 },
	["cloud-cog"] = { 16898613044, 661, 771 },
	["cloud-download"] = { 16898613044, 612, 820 },
	["cloud-drizzle"] = { 16898613044, 563, 869 },
	["cloud-fog"] = { 16898613044, 514, 918 },
	["cloud-hail"] = { 16898613044, 967, 0 },
	["cloud-lightning"] = { 16898613044, 918, 49 },
	["cloud-moon"] = { 16898613044, 820, 147 },
	["cloud-moon-rain"] = { 16898613044, 869, 98 },
	["cloud-off"] = { 16898613044, 771, 196 },
	["cloud-rain"] = { 16898613044, 147, 820 },
	["cloud-rain-wind"] = { 16898613044, 196, 771 },
	["cloud-snow"] = { 16898613044, 98, 869 },
	["cloud-sun"] = { 16898613044, 0, 967 },
	["cloud-sun-rain"] = { 16898613044, 49, 918 },
	["cloud-upload"] = { 16898613044, 967, 257 },
	["cloudy"] = { 16898613044, 869, 355 },
	["clover"] = { 16898613044, 820, 404 },
	["club"] = { 16898613044, 771, 453 },
	["code"] = { 16898613044, 355, 869 },
	["code-2"] = { 16898613044, 453, 771 },
	["code-xml"] = { 16898613044, 404, 820 },
	["codepen"] = { 16898613044, 306, 918 },
	["codesandbox"] = { 16898613044, 257, 967 },
	["coffee"] = { 16898613044, 967, 514 },
	["cog"] = { 16898613044, 918, 563 },
	["coins"] = { 16898613044, 869, 612 },
	["columns"] = { 16898613044, 661, 820 },
	["columns-2"] = { 16898613044, 820, 661 },
	["columns-3"] = { 16898613044, 771, 710 },
	["columns-4"] = { 16898613044, 710, 771 },
	["combine"] = { 16898613044, 612, 869 },
	["command"] = { 16898613044, 563, 918 },
	["compass"] = { 16898613044, 514, 967 },
	["component"] = { 16898613044, 967, 49 },
	["computer"] = { 16898613044, 918, 98 },
	["concierge-bell"] = { 16898613044, 869, 147 },
	["cone"] = { 16898613044, 820, 196 },
	["construction"] = { 16898613044, 196, 820 },
	["contact"] = { 16898613044, 49, 967 },
	["contact-2"] = { 16898613044, 147, 869 },
	["contact-round"] = { 16898613044, 98, 918 },
	["container"] = { 16898613044, 967, 306 },
	["contrast"] = { 16898613044, 918, 355 },
	["cookie"] = { 16898613044, 869, 404 },
	["cooking-pot"] = { 16898613044, 820, 453 },
	["copy"] = { 16898613044, 918, 612 },
	["copy-check"] = { 16898613044, 453, 820 },
	["copy-minus"] = { 16898613044, 404, 869 },
	["copy-plus"] = { 16898613044, 355, 918 },
	["copy-slash"] = { 16898613044, 306, 967 },
	["copy-x"] = { 16898613044, 967, 563 },
	["copyleft"] = { 16898613044, 869, 661 },
	["copyright"] = { 16898613044, 820, 710 },
	["corner-down-left"] = { 16898613044, 771, 759 },
	["corner-down-right"] = { 16898613044, 710, 820 },
	["corner-left-down"] = { 16898613044, 661, 869 },
	["corner-left-up"] = { 16898613044, 612, 918 },
	["corner-right-down"] = { 16898613044, 563, 967 },
	["corner-right-up"] = { 16898613044, 967, 98 },
	["corner-up-left"] = { 16898613044, 918, 147 },
	["corner-up-right"] = { 16898613044, 869, 196 },
	["cpu"] = { 16898613044, 196, 869 },
	["creative-commons"] = { 16898613044, 147, 918 },
	["credit-card"] = { 16898613044, 98, 967 },
	["croissant"] = { 16898613044, 967, 355 },
	["crop"] = { 16898613044, 918, 404 },
	["cross"] = { 16898613044, 869, 453 },
	["crosshair"] = { 16898613044, 453, 869 },
	["crown"] = { 16898613044, 404, 918 },
	["cuboid"] = { 16898613044, 355, 967 },
	["cup-soda"] = { 16898613044, 967, 612 },
	["currency"] = { 16898613044, 918, 661 },
	["cylinder"] = { 16898613044, 869, 710 },
	["database"] = { 16898613044, 710, 869 },
	["database-backup"] = { 16898613044, 820, 759 },
	["database-zap"] = { 16898613044, 771, 808 },
	["delete"] = { 16898613044, 661, 918 },
	["dessert"] = { 16898613044, 612, 967 },
	["diameter"] = { 16898613044, 967, 147 },
	["diamond"] = { 16898613044, 196, 918 },
	["diamond-percent"] = { 16898613044, 918, 196 },
	["dice-1"] = { 16898613044, 147, 967 },
	["dice-2"] = { 16898613044, 967, 404 },
	["dice-3"] = { 16898613044, 918, 453 },
	["dice-4"] = { 16898613044, 453, 918 },
	["dice-5"] = { 16898613044, 404, 967 },
	["dice-6"] = { 16898613044, 967, 661 },
	["dices"] = { 16898613044, 918, 710 },
	["diff"] = { 16898613044, 869, 759 },
	["disc"] = { 16898613044, 661, 967 },
	["disc-2"] = { 16898613044, 820, 808 },
	["disc-3"] = { 16898613044, 771, 857 },
	["disc-album"] = { 16898613044, 710, 918 },
	["divide"] = { 16898613044, 967, 453 },
	["divide-circle"] = { 16898613044, 967, 196 },
	["divide-square"] = { 16898613044, 196, 967 },
	["dna"] = { 16898613044, 967, 710 },
	["dna-off"] = { 16898613044, 453, 967 },
	["dock"] = { 16898613044, 918, 759 },
	["dog"] = { 16898613044, 869, 808 },
	["dollar-sign"] = { 16898613044, 820, 857 },
	["donut"] = { 16898613044, 771, 906 },
	["door-closed"] = { 16898613044, 710, 967 },
	["door-open"] = { 16898613044, 967, 759 },
	["dot"] = { 16898613044, 918, 808 },
	["download"] = { 16898613044, 820, 906 },
	["download-cloud"] = { 16898613044, 869, 857 },
	["drafting-compass"] = { 16898613044, 771, 955 },
	["drama"] = { 16898613044, 967, 808 },
	["dribbble"] = { 16898613044, 918, 857 },
	["drill"] = { 16898613044, 869, 906 },
	["droplet"] = { 16898613044, 820, 955 },
	["droplets"] = { 16898613044, 967, 857 },
	["drum"] = { 16898613044, 918, 906 },
	["drumstick"] = { 16898613044, 869, 955 },
	["dumbbell"] = { 16898613044, 967, 906 },
	["ear"] = { 16898613044, 967, 955 },
	["ear-off"] = { 16898613044, 918, 955 },
	["earth"] = { 16898613353, 0, 771 },
	["earth-lock"] = { 16898613353, 771, 0 },
	["eclipse"] = { 16898613353, 771, 257 },
	["egg"] = { 16898613353, 514, 771 },
	["egg-fried"] = { 16898613353, 257, 771 },
	["egg-off"] = { 16898613353, 771, 514 },
	["ellipsis"] = { 16898613353, 771, 49 },
	["ellipsis-vertical"] = { 16898613353, 820, 0 },
	["equal"] = { 16898613353, 0, 820 },
	["equal-not"] = { 16898613353, 49, 771 },
	["eraser"] = { 16898613353, 820, 257 },
	["euro"] = { 16898613353, 771, 306 },
	["expand"] = { 16898613353, 306, 771 },
	["external-link"] = { 16898613353, 257, 820 },
	["eye"] = { 16898613353, 771, 563 },
	["eye-off"] = { 16898613353, 820, 514 },
	["facebook"] = { 16898613353, 563, 771 },
	["factory"] = { 16898613353, 514, 820 },
	["fan"] = { 16898613353, 869, 0 },
	["fast-forward"] = { 16898613353, 820, 49 },
	["feather"] = { 16898613353, 771, 98 },
	["fence"] = { 16898613353, 98, 771 },
	["ferris-wheel"] = { 16898613353, 49, 820 },
	["figma"] = { 16898613353, 0, 869 },
	["file"] = { 16898613353, 820, 661 },
	["file-archive"] = { 16898613353, 869, 257 },
	["file-audio"] = { 16898613353, 771, 355 },
	["file-audio-2"] = { 16898613353, 820, 306 },
	["file-axis-3d"] = { 16898613353, 355, 771 },
	["file-badge"] = { 16898613353, 257, 869 },
	["file-badge-2"] = { 16898613353, 306, 820 },
	["file-bar-chart"] = { 16898613353, 820, 563 },
	["file-bar-chart-2"] = { 16898613353, 869, 514 },
	["file-box"] = { 16898613353, 771, 612 },
	["file-check"] = { 16898613353, 563, 820 },
	["file-check-2"] = { 16898613353, 612, 771 },
	["file-clock"] = { 16898613353, 514, 869 },
	["file-code"] = { 16898613353, 869, 49 },
	["file-code-2"] = { 16898613353, 918, 0 },
	["file-cog"] = { 16898613353, 820, 98 },
	["file-diff"] = { 16898613353, 771, 147 },
	["file-digit"] = { 16898613353, 147, 771 },
	["file-down"] = { 16898613353, 98, 820 },
	["file-edit"] = { 16898613353, 49, 869 },
	["file-heart"] = { 16898613353, 0, 918 },
	["file-image"] = { 16898613353, 918, 257 },
	["file-input"] = { 16898613353, 869, 306 },
	["file-json"] = { 16898613353, 771, 404 },
	["file-json-2"] = { 16898613353, 820, 355 },
	["file-key"] = { 16898613353, 355, 820 },
	["file-key-2"] = { 16898613353, 404, 771 },
	["file-line-chart"] = { 16898613353, 306, 869 },
	["file-lock"] = { 16898613353, 918, 514 },
	["file-lock-2"] = { 16898613353, 257, 918 },
	["file-minus"] = { 16898613353, 820, 612 },
	["file-minus-2"] = { 16898613353, 869, 563 },
	["file-music"] = { 16898613353, 771, 661 },
	["file-output"] = { 16898613353, 661, 771 },
	["file-pen"] = { 16898613353, 563, 869 },
	["file-pen-line"] = { 16898613353, 612, 820 },
	["file-pie-chart"] = { 16898613353, 514, 918 },
	["file-plus"] = { 16898613353, 918, 49 },
	["file-plus-2"] = { 16898613353, 967, 0 },
	["file-question"] = { 16898613353, 869, 98 },
	["file-scan"] = { 16898613353, 820, 147 },
	["file-search"] = { 16898613353, 196, 771 },
	["file-search-2"] = { 16898613353, 771, 196 },
	["file-signature"] = { 16898613353, 147, 820 },
	["file-sliders"] = { 16898613353, 98, 869 },
	["file-spreadsheet"] = { 16898613353, 49, 918 },
	["file-stack"] = { 16898613353, 0, 967 },
	["file-symlink"] = { 16898613353, 967, 257 },
	["file-terminal"] = { 16898613353, 918, 306 },
	["file-text"] = { 16898613353, 869, 355 },
	["file-type"] = { 16898613353, 771, 453 },
	["file-type-2"] = { 16898613353, 820, 404 },
	["file-up"] = { 16898613353, 453, 771 },
	["file-video"] = { 16898613353, 355, 869 },
	["file-video-2"] = { 16898613353, 404, 820 },
	["file-volume"] = { 16898613353, 257, 967 },
	["file-volume-2"] = { 16898613353, 306, 918 },
	["file-warning"] = { 16898613353, 967, 514 },
	["file-x"] = { 16898613353, 869, 612 },
	["file-x-2"] = { 16898613353, 918, 563 },
	["files"] = { 16898613353, 771, 710 },
	["film"] = { 16898613353, 710, 771 },
	["filter"] = { 16898613353, 612, 869 },
	["filter-x"] = { 16898613353, 661, 820 },
	["fingerprint"] = { 16898613353, 563, 918 },
	["fire-extinguisher"] = { 16898613353, 514, 967 },
	["fish"] = { 16898613353, 869, 147 },
	["fish-off"] = { 16898613353, 967, 49 },
	["fish-symbol"] = { 16898613353, 918, 98 },
	["flag"] = { 16898613353, 98, 918 },
	["flag-off"] = { 16898613353, 820, 196 },
	["flag-triangle-left"] = { 16898613353, 196, 820 },
	["flag-triangle-right"] = { 16898613353, 147, 869 },
	["flame"] = { 16898613353, 967, 306 },
	["flame-kindling"] = { 16898613353, 49, 967 },
	["flashlight"] = { 16898613353, 869, 404 },
	["flashlight-off"] = { 16898613353, 918, 355 },
	["flask-conical"] = { 16898613353, 453, 820 },
	["flask-conical-off"] = { 16898613353, 820, 453 },
	["flask-round"] = { 16898613353, 404, 869 },
	["flip-horizontal"] = { 16898613353, 306, 967 },
	["flip-horizontal-2"] = { 16898613353, 355, 918 },
	["flip-vertical"] = { 16898613353, 918, 612 },
	["flip-vertical-2"] = { 16898613353, 967, 563 },
	["flower"] = { 16898613353, 820, 710 },
	["flower-2"] = { 16898613353, 869, 661 },
	["focus"] = { 16898613353, 771, 759 },
	["fold-horizontal"] = { 16898613353, 710, 820 },
	["fold-vertical"] = { 16898613353, 661, 869 },
	["folder"] = { 16898613353, 404, 967 },
	["folder-archive"] = { 16898613353, 612, 918 },
	["folder-check"] = { 16898613353, 563, 967 },
	["folder-clock"] = { 16898613353, 967, 98 },
	["folder-closed"] = { 16898613353, 918, 147 },
	["folder-cog"] = { 16898613353, 869, 196 },
	["folder-dot"] = { 16898613353, 196, 869 },
	["folder-down"] = { 16898613353, 147, 918 },
	["folder-edit"] = { 16898613353, 98, 967 },
	["folder-git"] = { 16898613353, 918, 404 },
	["folder-git-2"] = { 16898613353, 967, 355 },
	["folder-heart"] = { 16898613353, 869, 453 },
	["folder-input"] = { 16898613353, 453, 869 },
	["folder-kanban"] = { 16898613353, 404, 918 },
	["folder-key"] = { 16898613353, 355, 967 },
	["folder-lock"] = { 16898613353, 967, 612 },
	["folder-minus"] = { 16898613353, 918, 661 },
	["folder-open"] = { 16898613353, 820, 759 },
	["folder-open-dot"] = { 16898613353, 869, 710 },
	["folder-output"] = { 16898613353, 771, 808 },
	["folder-pen"] = { 16898613353, 710, 869 },
	["folder-plus"] = { 16898613353, 661, 918 },
	["folder-root"] = { 16898613353, 612, 967 },
	["folder-search"] = { 16898613353, 918, 196 },
	["folder-search-2"] = { 16898613353, 967, 147 },
	["folder-symlink"] = { 16898613353, 196, 918 },
	["folder-sync"] = { 16898613353, 147, 967 },
	["folder-tree"] = { 16898613353, 967, 404 },
	["folder-up"] = { 16898613353, 918, 453 },
	["folder-x"] = { 16898613353, 453, 918 },
	["folders"] = { 16898613353, 967, 661 },
	["footprints"] = { 16898613353, 918, 710 },
	["forklift"] = { 16898613353, 869, 759 },
	["form-input"] = { 16898613353, 820, 808 },
	["forward"] = { 16898613353, 771, 857 },
	["frame"] = { 16898613353, 710, 918 },
	["framer"] = { 16898613353, 661, 967 },
	["frown"] = { 16898613353, 967, 196 },
	["fuel"] = { 16898613353, 196, 967 },
	["fullscreen"] = { 16898613353, 967, 453 },
	["function-square"] = { 16898613353, 453, 967 },
	["gallery-horizontal"] = { 16898613353, 918, 759 },
	["gallery-horizontal-end"] = { 16898613353, 967, 710 },
	["gallery-thumbnails"] = { 16898613353, 869, 808 },
	["gallery-vertical"] = { 16898613353, 771, 906 },
	["gallery-vertical-end"] = { 16898613353, 820, 857 },
	["gamepad"] = { 16898613353, 967, 759 },
	["gamepad-2"] = { 16898613353, 710, 967 },
	["gantt-chart"] = { 16898613353, 869, 857 },
	["gantt-chart-square"] = { 16898613353, 918, 808 },
	["gauge"] = { 16898613353, 771, 955 },
	["gauge-circle"] = { 16898613353, 820, 906 },
	["gavel"] = { 16898613353, 967, 808 },
	["gem"] = { 16898613353, 918, 857 },
	["ghost"] = { 16898613353, 869, 906 },
	["gift"] = { 16898613353, 820, 955 },
	["git-branch"] = { 16898613353, 918, 906 },
	["git-branch-plus"] = { 16898613353, 967, 857 },
	["git-commit-horizontal"] = { 16898613353, 869, 955 },
	["git-commit-vertical"] = { 16898613353, 967, 906 },
	["git-compare"] = { 16898613353, 967, 955 },
	["git-compare-arrows"] = { 16898613353, 918, 955 },
	["git-fork"] = { 16898613509, 771, 0 },
	["git-graph"] = { 16898613509, 0, 771 },
	["git-merge"] = { 16898613509, 771, 257 },
	["git-pull-request"] = { 16898613509, 49, 771 },
	["git-pull-request-arrow"] = { 16898613509, 257, 771 },
	["git-pull-request-closed"] = { 16898613509, 771, 514 },
	["git-pull-request-create"] = { 16898613509, 820, 0 },
	["git-pull-request-create-arrow"] = { 16898613509, 514, 771 },
	["git-pull-request-draft"] = { 16898613509, 771, 49 },
	["github"] = { 16898613509, 0, 820 },
	["gitlab"] = { 16898613509, 820, 257 },
	["glass-water"] = { 16898613509, 771, 306 },
	["glasses"] = { 16898613509, 306, 771 },
	["globe"] = { 16898613509, 771, 563 },
	["globe-2"] = { 16898613509, 257, 820 },
	["globe-lock"] = { 16898613509, 820, 514 },
	["goal"] = { 16898613509, 563, 771 },
	["grab"] = { 16898613509, 514, 820 },
	["graduation-cap"] = { 16898613509, 869, 0 },
	["grape"] = { 16898613509, 820, 49 },
	["grid-2x2"] = { 16898613509, 771, 98 },
	["grid-3x3"] = { 16898613509, 98, 771 },
	["grip"] = { 16898613509, 869, 257 },
	["grip-horizontal"] = { 16898613509, 49, 820 },
	["grip-vertical"] = { 16898613509, 0, 869 },
	["group"] = { 16898613509, 820, 306 },
	["guitar"] = { 16898613509, 771, 355 },
	["ham"] = { 16898613509, 355, 771 },
	["hammer"] = { 16898613509, 306, 820 },
	["hand"] = { 16898613509, 563, 820 },
	["hand-coins"] = { 16898613509, 257, 869 },
	["hand-heart"] = { 16898613509, 869, 514 },
	["hand-helping"] = { 16898613509, 820, 563 },
	["hand-metal"] = { 16898613509, 771, 612 },
	["hand-platter"] = { 16898613509, 612, 771 },
	["handshake"] = { 16898613509, 514, 869 },
	["hard-drive"] = { 16898613509, 820, 98 },
	["hard-drive-download"] = { 16898613509, 918, 0 },
	["hard-drive-upload"] = { 16898613509, 869, 49 },
	["hard-hat"] = { 16898613509, 771, 147 },
	["hash"] = { 16898613509, 147, 771 },
	["haze"] = { 16898613509, 98, 820 },
	["hdmi-port"] = { 16898613509, 49, 869 },
	["heading"] = { 16898613509, 355, 820 },
	["heading-1"] = { 16898613509, 0, 918 },
	["heading-2"] = { 16898613509, 918, 257 },
	["heading-3"] = { 16898613509, 869, 306 },
	["heading-4"] = { 16898613509, 820, 355 },
	["heading-5"] = { 16898613509, 771, 404 },
	["heading-6"] = { 16898613509, 404, 771 },
	["headphones"] = { 16898613509, 306, 869 },
	["headset"] = { 16898613509, 257, 918 },
	["heart"] = { 16898613509, 661, 771 },
	["heart-crack"] = { 16898613509, 918, 514 },
	["heart-handshake"] = { 16898613509, 869, 563 },
	["heart-off"] = { 16898613509, 820, 612 },
	["heart-pulse"] = { 16898613509, 771, 661 },
	["heater"] = { 16898613509, 612, 820 },
	["help-circle"] = { 16898613509, 563, 869 },
	["helping-hand"] = { 16898613509, 514, 918 },
	["hexagon"] = { 16898613509, 967, 0 },
	["highlighter"] = { 16898613509, 918, 49 },
	["history"] = { 16898613509, 869, 98 },
	["home"] = { 16898613509, 820, 147 },
	["hop"] = { 16898613509, 196, 771 },
	["hop-off"] = { 16898613509, 771, 196 },
	["hospital"] = { 16898613509, 147, 820 },
	["hotel"] = { 16898613509, 98, 869 },
	["hourglass"] = { 16898613509, 49, 918 },
	["ice-cream"] = { 16898613509, 869, 355 },
	["ice-cream-2"] = { 16898613509, 0, 967 },
	["ice-cream-bowl"] = { 16898613509, 967, 257 },
	["ice-cream-cone"] = { 16898613509, 918, 306 },
	["image"] = { 16898613509, 306, 918 },
	["image-down"] = { 16898613509, 820, 404 },
	["image-minus"] = { 16898613509, 771, 453 },
	["image-off"] = { 16898613509, 453, 771 },
	["image-plus"] = { 16898613509, 404, 820 },
	["image-up"] = { 16898613509, 355, 869 },
	["images"] = { 16898613509, 257, 967 },
	["import"] = { 16898613509, 967, 514 },
	["inbox"] = { 16898613509, 918, 563 },
	["indent"] = { 16898613509, 771, 710 },
	["indent-decrease"] = { 16898613509, 869, 612 },
	["indent-increase"] = { 16898613509, 820, 661 },
	["indian-rupee"] = { 16898613509, 710, 771 },
	["infinity"] = { 16898613509, 661, 820 },
	["info"] = { 16898613509, 612, 869 },
	["inspection-panel"] = { 16898613509, 563, 918 },
	["instagram"] = { 16898613509, 514, 967 },
	["italic"] = { 16898613509, 967, 49 },
	["iteration-ccw"] = { 16898613509, 918, 98 },
	["iteration-cw"] = { 16898613509, 869, 147 },
	["japanese-yen"] = { 16898613509, 820, 196 },
	["joystick"] = { 16898613509, 196, 820 },
	["kanban"] = { 16898613509, 49, 967 },
	["kanban-square"] = { 16898613509, 98, 918 },
	["kanban-square-dashed"] = { 16898613509, 147, 869 },
	["key"] = { 16898613509, 869, 404 },
	["key-round"] = { 16898613509, 967, 306 },
	["key-square"] = { 16898613509, 918, 355 },
	["keyboard"] = { 16898613509, 453, 820 },
	["keyboard-music"] = { 16898613509, 820, 453 },
	["lamp"] = { 16898613509, 869, 661 },
	["lamp-ceiling"] = { 16898613509, 404, 869 },
	["lamp-desk"] = { 16898613509, 355, 918 },
	["lamp-floor"] = { 16898613509, 306, 967 },
	["lamp-wall-down"] = { 16898613509, 967, 563 },
	["lamp-wall-up"] = { 16898613509, 918, 612 },
	["land-plot"] = { 16898613509, 820, 710 },
	["landmark"] = { 16898613509, 771, 759 },
	["languages"] = { 16898613509, 710, 820 },
	["laptop"] = { 16898613509, 563, 967 },
	["laptop-2"] = { 16898613509, 661, 869 },
	["laptop-minimal"] = { 16898613509, 612, 918 },
	["lasso"] = { 16898613509, 918, 147 },
	["lasso-select"] = { 16898613509, 967, 98 },
	["laugh"] = { 16898613509, 869, 196 },
	["layers"] = { 16898613509, 98, 967 },
	["layers-2"] = { 16898613509, 196, 869 },
	["layers-3"] = { 16898613509, 147, 918 },
	["layout"] = { 16898613509, 967, 612 },
	["layout-dashboard"] = { 16898613509, 967, 355 },
	["layout-grid"] = { 16898613509, 918, 404 },
	["layout-list"] = { 16898613509, 869, 453 },
	["layout-panel-left"] = { 16898613509, 453, 869 },
	["layout-panel-top"] = { 16898613509, 404, 918 },
	["layout-template"] = { 16898613509, 355, 967 },
	["leaf"] = { 16898613509, 918, 661 },
	["leafy-green"] = { 16898613509, 869, 710 },
	["library"] = { 16898613509, 710, 869 },
	["library-big"] = { 16898613509, 820, 759 },
	["library-square"] = { 16898613509, 771, 808 },
	["life-buoy"] = { 16898613509, 661, 918 },
	["ligature"] = { 16898613509, 612, 967 },
	["lightbulb"] = { 16898613509, 918, 196 },
	["lightbulb-off"] = { 16898613509, 967, 147 },
	["line-chart"] = { 16898613509, 196, 918 },
	["link"] = { 16898613509, 918, 453 },
	["link-2"] = { 16898613509, 967, 404 },
	["link-2-off"] = { 16898613509, 147, 967 },
	["linkedin"] = { 16898613509, 453, 918 },
	["list"] = { 16898613509, 869, 808 },
	["list-checks"] = { 16898613509, 404, 967 },
	["list-collapse"] = { 16898613509, 967, 661 },
	["list-end"] = { 16898613509, 918, 710 },
	["list-filter"] = { 16898613509, 869, 759 },
	["list-minus"] = { 16898613509, 820, 808 },
	["list-music"] = { 16898613509, 771, 857 },
	["list-ordered"] = { 16898613509, 710, 918 },
	["list-plus"] = { 16898613509, 661, 967 },
	["list-restart"] = { 16898613509, 967, 196 },
	["list-start"] = { 16898613509, 196, 967 },
	["list-todo"] = { 16898613509, 967, 453 },
	["list-tree"] = { 16898613509, 453, 967 },
	["list-video"] = { 16898613509, 967, 710 },
	["list-x"] = { 16898613509, 918, 759 },
	["loader"] = { 16898613509, 710, 967 },
	["loader-2"] = { 16898613509, 820, 857 },
	["loader-circle"] = { 16898613509, 771, 906 },
	["locate"] = { 16898613509, 869, 857 },
	["locate-fixed"] = { 16898613509, 967, 759 },
	["locate-off"] = { 16898613509, 918, 808 },
	["lock"] = { 16898613509, 918, 857 },
	["lock-keyhole"] = { 16898613509, 771, 955 },
	["lock-keyhole-open"] = { 16898613509, 820, 906 },
	["lock-open"] = { 16898613509, 967, 808 },
	["log-in"] = { 16898613509, 869, 906 },
	["log-out"] = { 16898613509, 820, 955 },
	["lollipop"] = { 16898613509, 967, 857 },
	["luggage"] = { 16898613509, 918, 906 },
	["m-square"] = { 16898613509, 869, 955 },
	["magnet"] = { 16898613509, 967, 906 },
	["mail"] = { 16898613613, 820, 0 },
	["mail-check"] = { 16898613509, 918, 955 },
	["mail-minus"] = { 16898613509, 967, 955 },
	["mail-open"] = { 16898613613, 771, 0 },
	["mail-plus"] = { 16898613613, 0, 771 },
	["mail-question"] = { 16898613613, 771, 257 },
	["mail-search"] = { 16898613613, 257, 771 },
	["mail-warning"] = { 16898613613, 771, 514 },
	["mail-x"] = { 16898613613, 514, 771 },
	["mailbox"] = { 16898613613, 771, 49 },
	["mails"] = { 16898613613, 49, 771 },
	["map"] = { 16898613613, 306, 771 },
	["map-pin"] = { 16898613613, 820, 257 },
	["map-pin-off"] = { 16898613613, 0, 820 },
	["map-pinned"] = { 16898613613, 771, 306 },
	["martini"] = { 16898613613, 257, 820 },
	["maximize"] = { 16898613613, 771, 563 },
	["maximize-2"] = { 16898613613, 820, 514 },
	["medal"] = { 16898613613, 563, 771 },
	["megaphone"] = { 16898613613, 869, 0 },
	["megaphone-off"] = { 16898613613, 514, 820 },
	["meh"] = { 16898613613, 820, 49 },
	["memory-stick"] = { 16898613613, 771, 98 },
	["menu"] = { 16898613613, 49, 820 },
	["menu-square"] = { 16898613613, 98, 771 },
	["merge"] = { 16898613613, 0, 869 },
	["message-circle"] = { 16898613613, 563, 820 },
	["message-circle-code"] = { 16898613613, 869, 257 },
	["message-circle-dashed"] = { 16898613613, 820, 306 },
	["message-circle-heart"] = { 16898613613, 771, 355 },
	["message-circle-more"] = { 16898613613, 355, 771 },
	["message-circle-off"] = { 16898613613, 306, 820 },
	["message-circle-plus"] = { 16898613613, 257, 869 },
	["message-circle-question"] = { 16898613613, 869, 514 },
	["message-circle-reply"] = { 16898613613, 820, 563 },
	["message-circle-warning"] = { 16898613613, 771, 612 },
	["message-circle-x"] = { 16898613613, 612, 771 },
	["message-square"] = { 16898613613, 355, 820 },
	["message-square-code"] = { 16898613613, 514, 869 },
	["message-square-dashed"] = { 16898613613, 918, 0 },
	["message-square-diff"] = { 16898613613, 869, 49 },
	["message-square-dot"] = { 16898613613, 820, 98 },
	["message-square-heart"] = { 16898613613, 771, 147 },
	["message-square-more"] = { 16898613613, 147, 771 },
	["message-square-off"] = { 16898613613, 98, 820 },
	["message-square-plus"] = { 16898613613, 49, 869 },
	["message-square-quote"] = { 16898613613, 0, 918 },
	["message-square-reply"] = { 16898613613, 918, 257 },
	["message-square-share"] = { 16898613613, 869, 306 },
	["message-square-text"] = { 16898613613, 820, 355 },
	["message-square-warning"] = { 16898613613, 771, 404 },
	["message-square-x"] = { 16898613613, 404, 771 },
	["messages-square"] = { 16898613613, 306, 869 },
	["mic"] = { 16898613613, 820, 612 },
	["mic-2"] = { 16898613613, 257, 918 },
	["mic-off"] = { 16898613613, 918, 514 },
	["mic-vocal"] = { 16898613613, 869, 563 },
	["microscope"] = { 16898613613, 771, 661 },
	["microwave"] = { 16898613613, 661, 771 },
	["milestone"] = { 16898613613, 612, 820 },
	["milk"] = { 16898613613, 514, 918 },
	["milk-off"] = { 16898613613, 563, 869 },
	["minimize"] = { 16898613613, 918, 49 },
	["minimize-2"] = { 16898613613, 967, 0 },
	["minus"] = { 16898613613, 771, 196 },
	["minus-circle"] = { 16898613613, 869, 98 },
	["minus-square"] = { 16898613613, 820, 147 },
	["monitor"] = { 16898613613, 404, 820 },
	["monitor-check"] = { 16898613613, 196, 771 },
	["monitor-dot"] = { 16898613613, 147, 820 },
	["monitor-down"] = { 16898613613, 98, 869 },
	["monitor-off"] = { 16898613613, 49, 918 },
	["monitor-pause"] = { 16898613613, 0, 967 },
	["monitor-play"] = { 16898613613, 967, 257 },
	["monitor-smartphone"] = { 16898613613, 918, 306 },
	["monitor-speaker"] = { 16898613613, 869, 355 },
	["monitor-stop"] = { 16898613613, 820, 404 },
	["monitor-up"] = { 16898613613, 771, 453 },
	["monitor-x"] = { 16898613613, 453, 771 },
	["moon"] = { 16898613613, 306, 918 },
	["moon-star"] = { 16898613613, 355, 869 },
	["more-horizontal"] = { 16898613613, 257, 967 },
	["more-vertical"] = { 16898613613, 967, 514 },
	["mountain"] = { 16898613613, 869, 612 },
	["mountain-snow"] = { 16898613613, 918, 563 },
	["mouse"] = { 16898613613, 563, 918 },
	["mouse-pointer"] = { 16898613613, 612, 869 },
	["mouse-pointer-2"] = { 16898613613, 820, 661 },
	["mouse-pointer-click"] = { 16898613613, 771, 710 },
	["mouse-pointer-square"] = { 16898613613, 661, 820 },
	["mouse-pointer-square-dashed"] = { 16898613613, 710, 771 },
	["move"] = { 16898613613, 453, 820 },
	["move-3d"] = { 16898613613, 514, 967 },
	["move-diagonal"] = { 16898613613, 918, 98 },
	["move-diagonal-2"] = { 16898613613, 967, 49 },
	["move-down"] = { 16898613613, 196, 820 },
	["move-down-left"] = { 16898613613, 869, 147 },
	["move-down-right"] = { 16898613613, 820, 196 },
	["move-horizontal"] = { 16898613613, 147, 869 },
	["move-left"] = { 16898613613, 98, 918 },
	["move-right"] = { 16898613613, 49, 967 },
	["move-up"] = { 16898613613, 869, 404 },
	["move-up-left"] = { 16898613613, 967, 306 },
	["move-up-right"] = { 16898613613, 918, 355 },
	["move-vertical"] = { 16898613613, 820, 453 },
	["music"] = { 16898613613, 967, 563 },
	["music-2"] = { 16898613613, 404, 869 },
	["music-3"] = { 16898613613, 355, 918 },
	["music-4"] = { 16898613613, 306, 967 },
	["navigation"] = { 16898613613, 771, 759 },
	["navigation-2"] = { 16898613613, 869, 661 },
	["navigation-2-off"] = { 16898613613, 918, 612 },
	["navigation-off"] = { 16898613613, 820, 710 },
	["network"] = { 16898613613, 710, 820 },
	["newspaper"] = { 16898613613, 661, 869 },
	["nfc"] = { 16898613613, 612, 918 },
	["notebook"] = { 16898613613, 869, 196 },
	["notebook-pen"] = { 16898613613, 563, 967 },
	["notebook-tabs"] = { 16898613613, 967, 98 },
	["notebook-text"] = { 16898613613, 918, 147 },
	["notepad-text"] = { 16898613613, 147, 918 },
	["notepad-text-dashed"] = { 16898613613, 196, 869 },
	["nut"] = { 16898613613, 967, 355 },
	["nut-off"] = { 16898613613, 98, 967 },
	["octagon"] = { 16898613613, 404, 918 },
	["octagon-alert"] = { 16898613613, 918, 404 },
	["octagon-pause"] = { 16898613613, 869, 453 },
	["octagon-x"] = { 16898613613, 453, 869 },
	["option"] = { 16898613613, 355, 967 },
	["orbit"] = { 16898613613, 967, 612 },
	["outdent"] = { 16898613613, 918, 661 },
	["package"] = { 16898613613, 918, 196 },
	["package-2"] = { 16898613613, 869, 710 },
	["package-check"] = { 16898613613, 820, 759 },
	["package-minus"] = { 16898613613, 771, 808 },
	["package-open"] = { 16898613613, 710, 869 },
	["package-plus"] = { 16898613613, 661, 918 },
	["package-search"] = { 16898613613, 612, 967 },
	["package-x"] = { 16898613613, 967, 147 },
	["paint-bucket"] = { 16898613613, 196, 918 },
	["paint-roller"] = { 16898613613, 147, 967 },
	["paintbrush"] = { 16898613613, 918, 453 },
	["paintbrush-2"] = { 16898613613, 967, 404 },
	["palette"] = { 16898613613, 453, 918 },
	["palmtree"] = { 16898613613, 404, 967 },
	["panel-bottom"] = { 16898613613, 771, 857 },
	["panel-bottom-close"] = { 16898613613, 967, 661 },
	["panel-bottom-dashed"] = { 16898613613, 918, 710 },
	["panel-bottom-inactive"] = { 16898613613, 869, 759 },
	["panel-bottom-open"] = { 16898613613, 820, 808 },
	["panel-left"] = { 16898613613, 967, 453 },
	["panel-left-close"] = { 16898613613, 710, 918 },
	["panel-left-dashed"] = { 16898613613, 661, 967 },
	["panel-left-inactive"] = { 16898613613, 967, 196 },
	["panel-left-open"] = { 16898613613, 196, 967 },
	["panel-right"] = { 16898613613, 820, 857 },
	["panel-right-close"] = { 16898613613, 453, 967 },
	["panel-right-dashed"] = { 16898613613, 967, 710 },
	["panel-right-inactive"] = { 16898613613, 918, 759 },
	["panel-right-open"] = { 16898613613, 869, 808 },
	["panel-top"] = { 16898613613, 869, 857 },
	["panel-top-close"] = { 16898613613, 771, 906 },
	["panel-top-dashed"] = { 16898613613, 710, 967 },
	["panel-top-inactive"] = { 16898613613, 967, 759 },
	["panel-top-open"] = { 16898613613, 918, 808 },
	["panels-left-bottom"] = { 16898613613, 820, 906 },
	["panels-right-bottom"] = { 16898613613, 771, 955 },
	["panels-top-left"] = { 16898613613, 967, 808 },
	["paperclip"] = { 16898613613, 918, 857 },
	["parentheses"] = { 16898613613, 869, 906 },
	["parking-circle"] = { 16898613613, 967, 857 },
	["parking-circle-off"] = { 16898613613, 820, 955 },
	["parking-meter"] = { 16898613613, 918, 906 },
	["parking-square"] = { 16898613613, 967, 906 },
	["parking-square-off"] = { 16898613613, 869, 955 },
	["party-popper"] = { 16898613613, 918, 955 },
	["pause"] = { 16898613699, 0, 771 },
	["pause-circle"] = { 16898613613, 967, 955 },
	["pause-octagon"] = { 16898613699, 771, 0 },
	["paw-print"] = { 16898613699, 771, 257 },
	["pc-case"] = { 16898613699, 257, 771 },
	["pen"] = { 16898613699, 771, 49 },
	["pen-line"] = { 16898613699, 771, 514 },
	["pen-square"] = { 16898613699, 514, 771 },
	["pen-tool"] = { 16898613699, 820, 0 },
	["pencil"] = { 16898613699, 820, 257 },
	["pencil-line"] = { 16898613699, 49, 771 },
	["pencil-ruler"] = { 16898613699, 0, 820 },
	["pentagon"] = { 16898613699, 771, 306 },
	["percent"] = { 16898613699, 771, 563 },
	["percent-circle"] = { 16898613699, 306, 771 },
	["percent-diamond"] = { 16898613699, 257, 820 },
	["percent-square"] = { 16898613699, 820, 514 },
	["person-standing"] = { 16898613699, 563, 771 },
	["phone"] = { 16898613699, 0, 869 },
	["phone-call"] = { 16898613699, 514, 820 },
	["phone-forwarded"] = { 16898613699, 869, 0 },
	["phone-incoming"] = { 16898613699, 820, 49 },
	["phone-missed"] = { 16898613699, 771, 98 },
	["phone-off"] = { 16898613699, 98, 771 },
	["phone-outgoing"] = { 16898613699, 49, 820 },
	["pi"] = { 16898613699, 820, 306 },
	["pi-square"] = { 16898613699, 869, 257 },
	["piano"] = { 16898613699, 771, 355 },
	["pickaxe"] = { 16898613699, 355, 771 },
	["picture-in-picture"] = { 16898613699, 257, 869 },
	["picture-in-picture-2"] = { 16898613699, 306, 820 },
	["pie-chart"] = { 16898613699, 869, 514 },
	["piggy-bank"] = { 16898613699, 820, 563 },
	["pilcrow"] = { 16898613699, 612, 771 },
	["pilcrow-square"] = { 16898613699, 771, 612 },
	["pill"] = { 16898613699, 563, 820 },
	["pin"] = { 16898613699, 918, 0 },
	["pin-off"] = { 16898613699, 514, 869 },
	["pipette"] = { 16898613699, 869, 49 },
	["pizza"] = { 16898613699, 820, 98 },
	["plane"] = { 16898613699, 98, 820 },
	["plane-landing"] = { 16898613699, 771, 147 },
	["plane-takeoff"] = { 16898613699, 147, 771 },
	["play"] = { 16898613699, 918, 257 },
	["play-circle"] = { 16898613699, 49, 869 },
	["play-square"] = { 16898613699, 0, 918 },
	["plug"] = { 16898613699, 404, 771 },
	["plug-2"] = { 16898613699, 869, 306 },
	["plug-zap"] = { 16898613699, 771, 404 },
	["plug-zap-2"] = { 16898613699, 820, 355 },
	["plus"] = { 16898613699, 257, 918 },
	["plus-circle"] = { 16898613699, 355, 820 },
	["plus-square"] = { 16898613699, 306, 869 },
	["pocket"] = { 16898613699, 869, 563 },
	["pocket-knife"] = { 16898613699, 918, 514 },
	["podcast"] = { 16898613699, 820, 612 },
	["pointer"] = { 16898613699, 661, 771 },
	["pointer-off"] = { 16898613699, 771, 661 },
	["popcorn"] = { 16898613699, 612, 820 },
	["popsicle"] = { 16898613699, 563, 869 },
	["pound-sterling"] = { 16898613699, 514, 918 },
	["power"] = { 16898613699, 820, 147 },
	["power-circle"] = { 16898613699, 967, 0 },
	["power-off"] = { 16898613699, 918, 49 },
	["power-square"] = { 16898613699, 869, 98 },
	["presentation"] = { 16898613699, 771, 196 },
	["printer"] = { 16898613699, 196, 771 },
	["projector"] = { 16898613699, 147, 820 },
	["proportions"] = { 16898613699, 98, 869 },
	["puzzle"] = { 16898613699, 49, 918 },
	["pyramid"] = { 16898613699, 0, 967 },
	["qr-code"] = { 16898613699, 967, 257 },
	["quote"] = { 16898613699, 918, 306 },
	["rabbit"] = { 16898613699, 869, 355 },
	["radar"] = { 16898613699, 820, 404 },
	["radiation"] = { 16898613699, 771, 453 },
	["radical"] = { 16898613699, 453, 771 },
	["radio"] = { 16898613699, 306, 918 },
	["radio-receiver"] = { 16898613699, 404, 820 },
	["radio-tower"] = { 16898613699, 355, 869 },
	["radius"] = { 16898613699, 257, 967 },
	["rail-symbol"] = { 16898613699, 967, 514 },
	["rainbow"] = { 16898613699, 918, 563 },
	["rat"] = { 16898613699, 869, 612 },
	["ratio"] = { 16898613699, 820, 661 },
	["receipt"] = { 16898613699, 869, 147 },
	["receipt-cent"] = { 16898613699, 771, 710 },
	["receipt-euro"] = { 16898613699, 710, 771 },
	["receipt-indian-rupee"] = { 16898613699, 661, 820 },
	["receipt-japanese-yen"] = { 16898613699, 612, 869 },
	["receipt-pound-sterling"] = { 16898613699, 563, 918 },
	["receipt-russian-ruble"] = { 16898613699, 514, 967 },
	["receipt-swiss-franc"] = { 16898613699, 967, 49 },
	["receipt-text"] = { 16898613699, 918, 98 },
	["rectangle-ellipsis"] = { 16898613699, 820, 196 },
	["rectangle-horizontal"] = { 16898613699, 196, 820 },
	["rectangle-vertical"] = { 16898613699, 147, 869 },
	["recycle"] = { 16898613699, 98, 918 },
	["redo"] = { 16898613699, 918, 355 },
	["redo-2"] = { 16898613699, 49, 967 },
	["redo-dot"] = { 16898613699, 967, 306 },
	["refresh-ccw"] = { 16898613699, 820, 453 },
	["refresh-ccw-dot"] = { 16898613699, 869, 404 },
	["refresh-cw"] = { 16898613699, 404, 869 },
	["refresh-cw-off"] = { 16898613699, 453, 820 },
	["refrigerator"] = { 16898613699, 355, 918 },
	["regex"] = { 16898613699, 306, 967 },
	["remove-formatting"] = { 16898613699, 967, 563 },
	["repeat"] = { 16898613699, 820, 710 },
	["repeat-1"] = { 16898613699, 918, 612 },
	["repeat-2"] = { 16898613699, 869, 661 },
	["replace"] = { 16898613699, 710, 820 },
	["replace-all"] = { 16898613699, 771, 759 },
	["reply"] = { 16898613699, 612, 918 },
	["reply-all"] = { 16898613699, 661, 869 },
	["rewind"] = { 16898613699, 563, 967 },
	["ribbon"] = { 16898613699, 967, 98 },
	["rocket"] = { 16898613699, 918, 147 },
	["rocking-chair"] = { 16898613699, 869, 196 },
	["roller-coaster"] = { 16898613699, 196, 869 },
	["rotate-3d"] = { 16898613699, 147, 918 },
	["rotate-ccw"] = { 16898613699, 967, 355 },
	["rotate-ccw-square"] = { 16898613699, 98, 967 },
	["rotate-cw"] = { 16898613699, 869, 453 },
	["rotate-cw-square"] = { 16898613699, 918, 404 },
	["route"] = { 16898613699, 404, 918 },
	["route-off"] = { 16898613699, 453, 869 },
	["router"] = { 16898613699, 355, 967 },
	["rows"] = { 16898613699, 820, 759 },
	["rows-2"] = { 16898613699, 967, 612 },
	["rows-3"] = { 16898613699, 918, 661 },
	["rows-4"] = { 16898613699, 869, 710 },
	["rss"] = { 16898613699, 771, 808 },
	["ruler"] = { 16898613699, 710, 869 },
	["russian-ruble"] = { 16898613699, 661, 918 },
	["sailboat"] = { 16898613699, 612, 967 },
	["salad"] = { 16898613699, 967, 147 },
	["sandwich"] = { 16898613699, 918, 196 },
	["satellite"] = { 16898613699, 147, 967 },
	["satellite-dish"] = { 16898613699, 196, 918 },
	["save"] = { 16898613699, 918, 453 },
	["save-all"] = { 16898613699, 967, 404 },
	["scale"] = { 16898613699, 404, 967 },
	["scale-3d"] = { 16898613699, 453, 918 },
	["scaling"] = { 16898613699, 967, 661 },
	["scan"] = { 16898613699, 967, 196 },
	["scan-barcode"] = { 16898613699, 918, 710 },
	["scan-eye"] = { 16898613699, 869, 759 },
	["scan-face"] = { 16898613699, 820, 808 },
	["scan-line"] = { 16898613699, 771, 857 },
	["scan-search"] = { 16898613699, 710, 918 },
	["scan-text"] = { 16898613699, 661, 967 },
	["scatter-chart"] = { 16898613699, 196, 967 },
	["school"] = { 16898613699, 453, 967 },
	["school-2"] = { 16898613699, 967, 453 },
	["scissors"] = { 16898613699, 820, 857 },
	["scissors-line-dashed"] = { 16898613699, 967, 710 },
	["scissors-square"] = { 16898613699, 869, 808 },
	["scissors-square-dashed-bottom"] = { 16898613699, 918, 759 },
	["screen-share"] = { 16898613699, 710, 967 },
	["screen-share-off"] = { 16898613699, 771, 906 },
	["scroll"] = { 16898613699, 918, 808 },
	["scroll-text"] = { 16898613699, 967, 759 },
	["search"] = { 16898613699, 918, 857 },
	["search-check"] = { 16898613699, 869, 857 },
	["search-code"] = { 16898613699, 820, 906 },
	["search-slash"] = { 16898613699, 771, 955 },
	["search-x"] = { 16898613699, 967, 808 },
	["send"] = { 16898613699, 967, 857 },
	["send-horizontal"] = { 16898613699, 869, 906 },
	["send-to-back"] = { 16898613699, 820, 955 },
	["separator-horizontal"] = { 16898613699, 918, 906 },
	["separator-vertical"] = { 16898613699, 869, 955 },
	["server"] = { 16898613777, 771, 0 },
	["server-cog"] = { 16898613699, 967, 906 },
	["server-crash"] = { 16898613699, 918, 955 },
	["server-off"] = { 16898613699, 967, 955 },
	["settings"] = { 16898613777, 771, 257 },
	["settings-2"] = { 16898613777, 0, 771 },
	["shapes"] = { 16898613777, 257, 771 },
	["share"] = { 16898613777, 514, 771 },
	["share-2"] = { 16898613777, 771, 514 },
	["sheet"] = { 16898613777, 820, 0 },
	["shell"] = { 16898613777, 771, 49 },
	["shield"] = { 16898613777, 869, 0 },
	["shield-alert"] = { 16898613777, 49, 771 },
	["shield-ban"] = { 16898613777, 0, 820 },
	["shield-check"] = { 16898613777, 820, 257 },
	["shield-ellipsis"] = { 16898613777, 771, 306 },
	["shield-half"] = { 16898613777, 306, 771 },
	["shield-minus"] = { 16898613777, 257, 820 },
	["shield-off"] = { 16898613777, 820, 514 },
	["shield-plus"] = { 16898613777, 771, 563 },
	["shield-question"] = { 16898613777, 563, 771 },
	["shield-x"] = { 16898613777, 514, 820 },
	["ship"] = { 16898613777, 771, 98 },
	["ship-wheel"] = { 16898613777, 820, 49 },
	["shirt"] = { 16898613777, 98, 771 },
	["shopping-bag"] = { 16898613777, 49, 820 },
	["shopping-basket"] = { 16898613777, 0, 869 },
	["shopping-cart"] = { 16898613777, 869, 257 },
	["shovel"] = { 16898613777, 820, 306 },
	["shower-head"] = { 16898613777, 771, 355 },
	["shrink"] = { 16898613777, 355, 771 },
	["shrub"] = { 16898613777, 306, 820 },
	["shuffle"] = { 16898613777, 257, 869 },
	["sigma"] = { 16898613777, 820, 563 },
	["sigma-square"] = { 16898613777, 869, 514 },
	["signal"] = { 16898613777, 918, 0 },
	["signal-high"] = { 16898613777, 771, 612 },
	["signal-low"] = { 16898613777, 612, 771 },
	["signal-medium"] = { 16898613777, 563, 820 },
	["signal-zero"] = { 16898613777, 514, 869 },
	["signpost"] = { 16898613777, 820, 98 },
	["signpost-big"] = { 16898613777, 869, 49 },
	["siren"] = { 16898613777, 771, 147 },
	["skip-back"] = { 16898613777, 147, 771 },
	["skip-forward"] = { 16898613777, 98, 820 },
	["skull"] = { 16898613777, 49, 869 },
	["slack"] = { 16898613777, 0, 918 },
	["slash"] = { 16898613777, 918, 257 },
	["slice"] = { 16898613777, 869, 306 },
	["sliders"] = { 16898613777, 404, 771 },
	["sliders-horizontal"] = { 16898613777, 820, 355 },
	["sliders-vertical"] = { 16898613777, 771, 404 },
	["smartphone"] = { 16898613777, 257, 918 },
	["smartphone-charging"] = { 16898613777, 355, 820 },
	["smartphone-nfc"] = { 16898613777, 306, 869 },
	["smile"] = { 16898613777, 869, 563 },
	["smile-plus"] = { 16898613777, 918, 514 },
	["snail"] = { 16898613777, 820, 612 },
	["snowflake"] = { 16898613777, 771, 661 },
	["sofa"] = { 16898613777, 661, 771 },
	["soup"] = { 16898613777, 612, 820 },
	["space"] = { 16898613777, 563, 869 },
	["spade"] = { 16898613777, 514, 918 },
	["sparkle"] = { 16898613777, 967, 0 },
	["sparkles"] = { 16898613777, 918, 49 },
	["speaker"] = { 16898613777, 869, 98 },
	["speech"] = { 16898613777, 820, 147 },
	["spell-check"] = { 16898613777, 196, 771 },
	["spell-check-2"] = { 16898613777, 771, 196 },
	["spline"] = { 16898613777, 147, 820 },
	["split"] = { 16898613777, 0, 967 },
	["split-square-horizontal"] = { 16898613777, 98, 869 },
	["split-square-vertical"] = { 16898613777, 49, 918 },
	["spray-can"] = { 16898613777, 967, 257 },
	["sprout"] = { 16898613777, 918, 306 },
	["square"] = { 16898613777, 869, 710 },
	["square-activity"] = { 16898613777, 869, 355 },
	["square-arrow-down"] = { 16898613777, 453, 771 },
	["square-arrow-down-left"] = { 16898613777, 820, 404 },
	["square-arrow-down-right"] = { 16898613777, 771, 453 },
	["square-arrow-left"] = { 16898613777, 404, 820 },
	["square-arrow-out-down-left"] = { 16898613777, 355, 869 },
	["square-arrow-out-down-right"] = { 16898613777, 306, 918 },
	["square-arrow-out-up-left"] = { 16898613777, 257, 967 },
	["square-arrow-out-up-right"] = { 16898613777, 967, 514 },
	["square-arrow-right"] = { 16898613777, 918, 563 },
	["square-arrow-up"] = { 16898613777, 771, 710 },
	["square-arrow-up-left"] = { 16898613777, 869, 612 },
	["square-arrow-up-right"] = { 16898613777, 820, 661 },
	["square-asterisk"] = { 16898613777, 710, 771 },
	["square-bottom-dashed-scissors"] = { 16898613777, 661, 820 },
	["square-check"] = { 16898613777, 563, 918 },
	["square-check-big"] = { 16898613777, 612, 869 },
	["square-chevron-down"] = { 16898613777, 514, 967 },
	["square-chevron-left"] = { 16898613777, 967, 49 },
	["square-chevron-right"] = { 16898613777, 918, 98 },
	["square-chevron-up"] = { 16898613777, 869, 147 },
	["square-code"] = { 16898613777, 820, 196 },
	["square-dashed-bottom"] = { 16898613777, 147, 869 },
	["square-dashed-bottom-code"] = { 16898613777, 196, 820 },
	["square-dashed-kanban"] = { 16898613777, 98, 918 },
	["square-dashed-mouse-pointer"] = { 16898613777, 49, 967 },
	["square-divide"] = { 16898613777, 967, 306 },
	["square-dot"] = { 16898613777, 918, 355 },
	["square-equal"] = { 16898613777, 869, 404 },
	["square-function"] = { 16898613777, 820, 453 },
	["square-gantt-chart"] = { 16898613777, 453, 820 },
	["square-kanban"] = { 16898613777, 404, 869 },
	["square-library"] = { 16898613777, 355, 918 },
	["square-m"] = { 16898613777, 306, 967 },
	["square-menu"] = { 16898613777, 967, 563 },
	["square-minus"] = { 16898613777, 918, 612 },
	["square-mouse-pointer"] = { 16898613777, 869, 661 },
	["square-parking"] = { 16898613777, 771, 759 },
	["square-parking-off"] = { 16898613777, 820, 710 },
	["square-pen"] = { 16898613777, 710, 820 },
	["square-percent"] = { 16898613777, 661, 869 },
	["square-pi"] = { 16898613777, 612, 918 },
	["square-pilcrow"] = { 16898613777, 563, 967 },
	["square-play"] = { 16898613777, 967, 98 },
	["square-plus"] = { 16898613777, 918, 147 },
	["square-power"] = { 16898613777, 869, 196 },
	["square-radical"] = { 16898613777, 196, 869 },
	["square-scissors"] = { 16898613777, 147, 918 },
	["square-sigma"] = { 16898613777, 98, 967 },
	["square-slash"] = { 16898613777, 967, 355 },
	["square-split-horizontal"] = { 16898613777, 918, 404 },
	["square-split-vertical"] = { 16898613777, 869, 453 },
	["square-stack"] = { 16898613777, 453, 869 },
	["square-terminal"] = { 16898613777, 404, 918 },
	["square-user"] = { 16898613777, 967, 612 },
	["square-user-round"] = { 16898613777, 355, 967 },
	["square-x"] = { 16898613777, 918, 661 },
	["squircle"] = { 16898613777, 820, 759 },
	["squirrel"] = { 16898613777, 771, 808 },
	["stamp"] = { 16898613777, 710, 869 },
	["star"] = { 16898613777, 967, 147 },
	["star-half"] = { 16898613777, 661, 918 },
	["star-off"] = { 16898613777, 612, 967 },
	["step-back"] = { 16898613777, 918, 196 },
	["step-forward"] = { 16898613777, 196, 918 },
	["stethoscope"] = { 16898613777, 147, 967 },
	["sticker"] = { 16898613777, 967, 404 },
	["sticky-note"] = { 16898613777, 918, 453 },
	["stop-circle"] = { 16898613777, 453, 918 },
	["store"] = { 16898613777, 404, 967 },
	["stretch-horizontal"] = { 16898613777, 967, 661 },
	["stretch-vertical"] = { 16898613777, 918, 710 },
	["strikethrough"] = { 16898613777, 869, 759 },
	["subscript"] = { 16898613777, 820, 808 },
	["subtitles"] = { 16898613777, 771, 857 },
	["sun"] = { 16898613777, 967, 453 },
	["sun-dim"] = { 16898613777, 710, 918 },
	["sun-medium"] = { 16898613777, 661, 967 },
	["sun-moon"] = { 16898613777, 967, 196 },
	["sun-snow"] = { 16898613777, 196, 967 },
	["sunrise"] = { 16898613777, 453, 967 },
	["sunset"] = { 16898613777, 967, 710 },
	["superscript"] = { 16898613777, 918, 759 },
	["swatch-book"] = { 16898613777, 869, 808 },
	["swiss-franc"] = { 16898613777, 820, 857 },
	["switch-camera"] = { 16898613777, 771, 906 },
	["sword"] = { 16898613777, 710, 967 },
	["swords"] = { 16898613777, 967, 759 },
	["syringe"] = { 16898613777, 918, 808 },
	["table"] = { 16898613777, 820, 955 },
	["table-2"] = { 16898613777, 869, 857 },
	["table-cells-merge"] = { 16898613777, 820, 906 },
	["table-cells-split"] = { 16898613777, 771, 955 },
	["table-columns-split"] = { 16898613777, 967, 808 },
	["table-properties"] = { 16898613777, 918, 857 },
	["table-rows-split"] = { 16898613777, 869, 906 },
	["tablet"] = { 16898613777, 918, 906 },
	["tablet-smartphone"] = { 16898613777, 967, 857 },
	["tablets"] = { 16898613777, 869, 955 },
	["tag"] = { 16898613777, 967, 906 },
	["tags"] = { 16898613777, 918, 955 },
	["tally-1"] = { 16898613777, 967, 955 },
	["tally-2"] = { 16898613869, 771, 0 },
	["tally-3"] = { 16898613869, 0, 771 },
	["tally-4"] = { 16898613869, 771, 257 },
	["tally-5"] = { 16898613869, 257, 771 },
	["tangent"] = { 16898613869, 771, 514 },
	["target"] = { 16898613869, 514, 771 },
	["telescope"] = { 16898613869, 820, 0 },
	["tent"] = { 16898613869, 49, 771 },
	["tent-tree"] = { 16898613869, 771, 49 },
	["terminal"] = { 16898613869, 820, 257 },
	["terminal-square"] = { 16898613869, 0, 820 },
	["test-tube"] = { 16898613869, 257, 820 },
	["test-tube-2"] = { 16898613869, 771, 306 },
	["test-tube-diagonal"] = { 16898613869, 306, 771 },
	["test-tubes"] = { 16898613869, 820, 514 },
	["text"] = { 16898613869, 771, 98 },
	["text-cursor"] = { 16898613869, 563, 771 },
	["text-cursor-input"] = { 16898613869, 771, 563 },
	["text-quote"] = { 16898613869, 514, 820 },
	["text-search"] = { 16898613869, 869, 0 },
	["text-select"] = { 16898613869, 820, 49 },
	["theater"] = { 16898613869, 98, 771 },
	["thermometer"] = { 16898613869, 869, 257 },
	["thermometer-snowflake"] = { 16898613869, 49, 820 },
	["thermometer-sun"] = { 16898613869, 0, 869 },
	["thumbs-down"] = { 16898613869, 820, 306 },
	["thumbs-up"] = { 16898613869, 771, 355 },
	["ticket"] = { 16898613869, 612, 771 },
	["ticket-check"] = { 16898613869, 355, 771 },
	["ticket-minus"] = { 16898613869, 306, 820 },
	["ticket-percent"] = { 16898613869, 257, 869 },
	["ticket-plus"] = { 16898613869, 869, 514 },
	["ticket-slash"] = { 16898613869, 820, 563 },
	["ticket-x"] = { 16898613869, 771, 612 },
	["timer"] = { 16898613869, 918, 0 },
	["timer-off"] = { 16898613869, 563, 820 },
	["timer-reset"] = { 16898613869, 514, 869 },
	["toggle-left"] = { 16898613869, 869, 49 },
	["toggle-right"] = { 16898613869, 820, 98 },
	["tornado"] = { 16898613869, 771, 147 },
	["torus"] = { 16898613869, 147, 771 },
	["touchpad"] = { 16898613869, 49, 869 },
	["touchpad-off"] = { 16898613869, 98, 820 },
	["tower-control"] = { 16898613869, 0, 918 },
	["toy-brick"] = { 16898613869, 918, 257 },
	["tractor"] = { 16898613869, 869, 306 },
	["traffic-cone"] = { 16898613869, 820, 355 },
	["train-front"] = { 16898613869, 404, 771 },
	["train-front-tunnel"] = { 16898613869, 771, 404 },
	["train-track"] = { 16898613869, 355, 820 },
	["tram-front"] = { 16898613869, 306, 869 },
	["trash"] = { 16898613869, 918, 514 },
	["trash-2"] = { 16898613869, 257, 918 },
	["tree-deciduous"] = { 16898613869, 869, 563 },
	["tree-palm"] = { 16898613869, 820, 612 },
	["tree-pine"] = { 16898613869, 771, 661 },
	["trees"] = { 16898613869, 661, 771 },
	["trello"] = { 16898613869, 612, 820 },
	["trending-down"] = { 16898613869, 563, 869 },
	["trending-up"] = { 16898613869, 514, 918 },
	["triangle"] = { 16898613869, 869, 98 },
	["triangle-alert"] = { 16898613869, 967, 0 },
	["triangle-right"] = { 16898613869, 918, 49 },
	["trophy"] = { 16898613869, 820, 147 },
	["truck"] = { 16898613869, 771, 196 },
	["turtle"] = { 16898613869, 196, 771 },
	["tv"] = { 16898613869, 98, 869 },
	["tv-2"] = { 16898613869, 147, 820 },
	["twitch"] = { 16898613869, 49, 918 },
	["twitter"] = { 16898613869, 0, 967 },
	["type"] = { 16898613869, 967, 257 },
	["umbrella"] = { 16898613869, 869, 355 },
	["umbrella-off"] = { 16898613869, 918, 306 },
	["underline"] = { 16898613869, 820, 404 },
	["undo"] = { 16898613869, 404, 820 },
	["undo-2"] = { 16898613869, 771, 453 },
	["undo-dot"] = { 16898613869, 453, 771 },
	["unfold-horizontal"] = { 16898613869, 355, 869 },
	["unfold-vertical"] = { 16898613869, 306, 918 },
	["ungroup"] = { 16898613869, 257, 967 },
	["university"] = { 16898613869, 967, 514 },
	["unlink"] = { 16898613869, 869, 612 },
	["unlink-2"] = { 16898613869, 918, 563 },
	["unlock"] = { 16898613869, 771, 710 },
	["unlock-keyhole"] = { 16898613869, 820, 661 },
	["unplug"] = { 16898613869, 710, 771 },
	["upload"] = { 16898613869, 612, 869 },
	["upload-cloud"] = { 16898613869, 661, 820 },
	["usb"] = { 16898613869, 563, 918 },
	["user"] = { 16898613869, 661, 869 },
	["user-2"] = { 16898613869, 514, 967 },
	["user-check"] = { 16898613869, 918, 98 },
	["user-check-2"] = { 16898613869, 967, 49 },
	["user-circle"] = { 16898613869, 820, 196 },
	["user-circle-2"] = { 16898613869, 869, 147 },
	["user-cog"] = { 16898613869, 147, 869 },
	["user-cog-2"] = { 16898613869, 196, 820 },
	["user-minus"] = { 16898613869, 49, 967 },
	["user-minus-2"] = { 16898613869, 98, 918 },
	["user-plus"] = { 16898613869, 918, 355 },
	["user-plus-2"] = { 16898613869, 967, 306 },
	["user-round"] = { 16898613869, 967, 563 },
	["user-round-check"] = { 16898613869, 869, 404 },
	["user-round-cog"] = { 16898613869, 820, 453 },
	["user-round-minus"] = { 16898613869, 453, 820 },
	["user-round-plus"] = { 16898613869, 404, 869 },
	["user-round-search"] = { 16898613869, 355, 918 },
	["user-round-x"] = { 16898613869, 306, 967 },
	["user-search"] = { 16898613869, 918, 612 },
	["user-square"] = { 16898613869, 820, 710 },
	["user-square-2"] = { 16898613869, 869, 661 },
	["user-x"] = { 16898613869, 710, 820 },
	["user-x-2"] = { 16898613869, 771, 759 },
	["users"] = { 16898613869, 967, 98 },
	["users-2"] = { 16898613869, 612, 918 },
	["users-round"] = { 16898613869, 563, 967 },
	["utensils"] = { 16898613869, 869, 196 },
	["utensils-crossed"] = { 16898613869, 918, 147 },
	["utility-pole"] = { 16898613869, 196, 869 },
	["variable"] = { 16898613869, 147, 918 },
	["vault"] = { 16898613869, 98, 967 },
	["vegan"] = { 16898613869, 967, 355 },
	["venetian-mask"] = { 16898613869, 918, 404 },
	["vibrate"] = { 16898613869, 453, 869 },
	["vibrate-off"] = { 16898613869, 869, 453 },
	["video"] = { 16898613869, 355, 967 },
	["video-off"] = { 16898613869, 404, 918 },
	["videotape"] = { 16898613869, 967, 612 },
	["view"] = { 16898613869, 918, 661 },
	["voicemail"] = { 16898613869, 869, 710 },
	["volume"] = { 16898613869, 661, 918 },
	["volume-1"] = { 16898613869, 820, 759 },
	["volume-2"] = { 16898613869, 771, 808 },
	["volume-x"] = { 16898613869, 710, 869 },
	["vote"] = { 16898613869, 612, 967 },
	["wallet"] = { 16898613869, 147, 967 },
	["wallet-2"] = { 16898613869, 967, 147 },
	["wallet-cards"] = { 16898613869, 918, 196 },
	["wallet-minimal"] = { 16898613869, 196, 918 },
	["wallpaper"] = { 16898613869, 967, 404 },
	["wand"] = { 16898613869, 404, 967 },
	["wand-2"] = { 16898613869, 918, 453 },
	["wand-sparkles"] = { 16898613869, 453, 918 },
	["warehouse"] = { 16898613869, 967, 661 },
	["washing-machine"] = { 16898613869, 918, 710 },
	["watch"] = { 16898613869, 869, 759 },
	["waves"] = { 16898613869, 820, 808 },
	["waypoints"] = { 16898613869, 771, 857 },
	["webcam"] = { 16898613869, 710, 918 },
	["webhook"] = { 16898613869, 967, 196 },
	["webhook-off"] = { 16898613869, 661, 967 },
	["weight"] = { 16898613869, 196, 967 },
	["wheat"] = { 16898613869, 453, 967 },
	["wheat-off"] = { 16898613869, 967, 453 },
	["whole-word"] = { 16898613869, 967, 710 },
	["wifi"] = { 16898613869, 869, 808 },
	["wifi-off"] = { 16898613869, 918, 759 },
	["wind"] = { 16898613869, 820, 857 },
	["wine"] = { 16898613869, 710, 967 },
	["wine-off"] = { 16898613869, 771, 906 },
	["workflow"] = { 16898613869, 967, 759 },
	["worm"] = { 16898613869, 918, 808 },
	["wrap-text"] = { 16898613869, 869, 857 },
	["wrench"] = { 16898613869, 820, 906 },
	["x"] = { 16898613869, 869, 906 },
	["x-circle"] = { 16898613869, 771, 955 },
	["x-octagon"] = { 16898613869, 967, 808 },
	["x-square"] = { 16898613869, 918, 857 },
	["youtube"] = { 16898613869, 820, 955 },
	["zap"] = { 16898613869, 918, 906 },
	["zap-off"] = { 16898613869, 967, 857 },
	["zoom-in"] = { 16898613869, 869, 955 },
	["zoom-out"] = { 16898613869, 967, 906 },
}
local customicons = {}
local customaliases = {}


local function normalizeiconname(name)
	return (tostring(name or "")
		:gsub("^%s+", "")
		:gsub("%s+$", "")
		:lower()
		:gsub("[_%s]+", "-"))
end

local iconfallback = {}
for key, value in pairs(iconfallbackdata) do
	iconfallback[normalizeiconname(key)] = value
end

local function iconstring(value)
	if type(value) == "number" then
		return string.format("%.0f", value)
	end
	return (tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function iconcandidates(raw)
	local key = normalizeiconname(raw)
	local list, seen = {}, {}
	local function push(value)
		value = normalizeiconname(value)
		if value ~= "" and not seen[value] then
			seen[value] = true
			list[#list + 1] = value
			return true
		end
		return false
	end
	local function expand(name, depth)
		local mapped = customaliases[name]
		if mapped == nil then
			mapped = iconaliases[name]
		end
		if type(mapped) == "string" then
			mapped = { mapped }
		end
		if type(mapped) == "table" then
			for _, target in ipairs(mapped) do
				if push(target) and depth < 4 then
					expand(normalizeiconname(target), depth + 1)
				end
			end
		end
	end
	expand(key, 0)
	push(key)
	return list
end

local function setimage(image, asset, offset, rect)
	return (pcall(function()
		image.Image = asset or ""
		image.ImageRectOffset = offset or Vector2.new(0, 0)
		image.ImageRectSize = rect or Vector2.new(0, 0)
	end))
end


local function standaloneasset(candidates)
	for _, candidate in ipairs(candidates) do
		local custom = customicons[candidate]
		if custom then
			return custom
		end
	end
	for _, candidate in ipairs(candidates) do
		local fallback = iconfallback[candidate]
		if fallback then
			return fallback
		end
	end
	local registry = iconnames
	for _, candidate in ipairs(candidates) do
		local direct = registry[candidate]
		if type(direct) == "string" and direct ~= "" then
			return direct
		end
	end
	return nil
end

local function directiconstring(raw)
	if raw:match("^%d+$") then
		return "rbxassetid://" .. raw
	end
	local lower = raw:lower()
	if lower:match("^rbxassetid://") or lower:match("^rbxasset://") or lower:match("^https?://") or lower:match("^rbxthumb://") then
		return raw
	end
	return nil
end

local function resolveiconasset(icon)
	local raw = iconstring(icon)
	if raw == "" then
		return nil
	end
	return directiconstring(raw) or standaloneasset(iconcandidates(raw))
end

local function hasimage(value)
	return value ~= nil and value ~= ""
end

local contentprovider = game:GetService("ContentProvider")

local function thumbnail(kind, id, width, height)
	width = tonumber(width) or 150
	return string.format("rbxthumb://type=%s&id=%.0f&w=%d&h=%d", tostring(kind or "AvatarHeadShot"), tonumber(id) or 0, width, tonumber(height) or width)
end

local applyicon

local function guardimage(image, source)
	image:SetAttribute("mxsource", source)
	task.spawn(function()
		pcall(function()
			contentprovider:PreloadAsync({ image }, function(_, status)
				if status ~= Enum.AssetFetchStatus.Success and image.Parent and image:GetAttribute("mxsource") == source then
					applyicon(image, "image-off", 48)
				end
			end)
		end)
	end)
end

function applyicon(image, icon, size)
	if not image then
		return false
	end
	image:SetAttribute("mxsource", nil)
	local raw = iconstring(icon)
	if raw == "" then
		setimage(image, "")
		return false
	end
	local direct = directiconstring(raw)
	if direct then
		local shown = setimage(image, direct)
		if not direct:lower():match("^rbxasset://") then
			guardimage(image, direct)
		end
		return shown
	end
	local candidates = iconcandidates(raw)
	for _, candidate in ipairs(candidates) do
		local custom = customicons[candidate]
		if custom then
			return setimage(image, custom)
		end
	end
	if (tonumber(size) or 48) <= 64 then
		for _, candidate in ipairs(candidates) do
			local baked = bakedsprites[candidate]
			if baked then
				return setimage(
					image,
					"rbxassetid://" .. tostring(baked[1]),
					Vector2.new(baked[4], baked[5]),
					Vector2.new(baked[2], baked[3])
				)
			end
		end
	end
	for _, candidate in ipairs(candidates) do
		local sprite = lucidesprites[candidate]
		if sprite then
			return setimage(image, "rbxassetid://" .. tostring(sprite[1]), Vector2.new(sprite[2], sprite[3]), Vector2.new(48, 48))
		end
	end
	local asset = standaloneasset(candidates)
	setimage(image, asset or "")
	return asset ~= nil
end
if getgenv().MXHUB_Running then
	if getgenv().MXHUB_ReopenPrompt then
		return
	end

	getgenv().MXHUB_ReopenPrompt = true

	local bind = Instance.new("BindableFunction")
	local result = nil

	bind.OnInvoke = function(answer)
		result = answer == "Re-Open"
	end

	pcall(function()
		sv.sg:SetCore("SendNotification", {
			Title = "MX HUB Already Opened",
			Text = "Destroy and Re-Open MX HUB?",
			Icon = assets.Logo,
			Duration = 10,
			Button1 = "Re-Open",
			Button2 = "Cancel",
			Callback = bind,
		})
	end)

	task.delay(10, function()
		if result == nil then
			result = false
		end
	end)

	repeat
		task.wait()
	until result ~= nil

	bind:Destroy()
	getgenv().MXHUB_ReopenPrompt = nil

	if not result then
		return
	end

	if getgenv().MXHUB_Instance then
		pcall(function()
			getgenv().MXHUB_Instance:DestroyGui()
		end)
	else
		for _, name in ipairs({
			"MXHUBUI",
			"ToggleUIButton",
			"PopupGui",
		}) do
			local old = sv.coregui:FindFirstChild(name)
			if old then
				old:Destroy()
			end
		end

		getgenv().MXHUB_Running = nil
		getgenv().MXHUB_ReopenPrompt = nil
		getgenv().MXHUB_Instance = nil
	end
end

getgenv().MXHUB_Running = true

local allConnections = {}
local resizeDebounceTable = {}

local function trackConnection(conn, name)
	if not conn then
		return nil
	end
	table.insert(allConnections, { conn = conn, name = name or "unnamed" })
	return conn
end

local function disconnectAll()
	for _, entry in ipairs(allConnections) do
		if entry.conn then
			pcall(function()
				entry.conn:Disconnect()
			end)
		end
	end
	allConnections = {}
end

local function debounceResize(key, callback, delay)
	delay = delay or 0.1
	if resizeDebounceTable[key] then
		task.cancel(resizeDebounceTable[key])
	end
	resizeDebounceTable[key] = task.delay(delay, function()
		pcall(function()
			callback()
		end)
		resizeDebounceTable[key] = nil
	end)
end

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
local config = { gamefolder = nil, autoloadfile = nil, data = {}, elements = {}, version = nil, current = nil, loaded = false }

local metakeys = {
	["Input_Config Name"] = true,
	["Input_External Config"] = true,
}

local function packconfig(data)
	local out = {}
	for key, value in pairs(data or {}) do
		local keep = not metakeys[key]
		if value == false or value == nil then
			keep = false
		elseif type(value) == "string" and value:gsub("%s+", "") == "" then
			keep = false
		elseif type(value) == "table" and next(value) == nil then
			keep = false
		end
		if keep then
			out[key] = value
		end
	end
	return out
end

local function missingdefault(key, element)
	if key:match("^Toggle_") then
		return false
	elseif key:match("^Input_") then
		return ""
	elseif key:match("^Dropdown_") then
		if type(element.Value) == "table" then
			return {}
		end
		return nil
	end
	return nil
end
local instance = {}
local classes = {
	"ScreenGui",
	"BillboardGui",
	"SurfaceGui",
	"ViewportFrame",
	"CanvasGroup",
	"Frame",
	"ScrollingFrame",
	"VideoFrame",
	"TextLabel",
	"TextButton",
	"TextBox",
	"ImageLabel",
	"ImageButton",
	"UIListLayout",
	"UIGridLayout",
	"UITableLayout",
	"UIPageLayout",
	"UIFlexItem",
	"UIAspectRatioConstraint",
	"UISizeConstraint",
	"UITextSizeConstraint",
	"UIPadding",
	"UICorner",
	"UIStroke",
	"UIGradient",
	"Folder",
	"Configuration",
	"BoolValue",
	"IntValue",
	"NumberValue",
	"StringValue",
	"Color3Value",
	"Vector3Value",
	"CFrameValue",
	"ObjectValue",
	"UIScale",
	"UITextSizeConstraint",
	"LocalizationTable",
}

local uilocked = false

local draggable = {
	dragging = false,
	resizing = false,
	draginput = nil,
	resizeinput = nil,
	dragstart = nil,
	resizestart = nil,
	startpos = nil,
	startsize = nil,
	minx = 420,
	miny = 260,
	defx = 720,
	defy = 470,
	mobilex = 600,
	mobiley = 400,
}

local sliderDrag = { active = nil, lastUpdateTime = 0 }
local sliderUpdateThrottle = 1 / 60

trackConnection(
	sv.uis.InputChanged:Connect(function(input)
		local active = sliderDrag.active
		if not active then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then

			if
				active.input
				and active.input.UserInputType == Enum.UserInputType.MouseButton1
				and not sv.uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			then
				sliderDrag.active = nil
				active.hidebubble()
				return
			end
		elseif input.UserInputType == Enum.UserInputType.Touch then

			if active.input ~= input then
				return
			end
		else
			return
		end
		local now = tick()
		if (now - sliderDrag.lastUpdateTime) > sliderUpdateThrottle then
			active.setfromx(input.Position.X)
			sliderDrag.lastUpdateTime = now
		end
	end),
	"global.sliderDrag.InputChanged"
)

trackConnection(
	sv.uis.InputEnded:Connect(function(input)
		local active = sliderDrag.active
		if not active then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or (input.UserInputType == Enum.UserInputType.Touch and input == active.input)
		then
			sliderDrag.active = nil
			active.hidebubble()
		end
	end),
	"global.sliderDrag.InputEnded"
)

for _, class in ipairs(classes) do
	instance[class:lower()] = function(parent)
		local obj = Instance.new(class)
		obj.Parent = parent
		return obj
	end
end

local sliceimage = assets.Slice
local rowalpha = 0

local function roundbg(parent, radius, color, native)
	if native or parent:IsA("TextButton") then
		parent.BackgroundColor3 = color
		parent.BackgroundTransparency = rowalpha
		parent.BorderSizePixel = 0
		local corner = parent:FindFirstChildOfClass("UICorner") or instance.uicorner(parent)
		corner.CornerRadius = UDim.new(0, radius)
		return setmetatable({}, {
			__index = function(_, key)
				if key == "ImageColor3" then
					return parent.BackgroundColor3
				elseif key == "ImageTransparency" then
					return parent.BackgroundTransparency
				end
				return nil
			end,
			__newindex = function(_, key, value)
				if key == "ImageColor3" then
					parent.BackgroundColor3 = value
				elseif key == "ImageTransparency" then
					parent.BackgroundTransparency = value
				end
			end,
		})
	end
	parent.BackgroundTransparency = 1
	local bg = instance.imagelabel(parent)
	bg.Name = "Bg"
	bg.BackgroundTransparency = 1
	bg.BorderSizePixel = 0
	bg.ImageTransparency = rowalpha
	bg.Image = sliceimage
	bg.ScaleType = Enum.ScaleType.Slice
	bg.SliceCenter = Rect.new(100, 100, 100, 100)
	bg.SliceScale = radius / 100
	bg.ImageColor3 = color
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.ZIndex = 0
	return bg
end

local function hoverbg(button, bg, normal, hover)
	button.MouseEnter:Connect(function()
		bg.ImageColor3 = hover
	end)
	button.MouseLeave:Connect(function()
		bg.ImageColor3 = normal
	end)
	button.MouseButton1Down:Connect(function()
		bg.ImageColor3 = normal
	end)
	button.MouseButton1Up:Connect(function()
		bg.ImageColor3 = hover
	end)
end

local function pesseffect(button)
	local scale = button:FindFirstChild("PressScale")
	if not scale then
		scale = Instance.new("UIScale")
		scale.Name = "PressScale"
		scale.Parent = button
	end
	sv.ts:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.96 }):Play()
	task.delay(0.08, function()
		if scale.Parent then
			sv.ts:Create(scale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
		end
	end)
end

local function tw(object, props, duration, style, direction)
	if not object then
		return
	end
	local ok = pcall(function()
		sv.ts
			:Create(
				object,
				TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
				props
			)
			:Play()
	end)
	if not ok then
		for key, value in pairs(props) do
			pcall(function()
				object[key] = value
			end)
		end
	end
end

local keydisplay = {
	LeftControl = "LCtrl",
	RightControl = "RCtrl",
	LeftShift = "LShift",
	RightShift = "RShift",
	LeftAlt = "LAlt",
	RightAlt = "RAlt",
	Return = "Enter",
	Escape = "Esc",
	Backspace = "Bksp",
	Delete = "Del",
	Insert = "Ins",
	PageUp = "PgUp",
	PageDown = "PgDn",
	CapsLock = "Caps",
	Zero = "0",
	One = "1",
	Two = "2",
	Three = "3",
	Four = "4",
	Five = "5",
	Six = "6",
	Seven = "7",
	Eight = "8",
	Nine = "9",
	Backquote = "`",
	Minus = "-",
	Equals = "=",
	LeftBracket = "[",
	RightBracket = "]",
	BackSlash = "\\",
	Semicolon = ";",
	Quote = "'",
	Comma = ",",
	Period = ".",
	Slash = "/",
	MouseButton2 = "RMB",
	MouseButton3 = "MMB",
}

local function keyname(key)
	if not key then
		return "None"
	end
	return keydisplay[key.Name] or key.Name
end

local function resolvekey(value)
	if value == nil or value == false or value == "" or value == "None" then
		return nil
	end
	if typeof(value) == "EnumItem" then
		if value == Enum.KeyCode.Unknown then
			return nil
		end
		if value.EnumType == Enum.KeyCode then
			return value
		end
		if value == Enum.UserInputType.MouseButton2 or value == Enum.UserInputType.MouseButton3 then
			return value
		end
		return nil
	end
	local name = tostring(value):gsub("^Enum%.%a+%.", "")
	if name == "MouseButton2" or name == "MouseButton3" then
		return Enum.UserInputType[name]
	end
	local ok, key = pcall(function()
		return Enum.KeyCode[name]
	end)
	if ok and key and key ~= Enum.KeyCode.Unknown then
		return key
	end
	return nil
end

local function inputmatches(input, key)
	if not key then
		return false
	end
	if key.EnumType == Enum.KeyCode then
		return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key
	end
	return input.UserInputType == key
end

local hasfs = type(isfolder) == "function" and type(makefolder) == "function"
if hasfs and not isfolder("MX HUB") then
	pcall(makefolder, "MX HUB")
end

function config.cleanname(name)
	name = tostring(name or "")
	name = name:gsub("[%c\\/:*?\"<>|]", "")
	name = name:gsub("%.%.+", "")
	name = name:gsub("^[%s%.]+", ""):gsub("[%s%.]+$", "")
	if #name > 48 then
		name = name:sub(1, 48):gsub("%s+$", "")
	end
	return name
end

function config:ensurefolders()
	if type(makefolder) ~= "function" or type(isfolder) ~= "function" then
		return false
	end
	pcall(function()
		if not isfolder("MX HUB") then
			makefolder("MX HUB")
		end
		if self.gamefolder and not isfolder(self.gamefolder) then
			makefolder(self.gamefolder)
		end
	end)
	local ok, exists = pcall(isfolder, self.gamefolder or "")
	return ok and exists == true
end

function config:getlist()
	local configs = {}

	if isfolder and listfiles and self.gamefolder and isfolder(self.gamefolder) then
		for _, filepath in pairs(listfiles(self.gamefolder)) do
			local filename = filepath:match("([^/\\]+)%.json$")
			if filename then
				table.insert(configs, filename)
			end
		end
	end

	table.sort(configs, function(a, b)
		return a:lower() < b:lower()
	end)
	return configs
end

function config:getautoload()
	if isfile and self.autoloadfile and isfile(self.autoloadfile) then
		local success, content = pcall(readfile, self.autoloadfile)

		if success and content and content ~= "" then
			return content:match("^%s*(.-)%s*$")
		end
	end

	return nil
end

function config:setautoload(name)
	name = config.cleanname(name)
	if name == "" then
		return false
	end
	self:ensurefolders()

	if writefile and self.autoloadfile then
		writefile(self.autoloadfile, tostring(name))
		print("[MX HUB] Autoload config set to: " .. tostring(name))
		return true
	end

	return false
end

function config:clearautoload()
	if delfile and self.autoloadfile and isfile(self.autoloadfile) then
		delfile(self.autoloadfile)
		print("[MX HUB] Autoload config cleared")
		return true
	end

	return false
end

function config:save(name)
	name = config.cleanname(name)
	if name == "" then
		warn("[MX HUB] Config name cannot be empty")
		return false
	end

	if not writefile or not self.gamefolder then
		return false
	end

	if not self:ensurefolders() then
		warn("[MX HUB] Could not create the config folder")
		return false
	end

	self.data._version = self.version

	local ok, err = pcall(function()
		local filepath = self.gamefolder .. "/" .. name .. ".json"
		writefile(filepath, sv.http:JSONEncode(packconfig(self.data)))
	end)
	if not ok then
		warn("[MX HUB] Config save failed: " .. tostring(err))
		return false
	end

	self.current = name
	return true
end

function config:savecurrent()
	local name = self.current
	if not name or name == "" then
		name = "default"
	end
	if self:save(name) then
		return name
	end
	return nil
end

function config:load(name)
	name = config.cleanname(name)
	if name == "" then
		warn("[MX HUB] Config name cannot be empty")
		return false
	end

	if not self.version then
		return false
	end

	local filepath = self.gamefolder .. "/" .. name .. ".json"

	if not isfile or not isfile(filepath) then
		warn("[MX HUB] Config file not found: " .. name)
		return false
	end

	local success, result = pcall(function()
		return sv.http:JSONDecode(readfile(filepath))
	end)

	if not success or type(result) ~= "table" then
		warn("[MX HUB] Failed to decode config")
		return false
	end

	if result._version ~= self.version then
		warn("[MX HUB] Config version mismatch")
		return false
	end

	self.data = result
	self.current = name
	self.loaded = true
	self:loadelements()

	print("[MX HUB] Config loaded: " .. name)
	return true
end

function config:delete(name)
	name = config.cleanname(name)
	if name == "" then
		warn("[MX HUB] Config name cannot be empty")
		return false
	end

	local filepath = self.gamefolder .. "/" .. name .. ".json"

	if not delfile or not isfile or not isfile(filepath) then
		warn("[MX HUB] Config file not found: " .. name)
		return false
	end

	delfile(filepath)
	print("[MX HUB] Config deleted: " .. name)

	if self:getautoload() == name then
		self:clearautoload()
	end

	if self.current == name then
		self.current = nil
	end

	return true
end

function config:loadelements()
	for key, element in pairs(self.elements) do
		if element.Set and not metakeys[key] then
			local value = self.data[key]
			local apply = value ~= nil
			if value == nil then
				value = missingdefault(key, element)
				apply = value ~= nil or key:match("^Dropdown_") ~= nil
			end
			if apply then
				local ok, err = pcall(function()
					if element.LoadValue then
						element:LoadValue(value)
					else
						element:Set(value, true)
					end
				end)
				if not ok then
					warn("[MX HUB] Config load failed for " .. tostring(key) .. ":", err)
				end
			end
		end
	end
end

function config:reset()
	self.data = {
		_version = self.version,
	}
	self.loaded = false

	for key, element in pairs(self.elements) do
		if element.Set then
			pcall(function()
				if element.ResetValue then

					element:ResetValue()
				elseif key:match("^Toggle_") then
					element:Set(false)
				elseif key:match("^Input_") then
					element:Set("")
				elseif key:match("^Dropdown_") then
					if type(element.Value) == "table" then
						element:Set({})
					else
						element:Set(nil)
					end
				end
			end)
		end
	end

	print("[MX HUB] Elements reset to defaults")
end

function config:loadexternal(json)
	if not json or json == "" then
		warn("[MX HUB] External config JSON is empty")
		return false
	end

	local success, data = pcall(function()
		return sv.http:JSONDecode(json)
	end)

	if not success or type(data) ~= "table" then
		warn("[MX HUB] External config JSON invalid")
		return false
	end

	if data._version and self.version and data._version ~= self.version then
		warn("[MX HUB] External config version mismatch")
		return false
	end

	self.data = data
	self.loaded = true
	self:loadelements()

	print("[MX HUB] External config loaded from JSON input")
	return true
end

local function isMobileDevice()
	return sv.uis.TouchEnabled and not sv.uis.KeyboardEnabled and not sv.uis.MouseEnabled
end

local function currentViewportSize()
	local camera = workspace.CurrentCamera
	if camera then
		local ok, viewport = pcall(function() return camera.ViewportSize end)
		if ok and viewport and viewport.X > 0 and viewport.Y > 0 then
			return viewport
		end
	end
	return Vector2.new(1280, 720)
end

local isMobile = isMobileDevice()

local function fitscaleof(object)
	local scale = 1
	local node = object
	while node do
		local ok, found = pcall(function()
			return node:FindFirstChild("FitScale")
		end)
		if ok and found and found:IsA("UIScale") then
			scale = scale * found.Scale
		end
		node = node.Parent
	end
	return math.max(scale, 0.01)
end

local function safesize(width, height)
	local viewport = currentViewportSize()

	local x = width / viewport.X
	local y = height / viewport.Y

	if isMobile then
		x = math.min(x, 0.5)
		y = math.min(y, 0.3)
	end

	return UDim2.new(x, 0, y, 0)
end

local function makedraggable(topbar, object)
	if isMobile then

		local viewport = currentViewportSize()
		draggable.defx = math.max(draggable.minx, math.min(draggable.mobilex, viewport.X - 24))
		draggable.defy = math.max(draggable.miny, math.min(draggable.mobiley, viewport.Y - 24))
	end

	object.Size = UDim2.new(0, draggable.defx, 0, draggable.defy)

	local fit = Instance.new("UIScale")
	fit.Name = "FitScale"
	fit.Parent = object

	local function adaptivefactor(viewport)
		if isMobile then
			return 1
		end
		local factor = math.min(viewport.X / 1920, viewport.Y / 1020)
		if factor > 0.9 and factor < 1.15 then
			return 1
		end
		return math.clamp(math.floor(factor * 20 + 0.5) / 20, 0.85, 1.75)
	end

	local function fitwindow()
		local screen = object.Parent
		if not screen or screen.AbsoluteSize.X == 0 or screen.AbsoluteSize.Y == 0 then
			return
		end
		local viewport = screen.AbsoluteSize
		local size = object.Size
		local scale = math.min(
			adaptivefactor(viewport) * (object:GetAttribute("MXScalable") and (sv.UserScale or 1) or 1),
			(viewport.X - 24) / math.max(size.X.Offset, 1),
			(viewport.Y - 24) / math.max(size.Y.Offset, 1)
		)
		fit.Scale = math.max(scale, 0.45)
	end

	local function clampwindow()
		local screen = object.Parent
		if not screen or screen.AbsoluteSize.X == 0 or screen.AbsoluteSize.Y == 0 then
			return
		end
		local viewport, scale = screen.AbsoluteSize, fit.Scale
		local limitx = math.max((viewport.X - object.Size.X.Offset * scale) / 2 / scale, 0)
		local limity = math.max((viewport.Y - object.Size.Y.Offset * scale) / 2 / scale, 0)
		local p = object.Position
		object.Position = UDim2.new(
			p.X.Scale,
			math.clamp(p.X.Offset, -limitx, limitx),
			p.Y.Scale,
			math.clamp(p.Y.Offset, -limity, limity)
		)
	end

	sv.Refits = sv.Refits or {}
	table.insert(sv.Refits, function()
		if object.Parent then
			fitwindow()
			clampwindow()
		end
	end)
	fitwindow()
	if object.Parent then
		trackConnection(
			object.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				fitwindow()
				clampwindow()
			end),
			"makedraggable.fit"
		)
	end

	local resizeConnection = nil
	local resizeHandles = {}
	local function makehandle(name, position, size, anchor, modex, modey)
		local handle = instance.frame(object)
		handle.Name = name
		handle.AnchorPoint = anchor
		handle.BackgroundTransparency = 1
		handle.BorderSizePixel = 0
		handle.Position = position
		handle.Size = size
		handle.ZIndex = 100
		handle.Active = true
		table.insert(resizeHandles, { handle, modex, modey })
		return handle
	end
	makehandle("ResizeRight", UDim2.new(1, 0, 0.5, -10), UDim2.new(0, isMobile and 14 or 8, 1, -44), Vector2.new(1, 0.5), 1, 0)
	makehandle("ResizeBottom", UDim2.new(0.5, -10, 1, 0), UDim2.new(1, -44, 0, isMobile and 14 or 8), Vector2.new(0.5, 1), 0, 1)
	local cornerhandle = makehandle("ResizeCorner", UDim2.new(1, 0, 1, 0), UDim2.new(0, isMobile and 30 or 24, 0, isMobile and 30 or 24), Vector2.new(1, 1), 1, 1)
	local dragConnection = nil

	trackConnection(
		topbar.InputBegan:Connect(function(input)
			if
				input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end

			if uilocked then
				return
			end
			draggable.dragging = true
			draggable.dragstart = input.Position
			draggable.startpos = object.Position

			if dragConnection then
				dragConnection:Disconnect()
			end
			dragConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					draggable.dragging = false
					dragConnection:Disconnect()
					dragConnection = nil
				end
			end)
		end),
		"makedraggable.drag.InputBegan"
	)

	trackConnection(
		topbar.InputChanged:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			then
				draggable.draginput = input
			end
		end),
		"makedraggable.drag.InputChanged"
	)

	for _, info in ipairs(resizeHandles) do
		local handle, modex, modey = info[1], info[2], info[3]
		trackConnection(
			handle.InputBegan:Connect(function(input)
				if
					input.UserInputType ~= Enum.UserInputType.MouseButton1
					and input.UserInputType ~= Enum.UserInputType.Touch
				then
					return
				end
				if uilocked then
					return
				end
				draggable.resizing = true
				draggable.resizestart = input.Position
				draggable.startsize = object.Size
				draggable.startpos2 = object.Position
				draggable.modex = modex
				draggable.modey = modey
				draggable.pendingresize = nil

				if resizeConnection then
					resizeConnection:Disconnect()
				end
				resizeConnection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						draggable.resizing = false
						draggable.pendingresize = nil
						clampwindow()
						resizeConnection:Disconnect()
						resizeConnection = nil
					end
				end)
			end),
			"makedraggable.resize.InputBegan"
		)
	end

	trackConnection(
		sv.uis.InputChanged:Connect(function(input)
			if draggable.dragging and input == draggable.draginput then
				draggable.pendingdrag = input.Position
			end
			if
				draggable.resizing
				and (
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				draggable.pendingresize = input.Position
			end
		end),
		"makedraggable.global.InputChanged"
	)

	trackConnection(
		game:GetService("RunService").RenderStepped:Connect(function()
			local drag = draggable.pendingdrag
			if drag then
				draggable.pendingdrag = nil
				local delta = (drag - draggable.dragstart) / fit.Scale
				object.Position = UDim2.new(
					draggable.startpos.X.Scale,
					draggable.startpos.X.Offset + delta.X,
					draggable.startpos.Y.Scale,
					draggable.startpos.Y.Offset + delta.Y
				)
			end

			local resize = draggable.pendingresize
			if resize and draggable.resizing then
				draggable.pendingresize = nil
				local delta = (resize - draggable.resizestart) / fit.Scale
				local viewport = object.Parent.AbsoluteSize / fit.Scale
				local startw, starth = draggable.startsize.X.Offset, draggable.startsize.Y.Offset
				local width = math.clamp(startw + delta.X * draggable.modex, draggable.minx, math.max(draggable.minx, viewport.X - 8))
				local height = math.clamp(starth + delta.Y * draggable.modey, draggable.miny, math.max(draggable.miny, viewport.Y - 8))
				object.Size = UDim2.new(0, width, 0, height)

				local p = draggable.startpos2
				object.Position = UDim2.new(
					p.X.Scale,
					p.X.Offset + (width - startw) / 2,
					p.Y.Scale,
					p.Y.Offset + (height - starth) / 2
				)

				clampwindow()
			end
		end),
		"makedraggable.render"
	)
end

local MXHUB = {}
MXHUB.Version = "4.3.0"
MXHUB.Theme = theme.Api -- Names(), Accents(), ParseHex(text), Set({ Preset, Accent, Mode })

function MXHUB:RegisterIcon(name, asset)
	if type(name) ~= "string" or normalizeiconname(name) == "" or asset == nil then
		return false
	end
	local value = resolveiconasset(asset)
	if not value then
		return false
	end
	customicons[normalizeiconname(name)] = value
	return true
end

function MXHUB:AddIconAlias(alias, target)
	if type(alias) ~= "string" or normalizeiconname(alias) == "" or target == nil then
		return false
	end
	customaliases[normalizeiconname(alias)] = target
	return true
end

function MXHUB:GetIconAsset(name)
	return resolveiconasset(name)
end

function MXHUB:ApplyIcon(image, name, size)
	return applyicon(image, name, size)
end

function MXHUB:SetUILocked(state)
	uilocked = state == true
end

function MXHUB:GetUILocked()
	return uilocked
end

function MXHUB:GetIconNames()
	local found, names = {}, {}
	local function add(key)
		if type(key) == "string" and key ~= "" and not found[key] then
			found[key] = true
			names[#names + 1] = key
		end
	end
	for key in pairs(iconnames) do add(key) end
	for key in pairs(lucidesprites) do add(key) end
	for key in pairs(iconaliases) do add(key) end
	for key in pairs(customicons) do add(key) end
	table.sort(names)
	return names
end

MXHUB.Image = {
	Normalize = resolveiconasset,
	Thumbnail = thumbnail,
	Apply = applyicon,
}
MXHUB.IconAssets = iconnames
MXHUB.IconAliases = iconaliases
MXHUB.IconRegistryCount = (function() local n = 0; for _ in pairs(MXHUB.IconAssets) do n += 1 end; return n end)()
MXHUB.IconRegistryVersion = "lucide-sheet+1457-registry-2026-11-06"

local WatermarkGui

function MXHUB:Watermark(wmconfig)
	wmconfig = wmconfig or {}
	local title = tostring(wmconfig.Title or "MX HUB")
	local showtime = wmconfig.ShowTime ~= false
	local showfps = wmconfig.ShowFPS ~= false
	local showping = wmconfig.ShowPing ~= false

	local parent = sv.coregui
	pcall(function()
		local ok, hidden = pcall(function()
			return gethui()
		end)
		if ok and hidden then
			parent = hidden
		end
	end)
	pcall(function()
		local old = parent:FindFirstChild("MXHUBWatermark") or sv.coregui:FindFirstChild("MXHUBWatermark")
		if old then
			old:Destroy()
		end
	end)

	local gui = instance.screengui(parent)
	gui.Name = "MXHUBWatermark"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 9000
	gui.IgnoreGuiInset = true
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
		elseif protect_gui then
			protect_gui(gui)
		end
	end)
	WatermarkGui = gui

	local pill = instance.frame(gui)
	pill.Name = "Pill"
	pill.AnchorPoint = Vector2.new(0.5, 0)
	pill.Position = wmconfig.Position or UDim2.new(0.5, 0, 0, 64)
	pill.Size = UDim2.new(0, 0, 0, isMobile and 30 or 34)
	pill.AutomaticSize = Enum.AutomaticSize.X
	pill.BackgroundColor3 = theme.Card
	pill.BackgroundTransparency = 0.08
	pill.BorderSizePixel = 0
	pill.Active = true
	instance.uicorner(pill).CornerRadius = UDim.new(0, 8)
	local pillstroke = instance.uistroke(pill)
	pillstroke.Color = theme.Stroke
	pillstroke.Thickness = 1

	local pad = instance.uipadding(pill)
	pad.PaddingLeft = UDim.new(0, 12)
	pad.PaddingRight = UDim.new(0, 14)

	local layout = instance.uilistlayout(pill)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)

	local logo = instance.imagelabel(pill)
	logo.Name = "Logo"
	logo.LayoutOrder = 1
	logo.BackgroundTransparency = 1
	logo.Size = UDim2.new(0, 20, 0, 20)
	logo.ScaleType = Enum.ScaleType.Fit
	instance.uicorner(logo).CornerRadius = UDim.new(0, 4)
	local function setlogo(value)
		if value == nil or value == false or value == "" then
			logo.Visible = false
			return
		end
		logo.Visible = true
		applyicon(logo, value, 96)
	end
	setlogo(wmconfig.Logo)

	local label = instance.textlabel(pill)
	label.Name = "Info"
	label.LayoutOrder = 2
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(0, 0, 1, 0)
	label.AutomaticSize = Enum.AutomaticSize.X
	label.Font = Enum.Font.GothamMedium
	label.TextSize = isMobile and 12 or 13
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.RichText = true
	label.TextXAlignment = Enum.TextXAlignment.Left

	local ping = 0
	local function refresh()
		local sep = '<font color="#7A7A86">|</font>'
		local parts = { title }
		if showtime then
			table.insert(parts, os.date("%H:%M:%S"))
		end
		if showfps then
			table.insert(parts, string.format("%d FPS", fpsmeter.value))
		end
		if showping then
			table.insert(parts, string.format("%dms", ping))
		end
		label.Text = table.concat(parts, "  " .. sep .. "  ")
	end

	fpsmeter.start()

	task.spawn(function()
		while pill.Parent do
			pcall(function()
				ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
			end)
			refresh()
			task.wait(0.5)
		end
	end)
	refresh()

	local MARGIN = 0
	local function clampwm()
		local bounds, size = gui.AbsoluteSize, pill.AbsoluteSize
		if bounds.X <= 0 or size.X <= 0 then
			return
		end
		local pos, anchor = pill.Position, pill.AnchorPoint
		local x = pos.X.Scale * bounds.X + pos.X.Offset
		local y = pos.Y.Scale * bounds.Y + pos.Y.Offset
		local minx, miny = anchor.X * size.X + MARGIN, anchor.Y * size.Y + MARGIN
		local maxx = bounds.X - (1 - anchor.X) * size.X - MARGIN
		local maxy = bounds.Y - (1 - anchor.Y) * size.Y - MARGIN
		x = math.clamp(x, minx, math.max(minx, maxx))
		y = math.clamp(y, miny, math.max(miny, maxy))
		pill.Position = UDim2.fromOffset(x, y)
	end
	pill:GetPropertyChangedSignal("AbsoluteSize"):Connect(clampwm)
	gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(clampwm)

	local dragstart, startpos, draginput = nil, nil, nil
	pill.InputBegan:Connect(function(input)
		if uilocked then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragstart = input.Position
			startpos = pill.Position
			draginput = input
		end
	end)
	trackConnection(
		sv.uis.InputChanged:Connect(function(input)
			if
				dragstart
				and (input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and input == draginput))
			then
				local delta = input.Position - dragstart
				pill.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
				clampwm()
			end
		end),
		"watermark.drag.changed"
	)
	trackConnection(
		sv.uis.InputEnded:Connect(function(input)
			if dragstart and (input.UserInputType == Enum.UserInputType.MouseButton1 or input == draginput) then
				dragstart = nil
			end
		end),
		"watermark.drag.ended"
	)

	local handle = {}
	function handle:SetVisible(state)
		gui.Enabled = state ~= false
	end
	function handle:SetTitle(text)
		title = tostring(text or title)
		refresh()
	end
	function handle:SetLogo(value)
		setlogo(value)
	end
	function handle:Destroy()
		pcall(function()
			gui:Destroy()
		end)
	end
	handle.Gui = gui
	return handle
end

local function popupbutton(parent, option, onpick)
	local style = tostring(option.Style or "default"):lower()
	local base, hover, textcolor
	if style == "primary" then
		base, hover, textcolor = theme.Accent, theme.Accent:Lerp(Color3.new(1, 1, 1), 0.14), theme.AccentText
	elseif style == "danger" then
		base, hover, textcolor = theme.Bad, theme.Bad:Lerp(Color3.new(1, 1, 1), 0.14), Color3.new(1, 1, 1)
	else
		base, hover, textcolor = theme.Element, theme.ElementHover, theme.Text
	end

	local button = instance.textbutton(parent)
	button.Name = "Option"
	button.AutoButtonColor = false
	button.BorderSizePixel = 0
	button.BackgroundColor3 = base
	button.AutomaticSize = Enum.AutomaticSize.X
	button.Size = UDim2.new(0, 0, 0, 34)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 12
	button.TextColor3 = textcolor
	button.Text = tostring(option.Text or "OK")
	instance.uicorner(button).CornerRadius = UDim.new(0, theme.Radius.control)
	local pad = instance.uipadding(button)
	pad.PaddingLeft = UDim.new(0, 16)
	pad.PaddingRight = UDim.new(0, 16)
	if style == "default" then
		local stroke = instance.uistroke(button)
		stroke.Color = theme.Stroke
		stroke.Thickness = 1
	end

	button.MouseEnter:Connect(function()
		tw(button, { BackgroundColor3 = hover }, 0.12)
	end)
	button.MouseLeave:Connect(function()
		tw(button, { BackgroundColor3 = base }, 0.18)
	end)
	button.Activated:Connect(function()
		onpick(option)
	end)
	return button
end

local function popupbox(parent, box, order)
	local frame = instance.frame(parent)
	frame.Name = "Box"
	frame.LayoutOrder = order
	frame.BorderSizePixel = 0
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	roundbg(frame, theme.Radius.control, theme.Row, true)
	local stroke = instance.uistroke(frame)
	stroke.Color = theme.Stroke
	stroke.Transparency = 0.45
	stroke.Thickness = 1

	local pad = instance.uipadding(frame)
	pad.PaddingTop = UDim.new(0, 12)
	pad.PaddingBottom = UDim.new(0, 12)
	pad.PaddingLeft = UDim.new(0, 12)
	pad.PaddingRight = UDim.new(0, 12)

	local row = instance.uilistlayout(frame)
	row.FillDirection = Enum.FillDirection.Horizontal
	row.SortOrder = Enum.SortOrder.LayoutOrder
	row.Padding = UDim.new(0, 10)

	local textwidth = UDim2.new(1, 0, 0, 0)
	if box.Icon ~= nil and box.Icon ~= "" then
		local icon = instance.imagelabel(frame)
		icon.Name = "Icon"
		icon.LayoutOrder = 1
		icon.BackgroundTransparency = 1
		icon.Size = UDim2.new(0, 22, 0, 22)
		icon.ImageColor3 = theme.Accent
		applyicon(icon, box.Icon, 48)
		textwidth = UDim2.new(1, -32, 0, 0)
	end

	local holder = instance.frame(frame)
	holder.Name = "Text"
	holder.LayoutOrder = 2
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.Size = textwidth
	holder.AutomaticSize = Enum.AutomaticSize.Y
	local stack = instance.uilistlayout(holder)
	stack.SortOrder = Enum.SortOrder.LayoutOrder
	stack.Padding = UDim.new(0, 3)

	local function line(text, font, size, color, layout)
		local label = instance.textlabel(holder)
		label.LayoutOrder = layout
		label.BackgroundTransparency = 1
		label.BorderSizePixel = 0
		label.Font = font
		label.TextSize = size
		label.TextColor3 = color
		label.TextWrapped = true
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.Size = UDim2.new(1, 0, 0, 0)
		label.AutomaticSize = Enum.AutomaticSize.Y
		label.Text = text
	end
	if box.Title and box.Title ~= "" then
		line(tostring(box.Title), Enum.Font.GothamBold, 13, theme.Text, 1)
	end
	if box.Description and box.Description ~= "" then
		line(tostring(box.Description), Enum.Font.Gotham, 12, theme.SubText, 2)
	end
end

function MXHUB:Popup(popupconfig)
	popupconfig = popupconfig or {}
	elevate()

	local previous = sv.coregui:FindFirstChild("PopupGui")
	if previous then
		previous:Destroy()
	end

	local gui = instance.screengui(sv.coregui)
	gui.Name = "PopupGui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 10000

	local backdrop = instance.textbutton(gui)
	backdrop.Name = "Backdrop"
	backdrop.Text = ""
	backdrop.AutoButtonColor = false
	backdrop.BorderSizePixel = 0
	backdrop.BackgroundColor3 = Color3.new(0, 0, 0)
	backdrop.BackgroundTransparency = 1
	backdrop.Size = UDim2.fromScale(1, 1)

	local dialog = instance.canvasgroup(gui)
	dialog.Name = "Dialog"
	dialog.AnchorPoint = Vector2.new(0.5, 0.5)
	dialog.Position = UDim2.new(0.5, 0, 0.5, 18)
	dialog.Size = UDim2.new(0.92, 0, 0, 0)
	dialog.AutomaticSize = Enum.AutomaticSize.Y
	dialog.BackgroundColor3 = theme.Card
	dialog.BorderSizePixel = 0
	dialog.GroupTransparency = 1
	instance.uicorner(dialog).CornerRadius = UDim.new(0, theme.Radius.card)
	local limit = instance.uisizeconstraint(dialog)
	limit.MaxSize = Vector2.new(430, math.huge)
	local border = instance.uistroke(dialog)
	border.Color = theme.Stroke
	border.Thickness = 1

	local pad = instance.uipadding(dialog)
	pad.PaddingTop = UDim.new(0, 18)
	pad.PaddingBottom = UDim.new(0, 18)
	pad.PaddingLeft = UDim.new(0, 18)
	pad.PaddingRight = UDim.new(0, 18)
	local stack = instance.uilistlayout(dialog)
	stack.SortOrder = Enum.SortOrder.LayoutOrder
	stack.Padding = UDim.new(0, 10)

	local order = 0
	local function nextorder()
		order += 1
		return order
	end
	local function heading(text, font, size, color)
		local label = instance.textlabel(dialog)
		label.LayoutOrder = nextorder()
		label.BackgroundTransparency = 1
		label.BorderSizePixel = 0
		label.Font = font
		label.TextSize = size
		label.TextColor3 = color
		label.TextWrapped = true
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Size = UDim2.new(1, 0, 0, 0)
		label.AutomaticSize = Enum.AutomaticSize.Y
		label.Text = text
	end
	if popupconfig.Title and popupconfig.Title ~= "" then
		heading(tostring(popupconfig.Title), Enum.Font.GothamBold, 18, theme.Text)
	end
	if popupconfig.Subtitle and popupconfig.Subtitle ~= "" then
		heading(tostring(popupconfig.Subtitle), Enum.Font.GothamMedium, 12, theme.SubText)
	end
	for _, box in ipairs(popupconfig.Boxes or {}) do
		popupbox(dialog, box, nextorder())
	end

	local actions = instance.frame(dialog)
	actions.Name = "Options"
	actions.LayoutOrder = nextorder()
	actions.BackgroundTransparency = 1
	actions.BorderSizePixel = 0
	actions.Size = UDim2.new(1, 0, 0, 34)
	local actionlayout = instance.uilistlayout(actions)
	actionlayout.FillDirection = Enum.FillDirection.Horizontal
	actionlayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	actionlayout.SortOrder = Enum.SortOrder.LayoutOrder
	actionlayout.Padding = UDim.new(0, 8)

	local popupfunc = { Open = true }
	local closed = false
	local escape

	local function close(option)
		if closed then
			return
		end
		closed = true
		popupfunc.Open = false
		if escape then
			escape:Disconnect()
		end
		tw(backdrop, { BackgroundTransparency = 1 }, 0.18)
		tw(dialog, { GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 10) }, 0.18)
		task.delay(0.2, function()
			gui:Destroy()
		end)
		local callback = (option and option.Callback) or popupconfig.OnClose
		if type(callback) == "function" then
			local ok, err = pcall(callback, option and option.Text)
			if not ok then
				warn("Popup callback error:", err)
			end
		end
	end
	popupfunc.Close = function()
		close(nil)
	end

	local options = popupconfig.Options
	if type(options) ~= "table" or #options == 0 then
		options = { { Text = "OK", Style = "primary" } }
	end
	for index, option in ipairs(options) do
		local button = popupbutton(actions, option, close)
		button.LayoutOrder = index
	end

	if popupconfig.Dismissable ~= false then
		backdrop.Activated:Connect(popupfunc.Close)
		escape = sv.uis.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Escape then
				close(nil)
			end
		end)
	end
	gui.Destroying:Connect(function()
		if escape then
			escape:Disconnect()
		end
	end)

	tw(backdrop, { BackgroundTransparency = 0.45 }, 0.2)
	tw(dialog, { GroupTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0) }, 0.28)
	return popupfunc
end
local function characterview(frame, options)
	options = options or {}
	local view = { Target = options.Target }
	local connections = {}
	local rendered = nil

	local viewport = Instance.new("ViewportFrame")
	viewport.Name = "Viewport"
	viewport.Size = UDim2.new(1, 0, 1, 0)
	viewport.BackgroundTransparency = 1
	viewport.BorderSizePixel = 0
	viewport.Ambient = Color3.fromRGB(170, 170, 185)
	viewport.LightColor = Color3.fromRGB(255, 255, 255)
	viewport.LightDirection = Vector3.new(-1, -1, -1)
	viewport.Active = true
	viewport.Parent = frame

	local function resolve()
		local target = view.Target
		if typeof(target) == "Instance" and target:IsA("Player") then
			return target
		end
		if type(target) == "number" then
			return sv.plrs:GetPlayerByUserId(target)
		end
		if type(target) == "string" and target ~= "" and target:lower() ~= "localplayer" then
			return sv.plrs:FindFirstChild(target)
		end
		return sv.plrs.LocalPlayer
	end

	local function clear()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		table.clear(connections)
		viewport:ClearAllChildren()
		viewport.CurrentCamera = nil
	end

	local function fallback(player)
		local picture = Instance.new("ImageLabel")
		picture.BackgroundTransparency = 1
		picture.AnchorPoint = Vector2.new(0.5, 0.5)
		picture.Position = UDim2.new(0.5, 0, 0.5, 0)
		picture.Size = UDim2.new(0, 90, 0, 90)
		picture.Parent = viewport
		if player then
			applyicon(picture, thumbnail("AvatarHeadShot", player.UserId, 150), 48)
		else
			applyicon(picture, "user", 48)
		end
	end

	function view:Render()
		clear()
		local player = resolve()
		local character = player and player.Character
		local model
		if character then
			pcall(function()
				character.Archivable = true
				model = character:Clone()
			end)
		end
		local root = model and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart)
		if not root then
			fallback(player)
			return false
		end

		for _, descendant in ipairs(model:GetDescendants()) do
			if descendant:IsA("BaseScript") or descendant:IsA("Sound") or descendant:IsA("ForceField") then
				descendant:Destroy()
			elseif descendant:IsA("BasePart") then
				descendant.Anchored = true
			end
		end
		local humanoid = model:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end
		model.Parent = viewport

		local camera = Instance.new("Camera")
		camera.FieldOfView = 28
		camera.Parent = viewport
		viewport.CurrentCamera = camera

		local boxcf, boxsize = model:GetBoundingBox()
		local center = boxcf.Position
		local distance = math.max(boxsize.Y, boxsize.X) / (2 * math.tan(math.rad(camera.FieldOfView / 2))) * 1.15
		local base = root.CFrame.Rotation
		local yaw = 20
		local function updatecamera()
			local rotation = base * CFrame.Angles(0, math.rad(yaw), 0)
			local position = center + rotation:VectorToWorldSpace(Vector3.new(0, boxsize.Y * 0.05, -distance))
			camera.CFrame = CFrame.lookAt(position, center)
		end
		updatecamera()

		local dragging, last = false, nil
		local function pointer(input)
			return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
		end
		connections[#connections + 1] = trackConnection(viewport.InputBegan:Connect(function(input)
			if pointer(input) then
				dragging, last = true, input.Position
			end
		end), "mx.character.began")
		connections[#connections + 1] = trackConnection(sv.uis.InputChanged:Connect(function(input)
			if dragging and last and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				yaw = yaw - (input.Position - last).X * 0.8
				last = input.Position
				updatecamera()
			end
		end), "mx.character.changed")
		connections[#connections + 1] = trackConnection(sv.uis.InputEnded:Connect(function(input)
			if pointer(input) then
				dragging = false
			end
		end), "mx.character.ended")
		return true
	end

	function view:SetTarget(target)
		self.Target = target
		self:Render()
	end

	function view:Destroy()
		clear()
		if rendered then
			rendered:Disconnect()
			rendered = nil
		end
		viewport:Destroy()
	end

	local player = resolve()
	if player then
		rendered = player.CharacterAdded:Connect(function()
			task.defer(function()
				if viewport.Parent then
					view:Render()
				end
			end)
		end)
	end
	view:Render()
	return view
end
local glass = { users = 0, effect = nil }

local GLASS_NAME = "MXLIB_Glass"
local GLASS_DEPTH = 0.15

do
	local stale = game:GetService("Lighting"):FindFirstChild(GLASS_NAME)
	if stale then
		stale:Destroy()
	end
	local camera = workspace.CurrentCamera
	local leftover = camera and camera:FindFirstChild(GLASS_NAME)
	while leftover do
		leftover:Destroy()
		leftover = camera:FindFirstChild(GLASS_NAME)
	end
end

local function glassrect(camera, topleft, bottomright, depth)
	local cframe = camera.CFrame
	local look = cframe.LookVector
	local function project(point)
		local ray = camera:ScreenPointToRay(point.X, point.Y, 0)
		local reach = (depth - (ray.Origin - cframe.Position):Dot(look)) / ray.Direction:Dot(look)
		return cframe:PointToObjectSpace(ray.Origin + ray.Direction * reach)
	end
	local first, second = project(topleft), project(bottomright)
	return Vector2.new((first.X + second.X) / 2, (first.Y + second.Y) / 2),
		Vector2.new(math.abs(second.X - first.X), math.abs(second.Y - first.Y))
end

local function sharedeffect()
	if glass.effect and glass.effect.Parent then
		return glass.effect
	end
	local effect = Instance.new("DepthOfFieldEffect")
	effect.Name = GLASS_NAME
	effect.FarIntensity = 0
	effect.NearIntensity = 1
	effect.FocusDistance = 0
	effect.InFocusRadius = 1000
	effect.Parent = game:GetService("Lighting")
	glass.effect = effect
	return effect
end

local function glassblur(frame)
	if not workspace.CurrentCamera then
		return nil
	end

	local part = Instance.new("Part")
	part.Name = GLASS_NAME
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Material = Enum.Material.SmoothPlastic
	part.Color = Color3.new(0, 0, 0)
	part.Transparency = 1
	part.Size = Vector3.new(0.01, 0.01, 0.01)

	sharedeffect()
	glass.users += 1

	local alive = true
	local connections = {}
	local cameraconnections = {}

	local function isvisible()
		if not frame:IsDescendantOf(game) then
			return false
		end
		local node = frame
		while node do
			if node:IsA("ScreenGui") then
				return node.Enabled
			end
			if node:IsA("GuiObject") and not node.Visible then
				return false
			end
			node = node.Parent
		end
		return false
	end

	local function update()
		local camera = workspace.CurrentCamera
		if not alive or not camera then
			return
		end
		if not isvisible() or frame.AbsoluteSize.X <= 0 or frame.AbsoluteSize.Y <= 0 then
			part.Transparency = 1
			return
		end
		local topleft = frame.AbsolutePosition
		local center, size = glassrect(camera, topleft, topleft + frame.AbsoluteSize, GLASS_DEPTH)
		part.Parent = camera
		part.Size = Vector3.new(math.max(size.X, 0.001), math.max(size.Y, 0.001), 0.001)
		part.CFrame = camera.CFrame * CFrame.new(center.X, center.Y, -GLASS_DEPTH)
		part.Transparency = 0.97
	end

	local function safeupdate()
		local ok = pcall(update)
		if not ok then
			part.Transparency = 1
		end
	end

	local function bindcamera()
		for _, connection in ipairs(cameraconnections) do
			connection:Disconnect()
		end
		table.clear(cameraconnections)
		local camera = workspace.CurrentCamera
		if not camera then
			return
		end
		for _, property in ipairs({ "CFrame", "ViewportSize", "FieldOfView" }) do
			cameraconnections[#cameraconnections + 1] = camera:GetPropertyChangedSignal(property):Connect(safeupdate)
		end
		safeupdate()
	end

	for _, property in ipairs({ "AbsolutePosition", "AbsoluteSize" }) do
		connections[#connections + 1] = frame:GetPropertyChangedSignal(property):Connect(safeupdate)
	end
	local node = frame
	while node do
		if node:IsA("ScreenGui") then
			connections[#connections + 1] = node:GetPropertyChangedSignal("Enabled"):Connect(safeupdate)
			break
		end
		if node:IsA("GuiObject") then
			connections[#connections + 1] = node:GetPropertyChangedSignal("Visible"):Connect(safeupdate)
		end
		node = node.Parent
	end
	connections[#connections + 1] = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindcamera)
	bindcamera()

	local controller = {}
	function controller:Destroy()
		if not alive then
			return
		end
		alive = false
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		for _, connection in ipairs(cameraconnections) do
			connection:Disconnect()
		end
		part:Destroy()
		glass.users -= 1
		if glass.users <= 0 and glass.effect then
			glass.effect:Destroy()
			glass.effect = nil
		end
	end
	frame.Destroying:Connect(function()
		controller:Destroy()
	end)
	return controller
end
local function buildhomepage(page, ctx)
	local Players = game:GetService("Players")
	local lp = Players.LocalPlayer
	local order = 0
	local function nextorder()
		order = order + 1
		return order
	end

	local function addcorner(object, radius)
		instance.uicorner(object).CornerRadius = UDim.new(0, radius)
	end

	local function newcard(height)
		local card = instance.frame(page)
		card.Name = "HomeCard"
		card.LayoutOrder = nextorder()
		card.BorderSizePixel = 0
		card.BackgroundColor3 = theme.Row
		card.Size = UDim2.new(1, 0, 0, height)
		card.ClipsDescendants = true
		addcorner(card, 8)
		local stroke = instance.uistroke(card)
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Transparency = 0.93
		stroke.Thickness = 1
		return card
	end

	local function label(parent, str, size, font, color, position, dimension, align)
		local l = instance.textlabel(parent)
		l.BackgroundTransparency = 1
		l.BorderSizePixel = 0
		l.Text = str
		l.TextSize = size
		l.Font = font
		l.TextColor3 = color
		l.TextXAlignment = align or Enum.TextXAlignment.Left
		l.TextTruncate = Enum.TextTruncate.AtEnd
		l.Position = position
		l.Size = dimension
		return l
	end

	local function glyph(parent, name, px, position, color)
		local img = instance.imagelabel(parent)
		img.BackgroundTransparency = 1
		img.BorderSizePixel = 0
		img.Position = position
		img.Size = UDim2.new(0, px, 0, px)
		img.ImageColor3 = color or theme.Text
		applyicon(img, name, 48)
		return img
	end

	local function hover(button, normal, over)
		button.MouseEnter:Connect(function()
			tw(button, { BackgroundColor3 = over }, 0.15)
		end)
		button.MouseLeave:Connect(function()
			tw(button, { BackgroundColor3 = normal }, 0.2)
		end)
	end

	local function copy(text)
		clipboardwrite(text)
	end

	local gamename = tostring(ctx.Footer or "")
	if gamename == "" then
		gamename = "this game"
	end

	local head = instance.frame(page)
	head.Name = "HomeHeading"
	head.BackgroundTransparency = 1
	head.BorderSizePixel = 0
	head.LayoutOrder = nextorder()
	head.Size = UDim2.new(1, 0, 0, 34)
	glyph(head, "home", 20, UDim2.new(0, 4, 0.5, -10), theme.Text)
	local headtext = label(head, "Welcome to " .. tostring(ctx.HubName or "MX HUB") .. "!", 16, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 32, 0, 0), UDim2.new(1, -36, 1, 0))

	local welcome = newcard(112)
	label(welcome, "WELCOME BACK", 10, Enum.Font.GothamMedium, theme.SubText, UDim2.new(0, 14, 0, 12), UDim2.new(1, -140, 0, 12))
	local shownname = lp and lp.DisplayName or "Player"
	local shownuser = lp and ("@" .. lp.Name) or ""
	local namelabel = label(welcome, shownname, 22, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 14, 0, 26), UDim2.new(1, -130, 0, 28))
	local userlabel = label(welcome, shownuser, 12, Enum.Font.Gotham, theme.SubText, UDim2.new(0, 14, 0, 56), UDim2.new(1, -130, 0, 14))

	local avatar = instance.imagelabel(welcome)
	avatar.Name = "Avatar"
	avatar.BackgroundTransparency = 1
	avatar.AnchorPoint = Vector2.new(1, 1)
	avatar.Position = UDim2.new(1, -6, 1, 4)
	avatar.Size = UDim2.new(0, 104, 0, 104)
	avatar.ScaleType = Enum.ScaleType.Fit
	if lp then
		avatar.Image = string.format("rbxthumb://type=AvatarBust&id=%d&w=150&h=150", lp.UserId)
	end

	local chiprow = instance.frame(welcome)
	chiprow.BackgroundTransparency = 1
	chiprow.BorderSizePixel = 0
	chiprow.Position = UDim2.new(0, 14, 0, 80)
	chiprow.Size = UDim2.new(1, -130, 0, 24)
	local chiplayout = instance.uilistlayout(chiprow)
	chiplayout.FillDirection = Enum.FillDirection.Horizontal
	chiplayout.SortOrder = Enum.SortOrder.LayoutOrder
	chiplayout.VerticalAlignment = Enum.VerticalAlignment.Center
	chiplayout.Padding = UDim.new(0, 6)

	local function chip(iconname, text, width, layoutorder, tint)
		local b = instance.textbutton(chiprow)
		b.Text = ""
		b.AutoButtonColor = false
		b.BorderSizePixel = 0
		b.LayoutOrder = layoutorder
		b.BackgroundColor3 = theme.Field
		b.Size = UDim2.new(0, width, 0, 24)
		addcorner(b, 12)
		local icon = glyph(b, iconname, 12, UDim2.new(0, 8, 0.5, -6), tint or theme.SubText)
		label(b, text, 11, Enum.Font.GothamMedium, theme.SubText, UDim2.new(0, 25, 0, 0), UDim2.new(1, -29, 1, 0))
		hover(b, theme.Field, theme.InnerHover)
		return b, icon
	end

	local namehidden, avatarhidden = false, false
	local namechip, nameicon = chip("eye", "Name", 66, 1)
	namechip.Activated:Connect(function()
		namehidden = not namehidden
		namelabel.Text = namehidden and "*****" or shownname
		userlabel.Text = namehidden and "@*****" or shownuser
		applyicon(nameicon, namehidden and "eye-off" or "eye", 48)
	end)
	local avatarchip, avataricon = chip("user", "Avatar", 74, 2)
	avatarchip.Activated:Connect(function()
		avatarhidden = not avatarhidden
		avatar.Visible = not avatarhidden
		applyicon(avataricon, avatarhidden and "user-x" or "user", 48)
	end)

	local stats = newcard(136)
	local HIST, CHART_H = 24, 28

	local function metric(xscale, title)
		local holder = instance.frame(stats)
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		holder.Position = UDim2.new(xscale, 0, 0, 0)
		holder.Size = UDim2.new(0.5, 0, 0, 96)
		label(holder, title, 11, Enum.Font.GothamMedium, theme.SubText, UDim2.new(0, 14, 0, 10), UDim2.new(0, 60, 0, 12))
		local value = label(holder, "0", 22, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 14, 0, 24), UDim2.new(0.6, 0, 0, 26))
		value.RichText = true
		local range = label(holder, "min 0  avg 0  max 0", 10, Enum.Font.Gotham, theme.SubText, UDim2.new(1, -10, 0, 10), UDim2.new(0.62, 0, 0, 12), Enum.TextXAlignment.Right)
		range.AnchorPoint = Vector2.new(1, 0)
		local chart = instance.frame(holder)
		chart.BackgroundTransparency = 1
		chart.BorderSizePixel = 0
		chart.Position = UDim2.new(0, 14, 0, 58)
		chart.Size = UDim2.new(1, -24, 0, CHART_H)
		local chartlayout = instance.uilistlayout(chart)
		chartlayout.FillDirection = Enum.FillDirection.Horizontal
		chartlayout.SortOrder = Enum.SortOrder.LayoutOrder
		chartlayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		chartlayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		chartlayout.Padding = UDim.new(0, 2)
		local bars = {}
		for i = 1, HIST do
			local bar = instance.frame(chart)
			bar.BorderSizePixel = 0
			bar.LayoutOrder = i
			bar.BackgroundColor3 = theme.Track
			bar.Size = UDim2.new(0, 4, 0, 2)
			bar.Visible = false
			bars[i] = bar
		end
		return { Value = value, Range = range, Bars = bars }
	end

	local fpsmetric = metric(0, "FPS")
	local pingmetric = metric(0.5, "Ping")

	local divider = instance.frame(stats)
	divider.BorderSizePixel = 0
	divider.BackgroundColor3 = theme.Stroke
	divider.BackgroundTransparency = 0.4
	divider.Position = UDim2.new(0, 14, 0, 98)
	divider.Size = UDim2.new(1, -28, 0, 1)

	local function bigstat(xscale, caption)
		local v = label(stats, "-", 15, Enum.Font.GothamBold, theme.Text, UDim2.new(xscale, 14, 0, 104), UDim2.new(0.5, -20, 0, 16))
		label(stats, caption, 10, Enum.Font.Gotham, theme.SubText, UDim2.new(xscale, 14, 0, 121), UDim2.new(0.5, -20, 0, 12))
		return v
	end
	local playersvalue = bigstat(0, "Players")
	local sessionvalue = bigstat(0.5, "Session")

	local gamecard = newcard(142)
	local gameicon = instance.imagelabel(gamecard)
	gameicon.Name = "GameIcon"
	gameicon.BackgroundColor3 = theme.Field
	gameicon.BorderSizePixel = 0
	gameicon.Position = UDim2.new(0, 14, 0, 12)
	gameicon.Size = UDim2.new(0, 44, 0, 44)
	gameicon.ScaleType = Enum.ScaleType.Crop
	addcorner(gameicon, 8)
	pcall(function()
		gameicon.Image = string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", game.GameId)
	end)
	local gamenamelabel = label(gamecard, gamename, 13, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 66, 0, 14), UDim2.new(1, -80, 0, 16))
	local gamesub = label(gamecard, "", 11, Enum.Font.Gotham, theme.SubText, UDim2.new(0, 66, 0, 33), UDim2.new(1, -80, 0, 14))

	local buttonrow = instance.frame(gamecard)
	buttonrow.BackgroundTransparency = 1
	buttonrow.BorderSizePixel = 0
	buttonrow.Position = UDim2.new(0, 14, 0, 66)
	buttonrow.Size = UDim2.new(1, -28, 0, 52)
	local rowlayout = instance.uilistlayout(buttonrow)
	rowlayout.FillDirection = Enum.FillDirection.Horizontal
	rowlayout.SortOrder = Enum.SortOrder.LayoutOrder
	rowlayout.Padding = UDim.new(0, 6)

	local function actionbutton(iconname, text, layoutorder, callback)
		local b = instance.textbutton(buttonrow)
		b.Text = ""
		b.AutoButtonColor = false
		b.BorderSizePixel = 0
		b.LayoutOrder = layoutorder
		b.BackgroundColor3 = theme.Field
		b.Size = UDim2.new(0.5, -3, 1, 0)
		addcorner(b, 8)
		local icon = glyph(b, iconname, 16, UDim2.new(0.5, -8, 0, 9), theme.Text)
		label(b, text, 11, Enum.Font.GothamMedium, theme.SubText, UDim2.new(0, 0, 0, 30), UDim2.new(1, 0, 0, 14), Enum.TextXAlignment.Center)
		hover(b, theme.Field, theme.InnerHover)
		b.Activated:Connect(callback)
		return b
	end

	local function teleport(jobid)
		local ok, err = pcall(function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobid, lp)
		end)
		if not ok then
			warn("Teleport failed:", err)
		end
	end

	actionbutton("refresh-cw", "Rejoin", 1, function()
		if #Players:GetPlayers() <= 1 then
			pcall(function()
				game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
			end)
		else
			teleport(game.JobId)
		end
	end)
	actionbutton("copy", "Job ID", 2, function()
		copy(tostring(game.JobId))
	end)

	local jobid = tostring(game.JobId)
	local shortjob = #jobid > 14 and (jobid:sub(1, 8) .. ".." .. jobid:sub(-4)) or (jobid ~= "" and jobid or "-")
	label(gamecard, "Job " .. shortjob .. "  ·  Place " .. tostring(game.PlaceId), 10, Enum.Font.Gotham, theme.Dim, UDim2.new(0, 14, 0, 124), UDim2.new(1, -28, 0, 12))

	local links = newcard(112)
	label(links, "LINKS", 10, Enum.Font.GothamMedium, theme.SubText, UDim2.new(0, 14, 0, 10), UDim2.new(1, -28, 0, 12))

	local function linkrow(y, iconname, title, sub, actionicon, action)
		glyph(links, iconname, 18, UDim2.new(0, 14, 0, y + 11), theme.Text)
		label(links, title, 12, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 44, 0, y + 4), UDim2.new(1, -100, 0, 14))
		local sublabel = label(links, sub, 11, Enum.Font.Gotham, theme.SubText, UDim2.new(0, 44, 0, y + 20), UDim2.new(1, -100, 0, 14))
		local b = instance.textbutton(links)
		b.Text = ""
		b.AutoButtonColor = false
		b.BorderSizePixel = 0
		b.BackgroundColor3 = theme.Field
		b.AnchorPoint = Vector2.new(1, 0)
		b.Position = UDim2.new(1, -14, 0, y + 6)
		b.Size = UDim2.new(0, 28, 0, 28)
		addcorner(b, 14)
		glyph(b, actionicon, 14, UDim2.new(0.5, -7, 0.5, -7), theme.Text)
		hover(b, theme.Field, theme.InnerHover)
		b.Activated:Connect(action)
		return sublabel
	end

	local discordurl = tostring(ctx.Discord or "")
	linkrow(26, "globe", "Community", ctx.OpenCommunity and "Discord, Donate" or discordurl, ctx.OpenCommunity and "chevron-right" or "copy", function()
		if ctx.OpenCommunity then
			ctx.OpenCommunity()
		else
			copy(discordurl)
		end
	end)
	local linedivider = instance.frame(links)
	linedivider.BorderSizePixel = 0
	linedivider.BackgroundColor3 = theme.Stroke
	linedivider.BackgroundTransparency = 0.4
	linedivider.Position = UDim2.new(0, 14, 0, 68)
	linedivider.Size = UDim2.new(1, -28, 0, 1)
	local featuresub = linkrow(72, "list-checks", "Feature list", "...", "chevron-right", function()
		if ctx.OpenFeatures then
			ctx.OpenFeatures()
		end
	end)

	local footer = instance.frame(page)
	footer.Name = "HomeFooter"
	footer.BackgroundTransparency = 1
	footer.BorderSizePixel = 0
	footer.LayoutOrder = nextorder()
	footer.Size = UDim2.new(1, 0, 0, 30)
	local dot = instance.frame(footer)
	dot.BorderSizePixel = 0
	dot.BackgroundColor3 = theme.Good
	dot.Position = UDim2.new(0, 8, 0.5, -4)
	dot.Size = UDim2.new(0, 8, 0, 8)
	addcorner(dot, 4)
	local executor = "Unknown"
	pcall(function()
		local name = identifyexecutor and identifyexecutor()
		if name then
			executor = tostring(name)
		end
	end)
	local execlabel = label(footer, string.format('<font color="#EEEEF3"><b>%s</b></font>  <font color="#A2A2AE">Executor detected</font>', executor), 12, Enum.Font.Gotham, theme.SubText, UDim2.new(0, 24, 0, 0), UDim2.new(1, -150, 1, 0))
	execlabel.RichText = true
	local keychip = instance.frame(footer)
	keychip.BorderSizePixel = 0
	keychip.BackgroundColor3 = theme.Field
	keychip.AnchorPoint = Vector2.new(1, 0.5)
	keychip.Position = UDim2.new(1, -4, 0.5, 0)
	keychip.Size = UDim2.new(0, 48, 0, 22)
	addcorner(keychip, 11)
	label(keychip, keyname(ctx.ToggleKey), 11, Enum.Font.GothamBold, theme.Text, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), Enum.TextXAlignment.Center)
	local hint = label(footer, "Tap the logo or", 11, Enum.Font.Gotham, theme.SubText, UDim2.new(1, -58, 0, 0), UDim2.new(0, 100, 1, 0), Enum.TextXAlignment.Right)
	hint.AnchorPoint = Vector2.new(1, 0)

	local ping = 0
	fpsmeter.start()

	local fpshist, pinghist = {}, {}
	local fpsstat = { min = math.huge, max = 0, sum = 0, n = 0 }
	local pingstat = { min = math.huge, max = 0, sum = 0, n = 0 }

	local function record(hist, stat, value)
		table.insert(hist, value)
		if #hist > HIST then
			table.remove(hist, 1)
		end
		stat.min = math.min(stat.min, value)
		stat.max = math.max(stat.max, value)
		stat.sum = stat.sum + value
		stat.n = stat.n + 1
	end

	local function paint(m, hist, stat, unit, floor, qualitycolor)
		local current = hist[#hist] or 0
		m.Value.Text = string.format('%d <font size="12" color="#A2A2AE">%s</font>', current, unit)
		m.Range.Text = string.format(
			"min %d  avg %d  max %d",
			stat.min == math.huge and 0 or stat.min,
			stat.n > 0 and math.floor(stat.sum / stat.n + 0.5) or 0,
			stat.max
		)
		local scale = math.max(stat.max, floor, 1)
		for i, bar in ipairs(m.Bars) do
			local v = hist[#hist - (#m.Bars - i)]
			if v then
				bar.Visible = true
				bar.Size = UDim2.new(0, 4, 0, math.max(2, math.floor(CHART_H * math.clamp(v / scale, 0, 1))))
				bar.BackgroundColor3 = qualitycolor(v)
			else
				bar.Visible = false
			end
		end
	end

	local function fpscolor(v)
		return v >= 50 and theme.Good or (v >= 30 and theme.Gold or theme.Bad)
	end
	local function pingcolor(v)
		return v <= 100 and theme.Good or (v <= 200 and theme.Gold or theme.Bad)
	end

	local function formatsession(seconds)
		seconds = math.floor(seconds)
		if seconds < 60 then
			return seconds .. "s"
		elseif seconds < 3600 then
			return string.format("%dm %02ds", math.floor(seconds / 60), seconds % 60)
		end
		return string.format("%dh %02dm", math.floor(seconds / 3600), math.floor(seconds % 3600 / 60))
	end

	local creator = ""
	task.spawn(function()
		local ok, info = pcall(function()
			return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
		end)
		if ok and type(info) == "table" then
			if info.Name then
				gamenamelabel.Text = tostring(info.Name)
			end
			if type(info.Creator) == "table" and info.Creator.Name then
				creator = tostring(info.Creator.Name)
			end
		end
	end)

	task.spawn(function()
		local started = os.clock()
		while page.Parent do
			pcall(function()
				ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
			end)
			record(fpshist, fpsstat, fpsmeter.value)
			record(pinghist, pingstat, ping)
			paint(fpsmetric, fpshist, fpsstat, "fps", 60, fpscolor)
			paint(pingmetric, pinghist, pingstat, "ms", 150, pingcolor)

			local count, maxplayers = #Players:GetPlayers(), Players.MaxPlayers
			playersvalue.Text = string.format("%d/%d", count, maxplayers)
			sessionvalue.Text = formatsession(os.clock() - started)
			gamesub.Text = (creator ~= "" and ("by " .. creator .. "  ·  ") or "") .. string.format("%d/%d players", count, maxplayers)
			local features, names = ctx.GetFeatureInfo()
			featuresub.Text = string.format("%d features across %d tabs", features, #names)
			task.wait(0.5)
		end
	end)
end
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
local function buildcommunitypage(page, ctx)
	local order = 0
	local function nextorder()
		order = order + 1
		return order
	end

	local function corner(object, radius)
		instance.uicorner(object).CornerRadius = UDim.new(0, radius)
	end

	local function label(parent, text, font, size, color)
		local l = instance.textlabel(parent)
		l.BackgroundTransparency = 1
		l.BorderSizePixel = 0
		l.Text = text
		l.Font = font
		l.TextSize = size
		l.TextColor3 = color
		l.TextXAlignment = Enum.TextXAlignment.Left
		return l
	end

	local rowheight = isMobile and 40 or 36

	-- Heading: tile + judul, tinggi tetap, lebar mengikuti halaman.
	local head = instance.frame(page)
	head.Name = "CommunityHeading"
	head.BackgroundTransparency = 1
	head.BorderSizePixel = 0
	head.LayoutOrder = nextorder()
	head.Size = UDim2.new(1, 0, 0, 40)

	local headtile = instance.frame(head)
	headtile.BorderSizePixel = 0
	headtile.BackgroundColor3 = theme.Element
	headtile.Position = UDim2.new(0, 0, 0.5, -18)
	headtile.Size = UDim2.new(0, 36, 0, 36)
	corner(headtile, 10)
	local headicon = instance.imagelabel(headtile)
	headicon.BackgroundTransparency = 1
	headicon.BorderSizePixel = 0
	headicon.AnchorPoint = Vector2.new(0.5, 0.5)
	headicon.Position = UDim2.new(0.5, 0, 0.5, 0)
	headicon.Size = UDim2.new(0, 20, 0, 20)
	headicon.ImageColor3 = theme.Text
	applyicon(headicon, "globe", 48)

	local headtitle = label(head, "MX HUB COMMUNITY", Enum.Font.GothamBold, 16, theme.Text)
	headtitle.Position = UDim2.new(0, 46, 0, 2)
	headtitle.Size = UDim2.new(1, -46, 0, 20)
	headtitle.TextTruncate = Enum.TextTruncate.AtEnd
	local headsub = label(head, "Discord and donations, all in one place", Enum.Font.Gotham, 12, theme.SubText)
	headsub.Position = UDim2.new(0, 46, 0, 22)
	headsub.Size = UDim2.new(1, -46, 0, 16)
	headsub.TextTruncate = Enum.TextTruncate.AtEnd

	-- Kartu: tinggi otomatis (AutomaticSize), jadi aman saat window di-resize / dipakai di layar kecil.
	local function newcard(spec)
		local card = instance.frame(page)
		card.Name = "CommunityCard"
		card.LayoutOrder = nextorder()
		card.BorderSizePixel = 0
		card.BackgroundColor3 = theme.Row
		card.BackgroundTransparency = rowalpha
		card.Size = UDim2.new(1, 0, 0, 0)
		card.AutomaticSize = Enum.AutomaticSize.Y
		corner(card, 10)
		local stroke = instance.uistroke(card)
		stroke.Color = spec.accent
		stroke.Transparency = 0.8
		stroke.Thickness = 1

		local pad = instance.uipadding(card)
		pad.PaddingTop = UDim.new(0, 14)
		pad.PaddingBottom = UDim.new(0, 14)
		pad.PaddingLeft = UDim.new(0, 14)
		pad.PaddingRight = UDim.new(0, 14)
		local list = instance.uilistlayout(card)
		list.Padding = UDim.new(0, 10)
		list.SortOrder = Enum.SortOrder.LayoutOrder

		local top = instance.frame(card)
		top.BackgroundTransparency = 1
		top.BorderSizePixel = 0
		top.LayoutOrder = 1
		top.Size = UDim2.new(1, 0, 0, 38)

		local tile = instance.frame(top)
		tile.BorderSizePixel = 0
		tile.BackgroundColor3 = spec.accent:Lerp(theme.Card, 0.8)
		tile.Size = UDim2.new(0, 38, 0, 38)
		corner(tile, 10)
		local tilestroke = instance.uistroke(tile)
		tilestroke.Color = spec.accent
		tilestroke.Transparency = 0.7
		tilestroke.Thickness = 1
		local glyph = instance.imagelabel(tile)
		glyph.BackgroundTransparency = 1
		glyph.BorderSizePixel = 0
		glyph.AnchorPoint = Vector2.new(0.5, 0.5)
		glyph.Position = UDim2.new(0.5, 0, 0.5, 0)
		glyph.Size = UDim2.new(0, 22, 0, 22)
		glyph.ImageColor3 = spec.accent:Lerp(Color3.new(1, 1, 1), 0.25)
		applyicon(glyph, spec.icon, 48)

		local title = label(top, spec.title, Enum.Font.GothamBold, 15, theme.Text)
		title.Position = UDim2.new(0, 48, 0, 2)
		title.Size = UDim2.new(1, -48, 0, 18)
		title.TextTruncate = Enum.TextTruncate.AtEnd
		local tag = label(top, spec.tag, Enum.Font.GothamMedium, 11, theme.SubText)
		tag.Position = UDim2.new(0, 48, 0, 21)
		tag.Size = UDim2.new(1, -48, 0, 15)
		tag.TextTruncate = Enum.TextTruncate.AtEnd

		local desc = label(card, spec.description, Enum.Font.Gotham, 13, theme.SubText)
		desc.LayoutOrder = 2
		desc.TextWrapped = true
		desc.TextYAlignment = Enum.TextYAlignment.Top
		desc.Size = UDim2.new(1, 0, 0, 0)
		desc.AutomaticSize = Enum.AutomaticSize.Y

		local field = instance.frame(card)
		field.LayoutOrder = 3
		field.BorderSizePixel = 0
		field.BackgroundColor3 = theme.Field
		field.Size = UDim2.new(1, 0, 0, rowheight - 4)
		corner(field, 8)
		local fieldicon = instance.imagelabel(field)
		fieldicon.BackgroundTransparency = 1
		fieldicon.BorderSizePixel = 0
		fieldicon.AnchorPoint = Vector2.new(0, 0.5)
		fieldicon.Position = UDim2.new(0, 10, 0.5, 0)
		fieldicon.Size = UDim2.new(0, 14, 0, 14)
		fieldicon.ImageColor3 = theme.Dim
		applyicon(fieldicon, "link", 48)
		local urllabel = label(field, spec.url, Enum.Font.GothamMedium, 12, theme.Text)
		urllabel.TextTruncate = Enum.TextTruncate.AtEnd
		urllabel.Position = UDim2.new(0, 32, 0, 0)
		urllabel.Size = UDim2.new(1, -42, 1, 0)

		local button = instance.textbutton(card)
		button.LayoutOrder = 4
		button.AutoButtonColor = false
		button.BorderSizePixel = 0
		button.BackgroundColor3 = spec.accent
		button.Size = UDim2.new(1, 0, 0, rowheight)
		button.Font = Enum.Font.GothamBold
		button.TextSize = 13
		button.TextColor3 = spec.accentText
		button.Text = spec.button
		corner(button, 8)
		local hover = spec.accent:Lerp(Color3.new(1, 1, 1), 0.14)
		button.MouseEnter:Connect(function()
			tw(button, { BackgroundColor3 = hover }, 0.15)
		end)
		button.MouseLeave:Connect(function()
			tw(button, { BackgroundColor3 = spec.accent }, 0.2)
		end)
		local busy = false
		button.Activated:Connect(function()
			local copied = clipboardwrite(spec.url)
			if busy then
				return
			end
			busy = true
			button.Text = copied and "Copied!" or "Clipboard not supported"
			task.delay(1.5, function()
				busy = false
				if button.Parent then
					button.Text = spec.button
				end
			end)
		end)
		return card
	end

	newcard({
		icon = assets.Discord,
		title = "Discord",
		tag = "Community & support",
		description = "Join to ask questions, get help, talk about scripts, and hear about the latest updates first.",
		url = ctx.Discord,
		button = "Copy Discord Invite",
		accent = Color3.fromRGB(88, 101, 242),
		accentText = Color3.fromRGB(255, 255, 255),
	})
	newcard({
		icon = "wallet",
		title = "Donate",
		tag = "Support development",
		description = "Help us keep building and updating quality premium scripts, so they stay free and keyless for everyone.",
		url = ctx.Donate,
		button = "Copy Donate Link",
		accent = theme.Gold,
		accentText = Color3.fromRGB(20, 16, 6),
	})
end

MXHUB.I18n = {
	Current = "English",
	Languages = { "English", "Indonesia" },
	Dict = {
		Indonesia = {
			["Attack"] = "Serang",
			["Settings"] = "Pengaturan",
			["Unload"] = "Keluar",
			["Auto Farm"] = "Farm Otomatis",
			["Home"] = "Beranda",
			["Community"] = "Komunitas",
			["General"] = "Umum",
			["Tools"] = "Alat",
			["More"] = "Lainnya",
			["Misc"] = "Lainnya",
			["Collect"] = "Kumpulkan",
			["Search"] = "Cari",
			["Save"] = "Simpan",
			["Load"] = "Muat",
			["Delete"] = "Hapus",
			["Language"] = "Bahasa",
			["Menu Scale"] = "Skala Menu",
			["Style"] = "Gaya",
			["Theme"] = "Tema",
			["Menu Key"] = "Tombol Menu",
			["Interface"] = "Antarmuka",
			["Lock UI"] = "Kunci UI",
			["Show Watermark"] = "Tampilkan Watermark",
			["Hide Username"] = "Sembunyikan Nama",
			["FPS Boost"] = "Peningkat FPS",
			["Mute Game Sound"] = "Bisukan Suara Game",
			["Lowest Server"] = "Server Terendah",
			["Copy Job ID"] = "Salin Job ID",
			["Join Job ID"] = "Gabung Job ID",
			["Config Manager"] = "Pengelola Config",
			["Apply Theme"] = "Terapkan Tema",
			["Reset Theme"] = "Reset Tema",
			["Custom Accent (hex)"] = "Warna Aksen Kustom (hex)",
			["Dark"] = "Gelap",
			["Light"] = "Terang",
			["Auto"] = "Otomatis",
			["Custom"] = "Kustom",
			["Blue"] = "Biru",
			["Purple"] = "Ungu",
			["Red"] = "Merah",
			["Green"] = "Hijau",
			["Cyan"] = "Sian",
			["Orange"] = "Oranye",
			["Member"] = "Anggota",
			["PREMIUM ONLY"] = "KHUSUS PREMIUM",
			["Press a key..."] = "Tekan sebuah tombol...",
			["MX HUB COMMUNITY"] = "KOMUNITAS MX HUB",
			["Copy Discord Invite"] = "Salin Undangan Discord",
			["Copy Donate Link"] = "Salin Link Donasi",
			["Copied!"] = "Tersalin!",
			["Community & support"] = "Komunitas & dukungan",
			["Support development"] = "Dukung pengembangan",
			["Discord and donations, all in one place"] = "Discord dan donasi, semuanya di satu tempat",
		},
	},
}
MXHUB.UnloadCallbacks = {}
MXHUB.UserScale = 1

function MXHUB:OnUnload(callback)
	if type(callback) == "function" then
		table.insert(self.UnloadCallbacks, callback)
	end
end

-- MXHUB:AddTranslations("Indonesia", { ["Auto Boss"] = "Boss Otomatis" })
-- A new language name is added to the Language menu automatically.
function MXHUB:AddTranslations(language, entries)
	if type(language) ~= "string" or type(entries) ~= "table" then
		return
	end
	local i18n = self.I18n
	if not table.find(i18n.Languages, language) then
		table.insert(i18n.Languages, language)
	end
	i18n.Dict[language] = i18n.Dict[language] or {}
	for key, value in pairs(entries) do
		if type(key) == "string" and type(value) == "string" then
			i18n.Dict[language][key] = value
		end
	end
	if self.RefreshLanguage then
		pcall(self.RefreshLanguage)
	end
end

function MXHUB:Window(guiconfig)
	guiconfig = guiconfig or {}
	MXHUB.Unloaded = false
	guiconfig.Title = "MX HUB"
	guiconfig.Footer = guiconfig.Footer or "MX HUB"
	local gamename = tostring(guiconfig.GameName or guiconfig.Footer or "")
	if gamename == "" or gamename == "MX HUB" then
		gamename = "Game " .. tostring(game.PlaceId)
	end
	guiconfig.Color = guiconfig.Color or theme.Accent
	guiconfig["Tab Width"] = guiconfig["Tab Width"] or (guiconfig.IconRail == true and 40 or 120)
	guiconfig.Version = guiconfig.Version or 1
	local function islogoid(value)
		local text = tostring(value or ""):gsub("%s+", ""):gsub("^rbxassetid://", "")
		return text == assets.LogoId
	end
	local function realimage(value)
		if value == nil or value == false or islogoid(value) then
			return nil
		end
		return value
	end
	guiconfig.WatermarkLogo = realimage(guiconfig.WatermarkLogo)
	guiconfig.HomeLogo = realimage(guiconfig.HomeLogo)
	local userPassedImage = realimage(guiconfig.Image)
	local userPassedToggle = realimage(guiconfig.ToggleImage or guiconfig.ToggleIcon or guiconfig.ButtonImage)
	guiconfig.Image = userPassedImage or assets.LogoId
	guiconfig.ImageSize = tonumber(guiconfig.ImageSize) or 48
	guiconfig.Community = guiconfig.Community ~= false
	guiconfig.Home = guiconfig.Home ~= false
	guiconfig.Settings = guiconfig.Settings ~= false
	guiconfig.LazyConfigTab = guiconfig.LazyConfigTab ~= false
	guiconfig.LoadUserThumbnail = guiconfig.LoadUserThumbnail ~= false
	guiconfig.ThumbnailDelay = tonumber(guiconfig.ThumbnailDelay) or 8

	local foldername = config.cleanname(guiconfig.ConfigFolder or gamename)
	if foldername == "" then
		foldername = "Game " .. tostring(game.PlaceId)
	end
	config.game = gamename
	config.gamefolder = "MX HUB/" .. foldername
	config.autoloadfile = config.gamefolder .. "/autoload.txt"
	config:ensurefolders()

	config.version = guiconfig.Version

	local autoloadname = config:getautoload()
	if autoloadname then
		config:load(autoloadname)
	else
		config.data = { _version = config.version }
	end

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

	local dropshadowholder = instance.frame(mxhubui)
	dropshadowholder.Name = "DropShadowHolder"
	dropshadowholder.BackgroundTransparency = 1
	dropshadowholder.BorderSizePixel = 0
	dropshadowholder.AnchorPoint = Vector2.new(0.5, 0.5)
	dropshadowholder.Position = UDim2.new(0.5, 0, 0.5, 0)
	dropshadowholder.ZIndex = 0
	if isMobile then
		dropshadowholder.Size = safesize(470, 270)
	else
		dropshadowholder.Size = safesize(640, 400)
	end

	dropshadowholder.Position = UDim2.new(0.5, 0, 0.5, 0)

	local dropshadow = instance.frame(dropshadowholder)
	dropshadow.Name = "Shell"
	dropshadow.BackgroundTransparency = 1
	dropshadow.BorderSizePixel = 0
	dropshadow.AnchorPoint = Vector2.new(0.5, 0.5)
	dropshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	dropshadow.Size = UDim2.new(1, 47, 1, 47)
	dropshadow.ZIndex = 0

	local bgRaw = guiconfig.Background
		or guiconfig.BackgroundImage
		or (userPassedImage and tostring(userPassedImage):gsub("%s+", "") ~= assets.LogoId and userPassedImage)
		or nil

	local bgAsset = nil
	if bgRaw then
		local s = iconstring(bgRaw)
		if s ~= "" and s:lower() ~= "none" and s:lower() ~= "false" then
			bgAsset = resolveiconasset(s)
		end
	end

	local main
	if bgAsset then
		main = instance.imagelabel(dropshadow)
		main.Image = bgAsset
		main.ScaleType = Enum.ScaleType.Crop
		main.BackgroundTransparency = 0
		main.BackgroundColor3 = theme.Backdrop
		local dim = math.clamp(tonumber(guiconfig.ThemeDim or guiconfig.BackgroundDim) or 0.68, 0, 1)
		local gray = math.floor((1 - dim) * 255 + 0.5)
		main.ImageColor3 = Color3.fromRGB(gray, gray, gray)
		rowalpha = math.clamp(tonumber(guiconfig.RowTransparency or guiconfig.RowAlpha) or 0, 0, 0.9)
	else
		rowalpha = 0
		main = instance.frame(dropshadow)
		main.BackgroundColor3 = theme.Backdrop
		main.BackgroundTransparency = 1
	end

	local mainstroke = instance.uistroke(main)
	mainstroke.Color = theme.Stroke
	mainstroke.Thickness = 1
	main.Name = "Main"
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	main.BorderSizePixel = 0
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.Size = UDim2.new(1, -47, 1, -47)

	local uicorner = instance.uicorner(main)

	if bgAsset then
		local scrim = instance.frame(main)
		scrim.Name = "Scrim"
		scrim.BackgroundColor3 = theme.Backdrop
		scrim.BackgroundTransparency = 0

		local scrimleft = math.clamp(tonumber(guiconfig.ThemeScrim) or 0.15, 0, 1)
		local scrimright = math.clamp(tonumber(guiconfig.ThemeScrimRight) or 0.55, 0, 1)
		local scrimgradient = instance.uigradient(scrim)
		scrimgradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, scrimleft),
			NumberSequenceKeypoint.new(0.3, math.min(1, scrimleft + 0.1)),
			NumberSequenceKeypoint.new(1, scrimright),
		})
		scrim.BorderSizePixel = 0
		scrim.Size = UDim2.new(1, 0, 1, 0)
		scrim.ZIndex = 0
		instance.uicorner(scrim).CornerRadius = uicorner.CornerRadius
	end

	local top = instance.frame(main)
	top.Name = "Top"
	top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	top.BackgroundTransparency = 1
	top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	top.BorderSizePixel = 0
	top.Size = UDim2.new(1, 0, 0, 38)

	local textlabel = instance.textlabel(top)
	textlabel.Font = Enum.Font.GothamBlack
	textlabel.Text = guiconfig.IconRail == true and "MX" or guiconfig.Title
	textlabel.TextColor3 = theme.Text
	textlabel.TextSize = 20
	textlabel.TextXAlignment = Enum.TextXAlignment.Left
	textlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textlabel.BackgroundTransparency = 1
	textlabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	textlabel.BorderSizePixel = 0
	textlabel.Size = UDim2.new(1, -100, 1, 0)
	textlabel.Position = UDim2.new(0, 14, 0, 0)
	textlabel.ZIndex = 2

	local titleglow = instance.textlabel(top)
	titleglow.Name = "TitleGlow"
	titleglow.Font = Enum.Font.GothamBlack
	titleglow.Text = textlabel.Text
	titleglow.TextColor3 = theme.Accent
	titleglow.TextSize = 20
	titleglow.TextXAlignment = Enum.TextXAlignment.Left
	titleglow.BackgroundTransparency = 1
	titleglow.BorderSizePixel = 0
	titleglow.ZIndex = 1
	titleglow.Position = UDim2.new(0, 15, 0, 0)
	titleglow.Size = UDim2.new(0, guiconfig["Tab Width"], 1, 0)

	local uicorner1 = instance.uicorner(top)

	local textlabel1 = instance.textlabel(top)
	textlabel1.Font = Enum.Font.GothamBold
	textlabel1.Text = guiconfig.Footer
	textlabel1.TextColor3 = theme.SubText
	textlabel1.TextSize = 14
	textlabel1.TextXAlignment = Enum.TextXAlignment.Left
	textlabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textlabel1.BackgroundTransparency = 1
	textlabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	textlabel1.BorderSizePixel = 0
	textlabel1.Visible = false

	local headergap = math.clamp(tonumber(guiconfig.TitleGap) or 22, 8, 60)
	local function measuretitle()
		local okm, bounds = pcall(function()
			return sv.textservice:GetTextSize(tostring(textlabel.Text), 20, Enum.Font.GothamBlack, Vector2.new(1000, 38))
		end)
		if okm and bounds and bounds.X > 0 then
			return math.ceil(bounds.X)
		end
		return math.ceil(textlabel.TextBounds.X)
	end
	local titlewidth = measuretitle()
	do
		local sidew = guiconfig["Tab Width"] + 10
		local startx = math.max(math.floor((sidew - titlewidth) / 2), 4)
		textlabel.Position = UDim2.new(0, startx, 0, 0)
		textlabel.Size = UDim2.new(0, titlewidth + 2, 1, 0)
		titleglow.Position = UDim2.new(0, startx + 1, 0, 0)
		titleglow.Size = textlabel.Size
	end
	local footerx = 18 + titlewidth + headergap
	textlabel1.TextTruncate = Enum.TextTruncate.AtEnd
	textlabel1.Size = UDim2.new(1, -(footerx + 66 + (isMobile and 110 or 150) + 10), 1, 0)
	textlabel1.Position = UDim2.new(0, footerx, 0, 0)

	local headerdivider = instance.frame(top)
	headerdivider.Name = "TitleDivider"
	headerdivider.AnchorPoint = Vector2.new(0.5, 0.5)
	headerdivider.BackgroundColor3 = theme.Stroke
	headerdivider.BackgroundTransparency = 0.1
	headerdivider.BorderSizePixel = 0
	headerdivider.Position = UDim2.new(0, 18 + titlewidth + headergap / 2, 0.5, 0)
	headerdivider.Size = UDim2.new(0, 1, 0, 14)
	headerdivider.Visible = false

	local close = instance.textbutton(top)
	close.Name = "Close"
	close.Font = Enum.Font.SourceSans
	close.Text = ""
	close.TextColor3 = Color3.fromRGB(0, 0, 0)
	close.TextSize = 14
	close.AnchorPoint = Vector2.new(1, 0.5)
	close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	close.BackgroundTransparency = 1
	close.BorderColor3 = Color3.fromRGB(0, 0, 0)
	close.BorderSizePixel = 0
	close.Position = UDim2.new(1, -8, 0.5, 0)
	close.Size = UDim2.new(0, 25, 0, 25)

	local imagelabel1 = instance.imagelabel(close)
	applyicon(imagelabel1, "x", 48)
	imagelabel1.AnchorPoint = Vector2.new(0.5, 0.5)
	imagelabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	imagelabel1.BackgroundTransparency = 1
	imagelabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	imagelabel1.BorderSizePixel = 0
	imagelabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
	imagelabel1.Size = UDim2.new(1, -8, 1, -8)

	local min = instance.textbutton(top)
	min.Name = "Min"
	min.Font = Enum.Font.SourceSans
	min.Text = ""
	min.TextColor3 = Color3.fromRGB(0, 0, 0)
	min.TextSize = 14
	min.AnchorPoint = Vector2.new(1, 0.5)
	min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	min.BackgroundTransparency = 1
	min.BorderColor3 = Color3.fromRGB(0, 0, 0)
	min.BorderSizePixel = 0
	min.Position = UDim2.new(1, -38, 0.5, 0)
	min.Size = UDim2.new(0, 25, 0, 25)

	local imagelabel2 = instance.imagelabel(min)
	applyicon(imagelabel2, "minus", 48)
	imagelabel2.AnchorPoint = Vector2.new(0.5, 0.5)
	imagelabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	imagelabel2.BackgroundTransparency = 1
	imagelabel2.ImageTransparency = 0.2
	imagelabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	imagelabel2.BorderSizePixel = 0
	imagelabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
	imagelabel2.Size = UDim2.new(1, -9, 1, -9)

	local searchbox = instance.textbox(top)
	searchbox.Name = "SearchBox"
	searchbox.AnchorPoint = Vector2.new(1, 0.5)
	searchbox.Position = UDim2.new(1, -66, 0.5, 0)
	searchbox.Size = UDim2.new(0, isMobile and 110 or 150, 0, 24)
	searchbox.BackgroundColor3 = theme.Pill
	searchbox.BackgroundTransparency = 0
	searchbox.BorderSizePixel = 0
	searchbox.Font = Enum.Font.Gotham
	searchbox.PlaceholderText = "Search"
	searchbox.PlaceholderColor3 = theme.Dim
	searchbox.Text = ""
	searchbox.TextColor3 = theme.Text
	searchbox.TextSize = 12
	searchbox.TextXAlignment = Enum.TextXAlignment.Left
	searchbox.ClearTextOnFocus = false
	searchbox.ClipsDescendants = true
	searchbox.TextTruncate = Enum.TextTruncate.AtEnd
	instance.uicorner(searchbox).CornerRadius = UDim.new(1, 0)

	local searchstroke = instance.uistroke(searchbox)
	searchstroke.Color = theme.Stroke
	searchstroke.Thickness = 1
	searchstroke.Transparency = 0.35

	local searchpad = instance.uipadding(searchbox)
	searchpad.PaddingLeft = UDim.new(0, 26)
	searchpad.PaddingRight = UDim.new(0, 10)

	local searchicon = instance.imagelabel(searchbox)
	searchicon.AnchorPoint = Vector2.new(0, 0.5)
	searchicon.Position = UDim2.new(0, -17, 0.5, 0)
	searchicon.Size = UDim2.new(0, 12, 0, 12)
	searchicon.BackgroundTransparency = 1
	searchicon.ImageColor3 = theme.Dim
	applyicon(searchicon, "search", 48)

	do
		local searchwidth = isMobile and 110 or 150
		local chips = instance.frame(top)
		chips.Name = "Chips"
		chips.BackgroundTransparency = 1
		chips.BorderSizePixel = 0
		chips.AnchorPoint = Vector2.new(1, 0.5)
		chips.Position = UDim2.new(1, -(66 + searchwidth + 8), 0.5, 0)
		chips.Size = UDim2.new(0, 0, 0, 22)
		chips.AutomaticSize = Enum.AutomaticSize.X

		local chiplist = instance.uilistlayout(chips)
		chiplist.FillDirection = Enum.FillDirection.Horizontal
		chiplist.Padding = UDim.new(0, 4)
		chiplist.SortOrder = Enum.SortOrder.LayoutOrder
		chiplist.VerticalAlignment = Enum.VerticalAlignment.Center
		chiplist.HorizontalAlignment = Enum.HorizontalAlignment.Right

		chips:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			textlabel1.TextTruncate = Enum.TextTruncate.AtEnd
			local reserved = 66 + searchwidth + 8 + chips.AbsoluteSize.X / fitscaleof(chips) + 8
			textlabel1.Size = UDim2.new(1, -(footerx + reserved), 1, 0)
		end)
	end

	local MX = { Tab = nil, Current = nil }
	do
		local tabwidthpx = guiconfig["Tab Width"]

		local sidewidth = tabwidthpx + 10
		local sidepanel = instance.frame(main)
		sidepanel.Name = "SidePanel"
		sidepanel.BackgroundColor3 = theme.Sidebar
		sidepanel.BackgroundTransparency = 0
		sidepanel.BorderSizePixel = 0
		sidepanel.ZIndex = 0
		sidepanel.Size = UDim2.new(0, sidewidth, 1, 0)
		instance.uicorner(sidepanel).CornerRadius = uicorner.CornerRadius
		local sidefill = instance.frame(sidepanel)
		sidefill.Name = "Fill"
		sidefill.BackgroundColor3 = theme.Sidebar
		sidefill.BackgroundTransparency = 0
		sidefill.BorderSizePixel = 0
		sidefill.AnchorPoint = Vector2.new(1, 0)
		sidefill.Position = UDim2.new(1, 0, 0, 0)
		sidefill.Size = UDim2.new(0, 16, 1, 0)

		for _, glass in ipairs({ sidepanel, sidefill }) do
			local fade = instance.uigradient(glass)
			fade.Rotation = 90
			fade.Transparency = NumberSequence.new(0.08, 0.2)
		end

		glassblur(sidepanel)

		if not bgAsset then
			local contentpanel = instance.frame(main)
			contentpanel.Name = "ContentPanel"
			contentpanel.BackgroundColor3 = theme.Backdrop
			contentpanel.BorderSizePixel = 0
			contentpanel.ZIndex = -1
			contentpanel.Position = UDim2.new(0, sidewidth, 0, 0)
			contentpanel.Size = UDim2.new(1, -sidewidth, 1, 0)
			instance.uicorner(contentpanel).CornerRadius = uicorner.CornerRadius

			local contentjoin = instance.frame(main)
			contentjoin.Name = "ContentJoin"
			contentjoin.BackgroundColor3 = theme.Backdrop
			contentjoin.BorderSizePixel = 0
			contentjoin.ZIndex = -1
			contentjoin.Position = UDim2.new(0, sidewidth, 0, 0)
			contentjoin.Size = UDim2.new(0, 24, 1, 0)
		end

		local savebutton = instance.textbutton(top)
		savebutton.Name = "SaveButton"
		savebutton.Visible = false
		savebutton.Text = ""
		savebutton.AutoButtonColor = false
		savebutton.AnchorPoint = Vector2.new(0, 0.5)
		savebutton.Position = UDim2.new(0, tabwidthpx + 16, 0.5, 0)
		savebutton.Size = UDim2.new(0, 66, 0, 24)
		savebutton.BackgroundColor3 = theme.Pill
		savebutton.BorderSizePixel = 0
		instance.uicorner(savebutton).CornerRadius = UDim.new(0, 5)
		local savestroke = instance.uistroke(savebutton)
		savestroke.Color = theme.Stroke
		savestroke.Thickness = 1
		savestroke.Transparency = 0.1

		local saveicon = instance.imagelabel(savebutton)
		saveicon.Name = "Icon"
		saveicon.BackgroundTransparency = 1
		saveicon.AnchorPoint = Vector2.new(0, 0.5)
		saveicon.Position = UDim2.new(0, 10, 0.5, 0)
		saveicon.Size = UDim2.new(0, 12, 0, 12)
		saveicon.ImageColor3 = theme.SubText
		applyicon(saveicon, "save", 48)

		local savelabel = instance.textlabel(savebutton)
		savelabel.Name = "Label"
		savelabel.BackgroundTransparency = 1
		savelabel.Font = Enum.Font.GothamMedium
		savelabel.Text = "Save"
		savelabel.TextSize = 12
		savelabel.TextColor3 = theme.SubText
		savelabel.TextXAlignment = Enum.TextXAlignment.Left
		savelabel.Position = UDim2.new(0, 28, 0, 0)
		savelabel.Size = UDim2.new(1, -30, 1, 0)

		savebutton.MouseEnter:Connect(function()
			tw(savebutton, { BackgroundColor3 = theme.ElementHover }, 0.15)
			tw(savelabel, { TextColor3 = theme.Text }, 0.15)
			tw(saveicon, { ImageColor3 = theme.Accent }, 0.15)
		end)
		savebutton.MouseLeave:Connect(function()
			tw(savebutton, { BackgroundColor3 = theme.Pill }, 0.2)
			tw(savelabel, { TextColor3 = theme.SubText }, 0.2)
			tw(saveicon, { ImageColor3 = theme.SubText }, 0.2)
		end)
		savebutton.Activated:Connect(function()
			pcall(pesseffect, savebutton)
			config:savecurrent()
		end)

		local subbar = instance.frame(top)
		subbar.Name = "SubTabs"
		subbar.AnchorPoint = Vector2.new(0, 0.5)
		subbar.Position = UDim2.new(0, tabwidthpx + 16, 0.5, 0)
		subbar.Size = UDim2.new(0, 0, 0, 24)
		subbar.AutomaticSize = Enum.AutomaticSize.X
		subbar.BackgroundColor3 = theme.Pill
		subbar.BorderSizePixel = 0
		subbar.Visible = false
		instance.uicorner(subbar).CornerRadius = UDim.new(0, 5)
		local subbarstroke = instance.uistroke(subbar)
		subbarstroke.Color = theme.Stroke
		subbarstroke.Thickness = 1
		subbarstroke.Transparency = 0.1
		local subbarpad = instance.uipadding(subbar)
		subbarpad.PaddingLeft = UDim.new(0, 2)
		subbarpad.PaddingRight = UDim.new(0, 2)
		local subbarlayout = instance.uilistlayout(subbar)
		subbarlayout.FillDirection = Enum.FillDirection.Horizontal
		subbarlayout.SortOrder = Enum.SortOrder.LayoutOrder
		subbarlayout.VerticalAlignment = Enum.VerticalAlignment.Center
		subbarlayout.Padding = UDim.new(0, 2)

		local subbuttons = {}

		function MX.relayout()
			if not top.Parent then
				return
			end
			local scale = fitscaleof(top)
			local width = top.AbsoluteSize.X / scale
			local compact = width < 540
			savebutton.Size = UDim2.new(0, compact and 28 or 66, 0, 24)
			savelabel.Visible = not compact
			saveicon.Position = compact and UDim2.new(0.5, -6, 0.5, 0) or UDim2.new(0, 10, 0.5, 0)
			local subx = tabwidthpx + 16
			subbar.Position = UDim2.new(0, subx, 0.5, 0)
			local searchmax = isMobile and 110 or 150
			local used = 0
			if subbar.Visible then
				used = subbar.AbsoluteSize.X / scale + 12
			end
			local room = width - subx - used - 66 - 8
			searchbox.Size = UDim2.new(0, math.clamp(math.floor(room), 70, searchmax), 0, 24)
		end

		function MX.clearsubbar()
			if MX.Current == nil and not subbar.Visible then
				return
			end
			for _, entry in ipairs(subbuttons) do
				entry:Destroy()
			end
			table.clear(subbuttons)
			subbar.Visible = false
			MX.Current = nil
			MX.relayout()
		end

		function MX.paintsub(active)
			for index, button in ipairs(subbuttons) do
				local on = index == active
				tw(button, { BackgroundTransparency = on and 0 or 1, TextColor3 = on and theme.Text or theme.SubText }, 0.18)
			end
		end

		function MX.showsubbar(owner, names, active, pick)
			if MX.Current ~= owner or #subbuttons ~= #names then
				for _, entry in ipairs(subbuttons) do
					entry:Destroy()
				end
				table.clear(subbuttons)
				MX.Current = owner
				for index, name in ipairs(names) do
					local button = instance.textbutton(subbar)
					button.Name = "SubTab"
					button.LayoutOrder = index
					button.AutoButtonColor = false
					button.BorderSizePixel = 0
					button.BackgroundColor3 = theme.TabActive
					button.BackgroundTransparency = 1
					button.Font = Enum.Font.GothamMedium
					button.TextSize = 12
					button.Text = tostring(name)
					button.TextColor3 = theme.SubText
					button.AutomaticSize = Enum.AutomaticSize.X
					button.Size = UDim2.new(0, 0, 1, -4)
					instance.uicorner(button).CornerRadius = UDim.new(0, 4)
					local padding = instance.uipadding(button)
					padding.PaddingLeft = UDim.new(0, 12)
					padding.PaddingRight = UDim.new(0, 12)
					button.Activated:Connect(function()
						pick(index)
					end)
					subbuttons[index] = button
				end
			end
			subbar.Visible = #names > 0
			MX.paintsub(active)
			MX.relayout()
		end

		local function queuerelayout()
			debounceResize("mx_top_relayout", MX.relayout, 0.03)
		end
		trackConnection(top:GetPropertyChangedSignal("AbsoluteSize"):Connect(queuerelayout), "mx.top.size")
		trackConnection(subbar:GetPropertyChangedSignal("AbsoluteSize"):Connect(queuerelayout), "mx.subbar.size")
		task.defer(MX.relayout)
	end

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

	local userfooter = instance.frame(main)
	userfooter.Name = "UserFooter"
	userfooter.BackgroundColor3 = theme.Row
	userfooter.BackgroundTransparency = rowalpha
	userfooter.BorderSizePixel = 0
	userfooter.AnchorPoint = Vector2.new(0, 1)
	userfooter.Position = UDim2.new(0, 3, 1, -8)
	userfooter.Size = UDim2.new(0, guiconfig["Tab Width"], 0, 46)
	instance.uicorner(userfooter).CornerRadius = UDim.new(0, 8)
	local footerstroke = instance.uistroke(userfooter)
	footerstroke.Color = theme.Stroke
	footerstroke.Thickness = 1
	footerstroke.Transparency = 0.5

	local localplayer = sv.plrs.LocalPlayer

	local headshot = instance.imagelabel(userfooter)
	headshot.Name = "Headshot"
	headshot.BackgroundColor3 = theme.Field
	headshot.BorderSizePixel = 0
	headshot.AnchorPoint = Vector2.new(0, 0.5)
	headshot.Position = UDim2.new(0, 8, 0.5, 0)
	headshot.Size = UDim2.new(0, 30, 0, 30)
	instance.uicorner(headshot).CornerRadius = UDim.new(1, 0)
	if localplayer then
		headshot.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100", localplayer.UserId)
	end

	local onlinedot = instance.frame(userfooter)
	onlinedot.Name = "Online"
	onlinedot.AnchorPoint = Vector2.new(0.5, 0.5)
	onlinedot.BackgroundColor3 = Color3.fromRGB(74, 222, 128)
	onlinedot.BorderSizePixel = 0
	onlinedot.Position = UDim2.new(0, 35, 0.5, 11)
	onlinedot.Size = UDim2.new(0, 9, 0, 9)
	instance.uicorner(onlinedot).CornerRadius = UDim.new(1, 0)
	local dotstroke = instance.uistroke(onlinedot)
	dotstroke.Color = theme.Row
	dotstroke.Thickness = 2

	local username = instance.textlabel(userfooter)
	username.Name = "Username"
	username.BackgroundTransparency = 1
	username.Font = Enum.Font.GothamBold
	username.TextColor3 = theme.Text
	username.TextSize = 12
	username.TextXAlignment = Enum.TextXAlignment.Left
	username.TextTruncate = Enum.TextTruncate.AtEnd
	username.Position = UDim2.new(0, 46, 0.5, -14)
	username.Size = UDim2.new(1, -54, 0, 14)
	if localplayer then
		username.Text = localplayer.DisplayName ~= "" and localplayer.DisplayName or localplayer.Name
	else
		username.Text = "User"
	end

	local handlelabel = instance.textlabel(userfooter)
	handlelabel.Name = "Handle"
	handlelabel.BackgroundTransparency = 1
	handlelabel.Font = Enum.Font.GothamMedium
	handlelabel.TextColor3 = theme.SubText
	handlelabel.TextSize = 11
	handlelabel.TextXAlignment = Enum.TextXAlignment.Left
	handlelabel.TextTruncate = Enum.TextTruncate.AtEnd
	handlelabel.Position = UDim2.new(0, 46, 0.5, 1)
	handlelabel.Size = UDim2.new(1, -54, 0, 13)
	handlelabel.Text = localplayer and ("@" .. localplayer.Name) or ""
	function guifunc:DestroyGui()
		disconnectAll()
		for key, timer in pairs(resizeDebounceTable) do
			if timer then
				task.cancel(timer)
			end
		end
		resizeDebounceTable = {}

		if sv.coregui:FindFirstChild("MXHUBUI") then
			mxhubui:Destroy()
		end

		if sv.coregui:FindFirstChild("ToggleUIButton") then
			sv.coregui.ToggleUIButton:Destroy()
		end

		if guifunc.Watermark then
			guifunc.Watermark:Destroy()
		end

		for _, child in ipairs(sv.coregui:GetChildren()) do
			if child.Name == "PopupGui" then
				pcall(function()
					child:Destroy()
				end)
			end
		end

		pcall(function()
			for _, callback in ipairs(MXHUB.UnloadCallbacks or {}) do
				pcall(callback)
			end
		end)
		pcall(MXHUB.FpsBoost, false)
		pcall(MXHUB.AntiAfk, false)
		MXHUB.Unloaded = true

		getgenv().MXHUB_Instance = nil
		getgenv().MXHUB_Running = nil
		getgenv().MXHUB_ReopenPrompt = nil
	end

	min.Activated:Connect(function()
		dropshadowholder.Visible = false
	end)

	close.Activated:Connect(function()
		local overlay = instance.frame(dropshadowholder)
		overlay.Size = UDim2.new(1, 0, 1, 0)
		overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		overlay.BackgroundTransparency = 0.3
		overlay.ZIndex = 50

		local dialog = instance.frame(overlay)
		dialog.Size = UDim2.new(0, 300, 0, 150)
		dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
		dialog.BackgroundColor3 = theme.Card
		dialog.BackgroundTransparency = 0
		dialog.BorderSizePixel = 0
		dialog.ZIndex = 51
		local uicorner3 = instance.uicorner(dialog)
		uicorner3.CornerRadius = UDim.new(0, 8)
		local dialogstroke = instance.uistroke(dialog)
		dialogstroke.Color = theme.Stroke
		dialogstroke.Thickness = 1

		local title = instance.textlabel(dialog)
		title.Name = "Title"
		title.Size = UDim2.new(1, 0, 0, 40)
		title.Position = UDim2.new(0, 0, 0, 4)
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.GothamBold
		title.Text = "MX HUB Window"
		title.TextSize = 22
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.ZIndex = 52

		local message = instance.textlabel(dialog)
		message.Name = "Message"
		message.Size = UDim2.new(1, -20, 0, 60)
		message.Position = UDim2.new(0, 10, 0, 30)
		message.BackgroundTransparency = 1
		message.Font = Enum.Font.Gotham
		message.Text = "Do you want to close this window?\nYou will not be able to open it again"
		message.TextSize = 14
		message.TextColor3 = theme.SubText
		message.TextWrapped = true
		message.ZIndex = 52

		local yes = instance.textbutton(dialog)
		yes.Name = "Yes"
		yes.Size = UDim2.new(0.45, -10, 0, 35)
		yes.Position = UDim2.new(0.05, 0, 1, -55)
		yes.BackgroundColor3 = theme.Element
		yes.BackgroundTransparency = 0
		yes.AutoButtonColor = true
		yes.Text = "Yes"
		yes.Font = Enum.Font.GothamBold
		yes.TextSize = 15
		yes.TextColor3 = Color3.fromRGB(255, 255, 255)
		yes.TextTransparency = 0.3
		yes.ZIndex = 52
		local yescorner = instance.uicorner(yes)
		yescorner.CornerRadius = UDim.new(0, 6)

		local cancel = instance.textbutton(dialog)
		cancel.Name = "Cancel"
		cancel.Size = UDim2.new(0.45, -10, 0, 35)
		cancel.Position = UDim2.new(0.5, 10, 1, -55)
		cancel.BackgroundColor3 = theme.Element
		cancel.BackgroundTransparency = 0
		cancel.AutoButtonColor = true
		cancel.Text = "Cancel"
		cancel.Font = Enum.Font.GothamBold
		cancel.TextSize = 15
		cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
		cancel.TextTransparency = 0.3
		cancel.ZIndex = 52
		local cancelcorner = instance.uicorner(cancel)
		cancelcorner.CornerRadius = UDim.new(0, 6)

		yes.MouseButton1Click:Connect(function()
			guifunc:DestroyGui()
		end)

		cancel.MouseButton1Click:Connect(function()
			overlay:Destroy()
		end)
	end)

	local togglekey = typeof(guiconfig.MenuKey) == "EnumItem" and guiconfig.MenuKey or Enum.KeyCode.F3
	trackConnection(
		sv.uis.InputBegan:Connect(function(input, gpe)
			if gpe then
				return
			end
			if input.KeyCode == togglekey then
				if dropshadowholder then
					dropshadowholder.Visible = not dropshadowholder.Visible
				end
			end
		end),
		"window.togglekey"
	)

	do
		local lighting = game:GetService("Lighting")
		local uipath = "MX HUB/ui.json"
		local uistate = { language = "English", scale = "Auto", menukey = "F3" }
		local i18n = MXHUB.I18n

		local staleblur = lighting:FindFirstChild("MXHUB_Blur")
		if staleblur then
			staleblur:Destroy()
		end

		pcall(function()
			if type(isfile) == "function" and type(readfile) == "function" and isfile(uipath) then
				local data = sv.http:JSONDecode(readfile(uipath))
				if type(data) == "table" then
					for key, value in pairs(data) do
						if uistate[key] ~= nil and type(value) == type(uistate[key]) then
							uistate[key] = value
						end
					end
				end
			end
		end)

		local function saveui()
			pcall(function()
				if type(writefile) ~= "function" then
					return
				end
				if type(isfolder) == "function" and not isfolder("MX HUB") then
					makefolder("MX HUB")
				end
				writefile(uipath, sv.http:JSONEncode(uistate))
			end)
		end

		local function make(class, parent, props)
			local obj = Instance.new(class)
			for key, value in pairs(props) do
				obj[key] = value
			end
			obj.Parent = parent
			return obj
		end

		-- ------------------------------------------------ menu key
		local function keycodeof(name)
			local ok, code = pcall(function()
				return Enum.KeyCode[name]
			end)
			if ok and typeof(code) == "EnumItem" then
				return code
			end
			return nil
		end
		local savedkey = keycodeof(uistate.menukey)
		if savedkey then
			togglekey = savedkey
		end

		-- ------------------------------------------------ menu scale
		dropshadowholder:SetAttribute("MXScalable", true)
		local function applyscale()
			local factor = tonumber(uistate.scale)
			sv.UserScale = factor and math.clamp(factor, 0.6, 1.6) or 1
			for _, refit in ipairs(sv.Refits or {}) do
				pcall(refit)
			end
		end
		applyscale()

		-- ------------------------------------------------ language
		local function translate(inst)
			local class = inst.ClassName
			local prop, origattr, trattr
			if class == "TextLabel" or class == "TextButton" then
				prop, origattr, trattr = "Text", "MXOrig", "MXTr"
			elseif class == "TextBox" then
				prop, origattr, trattr = "PlaceholderText", "MXPOrig", "MXPTr"
			else
				return
			end
			if inst:GetAttribute("MXNoTranslate") then
				return
			end
			local dict = i18n.Dict[i18n.Current]
			local english = i18n.Current == "English"
			local cur = inst[prop]
			local orig = inst:GetAttribute(origattr)
			if orig == nil then
				if english or not (dict and dict[cur]) then
					return
				end
				orig = cur
				inst:SetAttribute(origattr, cur)
			else
				local prev = inst:GetAttribute(trattr)
				if cur ~= orig and cur ~= prev then
					if english or not (dict and dict[cur]) then
						inst:SetAttribute(origattr, nil)
						inst:SetAttribute(trattr, nil)
						return
					end
					orig = cur
					inst:SetAttribute(origattr, cur)
				end
			end
			local target = orig
			if not english and dict and dict[orig] then
				target = dict[orig]
			end
			if target ~= cur then
				inst[prop] = target
			end
			inst:SetAttribute(trattr, target)
		end

		local languagerun = 0
		local function applylanguage()
			languagerun = languagerun + 1
			local id = languagerun
			task.spawn(function()
				local list = mxhubui:GetDescendants()
				for index, inst in ipairs(list) do
					if id ~= languagerun or MXHUB.Unloaded then
						return
					end
					pcall(translate, inst)
					if index % 400 == 0 then
						task.wait()
					end
				end
			end)
		end
		MXHUB.RefreshLanguage = applylanguage

		local languagepending = false
		trackConnection(
			mxhubui.DescendantAdded:Connect(function()
				if i18n.Current == "English" or languagepending then
					return
				end
				languagepending = true
				task.delay(0.15, function()
					languagepending = false
					if i18n.Current ~= "English" and not MXHUB.Unloaded then
						applylanguage()
					end
				end)
			end),
			"mx.i18n.added"
		)

		local refreshvalues
		MXHUB.SetLanguage = function(name)
			if not table.find(i18n.Languages, name) then
				return false
			end
			i18n.Current = name
			uistate.language = name
			saveui()
			applylanguage()
			if refreshvalues then
				refreshvalues()
			end
			return true
		end
		if table.find(i18n.Languages, uistate.language) then
			i18n.Current = uistate.language
			if i18n.Current ~= "English" then
				task.delay(0.6, applylanguage)
			end
		end

		-- ------------------------------------------------ popup shell
		local PW, ROWH, SUBROW = 236, 30, 26
		local POPX = guiconfig["Tab Width"] + 18
		local SUBX = POPX + PW + 6

		local catcher = make("TextButton", main, {
			Name = "ProfileCatcher",
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 18,
			Visible = false,
		})

		local popup = make("Frame", main, {
			Name = "ProfilePopup",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, POPX, 1, -8),
			Size = UDim2.new(0, PW, 0, 0),
			BackgroundColor3 = theme.Card,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 20,
			ClipsDescendants = true,
		})
		make("UICorner", popup, { CornerRadius = UDim.new(0, 10) })
		make("UIStroke", popup, { Color = theme.Stroke, Thickness = 1, Transparency = 0.2 })

		local scroll = make("ScrollingFrame", popup, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = theme.Bar,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
		})
		make("UIListLayout", scroll, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) })
		make("UIPadding", scroll, {
			PaddingTop = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
		})

		local head = make("Frame", scroll, { LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1 })
		local avatar = make("ImageLabel", head, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 2, 0.5, 0),
			Size = UDim2.new(0, 34, 0, 34),
			BackgroundColor3 = theme.Field,
			BorderSizePixel = 0,
			Image = headshot.Image,
		})
		make("UICorner", avatar, { CornerRadius = UDim.new(1, 0) })
		local pname = make("TextLabel", head, {
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			TextColor3 = theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.new(0, 44, 0, 7),
			Size = UDim2.new(1, -46, 0, 16),
			Text = username.Text,
		})
		local prole = make("TextLabel", head, {
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamMedium,
			TextSize = 11,
			TextColor3 = theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.new(0, 44, 0, 25),
			Size = UDim2.new(1, -46, 0, 14),
			Text = handlelabel.Text,
		})
		make("Frame", scroll, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = theme.Stroke,
			BackgroundTransparency = 0.4,
			BorderSizePixel = 0,
		})

		local function addrow(order, iconname, title, danger)
			local button = make("TextButton", scroll, {
				Name = "Row",
				LayoutOrder = order,
				Size = UDim2.new(1, 0, 0, ROWH),
				BackgroundColor3 = theme.ElementHover,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Text = "",
				BorderSizePixel = 0,
			})
			make("UICorner", button, { CornerRadius = UDim.new(0, 6) })
			local icon = make("ImageLabel", button, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 8, 0.5, 0),
				Size = UDim2.new(0, 14, 0, 14),
				ImageColor3 = danger and theme.Bad or theme.SubText,
			})
			applyicon(icon, iconname, 48)
			make("TextLabel", button, {
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				TextSize = 12,
				TextColor3 = danger and theme.Bad or theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.new(0, 30, 0, 0),
				Size = UDim2.new(0.5, -30, 1, 0),
				Text = title,
			})
			local value = make("TextLabel", button, {
				BackgroundTransparency = 1,
				Font = Enum.Font.Gotham,
				TextSize = 12,
				TextColor3 = theme.SubText,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(0.5, -22, 1, 0),
				Text = "",
			})
			if not danger then
				local chevron = make("ImageLabel", button, {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -6, 0.5, 0),
					Size = UDim2.new(0, 11, 0, 11),
					ImageColor3 = theme.Dim,
				})
				applyicon(chevron, "chevron-right", 48)
			end
			button.MouseEnter:Connect(function()
				tw(button, { BackgroundTransparency = 0.6 }, 0.12)
			end)
			button.MouseLeave:Connect(function()
				tw(button, { BackgroundTransparency = 1 }, 0.15)
			end)
			return button, value
		end

		-- ------------------------------------------------ sub menu (option list)
		local sub = make("Frame", main, {
			Name = "ProfileSub",
			BackgroundColor3 = theme.Card,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 128, 0, 40),
			Visible = false,
			ZIndex = 22,
			ClipsDescendants = true,
		})
		make("UICorner", sub, { CornerRadius = UDim.new(0, 8) })
		make("UIStroke", sub, { Color = theme.Stroke, Thickness = 1, Transparency = 0.2 })
		local subscroll = make("ScrollingFrame", sub, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = theme.Bar,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
		})
		make("UIListLayout", subscroll, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1) })
		make("UIPadding", subscroll, {
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
		})

		local subrow
		local function showoptions(row, options, current, onpick)
			if sub.Visible and subrow == row then
				sub.Visible = false
				return
			end
			subrow = row
			for _, child in ipairs(subscroll:GetChildren()) do
				if child:IsA("TextButton") then
					child:Destroy()
				end
			end
			for index, option in ipairs(options) do
				local selected = option.value == current
				local item = make("TextButton", subscroll, {
					LayoutOrder = index,
					Size = UDim2.new(1, 0, 0, SUBROW),
					BackgroundColor3 = theme.TabActive,
					BackgroundTransparency = selected and 0.2 or 1,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Font = Enum.Font.GothamMedium,
					TextSize = 12,
					TextColor3 = selected and theme.Text or theme.SubText,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = option.label,
				})
				make("UICorner", item, { CornerRadius = UDim.new(0, 5) })
				make("UIPadding", item, { PaddingLeft = UDim.new(0, option.color and 26 or 8) })
				if option.color then
					local dot = make("Frame", item, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, -18, 0.5, 0),
						Size = UDim2.new(0, 12, 0, 12),
						BackgroundColor3 = option.color,
						BorderSizePixel = 0,
					})
					make("UICorner", dot, { CornerRadius = UDim.new(1, 0) })
				end
				item.MouseEnter:Connect(function()
					if not selected then
						tw(item, { BackgroundTransparency = 0.6 }, 0.1)
					end
				end)
				item.MouseLeave:Connect(function()
					if not selected then
						tw(item, { BackgroundTransparency = 1 }, 0.12)
					end
				end)
				item.Activated:Connect(function()
					sub.Visible = false
					onpick(option.value)
				end)
			end
			local scale = fitscaleof(main)
			local mainh = main.AbsoluteSize.Y / scale
			local height = math.min(#options * (SUBROW + 1) + 10, mainh - 16)
			local rowy = (row.AbsolutePosition.Y - main.AbsolutePosition.Y) / scale
			local y = math.clamp(rowy, 8, math.max(mainh - height - 8, 8))
			sub.Position = UDim2.new(0, SUBX, 0, y)
			sub.Size = UDim2.new(0, 128, 0, height)
			sub.Visible = true
		end

		-- ------------------------------------------------ colour picker (floating, mouse + touch)
		local picker
		local pickerconns = {}
		local function closepicker()
			if picker then
				picker:Destroy()
				picker = nil
			end
			for _, conn in ipairs(pickerconns) do
				conn:Disconnect()
			end
			table.clear(pickerconns)
		end

		local function openpicker(initial, onchange)
			closepicker()
			local hue, sat, val = initial:ToHSV()
			local alpha = 1
			local PWD, PHT = 208, 206

			local frame = make("Frame", main, {
				Name = "ColorPicker",
				Size = UDim2.new(0, PWD, 0, PHT),
				BackgroundColor3 = theme.Card,
				BorderSizePixel = 0,
				ZIndex = 30,
				Active = true,
			})
			picker = frame
			make("UICorner", frame, { CornerRadius = UDim.new(0, 10) })
			make("UIStroke", frame, { Color = theme.Stroke, Thickness = 1, Transparency = 0.1 })

			local scale = fitscaleof(main)
			local mw, mh = main.AbsoluteSize.X / scale, main.AbsoluteSize.Y / scale
			frame.Position = UDim2.new(
				0,
				math.clamp(SUBX, 8, math.max(mw - PWD - 8, 8)),
				0,
				math.clamp(mh - PHT - 70, 8, math.max(mh - PHT - 8, 8))
			)

			local square = make("Frame", frame, {
				Position = UDim2.new(0, 10, 0, 10),
				Size = UDim2.new(1, -20, 0, 100),
				BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Active = true,
			})
			make("UICorner", square, { CornerRadius = UDim.new(0, 6) })
			local whitelayer = make("Frame", square, {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
			})
			make("UIGradient", whitelayer, {
				Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }),
			})
			local blacklayer = make("Frame", square, {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2,
			})
			make("UIGradient", blacklayer, {
				Rotation = 90,
				Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
			})
			local sqknob = make("Frame", square, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0, 12, 0, 12),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 4,
			})
			make("UICorner", sqknob, { CornerRadius = UDim.new(1, 0) })
			make("UIStroke", sqknob, { Color = Color3.fromRGB(0, 0, 0), Thickness = 1, Transparency = 0.4 })

			local huebar = make("Frame", frame, {
				Position = UDim2.new(0, 10, 0, 120),
				Size = UDim2.new(1, -20, 0, 12),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				Active = true,
			})
			make("UICorner", huebar, { CornerRadius = UDim.new(1, 0) })
			make("UIGradient", huebar, {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
					ColorSequenceKeypoint.new(0.1667, Color3.fromRGB(255, 255, 0)),
					ColorSequenceKeypoint.new(0.3333, Color3.fromRGB(0, 255, 0)),
					ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(0.6667, Color3.fromRGB(0, 0, 255)),
					ColorSequenceKeypoint.new(0.8333, Color3.fromRGB(255, 0, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
				}),
			})
			local hueknob = make("Frame", huebar, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0, 8, 0, 16),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 3,
			})
			make("UICorner", hueknob, { CornerRadius = UDim.new(0, 3) })
			make("UIStroke", hueknob, { Color = Color3.fromRGB(0, 0, 0), Thickness = 1, Transparency = 0.4 })

			local alphabase = make("Frame", frame, {
				Position = UDim2.new(0, 10, 0, 140),
				Size = UDim2.new(1, -20, 0, 12),
				BackgroundColor3 = theme.Field,
				BorderSizePixel = 0,
				Active = true,
			})
			make("UICorner", alphabase, { CornerRadius = UDim.new(1, 0) })
			local alphafill = make("Frame", alphabase, {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = initial,
				BorderSizePixel = 0,
			})
			make("UICorner", alphafill, { CornerRadius = UDim.new(1, 0) })
			make("UIGradient", alphafill, {
				Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
			})
			local alphaknob = make("Frame", alphabase, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0, 8, 0, 16),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 3,
			})
			make("UICorner", alphaknob, { CornerRadius = UDim.new(0, 3) })
			make("UIStroke", alphaknob, { Color = Color3.fromRGB(0, 0, 0), Thickness = 1, Transparency = 0.4 })

			make("TextLabel", frame, {
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				TextSize = 10,
				TextColor3 = theme.SubText,
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.new(0, 10, 0, 168),
				Size = UDim2.new(0, 28, 0, 24),
				Text = "HEX",
			})
			local swatch = make("Frame", frame, {
				Position = UDim2.new(0, 40, 0, 172),
				Size = UDim2.new(0, 16, 0, 16),
				BackgroundColor3 = initial,
				BorderSizePixel = 0,
			})
			make("UICorner", swatch, { CornerRadius = UDim.new(0, 4) })
			local hexbox = make("TextBox", frame, {
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				Font = Enum.Font.GothamMedium,
				TextSize = 12,
				TextColor3 = theme.Text,
				PlaceholderColor3 = theme.Dim,
				PlaceholderText = "#RRGGBBAA",
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.new(0, 62, 0, 168),
				Size = UDim2.new(0, 94, 0, 24),
				Text = "",
			})
			local pct = make("TextLabel", frame, {
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamMedium,
				TextSize = 11,
				TextColor3 = theme.SubText,
				TextXAlignment = Enum.TextXAlignment.Right,
				Position = UDim2.new(1, -56, 0, 168),
				Size = UDim2.new(0, 46, 0, 24),
				Text = "100%",
			})

			local function currentcolor()
				return Color3.fromHSV(hue, sat, val)
			end

			local lastemit, emitpending = 0, false
			local function emit(final)
				local now = os.clock()
				if final or now - lastemit > 0.12 then
					lastemit = now
					emitpending = false
					pcall(onchange, currentcolor(), alpha, final == true)
				elseif not emitpending then
					emitpending = true
					task.delay(0.13, function()
						if emitpending and frame.Parent then
							emitpending = false
							lastemit = os.clock()
							pcall(onchange, currentcolor(), alpha, false)
						end
					end)
				end
			end

			local function refresh(fromhex)
				local color = currentcolor()
				square.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				sqknob.Position = UDim2.new(sat, 0, 1 - val, 0)
				hueknob.Position = UDim2.new(hue, 0, 0.5, 0)
				alphaknob.Position = UDim2.new(alpha, 0, 0.5, 0)
				alphafill.BackgroundColor3 = color
				swatch.BackgroundColor3 = color
				pct.Text = string.format("%d%%", math.floor(alpha * 100 + 0.5))
				if not fromhex then
					hexbox.Text = string.format(
						"#%02X%02X%02X%02X",
						math.floor(color.R * 255 + 0.5),
						math.floor(color.G * 255 + 0.5),
						math.floor(color.B * 255 + 0.5),
						math.floor(alpha * 255 + 0.5)
					)
				end
			end
			refresh()

			local dragging
			local function track(input)
				if dragging == "sv" then
					local pos, size = square.AbsolutePosition, square.AbsoluteSize
					sat = math.clamp((input.Position.X - pos.X) / math.max(size.X, 1), 0, 1)
					val = 1 - math.clamp((input.Position.Y - pos.Y) / math.max(size.Y, 1), 0, 1)
				elseif dragging == "hue" then
					local pos, size = huebar.AbsolutePosition, huebar.AbsoluteSize
					hue = math.clamp((input.Position.X - pos.X) / math.max(size.X, 1), 0, 1)
				elseif dragging == "alpha" then
					local pos, size = alphabase.AbsolutePosition, alphabase.AbsoluteSize
					alpha = math.clamp((input.Position.X - pos.X) / math.max(size.X, 1), 0, 1)
				else
					return
				end
				refresh()
				emit(false)
			end

			local function begin(target)
				return function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = target
						track(input)
					end
				end
			end
			square.InputBegan:Connect(begin("sv"))
			huebar.InputBegan:Connect(begin("hue"))
			alphabase.InputBegan:Connect(begin("alpha"))

			local movedconn = sv.uis.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					track(input)
				end
			end)
			local endedconn = sv.uis.InputEnded:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					dragging = nil
					emit(true)
				end
			end)
			pickerconns[#pickerconns + 1] = trackConnection(movedconn, "mx.picker.moved")
			pickerconns[#pickerconns + 1] = trackConnection(endedconn, "mx.picker.ended")

			hexbox.FocusLost:Connect(function()
				local text = hexbox.Text:gsub("%s", ""):gsub("^#", "")
				if (#text == 6 or #text == 8) and text:match("^%x+$") then
					local r = tonumber(text:sub(1, 2), 16)
					local g = tonumber(text:sub(3, 4), 16)
					local b = tonumber(text:sub(5, 6), 16)
					hue, sat, val = Color3.fromRGB(r, g, b):ToHSV()
					if #text == 8 then
						alpha = tonumber(text:sub(7, 8), 16) / 255
					end
					refresh()
					emit(true)
				else
					refresh()
				end
			end)
		end

		-- ------------------------------------------------ rows
		local langrow, langvalue = addrow(10, "globe", "Language")
		local scalerow, scalevalue = addrow(11, "maximize-2", "Menu Scale")
		local stylerow, stylevalue = addrow(12, "palette", "Style")
		local themerow, themevalue = addrow(13, "sun", "Theme")
		local keyrow, keyvalue = addrow(14, "keyboard", "Menu Key")
		local unloadrow = addrow(15, "power", "Unload", true)

		local styleswatch = make("Frame", stylerow, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -24, 0.5, 0),
			Size = UDim2.new(0, 14, 0, 14),
			BackgroundColor3 = theme.Accent,
			BorderSizePixel = 0,
		})
		make("UICorner", styleswatch, { CornerRadius = UDim.new(0, 4) })

		refreshvalues = function()
			langvalue.Text = i18n.Current
			local factor = tonumber(uistate.scale)
			scalevalue.Text = factor and (math.floor(factor * 100 + 0.5) .. "%") or "Auto"
			stylevalue.Text = ""
			themevalue.Text = theme.State.Mode
			keyvalue.Text = togglekey.Name
			pname.Text = username.Text
			prole.Text = handlelabel.Text
		end

		local capturing
		local function stopcapture()
			if capturing then
				capturing:Disconnect()
				capturing = nil
			end
		end
		local reserved = {
			[Enum.KeyCode.W] = true,
			[Enum.KeyCode.A] = true,
			[Enum.KeyCode.S] = true,
			[Enum.KeyCode.D] = true,
			[Enum.KeyCode.Space] = true,
			[Enum.KeyCode.Return] = true,
			[Enum.KeyCode.Slash] = true,
			[Enum.KeyCode.Tab] = true,
		}

		local function closeall()
			stopcapture()
			closepicker()
			sub.Visible = false
			catcher.Visible = false
			if popup.Visible then
				tw(popup, { Size = UDim2.new(0, PW, 0, 0) }, 0.15)
				task.delay(0.16, function()
					if not catcher.Visible then
						popup.Visible = false
					end
				end)
			end
		end

		langrow.Activated:Connect(function()
			local options = {}
			for _, name in ipairs(i18n.Languages) do
				options[#options + 1] = { label = name, value = name }
			end
			showoptions(langrow, options, i18n.Current, function(value)
				MXHUB.SetLanguage(value)
			end)
		end)

		scalerow.Activated:Connect(function()
			local options = {
				{ label = "Auto", value = "Auto" },
				{ label = "75%", value = "0.75" },
				{ label = "90%", value = "0.9" },
				{ label = "100%", value = "1" },
				{ label = "110%", value = "1.1" },
				{ label = "125%", value = "1.25" },
				{ label = "150%", value = "1.5" },
			}
			local current = uistate.scale
			if tonumber(current) then
				current = tostring(tonumber(current))
			end
			showoptions(scalerow, options, current, function(value)
				uistate.scale = value
				saveui()
				applyscale()
				refreshvalues()
			end)
		end)

		stylerow.Activated:Connect(function()
			local options = {}
			for _, accent in ipairs(theme.Api.Accents()) do
				options[#options + 1] = { label = accent[1], value = accent[1], color = accent[2] }
			end
			options[#options + 1] = { label = "Custom", value = "Custom", color = theme.Accent }
			showoptions(stylerow, options, "", function(value)
				if value == "Custom" then
					openpicker(theme.Accent, function(color, _, final)
						theme.Api.Set({ Accent = color }, not final)
						refreshvalues()
					end)
					return
				end
				for _, accent in ipairs(theme.Api.Accents()) do
					if accent[1] == value then
						theme.Api.Set({ Accent = accent[2] })
					end
				end
				refreshvalues()
			end)
		end)

		themerow.Activated:Connect(function()
			showoptions(
				themerow,
				{ { label = "Dark", value = "Dark" }, { label = "Light", value = "Light" } },
				theme.State.Mode,
				function(value)
					theme.Api.Set({ Mode = value })
					refreshvalues()
				end
			)
		end)

		keyrow.Activated:Connect(function()
			if capturing then
				stopcapture()
				refreshvalues()
				return
			end
			sub.Visible = false
			keyvalue.Text = "Press a key..."
			capturing = trackConnection(
				sv.uis.InputBegan:Connect(function(input)
					if input.UserInputType ~= Enum.UserInputType.Keyboard then
						return
					end
					stopcapture()
					local code = input.KeyCode
					if code == Enum.KeyCode.Escape or code == Enum.KeyCode.Unknown then
						refreshvalues()
						return
					end
					if reserved[code] then
						refreshvalues()
						return
					end
					togglekey = code
					uistate.menukey = code.Name
					saveui()
					refreshvalues()
				end),
				"mx.keycapture"
			)
		end)

		unloadrow.Activated:Connect(function()
			closeall()
			guifunc:DestroyGui()
		end)

		-- ------------------------------------------------ character preview (ViewportFrame, drag to rotate)
		-- ------------------------------------------------ open / close
		local function openpopup()
			refreshvalues()
			local scale = fitscaleof(main)
			local mainh = main.AbsoluteSize.Y / scale
			local mainw = main.AbsoluteSize.X / scale
			local height = math.clamp(math.min(300, mainh - 24), 120, 300)
			local x = math.clamp(POPX, 8, math.max(mainw - PW - 8, 8))
			SUBX = x + PW + 6
			popup.Position = UDim2.new(0, x, 1, -8)
			catcher.Visible = true
			popup.Size = UDim2.new(0, PW, 0, 0)
			popup.Visible = true
			tw(popup, { Size = UDim2.new(0, PW, 0, height) }, 0.2)
		end

		local footerhit = make("TextButton", userfooter, {
			Name = "ProfileButton",
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 6,
		})
		local footerarrow = make("ImageLabel", userfooter, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -6, 0.5, 0),
			Size = UDim2.new(0, 12, 0, 12),
			ImageColor3 = theme.SubText,
			ZIndex = 7,
		})
		applyicon(footerarrow, "chevron-right", 48)

		footerhit.Activated:Connect(function()
			if catcher.Visible then
				closeall()
			else
				openpopup()
			end
		end)
		catcher.Activated:Connect(closeall)
		trackConnection(
			dropshadowholder:GetPropertyChangedSignal("Visible"):Connect(function()
				if not dropshadowholder.Visible then
					closeall()
				end
			end),
			"mx.profile.hide"
		)

		refreshvalues()
	end

	function guifunc:ToggleUI()
		local screengui = instance.screengui(sv.coregui)
		screengui.Name = "ToggleUIButton"
		screengui.IgnoreGuiInset = true
		screengui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		local mainbutton = instance.imagelabel(screengui)
		mainbutton.Size = UDim2.new(0, guiconfig.ImageSize, 0, guiconfig.ImageSize)
		mainbutton.Position = UDim2.new(0, 20, 0, 100)
		mainbutton.BackgroundTransparency = 1
		local toggleIcon = userPassedToggle or (not bgAsset and userPassedImage) or assets.LogoId
		local toggleStr = resolveiconasset(toggleIcon) or assets.Logo
		mainbutton.Image = toggleStr
		mainbutton.ScaleType = Enum.ScaleType.Crop

		local uicorner = instance.uicorner(mainbutton)
		uicorner.CornerRadius = UDim.new(0, 6)

		local button = instance.textbutton(mainbutton)
		button.Size = UDim2.new(1, 0, 1, 0)
		button.BackgroundTransparency = 1
		button.Text = ""

		local MARGIN = 0
		local moved = false
		local dragging = false
		local dragstart, startpos, draginput

		local function clampbutton()
			local bounds = screengui.AbsoluteSize
			if bounds.X <= 0 or bounds.Y <= 0 then
				return
			end
			local size = tonumber(guiconfig.ImageSize) or 50
			local x = mainbutton.Position.X.Scale * bounds.X + mainbutton.Position.X.Offset
			local y = mainbutton.Position.Y.Scale * bounds.Y + mainbutton.Position.Y.Offset
			x = math.clamp(x, MARGIN, math.max(MARGIN, bounds.X - size - MARGIN))
			y = math.clamp(y, MARGIN, math.max(MARGIN, bounds.Y - size - MARGIN))
			mainbutton.Position = UDim2.fromOffset(x, y)
		end
		screengui:GetPropertyChangedSignal("AbsoluteSize"):Connect(clampbutton)
		task.defer(clampbutton)

		button.MouseButton1Click:Connect(function()

			if moved then
				return
			end
			if dropshadowholder then
				dropshadowholder.Visible = not dropshadowholder.Visible
			end
		end)

		button.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				moved = false
				if uilocked then
					return
				end
				dragging = true
				dragstart = input.Position
				startpos = mainbutton.Position
				draginput = input
			end
		end)

		trackConnection(
			sv.uis.InputChanged:Connect(function(input)
				if not dragging then
					return
				end
				if input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and input == draginput) then
					local delta = input.Position - dragstart
					if not moved and delta.Magnitude < 6 then
						return
					end
					moved = true
					mainbutton.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
					clampbutton()
				end
			end),
			"togglebutton.drag"
		)
		trackConnection(
			sv.uis.InputEnded:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input == draginput) then
					dragging = false
				end
			end),
			"togglebutton.drag.end"
		)
	end

	guifunc:ToggleUI()

	local tabs = {}
	local searchItems = {}
	local counttab = 0
	local lasttabcategory = nil
	local usertabcount, usertabnames, buildingsystem = 0, {}, true
	local countdropdown = 0
	local templates = {}

	local openfeatures, collectfeatures
	do
	local featurepanel = nil
	local kindicons = {
		Toggle = "toggle-right",
		Slider = "sliders-horizontal",
		Dropdown = "chevron-down",
		Keybind = "keyboard",
		Color = "palette",
		Button = "mouse-pointer-click",
	}

	function collectfeatures()
		local groups, byname, total = {}, {}, 0
		for _, d in ipairs(searchItems) do
			if d.Kind and d.TabName ~= "Home" and d.TabName ~= "Config" and d.TabName ~= "Settings" and d.Object and d.Object.Parent then
				local g = byname[d.TabName]
				if not g then
					g = { Name = d.TabName, Items = {} }
					byname[d.TabName] = g
					groups[#groups + 1] = g
				end
				g.Items[#g.Items + 1] = d
				total = total + 1
			end
		end
		return groups, total
	end

	function openfeatures()
		if featurepanel and featurepanel.Parent then
			return
		end
		local groups, total = collectfeatures()

		local overlay = instance.frame(dropshadowholder)
		overlay.Name = "FeaturesOverlay"
		overlay.Size = UDim2.new(1, 0, 1, 0)
		overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		overlay.BackgroundTransparency = 0.45
		overlay.BorderSizePixel = 0
		overlay.ZIndex = 50
		instance.uicorner(overlay).CornerRadius = UDim.new(0, 8)
		featurepanel = overlay

		local function closepanel()
			if overlay.Parent then
				overlay:Destroy()
			end
			featurepanel = nil
		end

		local backdrop = instance.textbutton(overlay)
		backdrop.BackgroundTransparency = 1
		backdrop.Text = ""
		backdrop.Size = UDim2.new(1, 0, 1, 0)
		backdrop.AutoButtonColor = false
		backdrop.Activated:Connect(closepanel)

		local card = instance.frame(overlay)
		card.Name = "FeaturesCard"
		card.AnchorPoint = Vector2.new(0.5, 0.5)
		card.Position = UDim2.new(0.5, 0, 0.5, 0)
		card.Size = UDim2.new(0.74, 0, 0.94, 0)
		card.BackgroundColor3 = theme.Card
		card.BorderSizePixel = 0
		card.Active = true
		instance.uicorner(card).CornerRadius = UDim.new(0, 14)
		local cardstroke = instance.uistroke(card)
		cardstroke.Color = theme.Stroke
		cardstroke.Thickness = 1
		local limit = instance.uisizeconstraint(card)
		limit.MaxSize = Vector2.new(520, 100000)

		local headicon = instance.imagelabel(card)
		headicon.BackgroundTransparency = 1
		headicon.Position = UDim2.new(0, 16, 0, 14)
		headicon.Size = UDim2.new(0, 18, 0, 18)
		headicon.ImageColor3 = theme.Text
		applyicon(headicon, "list-checks", 48)

		local headtitle = instance.textlabel(card)
		headtitle.BackgroundTransparency = 1
		headtitle.Position = UDim2.new(0, 44, 0, 10)
		headtitle.Size = UDim2.new(1, -90, 0, 16)
		headtitle.Font = Enum.Font.GothamBold
		headtitle.Text = "Features"
		headtitle.TextColor3 = theme.Text
		headtitle.TextSize = 14
		headtitle.TextXAlignment = Enum.TextXAlignment.Left

		local headsub = instance.textlabel(card)
		headsub.BackgroundTransparency = 1
		headsub.Position = UDim2.new(0, 44, 0, 27)
		headsub.Size = UDim2.new(1, -90, 0, 13)
		headsub.Font = Enum.Font.Gotham
		headsub.Text = string.format("%d features across %d tabs", total, #groups)
		headsub.TextColor3 = theme.SubText
		headsub.TextSize = 11
		headsub.TextXAlignment = Enum.TextXAlignment.Left

		local closebtn = instance.textbutton(card)
		closebtn.AnchorPoint = Vector2.new(1, 0)
		closebtn.Position = UDim2.new(1, -12, 0, 10)
		closebtn.Size = UDim2.new(0, 28, 0, 28)
		closebtn.BackgroundTransparency = 1
		closebtn.Text = ""
		closebtn.AutoButtonColor = false
		instance.uicorner(closebtn).CornerRadius = UDim.new(1, 0)
		local closeimg = instance.imagelabel(closebtn)
		closeimg.AnchorPoint = Vector2.new(0.5, 0.5)
		closeimg.Position = UDim2.new(0.5, 0, 0.5, 0)
		closeimg.Size = UDim2.new(0, 14, 0, 14)
		closeimg.BackgroundTransparency = 1
		closeimg.ImageColor3 = theme.SubText
		applyicon(closeimg, "x", 48)
		closebtn.MouseEnter:Connect(function()
			tw(closebtn, { BackgroundTransparency = 0, BackgroundColor3 = theme.Element }, 0.15)
		end)
		closebtn.MouseLeave:Connect(function()
			tw(closebtn, { BackgroundTransparency = 1 }, 0.15)
		end)
		closebtn.Activated:Connect(closepanel)

		local box = instance.textbox(card)
		box.Position = UDim2.new(0, 14, 0, 50)
		box.Size = UDim2.new(1, -28, 0, 30)
		box.BackgroundColor3 = theme.Pill
		box.BorderSizePixel = 0
		box.Font = Enum.Font.Gotham
		box.PlaceholderText = "Search features"
		box.PlaceholderColor3 = theme.Dim
		box.Text = ""
		box.TextColor3 = theme.Text
		box.TextSize = 12
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.ClearTextOnFocus = false
		box.ClipsDescendants = true
		instance.uicorner(box).CornerRadius = UDim.new(1, 0)
		local boxstroke = instance.uistroke(box)
		boxstroke.Color = theme.Stroke
		boxstroke.Transparency = 0.35
		local boxpad = instance.uipadding(box)
		boxpad.PaddingLeft = UDim.new(0, 32)
		boxpad.PaddingRight = UDim.new(0, 12)
		local boxicon = instance.imagelabel(box)
		boxicon.AnchorPoint = Vector2.new(0, 0.5)
		boxicon.Position = UDim2.new(0, -20, 0.5, 0)
		boxicon.Size = UDim2.new(0, 13, 0, 13)
		boxicon.BackgroundTransparency = 1
		boxicon.ImageColor3 = theme.Dim
		applyicon(boxicon, "search", 48)

		local list = instance.scrollingframe(card)
		list.Position = UDim2.new(0, 10, 0, 90)
		list.Size = UDim2.new(1, -20, 1, -98)
		list.BackgroundTransparency = 1
		list.BorderSizePixel = 0
		list.ScrollBarThickness = 3
		list.ScrollBarImageColor3 = theme.Track
		list.CanvasSize = UDim2.new(0, 0, 0, 0)
		list.AutomaticCanvasSize = Enum.AutomaticSize.Y
		list.ScrollingDirection = Enum.ScrollingDirection.Y
		local listlayout = instance.uilistlayout(list)
		listlayout.SortOrder = Enum.SortOrder.LayoutOrder
		listlayout.Padding = UDim.new(0, 1)
		local listpad = instance.uipadding(list)
		listpad.PaddingRight = UDim.new(0, 6)

		local function jumpto(d)
			closepanel()
			task.spawn(function()
				pcall(d.Select)
				pcall(d.OpenSection)
				task.wait(0.4)
				pcall(function()
					local scr, obj = d.Scroll, d.Object
					if scr and obj and obj.Parent then
						local y = (obj.AbsolutePosition.Y - scr.AbsolutePosition.Y) / fitscaleof(scr) + scr.CanvasPosition.Y - 8
						scr.CanvasPosition = Vector2.new(0, math.max(0, y))
					end
				end)
			end)
		end

		local order = 0
		local rows, headers = {}, {}
		for _, g in ipairs(groups) do
			order = order + 1
			local head = instance.frame(list)
			head.BackgroundTransparency = 1
			head.BorderSizePixel = 0
			head.LayoutOrder = order
			head.Size = UDim2.new(1, 0, 0, 34)
			local ring = instance.frame(head)
			ring.AnchorPoint = Vector2.new(0, 0.5)
			ring.Position = UDim2.new(0, 14, 0.5, 4)
			ring.Size = UDim2.new(0, 14, 0, 14)
			ring.BackgroundTransparency = 1
			instance.uicorner(ring).CornerRadius = UDim.new(1, 0)
			local ringstroke = instance.uistroke(ring)
			ringstroke.Color = theme.Text
			ringstroke.Thickness = 1.5
			local gname = instance.textlabel(head)
			gname.BackgroundTransparency = 1
			gname.Position = UDim2.new(0, 38, 0, 6)
			gname.Size = UDim2.new(1, -90, 1, -6)
			gname.Font = Enum.Font.GothamMedium
			gname.Text = string.upper(g.Name)
			gname.TextColor3 = theme.Text
			gname.TextSize = 11
			gname.TextXAlignment = Enum.TextXAlignment.Left
			local gcount = instance.textlabel(head)
			gcount.AnchorPoint = Vector2.new(1, 0)
			gcount.BackgroundTransparency = 1
			gcount.Position = UDim2.new(1, -12, 0, 6)
			gcount.Size = UDim2.new(0, 40, 1, -6)
			gcount.Font = Enum.Font.GothamMedium
			gcount.Text = tostring(#g.Items)
			gcount.TextColor3 = theme.SubText
			gcount.TextSize = 11
			gcount.TextXAlignment = Enum.TextXAlignment.Right
			local group = { Frame = head, Rows = {} }
			headers[#headers + 1] = group

			for _, d in ipairs(g.Items) do
				order = order + 1
				local row = instance.textbutton(list)
				row.LayoutOrder = order
				row.Size = UDim2.new(1, 0, 0, 42)
				row.BackgroundColor3 = theme.Element
				row.BackgroundTransparency = 1
				row.BorderSizePixel = 0
				row.Text = ""
				row.AutoButtonColor = false
				instance.uicorner(row).CornerRadius = UDim.new(0, 8)
				local ricon = instance.imagelabel(row)
				ricon.AnchorPoint = Vector2.new(0, 0.5)
				ricon.Position = UDim2.new(0, 14, 0.5, 0)
				ricon.Size = UDim2.new(0, 15, 0, 15)
				ricon.BackgroundTransparency = 1
				ricon.ImageColor3 = theme.SubText
				applyicon(ricon, kindicons[d.Kind], 48)
				local rname = instance.textlabel(row)
				rname.BackgroundTransparency = 1
				rname.Position = UDim2.new(0, 42, 0, 6)
				rname.Size = UDim2.new(1, -90, 0, 15)
				rname.Font = Enum.Font.GothamMedium
				rname.Text = d.Name
				rname.TextColor3 = theme.Text
				rname.TextSize = 12
				rname.TextXAlignment = Enum.TextXAlignment.Left
				rname.TextTruncate = Enum.TextTruncate.AtEnd
				local rsub = instance.textlabel(row)
				rsub.BackgroundTransparency = 1
				rsub.Position = UDim2.new(0, 42, 0, 22)
				rsub.Size = UDim2.new(1, -90, 0, 13)
				rsub.Font = Enum.Font.Gotham
				rsub.Text = tostring(d.SectionName or "")
				rsub.TextColor3 = theme.SubText
				rsub.TextSize = 11
				rsub.TextXAlignment = Enum.TextXAlignment.Left
				rsub.TextTruncate = Enum.TextTruncate.AtEnd
				local arrow = instance.imagelabel(row)
				arrow.AnchorPoint = Vector2.new(1, 0.5)
				arrow.Position = UDim2.new(1, -14, 0.5, 0)
				arrow.Size = UDim2.new(0, 12, 0, 12)
				arrow.BackgroundTransparency = 1
				arrow.ImageColor3 = theme.Dim
				applyicon(arrow, "arrow-up-right", 48)
				row.MouseEnter:Connect(function()
					tw(row, { BackgroundTransparency = 0 }, 0.12)
				end)
				row.MouseLeave:Connect(function()
					tw(row, { BackgroundTransparency = 1 }, 0.15)
				end)
				row.Activated:Connect(function()
					jumpto(d)
				end)
				local rec = {
					Frame = row,
					Text = string.lower(d.Name .. " " .. tostring(d.SectionName or "") .. " " .. tostring(d.TabName or "")),
				}
				rows[#rows + 1] = rec
				group.Rows[#group.Rows + 1] = rec
			end
		end

		box:GetPropertyChangedSignal("Text"):Connect(function()
			local q = string.lower(box.Text)
			for _, rec in ipairs(rows) do
				rec.Frame.Visible = q == "" or string.find(rec.Text, q, 1, true) ~= nil
			end
			for _, group in ipairs(headers) do
				local any = false
				for _, rec in ipairs(group.Rows) do
					if rec.Frame.Visible then
						any = true
						break
					end
				end
				group.Frame.Visible = any
			end
		end)
	end
	end

	do
		local t = instance.frame(nil)
		t.Name = "Toggle"
		t.BorderSizePixel = 0
		t.Size = UDim2.new(1, 0, 0, isMobile and 44 or 38)
		roundbg(t, 4, theme.Row)

		local ttitle = instance.textlabel(t)
		ttitle.Name = "ToggleTitle"
		ttitle.Font = Enum.Font.GothamMedium
		ttitle.TextSize = 12
		ttitle.TextColor3 = theme.Text
		ttitle.TextXAlignment = Enum.TextXAlignment.Left
		ttitle.TextYAlignment = Enum.TextYAlignment.Top
		ttitle.BackgroundTransparency = 1
		ttitle.Position = UDim2.new(0, 10, 0, 13)
		ttitle.Size = UDim2.new(1, -100, 0, 13)
		ttitle.TextTruncate = Enum.TextTruncate.AtEnd

		local tbutton = instance.textbutton(t)
		tbutton.Name = "ToggleButton"
		tbutton.Font = Enum.Font.SourceSans
		tbutton.Text = ""
		tbutton.BackgroundTransparency = 1
		tbutton.Size = UDim2.new(1, 0, 1, 0)

		local tfeature = instance.frame(t)
		tfeature.Name = "FeatureFrame"
		tfeature.AnchorPoint = Vector2.new(1, 0.5)
		tfeature.BackgroundColor3 = theme.Field
		tfeature.BackgroundTransparency = 0
		tfeature.BorderSizePixel = 0
		tfeature.Position = UDim2.new(1, -12, 0.5, 0)
		tfeature.Size = isMobile and UDim2.new(0, 40, 0, 22) or UDim2.new(0, 32, 0, 16)
		instance.uicorner(tfeature)

		local tstroke = instance.uistroke(tfeature)
		tstroke.Color = Color3.fromRGB(255, 255, 255)
		tstroke.Thickness = 1.5
		tstroke.Transparency = 0.9

		local tcircle = instance.frame(tfeature)
		tcircle.Name = "ToggleCircle"
		tcircle.BackgroundColor3 = theme.Text
		tcircle.BorderSizePixel = 0
		tcircle.Position = isMobile and UDim2.new(0, 3, 0, 3) or UDim2.new(0, 2, 0, 2)
		tcircle.Size = isMobile and UDim2.new(0, 16, 0, 16) or UDim2.new(0, 12, 0, 12)
		instance.uicorner(tcircle).CornerRadius = UDim.new(0, 12)

		templates.Toggle = t
	end

	do
		local s = instance.frame(nil)
		s.Name = "Slider"
		s.BorderSizePixel = 0
		s.Size = UDim2.new(1, 0, 0, 58)
		roundbg(s, 4, theme.Row)

		local stitle = instance.textlabel(s)
		stitle.Name = "SliderTitle"
		stitle.Font = Enum.Font.GothamMedium
		stitle.TextColor3 = theme.Text
		stitle.TextSize = 12
		stitle.TextXAlignment = Enum.TextXAlignment.Left
		stitle.TextYAlignment = Enum.TextYAlignment.Center
		stitle.BackgroundTransparency = 1
		stitle.Position = UDim2.new(0, 10, 0, 7)
		stitle.Size = UDim2.new(1, -58, 0, 20)
		stitle.TextTruncate = Enum.TextTruncate.AtEnd

		local sholder = instance.frame(s)
		sholder.Name = "SliderInputHolder"
		sholder.AnchorPoint = Vector2.new(1, 0)
		sholder.Position = UDim2.new(1, -10, 0, 7)
		sholder.Size = UDim2.new(0, 32, 0, 20)
		roundbg(sholder, 4, theme.Field)

		local sinput = instance.textbox(sholder)
		sinput.Name = "SliderInput"
		sinput.Font = Enum.Font.GothamMedium
		sinput.Text = ""
		sinput.TextColor3 = Color3.fromRGB(255, 255, 255)
		sinput.TextSize = 11
		sinput.TextScaled = true
		sinput.TextXAlignment = Enum.TextXAlignment.Center
		sinput.TextYAlignment = Enum.TextYAlignment.Center
		sinput.BackgroundTransparency = 1
		sinput.ClearTextOnFocus = false
		sinput.Size = UDim2.new(1, -6, 1, 0)
		sinput.Position = UDim2.new(0, 3, 0, 0)

		local sinputconstraint = instance.uitextsizeconstraint(sinput)
		sinputconstraint.MinTextSize = 7
		sinputconstraint.MaxTextSize = 11

		local sbar = instance.frame(s)
		sbar.Name = "SliderBar"
		sbar.BackgroundColor3 = theme.Bar
		sbar.BackgroundTransparency = 0
		sbar.Position = UDim2.new(0, 10, 0, 39)
		sbar.Size = UDim2.new(1, -20, 0, 5)
		sbar.Active = true
		instance.uicorner(sbar).CornerRadius = UDim.new(1, 0)

		local sfill = instance.frame(sbar)
		sfill.Name = "SliderFill"
		sfill.BackgroundColor3 = theme.SliderFill
		sfill.BorderSizePixel = 0
		sfill.Size = UDim2.new(0, 0, 1, 0)
		instance.uicorner(sfill).CornerRadius = UDim.new(1, 0)

		local scircle = instance.frame(sbar)
		scircle.Name = "SliderCircle"
		scircle.AnchorPoint = Vector2.new(0.5, 0.5)
		scircle.BackgroundColor3 = theme.SliderFill
		scircle.Position = UDim2.new(0, 0, 0.5, 0)
		scircle.Size = UDim2.new(0, 12, 0, 12)
		scircle.Active = true
		scircle.ZIndex = 4
		instance.uicorner(scircle).CornerRadius = UDim.new(1, 0)

		local scirclestroke = instance.uistroke(scircle)
		scirclestroke.Color = Color3.fromRGB(255, 255, 255)
		scirclestroke.Transparency = 0.45
		scirclestroke.Thickness = 1

		local sbubble = instance.frame(sbar)
		sbubble.Name = "ValueBubble"
		sbubble.AnchorPoint = Vector2.new(0.5, 1)
		sbubble.BackgroundColor3 = theme.Element
		sbubble.BackgroundTransparency = 0
		sbubble.Position = UDim2.new(0, 0, 0, -10)
		sbubble.Size = UDim2.new(0, 48, 0, 22)
		sbubble.Visible = false
		sbubble.ZIndex = 20
		instance.uicorner(sbubble).CornerRadius = UDim.new(0, 5)

		local sbubbletext = instance.textlabel(sbubble)
		sbubbletext.Name = "BubbleText"
		sbubbletext.BackgroundTransparency = 1
		sbubbletext.Size = UDim2.new(1, -6, 1, 0)
		sbubbletext.Position = UDim2.new(0, 3, 0, 0)
		sbubbletext.Font = Enum.Font.GothamBold
		sbubbletext.TextColor3 = Color3.fromRGB(255, 255, 255)
		sbubbletext.TextSize = 11
		sbubbletext.TextScaled = true
		sbubbletext.TextXAlignment = Enum.TextXAlignment.Center
		sbubbletext.TextYAlignment = Enum.TextYAlignment.Center
		sbubbletext.ZIndex = 21

		local sbubbleconstraint = instance.uitextsizeconstraint(sbubbletext)
		sbubbleconstraint.MinTextSize = 7
		sbubbleconstraint.MaxTextSize = 11

		templates.Slider = s
	end

	do
		local o = instance.frame(nil)
		o.Name = "Option"
		o.Size = UDim2.new(1, 0, 0, 30)
		roundbg(o, 3, theme.Option).ImageTransparency = 1

		local obutton = instance.textbutton(o)
		obutton.Name = "OptionButton"
		obutton.BackgroundTransparency = 1
		obutton.Size = UDim2.new(1, 0, 1, 0)
		obutton.Text = ""

		local otext = instance.textlabel(o)
		otext.Name = "OptionText"
		otext.Font = Enum.Font.GothamBold
		otext.TextSize = 13
		otext.TextColor3 = theme.Text
		otext.BackgroundTransparency = 1
		otext.TextXAlignment = Enum.TextXAlignment.Left
		otext.TextTruncate = Enum.TextTruncate.AtEnd

		local ochoose = instance.frame(o)
		ochoose.Name = "ChooseFrame"
		ochoose.AnchorPoint = Vector2.new(0, 0.5)
		ochoose.BackgroundColor3 = guiconfig.Color
		ochoose.Position = UDim2.new(0, 2, 0.5, 0)
		ochoose.Size = UDim2.new(0, 0, 0, 0)

		local ochoosestroke = instance.uistroke(ochoose)
		ochoosestroke.Color = guiconfig.Color
		ochoosestroke.Thickness = 1.6
		ochoosestroke.Transparency = 1
		instance.uicorner(ochoose)

		templates.DropdownOption = o
	end

	dropshadowholder.Size = UDim2.new(0, 115 + textlabel.TextBounds.X + 1 + textlabel1.TextBounds.X, 0, 350)
	if isMobile then
		draggable.mobilex = math.max(420, tonumber(guiconfig.MobileWidth) or draggable.mobilex)
		draggable.mobiley = math.max(260, tonumber(guiconfig.MobileHeight) or draggable.mobiley)
	else

		draggable.defx = math.max(420, tonumber(guiconfig.Width) or draggable.defx)
		draggable.defy = math.max(260, tonumber(guiconfig.Height) or draggable.defy)
	end
	makedraggable(top, dropshadowholder)

	local moreblur = instance.frame(layers)
	moreblur.Name = "MoreBlur"
	moreblur.AnchorPoint = Vector2.new(1, 1)
	moreblur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	moreblur.BackgroundTransparency = 1
	moreblur.BorderColor3 = Color3.fromRGB(0, 0, 0)
	moreblur.BorderSizePixel = 0
	moreblur.ClipsDescendants = true
	moreblur.Position = UDim2.new(1, 8, 1, 8)
	moreblur.Size = UDim2.new(1, 154, 1, 54)
	moreblur.Visible = false

	local uicorner28 = instance.uicorner(moreblur)

	local connectbutton = instance.textbutton(moreblur)
	connectbutton.Name = "ConnectButton"
	connectbutton.Font = Enum.Font.SourceSans
	connectbutton.Text = ""
	connectbutton.TextColor3 = Color3.fromRGB(0, 0, 0)
	connectbutton.TextSize = 14
	connectbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	connectbutton.BackgroundTransparency = 1
	connectbutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	connectbutton.BorderSizePixel = 0
	connectbutton.Size = UDim2.new(1, 0, 1, 0)

	local dropdownselect = instance.frame(moreblur)
	dropdownselect.Name = "DropdownSelect"
	dropdownselect.AnchorPoint = Vector2.new(0, 0)
	dropdownselect.BackgroundColor3 = theme.Element
	dropdownselect.BackgroundTransparency = 0
	dropdownselect.BorderColor3 = Color3.fromRGB(0, 0, 0)
	dropdownselect.BorderSizePixel = 0
	dropdownselect.LayoutOrder = 1
	dropdownselect.Position = UDim2.new(0, 0, 0, 0)
	dropdownselect.Size = UDim2.new(0, 160, 0, 0)
	dropdownselect.ClipsDescendants = true

	local uicorner36 = instance.uicorner(dropdownselect)
	uicorner36.CornerRadius = UDim.new(0, 3)

	local uistroke14 = instance.uistroke(dropdownselect)
	uistroke14.Color = theme.Stroke
	uistroke14.Thickness = 2.5
	uistroke14.Transparency = 0.8

	local dropdownselectreal = instance.frame(dropdownselect)
	dropdownselectreal.Name = "DropdownSelectReal"
	dropdownselectreal.AnchorPoint = Vector2.new(0.5, 0.5)
	dropdownselectreal.BackgroundColor3 = theme.Card
	dropdownselectreal.BackgroundTransparency = 0
	dropdownselectreal.BorderColor3 = Color3.fromRGB(0, 0, 0)
	dropdownselectreal.BorderSizePixel = 0
	dropdownselectreal.LayoutOrder = 1
	dropdownselectreal.Position = UDim2.new(0.5, 0, 0.5, 0)
	dropdownselectreal.Size = UDim2.new(1, 1, 1, 1)

	local dropdownfolder = instance.folder(dropdownselectreal)
	dropdownfolder.Name = "DropdownFolder"

	local droppagelayout = instance.uipagelayout(dropdownfolder)
	droppagelayout.Name = "DropPageLayout"
	droppagelayout.EasingDirection = Enum.EasingDirection.InOut
	droppagelayout.EasingStyle = Enum.EasingStyle.Quad
	droppagelayout.TweenTime = 0.01
	droppagelayout.SortOrder = Enum.SortOrder.LayoutOrder
	droppagelayout.FillDirection = Enum.FillDirection.Vertical
	droppagelayout.Archivable = false

	local popuptoken = 0

	local POPUP_GAP = 4
	local POPUP_MARGIN = 6
	local POPUP_MAXH = isMobile and 240 or 210
	local popupinfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local popup = { open = false, anchor = nil, contenth = 0, settle = 0, conn = nil, scroller = nil, arrow = nil }
	local arrowinfo = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

	local function turnarrow(arrow, open)
		if arrow and arrow.Parent then
			sv.ts:Create(arrow, arrowinfo, { Rotation = open and 180 or 0 }):Play()
		end
	end

	local function popupscale()
		return fitscaleof(moreblur)
	end

	local function popupgeometry()
		local scale = popupscale()
		local origin = moreblur.AbsolutePosition
		local anchor = popup.anchor
		local ax = (anchor.AbsolutePosition.X - origin.X) / scale
		local ay = (anchor.AbsolutePosition.Y - origin.Y) / scale
		local aw = anchor.AbsoluteSize.X / scale
		local ah = anchor.AbsoluteSize.Y / scale

		local areaLeft = (layers.AbsolutePosition.X - origin.X) / scale
		local areaTop = (layers.AbsolutePosition.Y - origin.Y) / scale
		local areaRight = areaLeft + layers.AbsoluteSize.X / scale
		local areaBottom = areaTop + layers.AbsoluteSize.Y / scale

		local want = math.min(popup.contenth, POPUP_MAXH)
		local below = areaBottom - (ay + ah + POPUP_GAP) - POPUP_MARGIN
		local above = (ay - POPUP_GAP) - areaTop - POPUP_MARGIN
		local goup = want > below and above > below
		local height = math.max(40, math.min(want, goup and above or below))

		local maxwidth = math.max(areaRight - areaLeft - POPUP_MARGIN * 2, 60)
		local width = math.min(math.max(aw, 120), maxwidth)
		local x = math.clamp(ax, areaLeft + POPUP_MARGIN, math.max(areaLeft + POPUP_MARGIN, areaRight - POPUP_MARGIN - width))
		return x, goup and (ay - POPUP_GAP) or (ay + ah + POPUP_GAP), width, height, goup
	end

	local function popupapply(withsize)
		local x, y, width, height, goup = popupgeometry()
		dropdownselect.AnchorPoint = Vector2.new(0, goup and 1 or 0)
		dropdownselect.Position = UDim2.fromOffset(x, y)
		if withsize then
			dropdownselect.Size = UDim2.fromOffset(width, height)
		end
		return width, height
	end

	local function popupunlock()
		if popup.scroller then
			popup.scroller.ScrollingEnabled = true
			popup.scroller = nil
		end
		if popup.conn then
			popup.conn:Disconnect()
			popup.conn = nil
		end
	end

	local function closedropdownpopup()
		if not popup.open then
			return
		end
		popup.open = false
		popup.anchor = nil
		turnarrow(popup.arrow, false)
		popup.arrow = nil
		popupunlock()
		popuptoken = popuptoken + 1
		local token = popuptoken
		sv.ts:Create(dropdownselect, popupinfo, { Size = UDim2.fromOffset(dropdownselect.AbsoluteSize.X / popupscale(), 0) }):Play()
		task.delay(0.18, function()
			if popuptoken == token then
				moreblur.Visible = false
			end
		end)
	end

	local function opendropdownpopup(index, anchor, contenth, arrow)
		popuptoken = popuptoken + 1
		popupunlock()
		if popup.arrow and popup.arrow ~= arrow then
			turnarrow(popup.arrow, false)
		end
		popup.arrow = arrow
		turnarrow(arrow, true)
		droppagelayout:JumpToIndex(index)

		popup.open = true
		popup.anchor = anchor
		popup.contenth = contenth
		moreblur.Visible = true

		local width, height = popupapply(false)
		dropdownselect.Size = UDim2.fromOffset(width, 0)
		popup.settle = os.clock() + 0.2
		sv.ts:Create(dropdownselect, popupinfo, { Size = UDim2.fromOffset(width, height) }):Play()

		local scroller = anchor:FindFirstAncestorWhichIsA("ScrollingFrame")
		if scroller and scroller.ScrollingEnabled then
			popup.scroller = scroller
			scroller.ScrollingEnabled = false
		end

		popup.conn = game:GetService("RunService").RenderStepped:Connect(function()
			local field = popup.anchor
			if not popup.open or not field or not field:IsDescendantOf(layers) then
				closedropdownpopup()
				return
			end
			local box = popup.scroller
			if box then
				local centre = field.AbsolutePosition + field.AbsoluteSize / 2
				local from, size = box.AbsolutePosition, box.AbsoluteSize
				if centre.X < from.X or centre.Y < from.Y or centre.X > from.X + size.X or centre.Y > from.Y + size.Y then
					closedropdownpopup()
					return
				end
			end
			popupapply(os.clock() >= popup.settle)
		end)
	end

	local function refitdropdownpopup(anchor, contenth)
		if not popup.open or popup.anchor ~= anchor then
			return
		end
		popup.contenth = contenth
		local _, _, width, height = popupgeometry()
		popup.settle = os.clock() + 0.2
		sv.ts:Create(dropdownselect, popupinfo, { Size = UDim2.fromOffset(width, height) }):Play()
	end

	connectbutton.Activated:Connect(closedropdownpopup)

	local searchopened = {}

	local function runsearch()
		local query = string.lower(searchbox.Text or "")
		local current = layerspagelayout.CurrentPage
		local seen = {}

		if query == "" then
			for section, closefn in pairs(searchopened) do
				pcall(closefn)
			end
			searchopened = {}
		end

		for _, data in ipairs(searchItems) do
			if query == "" or data.Page == current then
				local match = query == ""
					or string.find(string.lower(data.Name), query, 1, true) ~= nil
					or string.find(string.lower(data.Path), query, 1, true) ~= nil
				if data.Object then
					data.Object.Visible = match
				end
				if data.Section then
					local state = seen[data.Section]
					if not state then
						state = { any = false, open = data.OpenSection, close = data.CloseSection, isopen = data.IsOpen }
						seen[data.Section] = state
					end
					if match then
						state.any = true
					end
				end
			end
		end

		for section, state in pairs(seen) do
			section.Visible = query == "" or state.any
			if query ~= "" and state.any and state.open then
				local wasopen = state.isopen and state.isopen()
				if not wasopen then
					searchopened[section] = state.close
					pcall(state.open)
				end
			end
		end
	end

	searchbox:GetPropertyChangedSignal("Text"):Connect(function()
		debounceResize("search", runsearch, 0.05)
	end)

	local usedkeys = {}

	local function keyfor(prefix, elementconfig)
		local key = prefix .. tostring(elementconfig.Flag or elementconfig.Title)
		if usedkeys[key] then
			warn(string.format("[MX HUB] Duplicate config key %q: these elements share one saved value. Give one of them a unique Flag.", key))
		end
		usedkeys[key] = true
		return key
	end

	local CONTENT_FONT = Enum.Font.Gotham
	local CONTENT_SIZE = 12

	local function contenttext(elementconfig)
		local text = elementconfig.Content or elementconfig.Desc or elementconfig.Description
		if text == nil then
			return nil
		end
		text = tostring(text)
		if text:gsub("%s+", "") == "" then
			return nil
		end
		return text
	end

	local function attachcontent(row, text, x, y, rightinset)
		local label = instance.textlabel(row)
		label.Name = "Content"
		label.BackgroundTransparency = 1
		label.Font = CONTENT_FONT
		label.RichText = true
		label.Text = text
		label.TextColor3 = theme.SubText
		label.TextSize = CONTENT_SIZE
		label.TextWrapped = true
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.Position = UDim2.new(0, x, 0, y)
		label.Size = UDim2.new(1, -(x + rightinset), 0, CONTENT_SIZE)
		local function measure()
			local width = row.AbsoluteSize.X / fitscaleof(row)
			if width <= 1 then
				width = layers.AbsoluteSize.X / fitscaleof(layers)
			end
			if width <= 1 then
				width = 440
			end
			local height = textheight(text, CONTENT_SIZE, CONTENT_FONT, width - x - rightinset, 400)
			label.Size = UDim2.new(1, -(x + rightinset), 0, height)
			return height
		end
		return label, measure
	end

	local ICONSLOT = 22

	local function elementiconx(cfg)
		return (cfg and hasimage(cfg.Icon)) and (10 + ICONSLOT) or 10
	end

	local function elementicon(row, value, center)
		local slot = { shifted = hasimage(value) }

		function slot.SetColor(color)
			if slot.image and typeof(color) == "Color3" then
				slot.image.ImageColor3 = color
			end
		end

		function slot.Set(newvalue)
			local has = hasimage(newvalue)
			if has and not slot.image then
				local img = instance.imagelabel(row)
				img.Name = "ElementIcon"
				img.BackgroundTransparency = 1
				img.AnchorPoint = Vector2.new(0, 0.5)
				img.Position = UDim2.new(0, 10, 0, center)
				img.Size = UDim2.new(0, 14, 0, 14)
				img.ImageColor3 = theme.SubText
				slot.image = img
			end
			if slot.image then
				slot.image.Visible = has
				if has then
					applyicon(slot.image, newvalue, 48)
				end
			end
			if has ~= slot.shifted then
				slot.shifted = has
				local delta = has and ICONSLOT or -ICONSLOT
				local from = has and 10 or (10 + ICONSLOT)
				for _, child in ipairs(row:GetChildren()) do
					if child:IsA("TextLabel") then
						local pos, size = child.Position, child.Size
						if pos.X.Scale == 0 and pos.X.Offset == from then
							child.Position = UDim2.new(0, pos.X.Offset + delta, pos.Y.Scale, pos.Y.Offset)
							child.Size = UDim2.new(size.X.Scale, size.X.Offset - delta, size.Y.Scale, size.Y.Offset)
						end
					end
				end
			end
		end

		slot.Set(value)
		return slot
	end

	local function iconapi(func, slot)
		function func:SetIcon(value)
			slot.Set(value)
		end
		function func:SetIconColor(color)
			slot.SetColor(color)
		end
	end

	local function watchwidth(row, relayout)
		local lastwidth = -1
		local queued = false
		row:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			local width = math.floor(row.AbsoluteSize.X + 0.5)
			if width == lastwidth or width <= 1 or queued then
				return
			end
			lastwidth = width
			queued = true
			task.defer(function()
				queued = false
				relayout()
			end)
		end)
	end

	local hasActiveTab = false

	function tabs:AddHeaderChip(chipconfig)
		if type(chipconfig) ~= "table" then
			chipconfig = { Text = tostring(chipconfig or "") }
		end
		local holder = top:FindFirstChild("Chips")
		if not holder then
			return nil
		end

		local chip = instance.frame(holder)
		chip.Name = "Chip"
		chip.LayoutOrder = tonumber(chipconfig.LayoutOrder) or #holder:GetChildren()
		chip.BackgroundColor3 = theme.Pill
		chip.BackgroundTransparency = 0.15
		chip.BorderSizePixel = 0
		chip.Size = UDim2.new(0, 0, 0, 22)
		chip.AutomaticSize = Enum.AutomaticSize.X
		instance.uicorner(chip).CornerRadius = UDim.new(1, 0)

		local chipstroke = instance.uistroke(chip)
		chipstroke.Color = theme.Stroke
		chipstroke.Thickness = 1
		chipstroke.Transparency = 0.35

		local chippad = instance.uipadding(chip)
		chippad.PaddingLeft = UDim.new(0, 7)
		chippad.PaddingRight = UDim.new(0, 8)

		local chiplayout = instance.uilistlayout(chip)
		chiplayout.FillDirection = Enum.FillDirection.Horizontal
		chiplayout.Padding = UDim.new(0, 4)
		chiplayout.SortOrder = Enum.SortOrder.LayoutOrder
		chiplayout.VerticalAlignment = Enum.VerticalAlignment.Center

		if chipconfig.Icon and chipconfig.Icon ~= "" then
			local chipicon = instance.imagelabel(chip)
			chipicon.LayoutOrder = 1
			chipicon.Size = UDim2.new(0, 12, 0, 12)
			chipicon.BackgroundTransparency = 1
			chipicon.ImageColor3 = chipconfig.Color or theme.SubText
			applyicon(chipicon, chipconfig.Icon, 48)
		end

		local chiptext = instance.textlabel(chip)
		chiptext.LayoutOrder = 2
		chiptext.Font = Enum.Font.GothamBold
		chiptext.TextSize = 11
		chiptext.TextColor3 = theme.SubText
		chiptext.BackgroundTransparency = 1
		chiptext.BorderSizePixel = 0
		chiptext.AutomaticSize = Enum.AutomaticSize.X
		chiptext.Size = UDim2.new(0, 0, 1, 0)
		chiptext.Text = tostring(chipconfig.Text or "")

		local chipobj = {}
		function chipobj:SetText(text)
			chiptext.Text = tostring(text)
		end
		function chipobj:SetVisible(visible)
			chip.Visible = visible and true or false
		end
		function chipobj:Destroy()
			chip:Destroy()
		end
		return chipobj
	end

	function tabs:AddTabHeader(headertext, order)
		headertext = tostring(headertext or "")
		local rail = guiconfig.IconRail == true
		local first = true
		for _, child in ipairs(scrolltab:GetChildren()) do
			if child:IsA("GuiObject") then
				first = false
				break
			end
		end

		local header = instance.frame(scrolltab)
		header.Name = "TabHeader"
		header.BackgroundTransparency = 1
		header.BorderSizePixel = 0
		header.LayoutOrder = tonumber(order) or (counttab * 2 - 1)
		header.Size = UDim2.new(1, -6, 0, rail and 8 or (first and 16 or 24))

		local label, line
		if rail then
			line = instance.frame(header)
			line.Name = "Divider"
			line.AnchorPoint = Vector2.new(0.5, 0.5)
			line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			line.BackgroundTransparency = 0.85
			line.BorderSizePixel = 0
			line.Position = UDim2.new(0.5, 0, 0.5, 0)
			line.Size = UDim2.new(0.6, 0, 0, 1)
			line.Visible = not first
		else
			label = instance.textlabel(header)
			label.Name = "HeaderText"
			label.Font = Enum.Font.GothamBold
			label.Text = headertext
			label.TextColor3 = theme.SubText
			label.TextTransparency = 0.2
			label.TextSize = 11
			label.TextTruncate = Enum.TextTruncate.AtEnd
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.TextYAlignment = Enum.TextYAlignment.Bottom
			label.BackgroundTransparency = 1
			label.BorderSizePixel = 0
			label.Position = UDim2.new(0, 8, 0, 0)
			label.Size = UDim2.new(1, -14, 1, -4)
		end

		local headerfunc = {}
		function headerfunc:SetText(newtext)
			if label then
				label.Text = tostring(newtext)
			end
		end
		function headerfunc:Destroy()
			header:Destroy()
		end
		return headerfunc
	end

	function tabs:_ensurecategory(cfg)
		local category = cfg.Category or cfg.Group
		if category == nil or category == "" or category == lasttabcategory then
			return
		end
		lasttabcategory = category
		tabs:AddTabHeader(category)
	end

	function tabs:AddTabLink(linkconfig)
		linkconfig = linkconfig or {}
		tabs:_ensurecategory(linkconfig)
		local rail = guiconfig.IconRail == true

		local entry = instance.frame(scrolltab)
		entry.Name = "TabLink"
		entry.BorderSizePixel = 0
		entry.LayoutOrder = counttab * 2
		entry.Size = UDim2.new(1, -6, 0, rail and 32 or 26)
		local entrybg = roundbg(entry, 4, theme.TabActive)
		entrybg.ImageTransparency = 1

		local entrybutton = instance.textbutton(entry)
		entrybutton.Name = "TabButton"
		entrybutton.Text = ""
		entrybutton.BackgroundTransparency = 1
		entrybutton.Size = UDim2.new(1, 0, 1, 0)

		local hasicon = linkconfig.Icon ~= nil and linkconfig.Icon ~= ""
		local entryicon
		if hasicon then
			entryicon = instance.imagelabel(entry)
			entryicon.Name = "TabIcon"
			entryicon.AnchorPoint = Vector2.new(rail and 0.5 or 0, 0.5)
			entryicon.Position = UDim2.new(rail and 0.5 or 0, rail and 0 or 8, 0.5, 0)
			entryicon.Size = rail and UDim2.new(0, 18, 0, 18) or UDim2.new(0, 14, 0, 14)
			entryicon.BackgroundTransparency = 1
			entryicon.ImageColor3 = theme.SubText
			applyicon(entryicon, linkconfig.Icon, 48)
		end

		local entryname
		if not rail then
			entryname = instance.textlabel(entry)
			entryname.Name = "LinkName"
			entryname.Font = Enum.Font.GothamBold
			entryname.Text = tostring(linkconfig.Name or linkconfig.Title or "Link")
			entryname.TextColor3 = theme.SubText
			entryname.TextSize = 13
			entryname.TextTruncate = Enum.TextTruncate.AtEnd
			entryname.TextXAlignment = Enum.TextXAlignment.Left
			entryname.BackgroundTransparency = 1
			entryname.BorderSizePixel = 0
			entryname.Size = UDim2.new(1, -(hasicon and 28 or 10), 1, 0)
			entryname.Position = UDim2.new(0, hasicon and 26 or 8, 0, 0)
		end

		local function glow(on)
			tw(entrybg, { ImageTransparency = on and 0.7 or 1 }, 0.15)
			if entryname then
				tw(entryname, { TextColor3 = on and theme.Text or theme.SubText }, 0.15)
			end
			if entryicon then
				tw(entryicon, { ImageColor3 = on and theme.Text or theme.SubText }, 0.15)
			end
		end
		entrybutton.MouseEnter:Connect(function()
			glow(true)
		end)
		entrybutton.MouseLeave:Connect(function()
			glow(false)
		end)

		entrybutton.Activated:Connect(function()
			pcall(pesseffect, entry)
			if typeof(linkconfig.Callback) == "function" then
				local ok, err = pcall(linkconfig.Callback)
				if not ok then
					warn("Tab link Callback error:", err)
				end
			elseif linkconfig.Link then
				clipboardwrite(linkconfig.Link)
			end
		end)

		counttab = counttab + 1
		local linkfunc = {}
		function linkfunc:Destroy()
			entry:Destroy()
		end
		return linkfunc
	end

	function tabs:AddTab(tabconfig)
		tabconfig = tabconfig or {}
		tabconfig.Name = tabconfig.Name or "Tab"
		if not tabconfig.Hidden then
			tabs:_ensurecategory(tabconfig)
		end

		local tabIndex = counttab

		local layoutOrder = tonumber(tabconfig.LayoutOrder) or (tabIndex * 2)
		local isFirstTab = not hasActiveTab and tabconfig.StartActive ~= false
		if isFirstTab then
			hasActiveTab = true
		end

		local scrollayers = instance.scrollingframe(layersfolder)
		scrollayers.Name = "ScrolLayers"
		scrollayers.ScrollBarImageColor3 = theme.Bar
		scrollayers.ScrollBarImageTransparency = 0.15
		scrollayers.ScrollBarThickness = 3
		scrollayers.VerticalScrollBarInset = Enum.ScrollBarInset.None
		scrollayers.Active = true
		scrollayers.LayoutOrder = layoutOrder
		scrollayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		scrollayers.BackgroundTransparency = 1
		scrollayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
		scrollayers.BorderSizePixel = 0
		scrollayers.Size = UDim2.new(1, 0, 1, 0)

		local uilistlayout1 = instance.uilistlayout(scrollayers)
		uilistlayout1.Padding = UDim.new(0, 3)
		uilistlayout1.SortOrder = Enum.SortOrder.LayoutOrder

		local function updatesizescroll()
			scrollayers.CanvasSize = UDim2.new(0, 0, 0, math.ceil(uilistlayout1.AbsoluteContentSize.Y / fitscaleof(scrollayers)) + 8)
		end

		uilistlayout1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updatesizescroll)

		local gridon = guiconfig.Grid ~= false and tabconfig.Grid ~= false and tabconfig.Columns ~= 1
		local gridmin = tonumber(tabconfig.GridMinWidth or guiconfig.GridMinWidth) or 380
		local gridgap = tonumber(guiconfig.GridGap) or 6
		local rowcount = 0
		local holders = {}
		local activeholder = nil

		local function applyholdermode(holder)
			local wide = gridon and scrollayers.AbsoluteSize.X / fitscaleof(scrollayers) >= gridmin
			if holder.Wide == wide then
				return
			end
			holder.Wide = wide
			if wide then
				holder.Layout.FillDirection = Enum.FillDirection.Horizontal
				holder.Layout.Padding = UDim.new(0, gridgap)
				holder.Left.Size = UDim2.new(0.5, -gridgap / 2, 0, 0)
				holder.Right.Size = UDim2.new(0.5, -gridgap / 2, 0, 0)
				holder.Left.Visible = true
				holder.Right.Visible = true
			else
				holder.Layout.FillDirection = Enum.FillDirection.Vertical
				holder.Layout.Padding = UDim.new(0, 5)
				holder.Left.Size = UDim2.new(1, 0, 0, 0)
				holder.Right.Size = UDim2.new(1, 0, 0, 0)
				holder.Left.Visible = holder.LeftCount > 0
				holder.Right.Visible = holder.RightCount > 0
			end
		end

		local function touchholder(holder)
			holder.Wide = nil
			applyholdermode(holder)
		end

		local function newholder()
			rowcount = rowcount + 1
			local holder = { LeftCount = 0, RightCount = 0, LeftRecs = {}, RightRecs = {} }
			local frame = instance.frame(scrollayers)
			frame.Name = "Columns"
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			frame.LayoutOrder = rowcount * 10
			frame.Size = UDim2.new(1, 0, 0, 0)
			frame.AutomaticSize = Enum.AutomaticSize.Y
			holder.Frame = frame
			holder.Layout = instance.uilistlayout(frame)
			holder.Layout.SortOrder = Enum.SortOrder.LayoutOrder
			holder.Layout.VerticalAlignment = Enum.VerticalAlignment.Top

			local function makecolumn(name, order)
				local column = instance.frame(frame)
				column.Name = name
				column.BackgroundTransparency = 1
				column.BorderSizePixel = 0
				column.LayoutOrder = order
				column.Size = UDim2.new(0.5, -gridgap / 2, 0, 0)
				column.AutomaticSize = Enum.AutomaticSize.Y
				local columnlayout = instance.uilistlayout(column)
				columnlayout.SortOrder = Enum.SortOrder.LayoutOrder
				columnlayout.Padding = UDim.new(0, 5)
				return column
			end

			holder.Left = makecolumn("Left", 1)
			holder.Right = makecolumn("Right", 2)
			holders[#holders + 1] = holder
			applyholdermode(holder)
			return holder
		end

		scrollayers:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			for _, holder in ipairs(holders) do
				applyholdermode(holder)
			end
		end)

		local function estimateheight(recs)
			local total = 0
			for _, rec in ipairs(recs) do
				if not rec.Removed then
					total = total + rec.Estimate() + 5
				end
			end
			return total
		end

		local function placesection(side, rec, legacyorder)
			side = tostring(side or ""):lower()
			if not gridon then
				return scrollayers, legacyorder
			end
			if rec.Force and (side == "full" or side == "wide" or side == "both" or side == "all") then
				rowcount = rowcount + 1
				activeholder = nil
				return scrollayers, rowcount * 10
			end
			local holder = activeholder
			if not holder then
				holder = newholder()
				activeholder = holder
			end
			local column
			if side == "left" or side == "l" then
				column = "Left"
			elseif side == "right" or side == "r" then
				column = "Right"
			else
				column = estimateheight(holder.LeftRecs) <= estimateheight(holder.RightRecs) and "Left" or "Right"
			end
			rec.Holder = holder
			rec.Column = column
			local order
			if column == "Left" then
				holder.LeftCount = holder.LeftCount + 1
				order = holder.LeftCount
				table.insert(holder.LeftRecs, rec)
			else
				holder.RightCount = holder.RightCount + 1
				order = holder.RightCount
				table.insert(holder.RightRecs, rec)
			end
			touchholder(holder)
			return holder[column], order
		end

		local function promotesection(section, rec)
			if not gridon or not rec or section.Parent == scrollayers then
				return
			end
			local holder = rec.Holder
			rec.Removed = true
			if holder then
				local order = holder.Frame.LayoutOrder + 1
				if rec.Column == "Left" then
					holder.LeftCount = holder.LeftCount - 1
				else
					holder.RightCount = holder.RightCount - 1
				end
				if activeholder == holder then
					activeholder = nil
				end
				section.LayoutOrder = order
				section.Parent = scrollayers
				if holder.LeftCount + holder.RightCount <= 0 then
					local at = table.find(holders, holder)
					if at then
						table.remove(holders, at)
					end
					holder.Frame:Destroy()
				else
					touchholder(holder)
				end
			else
				section.Parent = scrollayers
			end
		end

		local tab = instance.frame(nil)
		if not tabconfig.Hidden then
			tab.Parent = scrolltab
		end
		tab.Name = "Tab"
		tab.BorderSizePixel = 0
		tab.LayoutOrder = layoutOrder
		tab.Size = UDim2.new(1, -6, 0, 26)
		local tabbg = roundbg(tab, 4, theme.TabActive)
		tabbg.ImageTransparency = isFirstTab and 0 or 1

		local tabbutton = instance.textbutton(tab)
		tabbutton.Name = "TabButton"
		tabbutton.Font = Enum.Font.GothamBold
		tabbutton.Text = ""
		tabbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabbutton.TextSize = 13
		tabbutton.TextXAlignment = Enum.TextXAlignment.Left
		tabbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabbutton.BackgroundTransparency = 1
		tabbutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		tabbutton.BorderSizePixel = 0
		tabbutton.Size = UDim2.new(1, 0, 1, 0)

		local onOpenCallback
		local onOpenRan = false

		local function runOnOpen()
			if onOpenRan or not onOpenCallback then
				return
			end

			onOpenRan = true
			local ok, err = pcall(onOpenCallback)
			if not ok then
				warn("Tab OnOpen error:", err)
			end
		end

		local tabname = instance.textlabel(tab)
		tabname.Name = "TabName"
		tabname.Font = Enum.Font.GothamBold
		tabname.Text = tostring(tabconfig.Name)
		tabname.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabname.TextSize = 13
		tabname.TextTruncate = Enum.TextTruncate.AtEnd
		tabname.TextXAlignment = Enum.TextXAlignment.Left
		tabname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabname.BackgroundTransparency = 1
		tabname.BorderColor3 = Color3.fromRGB(0, 0, 0)
		tabname.BorderSizePixel = 0

		local tabicon
		local function settabicon(value)
			local has = value ~= nil and value ~= ""
			if has and not tabicon then
				tabicon = instance.imagelabel(tab)
				tabicon.Name = "TabIcon"
				tabicon.AnchorPoint = Vector2.new(0, 0.5)
				tabicon.Position = UDim2.new(0, 8, 0.5, 0)
				tabicon.Size = UDim2.new(0, 14, 0, 14)
				tabicon.BackgroundTransparency = 1
				tabicon.ImageColor3 = isFirstTab and theme.Accent or theme.SubText
			end
			if tabicon then
				tabicon.Visible = has
				if has then
					applyicon(tabicon, value, 48)
				end
			end
			tabname.Size = UDim2.new(1, -(has and 28 or 10), 1, 0)
			tabname.Position = UDim2.new(0, has and 26 or 8, 0, 0)
		end

		tabname.TextColor3 = isFirstTab and theme.Text or theme.SubText
		settabicon(tabconfig.Icon)

		if guiconfig.IconRail == true then
			tab.Size = UDim2.new(1, -6, 0, 32)
			tabname.Visible = false
			if tabicon then
				tabicon.AnchorPoint = Vector2.new(0.5, 0.5)
				tabicon.Position = UDim2.new(0.5, 0, 0.5, 0)
				tabicon.Size = UDim2.new(0, 18, 0, 18)
			end
		end

		if isFirstTab then
			layerspagelayout:JumpTo(scrollayers)
			local chooseframe = instance.frame(tab)
			chooseframe.Name = "ChooseFrame"
			chooseframe.BackgroundColor3 = theme.Text
			chooseframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
			chooseframe.BorderSizePixel = 0
			chooseframe.Position = UDim2.new(0, 2, 0, guiconfig.IconRail == true and 10 or 8)
			chooseframe.Size = UDim2.new(0, 1, 0, 12)

			local uistroke2 = instance.uistroke(chooseframe)
			uistroke2.Color = theme.Text
			uistroke2.Thickness = 1.6

			instance.uicorner(chooseframe)
		end

		local tabrec = {}
		if isFirstTab then
			MX.Tab = tabrec
		end
		local subs = {}
		local activesub = 1

		local function activepage()
			local sub = subs[activesub]
			return sub and sub.Page or scrollayers
		end

		local function subnames()
			local names = {}
			for index, sub in ipairs(subs) do
				names[index] = sub.Name
			end
			return names
		end

		local function runsubopen(sub)
			local owner = sub and sub.Sections
			if owner and owner._RunOpen then
				pcall(owner._RunOpen, owner)
			end
		end

		local function activatesub(index)
			if not subs[index] then
				return
			end
			activesub = index
			layerspagelayout:JumpTo(subs[index].Page)
			if MX.Current == tabrec then
				MX.paintsub(index)
			end
			runsubopen(subs[index])
			if searchbox.Text ~= "" then
				runsearch()
			end
		end

		local function refreshsubbar()
			if #subs > 0 and MX.Tab == tabrec then
				MX.showsubbar(tabrec, subnames(), activesub, activatesub)
			end
		end

		local function selecttab()
			if tabconfig._SelectHook then
				return tabconfig._SelectHook()
			end
			if layerspagelayout.CurrentPage == activepage() then
				MX.Tab = tabrec
				refreshsubbar()
				runOnOpen()
				return
			end

			local framechoose
			for _, tabframe in ipairs(scrolltab:GetChildren()) do
				if tabframe.Name == "Tab" then
					local cf = tabframe:FindFirstChild("ChooseFrame")
					if cf then
						framechoose = cf
					end
					local tb = tabframe:FindFirstChild("Bg")
					if tb then
						tw(tb, { ImageTransparency = 1 }, 0.25)
					end
					local tn = tabframe:FindFirstChild("TabName")
					if tn then
						tw(tn, { TextColor3 = theme.SubText }, 0.25)
					end
					local ti = tabframe:FindFirstChild("TabIcon")
					if ti then
						tw(ti, { ImageColor3 = theme.SubText }, 0.25)
					end
				end
			end

			if not framechoose then
				return
			end

			tw(tabbg, { ImageTransparency = 0 }, 0.25)
			tw(tabname, { TextColor3 = theme.Text }, 0.25)
			if tabicon then
				tw(tabicon, { ImageColor3 = theme.Accent }, 0.25)
			end

			local indicatory = guiconfig.IconRail == true and 10 or 8
			local fromy = indicatory
			if framechoose.Parent and framechoose.Parent ~= tab then
				pcall(function()
					fromy = math.clamp(framechoose.AbsolutePosition.Y - tab.AbsolutePosition.Y, -300, 400)
				end)
			end
			framechoose.Parent = tab
			framechoose.Size = UDim2.new(0, 1, 0, 12)
			framechoose.Position = UDim2.new(0, 2, 0, fromy)
			tw(framechoose, { Position = UDim2.new(0, 2, 0, indicatory) }, 0.32)

			layerspagelayout:JumpTo(activepage())
			MX.Tab = tabrec
			if #subs > 0 then
				refreshsubbar()
			else
				MX.clearsubbar()
			end
			runOnOpen()
			runsubopen(subs[activesub])

			if searchbox.Text ~= "" then
				runsearch()
			end
		end
		tabbutton.Activated:Connect(selecttab)

		local sections = {}
		function sections:SetIcon(value)
			settabicon(value)
		end
		local countsection = 0

		function sections:Select()
			selecttab()
		end

		function sections:GetPage()
			return scrollayers
		end

		function sections:_RunOpen()
			runOnOpen()
		end

		-- Sub-tabs (General / Advanced / Presets ...). The first call reuses this tab's own page,
		-- every further call creates another page that is switched from the top bar.
		function sections:AddSubTab(subname)
			if tabconfig.Hidden then
				return sections
			end
			subname = tostring(subname or ("Page " .. tostring(#subs + 1)))
			if #subs == 0 then
				subs[1] = { Name = subname, Page = scrollayers, Sections = sections }
				refreshsubbar()
				return sections
			end
			local index = #subs + 1
			local hidden = tabs:AddTab({
				Name = tabconfig.Name,
				Hidden = true,
				StartActive = false,
				LayoutOrder = layoutOrder,
				Grid = tabconfig.Grid,
				Columns = tabconfig.Columns,
				GridMinWidth = tabconfig.GridMinWidth,
				_SelectHook = function()
					selecttab()
					activatesub(index)
				end,
			})
			subs[index] = { Name = subname, Page = hidden:GetPage(), Sections = hidden }
			refreshsubbar()
			return hidden
		end

		function sections:AddLeftSection(title, open, icon)
			return sections:AddSection(title, open, "Left", icon)
		end

		function sections:AddRightSection(title, open, icon)
			return sections:AddSection(title, open, "Right", icon)
		end

		function sections:AddFullSection(title, open, icon)
			return sections:AddSection(title, open, "Full", icon)
		end

		function sections:OnOpen(callback)
			onOpenCallback = callback
			if isFirstTab then
				runOnOpen()
			end
			return self
		end

		function sections:AddSection(sectiontitletext, alwaysopen, side, sectionicon)
			local forcefull = false
			if type(sectiontitletext) == "table" then
				local opts = sectiontitletext
				forcefull = opts.Force == true
				sectiontitletext = opts.Title or opts.Name
				if alwaysopen == nil then
					alwaysopen = opts.Open ~= false and opts.AlwaysOpen ~= false
				end
				side = side or opts.Side or opts.Column
				sectionicon = sectionicon or opts.Icon
			end
			sectiontitletext = sectiontitletext or "Title"

			local rec = {
				Force = forcefull,
				Estimate = function()
					return 30
				end,
			}
			local sectiontween = TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			local arrowtween = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

			local section = instance.frame(nil)
			section.Name = "Section"
			section.BackgroundColor3 = theme.Row
			section.BackgroundTransparency = rowalpha
			section.BorderSizePixel = 0
			section.ClipsDescendants = true
			section.Size = UDim2.new(1, 0, 0, 30)
			instance.uicorner(section).CornerRadius = UDim.new(0, 6)
			do
				local sectionstroke = instance.uistroke(section)
				sectionstroke.Color = theme.Stroke
				sectionstroke.Thickness = 1
				sectionstroke.Transparency = 0.45
			end
			do
				local parentframe, layoutorder = placesection(side, rec, countsection)
				section.LayoutOrder = layoutorder
				section.Parent = parentframe
			end

			local sectionreal = instance.frame(section)
			sectionreal.AnchorPoint = Vector2.new(0.5, 0)
			sectionreal.BackgroundColor3 = theme.Header
			sectionreal.BackgroundTransparency = bgAsset and 0.05 or rowalpha
			sectionreal.BorderSizePixel = 0
			sectionreal.Position = UDim2.new(0.5, 0, 0, 0)
			sectionreal.Size = UDim2.new(1, 0, 0, 30)

			local uicorner = instance.uicorner(sectionreal)
			uicorner.CornerRadius = UDim.new(0, 6)

			local sectionbutton = instance.textbutton(sectionreal)
			sectionbutton.Font = Enum.Font.SourceSans
			sectionbutton.Text = ""
			sectionbutton.BackgroundTransparency = 1
			sectionbutton.Size = UDim2.new(1, 0, 1, 0)

			local featureframe = instance.frame(sectionreal)
			featureframe.AnchorPoint = Vector2.new(1, 0.5)
			featureframe.BackgroundTransparency = 1
			featureframe.Position = UDim2.new(1, -5, 0.5, 0)
			featureframe.Size = UDim2.new(0, 20, 0, 20)

			local featureimg = instance.imagelabel(featureframe)
			applyicon(featureimg, "chevron-down", 48)
			featureimg.AnchorPoint = Vector2.new(0.5, 0.5)
			featureimg.BackgroundTransparency = 1
			featureimg.ImageColor3 = theme.SubText
			featureimg.Position = UDim2.new(0.5, 0, 0.5, 0)
			featureimg.Rotation = 0
			featureimg.Size = UDim2.new(0, 16, 0, 16)

			local sectiontitle = instance.textlabel(sectionreal)
			sectiontitle.Font = Enum.Font.GothamBold
			sectiontitle.Text = sectiontitletext
			sectiontitle.TextColor3 = theme.Text
			sectiontitle.TextSize = 13
			sectiontitle.TextXAlignment = Enum.TextXAlignment.Left
			sectiontitle.AnchorPoint = Vector2.new(0, 0.5)
			sectiontitle.BackgroundTransparency = 1
			sectiontitle.Position = UDim2.new(0, 10, 0.5, 0)
			sectiontitle.Size = UDim2.new(1, -50, 0, 13)
			sectiontitle.TextTruncate = Enum.TextTruncate.AtEnd
			sectiontitle.TextTruncate = Enum.TextTruncate.AtEnd

			local headericon
			local function setsectionicon(value)
				local has = value ~= nil and value ~= ""
				if has and not headericon then
					headericon = instance.imagelabel(sectionreal)
					headericon.Name = "SectionIcon"
					headericon.AnchorPoint = Vector2.new(0, 0.5)
					headericon.BackgroundTransparency = 1
					headericon.Position = UDim2.new(0, 10, 0.5, 0)
					headericon.Size = UDim2.new(0, 14, 0, 14)
					headericon.ImageColor3 = theme.SubText
				end
				if headericon then
					headericon.Visible = has
					if has then
						applyicon(headericon, value, 48)
					end
				end
				sectiontitle.Position = UDim2.new(0, has and 31 or 10, 0.5, 0)
				sectiontitle.Size = UDim2.new(1, has and -71 or -50, 0, 13)
			end
			setsectionicon(sectionicon)

			local sectionadd = instance.frame(section)
			sectionadd.AnchorPoint = Vector2.new(0.5, 0)
			sectionadd.BackgroundTransparency = 1
			sectionadd.BorderSizePixel = 0
			sectionadd.ClipsDescendants = true
			sectionadd.Position = UDim2.new(0.5, 0, 0, 30)
			sectionadd.Size = UDim2.new(1, 0, 0, 0)

			local uicorner8 = instance.uicorner(sectionadd)
			uicorner8.CornerRadius = UDim.new(0, 2)

			local bodypad = instance.uipadding(sectionadd)
			bodypad.PaddingTop = UDim.new(0, 5)
			bodypad.PaddingBottom = UDim.new(0, 7)
			bodypad.PaddingLeft = UDim.new(0, 7)
			bodypad.PaddingRight = UDim.new(0, 7)

			local uilistlayout2 = instance.uilistlayout(sectionadd)
			uilistlayout2.Padding = UDim.new(0, 4)
			uilistlayout2.SortOrder = Enum.SortOrder.LayoutOrder

			local color_normal = theme.Text
			local color_open = theme.Text

			local opensection = false
			local sectionResizeQueued = false

			local function updatesizesection(animate)
				if not opensection then
					return
				end

				local contentHeight = math.max(0, math.ceil(uilistlayout2.AbsoluteContentSize.Y / fitscaleof(uilistlayout2.Parent)))
				if contentHeight > 0 then
					contentHeight = contentHeight + 12
				end
				local sectionsizey = 30 + contentHeight
				sectiontitle.TextColor3 = color_open

				if animate and featureframe.Parent then
					sv.ts:Create(featureframe, arrowtween, { Rotation = 180 }):Play()
					sv.ts:Create(featureimg, arrowtween, { ImageColor3 = theme.Text }):Play()
					sv.ts:Create(section, sectiontween, { Size = UDim2.new(1, 0, 0, sectionsizey) }):Play()
					sv.ts:Create(sectionadd, sectiontween, { Size = UDim2.new(1, 0, 0, contentHeight) }):Play()
				else
					if featureframe.Parent then
						featureframe.Rotation = 180
						featureimg.ImageColor3 = theme.Text
					end
					section.Size = UDim2.new(1, 0, 0, sectionsizey)
					sectionadd.Size = UDim2.new(1, 0, 0, contentHeight)
				end

				updatesizescroll()
			end

			local function queueSectionResize()
				if sectionResizeQueued then
					return
				end

				sectionResizeQueued = true
				task.defer(function()
					sectionResizeQueued = false
					updatesizesection(false)
				end)
			end

			local function closesection(animate)
				if not opensection then
					return
				end
				opensection = false
				sectiontitle.TextColor3 = color_normal
				if animate then
					sv.ts:Create(featureframe, arrowtween, { Rotation = 0 }):Play()
					sv.ts:Create(featureimg, arrowtween, { ImageColor3 = theme.SubText }):Play()
					sv.ts:Create(section, sectiontween, { Size = UDim2.new(1, 0, 0, 30) }):Play()
					sv.ts:Create(sectionadd, sectiontween, { Size = UDim2.new(1, 0, 0, 0) }):Play()
				else
					featureframe.Rotation = 0
					featureimg.ImageColor3 = theme.SubText
					section.Size = UDim2.new(1, 0, 0, 30)
					sectionadd.Size = UDim2.new(1, 0, 0, 0)
				end
			end

			sectionbutton.Activated:Connect(function()
				if opensection then
					closesection(true)
				else
					opensection = true
					updatesizesection(true)
				end
			end)

			if alwaysopen then
				opensection = true
				updatesizesection(false)
			end

			uilistlayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(queueSectionResize)

			local items = {}
			function items:SetIcon(value)
				setsectionicon(value)
			end
			local countitem = 0

			rec.Estimate = function()
				if opensection then
					return 30 + countitem * 49
				end
				return 30
			end

			function items:PromoteToFull()
				promotesection(section, rec)
			end
			local currentSubSection = nil
			local buildStartTime = 0
			local frameThreshold = 0.012
			local function yieldbuild()
				if buildStartTime == 0 then
					buildStartTime = tick()
				end
				if (tick() - buildStartTime) > frameThreshold then
					task.wait()
					buildStartTime = tick()
				end
			end

			local function registerSearchItem(title, object, kind)
				title = tostring(title or "Item")

				local path = tabconfig.Name .. "/" .. sectiontitletext
				if currentSubSection then
					path = path .. "/" .. currentSubSection
				end
				path = path .. "/" .. title

				table.insert(searchItems, {
					Name = title,
					Path = path,
					TabIndex = scrollayers.LayoutOrder,
					Page = scrollayers,
					Section = section,
					Object = object,
					Kind = kind,
					TabName = tabconfig.Name,
					SectionName = sectiontitletext,
					Select = selecttab,
					Scroll = scrollayers,
					IsOpen = function()
						return opensection
					end,
					OpenSection = function()
						if not opensection then
							opensection = true
							updatesizesection()
						end
					end,
					CloseSection = function()
						closesection(false)
					end,
				})
			end

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
				roundbg(paragraph, 4, theme.Row)

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

					hoverbg(paragraphbutton, roundbg(paragraphbutton, 6, theme.Inner), theme.Inner, theme.InnerHover)

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
			function items:AddCharacter(characterconfig)
				characterconfig = characterconfig or {}

				local box = instance.frame(sectionadd)
				box.Name = "Character"
				box.BorderSizePixel = 0
				box.LayoutOrder = countitem
				box.Size = UDim2.new(1, 0, 0, tonumber(characterconfig.Height) or 240)
				box.ClipsDescendants = true
				roundbg(box, 6, theme.Row)
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
			function items:AddButton(buttonconfig)
				buttonconfig = buttonconfig or {}
				buttonconfig.Title = buttonconfig.Title or "Confirm"
				buttonconfig.Callback = buttonconfig.Callback or function() end
				buttonconfig.SubTitle = buttonconfig.SubTitle or nil
				buttonconfig.SubCallback = buttonconfig.SubCallback or function() end

				local function runcallback(fn, label)
					elevate()
					if typeof(fn) == "function" then
						local ok, err = pcall(fn)
						if not ok then
							warn("Button Callback error (" .. tostring(label) .. "):", err)
						end
					end
				end

				local button = instance.frame(sectionadd)
				button.BorderSizePixel = 0
				button.Size = UDim2.new(1, 0, 0, isMobile and 46 or 40)
				button.LayoutOrder = countitem
				roundbg(button, 4, theme.Row)

				local padding = 3
				local gap = 4

				local mainbutton = instance.textbutton(button)
				mainbutton.Font = Enum.Font.GothamMedium
				mainbutton.Text = tostring(buttonconfig.Title)
				mainbutton.TextSize = isMobile and 12 or 11
				mainbutton.TextTruncate = Enum.TextTruncate.AtEnd
				mainbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
				mainbutton.TextTransparency = 0.3
				mainbutton.AutoButtonColor = false
				mainbutton.ZIndex = 10
				hoverbg(mainbutton, roundbg(mainbutton, 4, theme.Inner), theme.Inner, theme.InnerHover)

				if buttonconfig.SubTitle then
					mainbutton.Size = UDim2.new(0.5, -padding - gap, 1, -10)
					mainbutton.Position = UDim2.new(0, padding, 0, 5)
				else
					mainbutton.Size = UDim2.new(1, -padding * 2, 1, -10)
					mainbutton.Position = UDim2.new(0, padding, 0, 5)
				end

				local textpad = instance.uipadding(mainbutton)
				local buttonicon
				local function seticon(value)
					local has = hasimage(value)
					if has and not buttonicon then
						buttonicon = instance.imagelabel(mainbutton)
						buttonicon.Name = "ButtonIcon"
						buttonicon.BackgroundTransparency = 1
						buttonicon.AnchorPoint = Vector2.new(0, 0.5)
						buttonicon.Position = UDim2.new(0, 10, 0.5, 0)
						buttonicon.Size = UDim2.new(0, 16, 0, 16)
						buttonicon.ZIndex = 11
						buttonicon.ImageColor3 = theme.SubText
					end
					if buttonicon then
						buttonicon.Visible = has
						if has then
							applyicon(buttonicon, value, 48)
						end
					end
					textpad.PaddingLeft = UDim.new(0, has and 24 or 0)
				end
				seticon(buttonconfig.Icon)

				mainbutton.MouseButton1Down:Connect(function()
					pcall(pesseffect, mainbutton)
				end)

				mainbutton.MouseButton1Click:Connect(function()
					runcallback(buttonconfig.Callback, buttonconfig.Title)
				end)

				local buttons = { mainbutton }

				if buttonconfig.SubTitle then
					local subbutton = instance.textbutton(button)
					subbutton.Font = Enum.Font.GothamMedium
					subbutton.Text = tostring(buttonconfig.SubTitle)
					subbutton.TextSize = isMobile and 12 or 11
					subbutton.TextTruncate = Enum.TextTruncate.AtEnd
					subbutton.TextTransparency = 0.3
					subbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
					subbutton.Size = UDim2.new(0.5, -padding - gap, 1, -10)
					subbutton.Position = UDim2.new(0.5, gap, 0, 5)
					subbutton.AutoButtonColor = false
					subbutton.ZIndex = 10
					hoverbg(subbutton, roundbg(subbutton, 4, theme.Inner), theme.Inner, theme.InnerHover)

					subbutton.MouseButton1Down:Connect(function()
						pcall(pesseffect, subbutton)
					end)

					subbutton.MouseButton1Click:Connect(function()
						runcallback(buttonconfig.SubCallback, buttonconfig.SubTitle)
					end)
					buttons[#buttons + 1] = subbutton
				end

				local searchname = tostring(buttonconfig.Title)
				if buttonconfig.SubTitle then
					searchname = searchname .. " / " .. tostring(buttonconfig.SubTitle)
				end
				registerSearchItem(searchname, button, "Button")
				countitem = countitem + 1
				yieldbuild()

				local buttonfunc = {}
				function buttonfunc:SetTitle(text)
					mainbutton.Text = tostring(text)
				end
				function buttonfunc:SetIcon(value)
					seticon(value)
				end
				function buttonfunc:SetIconColor(color)
					if buttonicon and typeof(color) == "Color3" then
						buttonicon.ImageColor3 = color
					end
				end
				return buttonfunc
			end

			function items:AddColorPicker(colorconfig)
				colorconfig = colorconfig or {}
				colorconfig.Title = colorconfig.Title or colorconfig.Name or "Color"
				colorconfig.Callback = colorconfig.Callback or function() end

				local configkey = keyfor("Color_", colorconfig)

				local function parsecolor(value)
					if typeof(value) == "Color3" then
						return value
					end
					if type(value) == "string" then
						local hex = value:gsub("^#", "")
						if #hex == 3 then
							hex = hex:gsub(".", "%0%0")
						end
						if #hex == 6 and hex:match("^%x+$") then
							return Color3.fromRGB(
								tonumber(hex:sub(1, 2), 16),
								tonumber(hex:sub(3, 4), 16),
								tonumber(hex:sub(5, 6), 16)
							)
						end
					end
					return nil
				end

				local function tohex(color)
					return string.format(
						"%02X%02X%02X",
						math.floor(color.R * 255 + 0.5),
						math.floor(color.G * 255 + 0.5),
						math.floor(color.B * 255 + 0.5)
					)
				end

				local hubdefault = parsecolor(colorconfig.Default) or Color3.fromRGB(255, 255, 255)
				local hue, sat, val = hubdefault:ToHSV()
				local colorfunc = { Value = hubdefault, DefaultValue = hubdefault, Opened = false }

				local PANEL_HEIGHT = 148
				local basey = 46

				local row = instance.frame(sectionadd)
				row.Name = "ColorPicker"
				row.BorderSizePixel = 0
				row.ClipsDescendants = true
				row.LayoutOrder = countitem
				row.Size = UDim2.new(1, 0, 0, basey)
				roundbg(row, 4, theme.Row)

				local title = instance.textlabel(row)
				title.Name = "ColorTitle"
				title.Font = Enum.Font.GothamBold
				title.Text = tostring(colorconfig.Title)
				title.TextSize = 13
				title.TextColor3 = theme.Text
				title.TextXAlignment = Enum.TextXAlignment.Left
				title.TextYAlignment = Enum.TextYAlignment.Top
				title.TextTruncate = Enum.TextTruncate.AtEnd
				title.BackgroundTransparency = 1
				title.Position = UDim2.new(0, 10, 0, 15)
				title.Size = UDim2.new(1, -80, 0, 13)

				local swatch = instance.textbutton(row)
				swatch.Name = "Swatch"
				swatch.AnchorPoint = Vector2.new(1, 0.5)
				swatch.Position = UDim2.new(1, -12, 0, basey / 2)
				swatch.Size = UDim2.new(0, 26, 0, 26)
				swatch.AutoButtonColor = false
				swatch.Text = ""
				swatch.BorderSizePixel = 0
				swatch.BackgroundColor3 = hubdefault
				instance.uicorner(swatch).CornerRadius = UDim.new(1, 0)
				local swatchstroke = instance.uistroke(swatch)
				swatchstroke.Color = Color3.fromRGB(255, 255, 255)
				swatchstroke.Thickness = 1
				swatchstroke.Transparency = 0.8

				local panel = instance.frame(row)
				panel.Name = "Panel"
				panel.BackgroundTransparency = 1
				panel.BorderSizePixel = 0
				panel.Position = UDim2.new(0, 0, 0, basey)
				panel.Size = UDim2.new(1, 0, 0, PANEL_HEIGHT)
				panel.Visible = false

				local svbox = instance.frame(panel)
				svbox.Name = "SV"
				svbox.BorderSizePixel = 0
				svbox.Position = UDim2.new(0, 10, 0, 4)
				svbox.Size = UDim2.new(1, -58, 0, 100)
				svbox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				instance.uicorner(svbox).CornerRadius = UDim.new(0, 4)

				local whiteoverlay = instance.frame(svbox)
				whiteoverlay.BorderSizePixel = 0
				whiteoverlay.Size = UDim2.new(1, 0, 1, 0)
				whiteoverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				instance.uicorner(whiteoverlay).CornerRadius = UDim.new(0, 4)
				local whitegradient = instance.uigradient(whiteoverlay)
				whitegradient.Transparency =
					NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })

				local blackoverlay = instance.frame(svbox)
				blackoverlay.BorderSizePixel = 0
				blackoverlay.Size = UDim2.new(1, 0, 1, 0)
				blackoverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				instance.uicorner(blackoverlay).CornerRadius = UDim.new(0, 4)
				local blackgradient = instance.uigradient(blackoverlay)
				blackgradient.Rotation = 90
				blackgradient.Transparency =
					NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })

				local svhit = instance.textbutton(svbox)
				svhit.Name = "Hit"
				svhit.BackgroundTransparency = 1
				svhit.Text = ""
				svhit.Size = UDim2.new(1, 0, 1, 0)

				local svcursor = instance.frame(svbox)
				svcursor.Name = "Cursor"
				svcursor.AnchorPoint = Vector2.new(0.5, 0.5)
				svcursor.Size = UDim2.new(0, 10, 0, 10)
				svcursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				svcursor.BorderSizePixel = 0
				instance.uicorner(svcursor).CornerRadius = UDim.new(1, 0)
				local svcursorstroke = instance.uistroke(svcursor)
				svcursorstroke.Color = Color3.fromRGB(0, 0, 0)
				svcursorstroke.Thickness = 1.5

				local huebar = instance.frame(panel)
				huebar.Name = "Hue"
				huebar.BorderSizePixel = 0
				huebar.Position = UDim2.new(1, -38, 0, 4)
				huebar.Size = UDim2.new(0, 18, 0, 100)
				huebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				instance.uicorner(huebar).CornerRadius = UDim.new(0, 4)
				local huegradient = instance.uigradient(huebar)
				huegradient.Rotation = 90
				huegradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
					ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
					ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
					ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
					ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
				})

				local huehit = instance.textbutton(huebar)
				huehit.Name = "Hit"
				huehit.BackgroundTransparency = 1
				huehit.Text = ""
				huehit.Size = UDim2.new(1, 0, 1, 0)

				local huecursor = instance.frame(huebar)
				huecursor.Name = "Cursor"
				huecursor.AnchorPoint = Vector2.new(0.5, 0.5)
				huecursor.Size = UDim2.new(1, 4, 0, 4)
				huecursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				huecursor.BorderSizePixel = 0
				instance.uicorner(huecursor).CornerRadius = UDim.new(0, 2)
				local huecursorstroke = instance.uistroke(huecursor)
				huecursorstroke.Color = Color3.fromRGB(0, 0, 0)
				huecursorstroke.Thickness = 1

				local hexbox = instance.textbox(panel)
				hexbox.Name = "Hex"
				hexbox.Position = UDim2.new(0, 10, 0, 112)
				hexbox.Size = UDim2.new(0, 96, 0, 26)
				hexbox.BackgroundColor3 = theme.Field
				hexbox.BorderSizePixel = 0
				hexbox.ClearTextOnFocus = false
				hexbox.Font = Enum.Font.GothamBold
				hexbox.PlaceholderText = "#RRGGBB"
				hexbox.TextColor3 = theme.Text
				hexbox.TextSize = 12
				hexbox.Text = "#" .. tohex(hubdefault)
				instance.uicorner(hexbox).CornerRadius = UDim.new(0, 5)

				local description = contenttext(colorconfig)
				local ix = elementiconx(colorconfig)
				iconapi(colorfunc, elementicon(row, colorconfig.Icon, description and 15.5 or 21.5))
				title.Position = UDim2.new(0, ix, 0, description and 9 or 15)
				title.Size = UDim2.new(1, -(ix + 70), 0, 13)
				local function currentheight()
					return colorfunc.Opened and (basey + PANEL_HEIGHT) or basey
				end
				local function applyheight(animate)
					swatch.Position = UDim2.new(1, -12, 0, basey / 2)
					panel.Position = UDim2.new(0, 0, 0, basey)
					if colorfunc.Opened then
						panel.Visible = true
					elseif animate then
						task.delay(0.32, function()
							if not colorfunc.Opened then
								panel.Visible = false
							end
						end)
					else
						panel.Visible = false
					end
					local size = UDim2.new(1, 0, 0, currentheight())
					if animate then
						tw(row, { Size = size }, 0.3)
					else
						row.Size = size
					end
				end
				if description then
					title.Position = UDim2.new(0, ix, 0, 9)
					local _, measure = attachcontent(row, description, ix, 26, 64)
					local function relayout()
						basey = math.max(46, 26 + measure() + 10)
						applyheight(false)
					end
					relayout()
					watchwidth(row, relayout)
				end

				local function render()
					svbox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					svcursor.Position = UDim2.new(sat, 0, 1 - val, 0)
					huecursor.Position = UDim2.new(0.5, 0, hue, 0)
					swatch.BackgroundColor3 = colorfunc.Value
					if not hexbox:IsFocused() then
						hexbox.Text = "#" .. tohex(colorfunc.Value)
					end
				end

				local function commit(save, notify)
					colorfunc.Value = Color3.fromHSV(hue, sat, val)
					if save then
						config.data[configkey] = tohex(colorfunc.Value)
					end
					render()
					if notify then
						elevate()
						local ok, err = pcall(colorconfig.Callback, colorfunc.Value)
						if not ok then
							warn("ColorPicker Callback error:", err)
						end
					end
				end

				local function setcolor(color, notify)
					local h, s, v = color:ToHSV()
					if s > 0.001 and v > 0.001 then
						hue = h
					end
					sat, val = s, v
					commit(true, notify)
				end

				function colorfunc:Set(value)
					local color = parsecolor(value)
					if color then
						setcolor(color, true)
					end
				end

				function colorfunc:LoadValue(value)
					self:Set(value)
				end

				function colorfunc:ResetValue()
					self:Set(hubdefault)
				end

				function colorfunc:Get()
					return colorfunc.Value
				end

				function colorfunc:GetHex()
					return "#" .. tohex(colorfunc.Value)
				end

				function colorfunc:SetOpen(state)
					colorfunc.Opened = state == true
					applyheight(true)
				end

				local function pointer(input)
					local pos = Vector2.new(input.Position.X, input.Position.Y)
					local gui = row:FindFirstAncestorOfClass("ScreenGui")
					if gui and gui.IgnoreGuiInset then
						local okinset, inset = pcall(function()
							return game:GetService("GuiService"):GetGuiInset()
						end)
						if okinset then
							pos = pos + inset
						end
					end
					return pos
				end

				local dragging = nil
				local function drag(input)
					local pos = pointer(input)
					if dragging == "sv" then
						local abs, size = svbox.AbsolutePosition, svbox.AbsoluteSize
						sat = math.clamp((pos.X - abs.X) / math.max(size.X, 1), 0, 1)
						val = 1 - math.clamp((pos.Y - abs.Y) / math.max(size.Y, 1), 0, 1)
						commit(true, true)
					elseif dragging == "hue" then
						local abs, size = huebar.AbsolutePosition, huebar.AbsoluteSize
						hue = math.clamp((pos.Y - abs.Y) / math.max(size.Y, 1), 0, 1)
						commit(true, true)
					end
				end

				local function isdown(input)
					return input.UserInputType == Enum.UserInputType.MouseButton1
						or input.UserInputType == Enum.UserInputType.Touch
				end

				svhit.InputBegan:Connect(function(input)
					if not isdown(input) then
						return
					end
					dragging = "sv"
					drag(input)
				end)
				huehit.InputBegan:Connect(function(input)
					if not isdown(input) then
						return
					end
					dragging = "hue"
					drag(input)
				end)

				trackConnection(
					sv.uis.InputChanged:Connect(function(input)
						if
							dragging
							and (
								input.UserInputType == Enum.UserInputType.MouseMovement
								or input.UserInputType == Enum.UserInputType.Touch
							)
						then
							drag(input)
						end
					end),
					"colorpicker.changed." .. configkey
				)
				trackConnection(
					sv.uis.InputEnded:Connect(function(input)
						if dragging and isdown(input) then
							dragging = nil
						end
					end),
					"colorpicker.ended." .. configkey
				)

				hexbox.FocusLost:Connect(function()
					local color = parsecolor(hexbox.Text)
					if color then
						setcolor(color, true)
					else
						render()
					end
				end)

				swatch.Activated:Connect(function()
					colorfunc:SetOpen(not colorfunc.Opened)
				end)

				local saved = config.data[configkey]
				local startcolor = parsecolor(saved) or hubdefault
				do
					local h, s, v = startcolor:ToHSV()
					hue, sat, val = h, s, v
				end
				commit(true, false)

				countitem = countitem + 1
				yieldbuild()
				config.elements[configkey] = colorfunc
				registerSearchItem(colorconfig.Title, row, "Color")
				return colorfunc
			end

			items.AddColorpicker = items.AddColorPicker
			items.AddColor = items.AddColorPicker

			function items:AddKeybind(keybindconfig)
				keybindconfig = keybindconfig or {}
				keybindconfig.Title = keybindconfig.Title or keybindconfig.Name or "Keybind"
				keybindconfig.Callback = keybindconfig.Callback or function() end
				local changedcallback = keybindconfig.ChangedCallback or keybindconfig.OnChanged or function() end

				local configkey = keyfor("Keybind_", keybindconfig)
				local mode = tostring(keybindconfig.Mode or "Press"):lower()
				if mode ~= "toggle" and mode ~= "hold" then
					mode = "press"
				end
				local hubdefault = resolvekey(keybindconfig.Default)


				local keybindfunc = { Value = nil, Mode = mode, State = false, DefaultValue = hubdefault, Listening = false }

				local row = instance.frame(sectionadd)
				row.Name = "Keybind"
				row.BorderSizePixel = 0
				row.LayoutOrder = countitem
				row.Size = UDim2.new(1, 0, 0, 46)
				roundbg(row, 4, theme.Row)

				local title = instance.textlabel(row)
				title.Name = "KeybindTitle"
				title.Font = Enum.Font.GothamMedium
				title.Text = tostring(keybindconfig.Title)
				title.TextSize = 12
				title.TextColor3 = theme.Text
				title.TextXAlignment = Enum.TextXAlignment.Left
				title.TextYAlignment = Enum.TextYAlignment.Top
				title.TextTruncate = Enum.TextTruncate.AtEnd
				title.BackgroundTransparency = 1
				title.Position = UDim2.new(0, 10, 0, 15)
				title.Size = UDim2.new(1, -100, 0, 13)

				local chip = instance.textbutton(row)
				chip.Name = "KeyChip"
				chip.AnchorPoint = Vector2.new(1, 0.5)
				chip.Position = UDim2.new(1, -12, 0.5, 0)
				chip.Size = UDim2.new(0, 56, 0, 24)
				chip.AutoButtonColor = false
				chip.Font = Enum.Font.GothamBold
				chip.Text = ""
				chip.TextSize = 12
				chip.TextColor3 = theme.Text
				chip.BackgroundColor3 = theme.Field
				chip.BackgroundTransparency = 0
				chip.BorderSizePixel = 0
				instance.uicorner(chip).CornerRadius = UDim.new(0, 5)
				local chipstroke = instance.uistroke(chip)
				chipstroke.Color = Color3.fromRGB(255, 255, 255)
				chipstroke.Thickness = 1
				chipstroke.Transparency = 0.9

				local basey = 46
				local description = contenttext(keybindconfig)
				local ix = elementiconx(keybindconfig)
				iconapi(keybindfunc, elementicon(row, keybindconfig.Icon, description and 15.5 or 21.5))
				title.Position = UDim2.new(0, ix, 0, description and 9 or 15)
				title.Size = UDim2.new(1, -(ix + 90), 0, 13)
				if description then
					title.Position = UDim2.new(0, ix, 0, 9)
					local _, measure = attachcontent(row, description, ix, 26, 96)
					local function relayout()
						basey = math.max(46, 26 + measure() + 10)
						row.Size = UDim2.new(1, 0, 0, basey)
					end
					relayout()
					watchwidth(row, relayout)
				end

				local listengen = 0
				local hovering = false

				local function chipwidth(text)
					local okm, bounds = pcall(function()
						return sv.textservice:GetTextSize(text, 12, Enum.Font.GothamBold, Vector2.new(300, 24))
					end)
					return math.max(46, ((okm and bounds) and math.ceil(bounds.X) or 30) + 22)
				end

				local function render(instant)
					local text, textcolor, strokecolor, stroketrans
					if keybindfunc.Listening then
						text, textcolor, strokecolor, stroketrans = "...", guiconfig.Color, guiconfig.Color, 0
					elseif keybindfunc.Value then
						text, textcolor = keyname(keybindfunc.Value), theme.Text
						strokecolor, stroketrans = Color3.fromRGB(255, 255, 255), 0.9
					else
						text, textcolor = "None", theme.Dim
						strokecolor, stroketrans = Color3.fromRGB(255, 255, 255), 0.9
					end
					chip.Text = text
					local size = UDim2.new(0, chipwidth(text), 0, 24)
					local bg = hovering and theme.InnerHover or theme.Field
					if instant then
						chip.TextColor3 = textcolor
						chip.Size = size
						chip.BackgroundColor3 = bg
						chipstroke.Color = strokecolor
						chipstroke.Transparency = stroketrans
					else
						tw(chip, { TextColor3 = textcolor, Size = size, BackgroundColor3 = bg }, 0.2)
						tw(chipstroke, { Color = strokecolor, Transparency = stroketrans }, 0.2)
					end
				end

				local function setlistening(state)
					if keybindfunc.Listening == state then
						return
					end
					keybindfunc.Listening = state
					listengen = listengen + 1
					render(false)
					if state then
						local gen = listengen
						task.delay(8, function()
							if keybindfunc.Listening and listengen == gen then
								setlistening(false)
							end
						end)
					end
				end

				local function apply(key, instant, save, notify)
					keybindfunc.Value = key
					keybindfunc.State = false
					if save then
						config.data[configkey] = key and key.Name or "None"
					end
					render(instant)
					if notify then
						elevate()
						local ok, err = pcall(changedcallback, key)
						if not ok then
							warn("Keybind ChangedCallback error:", err)
						end
					end
				end

				local function fire(...)
					elevate()
					local ok, err = pcall(keybindconfig.Callback, ...)
					if not ok then
						warn("Keybind Callback error:", err)
					end
				end

				local function savedpref()
					local saved = config.data[configkey]
					if saved ~= nil then
						return resolvekey(saved)
					end
					return hubdefault
				end

				function keybindfunc:Set(value, instant)
					setlistening(false)
					apply(resolvekey(value), instant, true, true)
				end

				function keybindfunc:LoadValue(value)
					self:Set(value, true)
				end

				function keybindfunc:ResetValue()
					self:Set(hubdefault)
				end

				function keybindfunc:Get()
					return keybindfunc.Value
				end

				function keybindfunc:GetName()
					return keyname(keybindfunc.Value)
				end

				function keybindfunc:GetState()
					return keybindfunc.State
				end

				function keybindfunc:SetMode(newmode)
					newmode = tostring(newmode or ""):lower()
					if newmode == "toggle" or newmode == "hold" or newmode == "press" then
						mode = newmode
						keybindfunc.Mode = newmode
						keybindfunc.State = false
					end
				end

				chip.Activated:Connect(function()
					setlistening(not keybindfunc.Listening)
				end)

				chip.MouseEnter:Connect(function()
					hovering = true
					tw(chip, { BackgroundColor3 = theme.InnerHover }, 0.15)
				end)

				chip.MouseLeave:Connect(function()
					hovering = false
					tw(chip, { BackgroundColor3 = theme.Field }, 0.2)
				end)

				local holding = false

				trackConnection(
					sv.uis.InputBegan:Connect(function(input, processed)
						if not row.Parent then
							return
						end
						if keybindfunc.Listening then
							local picked = nil
							if input.UserInputType == Enum.UserInputType.Keyboard then
								if input.KeyCode == Enum.KeyCode.Escape then
									setlistening(false)
									return
								elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
									setlistening(false)
									apply(nil, false, true, true)
									return
								end
								picked = resolvekey(input.KeyCode)
							elseif
								input.UserInputType == Enum.UserInputType.MouseButton2
								or input.UserInputType == Enum.UserInputType.MouseButton3
							then
								picked = input.UserInputType
							end
							if picked then
								setlistening(false)
								apply(picked, false, true, true)
							end
							return
						end
						if processed or not inputmatches(input, keybindfunc.Value) then
							return
						end
						if mode == "toggle" then
							keybindfunc.State = not keybindfunc.State
							fire(keybindfunc.State)
						elseif mode == "hold" then
							holding = true
							fire(true)
						else
							fire(keybindfunc.Value)
						end
					end),
					"keybind.began." .. configkey
				)

				trackConnection(
					sv.uis.InputEnded:Connect(function(input)
						if holding and inputmatches(input, keybindfunc.Value) then
							holding = false
							fire(false)
						end
					end),
					"keybind.ended." .. configkey
				)

				apply(savedpref(), true, true, false)

				countitem = countitem + 1
				yieldbuild()
				config.elements[configkey] = keybindfunc
				registerSearchItem(keybindconfig.Title, row, "Keybind")
				return keybindfunc
			end

			items.AddKeyPicker = items.AddKeybind
			items.AddBind = items.AddKeybind

			function items:AddToggle(toggleconfig)
				toggleconfig = toggleconfig or {}
				toggleconfig.Title = toggleconfig.Title or "Title"
				toggleconfig.Callback = toggleconfig.Callback or function() end

				local configkey = keyfor("Toggle_", toggleconfig)
				local toggletween = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				local hubdefault = toggleconfig.Default and true or false
				local function savedpref()
					local v = config.data[configkey]
					if v ~= nil then
						return v == true
					end
					if config.loaded then
						return false
					end
					return hubdefault
				end

				local togglefunc = { Value = false, DefaultValue = hubdefault }

				local toggle = templates.Toggle:Clone()
				toggle.LayoutOrder = countitem
				toggle.Parent = sectionadd

				local toggletitle = toggle.ToggleTitle
				toggletitle.Text = toggleconfig.Title

				local togglebutton = toggle.ToggleButton
				local featureframe2 = toggle.FeatureFrame
				local uistroke8 = featureframe2.UIStroke
				local togglecircle = featureframe2.ToggleCircle

				local rowh = toggle.Size.Y.Offset
				local basey = rowh
				local description = contenttext(toggleconfig)
				local ix = elementiconx(toggleconfig)
				iconapi(togglefunc, elementicon(toggle, toggleconfig.Icon, description and 15.5 or math.floor(rowh / 2)))
				local haskey = toggleconfig.Keybind ~= false and (toggleconfig.Keybind ~= nil or guiconfig.ToggleKeybinds == true)
				local keyextra = haskey and 60 or 0
				toggletitle.Position = UDim2.new(0, ix, 0, description and 8 or math.floor((rowh - 13) / 2))
				toggletitle.Size = UDim2.new(1, -(ix + 60 + keyextra), 0, 13)
				if description then
					toggletitle.Position = UDim2.new(0, ix, 0, 8)
					local _, measure = attachcontent(toggle, description, ix, 24, 62 + keyextra)
					local function relayout()
						basey = math.max(rowh, 24 + measure() + 9)
						toggle.Size = UDim2.new(1, 0, 0, basey)
					end
					relayout()
					watchwidth(toggle, relayout)
				end

				local function render(value, instant)
					elevate()
					local titleColor = value and theme.Text or theme.OffText
					local circleColor = value and theme.KnobOn or theme.KnobOff

					local knob = togglecircle.Size.X.Offset
					local gap = math.floor((featureframe2.Size.Y.Offset - knob) / 2)
					local circlePosition = value and UDim2.new(0, featureframe2.Size.X.Offset - knob - gap, 0, gap)
						or UDim2.new(0, gap, 0, gap)
					local strokeColor = value and theme.ToggleOn or theme.ToggleOffStroke
					local strokeTransparency = 0
					local backgroundColor = value and theme.ToggleOn or theme.ToggleOff
					local backgroundTransparency = 0

					if instant then
						toggletitle.TextColor3 = titleColor
						togglecircle.Position = circlePosition
						togglecircle.BackgroundColor3 = circleColor
						uistroke8.Color = strokeColor
						uistroke8.Transparency = strokeTransparency
						featureframe2.BackgroundColor3 = backgroundColor
						featureframe2.BackgroundTransparency = backgroundTransparency
					else
						sv.ts:Create(toggletitle, toggletween, { TextColor3 = titleColor }):Play()
						sv.ts
							:Create(togglecircle, toggletween, {
								Position = circlePosition,
								BackgroundColor3 = circleColor,
							})
							:Play()
						sv.ts
							:Create(uistroke8, toggletween, {
								Color = strokeColor,
								Transparency = strokeTransparency,
							})
							:Play()
						sv.ts
							:Create(featureframe2, toggletween, {
								BackgroundColor3 = backgroundColor,
								BackgroundTransparency = backgroundTransparency,
							})
							:Play()
					end
				end

				local function apply(value, instant, save, fire)
					elevate()
					togglefunc.Value = value
					if save then
						config.data[configkey] = value
					end

					render(value, instant)
					if fire and typeof(toggleconfig.Callback) == "function" then
						task.spawn(function()
							elevate()
							local ok, err = pcall(toggleconfig.Callback, value)
							if not ok then
								warn("Toggle Callback error:", err)
							end
						end)
					end
				end

				togglebutton.Activated:Connect(function()
					togglefunc:Set(not togglefunc.Value)
				end)

				function togglefunc:Set(value, instant)
					apply(value and true or false, instant, true, true)
				end

				function togglefunc:LoadValue(value)
					self:Set(value, true)
				end

				function togglefunc:ResetValue()
					self:Set(hubdefault)
				end

				local keychip
				if haskey then
					local keyopt = toggleconfig.Keybind
					if type(keyopt) ~= "table" then
						keyopt = { Default = keyopt }
					end
					local keycfgkey = "ToggleKey_" .. configkey
					local keydefault = resolvekey(keyopt.Default)
					local savedkey = config.data[keycfgkey]
					local boundkey = savedkey ~= nil and resolvekey(savedkey) or keydefault
					local listening = false
					local listengen = 0
					local switchwidth = featureframe2.Size.X.Offset > 0 and featureframe2.Size.X.Offset or 32

					keychip = instance.textbutton(toggle)
					keychip.Name = "KeyChip"
					keychip.AnchorPoint = Vector2.new(1, 0.5)
					keychip.Position = UDim2.new(1, -(12 + switchwidth + 8), 0.5, 0)
					keychip.Size = UDim2.new(0, 40, 0, 20)
					keychip.AutoButtonColor = false
					keychip.Font = Enum.Font.GothamMedium
					keychip.TextSize = 10
					keychip.Text = ""
					keychip.BackgroundColor3 = theme.Field
					keychip.BorderSizePixel = 0
					instance.uicorner(keychip).CornerRadius = UDim.new(0, 5)
					local keystroke = instance.uistroke(keychip)
					keystroke.Color = Color3.fromRGB(255, 255, 255)
					keystroke.Thickness = 1
					keystroke.Transparency = 0.9

					local function renderkey()
						local text, color
						if listening then
							text, color = "...", guiconfig.Color
						elseif boundkey then
							text, color = keyname(boundkey), theme.Text
						else
							text, color = "None", theme.Dim
						end
						keychip.Text = text
						keychip.TextColor3 = color
						local okm, bounds = pcall(function()
							return sv.textservice:GetTextSize(text, 10, Enum.Font.GothamMedium, Vector2.new(200, 20))
						end)
						keychip.Size = UDim2.new(0, math.max(34, ((okm and bounds) and math.ceil(bounds.X) or 24) + 14), 0, 20)
					end

					local function bindkey(key)
						boundkey = key
						config.data[keycfgkey] = key and key.Name or "None"
						renderkey()
					end

					local function setlistening(state)
						if listening == state then
							return
						end
						listening = state
						listengen = listengen + 1
						renderkey()
						if state then
							local gen = listengen
							task.delay(8, function()
								if listening and listengen == gen then
									setlistening(false)
								end
							end)
						end
					end

					keychip.Activated:Connect(function()
						setlistening(not listening)
					end)

					trackConnection(
						sv.uis.InputBegan:Connect(function(input, processed)
							if not toggle.Parent then
								return
							end
							if listening then
								if input.UserInputType == Enum.UserInputType.Keyboard then
									if input.KeyCode == Enum.KeyCode.Escape then
										setlistening(false)
									elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
										setlistening(false)
										bindkey(nil)
									else
										setlistening(false)
										bindkey(resolvekey(input.KeyCode))
									end
								elseif
									input.UserInputType == Enum.UserInputType.MouseButton2
									or input.UserInputType == Enum.UserInputType.MouseButton3
								then
									setlistening(false)
									bindkey(input.UserInputType)
								end
								return
							end
							if processed or not boundkey or not inputmatches(input, boundkey) then
								return
							end
							togglefunc:Set(not togglefunc.Value)
						end),
						"togglekey.began." .. configkey
					)

					renderkey()
				end

				apply(savedpref(), true, true, true)

				countitem = countitem + 1
				yieldbuild()
				config.elements[configkey] = togglefunc
				registerSearchItem(toggleconfig.Title, toggle, "Toggle")
				return togglefunc
			end

			function items:AddSlider(sliderconfig)
				sliderconfig = sliderconfig or {}
				sliderconfig.Title = sliderconfig.Title or sliderconfig.Name or "Slider"
				sliderconfig.Increment = tonumber(sliderconfig.Increment) or 1
				sliderconfig.Min = tonumber(sliderconfig.Min) or 0
				sliderconfig.Max = tonumber(sliderconfig.Max) or 100
				sliderconfig.Default = tonumber(sliderconfig.Default) or sliderconfig.Min
				sliderconfig.Callback = sliderconfig.Callback or function() end

				local configkey = keyfor("Slider_", sliderconfig)

				local function getprecision(step)
					local s = tostring(step)
					if s:find("e") or s:find("E") then
						s = string.format("%.12f", step):gsub("0+$", ""):gsub("%.$", "")
					end

					local dot = s:find("%.")
					return dot and (#s - dot) or 0
				end

				local precision = tonumber(sliderconfig.Precision) or getprecision(sliderconfig.Increment)
				local suffix = tostring(sliderconfig.Suffix or "")

				local function roundtoincrement(value)
					local step = sliderconfig.Increment
					return math.floor((value / step) + 0.5) * step
				end

				local function formatnumber(value)
					value = tonumber(string.format("%." .. precision .. "f", value)) or 0

					if precision > 0 then
						return string.format("%." .. precision .. "f", value):gsub("0+$", ""):gsub("%.$", "")
					end

					return tostring(math.floor(value + 0.5))
				end

				local function clampvalue(value)
					value = tonumber(value) or sliderconfig.Min
					value = math.clamp(value, sliderconfig.Min, sliderconfig.Max)
					value = roundtoincrement(value)
					value = math.clamp(value, sliderconfig.Min, sliderconfig.Max)
					value = tonumber(string.format("%." .. precision .. "f", value)) or sliderconfig.Min
					return value
				end

				local hubdefault = clampvalue(sliderconfig.Default)
				local haspref = config.data[configkey] ~= nil
				local function savedpref()
					local v = tonumber(config.data[configkey])
					return v and clampvalue(v) or hubdefault
				end

				local sliderfunc = {
					Value = savedpref(),
					DefaultValue = hubdefault,
				}

				local slider = templates.Slider:Clone()
				slider.LayoutOrder = countitem
				slider.Parent = sectionadd

				local slidertitle = slider.SliderTitle
				slidertitle.Text = sliderconfig.Title

				local inputholder = slider.SliderInputHolder
				local textbox = inputholder.SliderInput

				local sliderframe = slider.SliderBar
				local sliderfill = sliderframe.SliderFill
				local slidercircle = sliderframe.SliderCircle
				local circlestroke = slidercircle.UIStroke
				local bubble = sliderframe.ValueBubble
				local bubbletext = bubble.BubbleText

				local basey = 58
				local description = contenttext(sliderconfig)
				local ix = elementiconx(sliderconfig)
				iconapi(sliderfunc, elementicon(slider, sliderconfig.Icon, 17))
				slidertitle.Position = UDim2.new(0, ix, 0, 7)
				slidertitle.Size = UDim2.new(1, -(ix + 48), 0, 20)
				if description then
					local _, measure = attachcontent(slider, description, ix, 31, 20)
					local function relayout()
						local bary = 31 + measure() + 8
						sliderframe.Position = UDim2.new(0, 10, 0, bary)
						basey = bary + 19
						slider.Size = UDim2.new(1, 0, 0, basey)
					end
					relayout()
					watchwidth(slider, relayout)
				end

				local dragging = false
				local setting = false

				local function getpercent(value)
					if sliderconfig.Max == sliderconfig.Min then
						return 0
					end

					return math.clamp((value - sliderconfig.Min) / (sliderconfig.Max - sliderconfig.Min), 0, 1)
				end

				local function updatebubble(percent, value)
					bubble.Position = UDim2.new(percent, 0, 0, -10)
					bubbletext.Text = tostring(value)
				end

				local function showbubble()
					bubble.Visible = true

					sv.ts
						:Create(slidercircle, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(0, 14, 0, 14),
						})
						:Play()

					sv.ts
						:Create(bubble, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							BackgroundTransparency = 0.15,
							Size = UDim2.new(0, 48, 0, 22),
						})
						:Play()
				end

				local function hidebubble()
					sv.ts
						:Create(slidercircle, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(0, 12, 0, 12),
						})
						:Play()

					sv.ts
						:Create(bubble, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(0, 48, 0, 22),
						})
						:Play()

					task.delay(0.15, function()
						if not dragging then
							bubble.Visible = false
						end
					end)
				end

				local filltween, circletween
				local lastfired = nil
				local lastcall, pendingvalue, flushqueued = 0, nil, false

				local function cancelvisual()
					if filltween then
						filltween:Cancel()
						filltween = nil
					end
					if circletween then
						circletween:Cancel()
						circletween = nil
					end
				end

				local function apply(value, fire, save)
					elevate()
					value = clampvalue(value)

					sliderfunc.Value = value
					if save then
						config.data[configkey] = value
					end

					local percent = getpercent(value)
					local formatted = formatnumber(value)

					setting = true
					textbox.Text = formatted
					setting = false

					updatebubble(percent, formatted .. suffix)

					if dragging then

						cancelvisual()
						sliderfill.Size = UDim2.new(percent, 0, 1, 0)
						slidercircle.Position = UDim2.new(percent, 0, 0.5, 0)
					else
						cancelvisual()
						local info = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
						filltween = sv.ts:Create(sliderfill, info, { Size = UDim2.new(percent, 0, 1, 0) })
						circletween = sv.ts:Create(slidercircle, info, { Position = UDim2.new(percent, 0, 0.5, 0) })
						filltween:Play()
						circletween:Play()
					end

					if fire and typeof(sliderconfig.Callback) == "function" then

						if dragging and lastfired == value then
							return
						end
						if dragging and (tick() - lastcall) < 0.06 then
							pendingvalue = value
							if not flushqueued then
								flushqueued = true
								task.delay(0.07, function()
									flushqueued = false
									if pendingvalue ~= nil then
										local v = pendingvalue
										pendingvalue = nil
										lastfired = v
										lastcall = tick()
										task.spawn(function()
											elevate()
											local okf, errf = pcall(sliderconfig.Callback, v)
											if not okf then
												warn("Slider Callback error:", errf)
											end
										end)
									end
								end)
							end
							return
						end
						pendingvalue = nil
						lastfired = value
						lastcall = tick()
						task.spawn(function()
							elevate()
							local ok, err = pcall(sliderconfig.Callback, value)
							if not ok then
								warn("Slider Callback error:", err)
							end
						end)
					end
				end

				local function setfromx(x)
					local width = math.max(sliderframe.AbsoluteSize.X, 1)
					local percent = math.clamp((x - sliderframe.AbsolutePosition.X) / width, 0, 1)
					local value = sliderconfig.Min + ((sliderconfig.Max - sliderconfig.Min) * percent)

					sliderfunc:Set(value)
				end

				function sliderfunc:Set(value, nocallback)
					apply(value, not nocallback, true)
				end

				function sliderfunc:LoadValue(value)
					self:Set(value, false)
				end

				function sliderfunc:ResetValue()
					self:Set(hubdefault)
				end

				local function startdrag(input)
					if
						input.UserInputType == Enum.UserInputType.MouseButton1
						or input.UserInputType == Enum.UserInputType.Touch
					then
						dragging = true
						showbubble()
						setfromx(input.Position.X)
						sliderDrag.active = {
							input = input,
							setfromx = setfromx,
							hidebubble = function()
								dragging = false
								hidebubble()
							end,
						}
					end
				end

				sliderframe.InputBegan:Connect(startdrag)
				slidercircle.InputBegan:Connect(startdrag)

				local grab = instance.frame(sliderframe)
				grab.Name = "GrabArea"
				grab.AnchorPoint = Vector2.new(0.5, 0.5)
				grab.BackgroundTransparency = 1
				grab.BorderSizePixel = 0
				grab.Position = UDim2.new(0.5, 0, 0.5, 0)
				grab.Size = UDim2.new(1, 14, 0, isMobile and 32 or 22)
				grab.Active = true
				grab.ZIndex = 3
				grab.InputBegan:Connect(startdrag)

				textbox.Focused:Connect(function()
					showbubble()
				end)

				textbox.FocusLost:Connect(function()
					if setting then
						return
					end

					local text = textbox.Text:gsub(",", ".")
					local value = tonumber(text)

					if value then
						sliderfunc:Set(value)
					else
						textbox.Text = formatnumber(sliderfunc.Value)
					end

					hidebubble()
				end)

				apply(sliderfunc.Value, haspref, true)

				countitem = countitem + 1
				yieldbuild()
				config.elements[configkey] = sliderfunc
				registerSearchItem(sliderconfig.Title, slider, "Slider")
				return sliderfunc
			end

			function items:AddInput(inputconfig)
				inputconfig = inputconfig or {}
				inputconfig.Title = inputconfig.Title or "Title"
				inputconfig.Placeholder = inputconfig.Placeholder or "Write your input here"
				inputconfig.Callback = inputconfig.Callback or function() end

				local configkey = keyfor("Input_", inputconfig)
				local hubdefault = tostring(inputconfig.Default or "")
				local nosave = inputconfig.NoSave == true
				local function savedpref()
					if nosave then
						return hubdefault
					end
					local v = config.data[configkey]
					if v ~= nil then
						return tostring(v)
					end
					if config.loaded and not metakeys[configkey] then
						return ""
					end
					return hubdefault
				end

				local inputfunc = { Value = savedpref(), DefaultValue = hubdefault }

				local inputcontainer = instance.frame(sectionadd)
				inputcontainer.BorderSizePixel = 0
				inputcontainer.LayoutOrder = countitem
				inputcontainer.Size = UDim2.new(1, 0, 0, 58)
				roundbg(inputcontainer, 4, theme.Row)

				local inputtitle = instance.textlabel(inputcontainer)
				inputtitle.Font = Enum.Font.GothamMedium
				inputtitle.Text = inputconfig.Title
				inputtitle.TextSize = 12
				inputtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				inputtitle.TextXAlignment = Enum.TextXAlignment.Left
				inputtitle.BackgroundTransparency = 1
				inputtitle.Position = UDim2.new(0, 10, 0, 6)
				inputtitle.Size = UDim2.new(1, -20, 0, 14)
				inputtitle.TextTruncate = Enum.TextTruncate.AtEnd

				local inputtextbox = instance.textbox(inputcontainer)
				inputtextbox.Font = Enum.Font.GothamBold
				inputtextbox.PlaceholderText = inputconfig.Placeholder
				inputtextbox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
				inputtextbox.TextTransparency = 0.4
				inputtextbox.Text = inputfunc.Value
				inputtextbox.TextSize = 11
				inputtextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
				inputtextbox.BackgroundColor3 = theme.Field
				inputtextbox.BackgroundTransparency = 0
				inputtextbox.TextXAlignment = Enum.TextXAlignment.Left
				inputtextbox.ClearTextOnFocus = false
				inputtextbox.Position = UDim2.new(0, 10, 0, 26)
				inputtextbox.Size = UDim2.new(1, -20, 0, 24)
				inputtextbox.ClipsDescendants = true
				inputtextbox.TextTruncate = Enum.TextTruncate.AtEnd

				local padding = instance.uipadding(inputtextbox)
				padding.PaddingLeft = UDim.new(0, 4)

				local basey = 58
				local description = contenttext(inputconfig)
				local ix = elementiconx(inputconfig)
				iconapi(inputfunc, elementicon(inputcontainer, inputconfig.Icon, 13))
				inputtitle.Position = UDim2.new(0, ix, 0, 6)
				inputtitle.Size = UDim2.new(1, -(ix + 10), 0, 14)
				if description then
					local _, measure = attachcontent(inputcontainer, description, ix, 23, 10)
					local function relayout()
						local boxy = 23 + measure() + 5
						inputtextbox.Position = UDim2.new(0, 10, 0, boxy)
						basey = boxy + 32
						inputcontainer.Size = UDim2.new(1, 0, 0, basey)
					end
					relayout()
					watchwidth(inputcontainer, relayout)
				end

				inputtextbox.Focused:Connect(function()
					inputtextbox.CursorPosition = #inputtextbox.Text + 1
				end)

				local suppress = false
				local function applyinput(value, fire, save)
					elevate()
					value = tostring(value == nil and "" or value)
					inputfunc.Value = value
					suppress = true
					inputtextbox.Text = value
					suppress = false
					if save and not nosave then
						config.data[configkey] = value
					end
					if fire and typeof(inputconfig.Callback) == "function" then
						elevate()
						local ok, err = pcall(inputconfig.Callback, value)
						if not ok then
							warn("Input Callback error:", err)
						end
					end
				end

				function inputfunc:Set(value)
					applyinput(value, true, true)
				end

				function inputfunc:LoadValue(value)
					self:Set(value)
				end

				function inputfunc:ResetValue()
					self:Set(hubdefault)
				end

				inputtextbox:GetPropertyChangedSignal("Text"):Connect(function()
					if suppress then
						return
					end
					inputfunc.Value = inputtextbox.Text
					if not nosave then
						config.data[configkey] = inputtextbox.Text
					end
				end)

				inputtextbox.FocusLost:Connect(function()
					inputfunc:Set(inputtextbox.Text)
				end)

				applyinput(inputfunc.Value, true, true)

				countitem = countitem + 1
				yieldbuild()
				if not nosave then
					config.elements[configkey] = inputfunc
				end
				registerSearchItem(inputconfig.Title, inputcontainer)
				return inputfunc
			end

			function items:AddDropdown(dropdownconfig)
				dropdownconfig = dropdownconfig or {}
				dropdownconfig.Title = dropdownconfig.Title or "Title"
				dropdownconfig.Multi = dropdownconfig.Multi or false
				dropdownconfig.Advanced = dropdownconfig.Advanced or false
				dropdownconfig.Options = dropdownconfig.Options or {}
				dropdownconfig.Callback = dropdownconfig.Callback or function() end
				local multi = dropdownconfig.Multi

				local function normalize(value)
					if multi then
						local out = {}
						if type(value) == "table" then
							for _, v in ipairs(value) do
								out[#out + 1] = v
							end
						end
						return out
					end
					if type(value) == "table" then
						return value[1]
					end
					if value == "" then
						return nil
					end
					return value
				end

				local function sameselection(a, b)
					if multi then
						if #a ~= #b then
							return false
						end
						for i = 1, #a do
							if a[i] ~= b[i] then
								return false
							end
						end
						return true
					end
					return a == b
				end

				local configkey = keyfor("Dropdown_", dropdownconfig)
				local hubdefault = normalize(dropdownconfig.Default)
				local function savedpref()
					local v = config.data[configkey]
					if v ~= nil then
						return normalize(v)
					end
					if config.loaded then
						return normalize(nil)
					end
					return normalize(hubdefault)
				end

				local dropdownfunc = {
					Value = savedpref(),
					Options = dropdownconfig.Options,
					DefaultValue = normalize(hubdefault),
				}

				local function parseOption(option)
					local label, desc, img, value

					if typeof(option) == "table" then
						if option.Label and option.Value ~= nil then
							label = tostring(option.Label)
							value = option.Value
							desc = option.Description or option.Desc or option[2]
							img = option.Image or option.Icon or option[3]
						else
							label = tostring(option[1] or option.Title or option.Name or "Option")
							desc = option[2] or option.Description or option.Desc
							img = option[3] or option.Image or option.Icon
							value = option.Value ~= nil and option.Value or label
						end
					else
						label = tostring(option)
						value = option
					end

					if img and type(img) == "number" then
						img = "rbxassetid://" .. tostring(img)
					elseif img and type(img) == "string" and img ~= "" and not img:find("rbxassetid://") then
						img = "rbxassetid://" .. img
					end

					return label, desc, img, value
				end

				local dropdown = instance.frame(sectionadd)
				dropdown.Name = "Dropdown"
				dropdown.BorderSizePixel = 0
				dropdown.LayoutOrder = countitem
				dropdown.Size = UDim2.new(1, 0, 0, 60)
				roundbg(dropdown, 4, theme.Row)

				local dropdownbutton = instance.textbutton(dropdown)
				dropdownbutton.Name = "ToggleButton"
				dropdownbutton.Text = ""
				dropdownbutton.BackgroundTransparency = 1
				dropdownbutton.Size = UDim2.new(1, 0, 1, 0)

				local dropdowntitle = instance.textlabel(dropdown)
				dropdowntitle.Name = "DropdownTitle"
				dropdowntitle.Font = Enum.Font.GothamMedium
				dropdowntitle.Text = dropdownconfig.Title
				dropdowntitle.TextColor3 = theme.Text
				dropdowntitle.TextSize = 12
				dropdowntitle.TextXAlignment = Enum.TextXAlignment.Left
				dropdowntitle.TextYAlignment = Enum.TextYAlignment.Top
				dropdowntitle.TextTruncate = Enum.TextTruncate.AtEnd
				dropdowntitle.BackgroundTransparency = 1
				dropdowntitle.Position = UDim2.new(0, 10, 0, 8)
				dropdowntitle.Size = UDim2.new(1, -20, 0, 13)

				local selectoptionsframe = instance.frame(dropdown)
				selectoptionsframe.Name = "SelectOptionsFrame"
				selectoptionsframe.AnchorPoint = Vector2.new(0, 0)
				selectoptionsframe.Position = UDim2.new(0, 10, 0, 26)
				selectoptionsframe.Size = UDim2.new(1, -20, 0, 26)
				selectoptionsframe.LayoutOrder = countdropdown
				roundbg(selectoptionsframe, 5, Color3.fromRGB(15, 15, 18))

				local optionselecting = instance.textlabel(selectoptionsframe)
				optionselecting.Name = "OptionSelecting"
				optionselecting.Font = Enum.Font.GothamMedium
				optionselecting.Text = dropdownconfig.Multi and "Select Options" or "Select Option"
				optionselecting.TextColor3 = Color3.fromRGB(255, 255, 255)
				optionselecting.TextSize = 11
				optionselecting.TextTransparency = 0.5
				optionselecting.TextXAlignment = Enum.TextXAlignment.Left
				optionselecting.AnchorPoint = Vector2.new(0, 0.5)
				optionselecting.BackgroundTransparency = 1
				optionselecting.Position = UDim2.new(0, 9, 0.5, 0)
				optionselecting.Size = UDim2.new(1, -30, 1, -8)

				local optionimg = instance.imagelabel(selectoptionsframe)
				optionimg.Name = "OptionImg"
				applyicon(optionimg, "chevron-down", 48)
				optionimg.ImageColor3 = theme.Text
				optionimg.AnchorPoint = Vector2.new(0.5, 0.5)
				optionimg.BackgroundTransparency = 1
				optionimg.Position = UDim2.new(1, -14, 0.5, 0)
				optionimg.Rotation = 0
				optionimg.Size = UDim2.new(0, 16, 0, 16)

				local basey = 60
				local description = contenttext(dropdownconfig)
				local ix = elementiconx(dropdownconfig)
				iconapi(dropdownfunc, elementicon(dropdown, dropdownconfig.Icon, 16))
				dropdowntitle.Position = UDim2.new(0, ix, 0, 8)
				dropdowntitle.Size = UDim2.new(1, -(ix + 10), 0, 13)
				if description then
					local _, measure = attachcontent(dropdown, description, ix, 25, 10)
					local function relayout()
						local fieldy = 25 + measure() + 6
						selectoptionsframe.Position = UDim2.new(0, 10, 0, fieldy)
						basey = fieldy + 26 + 8
						dropdown.Size = UDim2.new(1, 0, 0, basey)
					end
					relayout()
					watchwidth(dropdown, relayout)
				end

				local dropdowncontainer = instance.frame(dropdownfolder)
				dropdowncontainer.Size = UDim2.new(1, 0, 1, 0)
				dropdowncontainer.BackgroundTransparency = 1

				local searchbox = instance.textbox(dropdowncontainer)
				searchbox.Name = "SearchBox"
				searchbox.PlaceholderText = "Search"
				searchbox.Font = Enum.Font.GothamBold
				searchbox.Text = ""
				searchbox.TextSize = 12
				searchbox.TextColor3 = Color3.fromRGB(255, 255, 255)
				searchbox.BackgroundColor3 = theme.Element
				searchbox.BackgroundTransparency = 0
				searchbox.BorderSizePixel = 0
				searchbox.Size = UDim2.new(1, 0, 0, 25)
				searchbox.Position = UDim2.new(0, 0, 0, 0)
				searchbox.ClearTextOnFocus = false

				local scrollselect = instance.scrollingframe(dropdowncontainer)
				scrollselect.Name = "ScrollSelect"
				scrollselect.Size = UDim2.new(1, 0, 1, -30)
				scrollselect.Position = UDim2.new(0, 0, 0, 30)
				scrollselect.ScrollBarImageColor3 = theme.Track
				scrollselect.ScrollBarImageTransparency = 0.2
				scrollselect.BorderSizePixel = 0
				scrollselect.BackgroundTransparency = 1
				scrollselect.ScrollBarThickness = 3
				scrollselect.CanvasSize = UDim2.new(0, 0, 0, 0)

				local uilistlayout = instance.uilistlayout(scrollselect)
				uilistlayout.Padding = UDim.new(0, 3)
				uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder

				uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					scrollselect.CanvasSize = UDim2.new(0, 0, 0, math.ceil(uilistlayout.AbsoluteContentSize.Y / fitscaleof(scrollselect)))
				end)

				local optionlist = {}
				local built = false

				local function isselected(value)
					if multi then
						return table.find(dropdownfunc.Value, value) ~= nil
					end
					return dropdownfunc.Value ~= nil and dropdownfunc.Value == value
				end

				local function paint(entry, instant)
					local drop = entry.frame
					if not drop or not drop.Parent then
						return
					end
					local selected = isselected(entry.value)
					local targetSize = selected and UDim2.new(0, 1, 0, 12) or UDim2.new(0, 0, 0, 0)
					local targetStroke = selected and 0 or 1
					local targetBackground = selected and 0 or 1
					local stroke = drop.ChooseFrame:FindFirstChild("UIStroke")

					if instant then
						drop.ChooseFrame.Size = targetSize
						if stroke then
							stroke.Transparency = targetStroke
						end
						drop.Bg.ImageTransparency = targetBackground
					else
						local info = TweenInfo.new(selected and 0.2 or 0.1)
						sv.ts:Create(drop.ChooseFrame, info, { Size = targetSize }):Play()
						if stroke then
							sv.ts:Create(stroke, info, { Transparency = targetStroke }):Play()
						end
						sv.ts:Create(drop.Bg, info, { ImageTransparency = targetBackground }):Play()
					end
				end

				local function updatetext()
					local texts, matched = {}, {}
					for _, entry in ipairs(optionlist) do
						if isselected(entry.value) then
							texts[#texts + 1] = entry.label
							matched[entry.value] = true
						end
					end

					local picks = multi and dropdownfunc.Value or { dropdownfunc.Value }
					for _, v in ipairs(picks) do
						if v ~= nil and not matched[v] then
							texts[#texts + 1] = tostring(v)
						end
					end
					optionselecting.Text = (#texts == 0) and (multi and "Select Options" or "Select Option")
						or table.concat(texts, ", ")
				end

				local function fire()
					if typeof(dropdownconfig.Callback) ~= "function" then
						return
					end
					elevate()
					local ok, err
					if multi then
						ok, err = pcall(dropdownconfig.Callback, normalize(dropdownfunc.Value))
					else
						ok, err = pcall(dropdownconfig.Callback, dropdownfunc.Value ~= nil and tostring(dropdownfunc.Value) or "")
					end
					if not ok then
						warn("Dropdown Callback error:", err)
					end
				end

				local function apply(value, instant, save, dofire)
					elevate()
					dropdownfunc.Value = normalize(value)
					if save then
						config.data[configkey] = multi and normalize(dropdownfunc.Value) or dropdownfunc.Value
					end
					for _, entry in ipairs(optionlist) do
						paint(entry, instant)
					end
					updatetext()
					if dofire then
						fire()
					end
				end

				local searchvisible = false
				local function contentheight()
					local total, shown = 0, 0
					for _, entry in ipairs(optionlist) do
						if entry.frame and entry.frame.Visible then
							total = total + entry.frame.Size.Y.Offset + 3
							shown = shown + 1
						end
					end
					if shown == 0 then
						total = 33
					end
					return total - 3 + 8 + (searchvisible and 30 or 0)
				end

				local function applyfilter()
					if not built then
						return
					end
					local query = string.lower(searchbox.Text)
					for _, entry in ipairs(optionlist) do
						if entry.frame then
							entry.frame.Visible = query == ""
								or string.find(string.lower(entry.label), query, 1, true) ~= nil
								or (entry.desc ~= nil and string.find(string.lower(tostring(entry.desc)), query, 1, true) ~= nil)
						end
					end
					scrollselect.CanvasSize = UDim2.new(0, 0, 0, math.ceil(uilistlayout.AbsoluteContentSize.Y / fitscaleof(scrollselect)))
					refitdropdownpopup(selectoptionsframe, contentheight())
				end

				searchbox:GetPropertyChangedSignal("Text"):Connect(applyfilter)

				local function buildoption(entry)
					local useAdvanced = dropdownconfig.Advanced and (entry.desc or entry.img)
					local height = useAdvanced and 30 or (isMobile and 36 or 30)
					local leftPadding = entry.img and 42 or 8
					local textX = useAdvanced and math.max(8, leftPadding - 10) or leftPadding

					local optionframe = templates.DropdownOption:Clone()
					optionframe.Size = UDim2.new(1, 0, 0, height)
					optionframe.Parent = scrollselect

					local optionbutton = optionframe.OptionButton
					local optiontext = optionframe.OptionText
					optiontext.Text = entry.label
					optiontext.Position = UDim2.new(0, textX, 0, useAdvanced and 1 or math.floor((height - 13) / 2))
					optiontext.Size = UDim2.new(1, -(textX + 20), 0, 13)

					if entry.img then
						local icon = instance.imagelabel(optionframe)
						icon.Name = "OptionIcon"
						icon.Image = entry.img
						icon.BackgroundTransparency = 1
						icon.Position = UDim2.new(0, 8, 0.5, -14)
						icon.Size = UDim2.new(0, 28, 0, 28)
						icon.ScaleType = Enum.ScaleType.Fit
						instance.uicorner(icon).CornerRadius = UDim.new(0, 5)
					end

					if useAdvanced and entry.desc then
						local optiondesc = instance.textlabel(optionframe)
						optiondesc.Name = "OptionDesc"
						optiondesc.Font = Enum.Font.GothamBold
						optiondesc.Text = tostring(entry.desc)
						optiondesc.TextSize = 10
						optiondesc.TextTransparency = 0.3
						optiondesc.TextColor3 = Color3.fromRGB(255, 255, 255)
						optiondesc.Position = UDim2.new(0, textX, 0, 11)
						optiondesc.Size = UDim2.new(1, -(textX + 20), 0, 10)
						optiondesc.BackgroundTransparency = 1
						optiondesc.TextXAlignment = Enum.TextXAlignment.Left
						optiondesc.TextTruncate = Enum.TextTruncate.AtEnd
					end

					optionbutton.Activated:Connect(function()
						if multi then
							local sel = normalize(dropdownfunc.Value)
							local idx = table.find(sel, entry.value)
							if idx then
								table.remove(sel, idx)
							else
								table.insert(sel, entry.value)
							end
							apply(sel, false, true, true)
						else
							apply(entry.value, false, true, true)
							closedropdownpopup()
						end
					end)

					entry.frame = optionframe
				end

				local function buildall()
					if built then
						return
					end
					built = true
					for _, entry in ipairs(optionlist) do
						buildoption(entry)
						paint(entry, true)
					end
				end

				local function setoptions(list)
					for _, entry in ipairs(optionlist) do
						if entry.frame then
							entry.frame:Destroy()
						end
					end
					optionlist = {}
					for _, option in ipairs(list or {}) do
						local label, desc, img, value = parseOption(option)
						local entry = { label = label, desc = desc, img = img, value = value }
						optionlist[#optionlist + 1] = entry
						if built then
							buildoption(entry)
						end
					end
					dropdownfunc.Options = list or {}
				end

				dropdownbutton.Activated:Connect(function()
					buildall()

					searchvisible = #optionlist > 8
					searchbox.Text = ""
					searchbox.Visible = searchvisible
					scrollselect.Position = UDim2.new(0, 0, 0, searchvisible and 30 or 4)
					scrollselect.Size = UDim2.new(1, 0, 1, searchvisible and -30 or -8)
					applyfilter()
					opendropdownpopup(selectoptionsframe.LayoutOrder, selectoptionsframe, contentheight(), optionimg)
				end)

				function dropdownfunc:Clear()
					setoptions({})
					dropdownfunc.Value = normalize(nil)
					updatetext()
				end

				function dropdownfunc:AddOption(option)
					local label, desc, img, value = parseOption(option)
					local entry = { label = label, desc = desc, img = img, value = value }
					optionlist[#optionlist + 1] = entry
					if built then
						buildoption(entry)
						paint(entry, true)
						applyfilter()
					end
					updatetext()
				end

				function dropdownfunc:Set(value, instant)
					apply(value, instant, true, true)
				end

				function dropdownfunc:SetValue(val)
					self:Set(val)
				end

				function dropdownfunc:GetValue()
					return self.Value
				end

				function dropdownfunc:SetValues(newlist, selecting, instant)
					setoptions(newlist or {})
					apply(selecting, instant, true, true)
					applyfilter()
				end

				function dropdownfunc:Refresh(newlist, keep)
					setoptions(newlist or {})
					if keep == false then
						local cleared = normalize(nil)
						apply(cleared, true, true, not sameselection(normalize(dropdownfunc.Value), cleared))
					else
						apply(dropdownfunc.Value, true, false, false)
					end
					applyfilter()
				end

				function dropdownfunc:LoadValue(value)
					self:Set(value, true)
				end

				function dropdownfunc:ResetValue()
					self:Set(normalize(hubdefault))
				end

				setoptions(dropdownconfig.Options)
				apply(dropdownfunc.Value, true, true, true)

				countitem = countitem + 1
				countdropdown = countdropdown + 1
				yieldbuild()
				config.elements[configkey] = dropdownfunc
				registerSearchItem(dropdownconfig.Title, dropdown, "Dropdown")
				return dropdownfunc
			end
			function items:AddDivider()
				local divider = instance.frame(sectionadd)
				divider.Name = "Divider"
				divider.AnchorPoint = Vector2.new(0.5, 0)
				divider.Position = UDim2.new(0.5, 0, 0, 0)
				divider.Size = UDim2.new(1, 0, 0, 2)
				divider.BackgroundColor3 = guiconfig.Color
				divider.BackgroundTransparency = 0
				divider.BorderSizePixel = 0
				divider.LayoutOrder = countitem

				local gradient = instance.uigradient(divider)
				gradient.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.8),
					NumberSequenceKeypoint.new(0.5, 0),
					NumberSequenceKeypoint.new(1, 0.8),
				})

				instance.uicorner(divider).CornerRadius = UDim.new(0, 2)

				countitem = countitem + 1
				return divider
			end

			function items:AddSubSection(sectiontext)
				sectiontext = sectiontext or "Sub Section"

				local subsection = instance.frame(sectionadd)
				subsection.Name = "SubSection"
				subsection.BackgroundTransparency = 1
				subsection.Size = UDim2.new(1, 0, 0, 22)
				subsection.LayoutOrder = countitem

				local background = instance.frame(subsection)
				background.Size = UDim2.new(1, 0, 1, 0)
				background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				background.BackgroundTransparency = 1
				background.BorderSizePixel = 0
				instance.uicorner(background).CornerRadius = UDim.new(0, 6)

				local label = instance.textlabel(subsection)
				label.AnchorPoint = Vector2.new(0, 0.5)
				label.Position = UDim2.new(0, 10, 0.5, 0)
				label.Size = UDim2.new(1, -20, 1, 0)
				label.BackgroundTransparency = 1
				label.Font = Enum.Font.GothamBold
				label.Text = tostring(sectiontext)
				label.TextColor3 = theme.SubText
				label.TextSize = 13
				label.TextXAlignment = Enum.TextXAlignment.Left

				countitem = countitem + 1
				currentSubSection = tostring(sectiontext)
				return subsection
			end

			function items:AddConfigPanel()
				items:PromoteToFull()
				local selectedconfigname = config.current or ""
				local configdropdown

				local function setdropdownlist(dropdown, list)
					if dropdown and dropdown.Refresh then
						dropdown:Refresh(list)
					elseif dropdown and dropdown.SetValues then
						dropdown:SetValues(list, dropdown.Value)
					end
				end

				local function refreshconfiglist()
					setdropdownlist(configdropdown, config:getlist())
				end

				local saveparagraph = items:AddParagraph({
					Title = "Config Manager",
					Content = "Game: " .. tostring(config.game or "?") .. "  |  Profile: " .. (config.current or "None"),
				})

				local function updatestatus()
					saveparagraph:SetContent("Game: " .. tostring(config.game or "?") .. "  |  Profile: " .. (config.current or "None"))
				end

				local confignameinput = items:AddInput({
					Title = "Config Name",
					Placeholder = "Write config name here",
				})

				configdropdown = items:AddDropdown({
					Title = "Select Config",
					Multi = false,
					Options = config:getlist(),
					Callback = function(value)
						selectedconfigname = value or ""
						if selectedconfigname ~= "" then
							confignameinput:Set(selectedconfigname)
						end
					end,
				})

				items:AddButton({
					Title = "Save Config",
					SubTitle = "Load Config",
					Callback = function()
						local input = config.elements["Input_Config Name"]
						local name = input and input.Value or ""

						if name == "" then
							return
						end

						if config:save(name) then
							selectedconfigname = name
							refreshconfiglist()
							updatestatus()
						end
					end,
					SubCallback = function()
						if selectedconfigname == "" then
							return
						end

						if config:load(selectedconfigname) then
							updatestatus()
						end
					end,
				})

				items:AddButton({
					Title = "Delete Config",
					SubTitle = "Override Config",
					Callback = function()
						if selectedconfigname == "" then
							return
						end

						if config:delete(selectedconfigname) then
							selectedconfigname = ""

							if configdropdown then
								configdropdown:Refresh(config:getlist(), false)
							end
							updatestatus()
						end
					end,
					SubCallback = function()
						if selectedconfigname == "" then
							return
						end

						if config:save(selectedconfigname) then
							refreshconfiglist()
							updatestatus()
						end
					end,
				})

				items:AddSubSection("Auto-Load Configuration")

				local autostatus = items:AddParagraph({
					Title = "Auto Load Status",
					Content = "Auto Load: " .. (config:getautoload() or "None"),
				})

				items:AddButton({
					Title = "Set Auto Load",
					SubTitle = "Clear Auto Load",
					Callback = function()
						if selectedconfigname == "" then
							return
						end

						if config:setautoload(selectedconfigname) then
							autostatus:SetContent("Auto Load: " .. selectedconfigname)
						end
					end,
					SubCallback = function()
						if config:clearautoload() then
							autostatus:SetContent("Auto Load: None")
						end
					end,
				})

				items:AddSubSection("Folder Management")

				items:AddButton({
					Title = "Export Config",
					Callback = function()
						config.data._version = config.version
						local json = sv.http:JSONEncode(packconfig(config.data))

						clipboardwrite(json)
					end,
				})

				items:AddInput({
					Title = "External Config",
					Placeholder = "Paste raw JSON config here",
				})

				items:AddButton({
					Title = "Import Config",
					Callback = function()
						local input = config.elements["Input_External Config"]
						local json = input and input.Value

						if not json or json == "" then
							return
						end

						config:reset()

						local ok, err = pcall(function()
							config:loadexternal(json)
						end)

						if ok then
							updatestatus()
						else
							warn(err)
						end
					end,
				})

				items:AddSubSection("Reset Configuration")

				items:AddButton({
					Title = "Reset All To Default",
					Callback = function()
						config:reset()
						updatestatus()
					end,
				})

				return {
					UpdateStatus = updatestatus,
					RefreshList = refreshconfiglist,
				}
			end

			return items
		end

		if tabconfig.Hidden then
			return sections
		end

		if not buildingsystem then
			usertabcount = usertabcount + 1
			table.insert(usertabnames, tabconfig.Name)
		end
		counttab = counttab + 1

		local safename = tabconfig.Name:gsub("%s+", "_")
		if _G[safename] == nil then
			_G[safename] = sections
		end
		return sections
	end

	if guiconfig.Community ~= false or guiconfig.Home ~= false then
		pcall(function()
			tabs:AddTabHeader("Community", -3)
		end)
	end

	local communitytab
	local discordinvite = tostring(guiconfig.Discord or "https://discord.gg/G7FCTC2mEk")
	local donateurl = tostring(guiconfig.Donate or "https://sociabuzz.com/meowxhub/tribe")
	if guiconfig.Community ~= false then
		pcall(function()
			communitytab = tabs:AddTab({ Name = "Community", Icon = "globe", LayoutOrder = -2, StartActive = false })
			buildcommunitypage(communitytab:GetPage(), {
				Discord = discordinvite,
				Donate = donateurl,
			})
		end)
	end

	if guiconfig.Home ~= false then
		pcall(function()
			local HomeTab = tabs:AddTab({ Name = "Home", Icon = "home", LayoutOrder = -1 })
			buildhomepage(HomeTab:GetPage(), {
				Footer = guiconfig.Footer,
				Version = guiconfig.HomeVersion or guiconfig.ScriptVersion,
				Logo = guiconfig.HomeLogo or userPassedToggle or assets.LogoId,
				Discord = discordinvite,
				OpenCommunity = communitytab and function()
					communitytab:Select()
				end or nil,
				ToggleKey = togglekey,
				HubName = guiconfig.HomeTitle or "MX HUB",
				OpenFeatures = openfeatures,
				GetFeatureInfo = function()
					local groups, total = collectfeatures()
					local names = {}
					for _, g in ipairs(groups) do
						names[#names + 1] = g.Name
					end
					return total, names
				end,
			})
		end)
	end

	if guiconfig.Settings then
		local ConfigTab = tabs:AddTab({
			Name = "Settings",
			Icon = "settings",
			LayoutOrder = 1000000,
			StartActive = false,
		})
		local SettingsGeneral = ConfigTab:AddSubTab("General")
		local SettingsConfigs = ConfigTab:AddSubTab("Configs")

		do
			local InterfaceSection = ConfigTab:AddSection("Interface", true, "Left", "settings")
			InterfaceSection:AddToggle({
				Title = "Lock UI",
				Flag = "LockUI",
				Default = false,
				Callback = function(state)
					uilocked = state == true
				end,
			})
			InterfaceSection:AddToggle({
				Title = "Show Watermark",
				Flag = "ShowWatermark",
				Default = true,
				Callback = function(state)
					if guifunc.Watermark then
						guifunc.Watermark:SetVisible(state)
					end
				end,
			})

			local ToolsSection = ConfigTab:AddSection("Tools", true, "Left", "wrench")
			ToolsSection:AddToggle({
				Title = "Anti AFK",
				Flag = "AntiAfk",
				Default = false,
				Content = "Stops the idle kick",
				Callback = function(state)
					MXHUB.AntiAfk(state == true)
				end,
			})
			ToolsSection:AddToggle({
				Title = "FPS Boost",
				Flag = "FpsBoost",
				Default = false,
				Content = "Lower graphics for more FPS. Restored when turned off",
				Callback = function(state)
					MXHUB.FpsBoost(state == true)
				end,
			})

			local ThemeSection = ConfigTab:AddSection("Theme", true, "Right", "palette")
			local live = false
			task.defer(function()
				live = true
			end)
			local function apply(patch)
				if not live then
					return
				end
				theme.Api.Set(patch)
			end

			ThemeSection:AddDropdown({
				Title = "Theme",
				Flag = "ThemePick",
				Multi = false,
				NoSave = true,
				Options = theme.Api.Names(),
				Default = theme.State.Preset or "MX HUB",
				Callback = function(value)
					if value then
						apply({ Preset = value, Accent = false })
					end
				end,
			})

			local accentnames, accentcolors = { "Default" }, {}
			for _, accent in ipairs(theme.Api.Accents()) do
				accentnames[#accentnames + 1] = accent[1]
				accentcolors[accent[1]] = accent[2]
			end
			ThemeSection:AddDropdown({
				Title = "Accent",
				Flag = "ThemeAccent",
				Multi = false,
				NoSave = true,
				Options = accentnames,
				Default = "Default",
				Callback = function(value)
					if value then
						apply({ Accent = accentcolors[value] or false })
					end
				end,
			})

			ThemeSection:AddDropdown({
				Title = "Mode",
				Flag = "ThemeMode",
				Multi = false,
				NoSave = true,
				Options = { "Dark", "Light" },
				Default = theme.State.Mode or "Dark",
				Callback = function(value)
					if value then
						apply({ Mode = value })
					end
				end,
			})

			ThemeSection:AddInput({
				Title = "Custom Accent (hex)",
				Flag = "ThemeCustomAccent",
				Placeholder = "#1ED760",
				NoSave = true,
				Callback = function(value)
					local text = tostring(value or "")
					if text == "" then
						return
					end
					local color = theme.Api.ParseHex(text)
					if color then
						apply({ Accent = color })
					end
				end,
			})

			ThemeSection:AddButton({
				Title = "Reset Theme",
				Callback = function()
					theme.Api.Set({ Preset = "MX HUB", Accent = false, Mode = "Dark" })
				end,
			})
		end

		local function buildConfigTab()
			local ConfigSection = SettingsConfigs:AddSection("Config Manager", true, "Full", "save")
			ConfigSection:AddConfigPanel()
		end

		if guiconfig.LazyConfigTab then
			SettingsConfigs:OnOpen(buildConfigTab)
		else
			buildConfigTab()
		end
	end

	buildingsystem = false

	tabs.Destroy = function()
		guifunc:DestroyGui()
	end

	return tabs
end
local languagenames = {
	id = "Indonesia",
	fr = "Français",
	es = "Español",
	de = "Deutsch",
	pt = "Português",
	it = "Italiano",
	nl = "Nederlands",
	pl = "Polski",
	tr = "Türkçe",
	vi = "Tiếng Việt",
	ru = "Russian",
	ja = "Japanese",
	ko = "Korean",
	zh = "Chinese",
	ar = "Arabic",
	th = "Thai",
	hi = "Hindi",
}
local apitab = {}
apitab.__index = apitab

local function options(value)
	if type(value) == "table" then
		return value
	end
	return { name = value }
end

local function titleof(opts, fallback)
	return tostring(opts.name or opts.title or fallback)
end

local function sideof(value)
	local text = tostring(value or "full"):lower()
	return (text:gsub("^%l", string.upper))
end

local function remember(self, flag, element)
	if flag ~= nil and type(element) == "table" then
		self._window.flags[flag] = element
	end
	return element
end

function apitab:_target()
	if not self._section then
		self._section = self._tab:AddSection({ Title = self._name, Side = "Full" })
	end
	return self._section
end

function apitab:CreateSection(opts)
	opts = options(opts)
	self._section = self._tab:AddSection({
		Title = titleof(opts, "Section"),
		Open = opts.open ~= false,
		Side = sideof(opts.side),
		Icon = opts.icon,
	})
	return self
end

function apitab:CreateSubTab(name)
	self._tab = self._tab:AddSubTab(name)
	self._section = nil
	return self
end

function apitab:CreateButton(opts)
	opts = options(opts)
	return self:_target():AddButton({
		Title = titleof(opts, "Button"),
		Callback = opts.callback,
		Icon = opts.icon,
	})
end

function apitab:CreateToggle(opts)
	opts = options(opts)
	return remember(self, opts.flag, self:_target():AddToggle({
		Title = titleof(opts, "Toggle"),
		Flag = opts.flag,
		Default = opts.value == true,
		Callback = opts.callback,
		Keybind = opts.keybind,
		Icon = opts.icon,
		Content = opts.description,
	}))
end

function apitab:CreateSlider(opts)
	opts = options(opts)
	local range = type(opts.range) == "table" and opts.range or { 0, 100 }
	return remember(self, opts.flag, self:_target():AddSlider({
		Title = titleof(opts, "Slider"),
		Flag = opts.flag,
		Min = range[1],
		Max = range[2],
		Increment = opts.increment or 1,
		Default = opts.value or range[1],
		Suffix = opts.suffix,
		Icon = opts.icon,
		Callback = opts.callback,
		Content = opts.description,
	}))
end

function apitab:CreateDropdown(opts)
	opts = options(opts)
	local multi = opts.multiSelect == true
	local value = opts.value
	if multi and type(value) == "string" then
		value = { value }
	elseif not multi and type(value) == "table" then
		value = value[1]
	end
	return remember(self, opts.flag, self:_target():AddDropdown({
		Title = titleof(opts, "Dropdown"),
		Flag = opts.flag,
		Options = opts.options or {},
		Default = value,
		Multi = multi,
		Icon = opts.icon,
		Callback = opts.callback,
		Content = opts.description,
	}))
end

function apitab:CreateInput(opts)
	opts = options(opts)
	local numeric = opts.numeric == true
	local callback = opts.callback
	local element
	local lastvalid = tostring(opts.value or "")
	element = self:_target():AddInput({
		Title = titleof(opts, "Input"),
		Flag = opts.flag,
		Default = lastvalid,
		Placeholder = opts.placeholder,
		Icon = opts.icon,
		NoSave = opts.save == false,
		Content = opts.description,
		Callback = function(text)
			if numeric and text ~= "" and tonumber(text) == nil then
				if element then
					element:Set(lastvalid)
				end
				return
			end
			lastvalid = tostring(text)
			if type(callback) == "function" then
				callback(text)
			end
		end,
	})
	return remember(self, opts.flag, element)
end

function apitab:CreateKeybind(opts)
	opts = options(opts)
	local callback = opts.callback
	local element
	element = self:_target():AddKeybind({
		Title = titleof(opts, "Keybind"),
		Flag = opts.flag,
		Default = opts.value,
		Mode = opts.mode,
		Icon = opts.icon,
		Content = opts.description,
		Callback = function()
			if type(callback) == "function" then
				callback(element and element.Value or opts.value)
			end
		end,
		ChangedCallback = opts.changed,
	})
	return remember(self, opts.flag, element)
end

function apitab:CreateColorPicker(opts)
	opts = options(opts)
	local callback = opts.callback
	return remember(self, opts.flag, self:_target():AddColorPicker({
		Title = titleof(opts, "Color"),
		Flag = opts.flag,
		Default = opts.color,
		Icon = opts.icon,
		Content = opts.description,
		Callback = function(color)
			if type(callback) == "function" then
				callback(color, 1)
			end
		end,
	}))
end

function apitab:CreateImage(opts)
	opts = options(opts)
	return self:_target():AddImage({
		Image = opts.image or opts.icon or opts.source,
		Title = opts.name,
		Height = opts.height,
		Width = opts.width,
		Fit = opts.fit,
		Align = opts.align,
		AspectRatio = opts.aspectRatio,
		CornerRadius = opts.cornerRadius,
		Transparency = opts.transparency,
		Color = opts.color,
		Border = opts.border,
		Background = opts.background,
	})
end

function apitab:CreateCharacter(opts)
	opts = options(opts)
	local section = self._tab:AddSection({
		Title = opts.name or "",
		Side = sideof(opts.side or "right"),
		Open = true,
	})
	return section:AddCharacter({
		Target = opts.target,
		Height = opts.height,
		Title = opts.label,
	})
end

function apitab:SetIcon(value)
	self._tab:SetIcon(value)
	return self
end

function apitab:SetSectionIcon(value)
	if self._section then
		self._section:SetIcon(value)
	end
	return self
end

function apitab:CreateParagraph(opts)
	opts = options(opts)
	return self:_target():AddParagraph({
		Title = tostring(opts.name or opts.title or ""),
		Content = tostring(opts.content or opts.description or ""),
		Icon = opts.icon,
	})
end

function apitab:CreateLabel(opts)
	opts = options(opts)
	return self:_target():AddParagraph({ Title = titleof(opts, ""), Content = "" })
end

function apitab:CreateDivider()
	return self:_target():AddDivider()
end

function apitab:Select()
	self._tab:Select()
end
local apiwindow = {}
apiwindow.__index = apiwindow

function apiwindow:CreateSection(opts)
	opts = type(opts) == "table" and opts or { name = opts }
	self._category = tostring(opts.name or opts.title or "")
	return self
end

function apiwindow:CreateTab(opts)
	opts = type(opts) == "table" and opts or { name = opts }
	local name = tostring(opts.name or opts.title or "Tab")
	local tab = self._engine:AddTab({
		Name = name,
		Icon = opts.icon,
		Category = self._category,
	})
	return setmetatable({ _window = self, _tab = tab, _name = name }, apitab)
end

function apiwindow:Popup(opts)
	opts = opts or {}
	local boxes = {}
	for _, box in ipairs(opts.boxes or {}) do
		boxes[#boxes + 1] = { Title = box.title, Description = box.description, Icon = box.icon }
	end
	local choices = {}
	for _, choice in ipairs(opts.options or {}) do
		choices[#choices + 1] = { Text = choice.text, Style = choice.style, Callback = choice.callback }
	end
	return MXHUB:Popup({
		Title = opts.title,
		Subtitle = opts.subtitle,
		Boxes = boxes,
		Options = choices,
		Dismissable = opts.dismissable,
		OnClose = opts.onClose,
	})
end

function apiwindow:ChangeTheme(name, accent)
	local patch = { Preset = name }
	if accent ~= nil then
		patch.Accent = typeof(accent) == "Color3" and accent or MXHUB.Theme.ParseHex(accent) or false
	end
	return MXHUB.Theme.Set(patch)
end

function apiwindow:SetLanguage(name)
	return MXHUB.SetLanguage and MXHUB.SetLanguage(languagenames[name] or name)
end

function apiwindow:GetFlag(flag)
	local element = self.flags[flag]
	return element and element.Value
end

function apiwindow:Destroy()
	self._engine.Destroy()
end

function MXHUB:CreateWindow(opts)
	opts = type(opts) == "table" and opts or { name = opts }

	for code, entries in pairs(opts.translations or {}) do
		self:AddTranslations(languagenames[code] or code, entries)
	end

	local themefile = "MX HUB/theme.json"
	local hassaved = type(isfile) == "function" and isfile(themefile)
	if opts.theme and not hassaved then
		self.Theme.Set({ Preset = opts.theme }, true)
	end

	local engine = self:Window({
		Footer = opts.name,
		GameName = opts.configFolder or opts.name,
		ConfigFolder = opts.configFolder,
		Version = opts.configVersion,
		HomeVersion = opts.version,
		HomeLogo = opts.logo,
		HomeTitle = opts.homeTitle,
		Image = opts.image,
		ToggleImage = opts.icon,
		Background = opts.background,
		Color = opts.accent,
		MenuKey = opts.menuKey,
		IconRail = opts.iconRail,
		ToggleKeybinds = opts.toggleKeybinds,
		Community = opts.community,
		Home = opts.home,
		Settings = opts.settings,
		Discord = opts.discord,
		Donate = opts.donate,
		Watermark = opts.watermark,
		Width = opts.width,
		Height = opts.height,
	})

	local window = setmetatable({ _engine = engine, flags = {} }, apiwindow)
	if opts.language then
		window:SetLanguage(opts.language)
	end
	return window
end

MXHUB.Elevate = elevate
function MXHUB:Elevate()
	elevate()
end

getgenv().MXHUB = MXHUB
getgenv().MXLIB = MXHUB

return MXHUB
