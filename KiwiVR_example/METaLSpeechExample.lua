require("AddAppDirectory")
AddAppDirectory()
runfile[[kiwiVRConfigCreator.lua]]

--load in a configuration file to talk to the voice server
--? - why do we have to load both, shouldn't launcher take care of one?
vrjKernel.loadConfigFile(vrjLua.findInModelSearchPath([[VRPNText.jconf]]))
vrjKernel.loadConfigFile(vrjLua.findInModelSearchPath([[s:/jconf30/METaL.tracked.stereo.reordered.withwandandhand.jconf]]))

--create the config file and store it on S: drive (for METaL win7 server)
createKiwiVRConfigFile{
	words = {
		{"hello",.85},
		{"goodbye",.75},
		{"dog",.75},
		{"cat",.75},
		{"bears",.81},
		{"load config files",.81},
	},
	fullPathFileName = [[S:\ProjectsCurrent\KiwiVRConfigFiles\custom.xml]],
	servername = "Tracker00",
}

--action frame to print message to screen
Actions.addFrameAction(function()
	local speech_device = gadget.StringInterface("KinectProxy")
	while true do
		local message = speech_device.data
		if #message > 0 then
			print("You said "..message)
		end
		Actions.waitForRedraw()
	end
end)