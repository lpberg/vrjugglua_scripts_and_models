--helper functions for creating nativation frame actions

function getHeadPositionInWorld()
	local head = gadget.PositionInterface("VJHead")
	return RelativeTo.World:getInverseMatrix():preMult(head.position)
end

function translateWorld(x, y, z)
	RelativeTo.World:postMult(osg.Matrixd.translate(x, y, z))
end

function computeRotationAboutPoint(pointVec,rotation)
	local deltaMatrix = osg.Matrixd()
	deltaMatrix:preMult(osg.Matrixd.translate(pointVec))
	deltaMatrix:preMult(osg.Matrixd.rotate(rotation))
	deltaMatrix:preMult(osg.Matrixd.translate(-pointVec))
	return deltaMatrix
end

function rotateWorldAboutPoint(pointVec, rotation)
	local deltamatrix = computeRotationAboutPoint(pointVec,rotation)
	RelativeTo.World:preMult(deltamatrix)
end

function dropUserToGround()
	local world_height = RelativeTo.World:getMatrix():getTrans():y()
	RelativeTo.World:preMult(osg.Matrixd.translate(0, -world_height, 0))
end