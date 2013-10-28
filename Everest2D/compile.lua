require("LuaXML")
local lfs = require("lfs")

local a = xml.load(".buildpath"):find("buildpathentry")
local projname = xml.load(".project"):find("name")[1]
local result = xml.new("roblox") do
        result["xmlns:xmime"]="http://www.w3.org/2005/05/xmlmime"
        result["version"]="4"
        result["xsi:noNameSpaceSchemaLocation"]="http://www.roblox.com/roblox.xsd"
        result["xmlns:xsi"]="http://www.w3.org/2001/XMLSchema-instance"
end

local ignore = { }
if a["excluding"] then
        for file in a["excluding"]:gmatch("[^|]+") do
                local f = ".\\"..a["path"].."\\"..file:gsub("/", "\\")
                ignore[f] = true
                print("ignore:", f)
        end
end        

function browse(parent)
        local ret = { }
        for file in lfs.dir(parent) do
                if file ~= "." and file ~= ".." then
                        if lfs.attributes(parent.."\\"..file, "mode") == "directory" then
                                ret[file] = browse(parent.."\\"..file)
                        else
                                if not ignore[parent.."\\"..file] then
                                        table.insert(ret, parent.."\\"..file)
                                end
                        end
                end
        end
        return ret
end
local p3
local parent = (".\\"..a["path"])
local toexport = browse(parent)
local p1 = result:append("Item")
p1["class"]="StringValue"
p1["referent"]="RBX0"
local p2 = p1:append("Properties")
p2:append("string")["name"]="Name";p2:find("string", "name", "Name")[1]=projname
p2:append("string")["name"]="Value";p2:find("string", "name", "Value")[1]=""

function export(from)
        for file, data in pairs(from) do
                if type(data) == "table" then
                        p3 = p1:append("Item")
                        p3["class"]="StringValue"
                        p3["referent"]="RBX0"
                        local p4 = p3:append("Properties")
                        p4:append("string")["name"]="Name";p4:find("string", "name", "Name")[1]=file
                        p4:append("string")["name"]="Value";p4:find("string", "name", "Value")[1]=""
                        export(data)
                else
                        local read = io.open(data, "r")
                        local sType = read:read()
                        local item = (p3 or p1):append("Item")
                        if sType == "--server" then
                                item["class"]="Script"
                        elseif sType=="--client" then
                                item["class"]="LocalScript"
                        else
                                error("Invalid script type in file: "..data:sub(2))
                        end
                        item["referent"]="RBX0"
                        local props = item:append("Properties")
                        props:append("string")["name"]="Name";props:find("string", "name", "Name")[1]=(string.gmatch(data:sub(2), ".+\\(.+)")())
                        props:append("ProtectedString")["name"]="Source";props:find("ProtectedString", "name", "Source")[1]=read:read("*a")
                        props:append("Content")["name"]="LinkedSource";props:find("Content", "name", "LinkedSource")[1]="null"
                        props:append("bool")["name"]="Disabled";props:find("bool", "name", "Disabled")[1]="false"
                end
        end
end

export(toexport)
print(result)
io.open("ver-"..os.time()..".rbxm", "w"):write(tostring(result))