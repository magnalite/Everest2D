repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do CLIENT_PACKET006_DAMAGE = Class("CLIENT_PACKET006_DAMAGE")

	function CLIENT_PACKET006_DAMAGE.new(level, id, damage)
		local packet = {}
		setmetatable(packet, CLIENT_PACKET006_DAMAGE)

		packet.level = level
		packet.id = id
		packet.damage = damage

		return packet
	end

	function CLIENT_PACKET006_DAMAGE:Data()
		return {"CLIENT_PACKET006_DAMAGE", self.level, self.id, self.damage}
	end

	Import("Level")
	function CLIENT_PACKET006_DAMAGE.Handle(player, data)
		Level.allLevels[data[2]].entities[data[3]]:damage(data[4])
	end
end