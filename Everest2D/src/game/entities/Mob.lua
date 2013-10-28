--client
repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("Entity")

do Mob = Extends(Entity)
	_G.Mob = Mob
	Mob.__index = Mob	
	
	function Mob.new(game, level, name, speed, posX, posY)
		local mob = Entity.new(level, posX, posY)
		setmetatable(mob, Mob)
		
		mob.name = name
		mob.speed = speed
		mob.numSteps = 0
		mob.isMoving = false
		mob.movingDir = "SOUTH"
		mob.scale = 1
		mob.frame = Instance.new("ImageLabel", game.screen.frame)
		mob.frame.BorderSizePixel = 0
		mob.frame.BackgroundTransparency = 1
		mob.frame.ZIndex = 5
		
		return mob
	end
	
	function Mob:move(xa, ya)
		if xa ~= 0 and ya ~= 0 then
			self:move(xa, 0)
			self:move(0, ya)
			self.numSteps = self.numSteps - 1
			return
		end	
		
		self.numSteps = self.numSteps + 1
		
		if not self:hasCollided(xa, ya) then
			if ya < 0 then self.movingDir = "NORTH" end
			if ya > 0 then self.movingDir = "SOUTH" end
			if xa < 0 then self.movingDir = "WEST" end
			if xa > 0 then self.movingDir = "EAST" end
			
			self.posX = math.min(self.posX + (xa * self.speed), self.level.width)
			self.posX = math.max(self.posX, 0)
			self.posY = math.min(self.posY + (ya * self.speed), self.level.height)
			self.posY = math.max(self.posY, 0)
		end	
		
	end
	
	function Mob:hasCollided()
		error("Attempted to call hasCollided on native mob class.")
	end
	
end
