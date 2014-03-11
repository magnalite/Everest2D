--client

repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do CLIENT_PACKET002_MOVE = Class("CLIENT_PACKET002_MOVE")

	function CLIENT_PACKET002_MOVE.new(id, xa, ya, speed, posX, posY)
		local packet = {}
		setmetatable(packet, CLIENT_PACKET002_MOVE)

		packet.id = id
		packet.xa = xa
		packet.ya = ya
		packet.speed = speed
		packet.posX = posX
		packet.posY = posY

		return packet
	end

	function CLIENT_PACKET002_MOVE:Data()
		return {"CLIENT_PACKET002_MOVE", self.id, self.xa, self.ya, self.speed, self.posX, self.posY}
	end
	
	Import("SERVER_PACKET002_SPAWN")
	Import("SERVER_PACKET003_MOVE")
	Import("Level")

	function CLIENT_PACKET002_MOVE.Handle(player, data)
		for playerTo, _ in pairs(_G.localserver.players) do
			if playerTo ~= player then
				_G.localserver.packetHandler:sendPacket(playerTo, SERVER_PACKET003_MOVE.new(data[2], data[3], data[4], data[5], _G.localserver.players[player].player.posX, _G.localserver.players[player].player.posY):Data())
			end
		end

		_G.localserver.players[player].player.posX = _G.localserver.players[player].player.posX + (data[3] * data[5])
		_G.localserver.players[player].player.posY = _G.localserver.players[player].player.posY + (data[4] * data[5])
		_G.localserver.players[player].lastInteracted = tick()

		if data[6] ~= _G.localserver.players[player].player.posX or data[7] ~= _G.localserver.players[player].player.posY then
			_G.localserver.packetHandler:sendPacket(player, SERVER_PACKET003_MOVE.new(data[2], data[3], 0, 0, _G.localserver.players[player].player.posX, _G.localserver.players[player].player.posY):Data())
		end
		
		local playerPos = Vector2.new(_G.localserver.players[player].player.posX, _G.localserver.players[player].player.posY)
		for i, v in pairs(Level.allLevels["TestLevel"].entities) do
			local entityPos = Vector2.new(v.posX, v.posY)
			if not _G.localserver.players[player].playerMobs[v] and (playerPos - entityPos).magnitude < 50 then
				_G.localserver.players[player].playerMobs[v] = true
				_G.localserver.packetHandler:sendPacket(player, SERVER_PACKET002_SPAWN.new(v.type, v, entityPos.X, entityPos.Y, v.levelId):Data())
			end
		end
	end
end