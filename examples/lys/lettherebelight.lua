require("Actions")
dofile("X:/users/lpberg/VRJuggLua/examples/movetools.lua")
light = {}
lightGroup = osg.Group()
RelativeTo.World:addChild(lightGroup)
ss = RelativeTo.Room:getOrCreateStateSet()


robot = Transform{
	Model([[X:\users\adamc17\Factory\Factory Models\OSG\Machines\Robot.osg]])
}
RelativeTo.World:addChild(robot)


--Actions.addFrameAction(Rotation.createRotation(robot,"y",20))
factory = Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = ScaleFrom.inches,
		Model("X:/Users/lpberg/VRJuggLua/models/basicFactory.ive"),
}
RelativeTo.World:addChild(factory)


function addSpotLight(arg)
	local l = osg.Light()
	l:setLightNum(arg.number)
	light[arg.number] = l

	if arg.direction ~= nil then
		l:setDirection(arg.direction)
	else
		l:setDirection(osg.Vec3(0,-1,0))
	end
	if arg.spotcutoff ~= nil then
		l:setSpotCutoff(arg.spotcutoff)
	else
		l:setSpotCutoff(45.0)
	end
	if arg.spotexponent ~= nil then
		l:setSpotExponent(arg.spotexponent)
	else
		l:setSpotExponent(0.5)	
	end
	
	local ls = osg.LightSource()
	ls:setLight(l)
	ls:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	l:setAmbient(osg.Vec4(arg.ambient,0.0, 0.0, 1))
	l:setDiffuse(osg.Vec4(arg.diffuse, arg.diffuse, arg.diffuse, 1))
	l:setSpecular(osg.Vec4(arg.specular, arg.specular, arg.specular, 1))

	if arg.sphere == true then
		RelativeTo.World:addChild(Sphere{radius=.05,position={arg.position:x(),arg.position:y(),arg.position:z()}})
	end
	ss:setAssociatedModes(l, osg.StateAttribute.Values.ON)
	l:setPosition(arg.position)
	return ls
end

function addLight(arg)
	
	local l = osg.Light()
	l:setLightNum(arg.number)
	light[arg.number] = l
	
	local ls = osg.LightSource()
	ls:setLight(l)
	ls:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	
	l:setAmbient(osg.Vec4(arg.ambient, arg.ambient, arg.ambient, 1))
	l:setDiffuse(osg.Vec4(arg.diffuse, arg.diffuse, arg.diffuse, 1))
	l:setSpecular(osg.Vec4(arg.specular, arg.specular, arg.specular, 1))

	ss:setAssociatedModes(l, osg.StateAttribute.Values.ON)
	RelativeTo.World:addChild(Sphere{radius=.05,position={arg.position:x(),arg.position:y(),arg.position:z()}})
	l:setPosition(arg.position)
	return ls
end
	 
-- local dir = osg.Vec3f(0, 0, -.8)
-- dir:normalize()

light1 = addLight{
	number = 1,
	position = osg.Vec4(0,3.7,-5,0),
	ambient = 0.5,
	specular = 0.0,
	diffuse = 0.7
}
light0 = addSpotLight{
	number = 0,
	position = osg.Vec4(0,3.7,0,1),
	ambient = 0.8,
	specular = 0.0,
	diffuse = 0.7,
	sphere = true,
}

RelativeTo.World:addChild(light0)
RelativeTo.World:addChild(light1)
