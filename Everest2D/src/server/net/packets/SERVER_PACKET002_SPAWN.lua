--server
repeat wait() until _G.Import
_G.Import("Import")

do SERVER_PACKET002_SPAWN = {}
	_G.SERVER_PACKET002_SPAWN = SERVER_PACKET002_SPAWN
	SERVER_PACKET002_SPAWN.__index = SERVER_PACKET002_SPAWN

	function SERVER_PACKET002_SPAWN.new(type, playerToSpawn, x, y, id)
		local packet = {}
		setmetatable(packet, SERVER_PACKET002_SPAWN)
		
		packet.type = type
		packet.playerToSpawn = playerToSpawn
		packet.x = x
		packet.y = y
		packet.id = id
		
		return packet
	end
	
	function SERVER_PACKET002_SPAWN:Data()
		return {"SERVER_PACKET002_SPAWN", self.type, self.playerToSpawn.Name, self.x, self.y, self.id}
	end
	
	Import("Player")
	
	function SERVER_PACKET002_SPAWN.Handle(data)
		if data[2] == "Player" then
			p = Player.new(_G.localgame, _G.localgame.level, 100, data[3], data[4], data[5], nil)
			p.levelId = data[6]
		end
	end
end