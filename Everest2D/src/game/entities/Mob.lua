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
			self:move(xa / 2, 0)
			self:move(0, ya / 2)
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
			
			self.currentTile = self.level.tiles[math.floor(self.posX + 0.5)][math.floor(self.posY + 0.5)]
		end	
		
	end
	
	function Mob:hasCollided()
		error("Attempted to call hasCollided on native mob class.")
	end
	
	Import("Tile")
	
	function Mob:isSolidTile(x, y, xa, ya)
		
		local x = math.max(0, math.floor(x + xa + 0.5))
		local x = math.min(self.level.width, x)
		local y = math.max(0, math.floor(y + ya + 0.5))
		local y = math.min(self.level.height, y)
		
		local solid = false
		
		for xi = 0, self.scale - 1 do
			for yi = 0, self.scale - 1 do
				local nextTile = Tile.Tiles[self.level.tiles[x + xi][y + yi]]
				if not nextTile.isWalkable then solid = true end
			end
		end
		local nextTile = Tile.Tiles[self.level.tiles[x][y]]
		
		return solid

	end
	
end
