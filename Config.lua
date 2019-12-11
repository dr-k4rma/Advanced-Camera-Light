
--[[
	Project: Advanced Camera Light Plugin
	Author: Dr_K4rma
	Date: 23 Nov. 2019
	Provides: Config file for plugin
--]]

local Config = {
	Passive = {
		Type = {"PointLight", "SpotLight", "SurfaceLight"},
			Global = {
					Brightness = "_numtype:<51",
					Color = "_colortype",
					Range = "_numtype:<61",
					LightPartSizeX = "_numtype:<25:>.25",
					LightPartSizeY = "_numtype:<25:>.25",
				},
			LightPart = {
					Size = "_vectortype",
				},
			PointLight = {},
			SpotLight = {
					Angle = "_numtype:<91:>-1"
				},
			SurfaceLight = {
					Angle = "_numtype:<91:>-1"
				},
		},
	Active = {
			Type = "PointLight",
			Global = {
					Brightness = 1,
					Color = Color3.fromRGB(255, 255, 255),
					Range = 60,
					Angle = 90,
				},
			LightPart = {
					Size = Vector3.new(.25, .25, .25),
				},
		},
	}

return Config
