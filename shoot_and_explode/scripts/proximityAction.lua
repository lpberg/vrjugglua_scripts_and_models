function interObjectDistance(obj1,obj2)
	return (obj1:getPosition() - obj2:getPosition()):length()
end

function proximityChecker(obj1,obj2,proximity,functionToExecute)
	if obj1 and obj2 then
		Actions.addFrameAction(function()
			local distanceBetweenObjects = interObjectDistance(obj1,obj2)
			while distanceBetweenObjects > proximity do
				if obj1 and obj2 then
					distanceBetweenObjects = interObjectDistance(obj1,obj2)
				end
				Actions.waitForRedraw()
			end
			functionToExecute()
		end)
	end
end