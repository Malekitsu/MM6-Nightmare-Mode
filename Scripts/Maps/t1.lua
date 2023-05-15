local TXT = Localize{
	[0] = " ",
	[1] = "Door",
	[2] = "Exit",
	[3] = "Chest",
	[4] = "The door is locked.",
	[5] = "The door is locked.",
	[6] = "The door is locked.",
	[7] = "Zap!",
	[8] = "The door is locked.",
	[9] = "The door is locked.",
	[10] = "The door is locked.",
	[11] = "The door is locked.",
	[12] = "Refreshing.",
	[13] = "Temple of Baa",
	[14] = "",
	[15] = "",
	[16] = "",
	[17] = "",
	[18] = "A wooden sign reads: As the winds blow, the seasons change, and only at the end of all can the doors be opened.",
	[19] = "The haunted sounds of tortured souls assail your ears.",
	[20] = "A silver sign reads: As the winds blow, the seasons change, and only at the end of all can the doors be opened.",
	[21] = "A copper sign reads: As the winds blow, the seasons change, and only at the end of all can the doors be opened.",
	[22] = "A lapis sign reads: As the winds blow, the seasons change, and only at the end of all can the doors be opened.",
	[23] = "Sign",
	[24] = "Found something!",
	[25] = "You scoop away a handful of someone's hopes and dreams.",
	[26] = "Fountain",
	[27] = "You toss a few coins into the fountain.",
	[28] = " +20 Hit points restored.",
	[29] = "Statue",
	[30] = "The door clicks.",
	[31] = "Unholy words come down the corridor, there must be some sort of ritual going on",
	[32] = "Horde of Skeletons rises from the ground"
}


table.copy(TXT, evt.str, true)


evt.map[100] = function()
	if mapvars.spawn ~= 1 then 
	mapvars.event=true
	
	vars.portal=vars.portal or {}
	for i=0,3 do
		if Party[i].Spells[31]==true then
			Party[i].Spells[31]=false
			vars.portal[i]=true
		end
	end

		
	evt.StatusText(32)
	mapvars.spawn =  1
	evt.SetDoorState{Id = 2, State = 0}
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
		evt.StatusText(31)
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
			for i=0,3 do
				if vars.portal[i]==true then
					Party[i].Spells[31]=true
				end
			end
		
		end	
	end
end


evt.map[23] = function()
	if evt.Cmp("MapVar19", 1) then
		evt.OpenChest(0)
	else
		evt.OpenChest(0)
		evt.Set("MapVar19", 1)
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 3, Count = 1, X = -9986, Y = 1295, Z = -255}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 2, Count = 2, X = -10224, Y = 1295, Z = -255}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 1, Count = 2, X = -9716, Y = 1295, Z = -255}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 3, Count = 1, X = -8716, Y = 101, Z = -255}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 2, Count = 2, X = -8716, Y = 405, Z = -255}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 1, Count = 2, X = -8716, Y = -117, Z = -255}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 3, Count = 1, X = -10009, Y = -1039, Z = -255}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 2, Count = 2, X = -9713, Y = -1039, Z = -255}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 1, Count = 2, X = -10272, Y = -1039, Z = -255}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 3, Count = 1, X = -11291, Y = 138, Z = -255}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 2, Count = 2, X = -11291, Y = -93, Z = -255}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 1, Count = 2, X = -11291, Y = 454, Z = -255}
	end
end
