--Player class, all players use this class

repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("Mob")

do Player = Extends(Mob)
	_G.Player = Player
	Player.__index = Player
		
	Import("SpriteSheet")
	
	Player.players = {}
	
	function Player.new(id, game, level, health, name, posX, posY, input)
		local player = Mob.new(id, game, level, health, name, 1, posX, posY, "PLAYER")
		setmetatable(player, Player)
		
		
		if name == game.localPlayer.Name then
			player.frame.ZIndex = 6
		end
		
		player.input = input	
		player.scale = 2
		player.game = game
		player.frame.Name = name
		player.frame.Image = SpriteSheet.BasicSpriteSheet.url
		player.frame.ImageRectSize = Vector2.new(32, 32)
		player.frame.ImageRectOffset = Vector2.new(0, 128)
		
		Player.players[name] = player
		
		return player
	end
	
	Import("CLIENT_PACKET002_MOVE")
	Import("CLIENT_PACKET004_SPAWNEFFECT")
	Import("BasicMissile")
	
	function Player:tick()
		local xa = 0
		local ya = 0
		
		if self.input then
			if self.input.keys["w"] then
				ya = ya - 1
			end
			if self.input.keys["s"] then
				ya = ya + 1
			end
			if self.input.keys["a"] then
				xa = xa - 1
			end
			if self.input.keys["d"] then
				xa = xa + 1
			end
			if self.input.keys["Button1"] then
				local mousePos = Vector2.new((self.input.mouse.X + _G.localgame.screen.posX * 32)/32, (self.input.mouse.Y + _G.localgame.screen.posY * 32)/32)
				local dirVec = (mousePos - Vector2.new(self.posX, self.posY)).unit
				local missile = BasicMissile.new(#self.level.entities + 1, self.level, 3, self.posX, self.posY, "BasicMissile", dirVec, UDim2.new(0, 10, 0, 10), Color3.new(255/255,50/255,50/255))
				self.game.packetHandler:sendPacket(CLIENT_PACKET004_SPAWNEFFECT.new(#self.level.entities + 1, self.level, 3, self.posX, self.posY, "BasicMissile", dirVec, UDim2.new(0, 10, 0, 10), Color3.new(255/255,50/255,50/255)):Data())
			end
		end
		
		if xa ~= 0 or ya ~= 0 then
			xa, ya = self:move(xa, ya)
			
			xa = xa or 0
			ya = ya or 0
			
			self.isMoving = true
			self.game.packetHandler:sendPacket(CLIENT_PACKET002_MOVE.new(self.levelId, xa, ya, self.speed, self.posX, self.posY):Data())
		else
			self.isMoving = false
		end
		
	end	
	
	function Player:render()
		local animCycle = 2 - math.floor((self.numSteps * (self.speed * 5)) % 30 / 10)	
			
		self.frame:TweenSize(UDim2.new(0, 32 * self.scale, 0, 32 * self.scale), "Out", "Linear", 0.2, true)
		self.frame:TweenPosition(UDim2.new(0, self.posX * 32, 0, self.posY * 32), "Out", "Linear", 0.1, true)	
		
		if self.movingDir == "NORTH" then
			self.frame.ImageRectOffset = Vector2.new(32 * animCycle, 225)
			self.frame.ImageRectSize = Vector2.new(31, 31)
		end
		if self.movingDir == "EAST" then
			self.frame.ImageRectOffset = Vector2.new(32 * animCycle, 193)
			self.frame.ImageRectSize = Vector2.new(31, 31)			
		end
		if self.movingDir == "SOUTH" then
			self.frame.ImageRectOffset = Vector2.new(32 * animCycle, 129)
			self.frame.ImageRectSize = Vector2.new(31, 31)
		end
		if self.movingDir == "WEST" then
			self.frame.ImageRectOffset = Vector2.new(32 * animCycle, 161)
			self.frame.ImageRectSize = Vector2.new(31, 31)			
		end
	end
	
	function Player:hasCollided(xa, ya)
		return self:isSolidTile(self.posX, self.posY, xa, ya)	
	end
	
end