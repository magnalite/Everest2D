--server
repeat wait() until _G.Import
_G.Import("Import")

do SERVER_PACKET003_MOVE = {}
	_G.SERVER_PACKET003_MOVE = SERVER_PACKET003_MOVE
	SERVER_PACKET003_MOVE.__index = SERVER_PACKET003_MOVE

	function SERVER_PACKET003_MOVE.new(entityLevelId, xa, ya, speed, posX, posY)
		local packet = {}
		setmetatable(packet, SERVER_PACKET003_MOVE)

		packet.entityLevelId = entityLevelId
		packet.xa = xa
		packet.ya = ya
		packet.speed = speed
		packet.posX = posX
		packet.posY = posY

		return packet
	end
	
	function SERVER_PACKET003_MOVE:Data()
		return {"SERVER_PACKET003_MOVE", self.entityLevelId, self.xa, self.ya, self.speed, self.posX, self.posY}
	end
	
	
	function SERVER_PACKET003_MOVE.Handle(data)
		_G.localgame.player.level:getEntityFromId(data[2]):move(data[3], data[4], data[5], data[6], data[7])
	end
end