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

