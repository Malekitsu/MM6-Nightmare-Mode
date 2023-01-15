-- configure shrine event
configureShrineEvent(261, 11, "MagicResistance", 18, 19, 20, 21)

Game.MapEvtLines:RemoveEvent(211)

evt.map[211] = function()
	evt.ForPlayer("All")
	if not evt.Cmp("QBits", 160) then         -- NPC
		if evt.Cmp("Inventory", 486) then         -- "Dragon Tower Keys"
			if evt.Cmp("Inventory", 491)
				then
					evt.ForPlayer("All")
					evt.Subtract("Inventory", 491)
					evt.Set("QBits", 160)         -- NPC
					evt.SetTextureOutdoors{Model = 61, Facet = 42, Name = "T1swBu"}
				else
					Message("This lock looks different to the other ones")
			end
			
		end
	end
end
