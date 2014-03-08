--client

repeat wait() until _G.Import
_G.Import("Import")

do CLIENT_PACKET004_SPAWNEFFECT = {}
	_G.CLIENT_PACKET004_SPAWNEFFECT = CLIENT_PACKET004_SPAWNEFFECT
	CLIENT_PACKET004_SPAWNEFFECT.__index = CLIENT_PACKET004_SPAWNEFFECT

	function CLIENT_PACKET004_SPAWNEFFECT.new(id, level, speed, posX, posY, type, dirVec, size, color)
		local packet = {}
		setmetatable(packet, CLIENT_PACKET004_SPAWNEFFECT)
		
		packet.id = id
		packet.level = level
		packet.speed = speed
		packet.posX = posX
		packet.posY = posY
		packet.type = type
		packet.dirVec = dirVec
		packet.size = size
		packet.color = color
		
		return packet
	end

	function CLIENT_PACKET004_SPAWNEFFECT:Data()
		return {"CLIENT_PACKET004_SPAWNEFFECT", 
				self.id,
				self.level.name,
				self.speed,
				self.posX,
				self.posY,
				self.type,
				self.dirVec.X,
				self.dirVec.Y,
				self.size,
				self.color}
	end

	Import("SERVER_PACKET006_SPAWNEFFECT")

	function CLIENT_PACKET004_SPAWNEFFECT.Handle(player, data)
		for playerToSend, _ in pairs(_G.localserver.players) do
			if playerToSend ~= player then
				_G.localserver.packetHandler:sendPacket(playerToSend, 
					SERVER_PACKET006_SPAWNEFFECT.new(data[2],data[3],data[4],data[5],data[6],data[7],data[8],data[9],data[10],data[11]):Data())
			end
		end
	end
end