
MXHUB.Elevate = elevate
function MXHUB:Elevate()
	elevate()
end

getgenv().MXHUB = MXHUB
getgenv().MXLIB = MXHUB

return MXHUB

