require("Text")
require("Actions")
dofile([[C:\Users\lpberg\Desktop\movetools.lua]])
function makeCountdownNumber(num)
	return TextGeode{
		tostring(num),
		position = {-1, 2, -8},
		font = Font("DroidSerifItalic"),
		lineHeight = 1
	}
end
starwars = "Star Wars\n It is a period of civil war.\n Rebel spaceships, striking from a hidden base,\n have won their first victory against the evil Galactic\nEmpire.During the battle,\n Rebel spies managed to steal secret plans to the\nEmpire's ultimate weapon, the Death Star, an armored space station with enough power to\n destroy an entire planet. Pursued by the Empire's sinister agents,\n Princess Leia races homeaboard her starship,\n custodian of the stolen plans that can save herpeople and restore freedom to the galaxy\n..."
star_wars = "There is unrest in the Galactic\n Senate. Several thousand solar \n systems have declared their\n intentions to leave the Republic.\nThis separatist movement,\n under the leadership of the\n mysterious Count Dooku, has\n made it difficult for the limited\n number of Jedi Knights to maintain \n peace and order in the galaxy.\n \n Senator Amidala, the former\n Queen of Naboo, is returning\n to the Galactic Senate to vote\n on the critical issue of creating\n an ARMY OF THE REPUBLIC\n to assist the overwhelmed\n Jedi....\n"
text = TextGeode{
		tostring(star_wars),
		color = osg.Vec4(1, 1, 0.0, 1.0),
		lineHeight = .25,
		position = {-1, 0, 0},
		font = Font("DroidSans"),
}

xform = Transform{
	orientation = AngleAxis(Degrees(-52), Axis{1.0, 0.0, 0.0}),
	text
}


RelativeTo.World:addChild(xform)

fun = Transformation.move_slow(xform,.0015,-1,100,-100)
-- Actions.addFrameAction(fun)