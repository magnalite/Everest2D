--This is essentially the camera

repeat wait() until _G.Import
_G.Import("Import")

Import(Class)

do Screen = Class("Screen")

	Import("Hud")

	function Screen.new(game, sizeX, sizeY)
		local screen = {}
		setmetatable(screen, Screen)

		screen.ClippingMask = Instance.new("Frame", game.canvas)
		screen.ClippingMask.Size = UDim2.new(1,0,1,0)
		screen.ClippingMask.BackgroundColor3 = Color3.new(0,0,0)
		screen.ClippingMask.BackgroundTransparency = 0
		screen.ClippingMask.Name = "Clipping Mask"

		screen.frame = Instance.new("Frame", game.canvas)
		screen.frame.Size = UDim2.new(1,0,1,0)
		screen.frame.ZIndex = 2
		screen.frame.BackgroundTransparency = 1
		screen.frame.Name = "Screen"
		screen.testFrame = Instance.new("Frame", screen.frame)
		screen.testFrame.Size = UDim2.new(0,10,0,10)
		screen.testFrame.ZIndex = 6
		screen.testFrame.BackgroundTransparency = 0
		screen.testFrame.Name = "testFrame"
		
		screen.posX = 0
		screen.posY = 0
		
		screen.game = game
		screen.sizeX = sizeX
		screen.sizeY = sizeY
		screen.rendered = {}
		
		screen.hud = Hud.new(screen)
		
		
		return screen
	end

	Import("Tile")

	--Warning dense code ahead!
	function Screen:render(deltaTime, posX, posY)

		--Waits for the level to load itself
		while not self.game.level.ready and not #Tile.Tiles > 0 do wait() end
		
		--Stops the screen from moving over the edge of the map
		posX = math.min(self.game.level.width - 1 - (self.sizeX), posX)
		posY = math.min(self.game.level.height - 1 - (self.sizeY), posY)
		posX = math.max(1, posX)
		posY = math.max(1, posY)
		
		self.posX = posX
		self.posY = posY
		
		local posVec = Vector2.new(-posX * 32, -posY * 32)
		local currentPosVec = Vector2.new(self.frame.AbsolutePosition.X, self.frame.AbsolutePosition.Y)
		
		local newPos = currentPosVec:lerp(posVec, 8 * deltaTime)
		
		self.frame.Position = UDim2.new(0, newPos.X, 0, newPos.Y)

		local used = {}
		
		--Rounded so it matched up with the levels integer positions
		posX = math.floor(posX)
		posY = math.floor(posY)

		--Loops the size of the screen plus 1/4 over the edges
		for x = math.floor(-self.sizeX / 4), math.floor(self.sizeX + self.sizeY / 4) do
			for y = math.floor(-self.sizeY / 4), math.floor(self.sizeY + self.sizeY / 4) do
				local posXX = math.min(self.game.level.width, posX + x)
				local posYY = math.min(self.game.level.height, posY + y)
				posXX = math.max(1, posXX)
				posYY = math.max(1, posYY)

				self.rendered[posXX] = self.rendered[posXX] or {}
				used[posXX] = used[posXX] or {}
				used[posXX][posYY] = true
				
				--Checks if this tile has already been rendered, if not it renders it
				if not self.rendered[posXX][posYY] then
					if self.game.level.tiles[posXX] and self.game.level.tiles[posXX][posYY] then
						self.rendered[posXX][posYY] = Tile.Tiles[self.game.level.tiles[posXX][posYY]]:render(self, posXX, posYY)
					end
				end
			end
		end
		
		--Checks the rendered tiles to see if they still need to be rendered
		--I.E removes tiles that are not on the screen
		for x, ytab in pairs(self.rendered) do
			for y, tile in pairs(ytab) do
				if not used[x] then
					for y, tile in pairs(ytab) do
						tile:Destroy()
						self.rendered[x][y] = nil
					end
					self.rendered[x] = nil
					used[x] = nil
					break
				elseif not used[x][y] then
					tile:Destroy()
					self.rendered[x][y] = nil
					used[x][y] = nil
				end
			end
		end

	end
end