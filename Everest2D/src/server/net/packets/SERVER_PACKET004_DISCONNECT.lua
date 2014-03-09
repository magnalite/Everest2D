--server
repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do SERVER_PACKET004_DISCONNECT = Class("SERVER_PACKET004_DISCONNECT")

	function SERVER_PACKET004_DISCONNECT.new()
		local packet = {}
		setmetatable(packet, SERVER_PACKET004_DISCONNECT)


		return packet
	end
	
	function SERVER_PACKET004_DISCONNECT:Data()
		return {"SERVER_PACKET004_DISCONNECT"}
	end
	
	
	function SERVER_PACKET004_DISCONNECT.Handle(data)
		_G.localgame:stop()
	end
end