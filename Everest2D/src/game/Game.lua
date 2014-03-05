--client

--The game class coordinates all of the games calls and functions


--Allows access to the datamodel
<<<<<<< HEAD
if script.Parent.ClassName == "LocalScript" then game.Players.LocalPlayer.PlayerGui.Everest2D.Parent = nil end

_G.rbxGame = game
repeat wait() until _G.Import
_G.Import("Import")

--Defines the game class
do Game = {}
	_G.Game = Game
	Game.__index = Game

	function Game.new()
		local game = {}
		setmetatable(game, Game)

		Import("Screen")
		
		if not _G.isServer then 
			local tempScreenSize = LocalPlayer.PlayerGui.ScreenGui.AbsoluteSize
		
			LocalPlayer.PlayerGui.ScreenGui:Destroy()
			
			game.canvasPart = Instance.new("Part", Workspace.CurrentCamera)
			game.canvasPart.Anchored = true
			game.canvasPart.FormFactor = "Custom"
			game.canvasPart.Size = Vector3.new(3*math.tan(math.rad(35)) * 2 * (tempScreenSize.X/tempScreenSize.Y) , 3*math.tan(math.rad(35)) * 2, 0)
			
			Workspace.CurrentCamera.CameraType = "Scriptable"
			Workspace.CurrentCamera.CameraSubject = game.canvasPart
			Workspace.CurrentCamera.CoordinateFrame = CFrame.new(game.canvasPart.Position + game.canvasPart.CFrame.lookVector*3.1, game.canvasPart.Position)
			Workspace.CurrentCamera.Focus = game.canvasPart.CFrame
			
			game.canvas = Instance.new("SurfaceGui", game.canvasPart)
			game.canvas.CanvasSize = tempScreenSize
			game.canvas.Adornee = game.canvasPart
			
			Import("InputHandler")
			Import("ClientPacketHandler")
			
			game.localPlayer = LocalPlayer
			game.inputHandler = InputHandler.new(game)
			game.packetHandler = ClientPacketHandler.new()
			
		else
			game.localPlayer = {Name = "Server"}
			game.canvas = Instance.new("ScreenGui", game.ServerStorage)
			
		end
		game.canvas.Name = "Everest2DGame"

		game.screen = Screen.new(game, math.ceil(game.canvas.AbsoluteSize.X / 32), math.ceil(game.canvas.AbsoluteSize.Y / 32))
		game.running = false

		game.tickCount = 0
		game.frameCount = 0

		return game
	end

	function Game:start()
		self.running = true

		Import("CLIENT_PACKET001_LOGIN")

		if not _G.isServer then
			self.packetHandler:sendPacket(CLIENT_PACKET001_LOGIN.new():Data())
			--coroutine.wrap(function()  --Stops client from being disconnected due to lost connection
				--while wait(5) do self.packetHandler:sendPacket({"KEEPCONNECTION"}) end
			--end)()
		end

		coroutine.wrap(function()
			self:run()
		end)()
	end

	function Game:stop()
		self.running = false
		self.player:Destroy()
		self.screen.frame:Destroy()
		self.screen.ClippingMask:Destroy()
		local loaderInfo = Instance.new("TextLabel", self.canvas)
		loaderInfo.Size = UDim2.new(1,0,1,0)
		loaderInfo.BackgroundColor3 = Color3.new(0,0,0)
		loaderInfo.Text = "You have lost connection"
		loaderInfo.TextScaled = true
		loaderInfo.TextColor3 = Color3.new(0,0,0)
		loaderInfo.TextStrokeColor3 = Color3.new(141 / 255, 70 / 255, 212 / 255)
		loaderInfo.TextStrokeTransparency = 0
	end

	function Game:run()
		local timeAtStart = tick()
		local lastTime = tick()
		local minTimePerTick = 1/60
		local minTimePerFrame = 1/60

		local ticks = 0
		local frames = 0

		local lastTimer = tick()
		local unProcessedTime = 0
		local unRenderedTime = 0
	
		--The game cycle (calls everything)
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
	
	function Game:render()
		if not _G.isServer then
			self.frameCount = self.frameCount + 1

			if self.player then
				self.player.level:render()
				self.screen:render(self.player.posX - (self.screen.sizeX / 2), self.player.posY - (self.screen.sizeY / 2))
			end
		end
	end

end

Import("Server")

do --MAIN
	if script.Parent.Parent.Name == "Everest2DServer" then
		Server.new()
		_G.isServer = true
		
		--Tell people that everest is loading when they join
		local loaderScreen = Instance.new("ScreenGui", game.StarterGui)
		local loaderInfo = Instance.new("TextLabel", loaderScreen)
		loaderInfo.Size = UDim2.new(1,0,1,0)
		loaderInfo.BackgroundColor3 = Color3.new(0,0,0)
		loaderInfo.Text = "Please wait - Everest2D is loading"
		loaderInfo.TextScaled = true
		loaderInfo.TextColor3 = Color3.new(0,0,0)
		loaderInfo.TextStrokeColor3 = Color3.new(141 / 255, 70 / 255, 212 / 255)
		loaderInfo.TextStrokeTransparency = 0
		--Stops people falling when they join
		local loaderBlock = Instance.new("Part", Workspace)
		loaderBlock.Anchored = true
		loaderBlock.Size = Vector3.new(100,10,100)
		loaderBlock.Position = Vector3.new(-50, -20, -50)
		wait(5)
	else
		Import("LocalPlayer")
		repeat wait() until game.Players.LocalPlayer.Character
		game.Players.LocalPlayer.Character:Destroy()
		game.StarterGui:SetCoreGuiEnabled(2, false)
		wait(5)
	end
	--waits for the server to start up (it creates the packethandler)
	repeat wait() until Workspace:FindFirstChild("PacketHandler")
	local game = Game.new()
	_G.localgame = game
