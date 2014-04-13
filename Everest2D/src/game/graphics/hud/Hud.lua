--Heads up display

repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do Hud = Class("Hud")
	
	Import("Inventory")
	function Hud.new(screen)
		local hud = {}
		setmetatable(hud, Hud)
		
		hud.screen = screen
		hud.frame = Instance.new("Frame", screen.frame.Parent)
		hud.frame.Size = UDim2.new(1,0,1,0)
		hud.frame.ZIndex = 9
		hud.frame.BackgroundTransparency = 1
		hud.frame.Name = "Hud"
		
		hud.statusBar = Instance.new("Frame", hud.frame)
		hud.statusBar.Size = UDim2.new(1,0,0,50)
		hud.statusBar.ZIndex = 9
		hud.statusBar.BackgroundColor3 = Color3.new(0,0,0)
		hud.statusBar.BackgroundTransparency = 0.3
		hud.statusBar.Position = UDim2.new(0,0,1,-70)
		
		hud.levelIndicator = Instance.new("TextLabel", hud.statusBar)
		hud.levelIndicator.BackgroundTransparency = 1
		hud.levelIndicator.BorderSizePixel = 0
		hud.levelIndicator.Position = UDim2.new(0,50,0,0)
		hud.levelIndicator.Size = UDim2.new(0,120,0,50)
		hud.levelIndicator.ZIndex = 9
		hud.levelIndicator.FontSize = "Size48"
		hud.levelIndicator.TextColor3 = Color3.new(0,0,0)
		hud.levelIndicator.TextStrokeColor3 = Color3.new(1,1,1)
		hud.levelIndicator.TextStrokeTransparency = 0.5
		hud.levelIndicator.TextXAlignment = "Left"
		hud.levelIndicator.Font = "SourceSans"
		hud.levelIndicator.Text = "Lv:###"
		
		hud.xpBar = Instance.new("Frame", hud.statusBar)
		hud.xpBar.Size = UDim2.new(1, -170, 0.3, 0)
		hud.xpBar.Position = UDim2.new(0, 170, 0.7, 0)
		hud.xpBar.ZIndex = 9
		hud.xpBar.BackgroundColor3 = Color3.new(255/255, 170/255,0)
		hud.xpBar.BorderColor3 = Color3.new(0,0,0)
		hud.xpBar.BorderSizePixel = 3
		
		hud.xpText = Instance.new("TextLabel", hud.xpBar)
		hud.xpText.Size = UDim2.new(0,0,0,0)
		hud.xpText.Position = UDim2.new(0.5,0,0.5,0)
		hud.xpText.ZIndex = 9
		hud.xpText.BackgroundTransparency = 1
		hud.xpText.TextColor3 = Color3.new(1,1,1)
		hud.xpText.TextStrokeTransparency = 0
		hud.xpText.Font = "SourceSans"
		hud.xpText.FontSize = "Size14"
		hud.xpText.Text = "XP - #/# 100%"
		
		hud.hpBar = Instance.new("Frame", hud.statusBar)
		hud.hpBar.Size = UDim2.new(0.5, -85, 0.3, 0)
		hud.hpBar.Position = UDim2.new(0, 170, 0.2, 0)
		hud.hpBar.ZIndex = 9
		hud.hpBar.BackgroundColor3 = Color3.new(1,0,0)
		hud.hpBar.BorderColor3 = Color3.new(0,0,0)
		hud.hpBar.BorderSizePixel = 3
		
		hud.hpText = Instance.new("TextLabel", hud.hpBar)
		hud.hpText.Size = UDim2.new(0,0,0,0)
		hud.hpText.Position = UDim2.new(0.5,0,0.5,0)
		hud.hpText.ZIndex = 9
		hud.hpText.BackgroundTransparency = 1
		hud.hpText.TextColor3 = Color3.new(1,1,1)
		hud.hpText.TextStrokeTransparency = 0
		hud.hpText.Font = "SourceSans"
		hud.hpText.FontSize = "Size14"
		hud.hpText.Text = "HP - 100/100"
		
		hud.spBar = Instance.new("Frame", hud.statusBar)
		hud.spBar.Size = UDim2.new(0.5, -85, 0.3, 0)
		hud.spBar.Position = UDim2.new(0.5, 85, 0.2, 0)
		hud.spBar.ZIndex = 9
		hud.spBar.BackgroundColor3 = Color3.new(0,0,1)
		hud.spBar.BorderColor3 = Color3.new(0,0,0)
		hud.spBar.BorderSizePixel = 3
		
		hud.spText = Instance.new("TextLabel", hud.spBar)
		hud.spText.Size = UDim2.new(0,0,0,0)
		hud.spText.Position = UDim2.new(0.5,0,0.5,0)
		hud.spText.ZIndex = 9
		hud.spText.BackgroundTransparency = 1
		hud.spText.TextColor3 = Color3.new(1,1,1)
		hud.spText.TextStrokeTransparency = 0
		hud.spText.Font = "SourceSans"
		hud.spText.FontSize = "Size14"
		hud.spText.Text = "SP - 100/100"
		
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
		hud.chat.Position = UDim2.new(0, 0, 1, -320)
		hud.chat.BackgroundTransparency = 0.7
		hud.chat.Name = "Chatbox"
		hud.chat.BorderColor3 = Color3.new(0,0,0)
		hud.chat.BorderSizePixel = 3
		hud.chat.ClipsDescendants = true
		hud.chat.ZIndex = 8
		
		hud.inventory = Inventory.new(hud)
		
		hud.inventoryButton = Instance.new("ImageButton", hud.frame)
		hud.inventoryButton.Position = UDim2.new(0,400,1,-110)
		hud.inventoryButton.Size = UDim2.new(0,40,0,40)
		hud.inventoryButton.Image = "http://www.roblox.com/asset/?id=149947909"
		hud.inventoryButton.BackgroundTransparency = 1
		hud.inventoryButton.ZIndex = 9
		
		hud.inventoryButton.MouseButton1Click:connect(function() hud.inventory:toggleVisibility() end)
		
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