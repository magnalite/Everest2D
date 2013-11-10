--server

repeat wait() until _G.Import
_G.Import("Import")

do Server = {}
	_G.Server = Server
	Server.__index = Server

	function Server.new()
		print("!!!SERVER INITIALISING!!!")
		local server = {}
		setmetatable(server, Server)
		
		server.packetHandler = Instance.new("RemoteFunction", Workspace)
		server.packetHandler.Name = "PacketHandler"
		server.players = {}
		
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
			
			self.players[player] = {x = 5, y = 5}
		end
		
		if data[1] == "MOVE" then
			
			self.players[player].x = self.players[player].x + (data[2] * data[4])
			self.players[player].y = self.players[player].y + (data[3] * data[4])
			
			for playerTo, _ in pairs(self.players) do
				if playerTo ~= player then
					self:sendPacket(playerTo, {"PLAYERMOVE", player.Name, data[2], data[3]})
				end
			end
		
		end
		
	end
	
	function Server:sendPacket(player, data)
		coroutine.wrap(function(player, data)
			self.packetHandler:InvokeClient(player, data)
		end)(player, data)
	end
	
end
