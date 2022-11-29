dumps_folder = "dumps"

sortableMonsters = { }

function calculateAdjustedAverage(total_levels, total_monsters)
	naive = (total_levels / total_monsters)
	local total = 0
	local sd = 0
	for i = 0, Map.Monsters.High do
		monster = Map.Monsters[i]
		name = monster.Name
		if not (name == "Peasant")
		then
			level = monster.Level
			sd = sd + (level - naive)^2
		end
	end

	return (naive + (sd/total_monsters) ^(1/2) * 0.68)
end

function gatherMapMonsterLevels()
	msIndex = Map.MapStatsIndex

	mapName = Game.MapStats[msIndex].Name
	folderName = dumps_folder

	file = io.open(folderName .. '/' .. mapName .. '.txt',"w+")
	
	local total_monsters = 0
	local total_levels = 0
	local debug_string = ''
	local total_exp = 0

	for i=0, Map.Monsters.High do
		local name = Map.Monsters[i].Name
		if not (name == "Peasant") then
			total_monsters = total_monsters + 1
			local level = Map.Monsters[i].Level
			total_levels = total_levels + level
			total_exp = total_exp + Map.Monsters[i].Experience
			debug_string = i .. '\t' .. name .. '\t ' .. level
			file:write(debug_string)
		end
	end
	
	if (total_monsters == 0) then
		total_monsters = 1
	end
	
	local naive = total_levels / total_monsters
	local adjusted = calculateAdjustedAverage(total_levels, total_monsters)
	
	debug_string = '\n\nNaive Average for ' .. mapName .. ': ' .. total_levels .. '/' .. total_monsters .. '=' .. naive 
	debug_string = debug_string .. '\nAdjusted Average for ' .. mapName .. ': ' .. adjusted
	debug_string = debug_string .. '\nTotal Monster EXP for ' .. mapName .. ': ' .. total_exp
	
	file:write(debug_string)
	file:close()
end

function events.LoadMap()
	if pcall(gatherMapMonsterLevels) then
		gatherMapMonsterLevels()
	else
		
	end
end
