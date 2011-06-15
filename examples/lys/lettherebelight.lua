require("Actions")
dofile("X:/users/lpberg/VRJuggLua/examples/movetools.lua")
light = {}
lightGroup = osg.Group()
RelativeTo.World:addChild(lightGroup)
ss = RelativeTo.Room:getOrCreateStateSet()

robot = Transform{
	Model([[X:\users\adamc17\Factory\Factory Models\OSG\Machines\Robot.osg]])
}
Actions.addFrameAction(Rotation.createRotation(robot,"y",40))

factory = Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = ScaleFrom.inches,
		Model("X:/Users/lpberg/VRJuggLua/models/basicFactory.ive"),
}
RelativeTo.World:addChild(robot)
RelativeTo.World:addChild(factory)


function addLight(arg)
	local l = osg.Light()
	l:setLightNum(arg.number)
	light[arg.number] = l
	l:setDirection(osg.Vec3(0,-1,0))
	l:setSpotCutoff(60.0)
	l:setSpotExponent(0.5)
	local ls = osg.LightSource()
	ls:setLight(l)
	ls:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	l:setAmbient(osg.Vec4(arg.ambient, arg.ambient, arg.ambient, 1))
	l:setDiffuse(osg.Vec4(arg.diffuse, arg.diffuse, arg.diffuse, 1))
	l:setSpecular(osg.Vec4(arg.specular, arg.specular, arg.specular, 1))
	l:setPosition(arg.position)
	RelativeTo.World:addChild(Sphere{radius=.25,position={arg.position:x(),arg.position:y(),arg.position:z()}})
	return ls
end
	 
--local dir = osg.Vec3f(0, 0, -.8)
--dir:normalize()

light0 = addLight{
	number = 0,
	ambient = 0.8,
	diffuse = 0.7,
	specular = 0.0,
	position = osg.Vec4(0, 4, 0, 1),
	direction = dir
}

lightGroup:addChild(light0)
--[[
light1 = addLight{
	number = 1,
	ambient = 0.0,
	diffuse = 0.5,
	specular = 0.1,
	position = osg.Vec4(0, 2, 2, 0),
	--direction = osg.Vec3f(0, -1, 0)
}

--lightGroup:addChild(light1)
]]--
--ss:setAssociatedModes(light[0], osg.StateAttribute.Values.ON)
--ss:setAssociatedModes(light[1], osg.StateAttribute.Values.ON)