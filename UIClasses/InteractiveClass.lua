
--[[
	Project: Advanced Camera Light Plugin
	Author: Dr_K4rma
	Date: 24 Nov. 2019
	Provides: Interactive class
	Uses: nil
--]]

--// SERVICES AND PRIMARY OBJECTS \\--
local InteractiveClass = {}
InteractiveClass.__index = InteractiveClass

--// MISC VARIABLES \\--


--// FUNCTIONS \\--
function InteractiveClass:BindAction(Identifier, ActionType, funct, ...)
	local args = {...}
	self.Actions[Identifier] = self.Object[ActionType]:Connect(function(input)
		return funct(input, unpack(args))
	end)
end

function InteractiveClass:UnbindAction(Identifier)
	self.Actions[Identifier]:Disconnect()
end

function InteractiveClass.IsInteractiveObject(Object)
	return Object:IsA("Frame") or Object:IsA("ImageLabel") or Object:IsA("TextLabel")
end

function InteractiveClass.GetType(Object)
	return string.lower(Object.Name:match("%a+"))
end

function InteractiveClass.new(Object)
	local InteractiveObject = {}
	setmetatable(InteractiveObject, InteractiveClass)
	InteractiveObject.Object = Object
	InteractiveObject.Actions = {}
	
	return InteractiveObject
end

--// MAIN CODE \\--
--[[InteractiveClass.__newindex = function(i)
	warn("Indexed new "..tostring(i).." : "..debug.traceback())
end]]

return InteractiveClass
