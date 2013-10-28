--client
function _G.Extends(toExtend)
	local extendee = {}
	setmetatable(extendee, toExtend)
	
	return extendee
end