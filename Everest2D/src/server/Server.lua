--Handles entity ai, player positions, chat, etc.

repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do Server = Class("Server")

	Import("ServerPacketHandler")
	function Server.new()
		print("!!!SERVER INITIALISING!!!")
		Workspace.FilteringEnabled = true
		local server = {}
		setmetatable(server, Server)

		_G.localserver = server
		server.packetHandler = ServerPacketHandler.new(server)
		server.players = {}
		server.playerMobs = {}
		server.playersLastConnect = {}

		return server
	end

end
