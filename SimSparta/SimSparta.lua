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

local function moveAction(dragBtn,nextBtn,prevBtn)

	local wand = gadget.PositionInterface("VJWand")
	local activeObject = 1

	local getWandInWorld = function()
		return transformMatrixRoomToWorld(wand.matrix)
	end
	
	local function frameAction()
		while true do
			while not dragBtn.pressed do
				if nextBtn.justPressed then
					--turn off scribe effect current node
					Manipulables_Switches[activeObject]:setSingleChildOn(0)
					--set active object index increase by one
					activeObject = activeObject + 1
					--if obect index greater than number of objects reset to first
					if activeObject > #Manipulables then
						activeObject = 1
					end
					--set active object scribe on
					Manipulables_Switches[activeObject]:setSingleChildOn(1)
				end
				if prevBtn ~= nil then
					if prevBtn.justPressed then
						--turn off scribe effect current node
						Manipulables_Switches[activeObject]:setSingleChildOn(0)
						--set active object index decrease by one
						activeObject = activeObject - 1
						--if object index less than 1 (0) reset to last
						if activeObject < 1 then
							activeObject = #Manipulables
						end
						--set active object scribe on
						Manipulables_Switches[activeObject]:setSingleChildOn(1)
					end
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

function SimSparta(dragBtn,changeBtn,prevBtn)
	if dragBtn == nil or changeBtn == nil then
		print("SimSparta: Must pass both valid dragBtn and nextBtn (optionally: prevBtn")
	else
		Actions.addFrameAction(moveAction(dragBtn,changeBtn))
		print("SimSparta: frame action initiated successfully")
	end
end