require("Actions")
require("TransparentGroup")
require("Text")

--helper function below
local function doFadeOut(node, duration, outtime)
	f = function()
		local state = node:getOrCreateStateSet()
		state:setRenderingHint(2) -- transparent bin
		local bf = osg.BlendFunc()
		bf:setFunction(0x8003, 0x8004)
		state:setAttributeAndModes(bf)
		local transparencyRate = 1 / outtime
		local bc = osg.BlendColor(osg.Vec4(1.0, 1.0, 1.0, 1.0))
		state:setAttributeAndModes(bc)
		while duration > 0 do
			if duration < outtime then
				bc:setConstantColor(osg.Vec4(1.0, 1.0, 1.0, duration * transparencyRate))
				state:setAttributeAndModes(bc)
			end
			duration = duration - Actions.waitForRedraw()
		end
	end
	return f
end

local textGroup = osg.Group()

function setHelpText(text, duration)
	local duration = duration or 5
	textGroup:removeChildren(0, textGroup:getNumChildren())
	new_text = TextGeode{
		text,
		color = osg.Vec4(1.0, 1.0, 1.0, 1.0), --blue text
		position = {0, 2, 0},
		font = Font("Droid"),
		lineHeight = 0.25
	}

	text_xform = Transform{new_text}

	textGroup:addChild(text_xform)

	Actions.addFrameAction(doFadeOut(text_xform, duration, 1))

end

RelativeTo.Room:addChild(textGroup)


--usage:
setHelpText("Alert: a message!", optional_duration_paramerter)




