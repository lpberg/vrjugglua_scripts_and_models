dofile([[X:\Users\lpberg\src\vrjugglua_scripts_and_models\useful_tools.lua]])
dofile([[X:\Users\lpberg\src\vrjugglua_scripts_and_models\simSparta.lua]])

loadBasicFactoryWithBasicLighting()

local main_xform = Transform{
	position = {1,1,1},
}

local loadOSGsAndIves = function()
	for i,v in pairs(arg) do
		if string.find(v,".osg") or string.find(v,".ive") then
			model_xform = Transform{Model(v)}
			changeTransformColor(model_xform,getRandomColor())
			main_xform:addChild(createManipulatableObject(model_xform))
		end
	end
	RelativeTo.World:addChild(createManipulatableObject(main_xform))
end

loadOSGsAndIves()

--add frame action for scaling objects 
Actions.addFrameAction(
	function()
		increaseBtn = gadget.DigitalInterface("WMButtonPlus")
		decreaseBtn = gadget.DigitalInterface("WMButtonMinus")
		while true do
			if increaseBtn.justPressed then
				scaleTransform(main_xform,main_xform:getScale():x()*1.05)
			end
			if decreaseBtn.justPressed then
				scaleTransform(main_xform,main_xform:getScale():x()*.95)
			end
			Actions.waitForRedraw()
		end
	end)
-- 