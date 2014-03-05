--client

--Allows you to import a class (this was made before modulescripts)

function _G.Import(toImport)
<<<<<<< HEAD
	repeat wait() print("IMPORTING " .. toImport) until _G[toImport]
=======
	repeat wait() until _G[toImport]
>>>>>>> refs/remotes/origin/master
	getfenv(2)[toImport] = _G[toImport]
end
