require("AddAppDirectory")
AddAppDirectory()
--load in a configuration file to talk to the voice server
vrjKernel.loadConfigFile(vrjLua.findInModelSearchPath([[VRPNText.jconf]]))

Actions.addFrameAction(function()
	local speech_device = gadget.StringInterface("KinectProxy")
	while true do
		if speech_device.data == "computer" then
			print("You said computer!")
		elseif speech_device.data == "banana" then
			print("You said banana!")
		end
		Actions.waitForRedraw()
	end
end)

