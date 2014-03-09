
function _G.Class(className)
	local class = {}
	_G[className] = class
	class.__Index = class
	
	return class
end