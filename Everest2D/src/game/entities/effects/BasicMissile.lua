--client
repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("Entity")

do BasicMissile = Extends(Entity)
	_G.BasicMissile = BasicMissile
	BasicMissile.__index = BasicMissile

	function BasicMissile.new(id, level, speed, posX, posY, type, dirVec, size, color)
		local basicMissile = Entity.new(id, level, posX, posY)
		setmetatable(basicMissile, BasicMissile)

		basicMissile.speed = speed
		basicMissile.type = type
		basicMissile.movingDir = movingDir
		basicMissile.size = size
		basicMissile.color = color
		basicMissile.frame = Instance.new("ImageLabel", _G.localgame.screen.frame)
		basicMissile.frame.Name = "testBasicMissile"
		basicMissile.frame.Size = size
		basicMissile.frame.BorderSizePixel = 0
		basicMissile.frame.BackgroundTransparency = 0
		basicMissile.frame.ZIndex = 5
		basicMissile.frame.Position = UDim2.new(0, posX * 32, 0, posY * 32)
		basicMissile.frame.BackgroundColor3 = color
		basicMissile.endPos = basicMissile.level:rayCast(Vector2.new(posX, posY), dirVec)
		local timeToTake = (Vector2.new(posX, posY) - basicMissile.endPos).magnitude^.5 / speed
		basicMissile.frame:TweenPosition(UDim2.new(0, basicMissile.endPos.X * 32, 0, basicMissile.endPos.Y * 32), "Out", "Linear", timeToTake, true)	
		coroutine.wrap(function() wait(timeToTake) basicMissile.frame:Destroy() basicMissile = nil end)()
		return basicMissile
	end
	
	function BasicMissile:render()
	
	end
end
