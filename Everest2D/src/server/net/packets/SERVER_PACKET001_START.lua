--server
repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do SERVER_PACKET001_START = Class("SERVER_PACKET001_START")

	function SERVER_PACKET001_START.new(level, posX, posY, id)
		local packet = {}
		setmetatable(packet, SERVER_PACKET001_START)
		
		packet.level = level
		packet.posX = posX
		packet.posY = posY
		packet.id = id
		
		return packet
	end
	
	function SERVER_PACKET001_START:Data()
		return {"SERVER_PACKET001_START", self.level, self.posX, self.posY, self.id}
	end
	
	Import("Level")
	Import("Player")
	Import("CLIENT_PACKET003_KEEPCONNECTION")
	Import("CLIENT_PACKET005_CHATTED")
	
	function SERVER_PACKET001_START.Handle(data)
		coroutine.wrap(function() while wait(5) do _G.localgame.packetHandler:sendPacket(CLIENT_PACKET003_KEEPCONNECTION.new():Data()) end end)()
	
		_G.localgame.level = Level.allLevels[data[2]]
		repeat wait(1) until _G.localgame.level.ready
		_G.localgame.player = Player.new(data[5], _G.localgame, _G.localgame.level, 100, 100, _G.localgame.localPlayer.Name, data[3], data[4], _G.localgame.inputHandler)
		print("START!")
		_G.localgame.screen.hud:DisplayChat("System", Color3.new(1,1,1), "Game starting!", Color3.new(0,1,0))
		 _G.LocalPlayer.Chatted:connect(function(chat)
			_G.localgame.packetHandler:sendPacket(CLIENT_PACKET005_CHATTED.new(_G.LocalPlayer.Name, Color3.new(1,1,1), chat, Color3.new(1,1,1)):Data())
			_G.localgame.screen.hud:DisplayChat(_G.LocalPlayer.Name, Color3.new(1,1,1), chat, Color3.new(1,1,1))
		end)
	end
end