require("AddAppDirectory")
AddAppDirectory()
runfile[[kiwiVRConfigCreator.lua]]

--- tips for using voice in METaL
-- 		make sure no Navtestbed processes are still running
-- 		RDP should be configured to leave audio on remote machine and pass plug and play devices (?)
-- 		when loading jconfs make sure to load the metal one you want as well

--load in a configuration file to talk to the voice server
--? - why do we have to load both, shouldn't launcher take care of one?
vrjKernel.loadConfigFile(vrjLua.findInModelSearchPath([[VRPNText.jconf]]))
vrjKernel.loadConfigFile(vrjLua.findInModelSearchPath([[s:/jconf30/METaL.tracked.stereo.reordered.withwandandhand.jconf]]))

--list of words to recognize with confidence numbers
local mywords = {
	{"hello",.85},
	{"goodbye",.11},
	{"dog",.75},
	{"cat",.51},
	{"bears",.81},
}

--create the config file and store it on S: drive (for metal win7 server)
my_config_file = createKiwiVRConfigFile{
	words = mywords,
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