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
spinBtn2 = gadget.DigitalInterface("WMButtonPlus")

device = gadget.PositionInterface("VJWand")
hand = gadget.PositionInterface("VJHand")



g = Graph()

for i = 1, 20, 1 do
	local x = math.random(-5,5)
	local y = math.random(-5,5)
	local z = math.random(-5,5)
	g:addNode(Node(osg.Vec3d(x,y,z),.125))
end
	
for i = 1, 20, 1 do
	local fromNode = math.random(19)
	local toNode = math.random(19)
	if fromNode ~= toNode then
		g:addEdge(g:getNode(fromNode),g:getNode(toNode))
	end
end

RelativeTo.World:addChild(g.xform)

stateSet = g.xform:getOrCreateStateSet()
stateSet:setMode(0x0B50,osg.StateAttribute.Values.OFF)

Actions.addFrameAction(function()
	while true do
		while not dragBtn.pressed do
			Actions.waitForRedraw()
		end
		while dragBtn.pressed do
			local startPos = device.position
			Actions.waitForRedraw()
			local newVec = device.position
			g:setPosition(g.xform:getPosition()+(-3*(startPos-newVec)))
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


spinFunc = function(dt) 
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

Actions.addFrameAction(spinFunc)



spinFunc2 = function(dt) 
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
	while true do
		while not spinBtn2.pressed do
			dt = Actions.waitForRedraw()
		end
		while spinBtn2.pressed do
			local degree = calculateRot(device.position,hand.position)
			angle = angle + degree * dt
			q:makeRotate(Degrees(angle),  Axis{0,1,0})
			g.xform:setAttitude(q)
			dt = Actions.waitForRedraw()
		end
	end
end

Actions.addFrameAction(spinFunc2)






