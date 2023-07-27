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
	function events.Tick()
		vars.hasPortal=vars.hasPortal or {}
		if Party.EnemyDetectorYellow or Party.EnemyDetectorRed then
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

