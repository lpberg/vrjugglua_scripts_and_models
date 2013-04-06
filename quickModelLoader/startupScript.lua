dofile([[X:\Users\lpberg\src\vrjugglua_scripts_and_models\useful_tools.lua]])
dofile([[X:\Users\lpberg\src\vrjugglua_scripts_and_models\SimSparta\SimSparta.lua]])

loadBasicFactoryWithBasicLighting()
local models = {}
local global_position = {2,1.5,1.5}

local loadOSGsAndIves = function()
	for i,v in pairs(arg) do
		if string.find(v,".osg") or string.find(v,".ive") then
			model = Transform{Model(v)}
			model_xform = Transform{position = global_position, model}
			table.insert(models,model)
			changeTransformColor(model_xform,getRandomColor())
			RelativeTo.World:addChild(createManipulatableObject(model_xform))
		end
	end
end
loadOSGsAndIves()

--set up buttons to change which object is "selected"
nextBtn = gadget.DigitalInterface("WMButtonRight")
prevBtn = gadget.DigitalInterface("WMButtonLeft")
--set up button to move / drag object about scene
dragBtn = gadget.DigitalInterface("WMButtonB")

SimSparta(dragBtn,changeBtn,prevBtn)

-- add frame action for scaling objects 
Actions.addFrameAction(
	function()
		increaseBtn = gadget.DigitalInterface("WMButtonPlus")
		decreaseBtn = gadget.DigitalInterface("WMButtonMinus")
		while true do
			if increaseBtn.justPressed then
				for _,v in ipairs(models) do
					scaleTransform(v,v:getScale():x()*1.05)
				end
			end
			if decreaseBtn.justPressed then
				for _,v in ipairs(models) do
					scaleTransform(v,v:getScale():x()*0.95)
				end
			end
			Actions.waitForRedraw()
		end
	end)
