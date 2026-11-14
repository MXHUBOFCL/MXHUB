local function httprequest()
	return (type(request) == "function" and request)
		or (type(http_request) == "function" and http_request)
		or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
		or (type(http) == "table" and type(http.request) == "function" and http.request)
		or nil
end
