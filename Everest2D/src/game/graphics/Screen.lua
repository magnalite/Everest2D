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

		while not self.game.level.ready and not #Tile.Tiles > 0 do wait() end --checks if level is ready

		local posX = math.min(self.game.level.width + 1 - self.sizeX, posX) --ensures the camera isnt trying to move off the map
		local posY = math.min(self.game.level.height + 1 - self.sizeY, posY)--ensures the camera isnt trying to move off the map
		local posX = math.max(1, posX)--ensures the camera isnt trying to move off the map
		local posY = math.max(1, posY)--ensures the camera isnt trying to move off the map

		self.frame:TweenPosition(UDim2.new(-(posX / self.sizeX), 0, -(posY / self.sizeY), 0), "Out", "Linear", 0.2, true)--moves the camera

		local used = {}--Table of used tiles (youll see later)

		posX = math.floor(posX)--rounds the position
		posY = math.floor(posY)--rounds the position

		for x = math.floor(-self.sizeX / 4), math.floor(self.sizeX + self.sizeY / 4) do --iterates the size of the screen plus a little bit (so you cant see the clipping)
			for y = math.floor(-self.sizeY / 4), math.floor(self.sizeY + self.sizeY / 4) do --iterates the size of the screen plus a little bit (so you cant see the clipping)
				local posXX = math.min(self.game.level.width, posX + x)--ensures the tile it is rendering isnt off the level
				local posYY = math.min(self.game.level.height, posY + y)--ensures the tile it is rendering isnt off the level
				local posXX = math.max(0, posXX)--ensures the tile it is rendering isnt off the level
				local posYY = math.max(0, posYY)--ensures the tile it is rendering isnt off the level

				self.rendered[posXX] = self.rendered[posXX] or {} --creates multi dimensions table for x and y coords
				used[posXX] = used[posXX] or {}--creates multi dimensions table for x and y coords
				used[posXX][posYY] = true --says that we have used this tile
				if not self.rendered[posXX][posYY] then --if this tile is not rendered then
					if self.game.level.tiles[posXX] and self.game.level.tiles[posXX][posYY] then --if this tiles exists
						self.rendered[posXX][posYY] = Tile.Tiles[self.game.level.tiles[posXX][posYY]]:render(self, posXX, posYY) --render this tile
					end
				end
			end
		end

		for x, ytab in pairs(self.rendered) do --goes through the rendered table
			for y, tile in pairs(ytab) do--goes through the rendered table
				if not used[x] then --if x has not been used
					for y, tile in pairs(ytab) do --go through all the values at that x
						tile.instance:Destroy() --destroy those tiles
					end
					self.rendered[x] = nil --remove those tiles from rendered
					break 
				elseif not used[x][y] then --if the tile at x and y isnt used
					tile.instance:Destroy() --destroy it
					self.rendered[x][y] = nil --remove it from rendered table
				end
			end
		end

	end
end