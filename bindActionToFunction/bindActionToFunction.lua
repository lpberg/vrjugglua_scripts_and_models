--bindActionToFunction - interface for connecting button presses (and other actions) to function calls 

function bindActionToFunction(condition, actionToTake)
	Actions.addFrameAction(function()
		while true do
			if condition() then
				actionToTake()
			end
			Actions.waitForRedraw()
		end
	end)
end

function buttonPressed(button)
	local f = function()
		return button.pressed
	end
	return f
end

function buttonJustPressed(button)
	local f = function()
		return button.justPressed
	end
	return f
end

function notButtonPressed(button)
	local f = function()
		return not button.pressed
	end
	return f
end

function wordIsRecognized(data, word)
	local f = function()
		return data == word
	end
	return f
end