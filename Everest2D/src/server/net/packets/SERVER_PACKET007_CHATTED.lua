--server
repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do SERVER_PACKET007_CHATTED = Class("SERVER_PACKET007_CHATTED")

	function SERVER_PACKET007_CHATTED.new(playerName, playerColor, chat, chatColor)
		local packet = {}
		setmetatable(packet, SERVER_PACKET007_CHATTED)

		packet.playerName = playerName
		packet.playerColor = playerColor
		packet.chat = chat
		packet.chatColor = chatColor
		
		return packet
	end
	
	function SERVER_PACKET007_CHATTED:Data()
		return {"SERVER_PACKET007_CHATTED", self.playerName, self.playerColor, self.chat, self.chatColor}
	end
	
	
	function SERVER_PACKET007_CHATTED.Handle(data)
		_G.localgame.screen.hud:DisplayChat(data[2], data[3], data[4], data[5])
	end
end