--server
repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do ServerPacketHandler = Class("ServerPacketHandler")

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
		local stringData = ""
		for _, v in pairs(data) do stringData = stringData .. " " .. tostring(v) end
		--print(tick() .. ": Server sending packet " .. stringData .. " to player " .. player.Name)
		coroutine.wrap(function(player, data)
			self.handle:InvokeClient(player, data)
		end)(player, data)
		data = nil
	end
	
	Import("CLIENT_PACKET001_LOGIN")
	Import("CLIENT_PACKET002_MOVE")
	Import("CLIENT_PACKET003_KEEPCONNECTION")
	Import("CLIENT_PACKET004_SPAWNEFFECT")
	Import("CLIENT_PACKET005_CHATTED")
	Import("CLIENT_PACKET006_DAMAGE")
	
	function ServerPacketHandler:receivedPacket(player, data)
		local stringData = ""
		for _, v in pairs(data) do stringData = stringData .. " " .. tostring(v) end
		--print(tick() .. ": Server received packet " .. stringData .. " from player " .. player.Name)
		getfenv()[data[1]].Handle(player, data)
		data = nil
	end
	
end