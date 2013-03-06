-- Useful tools and various functions
require("osgFX")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())

function printUsefulTools()
	print("Functions in UsefulTools: ")
	print("\t\t" .. "addToWorld(xform)")
	print("\t\t" .. "wrapTransformInBlueScribeSwitch(xform)")
	print("\t\t" .. "wrapTransformInMatrixTransform(xform)")
	print("\t\t" .. "getRoomToWorld()")
	print("\t\t" .. "matrixMult(a,b)")
	print("\t\t" .. "transformMatrixRoomToWorld(matrix)")
	print("\t\t" .. "applyBasicLighting()")
	print("\t\t" .. "changeTransformColor(xform,{r/255,g/255,b/255})")
	print("\t\t" .. "getBasicFactory() - returns xform")
	print("\t\t" .. "loadBasicFactory() - adds it to World")
	print("\t\t" .. "loadBasicFactoryWithBasicLighting()")
	print("\t\t" .. "getSimpleBunny() - returns bunny xform")
	print("\t\t" .. "getLightsaber() - returns lightsaber xform")
end

local Stock_Models = {
	factory = Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = ScaleFrom.inches,
		Model(vrjLua.findInModelSearchPath([[/models/basicfactory.ive]]))
	},
	bunny = Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = ScaleFrom.inches,
		Model(vrjLua.findInModelSearchPath([[/models/bunny.osg]]))
	},
	lightsaber = Transform{
		scale = ScaleFrom.inches * 1.5,
		Model(vrjLua.findInModelSearchPath([[/models/lightsaber.osg]]))
	},
}

function addToWorld(xform)
	RelativeTo.World:addChild(xform)
end

function wrapTransformInBlueScribeSwitch(xform)
	local switch = osg.Switch()
	local scribe = osgFX.Scribe()
	scribe:setWireframeColor(osg.Vec4f(0, 0, 1, 1))
	switch:addChild(xform)
	switch:addChild(scribe)
	scribe:addChild(xform)
	switch:setSingleChildOn(0)
	return switch
end

function wrapTransformInMatrixTransform(xform)
	local MT = osg.MatrixTransform()
	MT:addChild(xform)
	return MT
end

local getRoomToWorld = function()
	return RelativeTo.World:getInverseMatrix()
end

--- This is a HIDEOUS HACK @todo
local matrixMult = function(a, b)
	local copyOfA = osg.Matrixd(a)
	copyOfA:preMult(b)
	return copyOfA
end

local transformMatrixRoomToWorld = function(m)
	return matrixMult(getRoomToWorld(), m)
end


function applyBasicLighting()
	local ss = RelativeTo.World:getOrCreateStateSet()
	local l1 = osg.Light()
	l1:setLightNum(1)
	l1:setAmbient(osg.Vec4(.1, .1, .1, 1.0))
	local ls1 = osg.LightSource()
	ls1:setLight(l1)
	ls1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l1, osg.StateAttribute.Values.ON)
	RelativeTo.Room:addChild(
		ls1
	)
	l1:setPosition(osg.Vec4(1, 1, .5, 1.0))
end

function changeTransformColor(xform, color)
	local mat = osg.Material()
	mat:setColorMode(0x1201);
	mat:setAmbient (0x0408, osg.Vec4(color[1], color[2], color[3], 1.0))
	mat:setDiffuse (0x0408, osg.Vec4(0.2, 0.2, 0.2, 1.0))
	mat:setSpecular(0x0408, osg.Vec4(0.2, 0.2, 0.2, 1.0))
	mat:setShininess(0x0408, 1)
	local ss = xform:getOrCreateStateSet()
	ss:setAttributeAndModes(mat, osg.StateAttribute.Values.ON + osg.StateAttribute.Values.OVERRIDE);
end

function getBasicFactory()
	local factory = Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = ScaleFrom.inches,
		Model(vrjLua.findInModelSearchPath([[/models/basicfactory.ive]]))
	}
	return factory
end

function loadBasicFactory()
	RelativeTo.World:addChild(getBasicFactory())
end

function loadBasicFactoryWithBasicLighting()
	loadBasicFactory()
	applyBasicLighting()
end

function getSimpleBunny()
	return Stock_Models.bunny
end

function getLightsaber()
	return Stock_Models.lightsaber
end

function loadSkyBoxWithBasicLighting()
	dofile(vrjLua.findInModelSearchPath([[environments/skybox/loadSkybox.lua]]))
end