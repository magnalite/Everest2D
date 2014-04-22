--[[
----------------------
--- Main Game Class---
----------------------

Contains these functions

.new()
--Constructs a new Game class
--Returns a Game class construct

:start()
--Starts Game running
--Returns nothing

:stop()
--Stops the game running
--Returns nothing

:run()
**Should only be called by :start()**
--Initialises the main game loop
--Returns nothing

:tick(deltaTime)
**Should only be called by :run()**
--Steps game logic by one tick
--Returns nothing

:render(deltaTime)
**Should only be called by :run()**
--Renders the game logic in it's current state
--Returns nothing

--]]


--Allows scripts to continue execution while in nil (To allow for nil'd players)
if script.Parent.ClassName == "LocalScript" then game.Players.LocalPlayer.PlayerGui.Everest2D.Parent = nil end
--Allows access to the datamodel
_G.rbxGame = game
--Wait for Import to become available
repeat wait() until _G.Import
_G.Import("Import")

--Import the Class define function from game.util
Import("Class")

--Defines the game class
do Game = Class("Game")


	--Requires no arguments
	--Constructs a new Game class
	--Returns a new game class construct
	function Game.new()
		local game = {}
		setmetatable(game, Game)
		
		--Import a Screen object from game.graphics.Screen
		--Used to render clientside
		Import("Screen")
		
		--If this is clientside then
		if not _G.isServer then
			--Get the players screen size in pixels
			local tempScreenSize = LocalPlayer.PlayerGui.ScreenGui.AbsoluteSize
			--Add their screen size as a variable in game
			--Has to be a ScreenGui so it resizes in real time
			--Allows it to be accessed later for use in rendering screen
			game.screenSizeHolder = LocalPlayer.PlayerGui.ScreenGui
			--Remove all the children from screenSizeHolder so nothing in rendering in it
			for _, v in pairs(game.screenSizeHolder:GetChildren()) do v:Destroy() end
			--The part the game will be drawn on
			--In CurrentCamera so it is local to the user
			game.canvasPart = Instance.new("Part", Workspace.CurrentCamera)
			game.canvasPart.Anchored = true
			game.canvasPart.FormFactor = "Custom"
			--X size is 3*tan(fov/2) * 2 * aspect ratio
			-- -- fov is divided by 2 to make a right angle triangle
			-- -- 3 * tan as it will be 3 studs away
			-- -- 2 * as the fov is divided by two
			-- -- +20 to the screen size to account for chat bar
			
			--Y size is 3 * tan(fov/2) * 2
			-- -- fov is divided by 2 to make a right angle triangle
			-- -- 3 * tan as it will be 3 studs away
			-- -- 2 * as the fov is divided by two
			
			--Z size is 0 as we are only looking at the front face(Therefore 2D)
			game.canvasPart.Size = Vector3.new(3*math.tan(math.rad(35)) * 2 * (tempScreenSize.X/(tempScreenSize.Y+20)) , 3*math.tan(math.rad(35)) * 2, 0)
			--Stop user control on camera
			Workspace.CurrentCamera.CameraType = "Scriptable"
			--Aim the camera at the canvasPart (where the game will be played on)
			Workspace.CurrentCamera.CameraSubject = game.canvasPart
			Workspace.CurrentCamera.CoordinateFrame = CFrame.new(game.canvasPart.Position + game.canvasPart.CFrame.lookVector*3.1, game.canvasPart.Position)
			Workspace.CurrentCamera.Focus = game.canvasPart.CFrame
			--Place a SurfaceGui on the canvasPart
			--This will contain the game graphics
			--A SurfaceGui to allow for nil'd players
			game.canvas = Instance.new("SurfaceGui", game.canvasPart)
			game.canvas.CanvasSize = tempScreenSize
			game.canvas.Adornee = game.canvasPart
			--If the players screen size changes then
			--Update all the screen size values
			game.screenSizeHolder.Changed:connect(function() 
				local tempScreenSize = game.screenSizeHolder.AbsoluteSize
				--Look above for explanation
				game.canvasPart.Size = Vector3.new(3*math.tan(math.rad(35)) * 2 * (tempScreenSize.X/(tempScreenSize.Y+20)) , 3*math.tan(math.rad(35)) * 2, 0)
				game.canvas.CanvasSize = tempScreenSize
				if game.screen then
					--Divided by 32 as tiles are 32x32
					game.screen.sizeX = game.canvas.AbsoluteSize.X / 32
					game.screen.sizeY = game.canvas.AbsoluteSize.Y / 32
				end
			end)
			
			--Import InputHandler to allow for easy handling of user input
			Import("InputHandler")
			--Import ClientPacketHandler so we can start replication
			Import("ClientPacketHandler")
			
			game.localPlayer = LocalPlayer
			--Initialise the InputHandler and ClientPacketHandler
			game.inputHandler = InputHandler.new(game)
			game.packetHandler = ClientPacketHandler.new()
			
		--If this is a server
		else
			--Set the name of "localplayer" to "Server"
			--Allows code to tell if this is a server later on
			game.localPlayer = {Name = "Server"}
			--Set canvas to ScreenGui in ServerStorage
			--Stop errors when code tries to change graphics
			game.canvas = Instance.new("ScreenGui", game.ServerStorage)
			
		end
		game.canvas.Name = "Everest2DGame"
		-- divided by 32 as tiles are 32x32
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
	
	Import("Item")
	
	function Game:render(deltaTime)
		if not _G.isServer then
		
			local deltaTime = tick() - self.lastframe
			self.lastframe = tick()
		
			self.frameCount = self.frameCount + 1

			if self.player then
				self.screen.hud.frameCounter.Text = "Frame Rate  " .. math.ceil(1/deltaTime)
				self.player.level:render(deltaTime)
				self.screen:render(deltaTime, self.player.posX - (self.screen.sizeX / 2), self.player.posY - (self.screen.sizeY / 2))
				for _, v in pairs(Item.itemList) do
					v:render()
				end	
			end
		end
	end

end

Import("Server")

do --MAIN
	if script.Parent.Parent.Name == "Everest2DServer" then
		Server.new()
		_G.isServer = true
		
		local loaderScreen = Instance.new("ScreenGui", game.StarterGui)
		local loaderInfo = Instance.new("Frame", loaderScreen)
		loaderInfo.Size = UDim2.new(1,0,1,0)
		loaderInfo.BackgroundColor3 = Color3.new(0,0,0)
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
		game.StarterGui:SetCoreGuiEnabled(1, false)
		
		repeat wait() until game.Players.LocalPlayer.PlayerGui.ScreenGui
		local loaderScreen = game.Players.LocalPlayer.PlayerGui.ScreenGui
		local background = Instance.new("ImageLabel", loaderScreen)
		background.Size = UDim2.new(1,0,1,0)
		background.Image = "rbxassetid://153133549"
		onStartScreen = true
		coroutine.wrap(function() 
			while onStartScreen do
				wait(1/20)
				local particle = Instance.new("Frame", background)
				local size = math.random(5,10)
				particle.BorderSizePixel = 0
				particle.BackgroundColor3 = Color3.new(1,1,1)
				particle.Size = UDim2.new(0,size,0,size/2)
				particle.Transparency = math.random(30,60) / 100
				local tX = loaderScreen.AbsoluteSize.X	
				local tY = loaderScreen.AbsoluteSize.Y
				local pos = UDim2.new(0, tX + tX * math.random(0,100)/100 - 10, 0, -0.5 * tY + tY * math.random(1,100) / 100)
				particle.Position = pos
				local waitTime = 1 / size * (270 + math.random(1,90))
				local endPos = UDim2.new(0, -tX + tX * math.random(0,90) / 100 - 10, 0, tY + tY * math.random(1,100) / 100)
				particle.Rotation = math.deg(math.tan((pos.Y.Offset - endPos.Y.Offset) / (pos.X.Offset - endPos.X.Offset)))
				particle:TweenPosition(endPos, "Out", "Quad", waitTime)
				game:GetService("Debris"):AddItem(particle, waitTime)
			end
		end)()
		local fader = Instance.new("Frame", background)
		fader.Size = UDim2.new(1,0,1,0)
		fader.BackgroundTransparency = 0
		fader.BackgroundColor3 = Color3.new(0,0,0)
		coroutine.wrap(function() 
			wait(5)
			for i = 0, 1, 0.001 do
				wait(1/30)
				fader.BackgroundTransparency = i
			end
		end)()
		local clipper = Instance.new("Frame", fader)
		clipper.Size = UDim2.new(1,0,1,0)
		clipper.BackgroundTransparency = 1
		clipper.ClipsDescendants = true
		local title = Instance.new("ImageLabel", clipper)
		title.Size = UDim2.new(1,0,1,0)
		title.Image = "rbxassetid://153133512"
		coroutine.wrap(function() 
			for i = 0, 1, 0.02 do
				wait(1/60)
				title.Position = UDim2.new(1-i,0,0,0)
				clipper.Position = UDim2.new(i-1,0,0,0)
			end
		end)()
		
		wait(30)
		
		
		Import("TestStaff")
		coroutine.wrap(function()
			local staff = TestStaff.new("Inventory")
			staff.inventorySlot = 0
		end)()
	end
	--waits for the server to start up (it creates the packethandler)
	repeat wait() until Workspace:FindFirstChild("PacketHandler")
	local game = Game.new()
	_G.localgame = game
	repeat wait() until game.start
	onStartScreen = false
	wait(1)
	game:start()
end