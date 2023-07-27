function events.CanSaveGame(t)
	if mapvars.event then
	t.Result=false
	Game.ShowStatusText("Can't save now")
	else
	t.Result=true
	end
end

function events.CanCastLloyd(t)
	if mapvars.event then
	t.Result=false
	Sleep(1)
	Game.ShowStatusText("Can't teleport now")
	else
	t.Result=true
	end
end


if SETTINGS["TRUENIGHTMARE"]==true then
	vars.hasPortal={}
	local function getDistanceToMonster(monster)
		return math.sqrt((Party.X - monster.X) * (Party.X - monster.X) + (Party.Y - monster.Y) * (Party.Y - monster.Y))
	end

	function events.Tick()
		nearbyMonsters=false
		for monsterIndex = 0, Map.Monsters.high do
			local monster = Map.Monsters[monsterIndex]
			local distanceToMonster = getDistanceToMonster(monster)
			if monster.Id~=121 and monster.Id~=122 and monster.Id~=123 and monster.Id~=133 and monster.Id~=134 and monster.Id~=135 then   
				if distanceToMonster < 4850 and monster.Active then
					nearbyMonsters=true
				end
			end
		end 
		if nearbyMonsters then
			mapvars.event=true
			for i=0,3 do
				if Party[i].Spells[31]==true then
					Party[i].Spells[31]=false
					vars.hasPortal[i]=true
				end
			end
		else
			mapvars.event=false
			for i=0,3 do
				if Party[i].Spells[31]==false and vars.hasPortal[i]==true then
					Party[i].Spells[31]=true
					vars.hasPortal[i]=false
				end
			end
		end
	end
end

