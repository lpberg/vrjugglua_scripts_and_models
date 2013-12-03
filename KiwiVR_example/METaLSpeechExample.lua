require("AddAppDirectory")
AddAppDirectory()
runfile[[kiwiVRConfigCreator.lua]]
runfile([[../message_loader/setMessageText.lua]])

--load in a configuration file to talk to the voice server
vrjKernel.loadConfigFile(vrjLua.findInModelSearchPath([[VRPNText.jconf]]))

--list of words to recognize
local mywords = {
	{"hello",.85},
	{"goodbye",.11},
	{"dog",.75},
	{"cat",.51},
	{"bears",.81},
}
--create the config file and store it on S: drive
my_config_file = createKiwiVRConfigFile{
	words = mywords,
	fullPathFileName = [[S:\ProjectsCurrent\KiwiVRConfigFiles\custom.xml]],
	--servername must match jconf being used
	servername = "Tracker00",
}

Actions.addFrameAction(function()
	local speech_device = gadget.StringInterface("KinectProxy")
	while true do
		for _,word in ipairs(mywords) do
			if speech_device.data == word[1] then
				setMessageText(" You said "..word[1], 1)
			end
		end
		Actions.waitForRedraw()
	end
end)