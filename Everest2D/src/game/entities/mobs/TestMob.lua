--TestMob class, all TestMobs use this class

repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("Mob")

do TestMob = Extends("TestMob", Mob)
		
	Import("SpriteSheet")
	
	TestMob.TestMobs = {}
	
	function TestMob.new(id, game, level, health, name, posX, posY)
		local testMob = Mob.new(id, game, level, health, name, 0.8, posX, posY, "TestMob")
		setmetatable(testMob, TestMob)

		testMob.scale = 2
		testMob.game = game
		testMob.frame.Name = name
		testMob.frame.Image = "http://www.roblox.com/asset/?id=149199457"
		
		TestMob.TestMobs[name] = TestMob
		
		return TestMob
	end
	
	Import("SERVER_PACKET003_MOVE")
	Import("SERVER_PACKET006_SPAWNEFFECT")
	
	function TestMob:tick(deltaTime)
		if _G.isServer then
			if math.random(1,50) == 50 then
		
				local currentPos = Vector2.new(self.posX, self.posY)
				local targetPlayerDist = math.huge
				local targetPlayerPos
				for _, v in pairs(_G.localserver.players) do
					local playerPos = Vector2.new(v.player.posX, v.player.posY) 
					local playerDist = (currentPos - playerPos).magnitude
					if playerDist < targetPlayerDist then
						targetPlayerDist = playerDist
						targetPlayerPos = playerPos
					end
				end
				
				if targetPlayerDist < 30 then
					local moveVec = ((targetPlayerPos + Vector2.new(math.random(-3,3), math.random(-3,3))) - currentPos).unit * self.speed * 50
					local xa, ya = self:move(moveVec.X, moveVec.Y)
					
					xa = xa or 0
					ya = ya or 0
					
					for player, _ in pairs(_G.localserver.players) do
						_G.localserver.packetHandler:sendPacket(player, SERVER_PACKET006_SPAWNEFFECT.new(10000, self.level.name, 3, currentPos.X, currentPos.Y, "BasicMissile", moveVec.unit.X, moveVec.unit.Y, UDim2.new(0, 10, 0, 10), Color3.new(0,0,0)):Data())
						_G.localserver.packetHandler:sendPacket(player, SERVER_PACKET003_MOVE.new(self.levelId, xa, ya, self.speed, self.posX, self.posY):Data())
					end
				end
			end
		end
		
	end	
	
	function TestMob:render(deltaTime)
	
		local posVec = Vector2.new(self.posX * 32 - 16, self.posY * 32 - 16)
		local currentPosVec = Vector2.new(self.frame.Position.X.Offset, self.frame.Position.Y.Offset)
		local newPos = currentPosVec:lerp(posVec, 0.5 * deltaTime)
		self.frame.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
		
		self.frame:TweenSize(UDim2.new(0, 32 * self.scale, 0, 32 * self.scale), "Out", "Linear", 0.2, true)
		
		--[[if math.random(1, 3) == 3 then
			local particle = _G.GuiRecycling.getGui()
			local particleSize = math.random(3,8)
			particle.Size = UDim2.new(0,particleSize,0,particleSize)
			particle.BackgroundColor3 = Color3.new(0,0,0)
			particle.BorderSizePixel = 0
			particle.BackgroundTransparency = math.random(50,100) / 100
			particle.ZIndex = 5
			particle.Position = self.frame.Position + UDim2.new(0, math.random(0,32), 0, math.random(0,32))
			particle.Parent = _G.localgame.screen.frame
			particle:TweenPosition(particle.Position + UDim2.new(0, math.random(-40,40), 0, math.random(-40,40)), "Out", "Linear", 2, true)
			coroutine.wrap(function() while particle.BackgroundTransparency < 1 do wait() particle.BackgroundTransparency = particle.BackgroundTransparency + 0.02 end end)()
			coroutine.wrap(function() wait(6) _G.GuiRecycling.addGui(particle) end)()
		end]]--
		
	end
	
	function TestMob:hasCollided(xa, ya)
		return self:isSolidTile(self.posX, self.posY, xa, ya)	
	end
	
end