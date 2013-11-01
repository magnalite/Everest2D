--client

repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("BasicTile")


repeat wait() until Extends
do AnimatedTile = Extends(BasicTile)
	_G.AnimatedTile = AnimatedTile
	AnimatedTile.__index = AnimatedTile
	
	function AnimatedTile.new(id, isWalkable, spriteSheet, spritePosX, spritePosY, frames, delay)
		local animatedTile = BasicTile.new(id, isWalkable, spriteSheet, spritePosX, spritePosY)
		setmetatable(animatedTile, AnimatedTile)
		
		animatedTile.frames = frames
		animatedTile.delay = delay
	
		return animatedTile
	end
	
	function AnimatedTile:render(screen, posX, posY)
	
		local rendered = Instance.new("ImageLabel", screen.frame)
		rendered.BorderSizePixel = 0
		rendered.ZIndex = 2
		rendered.Size = UDim2.new(1.05 / screen.sizeX, 0, 1.05 / screen.sizeY, 0)
		rendered.Position = UDim2.new(posX / screen.sizeX, 0, posY / screen.sizeY, 0)
		rendered.Image = self.spriteSheet.url
		rendered.ImageRectSize = self.spriteSheet.vector2Size
		
		local currentFrame = math.floor((screen.game.tickCount / self.delay)) % self.frames
		local frameDir = 1
		local lastFrameTick = screen.game.tickCount
		
		coroutine.wrap(function()
		
			while wait() do
			
				currentFrame = math.floor(math.abs(math.sin(screen.game.tickCount / self.delay) * self.frames))
				
				lastFrameTick = screen.game.tickCount + self.delay
				
				rendered.ImageRectOffset = Vector2.new(self.spritePosVec.X + (currentFrame * self.spriteSheet.vector2Size.X), self.spritePosVec.Y)
				--currentFrame = currentFrame + frameDir
				
				--if currentFrame <= 0 or currentFrame >= self.frames - 1 then
					--frameDir = -frameDir
				--end
				
			end
			
		end)()
		
		self.instance = rendered
		
		
		return self
	end
	
	
end