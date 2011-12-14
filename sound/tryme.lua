require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
mp3Path = vrjLua.findInModelSearchPath("tos-sulu-phasersready.mp3")
ProgramReady = vrjLua.findInModelSearchPath("ProgramCompleteEnterWhenReady.wav")
UpYourShaft = vrjLua.findInModelSearchPath("tos-scotty-upurshaft-fixed.wav")
snx.changeAPI("OpenAL")
--snx.changeAPI("Audiere")

i = snx.SoundInfo()
i.filename = ProgramReady
i.ambient = true

s = snx.SoundHandle(i.filename)
--
s:configure(i)
do
	s:trigger(1)
end