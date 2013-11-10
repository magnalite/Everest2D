--client
repeat wait() until _G.Import
_G.Import("Import")


do Screen = {}
	_G.Screen = Screen
	Screen.__index = Screen

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

		screen.game = game
		screen.sizeX = sizeX
		screen.sizeY = sizeY
		screen.rendered = {}

		return screen
	end

	Import("Tile")


	function Screen:render(posX, posY)

		while not self.game.level.ready and not #Tile.Tiles > 0 do wait() end

		local posX = math.min(self.game.level.width + 1 - self.sizeX, posX)
		local posY = math.min(self.game.level.height + 1 - self.sizeY, posY)
		local posX = math.max(1, posX)
		local posY = math.max(1, posY)

		self.frame:TweenPosition(UDim2.new(0, -posX * 32, 0, -posY * 32), "Out", "Linear", 0.2, true)

		local used = {}

		posX = math.floor(posX)
		posY = math.floor(posY)

		for x = math.floor(-self.sizeX / 4), math.floor(self.sizeX + self.sizeY / 4) do
			for y = math.floor(-self.sizeY / 4), math.floor(self.sizeY + self.sizeY / 4) do
				local posXX = math.min(self.game.level.width, posX + x)
				local posYY = math.min(self.game.level.height, posY + y)
				local posXX = math.max(1, posXX)
				local posYY = math.max(1, posYY)

				self.rendered[posXX] = self.rendered[posXX] or {}
				used[posXX] = used[posXX] or {}
				used[posXX][posYY] = true
				if not self.rendered[posXX][posYY] then
					if self.game.level.tiles[posXX] and self.game.level.tiles[posXX][posYY] then
						self.rendered[posXX][posYY] = Tile.Tiles[self.game.level.tiles[posXX][posYY]]:render(self, posXX, posYY)
					end
				end
			end
		end

		for x, ytab in pairs(self.rendered) do
			for y, tile in pairs(ytab) do
				if not used[x] then
					for y, tile in pairs(ytab) do
						tile:Destroy()
					end
					self.rendered[x] = nil
					break
				elseif not used[x][y] then
					tile:Destroy()
					self.rendered[x][y] = nil
				end
			end
		end

	end
end