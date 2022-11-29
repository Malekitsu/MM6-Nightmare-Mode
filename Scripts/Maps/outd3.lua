-- configure shrine event
configureShrineEvent(261, 8, "BaseMight", 18, 19, 20, 21)


Game.MapEvtLines:RemoveEvent(94)

evt.house[94] = 191  -- "Temple of Baa"
evt.map[94] = function()
	if evt.Cmp("Awards", 8) or evt.Cmp("Awards", 9) then
		if evt.Cmp("Awards", 12) or evt.Cmp("Awards", 13) then
			if evt.Cmp("Awards", 16) or evt.Cmp("Awards", 17) then
				if evt.Cmp("Awards", 20) or evt.Cmp("Awards", 21) then
					if evt.Cmp("Awards", 24) or evt.Cmp("Awards", 25) then
						if evt.Cmp("Awards", 28) or evt.Cmp("Awards", 29) then
							evt.MoveToMap{X = -15592, Y = 120, Z = -191, Direction = 0, LookAngle = 0, SpeedZ = 0, HouseId = 191, Icon = 5, Name = "T1.Blv"}         -- "Temple of Baa"					
						else
						Message("You need all the promotions to enter here")
						end	
					else
					Message("You need all the promotions to enter here")
					end
				else
				Message("You need all the promotions to enter here")
				end
			else
			Message("You need all the promotions to enter here")
			end	
		else
		Message("You need all the promotions to enter here")
		end			
	else
	Message("You need all the promotions to enter here")
	end
end

