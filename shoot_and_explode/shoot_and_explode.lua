require("gldef")
require("AddAppDirectory")
AddAppDirectory()

--include proximityAction and explosion lua files (for externally defined functions)
runfile[[scripts/proximityAction.lua]]
runfile[[scripts/explosion.lua]]
runfile[[scripts/PlaySound.lua]]

wand = gadget.PositionInterface("VJWand")

--set up sound files
blasterSound = SoundWav(vrjLua.findInModelSearchPath([[sounds/blast2.wav]]))
blasterSound.retriggerable = true
explodeSound = SoundWav(vrjLua.findInModelSearchPath([[sounds/explode.wav]]))
explodeSound.retriggerable = true
blasterSound:setVolume(.2)


local obj1 = Transform{
	position = {0,0,-2},
	Sphere{radius=.124}
}

local obj2 = Transform{
	position = {1,1,-2},
	Sphere{radius=.124}
}

--define a table called "shootable_objects" and list our objects we want to be shootable
local shootable_objects = {obj1,obj2}

--add objects to the virtual world
RelativeTo.World:addChild(obj1)
RelativeTo.World:addChild(obj2)


local function wandPosInWorld()
	return RelativeTo.World:getInverseMatrix():preMult(wand.position)
end

local function removeObjectFromShootableObjectsTable(obj)
	local idx = nil
	for index,value in ipairs(shootable_objects) do 
        if value == obj then 
			idx = index 
		end
    end
	table.remove(shootable_objects,idx)
end
	
local function getNewExplodeFunction(object)
	local pos = object:getPosition()
	function r() 
		explodeSound:trigger(1)
		explode{pos:x(),pos:y(),pos:z()} 
		object:getParent(0):removeChild(object)
		removeObjectFromShootableObjectsTable(object)
	end
	return r
end

local function createActionFrameForEachShootableObject(laser)
	for _, object in ipairs(shootable_objects) do
		proximity = object:getBound():radius()
		proximityChecker(laser,object,proximity,getNewExplodeFunction(object))
	end
end

local function createLaser()
	local laser = Transform{
		position = {wandPosInWorld():x(), wandPosInWorld():y(), wandPosInWorld():z()},
		Transform{
			orientation = AngleAxis(Degrees(90), Axis{1,0,0}),
			scale = .03,
			Model[[models/laser.ive]],
		}
	}
	laser:setScale(Vec(.3,.3,.5)) --make laser thinner
	laser:setAttitude(wand.orientation)
	laser:getOrCreateStateSet():setMode(0x0B50,osg.StateAttribute.Values.OFF) --turns off lighting for laser xform
	return laser
end

local function createProjectileMotionActionFrame(xform,scale,gravity)
	Actions.addFrameAction(
		function()			
			local velocity_x = scale * wand.forwardVector:x()
			local velocity_y = scale * wand.forwardVector:y()
			local velocity_z = scale * wand.forwardVector:z()
			dt = Actions.waitForRedraw()
			while true do
				current_position = xform:getPosition()
				next_x = current_position:x()+velocity_x*dt
				next_y = current_position:y()+velocity_y*dt
				next_z = current_position:z()+velocity_z*dt
				velocity_y = velocity_y - gravity*dt     
				next_position = Vec(next_x,next_y,next_z)
				xform:setPosition(next_position)
				dt = Actions.waitForRedraw()
			end
		end)
end

local function enableShootableObjects()
	if shootable_objects then
		Actions.addFrameAction(
			function()
				local trigger = gadget.DigitalInterface("VJButton2")
				while true do
					while not trigger.justPressed do
						Actions.waitForRedraw()
					end
					projectile = createLaser()
					RelativeTo.World:addChild(projectile)
					blasterSound:trigger(1)
					createProjectileMotionActionFrame(projectile,5,0)
					createActionFrameForEachShootableObject(projectile)
					Actions.waitForRedraw()
				end
			end
		)
	else 
		print("must define a table of shootable transforms, e.g. ")
	end
end

enableShootableObjects()
