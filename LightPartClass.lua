
--[[
	Project: Advanced Camera Light Plugin
	Author: Dr_K4rma
	Date: 23 Nov. 2019
	Provides: LightPart class
--]]

--// SERVICES AND PRIMARY OBJECTS \\--
local LightPartClass = {}
LightPartClass.__index = LightPartClass

local Config = require(script.Parent.Config)

--// CHANGABLE VARIABLES \\--


--// MISC VARIABLES \\--
local Connections = {}
local _existingLightPart = nil

LightPartClass.Object = nil
--// FUNCTIONS \\--
function LightPartClass:Destroy()
	for _, a in pairs(Connections) do
		a:Disconnect()
	end
	self.Part:Destroy()
end

function LightPartClass:Update()
	if not self.Light:IsA(Config.Active.Type) then
		self.Light:Destroy()
		self.Light = Instance.new(Config.Active.Type, self.Part)
	end
	for Property, Value in pairs(Config.Active.Global) do
		if Property == "Angle" then
			if self.Light:IsA("SurfaceLight") or self.Light:IsA("SpotLight") then
				self.Light[Property] = Value
			end
		else
			self.Light[Property] = Value
		end
	end
	for Property, Value in pairs(Config.Active.LightPart) do
		if Value then
			self.Part[Property] = Value
		end
	end
end

function LightPartClass.new()
	if _existingLightPart then
		warn("BCLight:// Detected old LightPart - Deleting")
		_existingLightPart:Destroy()
		_existingLightPart = nil
	end
	
	local LightPartObject = {}
	setmetatable(LightPartObject, LightPartClass)
	
	local Part = Instance.new("Part")
	Part.Name = "BCLight"
	Part.Anchored = true
	Part.Locked = true
	Part.CanCollide = false
	Part.Archivable = false
	Part.Size = Vector3.new(.25, .25, .25)
	Part.Transparency = 1
	Part.Parent = workspace
	
	local Light = Instance.new(Config.Active.Type)
	Light.Parent = Part
	
	LightPartObject.Part = Part
	LightPartObject.Light = Light
	
	Connections.Run = game:GetService("RunService").Heartbeat:Connect(function()
		LightPartObject.Part.CFrame = workspace.CurrentCamera.CFrame + (workspace.CurrentCamera.CFrame.LookVector * -.05)
	end)
	
	LightPartObject:Update()
	return LightPartObject
end

--// MAIN CODE \\--

return LightPartClass
