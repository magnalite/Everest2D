--client
repeat wait() until _G.Import
_G.Import("Import")

do Tile = {}
	_G.Tile = Tile
	Tile.__index = Tile
	
	Tile.Tiles = {}
	
	function Tile.new(id, isWalkable)
		local tile = {}
		setmetatable(tile, Tile)		
		
		if Tile.Tiles[id] then error("Tile ID Conflict id: " .. id) end
		Tile.Tiles[id] = tile
		
		tile.id = id
		tile.isWalkable = isWalkable
				
		return tile
	end
	
	function Tile:render(screen, posX, posY)
		
		local rendered = Instance.new("ImageLabel", screen.frame)
		rendered.BorderSizePixel = 0
		rendered.ZIndex = 2
		rendered.Size = UDim2.new(1.05 / screen.sizeX, 0, 1.05 / screen.sizeY, 0)
		rendered.Position = UDim2.new(posX / screen.sizeX, 0, posY / screen.sizeY, 0)
		rendered.Image = self.spriteSheet.url
		rendered.ImageRectSize = self.spriteSheet.vector2Size
		rendered.ImageRectOffset = self.spritePosVec
		
		return rendered
	end
	
	Import("BasicTile")
	Import("SpriteSheet")
	
	Tile.GRASS = BasicTile.new(1, SpriteSheet.BasicSpriteSheet, 0, 0)
	Tile.FLOWER1 = BasicTile.new(2, SpriteSheet.BasicSpriteSheet, 16, 0)
	Tile.FLOWER2 = BasicTile.new(3, SpriteSheet.BasicSpriteSheet, 32, 0)
end