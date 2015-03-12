ss = RelativeTo.World:getOrCreateStateSet()

function doLight1()
	local l3 = osg.Light()
	l3:setLightNum(0)
	l3:setAmbient(osg.Vec4(.2, .2, .2, 1.0))
	local ls3 = osg.LightSource()
	ls3:setLight(l3)
	ls3:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l3, osg.StateAttribute.Values.ON)
	RelativeTo.World:addChild(ls3)
	l3:setPosition(osg.Vec4(10.0, 1.5, 10, 1.0))
end

function doLight2()
	l2 = osg.Light()
	l2:setLightNum(1)
	l2:setAmbient(osg.Vec4(.2, .2, 0.2, 1.0))
	ls2 = osg.LightSource()
	ls2:setLight(l2)
	ls2:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l2, osg.StateAttribute.Values.ON)
	RelativeTo.World:addChild(ls2)
	l2:setPosition(osg.Vec4(10, 10, -2, 1.0))
end

function doLight3()
	l4 = osg.Light()
	l4:setLightNum(1)
	l4:setAmbient(osg.Vec4(.2, .2, .2, 1.0))
	ls4 = osg.LightSource()
	ls4:setLight(l4)
	ls4:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l4, osg.StateAttribute.Values.ON)
	RelativeTo.World:addChild(ls4)
	l4:setPosition(osg.Vec4(-15, 5, -2, 1.0))
end

doLight1()
doLight2()
doLight3()
print("simpleLights added to scene")