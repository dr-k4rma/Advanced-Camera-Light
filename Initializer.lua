
--[[
	Project: Advanced Camera Light Plugin
	Author: Dr_K4rma
	Date: 24 Nov. 2019
	Provides: Top-level plugin entity
	Uses: GuiHandler
--]]

--// SERVICES AND PRIMARY OBJECTS \\--

local Toolbar = plugin:CreateToolbar("Utils")

local UiHandler = require(script.UiHandler)
local DockHandler = require(script.DockHandler)

--// CHANGABLE VARIABLES \\--


--// MISC VARIABLES \\--
local UseDock = plugin:GetSetting("ACL_UseDock") or false

--// FUNCTIONS \\--
local Plugin = {}

Plugin.Mouse = plugin:GetMouse()
Plugin.Button = Toolbar:CreateButton("", "Advanced Camera Light", "http://www.roblox.com/asset/?id=4460541537")
Plugin.Active = false
Plugin.UseDock = UseDock

function Plugin:SetActiveState(state)
	plugin:Activate(state)
end

--// MAIN CODE \\--
--local DockInfo = 

local UiGui = script.Parent.ACL_UiGui
UiGui.Archivable = false
UiGui.Parent = game.CoreGui
Plugin.UiGui = UiGui


--local Dock = plugin:CreateDockWidgetPluginGui("DockGui", DockWidgetPluginGuiInfo.new(
--	Enum.InitialDockState.Left,
--	true,
--	--Plugin.UseDock,
--	true,
--	305,
--	140,
--	305,
--	140
--))
--Dock.Title = "Advanced Camera Light"
--Dock.Name = "ACL"
--Dock.ZIndexBehavior = Enum.ZIndexBehavior.Global
--Dock.Archivable = false
--Plugin.Dock = Dock
--
--
--local DockGui = script.Parent.ACL_DockGui
--DockGui.Archivable = false
--DockGui.Parent = Dock
--Plugin.DockGui = DockGui


UiHandler:Connect(Plugin)
--DockHandler:Connect(Plugin)