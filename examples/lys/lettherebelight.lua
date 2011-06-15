factory = Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = ScaleFrom.inches,
		Model("X:/Users/lpberg/VRJuggLua/models/basicFactory.ive"),
}

RelativeTo.World:addChild(factory)


light = {}
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
	
	l:setPosition(arg.position)
	return ls
end
	

lightGroup = osg.Group()
-- Maybe need to be added to room instaed of world
RelativeTo.World:addChild(lightGroup)

ss = RelativeTo.Room:getOrCreateStateSet()

local dir = osg.Vec3f(0, -1, 0)
dir:normalize()

lightGroup:addChild(
	addLight{
		number = 0,
		ambient = 0.8,
		diffuse = 0.7,
		specular = 0.0,
		position = osg.Vec4(0, 3, 2, 1),
		direction = dir
	}
)
ss:setAssociatedModes(light[0], osg.StateAttribute.Values.ON)

lightGroup:addChild(
	addLight{
		number = 1,
		ambient = 0.0,
		diffuse = 0.5,
		specular = 0.1,
		position = osg.Vec4(0, 2, 2, 0),
		direction = osg.Vec3f(0, -1, 0)
	}
)
ss:setAssociatedModes(light[1], osg.StateAttribute.Values.ON)