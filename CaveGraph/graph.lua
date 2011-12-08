--See http://www.lua.org/pil/16.html and http://www.lua.org/pil/16.1.html for more information
require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[drawFunctions.lua]]))
dofile(vrjLua.findInModelSearchPath([[drawFunctions.lua]]))
dofile(vrjLua.findInModelSearchPath([[graphFunctions.lua]]))


drawBtn = gadget.DigitalInterface("VJButton2")
device = gadget.PositionInterface("VJWand")

g = Graph()
node0 = Node(osg.Vec3d(0,0,0),.125)
node1 = Node(osg.Vec3d(1,0,0),.125)
g:addNode(node0)
g:addNode(node1)
g:addNode(Node(osg.Vec3d(-1,0,0),.125))
g:addNode(Node(osg.Vec3d(0,0,-1),.125))
g:addNode(Node(osg.Vec3d(0,0,1),.125))
g:addNode(Node(osg.Vec3d(0,1,0),.125))
g:addNode(Node(osg.Vec3d(0,-1,0),.125))
g:addEdge(node0,node1)
RelativeTo.World:addChild(g.xform)

Actions.addFrameAction(function()
	while true do
		while not drawBtn.pressed do
			Actions.waitForRedraw()
		end
		local initDevicePos = device.position
		local initHandPos =  osg.Vec3d(initDevicePos:x()-.5,initDevicePos:y(),initDevicePos:z())
		local initDist = (initHandPos-initDevicePos):length()
		while drawBtn.pressed do
			local currentPos = device.position
			local newVecLength = (initHandPos-currentPos):length()
			print(newVecLength)
			if (newVecLength > initDist) then
				g.scale = g.scale + .07
			elseif (newVecLength < initDist) then
				g.scale = g.scale - 0.7
			else
				g.scale = g.scale
			end 
			g:Scale(g.scale,g.scale,g.scale)
			Actions.waitForRedraw()
		end
	end
end)


rotFunc = function(dt) 
	local calculateRot = function(aPos,bPos)
		local deltaX = aPos:x() - bPos:x()
		local deltaY = aPos:y() - bPos:y()
		local sign
		if deltaY ~= 0 then sign = (deltaY/math.abs(deltaY)) or 1 else sign = 0 end
		local forceFactorY = 10
		local forceFactorX = 10
		local force = math.abs(deltaY)*sign*forceFactorX*forceFactorY*(1/math.abs(deltaX))
		return force
	end

	local angle = 0
	local q = osg.Quat()
	local wandInit = device.position
	while true do
		while not drawBtn.pressed do
			dt = Actions.waitForRedraw()
		end
		while drawBtn.pressed do
			local degree = calculateRot(device.position,wandInit)
			angle = angle + degree * dt
			q:makeRotate(Degrees(angle),  Axis{0,1,0})
			g.xform:setAttitude(q)
			dt = Actions.waitForRedraw()
		end
	end
end

--Actions.addFrameAction(rotFunc)









