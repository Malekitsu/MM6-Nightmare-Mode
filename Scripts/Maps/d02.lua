
--[[AES(2454, 100)
evt.map[100] = function()
	if mapvars.tyeksekk ~= 3 then 
    Message("This text is made possible by Eksekk, but now you are going to die")
		if mapvars.tyeksekk == nil then
		mapvars.tyeksekk = 0
		end
	mapvars.tyeksekk = mapvars.tyeksekk + 1
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	
	end
end
]]



local TXT = Localize{
	[0] = " ",
	[1] = "Door",
	[2] = "Exit",
	[3] = "Chest",
	[4] = "Guano Rock",
	[5] = "You've Rescued a child!  How patriarchal of you",
	[6] = "This Rock is covered in bat guano",
	[7] = "You harvest the guano and put it in your pouch",
	[8] = "You pick up some guano, but have nowhere to put it.",
	[9] = "Cage",
	[10] = "You open the cage and remove the bones.",
	[11] = "Teleporter",
	[12] = "Abandoned Temple",
	[13] = "You find the basic tools for repair",
}
table.copy(TXT, evt.str, true)

evt.map[101] = function()
	if mapvars.death ~= 1 then 
    Message("Trespassers shall die.")
	mapvars.death = 1	
	end
end


evt.map[102] = function()
	if mapvars.stench ~= 1 then 
    Message("'The stench fills your lungs.'")
	mapvars.stench = 1	
	end
end

evt.map[105] = function()
	if mapvars.learned == nil then
			for _, pl in Party do
			local skill, mastery = SplitSkill(pl.Skills[const.Skills.RepairItem])
			pl.Skills[const.Skills.RepairItem] = JoinSkill(math.max(skill, 4), math.max(mastery, const.Expert))
			end
		evt.StatusText(13)
		evt.ForPlayer("All")		
		evt.Add("Experience", 500)
		mapvars.learned = 1
	end
end

if mapvars.fix==nil then
	for i=1,Map.Monsters.High do
		if Map.Monsters[i].Id==154 or Map.Monsters[i].Id==155 or Map.Monsters[i].Id==156 then
			Map.Monsters[i].SpellSkill=Map.Monsters[i].SpellSkill^0.6
		end
		mapvars.fix=true
	end
end
