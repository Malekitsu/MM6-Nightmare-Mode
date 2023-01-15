local TXT = Localize{
	[0] = " ",
	[1] = "Door",
	[2] = "Exit",
	[3] = "Golden Wall",
}
table.copy(TXT, evt.str, true)

Game.MapEvtLines.Count = 0  -- Deactivate all standard events


evt.hint[1] = evt.str[1]  -- "Door."
evt.map[1] = function()
	evt.SetDoorState{Id = 1, State = 1}
end

evt.hint[2] = evt.str[1]  -- "Door."
evt.map[2] = function()
	evt.SetDoorState{Id = 2, State = 1}
end

evt.hint[3] = evt.str[1]  -- "Door."
evt.map[3] = function()
	evt.SetDoorState{Id = 3, State = 1}
end

evt.hint[4] = evt.str[1]  -- "Door."
evt.map[4] = function()
	evt.SetDoorState{Id = 4, State = 1}
end

evt.hint[5] = evt.str[1]  -- "Door."
evt.map[5] = function()
	evt.SetDoorState{Id = 5, State = 1}
end

evt.hint[6] = evt.str[2]  -- "Exit"
evt.map[6] = function()
	evt.MoveToMap{X = 2770, Y = -3192, Z = 0, Direction = 1024, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 6, Name = "D12.blv"}
end

evt.hint[100] = evt.str[3] 
evt.map[100] = function()
	if mapvars.map == 1 then
			evt.OpenChest(0)
			elseif evt.Cmp("Inventory", 493)
			then
			evt.ForPlayer("All")
			evt.Subtract("Inventory", 493)
			mapvars.map = 1
			Message("The map you found had secret instructions to find the hidden chest inside the wall")
			Sleep(50)
			evt.OpenChest(0)
			else
			Message("A gorgeous golden wall")
			end
end