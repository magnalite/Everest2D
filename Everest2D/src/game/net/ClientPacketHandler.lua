--client
repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do ClientPacketHandler = Class("ClientPacketHandler")

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
		local stringData = ""
		for _, v in pairs(data) do stringData = stringData .. " " .. tostring(v) end
		--print(tick() .. ": Client sending packet " .. stringData)
		coroutine.wrap(function(data)
			self.handle:InvokeServer(data)
		end)(data)
		data = nil
	end
	
	Import("SERVER_PACKET001_START")
	Import("SERVER_PACKET002_SPAWN")
	Import("SERVER_PACKET003_MOVE")
	Import("SERVER_PACKET004_DISCONNECT")
	Import("SERVER_PACKET005_DISCONNECTOTHER")
	Import("SERVER_PACKET006_SPAWNEFFECT")
	Import("SERVER_PACKET007_CHATTED")
	Import("SERVER_PACKET008_DAMAGE")
	
	function ClientPacketHandler:receivedPacket(data)
		local stringData = ""
		for _, v in pairs(data) do stringData = stringData .. " " .. tostring(v) end
		--print(tick() .. ": Client received packet " .. stringData)
		getfenv()[data[1]].Handle(data)
		data = nil
	end
	
end