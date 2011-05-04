Rotation = {
	createRotation = function(xform,axis,degree,custAxis)
		if axis == nil and custAxis then
			A = custAxis
		else
			A = {x=0,y=0,z=0}
			if A[axis] == nil then 
				error("error: second argument must be x,y, or z", 2)
			end
			A[axis] = 1
		end
		local theAxis = Axis{A.x,A.y,A.z}
		local f = function(dt) 
				local angle = 0
				local q = osg.Quat()
				while true do
					angle = angle + degree * dt
					q:makeRotate(Degrees(angle), theAxis)
					xform:setAttitude(q)
					dt = Actions.waitForRedraw()
				end
			end
		return f
	end,
}
function _createTransformation(xform,upper_bound,lower_bound,rate, get, set)
	assert(lower_bound<upper_bound,"_createTransformation: assert failed: Invalid upper & lower bounds")
	local f = function()
		local dt = Actions.waitForRedraw()
		local pos_edit = get(xform)
		local upper = pos_edit + upper_bound
		local lower = pos_edit + lower_bound
	
		while true do		
			-- Go up to upper_bound
			while pos_edit < upper do
				pos_edit = pos_edit + dt * rate
				set(xform, pos_edit)
				dt = Actions.waitForRedraw()
			end
			-- Go all the way down to lower_bound
			while pos_edit > lower do
				pos_edit = pos_edit - dt * rate
				set(xform, pos_edit)
				dt = Actions.waitForRedraw()
			end
		end
	end
	return f
end
Transformation = {
	createTransformationX = function(xform,upper_bound,lower_bound,rate)
		local function getter(xform)
			return xform:getPosition():x()
		end
		local function setter(xform, newval)
			local pos = xform:getPosition()
			xform:setPosition(osg.Vec3d(newval, pos:y(), pos:z()))
		end
		return _createTransformation(xform,upper_bound,lower_bound,rate,getter,setter)		
	end,
	createTransformationY = function(xform,upper_bound,lower_bound,rate)
		local function getter(xform)
			return xform:getPosition():y()
		end
		local function setter(xform, newval)
			local pos = xform:getPosition()
			xform:setPosition(osg.Vec3d(pos:x(), newval, pos:z()))
		end
		return _createTransformation(xform,upper_bound,lower_bound,rate,getter,setter)		
	end,
	createTransformationZ = function(xform,upper_bound,lower_bound,rate)
		local function getter(xform)
			return xform:getPosition():z()
		end
		local function setter(xform, newval)
			local pos = xform:getPosition()
			xform:setPosition(osg.Vec3d(pos:x(), pos:z(), newval))
		end
		return _createTransformation(xform,upper_bound,lower_bound,rate,getter,setter)		
	end,
}

