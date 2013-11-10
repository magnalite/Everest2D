--client
repeat wait() until _G.Import
_G.Import("Import")


do Game = {}
	_G.Game = Game
	Game.__index = Game

	function Game.new()
		local game = {}
		setmetatable(game, Game)

		Import("Screen")

		if not _G.isServer then
			game.canvas = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
			Import("InputHandler")
			game.localPlayer = LocalPlayer
			game.inputHandler = InputHandler.new(game)
		else
			game.canvas = Instance.new("ScreenGui", game.ServerStorage)
		end
		game.canvas.Name = "Everest2DGame"

		game.screen = Screen.new(game, math.ceil(game.canvas.AbsoluteSize.X / 32), math.ceil(game.canvas.AbsoluteSize.Y / 32))
		game.running = false

		game.packetHandler = Workspace.PacketHandler

		function game.packetHandler.OnClientInvoke(data)
			game:recievedPacket(data)
		end

		game.tickCount = 0
		game.frameCount = 0

		return game
	end

	function Game:start()
		self.running = true

		if not _G.isServer then
			self:sendPacket({"LOGIN"})
		end

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
				frames = 0
				ticks = 0
			end
		end
	end

	function Game:tick()
		self.tickCount = self.tickCount + 1

		if self.player then
			self.player.level:tick()
		end

	end

	Import("Level")
	Import("Player")


	function Game:render()
		if not _G.isServer then
			self.frameCount = self.frameCount + 1

			if self.player then
				self.player.level:render()
				self.screen:render(self.player.posX - (self.screen.sizeX / 2), self.player.posY - (self.screen.sizeY / 2))
			end
		end
	end

	function Game:recievedPacket(data)

		if data[1] == "START" then
			self.level = Level[data[2]]
			self.player = Player.new(self, self.level, self.localPlayer.Name, data[3], data[4], self.inputHandler)
		elseif data[1] == "SPAWN" then
			if data[2] == "Player" then
				Player.new(self, self.level, 100, data[3], data[4], data[5], nil)
			end
		elseif data[1] == "PLAYERMOVE" then

			Player.players[data[2]]:move(data[3], data[4], "PLAYER")

		end

	end

	function Game:sendPacket(data)
		coroutine.wrap(function(data)
			self.packetHandler:InvokeServer(data)
		end)(data)
	end

end

Import("Server")

do --MAIN
	if script.Parent.Parent.Name == "Everest2DServer" then
		Server.new()
		_G.isServer = true
	else
		Import("LocalPlayer")
		repeat wait() until game.Players.LocalPlayer.Character
		game.Players.LocalPlayer.Character:Destroy()
		game.StarterGui:SetCoreGuiEnabled(2, false)
		wait(5)
	end

	repeat wait() until Workspace:FindFirstChild("PacketHandler")
	local game = Game.new()
	game:start()
end