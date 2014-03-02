--client

--allows a class to extend another

function _G.Extends(toExtend)
	local extendee = {}
	setmetatable(extendee, toExtend)
	
	return extendee
end