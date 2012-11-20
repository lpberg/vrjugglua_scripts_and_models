require("Actions")
Transition_Effects = {
	shrink = function(node,duration)
		local duration = duration or 4
		if duration <= 0 then duration = 4 end
		local scaleRate = 1 / duration

		Actions.addFrameAction(
			function()
				while duration > 0 do
					local scale = duration * scaleRate
					node:setScale(osg.Vec3d(scale,scale,scale))
					duration = duration - Actions.waitForRedraw()
				end
			end
		)
	end,
	unshrink = function(node,duration,endsize)
		local duration = duration or 4
		if duration <= 0 then duration = 4 end
		local scaleRate = 1 / duration

		Actions.addFrameAction(
			function()
				while duration > 0 do
					local scale = 1-(duration * scaleRate)
					node:setScale(osg.Vec3d(scale,scale,scale))
					duration = duration - Actions.waitForRedraw()
				end
			end
		)
	end,
	fadein = function(node,duration)
		local CONSTANT_ALPHA = 0x8003
		local ONE_MINUS_CONSTANT_ALPHA = 0x8004
		
		local duration = duration or 4
		if duration <= 0 then duration = 4 end

		local state = node:getOrCreateStateSet()
		state:setRenderingHint(2) -- transparent bin

		local bf = osg.BlendFunc()
		bf:setFunction(CONSTANT_ALPHA, ONE_MINUS_CONSTANT_ALPHA)
		state:setAttributeAndModes(bf)

		local transparencyRate = 1 / duration
		local bc = osg.BlendColor(osg.Vec4(1.0, 1.0, 1.0, 1.0))
		state:setAttributeAndModes(bc)

		--this one is a frame action (its own thread action) because the node is already showing (switch) - visible
		Actions.addFrameAction(
			function()
				while duration > 0 do
					bc:setConstantColor(osg.Vec4(1.0, 1.0, 1.0, 1-(duration * transparencyRate)))
					state:setAttributeAndModes(bc)
					duration = duration - Actions.waitForRedraw()
				end
				state:setAttributeAndModes(osg.BlendFunc())
			end
		)
		
	end,
	fadeout = function(node,duration)
		local CONSTANT_ALPHA = 0x8003
		local ONE_MINUS_CONSTANT_ALPHA = 0x8004
		
		local duration = duration or 4
		if duration <= 0 then duration = 4 end

		local state = node:getOrCreateStateSet()
		state:setRenderingHint(2) -- transparent bin

		local bf = osg.BlendFunc()
		bf:setFunction(CONSTANT_ALPHA, ONE_MINUS_CONSTANT_ALPHA)
		state:setAttributeAndModes(bf)

		local transparencyRate = 1 / duration
		local bc = osg.BlendColor(osg.Vec4(1.0, 1.0, 1.0, 1.0))
		state:setAttributeAndModes(bc)
		
		--not adding as frame action above - we need this one to wait (not start its own thread action)
		while duration > 0 do
			bc:setConstantColor(osg.Vec4(1.0, 1.0, 1.0, duration * transparencyRate))
			state:setAttributeAndModes(bc)
			duration = duration - Actions.waitForRedraw()
		end 
		--state:setAttributeAndModes(osg.BlendFunc())
		
	end,
	fadeAllOut = function(xform)
		Transition_Effects.shrink(xform,.5)
		Transition_Effects.fadeout(xform,.25)
	end,

	fadeAllIn = function(xform)
		Transition_Effects.fadein(xform,.5)
		Transition_Effects.unshrink(xform,.25)
	end,
}


