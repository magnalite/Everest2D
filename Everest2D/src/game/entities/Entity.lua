--client
repeat wait() until _G.Import
_G.Import("Import")

do Entity = {}
	_G.Entity = Entity
	Entity.__index = Entity
	
	function Entity.new(level, posX, posY)
		entity = {}
		setmetatable(entity, Entity)
		
		entity.level = level
		table.insert(level.entities, entity)
		entity.levelId = #level.entities
		entity.posX = posX
		entity.posY = posY
		
		return entity
	end
	
	function Entity:tick()
		
	end
	
	function Entity:render()
		error("Attempted to render base entity")
	end	
	
end