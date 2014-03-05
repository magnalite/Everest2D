--server
repeat wait() until _G.Import
_G.Import("Import")

do SERVER_PACKET004_DISCONNECT = {}
	_G.SERVER_PACKET004_DISCONNECT = SERVER_PACKET004_DISCONNECT
	SERVER_PACKET004_DISCONNECT.__index = SERVER_PACKET004_DISCONNECT

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