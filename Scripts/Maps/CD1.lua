local TXT = Localize{
	[0] = " ",
	[1] = "Door",
	[2] = "Switch",
	[3] = "Chest",
	[4] = "Exit",
	[5] = "The door is locked.",
	[6] = "The door won't budge.",
	[7] = "Castle Alamos",
	[8] = "Tree",
	[9] = "Etched into the tree a message reads:                                                                                                                                                                                                                              The first is half the forth plus one, better hurry or you'll be done!",
	[10] = "Etched into the tree a message reads:                                                                                                                                                                                                                              The second is next to the third, oh so pretty like a bird!",
	[11] = "Etched into the tree a message reads:                                                                                                                                                                                                                              The third is the first of twenty six, A through Z you'll have to mix!",
	[12] = "Etched into the tree a message reads:                                                                                                                                                                                                                              The fifth is twice the second, five letters in all I reckon!",
	[13] = "Etched into the tree a message reads:                                                                                                                                                                                                                              The forth is eight from the end, Archibald really is your friend!",
	[14] = "What's the password?",
	[15] = "JBARD",
	[16] = "jbard",
	[17] = "Wrong!",
	[18] = "Ok!",
	[19] = "Who told you!  Alright, you may pass!",
	[20] = "Teleporter",
	[21] = "Restricted area - Keep out.",
	[22] = "The summoning has begun, better hurry",
	[23] = "Locked",
	[24] = "They key is stucked in the door.",
	[25] = "Door to the unknown",
}
table.copy(TXT, evt.str, true)

evt.map[100] = function()
	if mapvars.alert ~= 1 then 
		evt.StatusText(22)
		if mapvars.alert == nil then
		mapvars.alert = 1
		vars.portal=vars.portal or {}
		mapvars.event=true
		for i=0,3 do
			if Party[i].Spells[31]==true then
				Party[i].Spells[31]=false
				vars.portal[i]=true
			end
		end
		evt.SetDoorState{Id = 10, State = 0}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {100, 00, 0}, radius = 64, group = 255, ShowOnMap = true}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {90, 10, 0}, radius = 64, group = 255}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {80, 20, 00}, radius = 64, group = 255}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {70, 30, 0}, radius = 64, group = 255}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {60, 30, 10}, radius = 64, group = 255}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {50, 35, 15}, radius = 64, group = 255}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {40, 40, 20}, radius = 64, group = 255}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {30, 50, 20}, radius = 64, group = 255}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {20, 50, 30}, radius = 64, group = 255}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {10, 50, 40}, radius = 64, group = 255}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {0, 50, 50}, radius = 64, group = 255}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {0, 30, 70}, radius = 64, group = 255}
		Sleep(500)
		pseudoSpawnpoint{monster = 91, x = 1318, y = 1166, z = 245, count = 1, powerChances = {0, 0, 100}, radius = 64, group = 255}	
		Message("A dark presence is approaching the door")
		Sleep(3000)
		pseudoSpawnpoint{monster = 88, x = 1318, y = 1166, z = 245, count = 5, powerChances = {0, 0, 100}, radius = 64, group = 255}
		for i=0,3 do
			if vars.portal[i]==true then
				Party[i].Spells[31]=true
			end
		end		
		mapvars.event=false
		end	
	end
end

evt.hint[101] = evt.str[25]  -- "Door to the unknown"
evt.map[101] = function()
	if  evt.Cmp("Inventory", 497) then        -- Key
		evt.MoveToMap{X = 0, Y = 1280, Z = 0, Direction = 1536, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 8, Name = "zdwj01.blv"}
		else
		evt.StatusText(23)
	end
end