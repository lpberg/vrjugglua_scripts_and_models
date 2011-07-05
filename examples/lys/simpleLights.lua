require("getScriptFilename")
fn = getScriptFilename()
assert(fn, "Have to load this from file, not copy and paste, or we can't find our models!")
vrjLua.appendToModelSearchPath(fn)
vrjLua.appendToModelSearchPath(vrjLua.findInModelSearchPath("../../models/"))

factory = Transform{
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	scale = ScaleFrom.inches,
	Model("basicfactory.ive")
}
--RelativeTo.World:addChild(factory)

ss = RelativeTo.World:getOrCreateStateSet()
RelativeTo.World:addChild(Sphere{radius=.23, position = {0,3,-5}})
--RelativeTo.World:addChild(Sphere{radius=.23, position = {1.5,2,-6}})
function doLight1()

	l1 = osg.Light()
	l1:setAmbient(osg.Vec4(0.8, 0.8, 0.8, 0.8))
	ls1 = osg.LightSource()
	ls1:setLight(l1)
	ls1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l1, osg.StateAttribute.Values.ON)
	RelativeTo.Room:addChild(
		ls1
	)

	l1:setPosition(osg.Vec4(0, 3, -5, 1))
end
-- doLight1()
function doLight1_5()

	local l1 = osg.Light()
	l1:setAmbient(osg.Vec4(.8, .8, 0.7, 1.0))
	local ls1 = osg.LightSource()
	ls1:setLight(l1)
	ls1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l1, osg.StateAttribute.Values.ON)
	RelativeTo.Room:addChild(
		ls1
	)
	l1:setPosition(osg.Vec4(1.5, 2, -6, 0))
end
function doLight2()

	l2 = osg.Light()
	l2:setLightNum(1)
	l2:setAmbient(osg.Vec4(.8, .8, 0.6, 1.0))
	
	ls2 = osg.LightSource()
	ls2:setLight(l2)
	ls2:setLocalStateSetModes(osg.StateAttribute.Values.ON)

	ss:setAssociatedModes(l2, osg.StateAttribute.Values.ON)
	
	RelativeTo.Room:addChild(
		ls2
	)
	l2:setPosition(osg.Vec4(1.5, 2, -6, 1.0))
end

doLight1()
doLight2()