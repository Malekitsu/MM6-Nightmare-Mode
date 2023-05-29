-- configure shrine event
configureShrineEvent(262, 7, "FireResistance", 21, 22, 23, 24)
configureShrineEvent(261, 9, "ColdResistance", 14, 15, 16, 17)

Game.MapEvtLines:RemoveEvent(102)

evt.hint[102] = "Golden well"
evt.map[102] = function()
	if evt.Cmp("LevelBonus", 15) then
		evt.StatusText(10)         -- "Refreshing!"
	else if evt.Cmp("Gold", 15000) then
			evt.ForPlayer("All")
			evt.Set("LevelBonus", 15)
			evt.Subtract("Gold", 15000)
			Game.ShowStatusText("+15 Level temporary.  Look Out! (-15000 Gold")
			evt.Set("AutonotesBits", 47)         -- "30 Temporary levels from the western well in the town of Kriegspire."
			evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 3, Count = 2, X = -13280, Y = 19696, Z = 160}
			evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 3, Count = 2, X = -13368, Y = 18096, Z = 160}
			evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 3, Count = 2, X = -10976, Y = 18152, Z = 160}
			evt.SummonMonsters{TypeIndexInMapStats = 3, Level = 3, Count = 2, X = -9992, Y = 19056, Z = 160}
		else
		Game.ShowStatusText("A gold donation is required")
		end
	end
end
