
--[[
	Project: Advanced Camera Light Plugin
	Author: Dr_K4rma
	Date: 24 Nov. 2019
	Provides: Button class
	Uses: InteractiveClass
--]]

--// SERVICES AND PRIMARY OBJECTS \\--
local InteractiveClass = require(script.Parent.InteractiveClass)

local ButtonClass = setmetatable({}, InteractiveClass)
ButtonClass.__index = ButtonClass

--// MISC VARIABLES \\--


--// FUNCTIONS \\--
function ButtonClass.new(Object)
	local ButtonObject = setmetatable(InteractiveClass.new(Object), ButtonClass)
	
	return ButtonObject
end

function ButtonClass:CloneTo(Object)
	
end

--// MAIN CODE \\--
return ButtonClass
