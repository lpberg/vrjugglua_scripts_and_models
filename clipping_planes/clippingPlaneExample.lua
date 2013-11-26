-- clipping plane example
require "AddAppDirectory"
require("StockModels")
AddAppDirectory()
runfile[[ClipPlanes.lua]]

--create sample geometry
teapot = Transform{
	position = {0,0,0},
	orientation = AngleAxis(Degrees(90),Axis{1.0,0.0,0.0}),
	Transform{
		scale = .45,
		StockModels.Teapot(),
		Sphere{radius=.125},
	}
}

cp = ClipPlanes{
	node = teapot,
	enabled_Z = false,
}

RelativeTo.World:addChild(cp.parent)
