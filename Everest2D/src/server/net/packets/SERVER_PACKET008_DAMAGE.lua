--server
repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do SERVER_PACKET008_DAMAGE = Class("SERVER_PACKET008_DAMAGE")

	function SERVER_PACKET008_DAMAGE.new(level, id, newHealth)
		local packet = {}
		setmetatable(packet, SERVER_PACKET008_DAMAGE)

		packet.level = level
		packet.id = id
		packet.newHealth = newHealth
		
		return packet
	end
	
	function SERVER_PACKET008_DAMAGE:Data()
		return {"SERVER_PACKET008_DAMAGE", self.level, self.id, self.newHealth}
	end
	
	Import("Level")
	function SERVER_PACKET008_DAMAGE.Handle(data)
		Level.allLevels[data[2]].entities[data[3]]:damage(nil, data[4])
	end
end