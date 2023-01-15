
Game.MapEvtLines:RemoveEvent(27)

evt.hint[27] = evt.str[10]  -- "Altar of the Moon"
evt.map[27] = function()
	if mapvars.medusa ~= 1 then
		Message("Moon Crystal repulse you")
		mapvars.medusa = 1
		evt.SetDoorState{Id = 5, State = 0}
		evt.SetDoorState{Id = 6, State = 0}
		evt.MoveToMap{X = 1652, Y = 6122, Z = 256, Direction = 1, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 0, Name = "0"}
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 1, Count = 3, X = 3388, Y = 6122, Z = 384, radius = 256}
		Sleep(300)
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 1, Count = 3, X = 3388, Y = 6122, Z = 384, radius = 256}
		Sleep(300)
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 1, Count = 3, X = 3388, Y = 6122, Z = 384, radius = 256}
		Sleep(600)
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 2, Count = 2, X = 3388, Y = 6122, Z = 384, radius = 256}
		Sleep(200)
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 2, Count = 1, X = 3388, Y = 6122, Z = 384, radius = 256}
		Sleep(200)
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 2, Count = 1, X = 3388, Y = 6122, Z = 384, radius = 256}
		Sleep(800)
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 3, Count = 1, X = 3388, Y = 6122, Z = 384, radius = 256}
		Sleep(400)
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 3, Count = 1, X = 3388, Y = 6122, Z = 384, radius = 256}
		Sleep(400)
		evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 3, Count = 1, X = 3388, Y = 6122, Z = 384, radius = 256}
		Sleep(700)
		pseudoSpawnpoint{monster = 85, x = 3388, y = 6122, z = 384, count = 1, powerChances = {0, 0, 100}, radius = 128, group = 50, transform = function(mon) mon.FullHP = 2500 mon.HP = mon.FullHP end}
		Sleep(1500)
		Message("Time is twisting, full moon has arrived")
		mapvars.moon = 1
		evt.SetDoorState{Id = 5, State = 1}
		evt.SetDoorState{Id = 6, State = 1} 
		else
			if not evt.Cmp("QBits", 174) then         -- NPC
				if evt.Cmp("QBits", 119) then         -- "Visit the Altar of the Moon in the Temple of the Moon at midnight of a full moon."
					if not evt.Cmp("HourIs", 1) then
						if mapvars.moon == 1 then
						evt.SpeakNPC(306)         -- "Loretta Fleise"
						else Message("Visit the Altar of the Moon at midnight of a full moon.")
					end
				end
			end
		end

	end
end

Game.MapEvtLines:RemoveEvent(5)

evt.hint[5] = evt.str[1]  -- "Door"
evt.map[5] = function()
	if mapvars.medusa ~= 1 then
	evt.SetDoorState{Id = 5, State = 1}
	evt.SetDoorState{Id = 6, State = 1} 
	end
end
