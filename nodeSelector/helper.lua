-- helper graph functions

function hasChildren(node)
	if node:getNumChildren() > 0 then
		return true
	else
		return false
	end
end

function printType(node)
	return osgLua.getTypeInfo(node).name
end

function isManipulatable2(node)
	local condition1 = osgLua.getTypeInfo(node).name == [[osg::PositionAttitudeTransform]]
	local condition2 = osgLua.getTypeInfo(node).name == [[osg::MatrixTransform]]
	local condition3 = osgLua.getTypeInfo(node).name == [[osg::Group]]
	-- local condition4 = osgLua.getTypeInfo(node).name == [[osgFX::Scribe]]
	return condition1 or condition2 or condition3 or condition4
end

function printGraph(group,rlevel)
	local rlevel = rlevel or "_"
	for i=1,group:getNumChildren(),1 do
		local child = group.Child[i]
		print(rlevel..printType(child))
		if isManipulatable2(child) then
			printGraph(child,rlevel.."_")
		end
	end
end
