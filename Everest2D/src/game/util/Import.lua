--Allows you to import a class (this was made before modulescripts)

function _G.Import(toImport)
	print("IMPORTING " .. toImport)
	wait()
	if not _G[toImport] then
		repeat wait() --print("STILL IMPORTING " .. toImport) 
		until _G[toImport]
	end
	getfenv(2)[toImport] = _G[toImport]
end
