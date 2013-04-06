--Using Code from: https://gist.github.com/lpberg/5067603
require("Actions")
require("osgFX")

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

local function moveAction(dragBtn,changeBtn)

	local wand = gadget.PositionInterface("VJWand")
	local activeObject = 1

	local getWandInWorld = function()
		return transformMatrixRoomToWorld(wand.matrix)
	end
	
	local function frameAction()
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
			local nodeRelativeToWand = matrixMult(osg.Matrixd.inverse(getWandInWorld()), node_matrix) -- what is required

			while dragBtn.pressed do
				local new_mat = matrixMult(getWandInWorld(), nodeRelativeToWand)
				node:setMatrix(new_mat)
				Actions.waitForRedraw()
			end
		end
	end
	return frameAction
end

function SimSparta(dragBtn,changeBtn)
	if dragBtn == nil or changeBtn == nil then
		print("SimSparta: Must pass both valid dragBtn and changeBtn")
	else
		Actions.addFrameAction(moveAction(dragBtn,changeBtn))
		print("SimSparta: frame action initiated successfully")
	end
end