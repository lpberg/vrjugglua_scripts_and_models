require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
o = vrjLua.findInModelSearchPath("tos-sulu-phasersready.mp3")
snx.changeAPI("OpenAL")
--snx.changeAPI("Audiere")

i = snx.SoundInfo()
i.filename = vrjLua.findInModelSearchPath("tos-scotty-upurshaft-fixed.wav")
i.ambient = false

s = snx.SoundHandle(i.filename)
--
s:setPosition(-200,0,0)
s:configure(i)
do
	s:trigger(1)
	s:trigger(1)
end