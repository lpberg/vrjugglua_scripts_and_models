--See http://www.lua.org/pil/16.html and http://www.lua.org/pil/16.1.html for more information
require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[drawFunctions.lua]]))
dofile(vrjLua.findInModelSearchPath([[graphFunctions.lua]]))
dofile(vrjLua.findInModelSearchPath([[holodeck/loadHolodeck.lua]]))


strechBtn = gadget.DigitalInterface("VJButton1")
dragBtn = gadget.DigitalInterface("VJButton2")
spinBtn = gadget.DigitalInterface("WMButtonMinus")

device = gadget.PositionInterface("VJWand")
hand = gadget.PositionInterface("VJHand")



g = Graph()
g:addNode(Node(osg.Vec3d(0,0,0),.125))
g:addNode(Node(osg.Vec3d(1,0,0),.125))
g:addNode(Node(osg.Vec3d(-1,0,0),.125))
g:addNode(Node(osg.Vec3d(0,0,-1),.125))
g:addNode(Node(osg.Vec3d(0,0,1),.125))
g:addNode(Node(osg.Vec3d(0,1,0),.125))
g:addNode(Node(osg.Vec3d(0,-1,0),.125))
g:addEdge(g:getNode(0),g:getNode(1))
g:addEdge(g:getNode(1),g:getNode(2))
g:addEdge(g:getNode(2),g:getNode(3))
g:addEdge(g:getNode(3),g:getNode(4))
g:addEdge(g:getNode(4),g:getNode(5))
g:addEdge(g:getNode(5),g:getNode(6))
RelativeTo.World:addChild(g.xform)

-- stateSet = g.xform:getOrCreateStateSet()
-- stateSet:setMode(0x0B50,osg.StateAttribute.Values.OFF)

Actions.addFrameAction(function()
	while true do
		while not dragBtn.pressed do
			Actions.waitForRedraw()
		end
		print("button pressed")
		while dragBtn.pressed do
			local startPos = device.position
			Actions.waitForRedraw()
			local newVec = device.position
			g:setPosition(g.xform:getPosition()+(-2*(startPos-newVec)))
			Actions.waitForRedraw()
		end
		
	end
end)


Actions.addFrameAction(function()
	while true do
		while not strechBtn.pressed do
			Actions.waitForRedraw()
		end
		
		local currentScale = g:getScale()
		local initDevicePos = device.position
		--this will be hand target
		local initHandPos =  hand.position
		local initDist = (initHandPos-initDevicePos):length()
		
		while strechBtn.pressed do
			local currentWandPos = device.position
			local currentHandPos = hand.position
			local newVecLength = (currentHandPos-currentWandPos):length()
			newScale = (newVecLength/(initDist/currentScale))
			g:Scale(newScale,newScale,newScale)
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
	--local wandInit = device.position
	while true do
		while not spinBtn.pressed do
			dt = Actions.waitForRedraw()
		end
		while spinBtn.pressed do
			local degree = calculateRot(device.position,hand.position)
			angle = angle + degree * dt
			q:makeRotate(Degrees(angle),  Axis{0,0,1})
			g.xform:setAttitude(q)
			dt = Actions.waitForRedraw()
		end
	end
end

Actions.addFrameAction(rotFunc)









