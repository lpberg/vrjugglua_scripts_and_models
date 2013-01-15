require("Actions")

local _createRotation = function(xform,axis,degree,custAxis)
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
end
local _DrawableShapes = {
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
}
local _colorset = {
		{(12*21)/255,(12*21)/255,(12*21)/255,0},
		{(11*21)/255,(11*21)/255,(11*21)/255,0},
		{(10*21)/255,(10*21)/255,(10*21)/255,0},
		{(9*21)/255,(9*21)/255,(9*21)/255,0},
		{(8*21)/255,(8*21)/255,(8*21)/255,0},
		{(7*21)/255,(7*21)/255,(7*21)/255,0},
		{(6*21)/255,(6*21)/255,(6*21)/255,0},
		{(5*21)/255,(5*21)/255,(5*21)/255,0},
		{(4*21)/255,(4*21)/255,(4*21)/255,0},
		{(3*21)/255,(3*21)/255,(3*21)/255,0},
		{(2*21)/255,(2*21)/255,(2*21)/255,0},
		{(1*21)/255,(1*21)/255,(1*21)/255,0},
		{0,0,0,0},
}

local _thickness = .5
local _distance = .75

local _vertObject = Transform{
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	_DrawableShapes.Capsule{position = {0,0,_distance}, radius = .10, height = _thickness, color=_colorset[1]}, --1
	_DrawableShapes.Capsule{position = {0,0,-_distance}, radius = .10, height = _thickness, color=_colorset[7]} --7
}
local _horizObject = Transform{
	orientation = AngleAxis(Degrees(90), Axis{0.0, 0.0, 1.0}),
	Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		_DrawableShapes.Capsule{position = {0,0,_distance}, radius = .10, height = _thickness, color=_colorset[10]}, --10
		_DrawableShapes.Capsule{position = {0,0,-_distance}, radius = .10, height = _thickness, color=_colorset[4]} --4
	}
}
local _fortyfive1Object = Transform{
	orientation = AngleAxis(Degrees(30), Axis{0.0, 0.0, 1.0}),
	Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		_DrawableShapes.Capsule{position = {0,0,_distance}, radius = .10, height = _thickness, color=_colorset[12]}, --12
		_DrawableShapes.Capsule{position = {0,0,-_distance}, radius = .10, height = _thickness, color=_colorset[6]} --6
	}
}
local _fortyfive2Object = Transform{
	orientation = AngleAxis(Degrees(60), Axis{0.0, 0.0, 1.0}),
	Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		_DrawableShapes.Capsule{position = {0,0,_distance}, radius = .10, height = _thickness, color=_colorset[11]}, --11
		_DrawableShapes.Capsule{position = {0,0,-_distance}, radius = .10, height = _thickness, color=_colorset[5]} --5
	}
}
local _fortyfive3Object = Transform{
	orientation = AngleAxis(Degrees(-30), Axis{0.0, 0.0, 1.0}),
	Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		_DrawableShapes.Capsule{position = {0,0,_distance}, radius = .10, height = _thickness, color=_colorset[2]}, --3
		_DrawableShapes.Capsule{position = {0,0,-_distance}, radius = .10, height = _thickness, color=_colorset[8]} --9 
	}
}
local _fortyfive4Object = Transform{
	orientation = AngleAxis(Degrees(-60), Axis{0.0, 0.0, 1.0}),
	Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		_DrawableShapes.Capsule{position = {0,0,_distance}, radius = .10, height = _thickness, color=_colorset[3]}, --2
		_DrawableShapes.Capsule{position = {0,0,-_distance}, radius = .10, height = _thickness, color=_colorset[9]} --8
	}
}
local _mainObject = Transform{
	scale = .25,
	position = {1,1,0},
	_vertObject,
	_horizObject,
	_fortyfive1Object,
	_fortyfive2Object,
	_fortyfive3Object,
	_fortyfive4Object,
}
startLoading = function()
	RelativeTo.World:addChild(_mainObject)
	Actions.addFrameAction(_createRotation(_mainObject,"z",175))
end
stopLoading = function()
	RelativeTo.World:removeChild(_mainObject)
	Actions.removeFrameAction(_createRotation(_mainObject,"z",175))
end

--USE EXAMPLE:
startLoading() -- call before code being loaded (if code takes a while)
--CODE TO LOAD HERE
stopLoading() -- remove animation/xform when app is ready (finished loading)

