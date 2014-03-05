--server

--Handles entity ai, player positions, chat, etc.

repeat wait() until _G.Import
_G.Import("Import")

do Server = {}
	_G.Server = Server
	Server.__index = Server

<<<<<<< HEAD

	Import("ServerPacketHandler")
	function Server.new()
		print("!!!SERVER INITIALISING!!!")
		local server = {}
		setmetatable(server, Server)

		_G.localserver = server
		server.packetHandler = ServerPacketHandler.new(server)
		server.players = {}
		server.playersLastConnect = {}

		return server
	end

=======
	function Server.new()
		print("!!!SERVER INITIALISING!!!")
		local server = {}
		setmetatable(server, Server)
		
		server.packetHandler = Instance.new("RemoteFunction", Workspace)
		server.packetHandler.Name = "PacketHandler"
		server.players = {}
		server.playersLastConnect = {}
		
		function server.packetHandler.OnServerInvoke(player, data)
			server:recievedPacket(player, data)
		end
	
		return server
	end
	
	function Server:recievedPacket(player, data)
		
		if data[1] == "LOGIN" then
			self:sendPacket(player, {"START", "TestLevel", 5, 5})
			
			for playerToSpawn, _ in pairs(self.players) do
				self:sendPacket(player, {"SPAWN", "Player", playerToSpawn.Name, self.players[playerToSpawn].x, self.players[playerToSpawn].y})
			end
			
			for playerToSend, _ in pairs(self.players) do
				self:sendPacket(playerToSend, {"SPAWN", "Player", player.Name, 5, 5})
			end
			
			self.players[player] = {x = 5, y = 5, lastInteracted = tick()}
			
			coroutine.wrap(function() 
				repeat 
					wait(10) 
				until self.players[player].lastInteracted + 10 < tick() 
				print("Disconnecting player " .. player.Name .. " due to lost connection.")
				self:sendPacket(player, {"DISCONNECT"})
				for playerTo, _ in pairs(self.players) do
					if playerTo ~= player then
						self:sendPacket(playerTo, {"DISCONNECTOTHER", player.Name})
					end
				end
				self.players[player] = nil
			end)()
			
		elseif data[1] == "MOVE" then
			
			for playerTo, _ in pairs(self.players) do
				if playerTo ~= player then
					self:sendPacket(playerTo, {"PLAYERMOVE", player.Name, data[2], data[3], self.players[player].x, self.players[player].y})
				end
			end
			
			self.players[player].x = self.players[player].x + (data[2] * data[4])
			self.players[player].y = self.players[player].y + (data[3] * data[4])
			self.players[player].lastInteracted = tick()
			
			if data[5] ~= self.players[player].x or data[6] ~= self.players[player].y then
				self:sendPacket(player, {"PLAYERMOVE", player.Name, 0, 0, self.players[player].x, self.players[player].y})
			end
		
		elseif data[1] == "LEFT" then
			self:sendPacket(player, {"DISCONNECT"})
			for playerTo, _ in pairs(self.players) do
				if playerTo ~= player then
					self:sendPacket(playerTo, {"DISCONNECTOTHER", player.Name})
				end
			end
			self.players[player] = nil
			
			
		elseif data[1] == "KEEPCONNECTION" then
			print("Received keep connection packet from " .. player.Name)
			self.players[player].lastInteracted = tick()
		end
		
	end
	
	function Server:sendPacket(player, data)
		coroutine.wrap(function(player, data)
			self.packetHandler:InvokeClient(player, data)
		end)(player, data)
	end
	
	
>>>>>>> refs/remotes/origin/master
end
