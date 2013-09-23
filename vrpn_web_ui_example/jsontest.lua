require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
vrjKernel.loadConfigFile(vrjLua.findInModelSearchPath([[json_vrpn.jconf]]))

local function recieveString()
	strings = gadget.StringInterface("JSText")
	Actions.addFrameAction(function()
			while true do
				newData = strings.data
				if newData ~= "" then
					print("New String Recieved: ", newData)
				end
				Actions.waitForRedraw()
			end
		end)
end

recieveString()

local function recieveAnalog0()
	local input = gadget.AnalogInterface("JSAnalog0")
	Actions.addFrameAction(function()
			local last_value = ""
			while true do
				local newData = input.data
				if newData ~= nil and newData ~= last_value then
					print("New Analog Value Recieved on JSAnalog0: ", newData)
					last_value = newData
				end
				Actions.waitForRedraw()
			end
		end)
end
recieveAnalog0()

local function recieveAnalog10()
	local input = gadget.AnalogInterface("JSAnalog10")
	Actions.addFrameAction(function()
			local last_value = ""
			while true do
				local newData = input.data
				if newData ~= nil and newData ~= last_value then
					print("New Analog Value Recieved on JSAnalog10: ", newData)
					last_value = newData
				end
				Actions.waitForRedraw()
			end
		end)
end
recieveAnalog10()


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