require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
vrjKernel.loadConfigFile(vrjLua.findInModelSearchPath([[nunchuck.jconf]]))

x = gadget.AnalogInterface("WMNunchukJoystickX");
y = gadget.AnalogInterface("WMNunchukJoystickY");

--use .centered for values between -1 and 1
Actions.addFrameAction(function() 
    while true do
        print("x: "..x.centered)
        print("y: "..y.centered)
        Actions.waitForRedraw()
    end
end)

