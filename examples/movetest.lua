require("DebugAxes")
require("StockModels")
require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath("../movetools.lua"))
vrjLua.appendToModelSearchPath(vrjLua.findInModelSearchPath("../models/"))

matrix_xform_robot = osg.MatrixTransform()
matrix_xform_arm = osg.MatrixTransform()

roboArm = Transform{
	Model ([[arm.osg]]),
}
matrix_xform_arm:addChild(roboArm)

heightExtention = Transform {
	position = {-1,2.4,0},
	matrix_xform_arm,
}

matrix_xform_robot:addChild(heightExtention)  

roboBase = Transform{
	Model([[Robot Bottom.osg]]),
} 
matrix_xform_robot:addChild(roboBase)

robot = Transform{
	matrix_xform_robot,
}
RelativeTo.World:addChild(robot)  

moveRobot = function()
	local pos = robot:getPosition()
	local toLeft = Rotation.rotate(matrix_xform_robot,"y",90,40)
	local toRight = Rotation.rotate(matrix_xform_robot,"y",-90,40)
	local armDown = Rotation.rotate(matrix_xform_arm,"z",-45,40)
	local armUp = Rotation.rotate(matrix_xform_arm,"z",45,40)
	local slightXLeft = Transformation.move_slow(robot,.3,2,1,0)
	while true do
		toLeft()
		Actions.waitSeconds(.25)
		armDown()
		Actions.waitSeconds(.25)
		armUp()
		Actions.waitSeconds(.25)
		toRight()
		Actions.waitSeconds(.25)
		armDown()
		Actions.waitSeconds(.25)
		armUp()
		Actions.waitSeconds(.25)
		slightXLeft()
		print(robot:getPosition():x())
		Actions.waitSeconds(.25)
	end
end
--Actions.addFrameAction(moveRobot)



