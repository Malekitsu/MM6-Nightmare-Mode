local TXT = Localize{
	[0] = " ",
	[1] = "Chest",
	[2] = "Exit",
	[3] = "Exit",
	[4] = "Exit",
}
table.copy(TXT, evt.str, true)

Game.MapEvtLines.Count = 0  -- Deactivate all standard events


evt.map[1] = function()
	evt.SetDoorState{Id = 1, State = 0}
	evt.SetDoorState{Id = 3, State = 1}
	if not mapvars.Spawned1 then
		mapvars.Spawned1=true
		Game.ShowStatusText("They are coming from the ceiling!")
		for i=1,10 do
			pseudoSpawnpoint{monster = 28, x = 1740, y = 1047, z = 240, count = 1, powerChances = {70, 20, 10}, radius = 512, group = 255, ShowOnMap = true}
			Sleep(50)
		end
	end
end

evt.map[2] = function()
	evt.SetDoorState{Id = 2, State = 0}
	evt.SetDoorState{Id = 4, State = 1}
	if not mapvars.Spawned2 then
		mapvars.Spawned2=true
		Game.ShowStatusText("More of them!")
		for i=1,10 do
			pseudoSpawnpoint{monster = 28, x = -1740, y = 1047, z = 240, count = 1, powerChances = {60, 25, 15}, radius = 512, group = 255, ShowOnMap = true}
			Sleep(50)
		end
	end
end

evt.map[3] = function()
	evt.SetDoorState{Id = 1, State = 1}
	evt.SetDoorState{Id = 3, State = 0}
	if not mapvars.Spawned3 then
		mapvars.Spawned3=true
		Game.ShowStatusText("More of them!")
		for i=1,10 do
			pseudoSpawnpoint{monster = 28, x = 519, y = -2187, z = 240, count = 1, powerChances = {60, 25, 15}, radius = 512, group = 255, ShowOnMap = true}
			Sleep(50)
		end
		pseudoSpawnpoint{monster = 25, x = 519, y = -2187, z = 240, count = 1, powerChances = {100, 0, 0}, radius = 512, group = 255, ShowOnMap = true}
		pseudoSpawnpoint{monster = 25, x = 519, y = -2187, z = 240, count = 1, powerChances = {0, 100, 0}, radius = 512, group = 255, ShowOnMap = true}
		pseudoSpawnpoint{monster = 25, x = 519, y = -2187, z = 240, count = 1, powerChances = {100, 0, 0}, radius = 512, group = 255, ShowOnMap = true}
	end
end

evt.hint[5] = evt.str[1]  -- "Chest"
evt.map[5] = function()
	evt.OpenChest(2)
end

evt.hint[6] = evt.str[1]  -- "Chest"
evt.map[6] = function()
	evt.OpenChest(3)
end

evt.hint[7] = "Exit"
evt.map[7] = function()
	evt.MoveToMap{X = 1393, Y = 1162, Z = 245, Direction = 0, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 8, Name = "cd1.blv"}
end