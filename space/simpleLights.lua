ss = RelativeTo.World:getOrCreateStateSet()

local function createLight1(x,y,z)
	local l1 = osg.Light()
	l1:setLightNum(1)
	l1:setAmbient(osg.Vec4(.1, .1, .1, 1.0))
	local ls1 = osg.LightSource()
	ls1:setLight(l1)
	ls1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l1, osg.StateAttribute.Values.ON)
	RelativeTo.World:addChild(ls1)
	l1:setPosition(osg.Vec4(x,y,z, 1.0))
end

local function createLight2(x,y,z)
	l2 = osg.Light()
	l2:setLightNum(2)
	l2:setAmbient(osg.Vec4(.2, .2, 0.2, .50))
	ls2 = osg.LightSource()
	ls2:setLight(l2)
	ls2:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l2, osg.StateAttribute.Values.ON)
	RelativeTo.World:addChild(ls2)
	l2:setPosition(osg.Vec4(x,y,z, 1.0))
end

createLight1(-100.0, 0.0, -25)
createLight2(100.5, 20, 25)
