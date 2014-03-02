--client

--Heads up display

repeat wait() until _G.Import
_G.Import("Import")


do Hud = {}
	_G.Hud = Hud
	Hud.__index = Hud
	
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
		
		hud.playerHealth = Instance.new("TextLabel", hud.playerInfo)
		
		
		
		return hud
	end
	
end