--server
repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do SERVER_PACKET002_SPAWN = Class("SERVER_PACKET002_SPAWN")

	function SERVER_PACKET002_SPAWN.new(type, playerToSpawn, x, y, id, hp, maxHp)
		local packet = {}
		setmetatable(packet, SERVER_PACKET002_SPAWN)
		
		packet.type = type
		packet.playerToSpawn = playerToSpawn
		packet.x = x
		packet.y = y
		packet.id = id
		packet.hp = hp
		packet.maxHp = maxHp
		
		return packet
	end
	
	function SERVER_PACKET002_SPAWN:Data()
		return {"SERVER_PACKET002_SPAWN", self.type, self.playerToSpawn.Name, self.x, self.y, self.id, self.hp, self.maxHp}
	end
	
	Import("Player")
	Import("TestMob")
	
	function SERVER_PACKET002_SPAWN.Handle(data)
		if data[2] == "Player" then
			print("SPAWNING PLAYER")
			Player.new(data[6], _G.localgame, _G.localgame.level, data[7], data[8], data[3], data[4], data[5], nil)
		elseif data[2] == "TestMob" then
			print("SPAWNING TESTMOB")
			TestMob.new(data[6], _G.localgame, _G.localgame.level, data[7], data[8], data[3], data[4], data[5])
		end
	end
end