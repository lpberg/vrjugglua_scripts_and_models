--Using Code from: https://gist.github.com/lpberg/5067603
require("Actions")
require("StockModels")
require("osgFX")
local metal = true

local Manipulables = {}
local Manipulables_Switches = {}

function createManipulatableObject(xform)

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

	local xform_asMatrixTransform = wrapTransformInMatrixTransform(xform)
	local xform_asScribeSwitch = wrapTransformInBlueScribeSwitch(xform_asMatrixTransform)
	table.insert(Manipulables, xform_asMatrixTransform)
	table.insert(Manipulables_Switches, xform_asScribeSwitch)

	return xform_asScribeSwitch
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

function moveAction(dt)
	local dragBtn, changeBtn
	if not metal then
		print("Using Workstation Defaults")
		changeBtn = gadget.DigitalInterface("VJButton0")
		dragBtn = gadget.DigitalInterface("VJButton2")
	else
		print("Using METaL Defaults")
		changeBtn = gadget.DigitalInterface("WMButtonLeft")
		dragBtn = gadget.DigitalInterface("WMButtonB")
	end
	local wand = gadget.PositionInterface("VJWand")
	local activeObject = 1

	local getWandInWorld = function()
		return transformMatrixRoomToWorld(wand.matrix)
	end

	while true do
		while not dragBtn.pressed do
			if changeBtn.justPressed then
				Manipulables_Switches[activeObject]:setSingleChildOn(0)
				activeObject = activeObject + 1
				if activeObject > #Manipulables then
					activeObject = 1
				end
				Manipulables_Switches[activeObject]:setSingleChildOn(1)
			end
			Actions.waitForRedraw()
		end

		local node = Manipulables[activeObject]
		local node_matrix = node:getMatrix()
		--local nodeRelativeToWand =  node_matrix * osg.Matrixd.inverse(getWandInWorld()) --what should be possible
		local nodeRelativeToWand = matrixMult(osg.Matrixd.inverse(getWandInWorld()), node_matrix) -- what is required

		while dragBtn.pressed do
			--local new_mat = nodeRelativeToWand * getWandInWorld()
			local new_mat = matrixMult(getWandInWorld(), nodeRelativeToWand)
			node:setMatrix(new_mat)
			Actions.waitForRedraw()
		end
	end
end

Actions.addFrameAction(moveAction)

--EXAMPLES OF USE

function exampleSingleObject()
	print("EXAMPLE USE - SINGLE OBJECT (i.e. Transform)")
	local sphere = Transform{position = {1, 0, 0}, Sphere{radius = .125}}
	RelativeTo.World:addChild(createManipulatableObject(sphere))
end

function exampleMultipleObjects()
	print("EXAMPLE USE - MULTIPLE OBJECTS (GROUP)")
	local sphere1 = Transform{position = {0, 0, 0}, Sphere{radius = .125}}
	local sphere2 = Transform{position = {1, 0, 0}, Sphere{radius = .125}}
	local spheres = Transform{
		createManipulatableObject(sphere1),
		createManipulatableObject(sphere2),
	}
	RelativeTo.World:addChild(createManipulatableObject(spheres))
end