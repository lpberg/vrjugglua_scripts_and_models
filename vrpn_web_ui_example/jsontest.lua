require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
vrjKernel.loadConfigFile(vrjLua.findInModelSearchPath([[json_vrpn.jconf]]))

local function textListener(actionFunction)
	strings = gadget.StringInterface("JSText")
	Actions.addFrameAction(function()
			while true do
				newData = strings.data
				if newData ~= "" then
					actionFunction(newData)
				end
				Actions.waitForRedraw()
			end
		end)
end

local function printNewDataValue()
	local function f(newData)
		print(newData)
	end
end


textListener(printNewDataValue())

local function analogListener(str)
	local input = gadget.AnalogInterface(str)
	Actions.addFrameAction(function()
			local last_value = ""
			while true do
				local newData = input.data
				if newData ~= nil and newData ~= last_value then
					print("new analog value recieved on "..str..": ", newData)
					last_value = newData
				end
				Actions.waitForRedraw()
			end
		end)
end

analogListener("JSAnalog1")
analogListener("JSAnalog2")


local function doWhen(condition, actionToTake)
	Actions.addFrameAction(function()
			while true do
				if condition() then
					actionToTake()
					Actions.waitForRedraw()
				else
					Actions.waitForRedraw()
				end
			end
		end)
end

function simplePrintFunction(mystr)
	local f = function()
		print(mystr)
	end
	return f
end

function buttonJustPressed(button)
	local f = function()
		return button.justPressed
	end
	return f
end

function buttonPressed(button)
	local f = function()
		return button.pressed
	end
	return f
end

doWhen(buttonPressed(gadget.DigitalInterface("JSButton1")), simplePrintFunction("button 1 is pressed!"))
doWhen(buttonJustPressed(gadget.DigitalInterface("JSButton0")), simplePrintFunction("button 0 was just pressed!"))