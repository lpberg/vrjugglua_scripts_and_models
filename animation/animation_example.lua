require("Actions")
require("getScriptFilename")

vrjLua.appendToModelSearchPath(getScriptFilename())

dofile(vrjLua.findInModelSearchPath([[../MoveTools.lua]]))

xform = Transform{Sphere{radius=.125}}

makeDoAll_ONCE = function(funcs)
	return function()
		for _,func in ipairs(funcs) do
			func()
			Actions.waitForRedraw()
		end
	end
end

makeDoAll_REPEAT = function(funcs)
	return function()
		while true do
			for _,func in ipairs(funcs) do
				func()
				Actions.waitForRedraw()
			end
		end
	end
end


RelativeTo.World:addChild(xform)

one = Transformation.move_slow(xform,.75,-1.5,0,0)
two = Transformation.move_slow(xform,.75,0,0,-1.5)
three = Transformation.move_slow(xform,.75,1.5,0,0)
four = Transformation.move_slow(xform,.75,0,0,1.5)


myfuncs = {one,two,three,four}

Actions.addFrameAction(makeDoAll_ONCE(myfuncs))
-- Actions.addFrameAction(makeDoAll_REPEAT(myfuncs))



