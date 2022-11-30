local TXT = Localize{
	[0] = " ",
	[1] = "Sack",
	[2] = "You find jerked beef in the sack (+10 food).",
	[3] = "Mead filled barrel.",
	[4] = "You drink the mead and are feeling good.",
	[5] = "Stew filled bowl.",
	[6] = "The stew tasts good - you feel better (+5 hits).",
	[7] = "Crates filled with wood chips.",
	[8] = "The sack is empty.",
	[9] = "The bowl is empty.",
	[10] = "There is of nothing of value in the crates.",
	[11] = "The mead barrel is empty.",
	[12] = "It's locked"
}
table.copy(TXT, evt.str, true)

Game.MapEvtLines.Count = 0  -- Deactivate all standard events


evt.hint[1] = evt.str[1]  -- "Sack"
evt.map[1] = function()
	if evt.Cmp("MapVar0", 1) then
		evt.StatusText(8)         -- "The sack is empty."
	else
		evt.StatusText(2)         -- "You find jerked beef in the sack (+10 food)."
		evt.Add("Food", 10)
		evt.Add("MapVar0", 1)
	end
end

evt.hint[2] = evt.str[5]  -- "Stew filled bowl."
evt.map[2] = function()
	if evt.Cmp("MapVar1", 2) then
		evt.StatusText(9)         -- "The bowl is empty."
	else
		evt.StatusText(6)         -- "The stew tasts good - you feel better (+5 hits)."
		evt.Add("HP", 5)
		evt.Add("MapVar1", 1)
	end
end

evt.hint[3] = evt.str[7]  -- "Crates filled with wood chips."
evt.map[3] = function()
	evt.StatusText(10)         -- "There is of nothing of value in the crates."
end

evt.hint[4] = evt.str[3]  -- "Mead filled barrel."
evt.map[4] = function()
	if evt.Cmp("MapVar2", 4) then
		evt.StatusText(11)         -- "The mead barrel is empty."
	else
		evt.StatusText(4)         -- "You drink the mead and are feeling good."
		evt.Add("Drunk", 5)
		evt.Add("MapVar2", 1)
	end
end




evt.map[100] = function()
	evt.ForPlayer("All")
	if evt.Cmp("Inventory", 491) then         -- "Minotaur's Key"

		evt.MoveToMap{106, x = -3416, y = 4756, z = 1, Direction = 512, LookAngle = 0, SpeedZ = 0,  HouseId = 0, Icon = 0, Name = "d10.blv"}
	else
		evt.StatusText(12)         -- "The door is locked."
	end
end
