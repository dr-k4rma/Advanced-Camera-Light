
--[[
	Project: Advanced Camera Light Plugin
	Author: Dr_K4rma
	Date: 24 Nov. 2019
	Provides: Slider class
	Uses: InteractiveClass, ButtonClass
--]]

--// SERVICES AND PRIMARY OBJECTS \\--
local InteractiveClass = require(script.Parent.InteractiveClass)
local ButtonClass = require(script.Parent.ButtonClass)

local SliderClass = setmetatable({}, InteractiveClass)
SliderClass.__index = SliderClass

--// MISC VARIABLES \\--
local Connections = {}
local InstantiatedObjects = {}

--// FUNCTIONS \\--
function SliderClass.GetClassObjectByName(name)
	for Object, ClassObject in pairs(InstantiatedObjects) do
		if Object.Name == name then
			return ClassObject
		end
	end
end

function SliderClass.GetClassObjectByObject(object)
	for Object, ClassObject in pairs(InstantiatedObjects) do
		if Object == object then
			return ClassObject
		end
	end
end

function SliderClass:SetRange(Min, Max)
	self.Range.Min = Min
	self.Range.Max = Max
end

function SliderClass:BindToValueUpdate(funct, getRaw)
	local con = self.Slider.Object.Changed:Connect(function()
		funct(self:GetValue(getRaw))
	end)
	table.insert(Connections, con)
	return con
end

function SliderClass:GetValue(getRaw)
	getRaw = getRaw or false
	if getRaw then
		return self._RawValue
	else
		if self.Range.Max then
			return math.clamp((self._RawValue / self.Clamp.AbsoluteSize.X) * (self.Range.Max), self.Range.Min, self.Range.Max)
		else
			return self._RawValue
		end
	end
end
--[[
	153			x
	----	=	----
	200			50
--]]

function SliderClass:SetValue(Value)
	if self.Range.Max then
		self._RawValue = (self.Clamp.AbsoluteSize.X * Value) / self.Range.Max
	else
		self._RawValue = Value
	end
	self.Slider.Object.Position = UDim2.new(UDim.new(self.Slider.Object.Position.X.Scale, self._RawValue), self.Slider.Object.Position.Y)
end
--[[
	x			24
	----	=	----
	200			50
--]]

function SliderClass:SetRoundValue(Value)
	self._RoundValue = Value
end

function SliderClass:ConnectMirror(SliderObject)
	SliderObject:_AddMirroredSlider(self)
	--self:ConnectMirror(SliderObject)
end

function SliderClass:_AddMirroredSlider(ToMirrorSlider)
	local i = 0
	local AlreadyExists = false
	for _, a in pairs(self._MirrorObjects) do
		if a == ToMirrorSlider then
			AlreadyExists = true
		end
		i = i + 1
		if i > 1000 then
			print("EMERGENCY EXIT")
			break
		end
	end
	if not AlreadyExists then
		table.insert(self._MirrorObjects, ToMirrorSlider)
	end
end

function SliderClass.new(Object, Plugin)
	local SliderObject = setmetatable(InteractiveClass.new(Object), SliderClass)
	
	InstantiatedObjects[Object] = SliderObject
	
	SliderObject.Clamp = SliderObject.Object.SlideClamp
	SliderObject.Slider = InteractiveClass.new(SliderObject.Object.SlideClamp.Mover)
	SliderObject.Range = {Min = 0, Max = nil}
	SliderObject._RawValue = 0
	SliderObject.OnUpdateFunction = nil
	SliderObject._RoundValue = .1
	SliderObject._Active = false
	SliderObject._MirrorObjects = {}
	
	local Dragging = false
	local _Dragger
	local _ValueTag
	SliderObject.Slider:BindAction("BeginDragging", "InputBegan", function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			Plugin:SetActiveState(true)
			local previousValue = 0
			SliderObject.Slider.Object.Value.Visible = true
			SliderObject._Active = true
			_ValueTag = SliderObject:BindToValueUpdate(function(Value)
				SliderObject.Slider.Object.Value.Text = Value
			end)
			_Dragger = game:GetService("RunService").Heartbeat:Connect(function()
				SliderObject._RawValue = math.clamp(Plugin.Mouse.X - SliderObject.Clamp.AbsolutePosition.X, 0, SliderObject.Clamp.AbsoluteSize.X)
				SliderObject:SetValue(SliderObject:GetValue() - SliderObject:GetValue() % SliderObject._RoundValue)
				SliderObject.Slider.Object.Position = UDim2.new(SliderObject.Slider.Object.Position.X.Scale, SliderObject._RawValue, SliderObject.Slider.Object.Position.Y.Scale, SliderObject.Slider.Object.Position.Y.Offset)
				for _, a in pairs(SliderObject._MirrorObjects) do
					a:SetValue(SliderObject:GetValue())
				end
			end)
		end
	end)
	SliderObject.Slider:BindAction("EndDragging", "InputEnded", function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = false
			Plugin:SetActiveState(false)
			if _Dragger then
				_Dragger:Disconnect()
			end
			if _ValueTag then
				_ValueTag:Disconnect()
			end
			SliderObject.Slider.Object.Value.Visible = false
			SliderObject._Active = false
			if SliderObject.OnUpdateFunction and SliderObject._Active then
				SliderObject.OnUpdateFunction(SliderObject:GetValue())
			end
		end
	end)
	return SliderObject
end

--// MAIN CODE \\--

return SliderClass
