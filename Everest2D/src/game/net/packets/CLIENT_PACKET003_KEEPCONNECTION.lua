--client

repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do CLIENT_PACKET003_KEEPCONNECTION = Class("CLIENT_PACKET003_KEEPCONNECTION")

	function CLIENT_PACKET003_KEEPCONNECTION.new()
		local packet = {}
		setmetatable(packet, CLIENT_PACKET003_KEEPCONNECTION)

		return packet
	end

	function CLIENT_PACKET003_KEEPCONNECTION:Data()
		return {"CLIENT_PACKET003_KEEPCONNECTION"}
	end

	function CLIENT_PACKET003_KEEPCONNECTION.Handle(player, data)
		_G.localserver.players[player].lastInteracted = tick()
	end
end