
--[[
	Project: Advanced Camera Light Plugin
	Author: Dr_K4rma
	Date: 24 Nov. 2019
	Provides: GUI Handler
	Uses: LightPartClass, Config, InteractiveClass, ButtonClass, DropdownClass, SliderClass
--]]

--// SERVICES AND PRIMARY OBJECTS \\--
local UiHandler = {}
--local Mouse = nil
local _Gui = nil
local Light, _Plugin

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
local Connections = {}
local GuiActions = {
	Button_Preferences = {
		InputBegan = function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				_Gui.Main.Preferences.Visible = not _Gui.Main.Preferences.Visible
			end
		end,
	},
	Button_TurnOff = {
		InputBegan = function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				UiHandler:SetState(false)
				_Gui.Main.Button_TurnOff.Font = Enum.Font.SourceSans
			end
		end,
		MouseEnter = function(input, Button)
			Button.Object.Font = Enum.Font.SourceSansBold
		end,
		MouseLeave = function(input, Button)
			Button.Object.Font = Enum.Font.SourceSans
		end,
	},
	Slider_Brightness_Updated = function(Value)
--		print("Updated brightness "..Value, debug.traceback())
		Config.Active.Global.Brightness = Value
		if Light then
			Light:Update()
		end
	end,
	Dropdown_Types_Updated = function(Object)
		local Selection = Object:GetSelection()
		Config.Active.Type = Selection.Object.Text
		if Light then
			Light:Update()
		end
	end,
	Slider_OriginSizeX_Updated = function(Value)
--		print("Updated OriginSizeX "..Value, debug.traceback())
		Config.Active.LightPart.Size = Vector3.new(Value, Config.Active.LightPart.Size.Y, .25)
		if Light then
			Light:Update()
		end
	end,
	Slider_OriginSizeY_Updated = function(Value)
--		print("Updated OriginSizeY "..Value, debug.traceback())
		Config.Active.LightPart.Size = Vector3.new(Config.Active.LightPart.Size.X, Value, .25)
		if Light then
			Light:Update()
		end
	end,
	Slider_Angle_Updated = function(Value)
--		print("Updated Angle "..Value, debug.traceback())
		Config.Active.Global.Angle = Value
		if Light then
			Light:Update()
		end
	end,
	Slider_Range_Updated = function(Value)
--		print("Updated Range "..Value, debug.traceback())
		Config.Active.Global.Range = Value
		if Light then
			Light:Update()
		end
	end,
	}

--// FUNCTIONS \\--
function UiHandler:SetState(state)
	_Plugin.Active = state
	_Gui.Enabled = _Plugin.Active
	_Plugin.Button:SetActive(state)
	if _Plugin.Active then
		Light = LightPartClass.new()
	else
		Light:Destroy()
	end
end

function UiHandler:ToggleState()
	UiHandler:SetState(not _Plugin.Active)
end

function UiHandler:Connect(Plugin)
	_Plugin = Plugin
	_Gui = Plugin.UiGui
	local Main = _Gui.Main
	for _, Object in pairs(_Gui:GetDescendants()) do
		if Object:IsA("Frame") or Object:IsA("ImageLabel") or Object:IsA("TextLabel") then
			local Type = InteractiveClass.GetType(Object)
			if Type then
				if Type == "button" then
					local Button = ButtonClass.new(Object)
					if InteractiveClass.GetType(Object.Parent) ~= "dropdown" then
						if GuiActions[Button.Object.Name] then
							for action, funct in pairs(GuiActions[Button.Object.Name]) do
								Button:BindAction(Button.Object.Name.."_"..action, action, funct, Button)
							end
						end
					end
				elseif Type == "dropdown" then
					local Dropdown = DropdownClass.new(Object)
					for _, Element in pairs(Dropdown:GetElements()) do
						Element:BindAction("ElementHover", "MouseEnter", function()
							Element.Object.BackgroundColor3 = Color3.fromRGB(185, 185, 185)
						end)
						Element:BindAction("ElementUnhover", "MouseLeave", function()
							Element.Object.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						end)
					end
					if GuiActions[Dropdown.Object.Name.."_Updated"] then
						Dropdown:BindToSelectionUpdate(GuiActions[Dropdown.Object.Name.."_Updated"])
					end
				elseif Type == "slider" then
					local SliderObject = SliderClass.new(Object, Plugin)
					--local SliderShared = SharedClass.new(Object.Name)
					--SliderShared:Add(SliderObject)
					if GuiActions[SliderObject.Object.Name.."_Updated"] then
						SliderObject:BindToValueUpdate(GuiActions[SliderObject.Object.Name.."_Updated"])
					end
				end
			end
		end
	end
	local BrightnessSlider = SliderClass.GetClassObjectByName("Slider_Brightness")
	BrightnessSlider:SetRange(0, 10)
	BrightnessSlider:SetValue(DEFAULT_CONFIG.Active.Global.Brightness)
	
	local RangeSlider = BrightnessSlider.GetClassObjectByName("Slider_Range")
	RangeSlider:SetRange(0, 60)
	RangeSlider:SetRoundValue(1)
	RangeSlider:SetValue(DEFAULT_CONFIG.Active.Global.Range)
	
	local AngleSlider = BrightnessSlider.GetClassObjectByName("Slider_Angle")
	AngleSlider:SetRange(0, 180)
	AngleSlider:SetRoundValue(5)
	AngleSlider:SetValue(DEFAULT_CONFIG.Active.Global.Angle)
	
	local OriginSizeXSlider = BrightnessSlider.GetClassObjectByName("Slider_OriginSizeX")
	OriginSizeXSlider:SetRange(.25, 25)
	OriginSizeXSlider:SetRoundValue(.25)
	OriginSizeXSlider:SetValue(DEFAULT_CONFIG.Active.LightPart.Size.X)
	
	local OriginSizeYSlider = BrightnessSlider.GetClassObjectByName("Slider_OriginSizeY")
	OriginSizeYSlider:SetRange(.25, 25)
	OriginSizeYSlider:SetRoundValue(.25)
	OriginSizeYSlider:SetValue(DEFAULT_CONFIG.Active.LightPart.Size.Y)
	
	Plugin.Button.Click:Connect(function()
		UiHandler:ToggleState()
	end)
end

--// MAIN CODE \\--

return UiHandler
