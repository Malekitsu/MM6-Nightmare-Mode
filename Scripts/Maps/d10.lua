local TXT = Localize{
	[0] = " ",
	[1] = "Door",
	[2] = "Chest",
	[3] = "Lever",
	[4] = "Cabinet",
	[5] = "Switch",
	[6] = "The Door won't budge.",
	[7] = "Caught!",
	[8] = "Rats!",
	[9] = "Are those footsteps?",
	[10] = "Exit",
	[11] = "Dragoons' Keep",
	[12] = "Who dares disturb my sleep",
	[13] = "Some weird noises are coming from a nearby wall",
	[14] = "Something from the door is pulling you",
	[15] = "The whole room is shaking",
}

table.copy(TXT, evt.str, true)


evt.map[100] = function()
	if mapvars.alert ~= 1 then 
		mapvars.event=true
		vars.portal=vars.portal or {}
		for i=0,3 do
			if Party[i].Spells[31]==true then
				Party[i].Spells[31]=false
				vars.portal[i]=true
			end
		end
		evt.StatusText(15)
		if mapvars.alert == nil then
		mapvars.alert = 1
		Sleep(4000)
		Message("Who dares disturb my sleep")
		Sleep(100)
		mapvars.pull = 1	
		end	
	end
end

evt.map[101] = function()
	if mapvars.warning ~= 1 then 
		evt.StatusText(13)
		if mapvars.warning == nil then
		mapvars.warning = 1
		end	
	end
end



evt.map[102] = function()
	if	mapvars.teleport ~= 1 then
		if mapvars.pull == 1 then
		Message("Something from the door is pulling you")
		mapvars.teleport = 1	
		Sleep(100)	
		mapvars.event=false
		for i=0,3 do
			if vars.portal[i]==true then
				Party[i].Spells[31]=true
			end
		end
		evt.MoveToMap{x = 296, y = -221, z = 1, Direction = 1024, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 0, Name = "zddb02.blv"}
		end
	end	
end

evt.ForPlayer("All")
evt.Subtract("Inventory", 491)         -- "Minotaurs's Key"
		
		
evt.map[103] = function()
	if	mapvars.key ~= 1 then
		evt.ForPlayer("All")
		evt.Subtract("Inventory", 491)         -- "Minotaurs's Key"
		mapvars.key = 1
	end
end

