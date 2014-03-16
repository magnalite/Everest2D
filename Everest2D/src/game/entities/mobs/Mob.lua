--Base mob class, mobs should extend this class

repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("Entity")

do Mob = Extends("Mob", Entity)

	function Mob.new(id, game, level, hp, maxHp, name, speed, posX, posY, type)
		print(id, game, level, hp, maxHp, name, speed, posX, posY, type)
		local mob = Entity.new(id, level, posX, posY)
		setmetatable(mob, Mob)

		mob.name = name
		mob.Name = name
		mob.hp = hp
		mob.maxHp = maxHp
		mob.speed = speed
		mob.type = type
		mob.isMob = true
		mob.numSteps = 0
		mob.isMoving = false
		mob.movingDir = "SOUTH"
		mob.scale = 1
		mob.frame = Instance.new("ImageLabel", game.screen.frame)
		mob.frame.BorderSizePixel = 0
		mob.frame.BackgroundTransparency = 1
		mob.frame.Position = UDim2.new(0, posX * 32, 0, posY * 32)
		mob.frame.ZIndex = 5

		mob.nameToolTip = Instance.new("TextLabel", mob.frame)
		mob.nameToolTip.Text = name .. ":" .. mob.levelId
		mob.nameToolTip.Size = UDim2.new(1,0,0.3,0)
		mob.nameToolTip.Position = UDim2.new(0,0,-0.5,0)
		mob.nameToolTip.BackgroundTransparency = 1
		mob.nameToolTip.TextColor3 = Color3.new(1,1,1)
		mob.nameToolTip.TextStrokeTransparency = 0
		mob.nameToolTip.BorderSizePixel = 0
		mob.nameToolTip.FontSize = "Size14"
		mob.nameToolTip.ZIndex = 8
		
		mob.healthBar = Instance.new("Frame", mob.nameToolTip)
		mob.healthBar.Size = UDim2.new(1,0,0.3,0)
		mob.healthBar.Position = UDim2.new(0,0,1.1,0)
		mob.healthBar.BackgroundTransparency = 0
		mob.healthBar.BackgroundColor3 = Color3.new(1,0,0)
		mob.healthBar.BorderSizePixel = 1
		mob.healthBar.ZIndex = 8
		
		mob.healthBarGreen = Instance.new("Frame", mob.healthBar)
		mob.healthBarGreen.Size = UDim2.new(1,0,1,0)
		mob.healthBarGreen.Position = UDim2.new(0,0,0,0)
		mob.healthBarGreen.BackgroundTransparency = 0
		mob.healthBarGreen.BackgroundColor3 = Color3.new(0,1,0)
		mob.healthBarGreen.BorderSizePixel = 1
		mob.healthBarGreen.ZIndex = 8
		
		mob.healthLabel = Instance.new("TextLabel", mob.healthBar)
		mob.healthLabel.Text = hp
		mob.healthLabel.Size = UDim2.new(0,0,0,0)
		mob.healthLabel.Position = UDim2.new(0.5,0,0.5,0)
		mob.healthLabel.BackgroundTransparency = 1
		mob.healthLabel.TextColor3 = Color3.new(1,1,1)
		mob.healthLabel.TextStrokeTransparency = 0
		mob.healthLabel.BorderSizePixel = 0
		mob.healthLabel.FontSize = "Size8"
		mob.healthLabel.ZIndex = 8

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
		
		local xCollide, yCollide = self:hasCollided(xa, ya)


		xa = xCollide and 0 or xa
		ya = yCollide and 0 or ya

		if xa ~= 0 or ya ~= 0 then

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
		
		x = math.floor(x + 0.5)
		y = math.floor(y + 0.5)
		xa = math.floor(xa + 0.5)
		ya = math.floor(ya + 0.5)
		
		local xCollide
		local yCollide
		
		for yd = math.ceil(-self.scale/2), math.floor(self.scale/2), 1 do
			if     not self.level.tiles[x + xa]                                then xCollide = true
			elseif not self.level.tiles[x + xa][y + yd]                        then xCollide = true
			elseif not Tile.Tiles[self.level.tiles[x + xa][y + yd]].isWalkable then xCollide = true 
			end
		end
		for xd = math.ceil(-self.scale/2), math.floor(self.scale/2), 1 do
			if     not self.level.tiles[x + xd]                                then yCollide = true
			elseif not self.level.tiles[x + xd][y + ya]                        then yCollide = true
			elseif not Tile.Tiles[self.level.tiles[x + xd][y + ya]].isWalkable then yCollide = true 
			end
		end
		
		return xCollide, yCollide
	end

	Import("SERVER_PACKET008_DAMAGE")

	function Mob:damage(amount, newHealth)
		if _G.isServer then
			self.hp = self.hp - amount
			for playerTo, _ in pairs(_G.localserver.players) do
				_G.localserver.packetHandler:sendPacket(playerTo, SERVER_PACKET008_DAMAGE.new(self.level.name, self.levelId, self.hp):Data())
			end
		else
			self.hp = newHealth
			self.healthLabel.Text = self.hp
			self.healthBarGreen.Size = UDim2.new(self.hp/self.maxHp,0,1,0)
		end
		
		if self.hp <= 0 then
			self:kill()
		end
	end
	
	function Mob:kill()
		self.level.entities[self.levelId] = nil  
		self.frame:Destroy()
		self = nil 
	end

end
