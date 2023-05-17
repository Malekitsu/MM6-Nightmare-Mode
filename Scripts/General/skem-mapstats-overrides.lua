--[[

Map Stats Overrides for Skill Emphasis Mod

 -- for overriding Map Reload timers
 -- for replacing one monster type with another
 
 supersedes 'skem-monster-move.lua' and 'refresh-timers.lua'
 
 0.8.5 - added "RANDO" flag - setting it to true will cause the game to assign monsters randomly to maps at GameInitialized2
 
]]

-- set BATS to true to enable "Oops, All Bats" mode

local BATS = false

-- set RANDO to true to randomly assign monster types to the various maps
-- this never changes The Hive or The Arena
-- this should re-randomize on each game load, so pair with reset never for best results (or reset 0 for most chaotic)
-- this has no effect if BATS == true

local RANDO = SETTINGS["RandomizeMapClusters"]
local ADAPTIVE = SETTINGS["AdaptiveMonsterMode"]

local WEEK = 7
local YEAR = WEEK * 52
local CENTURY = YEAR * 100
local NEVER = math.huge

local globalReset = SETTINGS["GlobalMapResetDays"]

if ((globalReset == nil) or (string.lower(globalReset) == 'default'))
then
	globalReset = nil
elseif (string.lower(globalReset) == 'never')
then
	globalReset = math.huge
elseif (string.lower(globalReset) == 'instant')
then
	globalReset = 0
elseif (type(globalReset) == 'number' ) 
then
	globalReset = globalReset
else
	globalReset = nil
end



-- Maps are ordered by ID, starting from 1

debug_string = ""

MAPS = {
	"Sweet Water",
	"Paradise Valley",
	"Hermit's Isle",
	"Kriegspire",
	"Blackshire",
	"Dragonsand",
	"Frozen Highlands",
	"Free Haven",
	"Mire of the Damned",
	"Silver Cove",
	"Bootleg Bay",
	"Castle Ironfist",
	"Eel Infested Waters",
	"Misty Islands",
	"New Sorpigal",
	"Goblinwatch",
	"Abandoned Temple",
	"Shadow Guild Hideout",	
	"Hall of the Fire Lord",
	"Snergle's Caverns",
	"Dragoons' Caverns",
	"Silver Helm Outpost",
	"Shadow Guild",
	"Snergle's Iron Mines",
	"Dragoons' Keep",
	"Corlagon's Estate",
	"Silver Helm Stronghold",
	"The Monolith",
	"Tomb of Ethric the Mad",
	"Icewind Keep",
	"Warlord's Fortress",
	"Lair of the Wolf",
	"Gharik's Forge",
	"Agar's Laboratory",
	"Caves of the Dragon Riders",
	"Temple of Baa",
	"Temple of the Fist",
	"Temple of Tsantsa",
	"Temple of the Sun",
	"Temple of the Moon",
	"Supreme Temple of Baa",
	"Superior Temple of Baa",
	"Temple of the Snake",
	"Castle Alamos",
	"Castle Darkmoor",
	"Castle Kriegspire",
	"Free Haven Sewer",
	"Tomb of VARN",
	"Oracle of Enroth",
	"Control Center",
	"The Hive",
	"The Arena",
	"Dragon's Lair",
	"zddb02.blv",
	"zddb03.blv",
	"zddb04.blv",
	"zddb05.blv",
	"zddb06.blv",
	"zddb07.blv",
	"zddb08.blv",
	"zddb09.blv",
	"zddb10.blv",
	"zdtl01.blv",
	"zdtl02.blv",
	"zdwj01.blv",
	"Devil Outpost",
	"New World Computing",
}

MapIDs = { }
for i,v in ipairs(MAPS) do
	MapIDs[v] = i
end

-- Regional Reset stuff

localResets = {
	[MapIDs["The Arena"]] = 0,
	[MapIDs["zddb09.blv"]] = 7,
	[MapIDs["New Sorpigal"]] = 672,
}



function changeAllRegionResets()
	for i = 1, Game.MapStats.high do
		orig = Game.MapStats[i]["RefillDays"]
		if not (localResets[i] == nil)
		then
			Game.MapStats[i]["RefillDays"] = localResets[i]
		elseif not (globalReset == nil) 
		then
			Game.MapStats[i]["RefillDays"] = globalReset
		else
			Game.MapStats[i]["RefillDays"] = orig
		end
	end
end

-- Monster Substitutions stuff

localSubstitutions = {  
	[MapIDs["Silver Helm Outpost"]] = { Monster1Pic = "Thief", Monster3Pic = "PeasantF3" },
	[MapIDs["Frozen Highlands"]] = { Monster2Pic = "Archer", Monster3Pic = "Ogre" },
	[MapIDs["Temple of Baa"]] = { Monster1Pic = "Monk" },
	[MapIDs["Free Haven Sewer"]] = { Monster2Pic = "Monk" },
	[MapIDs["Castle Darkmoor"]] = { Monster3Pic = "KnightPlate" },
}

function monsterSubstitutions()
	for i = 1, Game.MapStats.high do
		if BATS == true 
		then
			for j = 1, 3 do
				key = "Monster" .. j .. "Pic"
				Game.MapStats[i][key] = "Bat"
			end
		elseif RANDO == true
		then
			applyRandomMonsters(i)	
		else
			if not (localSubstitutions[i] == nil) then
				for j = 1, 3 do
					key = "Monster" .. j .. "Pic"
					if not (localSubstitutions[i][key] == nil) then
						Game.MapStats[i][key] = localSubstitutions[i][key]
					end
				end
			end	
		end
	end			
end

function applyRandomMonsters(i)
	if not ((i == MapIDs["The Hive"]) or (i == MapIDs["The Arena"]))
	then
		debug_string = debug_string .. "\n" .. MAPS[i] .. ": "
		for j = 1, 3 do
			selection = math.random(Game.MonstersTxt.high - 2)
			value = Game.MonstersTxt[selection]["Picture"]
			value = value:sub(1,-2)
			if ((value == "PeasantF1") or (value == "PeasantF2"))
			then
				value = "PeasantF3"
			elseif (value == "PeasantM1")
			then
				value = "Merchant"
			end
			key = "Monster" .. j .. "Pic"
			Game.MapStats[i][key] = value
			debug_string = debug_string .. value .. ", "
		end
	end
end

function checkSeed()
	if (vars["Seed"] == nil)
	then
		vars["Seed"] = os.time()
		math.randomseed(vars["Seed"])
	end
end

function events.AfterNewGameAutosave()
	checkSeed()
end

function events.BeforeSaveGame()
	checkSeed()
end

function events.BeforeMapLoad()
	checkSeed()
end

function events.GameInitialized2()
	changeAllRegionResets()
	monsterSubstitutions()
end

function events.GameInitialized2()
Game.MapStats[62].Monster1Pic = "Minotaur"
Game.MapStats[62].Monster2Pic = "Lich"
Game.MapStats[62].Monster3Pic = "KnightPlate"
Game.MapStats[62].Mon1Low = 6
Game.MapStats[62].Mon1High = 8
Game.MapStats[62].Mon2Low = 4
Game.MapStats[62].Mon2High= 6
Game.MapStats[62].Mon3Low = 3
Game.MapStats[62].Mon3High= 5
Game.MapStats[62].Name="Unknown"
Game.MapStats[62].Mon1Dif = 5
Game.MapStats[62].Mon2Dif = 5
Game.MapStats[62].Mon3Dif = 5
Game.MapStats[61].Name = "Celestial Arena"
Game.MapStats[61].Trap = 0
Game.MapStats[61].RedbookTrack = 10
end
