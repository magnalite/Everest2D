Everest2D
=========

2D RPG running the everest engine.

Compiling
---------

Compiling Everest2D is made easy by the help of Lua and a few modules. The required modules are:

* LuaXML
* LuaFileSystem

To compile, simply run compile.lua. The resultant file (formatted as "ver-%d.rbxm" where %d is the time compiled) is a ROBLOX Model which contains a compiled version of the code, organised using StringValue instances.

Once compiled, you will need to move a few things.

* Everest2DClient should be moved to StarterGui
* Everest2DServer should be moved to ServerScriptService

Reporting bugs
---------

To report bugs, use the following system for providing info:

* Bug description
* Occurance (Where and When)
* What were you doing at the time
* Script info (if it was a script error, give the full error, including stacktrace)
