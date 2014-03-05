--server
repeat wait() until _G.Import
_G.Import("Import")


do ServerPacketHandler = {}
	_G.ServerPacketHandler = ServerPacketHandler
	ServerPacketHandler.__index = ServerPacketHandler

	function ServerPacketHandler.new(server)
		local serverPacketHandler = {}
		setmetatable(serverPacketHandler, ServerPacketHandler)
		
		serverPacketHandler.server = server
		serverPacketHandler.handle = Instance.new("RemoteFunction", Workspace)
		serverPacketHandler.handle.Name = "PacketHandler"
		
		function serverPacketHandler.handle.OnServerInvoke(player, data)
			serverPacketHandler:receivedPacket(player, data)
		end
		
		return serverPacketHandler
	end
	
	function ServerPacketHandler:sendPacket(player, data)
		print(tick() .. ": Server sending packet " .. table.concat(data, " ") .. " to player " .. player.Name)
		coroutine.wrap(function(player, data)
			self.handle:InvokeClient(player, data)
		end)(player, data)
	end
	
	Import("CLIENT_PACKET001_LOGIN")
	Import("CLIENT_PACKET002_MOVE")
	Import("CLIENT_PACKET003_KEEPCONNECTION")
	function ServerPacketHandler:receivedPacket(player, data)
		print(tick() .. ": Server received packet " .. table.concat(data, " ") .. " from player " .. player.Name)
		getfenv()[data[1]].Handle(player, data)
	end
	
end