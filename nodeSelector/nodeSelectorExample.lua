require("AddAppDirectory")
require("osgUtil")
AddAppDirectory()
runfile[[nodeSelector.lua]]
runfile[[helper.lua]]

balls = Transform{
	Transform{
		scale = 1/100,
		Model[[C:\Users\lpberg\Desktop\danfoss_pump.osg]]
	},
	Transform{
		Transform{
			Sphere{position = {-1, 0, 0},radius=.125},
		},
		Transform{
			Sphere{position = {-1, .5, 0},radius=.125},
		}
	},
	Transform{
		Transform{
			Transform{
				Sphere{position = {0, 0, 0},radius=.125},
			}
		}
	},
	Transform{
		Sphere{position = {1, 0, 0},radius=.125},
	},
	Transform{
		Sphere{position = {1.5, 0, 0},radius=.125},
	}
}

RelativeTo.World:addChild(balls)

ns = nodeSelector{
	parent = balls,
}

-- local isParentTopofSnake = ns:isTopOfSnake(ns.parent)
-- print("Should print false: ",isParentTopofSnake)
-- local isChild1TopofSnake = ns:isTopOfSnake(ns.parent.Child[1])
-- print("Should print false: ",isChild1TopofSnake)
-- local isChild2TopofSnake = ns:isTopOfSnake(ns.parent.Child[2])
-- print("Should print true: ",isChild2TopofSnake)
-- local isChild3TopofSnake = ns:isTopOfSnake(ns.parent.Child[3])
-- print("Should print true: ",isChild3TopofSnake)
-- local isChild4TopofSnake = ns:isTopOfSnake(ns.parent.Child[4])
-- print("Should print true: ",isChild4TopofSnake)


Actions.addFrameAction(function()
	local wand = gadget.PositionInterface("VJWand")
	local dragBtn = gadget.DigitalInterface("VJButton2")
	
	local function setMatrix(xform, mat)
		if osgLua.getTypeInfo(xform).name == [[osg::PositionAttitudeTransform]] then
			xform:setPosition(mat:getTrans())
			xform:setAttitude(mat:getRotate())
		else
			xform:setMatrix(mat)
		end
	end

	local function getMatrix(xform)
		if osgLua.getTypeInfo(xform).name == [[osg::PositionAttitudeTransform]] then
			mat = osg.Matrixd()
			mat:setTrans(xform:getPosition())
			mat:setRotate(xform:getAttitude())
			return mat
		elseif osgLua.getTypeInfo(xform).name == [[osg::MatrixTransform]] then
			return xform:getMatrix()
		end
	end

	local function getWandInWorld()
		return wand.matrix * RelativeTo.World:getInverseMatrix()
	end

	local function getPosition(xform)
		mat = getMatrix(xform)
		return mat:getTrans()
	end
	
	while true do
		if dragBtn.justPressed then
			node = ns.selectedNode
			local wandpos = getWandInWorld()
			nodeRelativeToWand = getMatrix(node) * osg.Matrixd.inverse(wandpos)
		end
		if dragBtn.pressed then
			print(getPosition(node))
			local new_mat = nodeRelativeToWand * getWandInWorld()
			setMatrix(node, new_mat)
		end
		Actions.waitForRedraw()
	end
end)
