--client
repeat wait() until game.Players.LocalPlayer.Character
game.Players.LocalPlayer.Character:Destroy()
repeat wait() until _G.Import
_G.Import("Import")

Import("LocalPlayer")

do Game = {}
	_G.Game = Game
	Game.__index = Game

	function Game.new()
		local game = {}
		setmetatable(game, Game)
		
		Import("Screen")
		Import("Level")
		Import("InputHandler")
		Import("Player")
		
		game.canvas = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
		
		game.level = Level.new(100, 100)
		repeat wait() until game.level.testRandomGenerate
		game.level:testRandomGenerate()
		
		game.screen = Screen.new(game, 32, math.floor(32 * (game.canvas.AbsoluteSize.Y / game.canvas.AbsoluteSize.X)))
		game.running = false
		game.localPlayer = LocalPlayer
		game.inputHandler = InputHandler.new(game)
		game.player = Player.new(game, game.level, 0, 0, game.inputHandler)		
		
		game.tickCount = 0
		game.frameCount = 0
		
		return game
	end

	function Game:start()
		self.running = true
		
		coroutine.wrap(function()
			self:run()
		end)()
	end
	
	function Game:stop()
		self.running = false
	end

	function Game:run()
		local timeAtStart tick()
		local lastTime = tick()
		local minTimePerTick = 1/60
		local minTimePerFrame = 1/60
		
		local ticks = 0
		local frames = 0
	
		local lastTimer = tick()
		local unProcessedTime = 0
		local unRenderedTime = 0
		
		while (self.running) do
			local now = tick()
			unProcessedTime = unProcessedTime + ((now - lastTime) / minTimePerTick)
			unRenderedTime = unRenderedTime + ((now - lastTime) / minTimePerFrame)
			lastTime = now
			
			while (unProcessedTime >= 1) do
				ticks = ticks + 1
				self:tick()
				unProcessedTime = unProcessedTime - 1
			end
			
			while (unRenderedTime >= 1) do		
				frames = frames + 1
				self:render()
				unRenderedTime = unRenderedTime - 1
			end
			
			wait(0)
			
			if (now - lastTimer >= 1 ) then				
				lastTimer = lastTimer + 1
				print(frames .. " frames : " .. ticks .. " ticks")
				frames = 0
				ticks = 0			
			end
		end
	end
	
	function Game:tick()
		self.tickCount = self.tickCount + 1
		self.level:tick()
		
	end
	
	function Game:render()
		self.frameCount = self.frameCount + 1
		self.level:render()
		self.screen:render(self.player.posX - (self.screen.sizeX / 2), self.player.posY - (self.screen.sizeY / 2))
		
	end
end

do --MAIN
	game.StarterGui:SetCoreGuiEnabled(2, false)
	wait(2)
	local game = Game.new()
	game:start()
end