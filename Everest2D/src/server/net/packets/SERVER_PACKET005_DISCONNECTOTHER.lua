--server
repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do SERVER_PACKET005_DISCONNECTOTHER = Class("SERVER_PACKET005_DISCONNECTOTHER")

	function SERVER_PACKET005_DISCONNECTOTHER.new(playerName)
		local packet = {}
		setmetatable(packet, SERVER_PACKET005_DISCONNECTOTHER)

		packet.playerName = playerName

		return packet
	end
	
	function SERVER_PACKET005_DISCONNECTOTHER:Data()
		return {"SERVER_PACKET005_DISCONNECTOTHER", self.playerName}
	end
	
	
	Import("Player")
	
	function SERVER_PACKET005_DISCONNECTOTHER.Handle(data)
		Player.players[data[2]]:Destroy()
	end
end