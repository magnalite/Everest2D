--Base entity class, should not really be used for anything other than setting up other classes

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
		print(entity.levelId)
		entity.posX = posX
		entity.posY = posY
		
		return entity
	end
	
	function Entity:tick()
		
	end
	
	function Entity:render()
		--Entities should have their own render function to stop graphical glitches
		error("Attempted to render base entity")
	end	
	
	function Entity:Destroy()
		self.level.entities[self.levelId] = nil
		if self.frame then
			self.frame:Destroy()
		end
		self = nil
	end
	
end