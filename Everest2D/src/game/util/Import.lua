--client

--Allows you to import a class (this was made before modulescripts)

function _G.Import(toImport)
	repeat wait() until _G[toImport]
	getfenv(2)[toImport] = _G[toImport]
end
