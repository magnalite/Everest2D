--Custom input handler for convenience

repeat wait() until _G.Import
_G.Import("Import")

do InputHandler = {}
	_G.InputHandler = InputHandler
	InputHandler.__index = InputHandler
	
	function InputHandler.new(game)
		local inputHandler = {}
		setmetatable(inputHandler, InputHandler)		
		
		inputHandler.keys = {}
		inputHandler.mouse = game.localPlayer:GetMouse()		
		
		--Allows to easily see which keys are being held down
		inputHandler.mouse.KeyDown:connect(function(key) inputHandler:keyDown(key) end)		
		inputHandler.mouse.KeyUp:connect(function(key) inputHandler:keyUp(key) end)			
		
		return inputHandler
	end
	
	function InputHandler:keyDown(key)
		self.keys[key] = true
	end
	
	function InputHandler:keyUp(key)
		self.keys[key] = false		
	end
end