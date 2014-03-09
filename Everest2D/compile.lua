require("LuaXML")
local lfs = require("lfs")
local json = require("json")

local projdata = xml.load(".buildpath"):find("buildpathentry")
local projname = xml.load(".project"):find("name")[1]
local result = xml.new("roblox") do
	result["xmlns:xmime"]="http://www.w3.org/2005/05/xmlmime"
	result["version"]="4"
	result["xsi:noNameSpaceSchemaLocation"]="http://www.roblox.com/roblox.xsd"
	result["xmlns:xsi"]="http://www.w3.org/2001/XMLSchema-instance"
end

local ignore = { }
if projdata["excluding"] then
	for file in projdata["excluding"]:gmatch("[^|]+") do
		local f = projdata["path"].."/"..file
		ignore[f] = true
		print("ignoring:", f)
	end
end

function browse(parent, indent)
	local ret = { }
	for file in lfs.dir(parent) do
		if file ~= "." and file ~= ".." then
			--print(indent, file, lfs.attributes(parent.."/"..file, "mode"))
			if lfs.attributes(parent.."/"..file, "mode") == "directory" then
				ret[file] = browse(parent.."/"..file, indent.."	")
				--print(indent.."	", ret[file])
			else
				if not ignore[parent.."/"..file] then
					ret[file] = "./"..parent.."/"..file
					--print(indent, ret[file])
				end
			end
		end
	end
	return ret
end

--print("Project path:")
local project = browse(projdata['path'], "")

function instancify(mode, from, to)
	for name, v in pairs(from) do
		print(name, v)
		if type(v) == "table" then
			local dir = to:append("Item")
			dir["class"]="StringValue"
			dir["referent"]="RBX0"
			local props = dir:append("Properties")
			props:append("string")["name"]="Name";props:find("string", "name", "Name")[1]=name
			props:append("string")["name"]="Value";props:find("string", "name", "Value")[1]=""
			
			instancify(mode, v, dir)
		else
			local data = io.open(v, "r"):read("*a")
			item = to:append("Item")
			item["class"] = mode.."Script"
			item["referent"] = "RBX0"
			local props = item:append("Properties")
			props:append("string")["name"]="Name";props:find("string", "name", "Name")[1]=name
			props:append("ProtectedString")["name"]="Source";props:find("ProtectedString", "name", "Source")[1]=data
			props:append("Content")["name"]="LinkedSource";props:find("Content", "name", "LinkedSource")[1]="null"
			props:append("bool")["name"]="Disabled";props:find("bool", "name", "Disabled")[1]="false"
		end
	end
end

local client = result:append("Item") do
	client["class"]="StringValue"
	client["referent"]="RBX0"
	local props = client:append("Properties")
	props:append("string")["name"]="Name";props:find("string", "name", "Name")[1] = projname.."Client"
	props:append("string")["name"]="Value";props:find("string", "name", "Value")[1] = ""
end

local server = result:append("Item") do
	server["class"]="StringValue"
	server["referent"]="RBX0"
	local props = server:append("Properties")
	props:append("string")["name"]="Name";props:find("string", "name", "Name")[1] = projname.."Server"
	props:append("string")["name"]="Value";props:find("string", "name", "Value")[1] = ""
end

instancify("Local", project, client)
instancify("", project, server)

io.open("ver-"..os.time()..".rbxm", "w"):write(tostring(result))
print("Completed!")