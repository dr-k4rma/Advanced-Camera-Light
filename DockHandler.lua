
--[[
	Project: Advanced Camera Light Plugin
	Author: Dr_K4rma
	Date: 9 Dec. 2019
	Provides: Dock GUI Handler
	Uses: 
]]--

--// SERVICES AND PRIMARY OBJECTS \\-
local DockHandler = {}

local LightPartClass = require(script.Parent.LightPartClass)

local DEFAULT_CONFIG = require(script.Parent.Config:Clone())
local Config = require(script.Parent.Config)

local ClassesFolder = script.Parent.UIClasses
local InteractiveClass = require(ClassesFolder.InteractiveClass)
local ButtonClass = require(ClassesFolder.ButtonClass)
local DropdownClass = require(ClassesFolder.DropdownClass)
local SliderClass = require(ClassesFolder.SliderClass)

--// CHANGABLE VARIABLES \\--

--// MISC VARIABLES \\--
local _Gui

--// FUNCTIONS \\--
function DockHandler:Connect(Plugin)
	_Gui = Plugin.DockGui
	local Main = _Gui.Main
	for _, Object in pairs(_Gui:GetDescendants()) do
		if Object:IsA("Frame") or Object:IsA("ImageLabel") or Object:IsA("TextLabel") then
			local Type = InteractiveClass.GetType(Object)
			if Type then
				local ObjectName = Object.Name
				Object.Name = ObjectName.."_DropDown"
				if Type == "button" then
					
				elseif Type == "dropdown" then
					
				elseif Type == "slider" then
					local SliderObject = SliderClass.new(Object, Plugin)
					SliderObject:ConnectMirror(SliderClass.GetClassObjectByName(ObjectName))
				end
			end
		end
	end
end

--// MAIN CODE \\--

return DockHandler