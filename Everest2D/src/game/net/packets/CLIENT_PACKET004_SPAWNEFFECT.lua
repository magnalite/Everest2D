--client

repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do CLIENT_PACKET004_SPAWNEFFECT = Class("CLIENT_PACKET004_SPAWNEFFECT")

	function CLIENT_PACKET004_SPAWNEFFECT.new(id, level, speed, posX, posY, type, dirVec, size, color, shouldDamageMobs, shouldDamagePlayer)
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
		packet.shouldDamageMobs = shouldDamageMobs
		packet.shouldDamagePlayer = shouldDamagePlayer
		
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
				self.color,
				self.shouldDamageMobs,
				self.shouldDamagePlayer}
	end

	Import("SERVER_PACKET006_SPAWNEFFECT")

	function CLIENT_PACKET004_SPAWNEFFECT.Handle(player, data)
		for playerToSend, _ in pairs(_G.localserver.players) do
			if playerToSend ~= player then
				_G.localserver.packetHandler:sendPacket(playerToSend, 
					SERVER_PACKET006_SPAWNEFFECT.new(data[2],data[3],data[4],data[5],data[6],data[7],data[8],data[9],data[10],data[11],data[12],data[13]):Data())
			end
		end
	end
end