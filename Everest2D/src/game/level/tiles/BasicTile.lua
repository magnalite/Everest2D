--Basic general purpose tile

repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("Tile")

do BasicTile = Extends("BasicTile", Tile)
	
	function BasicTile.new(id, isWalkable, spriteSheet, spritePosX, spritePosY)
		basicTile = Tile.new(id, isWalkable)
		setmetatable(basicTile, BasicTile)
		
		basicTile.spriteSheet = spriteSheet
		basicTile.spritePosX = spritePosX
		basicTile.spritePosY = spritePosY
		basicTile.spriteSizeX = spriteSheet.spriteSizeX
		basicTile.spriteSizeY = spriteSheet.spriteSizeY	
		basicTile.spritePosVec = Vector2.new(spritePosX, spritePosY)
		
		return basicTile	
	end	
	
end