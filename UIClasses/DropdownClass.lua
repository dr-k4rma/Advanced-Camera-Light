
--[[
	Project: Advanced Camera Light Plugin
	Author: Dr_K4rma
	Date: 24 Nov. 2019
	Provides: DropDown class
	Uses: InteractiveClass, ButtonClass
--]]

--// SERVICES AND PRIMARY OBJECTS \\--
local InteractiveClass = require(script.Parent.InteractiveClass)
local ButtonClass = require(script.Parent.ButtonClass)

local DropdownClass = setmetatable({}, InteractiveClass)
DropdownClass.__index = DropdownClass

--// MISC VARIABLES \\--


--// FUNCTIONS \\--
function DropdownClass:Open()
	local TotalOpenSize = 0
	for _, a in pairs(self.Object:GetChildren()) do
		if InteractiveClass.IsInteractiveObject(a) then
			TotalOpenSize = TotalOpenSize + self.Object.AbsoluteSize.Y
		end 
	end
	self.Object.Size = UDim2.new(self.Object.Size.X.Scale, self.Object.Size.X.Offset, 0, TotalOpenSize)
end

function DropdownClass:Close()
	local CloseSize
	for _, a in pairs(self.Object:GetChildren()) do
		if InteractiveClass.IsInteractiveObject(a) then
			CloseSize = a.Size.Y.Offset
			break
		end 
	end
	self.Object.Size = UDim2.new(self.Object.Size.X.Scale, self.Object.Size.X.Offset, 0, CloseSize)
end

function DropdownClass:GetElements()
	return self.Elements
end

function DropdownClass:UpdateElementOrder()
	for i, Element in pairs(self:GetElements()) do
		Element.Object.LayoutOrder = i
	end
	if self.OnUpdateFunction then
		self.OnUpdateFunction(self)
	end
end

function DropdownClass:Select(ButtonObject)
	local ElementTable = self:GetElements()
	for i, Element in pairs(ElementTable) do
		if Element == ButtonObject then
			table.remove(ElementTable, i)
			break
		end
	end
	table.insert(ElementTable, 1, ButtonObject)
	self.Selected = ButtonObject
	self:UpdateElementOrder()
end

function DropdownClass:BindToSelectionUpdate(funct)
	self.OnUpdateFunction = funct
end

function DropdownClass:GetSelection()
	return self.Selected
end

function DropdownClass.new(Object)
	--Inherits from InteractiveClass
	local DropdownObject = setmetatable(InteractiveClass.new(Object), DropdownClass)
	
	DropdownObject.IsOpen = false
	DropdownObject.Selected = nil
	DropdownObject.Elements = {}
	DropdownObject.OnUpdateFunction = nil
	
	for _, a in pairs(DropdownObject.Object:GetChildren()) do
		if InteractiveClass.IsInteractiveObject(a) and InteractiveClass.GetType(a) == "button" then
			local Button = ButtonClass.new(a)
			DropdownObject.Elements[a.LayoutOrder] = Button
			Button:BindAction("Select_"..Button.Object.Name, "InputBegan", function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					DropdownObject:Select(Button)
				end
			end)
		end
	end
	
 	DropdownObject:BindAction("OpenDropdown", "MouseEnter",function() DropdownObject:Open() end)
	DropdownObject:BindAction("CloseDropdown", "MouseLeave", function() DropdownObject:Close() end)
	
	return DropdownObject
end

--// MAIN CODE \\--
return DropdownClass
