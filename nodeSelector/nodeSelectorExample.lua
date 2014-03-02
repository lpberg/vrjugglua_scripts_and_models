require("AddAppDirectory")
require("osgUtil")
AddAppDirectory()
runfile[[nodeSelector.lua]]
runfile[[helper.lua]]

op = osgUtil.Optimizer()

balls = Transform{
	Transform{
		Transform{
			Sphere{position = {-1, 0, 0},radius=.125},
		},
		Transform{
			Sphere{position = {-1, .5, 0},radius=.125},
		}
	},
	Transform{
		Transform{
			Transform{
				Sphere{position = {0, 0, 0},radius=.125},
			}
		}
	},
	Transform{
		Sphere{position = {1, 0, 0},radius=.125},
	},
	Transform{
		Sphere{position = {1.5, 0, 0},radius=.125},
	}
}

RelativeTo.World:addChild(balls)

printGraph(balls)
op:optimize(balls,osgUtil.Optimizer.OptimizationOptions.ALL_OPTIMIZATIONS)
print()
printGraph(balls)
-- ns = nodeSelector{
	-- parent = balls,
-- }

-- local isParentTopofSnake = ns:isTopOfSnake(ns.parent)
-- print("Should print false: ",isParentTopofSnake)
-- local isChild1TopofSnake = ns:isTopOfSnake(ns.parent.Child[1])
-- print("Should print false: ",isChild1TopofSnake)
-- local isChild2TopofSnake = ns:isTopOfSnake(ns.parent.Child[2])
-- print("Should print true: ",isChild2TopofSnake)
-- local isChild3TopofSnake = ns:isTopOfSnake(ns.parent.Child[3])
-- print("Should print true: ",isChild3TopofSnake)
-- local isChild4TopofSnake = ns:isTopOfSnake(ns.parent.Child[4])
-- print("Should print true: ",isChild4TopofSnake)
