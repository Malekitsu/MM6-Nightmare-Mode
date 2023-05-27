local TXT = Localize{
	[0] = " ",
	[1] = "Bench",
	[2] = "You find a small wooden dowl.",
	[3] = "Crate",
	[4] = "There seems to be a small hole in the crate.",
	[5] = "You fit the dowl into the hole and a small key pops out.",
	[6] = "The crate is padlocked - you need a key.",
	[7] = "You fit the key into the padlock and it pops open.",
}
table.copy(TXT, evt.str, true)

-- Deactivate all standard events
Game.MapEvtLines.Count = 0

--[[
evt.hint[1] = evt.str[1]  -- "Bench"
evt.map[1] = function()
	if not evt.Cmp("MapVar0", 1) then
		evt.Add("MapVar0", 1)
		evt.StatusText(2)         -- "You find a small wooden dowl."
	end
end

evt.hint[2] = evt.str[3]  -- "Crate"
evt.map[2] = function()
	evt.OpenChest(1)
end

evt.hint[3] = evt.str[3]  -- "Crate"
evt.map[3] = function()
	evt.OpenChest(0)
end
]]


evt.map[100] = function()
	if SETTINGS["255MOD"]==true then
		Message("255 MOD correctly detected, you are ready to go fellow adventurer, you will be teleported to a very dangerous world, good luck and have fun!")
		evt.MoveToMap{X = -9714, Y = -7508, Z = 0, Direction = 512, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 0, Name = "Oute3.odm"}
	else
		Message("255 MOD not detected, please save game, go to Might and Magic 6 main folder, open MM6.ini and set 255MOD to true (just like this:  255MOD=true ). Once done, relaunch the game and load game; if done correctly you will be teleported out")
	end
end
Timer(evt.map[1].last, 3*const.Minute)
