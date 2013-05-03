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

--recursive function to strip of the beginning and extension of paths
function stripPathAndExtension(str)
	slash_location = string.find(str, '\\')
	if slash_location == nil then
		str = string.gsub(str, " ", "")
		str = string.gsub(str, "-", "_")
		str = string.gsub(str, "__", "_")
		str = string.gsub(str, ".osg", "")
		str = string.gsub(str, ".ive", "")
		str = string.gsub(str, ".STL", "")
		str = string.gsub(str, ".stl", "")
		return str
	else
		return stripPathAndExtension(string.sub(str, slash_location + 1))
	end
end

getRandomColor = coroutine.wrap(function()
	while true do
		coroutine.yield({153/255,0/255,0/255}) -- RED
		coroutine.yield({0/255,153/255,153/255}) -- TEAL
		coroutine.yield({76/255,0/255,153/255}) -- PURPLE
		coroutine.yield({0/255,153/255,0/255}) -- GREEN
		coroutine.yield({0/255,0/255,204/255}) -- BLUE
		coroutine.yield({204/255,204/255,0/255}) -- YELLOW
		coroutine.yield({98/255,192/255,220/255})
		coroutine.yield({188/255,166/255,142/255})
		coroutine.yield({54/255,99/255,120/255})
		coroutine.yield({0/255,120/255,173/255})
		coroutine.yield({237/255,160/255,167/255})
		coroutine.yield({30/255,213/255,89/255})
		coroutine.yield({228/255,161/255,70/255})
		coroutine.yield({125/255,125/255,0})
		coroutine.yield({199/255,74/255,108/255})
		coroutine.yield({255/255,105/255,51/255})
		coroutine.yield({110/255,166/255,191/255})
		coroutine.yield({128/255,63/255,67/255})
		coroutine.yield({218/255,202/255,143/255})
		coroutine.yield({239/255,107/255,69/255})
		coroutine.yield({125/255,0,0})
		coroutine.yield({92/255,129/255,88/255})
		coroutine.yield({102/255,153/255,254/255})
		coroutine.yield({255/255,103/255,204/255})
		coroutine.yield({0,125/255,0})
		coroutine.yield({0,0,125/255})
		coroutine.yield({102/255,51/255,1})
		coroutine.yield({255/255,251/255,102/255})
		coroutine.yield({0/255,51/255,102/255})
		coroutine.yield({239/255,107/255,69/255})
		coroutine.yield({223/255,69/255,101/255})
		coroutine.yield({255/255,128/255,192/255})
		coroutine.yield({51/255,51/255,51/255})
		coroutine.yield({204/255,153/255,104/255})
	end
end)

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
	dofile(vrjLua.findInModelSearchPath([[simpleLights.lua]]))
end

function changeTransformColor(xform, color)
	local mat = osg.Material()
	mat:setColorMode(0x1201);
	mat:setAmbient (0x0408, osg.Vec4(color[1], color[2], color[3], 1.0))
	mat:setDiffuse (0x0408, osg.Vec4(0.2, 0.2, 0.2, 1.0))
	mat:setSpecular(0x0408, osg.Vec4(0.2, 0.2, 0.2, 1.0))
	mat:setShininess(0x0408, 1)
	local ss = xform:getOrCreateStateSet()
	ss:setAttributeAndModes(mat, osg.StateAttribute.Values.ON+osg.StateAttribute.Values.OVERRIDE);
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

function scaleTransform(node,scale)
	node:setScale(osg.Vec3d(scale,scale,scale))
end