--Handles entity ai, player positions, chat, etc.

repeat wait() until _G.Import
_G.Import("Import")

do Server = {}
	_G.Server = Server
	Server.__index = Server


	Import("ServerPacketHandler")
	function Server.new()
		print("!!!SERVER INITIALISING!!!")
		local server = {}
		setmetatable(server, Server)

		_G.localserver = server
		server.packetHandler = ServerPacketHandler.new(server)
		server.players = {}
		server.playersLastConnect = {}

		return server
	end

end
