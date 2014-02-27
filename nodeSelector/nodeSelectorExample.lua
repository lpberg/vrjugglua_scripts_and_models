require("AddAppDirectory")
AddAppDirectory()
runfile[[nodeSelector.lua]]

local balls = Transform{
	Transform{
		Sphere{position = {-1, 0, 0},radius=.125},
		Sphere{position = {-1,.5,0},radius=.125},
		Sphere{position = {-1, 1, 0},radius=.125},
	},
	Transform{
		Sphere{position = {0, 0, 0},radius=.125},
		Sphere{position = {0,.5,0},radius=.125},
		Sphere{position = {0, 1, 0},radius=.125},
	},
	Transform{
		Sphere{position = {1, 0, 0},radius=.125},
		Sphere{position = {1,.5,0},radius=.125},
		Sphere{position = {1, 1, 0},radius=.125},
	},
	Transform{
		Sphere{position = {1.5, 0, 0},radius=.125},
		Sphere{position = {1.5,.5,0},radius=.125},
		Sphere{position = {1.5, 1, 0},radius=.125},
	}
}

RelativeTo.World:addChild(balls)

ns = nodeSelector{
	parent = balls,
}

-- ns:moveDown()
-- ns:moveUp()

