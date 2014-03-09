--Base entity class, should not really be used for anything other than setting up other classes

repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do Entity = Class("Entity")
	
	function Entity.new(id, level, posX, posY)
		entity = {}
		setmetatable(entity, Entity)
		
		entity.level = level
		if id then
			level.entities[id] = entity
			entity.levelId = id
		else
			table.insert(level.entities, entity)
			entity.levelId = #level.entities
		end
		entity.posX = posX
		entity.posY = posY
		
		return entity
	end
	
	function Entity:tick()
		
	end
	
	function Entity:render()
		--Entities should have their own render function due to graphical diversity
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