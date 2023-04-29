-- SKEM INITIALIZE
-- reads settings from mm6.ini File 

local ini = require "inifile"

local UPDATE_INI = false

local PRESETS = {
	["ImprovedQuestItems"] = true,
	["RandomizeMapClusters"] = false,
	["AdaptiveMonsterMode"] = "disabled",
	["ResistancesDisplayMode"] = "default",
	["EasierMonsters"] = false,
	["MoreLinkedSkills"] = false,
	["ShowDiceInSpellDescription"] = false,
	["MonsterExperienceMultiplier"] = 1.00,
	["GlobalMapResetDays"] = "default",
	["DifficultyModifier"] = 1.00,
	HomingProjectiles = true,
	["KnightAsBloodKnight"] = false,
	["KnightAsGreyKnight"] = false,
	["ArcherAsAssassin"] = false,
	["ArcherAsAshikari"] = false,
	["PaladinAsBerseker"] = false,
	["SorcererAsNecromancer"] = false,
	["ClericAsSeraphin"] = false,
	["ImbaSubClasses"] = false,
	["SorcererAsShadow"] = false,
	["DruidAsHerbalist"] = false,
	["DruidAsShaman"] = false,
	["EqualizedMode"] = false,
	["ItemRework"] = false,
	["StatsRework"] = false,
}

SETTINGS = { }

local INIT = ini.parse("mm6.ini")

if (INIT["Skill Emphasis"] == nil) then
	UPDATE_INI = true
	INIT["Skill Emphasis"] = {}
	for k,v in pairs(PRESETS) do
		SETTINGS[k] = v
		INIT["Skill Emphasis"][k] = v
	end
end

for k,d in pairs(PRESETS) do
	if (INIT["Skill Emphasis"][k] == nil) then
		UPDATE_INI = true
		INIT["Skill Emphasis"][k] = d
	end
	v = INIT["Skill Emphasis"][k]
	SETTINGS[k] = v
end

if not (UPDATE_INI == false) then
	ini.save("mm6.ini",INIT)
end
