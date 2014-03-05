--client

repeat wait() until _G.Import
_G.Import("Import")

do CLIENT_PACKET001_LOGIN = {}
	_G.CLIENT_PACKET001_LOGIN = CLIENT_PACKET001_LOGIN
	CLIENT_PACKET001_LOGIN.__index = CLIENT_PACKET001_LOGIN

	function CLIENT_PACKET001_LOGIN.new()
		local packet = {}
		setmetatable(packet, CLIENT_PACKET001_LOGIN)

		return packet
	end

	function CLIENT_PACKET001_LOGIN:Data()
		return {"CLIENT_PACKET001_LOGIN"}
	end

	Import("Player")
	Import("Level")
	Import("SERVER_PACKET001_START")
	Import("SERVER_PACKET002_SPAWN")
	Import("SERVER_PACKET004_DISCONNECT")
	Import("SERVER_PACKET005_DISCONNECTOTHER")

	function CLIENT_PACKET001_LOGIN.Handle(player, data)

		_G.localserver.players[player] = {lastInteracted = tick(), player = Player.new(_G.localgame, Level.allLevels["TestLevel"], 100, player.Name, 5, 5, nil)}
		_G.localserver.packetHandler:sendPacket(player, SERVER_PACKET001_START.new("TestLevel", 5, 5, _G.localserver.players[player].player.levelId):Data())
		
		for playerToSpawn, playerInTable in pairs(_G.localserver.players) do
			if playerToSpawn ~= player then
				_G.localserver.packetHandler:sendPacket(player, 
					SERVER_PACKET002_SPAWN.new("Player", playerToSpawn, playerInTable.player.posX, playerInTable.player.posY, _G.localserver.players[player].player.levelId):Data())
			end
		end

		for playerToSend, _ in pairs(_G.localserver.players) do
			if playerToSend ~= player then
				_G.localserver.packetHandler:sendPacket(playerToSend, SERVER_PACKET002_SPAWN.new("Player", player, 5, 5, _G.localserver.players[player].player.levelId):Data())
			end
		end
		
		
		
		coroutine.wrap(function() 
			repeat 
				wait(10) 
			until _G.localserver.players[player].lastInteracted + 10 < tick() 
			print("Disconnecting player " .. player.Name .. " due to lost connection.")
			_G.localserver.packetHandler:sendPacket(player, SERVER_PACKET004_DISCONNECT.new():Data())
			for playerTo, _ in pairs(_G.localserver.players) do
				if playerTo ~= player then
					_G.localserver.packetHandler:sendPacket(playerTo, SERVER_PACKET005_DISCONNECTOTHER.new(player.Name):Data())
				end
			end
			_G.localserver.players[player] = nil
		end)()
		
	end
end