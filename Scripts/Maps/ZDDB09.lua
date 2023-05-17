local TXT = Localize{
	[0] = " ",
	[1] = "Exit",
	[2] = "The first trial of the celestial arena: many have perished in this crucible of cosmic challenges. But fear not, for I am confident in your abilities to emerge victorious.",
	[3] = "Are you ready to prove your strength?(yes/no)",
	[4] = "Yes",
	[5] = "The second trial of the Celestial Arena is a true test of one's skill and resolve, far more difficult than the first. The challenges you will face will push you to your limits and require every ounce of your strength to overcome.",
	[6] = "The third trial of the Celestial Arena is widely regarded as the ultimate challenge, one that even the gods themselves would struggle to overcome. If you can overcome this ultimate test, you will have proven yourself as a true master of the Celestial Arena.",
	[7] = "Do you wish do some training your skills before leaving?",
	[8] = "train",
	[9] = "leave",
	[10] = "train/leave"
}
table.copy(TXT, evt.str, true)

Game.MapEvtLines.Count = 0  -- Deactivate all standard events
evt.HouseDoor(1, 82)
evt.house[1] = 82
evt.hint[1] = "Training Ground" 
-- "Exit"
evt.hint[7] = "Exit"
evt.map[7] = function()
	if vars.CelestialArena1~=nil then  
		if vars.GameOver~=nil then
		evt.MoveToMap{X = 14088, Y = 2800, Z = 96, Direction = 1024, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 1, Name = "OutD3.Odm"}	
		else
		Message("That's your final battle, I hope you are ready")
		evt.MoveToMap{evt.MoveToMap{X = -3657, Y =  -387, Z = 1185, Direction = 0, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 1, Name = "sci-fi.blv"}}	
		end
	else
		Game.ShowStatusText("prove your worth before leaving the Celestial Arena")
	end
end

--main door
evt.hint[2] = "Celestial Arena Master"
evt.map[2] = function()
	evt.ForPlayer("All")
	if evt.Cmp("Inventory", 579) or evt.Cmp("Inventory", 299) or evt.Cmp("Inventory", 399) and vars.CelestialArena1==nil then     
	Message("Congratulations, hero! You have proven yourself worthy in the Celestial Arena and emerged victorious from one of its trials. With the celestial artifact in your possession, you are now free to embark on your quest to save your world. This powerful artifact will protect you from the dangers that await and aid you in your battles against the forces of darkness. Go forth, champion, and may your bravery and skill be your guide on your journey. You may come back at any time, the entrance is located in Ironfist, search for a place with breathtaking view")
	vars.CelestialArena1=true
	vars.lastFight=true
	else 
	Message("To save your world, you must complete at least one of the trials that await you in the Celestial Arena. These tests will challenge you to the very core of your being, are you ready to take up the challenge and prove your worth, to become a true hero of the celestial realm?") 
	end
end

