--client
repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("Entity")

do BasicMissile = Extends("BasicMissile", Entity)

	BasicMissile.Recycling = {}

	function BasicMissile.new(id, level, speed, posX, posY, type, dirVec, size, color, shouldDamageMobs, shouldDamagePlayer)
		local basicMissile = Entity.new(id, level, posX, posY)
		setmetatable(basicMissile, BasicMissile)

		basicMissile.name = "BasicMissile"
		basicMissile.speed = speed
		basicMissile.type = type
		basicMissile.dirVec = dirVec
		basicMissile.size = size
		basicMissile.color = color	
		basicMissile.startPos = Vector2.new(posX, posY)
		basicMissile.endPos = basicMissile.level:rayCast(Vector2.new(posX, posY), dirVec)
		basicMissile.shouldDamageMobs = shouldDamageMobs
		basicMissile.shouldDamagePlayer = shouldDamagePlayer
		basicMissile.frame = _G.GuiRecycling.getGui()
		basicMissile.frame.Name = "testBasicMissile"
		basicMissile.frame.Size = size
		basicMissile.frame.BorderSizePixel = 0
		basicMissile.frame.BackgroundTransparency = 0
		basicMissile.frame.ZIndex = 5
		basicMissile.frame.Position = UDim2.new(0, posX * 32, 0, posY * 32)
		basicMissile.frame.BackgroundColor3 = color
		basicMissile.frame.Parent = _G.localgame.screen.frame
		
		local entitiesInRange = {}
		local currentPos = Vector2.new(posX, posY)
		
		for i, v in pairs(basicMissile.level.entities) do
			if i < 50000 and v.isMob and not v.isPlayer and v ~= _G.localgame.player then
				table.insert(entitiesInRange, v)
			end
		end
		
		basicMissile.culledEntityList = entitiesInRange
		
		coroutine.wrap(function() 
			while basicMissile do 
				wait()
				local particle = _G.GuiRecycling.getGui()
				local particleSize = math.random(1,5)
				particle.Size = UDim2.new(0,particleSize,0,particleSize)
				particle.BackgroundColor3 = color
				particle.BorderSizePixel = 0
				particle.BackgroundTransparency = math.random(0,100) / 100
				particle.ZIndex = 5
				particle.Position = basicMissile.frame.Position + UDim2.new(0, math.random(0,10), 0, math.random(0,10))
				particle.Parent = _G.localgame.screen.frame
				particle:TweenPosition(particle.Position + UDim2.new(0, math.random(-20,20), 0, math.random(-20,20)), "Out", "Linear", 2, true)
				coroutine.wrap(function() while particle.BackgroundTransparency < 1 do wait() particle.BackgroundTransparency = particle.BackgroundTransparency + 0.02 end end)()
				coroutine.wrap(function() wait(6) _G.GuiRecycling.addGui(particle) end)()
			end
		end)()
		
		return basicMissile
	end
	
	Import("CLIENT_PACKET006_DAMAGE")
	
	function BasicMissile:tick(deltaTime)
		local currentPos = Vector2.new(self.posX, self.posY)
		local closestEntity
		
		if self.culledEntityList then
			for _, v in pairs(self.culledEntityList) do
				if not closestEntity then closestEntity = v
				else
					local closestPos = Vector2.new(closestEntity.frame.Position.X.Offset / 32, closestEntity.frame.Position.Y.Offset / 32)
					local comparePos = Vector2.new(v.frame.Position.X.Offset / 32, v.frame.Position.Y.Offset / 32)
					if (comparePos - currentPos).magnitude < (closestPos - currentPos).magnitude then
						closestEntity = v
					end
				end
			end
		end
		
		if (currentPos - self.endPos).magnitude < 1.1 then
			self.level.entities[self.levelId] = nil  
			_G.GuiRecycling.addGui(self.frame)
			self = nil 
		elseif closestEntity and (Vector2.new(closestEntity.frame.Position.X.Offset / 32 + closestEntity.scale / 2, closestEntity.frame.Position.Y.Offset / 32 + closestEntity.scale / 2) - currentPos).magnitude < closestEntity.scale / 2 then
			self.level.entities[self.levelId] = nil  
			_G.GuiRecycling.addGui(self.frame)
			if self.shouldDamageMobs and closestEntity ~= _G.localgame.player then
				_G.localgame.packetHandler:sendPacket(CLIENT_PACKET006_DAMAGE.new(closestEntity.level.name, closestEntity.levelId, 20):Data())
			elseif self.shouldDamagePlayer and closestEntity == _G.localgame.player then
				_G.localgame.packetHandler:sendPacket(CLIENT_PACKET006_DAMAGE.new(closestEntity.level.name, closestEntity.levelId, 20):Data())
			end
			self = nil

		else 
			local newPos = currentPos + self.dirVec * self.speed * deltaTime
			self.posX = newPos.X
			self.posY = newPos.Y
		end
		
	end
	
	function BasicMissile:render(deltaTime)
	
		local posVec = Vector2.new(self.posX * 32 - self.size.X.Offset, self.posY * 32 - self.size.Y.Offset)
		local currentPosVec = Vector2.new(self.frame.Position.X.Offset, self.frame.Position.Y.Offset)
		local newPos = currentPosVec:lerp(posVec, 10 * deltaTime)
		self.frame.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
		
	end
end
