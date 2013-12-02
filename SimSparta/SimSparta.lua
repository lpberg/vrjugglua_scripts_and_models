require("osgFX")
local SimSpartaIndex = { isSimSparta = true }
local SimSpartaMT = {__index = SimSpartaIndex}

function SimSpartaIndex:_setMatrix(xform, mat)
	if osgLua.getTypeInfo(xform).name == [[osg::PositionAttitudeTransform]] then
		xform:setPosition(mat:getTrans())
		xform:setAttitude(mat:getRotate())
	else
		xform:setMatrix(mat)
	end
end

function SimSpartaIndex:_getMatrix(xform)
	if osgLua.getTypeInfo(xform).name == [[osg::PositionAttitudeTransform]] then
		mat = osg.Matrixd()
		mat:setTrans(xform:getPosition())
		mat:setRotate(xform:getAttitude())
		return mat
	elseif osgLua.getTypeInfo(xform).name == [[osg::MatrixTransform]] then
		return xform:getMatrix()
	end
end

function SimSpartaIndex:_getPosition(xform)
	mat = self:_getMatrix(xform)
	return mat:getTrans()
end

function SimSpartaIndex:_wrapTransformInBlueScribeSwitch(xform)
	local switch = osg.Switch()
	local scribe = osgFX.Scribe()
	scribe:setWireframeColor(osg.Vec4f(0, 0, 1, 1))
	switch:addChild(xform)
	switch:addChild(scribe)
	scribe:addChild(xform)
	switch:setSingleChildOn(0)
	return switch
end

function SimSpartaIndex:_wrapTransformInMatrixTransform(xform)
	MT = osg.MatrixTransform()
	MT:addChild(xform)
	return MT
end

function SimSpartaIndex:createManipulatableObject(xform)
	assert(osgLua.getTypeInfo(xform).name == [[osg::MatrixTransform]] or osgLua.getTypeInfo(xform).name == [[osg::PositionAttitudeTransform]], "must pass PAT or MT")
	local xform_asScribeSwitch = self:_wrapTransformInBlueScribeSwitch(xform)
	table.insert(self.Manipulables, xform)
	table.insert(self.initial_matricies, self:_getMatrix(xform))
	table.insert(self.Manipulables_Switches, xform_asScribeSwitch)
	self.parent:addChild(xform_asScribeSwitch)
	return
end


function SimSpartaIndex:_getWandInWorld()
	return self.wand.matrix * RelativeTo.World:getInverseMatrix()
end

function SimSpartaIndex:_getClosestObject()
	self.Manipulables_Switches[self.activeObject]:setSingleChildOn(0)
	local minDist = 100000
	local wandPos = self:_getWandInWorld():getTrans()
	for i = 1, #self.Manipulables, 1 do
		local manipulablePos = self:_getPosition(self.Manipulables[i])
		local dist = (wandPos - manipulablePos):length()
		if dist < minDist then
			minDist = dist
			self.activeObject = i
		end
	end
	self.Manipulables_Switches[self.activeObject]:setSingleChildOn(1)
end

function SimSpartaIndex:_selectNextObject()
	--turn off scribe effect current node
	self.Manipulables_Switches[self.activeObject]:setSingleChildOn(0)
	--set active object index increase by one
	self.activeObject = self.activeObject + 1
	--if obect index greater than number of objects reset to first
	if self.activeObject > #self.Manipulables then
		self.activeObject = 1
	end
	--set active object scribe on
	self.Manipulables_Switches[self.activeObject]:setSingleChildOn(1)
end

function SimSpartaIndex:_selectPreviousObject()
	--turn off scribe effect current node
	self.Manipulables_Switches[self.activeObject]:setSingleChildOn(0)
	--set active object index increase by one
	self.activeObject = self.activeObject - 1
	--if obect index greater than number of objects reset to first
	if self.activeObject < 1 then
		self.activeObject = #self.Manipulables
	end
	--set active object scribe on
	self.Manipulables_Switches[self.activeObject]:setSingleChildOn(1)
end

function SimSpartaIndex:_resetPart()
	local node = self.Manipulables[self.activeObject]
	self:_setMatrix(node, self.initial_matricies[self.activeObject])
end

function SimSpartaIndex:_checkCycleButtons()
	if self.nextBtn.justPressed then
		self:_selectNextObject()
	end
	if self.prevBtn ~= nil and self.prevBtn.justPressed then
		self:_selectPreviousObject()
	end
	if self.resetBtn ~= nil and self.resetBtn.justPressed then
		self:_resetPart()
	end
end

function SimSpartaIndex:addFrameActions()
	local function selectionFunc()
		if self.cycleThroughParts then
			self:_checkCycleButtons()
		else
			self:_getClosestObject()
		end
	end
	Actions.addFrameAction(
		function()
			local nodeRelativeToWand = ""
			local node = ""
			while true do
				selectionFunc()
				if self.dragBtn.justPressed then
					node = self.Manipulables[self.activeObject]
					local wandpos = self:_getWandInWorld()
					nodeRelativeToWand = self:_getMatrix(node) * osg.Matrixd.inverse(wandpos)
				end
				if self.dragBtn.pressed then
					local new_mat = nodeRelativeToWand * self:_getWandInWorld()
					self:_setMatrix(node, new_mat)
				end
				Actions.waitForRedraw()
			end
		end
	)
end

SimSparta = function(item)
	--must have a drag button to manipulate geometry
	assert(item.dragBtn, "SimSparta: must pass dragBtn for manipulating objects")
	--if cycleThroughParts is true (not false) then make sure the other buttons are provided
	if item.cycleThroughParts ~= false then
		item.cycleThroughParts = true
		assert(item.nextBtn, "SimSparta: must pass nextBtn for manipulating objects")
		assert(item.prevBtn, "SimSparta: must pass prevBtn for manipulating objects")
	end
	--assume parent is RelativeTo.World if nothing passed
	item.parent = item.parent or RelativeTo.World
	--assume wand is VJWand unless passed
	item.wand = item.wand or gadget.PositionInterface("VJWand")
	--create internal data tables
	item.Manipulables = {}
	item.initial_matricies = {}
	item.Manipulables_Switches = {}
	--set active item index to be first item in table
	item.activeObject = 1
	--we must set the metatable - so it can find its methods
	setmetatable(item, SimSpartaMT)
	--add any passed nodes to data structures
	for _, xform in ipairs(item) do
		item:createManipulatableObject(xform)
	end
	--begin frame action
	item:addFrameActions()
	--return 'instance' of SimSparta
	return item
end