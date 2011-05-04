--Recreating light technique from OSG Tutorial: http://www.openscenegraph.org/projects/osg/attachment/wiki/Support/Tutorials/Tuto9.zip

factory = Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = ScaleFrom.inches,
		Model("X:/Users/lpberg/VRJuggLua/models/basicFactory.ive"),
}


lightGroup = Group{}
lightSS = RelativeTo.World:getOrCreateStateSet()
--*suggested from: http://www.cuboslocos.com/tutorials/OSG-BasicLighting & http://www.cs.clemson.edu/~malloy/courses/3dgames-2007/tutor/web/light/light.html
lightSS2 = lightGroup:getOrCreateStateSet() --*
lightSource1 = osg.LightSource()
lightSource2 = osg.LightSource()

-- Create a local light (1)
RelativeTo.World:addChild(Sphere{radius=.25,position = {1,1,1}})
lightPosition = osg.Vec4(1,1,1,0)
myLight = osg.Light()
myLight:setLightNum(0)
myLight:setAmbient(osg.Vec4(0,1.0,0.0,20.0))
--myLight:setDiffuse(osg.Vec4(1,1,1,1.0))
--myLight:setConstantAttenuation(1.0)
lightSource1:setLight(myLight)
lightSource1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
--lightSource1:setStateSetModes(lightSS2,osg.StateAttribute.Values.ON)
lightSS:setAssociatedModes(myLight, osg.StateAttribute.Values.ON)
lightGroup:addChild(lightSource1)
myLight:setPosition(lightPosition)




--*Create a local light (2)
RelativeTo.World:addChild(Sphere{radius=.25,position = {0,1,-3}})
lightPosition2 = osg.Vec4(0,1,-3,0)
myLight2 = osg.Light()
myLight2:setLightNum(1)
myLight2:setAmbient(osg.Vec4(1.0,0.0,0.0,1.0))
--myLight2:setDiffuse(osg.Vec4(0.1,0.4,0.1,1.0))
--myLight2:setConstantAttenuation(1.0)
lightSource2:setLight(myLight2)
lightSource2:setLocalStateSetModes(osg.StateAttribute.Values.ON)
lightSS:setAssociatedModes(myLight2, osg.StateAttribute.Values.ON)
lightGroup:addChild(lightSource2)
myLight2:setPosition(lightPosition)







RelativeTo.World:addChild(factory)
RelativeTo.World:addChild(lightGroup)
