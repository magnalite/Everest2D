--Base tile, extend to make new tile types

repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do Tile = Class("Tile")
	
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
	
	function Tile:tick()
	
	end
	
	function Tile:render(screen, posX, posY)
		
		local rendered = Instance.new("ImageLabel", screen.frame)
		rendered.BorderSizePixel = 0
		rendered.ZIndex = 2
		rendered.Size = UDim2.new(0, 32, 0, 32)
		rendered.Position = UDim2.new(0, posX * 32, 0, posY * 32)
		rendered.Image = self.spriteSheet.url
		rendered.ImageRectSize = self.spriteSheet.vector2Size + Vector2.new(-2, -2)
		rendered.ImageRectOffset = self.spritePosVec + Vector2.new(1,1)
		
		
		return rendered
	end
	
	Import("BasicTile")
	Import("AnimatedTile")
	Import("SpriteSheet")
	
	--All tile types are declared here
	--id, walkable, spritesheet, spritesheetposition
	Tile.GRASS = BasicTile.new(1, true, SpriteSheet.BasicSpriteSheet, 0, 0)
	Tile.FLOWER1 = BasicTile.new(2, true, SpriteSheet.BasicSpriteSheet, 32, 0)
	Tile.FLOWER2 = BasicTile.new(3, true, SpriteSheet.BasicSpriteSheet, 64, 0)
	Tile.STONE = BasicTile.new(4, false, SpriteSheet.BasicSpriteSheet, 0, 32)
	Tile.Water = AnimatedTile.new(5, false, SpriteSheet.BasicSpriteSheet, 0, 64, 3, 60)
end