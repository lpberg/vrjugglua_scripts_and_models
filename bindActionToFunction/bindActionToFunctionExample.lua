--example of bindActionToFunction.lua
require("AddAppDirectory")
AddAppDirectory()
runfile[[bindActionToFunction.lua]]

local function printHello()
	print("Hello")
end

local function printString(str)
	print(str)
end

-- function without paramters (pass the function by name without parens):
bindActionToFunction(buttonJustPressed(gadget.DigitalInterface("VJButton1")), printHello)

-- function with paramters (pass an anonymous function):
bindActionToFunction(buttonJustPressed(gadget.DigitalInterface("VJButton2")), function() printString("GoodBye") end)

--[[

OTHER ACTION OPTIONS
buttonPressed(button)
buttonJustPressed(button)
notButtonPressed(button)
wordIsRecognized(data, word)

]]--