--difficulty 1
evt.hint[3] = "first trial"
evt.map[3] = function()
if not mapvars.event1 then
evt.SetMessage(2)   
	if evt.Question{Question = 3, Answer1 = 4} then      
		Game.ShowStatusText("Let it be, prepare yourself") 
		mapvars.event1=true
		mapvars.event=true
		Sleep(500)
		Game.ShowStatusText("3")
		Sleep(100)
		Game.ShowStatusText("2")
		Sleep(100)
		Game.ShowStatusText("1")
		Sleep(100)
		Game.ShowStatusText("Let the fight start!")
		Sleep(50)
		--start fight

		--magyars 1
		pseudoSpawnpoint{monster = 4, x = 1224, y = 3623, z = 0, count = 6, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(100)(mon); mon.Name="Celestial Soldier" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 4, x = 1224, y = 5500, z = 0, count = 6, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(100)(mon); mon.Name="Celestial Soldier" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 4, x = 6460, y = 3623, z = 0, count = 6, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(100)(mon); mon.Name="Celestial Soldier" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 4, x = 6460, y = 5500, z = 0, count = 6, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(100)(mon); mon.Name="Celestial Soldier" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(1000)
		--magyars 2
		pseudoSpawnpoint{monster = 4, x = 6460, y = 7800, z = 0, count = 5, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(120)(mon); mon.Name="Celestial Warrior" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 4, x = 1224, y = 7800, z = 0, count = 5, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(120)(mon); mon.Name="Celestial Warrior" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(1000)
		--magyars 3
		pseudoSpawnpoint{monster = 4, x = 2720, y = 9497, z = 0, count = 3, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(140)(mon); mon.Name="Celestial Warlord" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 4, x = 4780, y = 9497, z = 0, count = 3, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(140)(mon); mon.Name="Celestial Warlord" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(1000)
		--titans
		pseudoSpawnpoint{monster = 124, x = 6813, y = 3000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(100)(mon); mon.Name="Celestial Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 124, x = 6813, y = 6000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(100)(mon); mon.Name="Celestial Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 124, x = 864, y = 3000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(100)(mon); mon.Name="Celestial Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 124, x = 864, y = 6000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(100)(mon); mon.Name="Celestial Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 124, x = 3800, y = 9814, z = 192, count = 1, powerChances = {0, 100, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(120)(mon); mon.Name="Celestial Noble Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 124, x = 3800, y = 9814, z = 192, count = 1, powerChances = {0, 100, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(120)(mon); mon.Name="Celestial Noble Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(1000)
		--dragons
		pseudoSpawnpoint{monster = 40, x = 5200, y = 8468, z = 500, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Dragon" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 40, x = 3800, y = 8468, z = 500, count = 1, powerChances = {0, 100, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(180)(mon); mon.Name="Celestial Blue Dragon" mon.TreasureGold= 0 mon.TreasureItemPercent = 100 mon.TreasureGold= 0 mon.Item = 579  mon.Experience = 36000 end}
		pseudoSpawnpoint{monster = 40, x = 2400, y = 8468, z = 500, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Dragon" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		mapvars.event=false
	else 
		Game.ShowStatusText("Choose carefully")
	end
end
end

--difficulty 2
evt.hint[4] = "second trial"
evt.map[4] = function() 
evt.SetMessage(5)   
if not mapvars.event2 then
	if evt.Question{Question = 3, Answer1 = 4} then      
		Game.ShowStatusText("Let it be, prepare yourself") 
		mapvars.event2=true
		mapvars.event=true
		Sleep(500)
		Game.ShowStatusText("3")
		Sleep(100)
		Game.ShowStatusText("2")
		Sleep(100)
		Game.ShowStatusText("1")
		Sleep(100)
		Game.ShowStatusText("Let the fight start!")
		Sleep(50)
		--lizard
		pseudoSpawnpoint{monster = 31, x = 1224, y = 3623, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(110)(mon); mon.Name="Celestial Fire Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 31, x = 1224, y = 5500, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(110)(mon); mon.Name="Celestial Fire Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 31, x = 6460, y = 3623, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(110)(mon); mon.Name="Celestial Fire Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 31, x = 6460, y = 5500, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(110)(mon); mon.Name="Celestial Fire Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(500)
		pseudoSpawnpoint{monster = 31, x = 1224, y = 3623, z = 0, count = 2, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(120)(mon); mon.Name="Celestial Lightning Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 31, x = 1224, y = 5500, z = 0, count = 2, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(120)(mon); mon.Name="Celestial Lightning Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 31, x = 6460, y = 3623, z = 0, count = 2, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(120)(mon); mon.Name="Celestial Lightning Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 31, x = 6460, y = 5500, z = 0, count = 2, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(120)(mon); mon.Name="Celestial Lightning Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(500)
		pseudoSpawnpoint{monster = 31, x = 1224, y = 3623, z = 0, count = 2, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(130)(mon); mon.Name="Celestial Ice Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 31, x = 1224, y = 5500, z = 0, count = 2, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(130)(mon); mon.Name="Celestial Ice Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 31, x = 6460, y = 3623, z = 0, count = 2, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(130)(mon); mon.Name="Celestial Ice Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 31, x = 6460, y = 5500, z = 0, count = 2, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(130)(mon); mon.Name="Celestial Ice Lizard" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(1000)
		----wyrm 1
		pseudoSpawnpoint{monster = 37, x = 6460, y = 7800, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(135)(mon); mon.Name="Celestial Wyrm" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 37, x = 1224, y = 7800, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(135)(mon); mon.Name="Celestial Wyrm" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 37, x = 6460, y = 7800, z = 0, count = 2, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Greater Wyrm" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 37, x = 1224, y = 7800, z = 0, count = 2, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Greater Wyrm" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(1000)
		--wyrm 3
		pseudoSpawnpoint{monster = 37, x = 2720, y = 9497, z = 0, count = 1, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(165)(mon); mon.Name="Celestial Great Wyrm" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 37, x = 4780, y = 9497, z = 0, count = 1, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(165)(mon); mon.Name="Celestial Great Wyrm" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}	
		Sleep(1000)
		--drakes
		pseudoSpawnpoint{monster = 34, x = 6813, y = 3000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(133)(mon); mon.Name="Celestial Fire Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 34, x = 6813, y = 6000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(133)(mon); mon.Name="Celestial Fire Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 34, x = 864, y = 3000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(133)(mon); mon.Name="Celestial Fire Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 34, x = 864, y = 6000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(133)(mon); mon.Name="Celestial Fire Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 34, x = 3800, y = 9814, z = 192, count = 1, powerChances = {0, 100, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(144)(mon); mon.Name="Celestial Frost Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 34, x = 3800, y = 9814, z = 192, count = 1, powerChances = {0, 100, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(144)(mon); mon.Name="Celestial Frost Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(1000)
		--dragons
		pseudoSpawnpoint{monster = 40, x = 5200, y = 8468, z = 500, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Red Dragon" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 40, x = 3800, y = 8468, z = 200, count = 1, powerChances = {0, 100, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(180)(mon); mon.Name="Celestial Blue Dragon" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 40, x = 2400, y = 8468, z = 500, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Red Dragon" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 40, x = 3800, y = 8468, z = 600, count = 1, powerChances = {0, 0, 100}, radius = 0, group = 255, transform = function(mon) genericTransform(200)(mon); mon.Name="Celestial Gold Dragon" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		mapvars.event=false
	else 
		Game.ShowStatusText("Choose carefully")
	end   
end
end

--difficulty 3
evt.hint[5] = "third trial"
evt.map[5] = function()   
evt.SetMessage(6)   
if not mapvars.event3 then
	if evt.Question{Question = 3, Answer1 = 4} then  
		Game.ShowStatusText("Let it be, prepare yourself") 
		mapvars.event3=true
		mapvars.event=true
		Sleep(500)
		Game.ShowStatusText("Let the fight start!")
		Sleep(50)
		--start fight
		--Hydras
		pseudoSpawnpoint{monster = 85, x = 1224, y = 3623, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 85, x = 1224, y = 5500, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 85, x = 6460, y = 3623, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 85, x = 6460, y = 5500, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(500)
		pseudoSpawnpoint{monster = 85, x = 1224, y = 3623, z = 0, count = 2, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(170)(mon); mon.Name="Celestial Venomous Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 85, x = 1224, y = 5500, z = 0, count = 2, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(170)(mon); mon.Name="Celestial Venomous Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 85, x = 6460, y = 3623, z = 0, count = 2, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(170)(mon); mon.Name="Celestial Venomous Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 85, x = 6460, y = 5500, z = 0, count = 2, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(170)(mon); mon.Name="Celestial Venomous Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(500)
		pseudoSpawnpoint{monster = 85, x = 1224, y = 3623, z = 0, count = 2, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(190)(mon); mon.Name="Celestial Colossal Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 85, x = 1224, y = 5500, z = 0, count = 2, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(190)(mon); mon.Name="Celestial Colossal Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 85, x = 6460, y = 3623, z = 0, count = 2, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(190)(mon); mon.Name="Celestial Colossal Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 85, x = 6460, y = 5500, z = 0, count = 2, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(190)(mon); mon.Name="Celestial Colossal Hydra" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(1000)
		--drakes
		pseudoSpawnpoint{monster = 34, x = 6813, y = 3000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(133)(mon); mon.Name="Celestial Fire Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 34, x = 6813, y = 6000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(133)(mon); mon.Name="Celestial Fire Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 34, x = 864, y = 3000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(133)(mon); mon.Name="Celestial Fire Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 34, x = 864, y = 6000, z = 192, count = 1, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(133)(mon); mon.Name="Celestial Fire Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 34, x = 3800, y = 9814, z = 192, count = 1, powerChances = {0, 100, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(144)(mon); mon.Name="Celestial Frost Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 34, x = 3800, y = 9814, z = 192, count = 1, powerChances = {0, 100, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(144)(mon); mon.Name="Celestial Frost Drake" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(1000)
		--dragons 
		pseudoSpawnpoint{monster = 40, x = 5200, y = 8468, z = 500, count = 2, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Blue Dragon" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 40, x = 3800, y = 8468, z = 500, count = 2, powerChances = {0, 100, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(180)(mon); mon.Name="Celestial Gold Dragon" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 40, x = 2400, y = 8468, z = 500, count = 2, powerChances = {100, 0, 0}, radius = 0, group = 255, transform = function(mon) genericTransform(150)(mon); mon.Name="Celestial Blue Dragon" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 40, x = 3800, y = 8468, z = 500, count = 2, powerChances = {0, 0, 100}, radius = 0, group = 255, transform = function(mon) genericTransform(200)(mon); mon.Name="Celestial Gold Dragon" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		----titans 1
		pseudoSpawnpoint{monster = 166, x = 6460, y = 7800, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(190)(mon); mon.Name="Celestial Supreme Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 166, x = 1224, y = 7800, z = 0, count = 3, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(190)(mon); mon.Name="Celestial Supreme Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 166, x = 6460, y = 7800, z = 0, count = 2, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(190)(mon); mon.Name="Celestial Supreme Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 166, x = 1224, y = 7800, z = 0, count = 2, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(190)(mon); mon.Name="Celestial Supreme Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		Sleep(1000)
		--titans 3
		pseudoSpawnpoint{monster = 166, x = 2720, y = 9497, z = 0, count = 1, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(220)(mon); mon.Name="Celestial Divine Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
		pseudoSpawnpoint{monster = 166, x = 4780, y = 9497, z = 0, count = 1, powerChances = {0, 100, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(220)(mon); mon.Name="Celestial Divine Titan" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}	
		Sleep(1000)
		pseudoSpawnpoint{monster = 166, x = 3780, y = 9497, z = 0, count = 1, powerChances = {0, 0, 100}, radius = 256, group = 255, transform = function(mon) genericTransform(250)(mon); mon.Name="Champion of the Gods" mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}		
		mapvars.event=false
	else 
		Game.ShowStatusText("Choose carefully")
	end 
	end
end

--Barrel 1
evt.hint[21] = "God's Nectar"
evt.map[21] = function()  
	if not evt.Cmp("MapVar21", 1) then
		evt.ForPlayer("All")
		evt.Add("HP", 2000)
		evt.Add("SP", 2000)
		evt.Set("MapVar21", 1)	
		Game.ShowStatusText("+2000 Hit Points and Magic Points")
	else
	Game.ShowStatusText("Empty")
	end 
end

--Barrel 2
evt.hint[22] = "God's Nectar"
evt.map[22] = function()  
	if not evt.Cmp("MapVar22", 1) then
		evt.ForPlayer("All")
		evt.Add("HP", 2000)
		evt.Add("SP", 2000)
		evt.Set("MapVar22", 1)	
		Game.ShowStatusText("+2000 Hit Points and Magic Points")
	else
	Game.ShowStatusText("Empty")
	end 
end

--Barrel 3
evt.hint[23] = "God's Nectar"
evt.map[23] = function()  
	if not evt.Cmp("MapVar23", 1) then
		evt.ForPlayer("All")
		evt.Add("HP", 2000)
		evt.Add("SP", 2000)
		evt.Set("MapVar23", 1)	
		Game.ShowStatusText("+2000 Hit Points and Magic Points")
	else
	Game.ShowStatusText("Empty")
	end 
end

--Barrel 4
evt.hint[24] = "God's Nectar"
evt.map[24] = function()  
	if not evt.Cmp("MapVar24", 1) then
		evt.ForPlayer("All")
		evt.Add("HP", 2000)
		evt.Add("SP", 2000)
		evt.Set("MapVar24", 1)	
		Game.ShowStatusText("+2000 Hit Points and Magic Points")
	else
	Game.ShowStatusText("Empty")
	end 
end


--Urn 1
evt.hint[31] = "Food Urn"
evt.map[31] = function()    
	if not evt.Cmp("Food" , 50) then
		evt.Set("Food", 50)
		Game.ShowStatusText("An endless amount of food is stored")
	end
end

--Urn 2
evt.hint[32] = "Water Urn"
evt.map[32] = function()  
	if not evt.Cmp("Food" , 50) then
		evt.Set("Food", 50)
		Game.ShowStatusText("An endless amount of food is stored")
	end  
end

--Chest 1
evt.hint[41] = "Celestial Chest"
evt.map[41] = function()
evt.ForPlayer("All")
	if evt.Cmp("Inventory", 579) then     
	evt.OpenChest(1)
	else
	Game.ShowStatusText("first trial required")
	end
end

--Chest 2
evt.hint[42] = "Greater Celestial Chest"
evt.map[42] = function() 
	evt.ForPlayer("All")
	if evt.Cmp("Inventory", 299) then  
	evt.OpenChest(2) 
	else
	Game.ShowStatusText("second trial required")
	end 
end

--Chest 3
evt.hint[43] = "Greater Celestial Chest"
evt.map[43] = function()  
evt.ForPlayer("All")
	if evt.Cmp("Inventory", 299) then    
	evt.OpenChest(3)
	else
	Game.ShowStatusText("second trial required")
	end
end

--Chest 4
evt.hint[44] = "Gods Treasure"
evt.map[44] = function()
evt.ForPlayer("All")
	if evt.Cmp("Inventory", 399) then      
	evt.OpenChest(4)
	else
	Game.ShowStatusText("third trial required")
	end
end

function events.DeathMap(t)
	t.Name = "zddb09.blv"
	XYZ(Party, 3840, 2880, 192)
	Party.Direction = 512
	Party.LookAngle = 0
	Sleep(1)
	Message("You are not worthy, go away, mortal")
	Game.ExitMapAction=7
end