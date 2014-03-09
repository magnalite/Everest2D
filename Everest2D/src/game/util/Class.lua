
function _G.Class(className)
	local class = {}
	_G[className] = class
	class.__index = class
	
	return class
end