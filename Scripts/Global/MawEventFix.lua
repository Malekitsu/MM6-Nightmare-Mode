function events.CanSaveGame(t)
	if (mapvars.event and t.SaveKind ~=1) or (mapvars.eventNightmare and t.SaveKind ~=1) then
	t.Result=false
	Game.ShowStatusText("Can't save now")
	else
	t.Result=true
	end
end

function events.CanCastLloyd(t)
	if mapvars.event or mapvars.eventNightmare then
	t.Result=false
	Sleep(1)
	Game.ShowStatusText("Can't teleport now")
	else
	t.Result=true
	end
end


if SETTINGS["TRUENIGHTMARE"]==true then
	function events.Tick()
		if Party.EnemyDetectorYellow or Party.EnemyDetectorRed then
			mapvars.eventNightmare=true
		else
			mapvars.eventNightmare=false
		end
	end
	function events.CanCastTownPortal(t)
		if Party.EnemyDetectorYellow or Party.EnemyDetectorRed then
			t.Can=false
		else
			t.Can=true
		end
	end	
end

--grayface fix treasure code
local function NeedSeed()
	local t = mapvars.MonsterSeed
	if not t then
		t = {}
		mapvars.MonsterSeed = t
		for i = 0, Map.Monsters.Limit - 1 do
			t[i] = Game.RandSeed
			for i = 1, 30 do
				Game.Rand()
			end
		end
	end
	return t
end

events.LoadMap = NeedSeed

local function f(t)
	local seed = NeedSeed()
	Game.RandSeed = seed[t.MonsterIndex]
	t.CallDefault()
	seed[t.MonsterIndex] = Game.RandSeed
end

events.PickCorpse = f
events.CastTelepathy = f
