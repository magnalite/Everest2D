--client
repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("Mob")

do Player = Extends(Mob)
	_G.Player = Player
	Player.__index = Player
		
	Import("SpriteSheet")
	
	Player.players = {}
	
	function Player.new(game, level, name, posX, posY, input)
		local player = Mob.new(game, level, name, 0.2, posX, posY)
		setmetatable(player, Player)
		
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
		end
		
		if xa ~= 0 or ya ~= 0 then
			--self:move(xa, ya)
			self.game:sendPacket({"MOVE", xa, ya})
			self.isMoving = true
		else
			self.isMoving = false
		end
		
	end	
	
	function Player:render()
		local animCycle = 2 - math.floor((self.numSteps * (self.speed * 5)) % 30 / 10)	
			
		self.frame:TweenSize(UDim2.new((1 * self.scale) / self.game.screen.sizeX, 0, (1 * self.scale) / self.game.screen.sizeY), "Out", "Linear", 0.2, true)
		self.frame:TweenPosition(UDim2.new((self.posX) / self.game.screen.sizeX, 0, (self.posY) / self.game.screen.sizeY, 0), "Out", "Linear", 0.1, true)	
		
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