--example of createKiwiVRConfigFile function 
require("AddAppDirectory")
AddAppDirectory()
runfile[[kiwiVRConfigCreator.lua]]

my_config_file = createKiwiVRConfigFile{
	words = {
		-- {"word",confidence},
		{"hello",.85},
		{"goodbye",.11},
		{"dog",.75},
		{"cat",.51},
		{"bears",.81},
	},
	outfile = "myXML",
	-- fullPathFileName = "full/path/here"
	servername = "Tracker00",
}