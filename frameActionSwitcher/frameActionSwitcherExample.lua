require("AddAppDirectory")
AddAppDirectory()
runfile[[frameActionSwitcher.lua]]

function print1()
	while true do
		print(1)
		Actions.waitForRedraw()
	end
end

function print1_onExit()
	print("exiting print1")
end

function print2()
	while true do
		print(2)
		Actions.waitForRedraw()
	end
end

function print2_onExit()
	print("exiting print2")
end

function print3()
	while true do
		print(3)
		Actions.waitForRedraw()
	end
end

function print3_onExit()
	print("exiting print3")
end

mySwitcher = frameActionSwitcher{
	switchButton = gadget.DigitalInterface("VJButton2"),
	{print1,"print 1",print1_onExit},
	{print2,"print 2",print2_onExit},
	{print3,"print 3",print3_onExit},
}