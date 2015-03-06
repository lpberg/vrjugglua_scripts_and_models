require("AddAppDirectory")
AddAppDirectory()

runfile[[simpleLights.lua]]

local voyager = Transform{
	position = {-17,-1,11.5},
	Transform{
		Model("voyager.ive"),
	}
}

RelativeTo.World:addChild(voyager)