--credits to Grayface for this code ;)
if SETTINGS["TRUENIGHTMARE"]==true then
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
end
