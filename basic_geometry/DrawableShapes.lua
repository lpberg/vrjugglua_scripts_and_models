DrawableShapes = {

	RyanSphere = function(a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end

		local drbl = osg.ShapeDrawable(osg.Sphere(pos, a.radius or 1.0))
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
	Sphere = function(a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local sphere = osg.Sphere(pos, a.radius or 1.0)
		local drbl = osg.ShapeDrawable(sphere)
		local color = osg.Vec4(0,0,0,1)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
	Cylinder = function (a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local drbl = osg.ShapeDrawable(osg.Cylinder(pos, a.radius or 1.0, a.height or 1.0))
		local color = osg.Vec4(0,0,0,1)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
	CylinderFromHereToThere = function(a) 
		local midpoint = (a.here + a.there) * 0.5
		local myheight = (a.here-a.there):length()
		local xform = Transform{
			position = {midpoint:x(),midpoint:y(),midpoint:z()},
			DrawableShapes.Cylinder{height = myheight, color = a.color or {1,1,0,0}, radius = a.radius or .125},
		}
		local newVec = a.there - a.here
		local newQuat = osg.Quat()
		newQuat:makeRotate(osg.Vec3(0,0,1),osg.Vec3(newVec:x(),newVec:y(),newVec:z()))
		xform:setAttitude(newQuat)
		return xform
	end,
	Cube = function(a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local drbl = osg.ShapeDrawable(osg.Box(pos, a.width or 1.0))
		local color = osg.Vec4(0,0,0,0)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
	Box = function(a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local drbl = osg.ShapeDrawable(osg.Box(pos, a.width or 1.0,a.height or 1.0,a.depth or 1.0))
		local color = osg.Vec4(0,0,0,0)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
	Capsule = function(a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local drbl = osg.ShapeDrawable(osg.Capsule(pos, a.radius or 1.0,a.height or 1.0))
		local color = osg.Vec4(0,0,0,0)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
	Cone = function(a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local drbl = osg.ShapeDrawable(osg.Cone(pos, a.radius or 1.0,a.height or 1.0))
		local color = osg.Vec4(0,0,0,0)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
}