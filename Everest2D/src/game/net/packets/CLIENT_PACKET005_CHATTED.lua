repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do CLIENT_PACKET005_CHATTED = Class("CLIENT_PACKET005_CHATTED")

	function CLIENT_PACKET005_CHATTED.new(playerName, playerColor, chat, chatColor)
		local packet = {}
		setmetatable(packet, CLIENT_PACKET005_CHATTED)

		packet.playerName = playerName
		packet.playerColor = playerColor
		packet.chat = chat
		packet.chatColor = chatColor

		return packet
	end

	function CLIENT_PACKET005_CHATTED:Data()
		return {"CLIENT_PACKET005_CHATTED", self.playerName, self.playerColor, self.chat, self.chatColor}
	end

	Import("SERVER_PACKET007_CHATTED")

	function CLIENT_PACKET005_CHATTED.Handle(player, data)
		for playerTo, _ in pairs(_G.localserver.players) do
			if playerTo ~= player then
				_G.localserver.packetHandler:sendPacket(playerTo, SERVER_PACKET007_CHATTED.new(data[2], data[3], data[4], data[5]):Data())
			end
		end
	end
end