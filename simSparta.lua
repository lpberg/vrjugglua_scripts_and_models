require("Actions")
require("StockModels")
require("osgFX")
local metal = false

local Manipulables = {}
local Manipulables_Switches = {}

local function wrapXformInScribeSwitch(xform)
	local MT = osg.MatrixTransform()
	MT:addChild(xform)
	table.insert(Manipulables, MT)
	local switch = osg.Switch()
	local scribe = osgFX.Scribe()
	scribe:setWireframeColor(osg.Vec4f(0, 0, 1, 1))
	switch:addChild(MT)
	switch:addChild(scribe)
	scribe:addChild(MT)
	switch:setSingleChildOn(0)
	table.insert(Manipulables_Switches, switch)
	return switch
end
-- EXAMPLE USE - SINGLE OBJECTS
-- 1)Create Transform

-- local teapot = Transform{position = {1,0,0},StockModels.Teapot()}
-- 2)AddTransform to Scene using wrapXformInScribeSwitch()
-- RelativeTo.World:addChild(wrapXformInScribeSwitch(teapot))

-- EXAMPLE USE - MULTIPLE OBJECTS (GROUP)
-- 1)Create Transform
local teapot = Transform{position = {0,0,0},StockModels.Teapot()}
local teapot2 = Transform{position = {1,0,0},StockModels.Teapot()}
local teapots = Transform{
	wrapXformInScribeSwitch(teapot),
	wrapXformInScribeSwitch(teapot2),
}
-- 2)AddTransform to Scene using wrapXformInScribeSwitch()
RelativeTo.World:addChild(wrapXformInScribeSwitch(teapots))

function moveAction(dt)
	local dragBtn, changeBtn
	if not metal then
		print("Using Workstation Defaults")
		changeBtn = gadget.DigitalInterface("VJButton0")
		dragBtn = gadget.DigitalInterface("VJButton2")
	else
		print("Using METaL Defaults")
		changeBtn = gadget.DigitalInterface("WMButtonPlus")
		dragBtn = gadget.DigitalInterface("WMButtonB")
	end

	local wand = gadget.PositionInterface("VJWand")
	local activeObject = 1

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
		-- nav_mat = RelativeTo.World:getInverseMatrix():preMult(wand.matrix)
		local node = Manipulables[activeObject]
		local node_matrix = node:getMatrix()
		local xformFromNodeToWand = node_matrix * osg.Matrixd.inverse(wand.matrix) 

		while dragBtn.pressed do
			local new_mat = xformFromNodeToWand * wand.matrix 
			node:setMatrix(new_mat)
			Actions.waitForRedraw()
		end
	end
end

Actions.addFrameAction(moveAction)