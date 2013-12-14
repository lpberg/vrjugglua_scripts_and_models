require("AddAppDirectory")
AddAppDirectory()
runfile[[frameActionSwitcher.lua]]

function print1()
	while true do
		print(1)
		Actions.waitForRedraw()
	end
end
function print2()
	while true do
		print(2)
		Actions.waitForRedraw()
	end
end
function print3()
	while true do
		print(3)
		Actions.waitForRedraw()
	end
end

mySwitcher = frameActionSwitcher{
	switchButton = gadget.DigitalInterface("VJButton2"),
	{print1,"print 1"},
	{print2,"print 2"},
	{print3,"print 3"},
}