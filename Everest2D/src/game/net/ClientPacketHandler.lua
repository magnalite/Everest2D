--client
repeat wait() until _G.Import
_G.Import("Import")

do ClientPacketHandler = {}
	_G.ClientPacketHandler = ClientPacketHandler
	ClientPacketHandler.__index = ClientPacketHandler

	function ClientPacketHandler.new(game)
		local clientPacketHandler = {}
		setmetatable(clientPacketHandler, ClientPacketHandler)
		
		clientPacketHandler.game = game
		clientPacketHandler.handle = Workspace.PacketHandler
		
		function clientPacketHandler.handle.OnClientInvoke(data)
			clientPacketHandler:receivedPacket(data)
		end
		
		return clientPacketHandler
	end
	
	function ClientPacketHandler:sendPacket(data)
		print(tick() .. ": Client sending packet " .. table.concat(data, " "))
		coroutine.wrap(function(data)
			self.handle:InvokeServer(data)
		end)(data)
	end
	
	Import("SERVER_PACKET001_START")
	Import("SERVER_PACKET002_SPAWN")
	Import("SERVER_PACKET003_MOVE")
	Import("SERVER_PACKET004_DISCONNECT")
	Import("SERVER_PACKET005_DISCONNECTOTHER")
	function ClientPacketHandler:receivedPacket(data)
		print(tick() .. ": Client received packet " .. table.concat(data, " "))
		getfenv()[data[1]].Handle(data)
	end
	
end