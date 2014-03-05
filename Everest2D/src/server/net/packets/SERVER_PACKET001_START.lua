--server
repeat wait() until _G.Import
_G.Import("Import")

do SERVER_PACKET001_START = {}
	_G.SERVER_PACKET001_START = SERVER_PACKET001_START
	SERVER_PACKET001_START.__index = SERVER_PACKET001_START

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
	
	function SERVER_PACKET001_START.Handle(data)
		coroutine.wrap(function() while wait(5) do _G.localgame.packetHandler:sendPacket(CLIENT_PACKET003_KEEPCONNECTION.new():Data()) end end)()
	
		_G.localgame.level = Level.allLevels[data[2]]
		repeat wait(1) until _G.localgame.level.ready
		_G.localgame.player = Player.new(_G.localgame, _G.localgame.level, 100, _G.localgame.localPlayer.Name, data[3], data[4], _G.localgame.inputHandler)
		_G.localgame.level.entities[_G.localgame.player.levelId] = nil
		_G.localgame.player.levelId = data[5]
		_G.localgame.level.entities[data[5]] = _G.localgame.player
		
	end
end