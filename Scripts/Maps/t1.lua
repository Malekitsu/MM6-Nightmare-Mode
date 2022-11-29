
evt.map[100] = function()
	if mapvars.spawn ~= 1 then 
    Message("Horde of Skeletons rises from the ground")
	mapvars.spawn =  1
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 1, powerChances = {0, 0, 100}, radius = 128, group = 255}
	Sleep(100)
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 1, powerChances = {0, 100, 0}, radius = 128, group = 255}
	Sleep(100)
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 1, powerChances = {0, 100, 0}, radius = 128, group = 255}
	Sleep(100)
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 2, powerChances = {50, 30, 20}, radius = 512, group = 255}
	Sleep(600)
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 2, powerChances = {50, 30, 20}, radius = 512, group = 255}
	Sleep(400)
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 2, powerChances = {50, 30, 20}, radius = 512, group = 255}
	Sleep(400)
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 2, powerChances = {50, 30, 20}, radius = 512, group = 255}
	Sleep(400)
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 2, powerChances = {50, 30, 20}, radius = 512, group = 255}
	Sleep(400)
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 2, powerChances = {50, 30, 20}, radius = 512, group = 255}
	Sleep(400)
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 2, powerChances = {50, 30, 20}, radius = 512, group = 255}
	Sleep(400)
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 2, powerChances = {50, 30, 20}, radius = 512, group = 255}
	Sleep(400)
	pseudoSpawnpoint{monster = 154, x = -1287, y = -6026, z = 1064, count = 2, powerChances = {50, 30, 20}, radius = 512, group = 255}
	Sleep(100)
	mapvars.lich = 1
	end
end


evt.map[101] = function()
	if mapvars.alert ~= 1 then 
    Message("Unholy words come down the corridor, there must be some sort of ritual going on")
		if mapvars.alert == nil then
		mapvars.alert = 1
		end	
	end
end

evt.map[102] = function()
	if mapvars.powers == nil then
		if mapvars.lich == 1 then 
			Message("The lich powers flow through your body")
			evt.ForPlayer("All")
			evt.Add("Experience", 20000)
		mapvars.powers = 1
		end	
	end
end

