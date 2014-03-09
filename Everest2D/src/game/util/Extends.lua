--client

--allows a class to extend another

function _G.Extends(className, toExtend)
	local extendee = {}
	setmetatable(extendee, toExtend)
	
	_G[className] = extendee
	extendee.__index = extendee
	
	return extendee
end