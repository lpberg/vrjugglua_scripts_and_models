require("DebugAxes")
require("StockModels")
require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
--dofile(vrjLua.findInModelSearchPath("../movetools.lua"))
--vrjLua.appendToModelSearchPath(vrjLua.findInModelSearchPath("../models/"))

xform = Transform{
	Sphere{radius = .23},
}

RelativeTo.World:addChild(xform)
--



move_slow = function(xform,rate,x,y,z)

	local pos = xform:getPosition()
	local f = function()
		local dt = Actions.waitForRedraw()
		local goal = osg.Vec3d(pos:x()+x,pos:y()+y,pos:z()+ z)
		rate = rate or .005
		local steps = 1
		--for steps=1, 100, .005 do
		while true do 
			local currentPos = xform:getPosition()
			local newPos = (goal - pos) * dt*rate + currentPos
			xform:setPosition(newPos)
			dt = Actions.waitForRedraw()
			--steps = steps + rate
			if currentPos:x() > goal:x()  then break end
		end
	end
	return f
end


x = function()
	move_slow(xform,.5,2,1,-3)
	Actions.waitSeconds(2)
	move_slow(xform,.5,2,1,-3)
end







-- Actions.addFrameAction(x)
-- print(xform:getPosition():x(),xform:getPosition():y(),xform:getPosition():z())