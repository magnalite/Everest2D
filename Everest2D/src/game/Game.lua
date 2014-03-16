--The game class coordinates all of the games calls and functions


--Allows access to the datamodel
if script.Parent.ClassName == "LocalScript" then game.Players.LocalPlayer.PlayerGui.Everest2D.Parent = nil end

_G.rbxGame = game
repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

--Defines the game class
do Game = Class("Game")

	function Game.new()
		local game = {}
		setmetatable(game, Game)

		Import("Screen")
		
		if not _G.isServer then 
			local tempScreenSize = LocalPlayer.PlayerGui.ScreenGui.AbsoluteSize

			game.screenSizeHolder = LocalPlayer.PlayerGui.ScreenGui
			
			for _, v in pairs(game.screenSizeHolder:GetChildren()) do v:Destroy() end
			

			
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
			
			game.screenSizeHolder.Changed:connect(function() 
				local tempScreenSize = game.screenSizeHolder.AbsoluteSize
				game.canvasPart.Size = Vector3.new(3*math.tan(math.rad(35)) * 2 * (tempScreenSize.X/tempScreenSize.Y) , 3*math.tan(math.rad(35)) * 2, 0)
				game.canvas.CanvasSize = tempScreenSize
				if game.screen then
					game.screen.sizeX = game.canvas.AbsoluteSize.X / 32
					game.screen.sizeY = game.canvas.AbsoluteSize.Y / 32
				end
			end)
			
			
			
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
	
		self.lasttick = tick()
		self.lastframe = tick()
		
		--The game cycle (calls everything)
		
		if _G.isServer then
			while self.running do
				wait(1/20)
				self:tick()
			end
		end
		
		local lasttick = tick()
		
		_G.rbxGame:GetService("RunService").RenderStepped:connect(function()
			self:render()
			if tick() - lasttick >= 0.05 then
				self:tick()
				lasttick = tick()
			end
		end)
		
	end

	Import("Level")
	Import("SERVER_PACKET007_CHATTED")

	function Game:tick(deltaTime)
		self.tickCount = self.tickCount + 1
		
		local deltaTime = tick() - self.lasttick
		self.lasttick = tick()
		
		
		if self.player then
			self.screen.hud.tickCounter.Text = "Tick Rate  " .. math.ceil(1/deltaTime)
			self.player.level:tick(deltaTime)
		end

					
		if _G.isServer then
			--[[if math.random(1, 20) == 1 then
				for playerTo, _ in pairs(_G.localserver.players) do
					_G.localserver.packetHandler:sendPacket(playerTo, SERVER_PACKET007_CHATTED.new("Server", Color3.new(1,1,1), " The current server tick rate is : " .. tostring(math.ceil(1/deltaTime)), Color3.new(1,1,1)):Data())
				end
			end]]--
			for i, v in pairs(Level.allLevels) do
				v:tick(deltaTime)
			end
		end

	end
	
	function Game:render(deltaTime)
		if not _G.isServer then
		
			local deltaTime = tick() - self.lastframe
			self.lastframe = tick()
		
			self.frameCount = self.frameCount + 1

			if self.player then
				self.screen.hud.frameCounter.Text = "Frame Rate  " .. math.ceil(1/deltaTime)
				self.player.level:render(deltaTime)
				self.screen:render(deltaTime, self.player.posX - (self.screen.sizeX / 2), self.player.posY - (self.screen.sizeY / 2))
			end
		end
	end

end

Import("Server")

do --MAIN
	wait(2)
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
	repeat wait() until game.start
	game:start()
end