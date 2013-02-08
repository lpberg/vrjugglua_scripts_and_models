require("Actions")
require("StockModels")
require("osgFX")
local inMETaL = false

-- EXAMPLE USE
-- 1)Create Transform
-- local teapot = Transform{position = {1,0,0},StockModels.Teapot()}
-- 2)AddTransform to Scene using wrapXformInScribeSwitch()
-- RelativeTo.World:addChild(wrapXformInScribeSwitch(teapot))

local Manipulables = {}
local Manipulables_Switches = {}

local function wrapXformInScribeSwitch(xform)
	table.insert(Manipulables, xform)
	local switch = osg.Switch()
	local scribe = osgFX.Scribe()
	scribe:setWireframeColor(osg.Vec4f(0, 0, 1, 1))
	switch:addChild(xform)
	switch:addChild(scribe)
	scribe:addChild(xform)
	switch:setSingleChildOn(0)
	table.insert(Manipulables_Switches, switch)
	return switch
end

function moveAction(dt)
	local dragBtn, changeBtn
	if not inMETaL then
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
				-- turn OFF scribe for previously highlighted node
				Manipulables_Switches[activeObject]:setSingleChildOn(0)
				activeObject = activeObject + 1
				if activeObject > #Manipulables then
					activeObject = 1
				end
				-- turn ON scribe for previously highlighted node
				Manipulables_Switches[activeObject]:setSingleChildOn(1)
				-- print("Change button pressed: active object now #" .. activeObject .. " of " .. #Manipulables)
			end
			Actions.waitForRedraw()
		end
		local node = Manipulables[activeObject]
		local offset = node:getPosition() - wand.position
		while dragBtn.pressed do
			node:setPosition(wand.position + offset)
			node:setAttitude(wand.orientation)
			Actions.waitForRedraw()
		end
	end
end

Actions.addFrameAction(moveAction)