=======
_G.rbxGame = game
repeat wait() until _G.Import
_G.Import("Import")

--Defines the game class
do Game = {}
	_G.Game = Game
	Game.__index = Game

	function Game.new()
		local game = {}
		setmetatable(game, Game)

		Import("Screen")

		if not _G.isServer then 
			local tempScreenSize = LocalPlayer.PlayerGui.ScreenGui.AbsoluteSize
			LocalPlayer.PlayerGui.ScreenGui:Destroy()
			LocalPlayer.PlayerGui.Everest2D.Parent = nil
			game.canvasPart = Instance.new("Part", Workspace.CurrentCamera)
			game.canvasPart.Anchored = true
			game.canvasPart.FormFactor = "Custom"
			game.canvasPart.Size = Vector3.new(3*math.tan(math.rad(35)) * 2 * (tempScreenSize.X/tempScreenSize.Y) , 3*math.tan(math.rad(35)) * 2, 0)
			Workspace.CurrentCamera.CameraType = "Scriptable"
			Workspace.CurrentCamera.CameraSubject = game.canvasPart
			Workspace.CurrentCamera.CoordinateFrame = CFrame.new(game.canvasPart.Position + game.canvasPart.CFrame.lookVector*3.1, game.canvasPart.Position)
			Workspace.CurrentCamera.Focus = game.canvasPart.CFrame
			game.canvas = Instance.new("SurfaceGui", game.canvasPart)
			game.canvas.CanvasSize = tempScreenSize
			game.canvas.Adornee = game.canvasPart
			Import("InputHandler")
			game.localPlayer = LocalPlayer
			game.inputHandler = InputHandler.new(game)
		else
			game.localPlayer = {Name = "Server"}
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
			coroutine.wrap(function()  --Stops client from being disconnected due to lost connection
				while wait(5) do self:sendPacket({"KEEPCONNECTION"}) end
			end)()
		end

		coroutine.wrap(function()
			self:run()
		end)()
	end

	function Game:stop()
		self.running = false
		self.player:Destroy()
		self.screen.frame:Destroy()
		self.screen.ClippingMask:Destroy()
		local loaderInfo = Instance.new("TextLabel", self.canvas)
		loaderInfo.Size = UDim2.new(1,0,1,0)
		loaderInfo.BackgroundColor3 = Color3.new(0,0,0)
		loaderInfo.Text = "You have lost connection"
		loaderInfo.TextScaled = true
		loaderInfo.TextColor3 = Color3.new(0,0,0)
		loaderInfo.TextStrokeColor3 = Color3.new(141 / 255, 70 / 255, 212 / 255)
		loaderInfo.TextStrokeTransparency = 0
	end

	function Game:run()
		local timeAtStart = tick()
		local lastTime = tick()
		local minTimePerTick = 1/60
		local minTimePerFrame = 1/60

		local ticks = 0
		local frames = 0

		local lastTimer = tick()
		local unProcessedTime = 0
		local unRenderedTime = 0
	
		--The game cycle (calls everything)
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
			self.player = Player.new(self, self.level, 100, self.localPlayer.Name, data[3], data[4], self.inputHandler)
		elseif data[1] == "SPAWN" then
			if data[2] == "Player" then
				Player.new(self, self.level, 100, data[3], data[4], data[5], nil)
			end
		elseif data[1] == "PLAYERMOVE" then
			Player.players[data[2]]:move(data[3], data[4], "PLAYER", data[5], data[6])
		elseif data[1] == "DISCONNECT" then
			self:stop()
		elseif data[1] == "DISCONNECTOTHER" then
			Player.players[data[2]]:Destroy()
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
		
		--Tell people that everest is loading when they join
		local loaderScreen = Instance.new("ScreenGui", game.StarterGui)
		local loaderInfo = Instance.new("TextLabel", loaderScreen)
		loaderInfo.Size = UDim2.new(1,0,1,0)
		loaderInfo.BackgroundColor3 = Color3.new(0,0,0)
		loaderInfo.Text = "Please wait - Everest2D is loading"
		loaderInfo.TextScaled = true
		loaderInfo.TextColor3 = Color3.new(0,0,0)
		loaderInfo.TextStrokeColor3 = Color3.new(141 / 255, 70 / 255, 212 / 255)
		loaderInfo.TextStrokeTransparency = 0
		--Stops people falling when they join
		local loaderBlock = Instance.new("Part", Workspace)
		loaderBlock.Anchored = true
		loaderBlock.Size = Vector3.new(100,10,100)
		loaderBlock.Position = Vector3.new(-50, -20, -50)
		
	else
		Import("LocalPlayer")
		repeat wait() until game.Players.LocalPlayer.Character
		game.Players.LocalPlayer.Character:Destroy()
		game.StarterGui:SetCoreGuiEnabled(2, false)
		wait(5)
	end
	--waits for the server to start up (it creates the packethandler)
	repeat wait() until Workspace:FindFirstChild("PacketHandler")
	local game = Game.new()
>>>>>>> refs/remotes/origin/master
	game:start()
end
