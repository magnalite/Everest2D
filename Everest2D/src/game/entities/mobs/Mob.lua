--Base mob class, mobs should extend this class

repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("Entity")

do Mob = Extends("Mob", Entity)

	function Mob.new(id, game, level, hp, name, speed, posX, posY, type)
		local mob = Entity.new(id, level, posX, posY)
		setmetatable(mob, Mob)

		mob.name = name
		mob.hp = hp
		mob.speed = speed
		mob.type = type
		mob.numSteps = 0
		mob.isMoving = false
		mob.movingDir = "SOUTH"
		mob.scale = 1
		mob.frame = Instance.new("ImageLabel", game.screen.frame)
		mob.frame.BorderSizePixel = 0
		mob.frame.BackgroundTransparency = 1
		mob.frame.ZIndex = 5

		mob.nameToolTip = Instance.new("TextLabel", mob.frame)
		mob.nameToolTip.Text = name .. ":" .. mob.levelId
		mob.nameToolTip.Size = UDim2.new(1,0,0.3,0)
		mob.nameToolTip.Position = UDim2.new(0,0,-0.5,0)
		mob.nameToolTip.BackgroundTransparency = 1
		mob.nameToolTip.BorderSizePixel = 0
		mob.nameToolTip.FontSize = "Size18"
		mob.nameToolTip.ZIndex = 8

		return mob
	end

	--xa is the distance across x it is moving
	--xy is the same for the y axis
	--type is the speed at which they move
	--truePosX is for synchronisation with the server (forces the entity to that position)
	--truePosY is the same but for the y axis
	function Mob:move(xa, ya, type, truePosX, truePosY)
	
		self.posX = truePosX or self.posX
		self.posY = truePosY or self.posY
	
		if xa ~= 0 and ya ~= 0 then
			xa = xa * math.cos(45)
			ya = ya * math.cos(45)
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

			return xa, ya
		end

	end

	--Should be custom for every mob due to differing behavour
	function Mob:hasCollided()
		error("Attempted to call hasCollided on native mob class.")
	end

	Import("Tile")

	--Find if the mob moving from x,y via xa ya will collide with a tile
	--Factors in the scale of the mob
	function Mob:isSolidTile(x, y, xa, ya)

		local x = math.max(0, math.floor(x + xa))
		local x = math.min(self.level.width, x)
		local y = math.max(0, math.floor(y + ya))
		local y = math.min(self.level.height, y)

		local solid = false
		if x >= self.level.width - 1 or x <= 0 or y >= self.level.height - 1 or y <= 0 then return true end
		for xi = 0, math.ceil(self.scale) do
			for yi = 0, math.ceil(self.scale) do
				local nextTile = Tile.Tiles[self.level.tiles[x + xi][y + yi]]
				if not nextTile.isWalkable then solid = true end
			end
		end
		local nextTile = Tile.Tiles[self.level.tiles[x][y]]

		return solid

	end

end
