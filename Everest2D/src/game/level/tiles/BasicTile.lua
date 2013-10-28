--client

repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("Tile")


repeat wait() until Extends
do BasicTile = Extends(Tile)
	_G.BasicTile = BasicTile
	BasicTile.__index = BasicTile
	
	function BasicTile.new(id, spriteSheet, spritePosX, spritePosY)
		basicTile = Tile.new(id, true)
		setmetatable(basicTile, BasicTile)
		
		basicTile.spriteSheet = spriteSheet
		basicTile.spritePosX = spritePosX
		basicTile.spritePosY = spritePosY
		basicTile.spriteSizeX = spriteSheet.spriteSizeX-1
		basicTile.spriteSizeY = spriteSheet.spriteSizeY-1	
		basicTile.spritePosVec = Vector2.new(spritePosX-1, spritePosY-1)
		
		return basicTile	
	end	
	
end