require("gldef")
require("AddAppDirectory")
AddAppDirectory()

local function createExplosionModel(pos)
	local xform = Transform{
		position = pos,
		scale = math.random(3,8),
		Model[[explode1.ive]],
		Transform{
			Model[[explode2.ive]],
			scale = .15
		}
	}
	xform:getOrCreateStateSet():setMode(0x0B50,osg.StateAttribute.Values.OFF)
	return xform
end

local function explodeObject(position, durationInSeconds)
	Actions.addFrameAction(
		function()			
			local dt = Actions.waitForRedraw()
			local model = createExplosionModel(position)
			RelativeTo.World:addChild(model)
			local curr_scale = 0.01
			local dest_scale = model:getScale():x()
			local scale_step = (dest_scale / durationInSeconds) * dt
			while curr_scale < dest_scale do
				curr_scale = curr_scale + scale_step
				model:setScale(osg.Vec3d(curr_scale,curr_scale,curr_scale))
				Actions.waitForRedraw()
			end
			RelativeTo.World:removeChild(model)
		end)
end

function explode(pos)
	for var=1,math.random(1,3),1 do
		explodeObject(pos, math.random(700,1000)/1000) 
    end
end
