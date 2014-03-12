--Heads up display

repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do Hud = Class("Hud")
	
	function Hud.new(screen)
		local hud = {}
		setmetatable(hud, Hud)
		
		hud.screen = screen
		hud.frame = Instance.new("Frame", screen.frame.Parent)
		hud.frame.Size = UDim2.new(1,0,1,0)
		hud.frame.ZIndex = 9
		hud.frame.BackgroundTransparency = 1
		hud.frame.Name = "Hud"
		
		hud.playerInfo = Instance.new("ImageLabel", hud.frame)
		hud.playerInfo.Size = UDim2.new(0, 300, 0, 100)
		hud.playerInfo.BackgroundTransparency = 1
		hud.playerInfo.BackgroundColor3 = Color3.new(0,0,0)
		hud.playerInfo.Name = "PlayerInfo"
		hud.playerInfo.Image = "http://www.roblox.com/asset/?id=135283499"
		hud.playerInfo.ZIndex = 9
		
		hud.playerName = Instance.new("TextLabel", hud.playerInfo)
		hud.playerName.Size = UDim2.new(0,120,0,20)
		hud.playerName.Position = UDim2.new(0,90,0,24)
		hud.playerName.BackgroundTransparency = 1
		hud.playerName.Text = screen.game.localPlayer.Name
		hud.playerName.TextXAlignment = "Left"
		hud.playerName.TextScaled = true
		hud.playerName.FontSize = "Size24"
		hud.playerName.Font = "ArialBold"
		hud.playerName.TextColor3 = Color3.new(1,1,1)
		hud.playerName.TextStrokeTransparency = 0
		hud.playerName.Name = "PlayerName"
		hud.playerName.ZIndex = 9
		
		hud.tickCounter = Instance.new("TextLabel", hud.frame)
		hud.tickCounter.Size = UDim2.new(0,100,0,40)
		hud.tickCounter.Position = UDim2.new(0.5, -50, 0, 25)
		hud.tickCounter.BackgroundTransparency = 1
		hud.tickCounter.Text = "Tick rate - ERROR"
		hud.tickCounterTextXAlignment = "Center"
		hud.tickCounter.TextScaled = true
		hud.tickCounter.Font = "ArialBold"
		hud.tickCounter.TextColor3 = Color3.new(1,1,1)
		hud.tickCounter.TextStrokeTransparency = 0
		hud.tickCounter.Name = "tickCounter"
		hud.tickCounter.ZIndex = 9
		
		hud.frameCounter = Instance.new("TextLabel", hud.frame)
		hud.frameCounter.Size = UDim2.new(0,100,0,40)
		hud.frameCounter.Position = UDim2.new(0.5, 50, 0, 25)
		hud.frameCounter.BackgroundTransparency = 1
		hud.frameCounter.Text = "Frame rate - ERROR"
		hud.frameCounterTextXAlignment = "Center"
		hud.frameCounter.TextScaled = true
		hud.frameCounter.Font = "ArialBold"
		hud.frameCounter.TextColor3 = Color3.new(1,1,1)
		hud.frameCounter.TextStrokeTransparency = 0
		hud.frameCounter.Name = "frameCounter"
		hud.frameCounter.ZIndex = 9
		
		hud.chat = Instance.new("Frame", hud.frame)
		hud.chat.Size = UDim2.new(0, 400, 0, 250)
		hud.chat.Position = UDim2.new(0, 40, 1, -290)
		hud.chat.BackgroundTransparency = 0.7
		hud.chat.Name = "Chatbox"
		hud.chat.ClipsDescendants = true
		hud.chat.ZIndex = 8
		
		hud.playerHealth = Instance.new("TextLabel", hud.playerInfo)
		
		
		
		return hud
	end
	
	function Hud:DisplayChat(playerName, nameColor, chat, chatColor)

	
		local chatLength = #chat
		local chatHeightMod = math.ceil(chatLength / 44)
			
		for _, v in pairs(self.chat:GetChildren()) do
			v.Position = UDim2.new(0, v.Position.X.Offset, 1, v.Position.Y.Offset -15 * chatHeightMod + 5)
		end
		
		local nameBox = Instance.new("TextLabel", self.chat)
		nameBox.BackgroundTransparency = 1
		nameBox.Size = UDim2.new(0, 100, 0, 20)
		nameBox.Position = UDim2.new(0, 0, 1, -15 * chatHeightMod - 5)
		nameBox.Text = playerName
		nameBox.TextStrokeTransparency = 0.4
		nameBox.TextColor3 = nameColor
		nameBox.Font = "SourceSans"
		nameBox.FontSize = "Size14"
		nameBox.TextXAlignment = "Left"
		nameBox.ZIndex = 9
		
		local chatBox = Instance.new("TextLabel", self.chat)
		chatBox.BackgroundTransparency = 1
		chatBox.Size = UDim2.new(1, -110, 0, 15 * chatHeightMod + 5)
		chatBox.Position = UDim2.new(0, 110, 1, -15 * chatHeightMod - 5)
		chatBox.Text = chat
		chatBox.TextStrokeTransparency = 0.4
		chatBox.TextColor3 = chatColor
		chatBox.Font = "SourceSans"
		chatBox.FontSize = "Size14"
		chatBox.TextXAlignment = "Left"
		chatBox.TextWrapped = true
		chatBox.ZIndex = 9
	end
	
end