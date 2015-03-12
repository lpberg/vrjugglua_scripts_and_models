require("AddAppDirectory")
AddAppDirectory()

runfile[[proximityAction.lua]]

obj1 = Transform{
	position = {0,0,0},
	Sphere{radius=.124}
}

obj2 = Transform{
	position = {1,1,0},
	Sphere{radius=.124}
}

RelativeTo.World:addChild(obj1)
RelativeTo.World:addChild(obj2)

local function printHello() 
	print("Obj 1 and Obj 2 are now within 1.3 meters of each other!") 
end

proximityChecker(obj1,obj2,1.3,printHello)

--To test the function enter this into the testbed window
-- obj2:setPosition(Vec(0,1,0))