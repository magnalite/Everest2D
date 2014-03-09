--server
repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do SERVER_PACKET006_SPAWNEFFECT = Class("SERVER_PACKET006_SPAWNEFFECT")

	function SERVER_PACKET006_SPAWNEFFECT.new(id, level, speed, posX, posY, type, dirVecX, dirVecY, size, color)
		local packet = {}
		setmetatable(packet, SERVER_PACKET006_SPAWNEFFECT)
		
		packet.id = id
		packet.level = level
		packet.speed = speed
		packet.posX = posX
		packet.posY = posY
		packet.type = type
		packet.dirVecX = dirVecX
		packet.dirVecY = dirVecY
		packet.size = size
		packet.color = color
		
		return packet
	end
	
	function SERVER_PACKET006_SPAWNEFFECT:Data()
		return {"SERVER_PACKET006_SPAWNEFFECT", 
				self.id,
				self.level,
				self.speed,
				self.posX,
				self.posY,
				self.type,
				self.dirVecX,
				self.dirVecY,
				self.size,
				self.color}
	end
	
	Import("BasicMissile")
	Import("Level")
	function SERVER_PACKET006_SPAWNEFFECT.Handle(data)
		if data[7] == "BasicMissile" then
			BasicMissile.new(data[2],Level.allLevels[data[3]],data[4],data[5],data[6],data[7],Vector2.new(data[8],data[9]),data[10],data[11])
		end
	end
end