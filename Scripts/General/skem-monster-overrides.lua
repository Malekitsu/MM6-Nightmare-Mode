-- Monster Customization stuff from Skill Emphasis Mod

--[[ EASY MODE
	Shallower curves for the Damage Multiplier, and Energy attacks are not multiplied
	Every monster will drop at least 1 gold, and increases the number of dice rolled for gold drops by 1
	Scales resistances so that they're relative to the resist cap, instead of only reducing immunity to the resist cap
	Forces all flying monsters to attempt to engage in melee 
]]

local EASY_OVERRIDES = SETTINGS["EasierMonsters"]

--[[ ADAPTIVE MODE - Monsters are changed after spawn:
	Preset (not implemented) - relative to preset "Map Level" values
	Map - relative to average monster level for that map
	Party - relative to party level
	Disabled (default) - monsters are not changed after spawn.
]]

local ADAPTIVE = string.lower(SETTINGS["AdaptiveMonsterMode"])
if ((ADAPTIVE == "default") or (ADAPTIVE == "disabled")) then
	ADAPTIVE = "disabled"
elseif not ((ADAPTIVE == "preset") or (ADAPTIVE == "map") or (ADAPTIVE == "100") or (ADAPTIVE == "party")) then
	error("Recoverable error: Adaptive Mode '" .. tostring(ADAPTIVE) .. "' not yet handled.  Falling back to default (non-adaptive) behavior.",2) 
	ADAPTIVE = "disabled"
else
	debug.Message("Adaptive mode " .. ADAPTIVE .. " enabled.")
end

-- the resist_cap is the highest resistance that generic monsters are allowed to have
-- in the absence of core Skill Emphasis (or other immunity removal mods), "Unique" monsters are still allowed to be immune to stuff
local resist_cap = 120

-- EnergyMod
-- This is a divisor applied to Energy attacks
-- the larger this number, the weaker Energy attacks become
-- if EASY_OVERRIDES == true, this is ignored entirely (under Easy Mode, energy attacks are not multiplied at all)
local EnergyMod = 2

-- base multipliers
-- these multipliers are applied after monster customizations and EZ-exclusive tech are applied
-- defaults are 2 for Health, 2 for Gold, 1 for Armor, 1.09 for Experience
-- Health and Armor use the greater of the original or calculated values; multipliers less than 1 have no effect.
local baseHealthMultiplier = 2
local baseArmorMultiplier = 1

-- Gold and Experience will always set calculated (to permit Zero Monster EXP games)
local baseGoldMultiplier = 2
local baseExperienceMultiplier = SETTINGS["MonsterExperienceMultiplier"]

local dmesg = ''

-- masteries text

local masteries =
{
	[const.Novice] = "n",
	[const.Expert] = "e",
	[const.Master] = "m",
}

-- attack types text

local attackTypes =
{
	[const.Damage.Phys] = "Phys",
	[const.Damage.Magic] = "Magic",
	[const.Damage.Fire] = "Fire",
	[const.Damage.Elec] = "Elec",
	[const.Damage.Cold] = "Cold",
	[const.Damage.Poison] = "Poison",
	[const.Damage.Energy] = "Energy",
}

resistanceTypes = { }
for k,v in pairs(attackTypes) do
	if not (v == "Energy")
	then
		resistanceTypes[v] = k
	end
end

-- missiles

local missiles =
{
	["Arrow"] = 1,
	["FireArrow"] = 2,
	["Fire"] = 3,
	["Elec"] = 4,
	["Cold"] = 5,
	["Poison"] = 6,
	["Energy"] = 7,
	["Magic"] = 8,
	["Rock"] = 9,
}

local spellTxtIds = { }

local monsterInfos =
{
	--Maddening Eye
	[12] = {["SpellChance"] = 2, ["Spell"] = "Dispell Magic", ["SpellSkill"] = JoinSkill(10, const.Novice), },
	--[[Priest of Baa
	[16] = 
	{["Name"]= "Priest of Baa",["FullHP"] = 220,["Level"] = 40, ["ArmorClass"]=40,["Experience"]= 1144,["Attack1"] = {["Type"] = const.Damage.Elec, ["DamageDiceCount"] = 6, ["DamageDiceSides"] = 6, ["DamageAdd"] = 0, ["Missile"] = missiles["Elec"], },},
	--Bishop of Baa
	[17] = 
	{["Name"]= "Bishop of Baa",["FullHP"] = 340,["Level"] = 50,["ArmorClass"]=50,["Experience"]= 2375,["Attack1"] = {["Type"] = const.Damage.Elec, ["DamageDiceCount"] = 7, ["DamageDiceSides"] = 6, ["DamageAdd"] = 5, ["Missile"] = missiles["Elec"], },["Spell"] = "Harm", ["SpellSkill"] = JoinSkill(6, const.Master),},
	--Cardinal of Baa
	[18] = 
	{["Name"]= "Cardinal of Baa",["FullHP"] = 510,["Level"] =60,["ArmorClass"]=60,["Experience"]= 4000,["Attack1"] = {["Type"] = const.Damage.Elec, ["DamageDiceCount"] = 10, ["DamageDiceSides"] = 6, ["DamageAdd"] = 10, ["Missile"] = missiles["Elec"], },["Spell"] = "Flying Fist", ["SpellSkill"] = JoinSkill(6, const.Master),},
	--devil Spawn
	[28] = {["FullHP"] = 190,["Level"] = 50,["ArmorClass"]=40,["Experience"]= 2800, ["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 4, ["DamageDiceSides"] = 6, ["DamageAdd"] = 8,},["Attack2"] = {["Type"] = const.Damage.Fire, ["DamageDiceCount"] = 2, ["DamageDiceSides"] = 26, ["DamageAdd"] = 4, ["Missile"] = missiles["Fire"], },["SpellChance"] = 20, ["SpellName"] = "Fire Bolt", ["SpellSkill"] = JoinSkill(12, const.Master),},
	--devil Worker
	[29] = {["FullHP"] = 480,["Level"] = 60,["ArmorClass"]=60,["Experience"]= 4800, ["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 5, ["DamageDiceSides"] = 6, ["DamageAdd"] = 20,},["Attack2"] = {["Type"] = const.Damage.Poison, ["DamageDiceCount"] = 3, ["DamageDiceSides"] = 26, ["DamageAdd"] = 10, ["Missile"] = missiles["Poison"], },["SpellChance"] = 20, ["SpellName"] = "Fire Bolt", ["SpellSkill"] = JoinSkill(13, const.Master),},
	--devil Warrior
	[30] = {["FullHP"] = 600,["Level"] = 70,["ArmorClass"]=80,["Experience"]= 6500, ["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 5, ["DamageDiceSides"] = 6, ["DamageAdd"] = 30,},["Attack2"] = {["Type"] = const.Damage.Fire, ["DamageDiceCount"] = 3, ["DamageDiceSides"] = 26, ["DamageAdd"] = 14, ["Missile"] = missiles["Fire"], },["SpellChance"] = 20, ["SpellName"] = "Fireball", ["SpellSkill"] = JoinSkill(6, const.Master),["Bonus"] = 0, ["BonusMul"] = 0},
	--devil captain
	[25] = {["FullHP"] = 750,["Level"] = 80,["ArmorClass"]=80, ["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 16, ["DamageDiceSides"] = 6, ["DamageAdd"] = 20,},["Attack2"] = {["Type"] = const.Damage.Cold, ["DamageDiceCount"] = 6, ["DamageDiceSides"] = 13, ["DamageAdd"] = 23, ["Missile"] = missiles["Cold"], },},
	--Devil Master
	[26] = {["FullHP"] = 950,["Level"] = 90,["ArmorClass"]=90, ["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 17, ["DamageDiceSides"] = 8, ["DamageAdd"] = 20,},["Attack2"] = {["Type"] = const.Damage.Elec, ["DamageDiceCount"] = 6, ["DamageDiceSides"] = 13, ["DamageAdd"] = 32, ["Missile"] = missiles["Elec"], },["SpellChance"] = 20, ["SpellName"] = "Meteor Shower", ["SpellSkill"] = JoinSkill(3, const.Master),},	
	--Devil King
	[27] = { ["FullHP"] = 1150,["Level"] = 100,["ArmorClass"]=100, ["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 20, ["DamageDiceSides"] = 9, ["DamageAdd"] = 20,},["Attack2"] = {["Type"] = const.Damage.Magic, ["DamageDiceCount"] = 6, ["DamageDiceSides"] = 13, ["DamageAdd"] = 39, ["Missile"] = missiles["Magic"], },["Bonus"] = 0, ["BonusMul"] = 0},
	]]
	--Defender of VARN
	[88] = {["SpellChance"] = 20, ["Spell"] = "Psychic Shock", ["SpellSkill"] = JoinSkill(4, const.Master), },
	--Sentinel of VARN
	[89] = {["SpellChance"] = 20, ["Spell"] = "Psychic Shock", ["SpellSkill"] = JoinSkill(6, const.Master), },
	--Guardian of VARN
	[90] = {["SpellChance"] = 20, ["Spell"] = "Psychic Shock", ["SpellSkill"] = JoinSkill(7, const.Master), },
	--Lich
	[94] = {["SpellChance"] = 1, ["Spell"] = "Dispell Magic", ["SpellSkill"] = JoinSkill(10, const.Novice), },
	--Greater Lich
	[95] = {["SpellChance"] = 1, ["Spell"] = "Dispell Magic", ["SpellSkill"] = JoinSkill(10, const.Novice), },
	--Gorgon
	[102] = {["SpellChance"] = 30, ["Spell"] = "Psychic Shock", ["SpellSkill"] = JoinSkill(5, const.Master), },
	--Minotaur
	[106] = {["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 3, ["DamageDiceSides"] = 7, ["DamageAdd"] = 25,},},
	--Minotaur Mage
	[107] = {["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 6, ["DamageDiceSides"] = 7, ["DamageAdd"] = 28,},},
	--Minotaur King
	[108] = {["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 9, ["DamageDiceSides"] = 7, ["DamageAdd"] = 36,},},
	--Titan
	[166] = {["Attack1"] = {["Type"] = const.Damage.Elec, ["DamageDiceCount"] = 7, ["DamageDiceSides"] = 20, ["DamageAdd"] = 10,["Missile"] = missiles["Elec"],},["SpellChance"] = 50, ["Spell"] = "Psychic Shock", ["SpellSkill"] = JoinSkill(8, const.Master), ["PhysResistance"] = 10, },
	--Noble Titan
	[167] = {["Attack1"] = {["Type"] = const.Damage.Elec, ["DamageDiceCount"] = 8, ["DamageDiceSides"] = 20, ["DamageAdd"] = 20,["Missile"] = missiles["Elec"],},["SpellChance"] = 50, ["Spell"] = "Psychic Shock", ["SpellSkill"] = JoinSkill(9, const.Master), ["PhysResistance"] = 15, },
	--Supreme Titan
	[168] = {["Attack1"] = {["Type"] = const.Damage.Elec, ["DamageDiceCount"] = 11, ["DamageDiceSides"] = 20, ["DamageAdd"] = 30,["Missile"] = missiles["Elec"],},["SpellChance"] = 50, ["Spell"] = "Psychic Shock", ["SpellSkill"] = JoinSkill(13, const.Master), ["PhysResistance"] = 20, },
	-- Follower of Baa
	[139] = {["SpellChance"] = 10, ["Spell"] = "Mind Blast", ["SpellSkill"] = JoinSkill(2, const.Novice), },
	-- Mystic of Baa
	[140] = {["SpellChance"] = 30, ["Spell"] = "Mind Blast", ["SpellSkill"] = JoinSkill(4, const.Novice), },
	-- Fanatic of Baa
	[141] = {["SpellChance"] = 50, ["Spell"] = "Mind Blast", ["SpellSkill"] = JoinSkill(6, const.Novice), },
	-- Cannibal (female)
	[130] = {["SpellChance"] = 10, ["Spell"] = "Deadly Swarm", ["SpellSkill"] = JoinSkill(3, const.Novice), },
	-- Head Hunter (female)
	[131] = {["SpellChance"] = 20, ["Spell"] = "Deadly Swarm", ["SpellSkill"] = JoinSkill(4, const.Novice), },
	-- Witch Doctor (female)
	[132] = {["SpellChance"] = 30, ["Spell"] = "Deadly Swarm", ["SpellSkill"] = JoinSkill(6, const.Novice), },
	-- Cannibal (male)
	[142] = {["SpellChance"] = 10, ["Spell"] = "Fire Bolt", ["SpellSkill"] = JoinSkill(3, const.Novice), },
	-- Head Hunter (male)
	[143] = {["SpellChance"] = 20, ["Spell"] = "Fire Bolt", ["SpellSkill"] = JoinSkill(4, const.Novice), },
	-- Witch Doctor (male)
	[144] = {["SpellChance"] = 30, ["Spell"] = "Fire Bolt", ["SpellSkill"] = JoinSkill(6, const.Novice), },
	--Malekith rebalance
	--skeleton
	[154] = {["SpellChance"] = 10, ["Spell"] = "Fire Bolt", ["SpellSkill"] = JoinSkill(3, const.Novice), },
	-- Skeleton Knight
	[155] = {["SpellChance"] = 20, ["Spell"] = "Fire Bolt", ["SpellSkill"] = JoinSkill(6, const.Novice), },
	-- Skeleton Lord
	[156] = {["SpellChance"] = 30, ["Spell"] = "Fire Bolt", ["SpellSkill"] = JoinSkill(9, const.Novice), },
	--Magyar
	 [  4] = {["SpellChance"] = 10, ["Spell"] = "Lightning Bolt", ["SpellSkill"] = JoinSkill(8, const.Master), },
	-- Magyar Soldier
	 [  5] = {["SpellChance"] = 20, ["Spell"] = "Lightning Bolt", ["SpellSkill"] = JoinSkill(12, const.Master), },
	-- Goblin
	[ 76] = {["SpellChance"] = 10, ["Spell"] = "Fire Bolt", ["SpellSkill"] = JoinSkill(2, const.Novice), },
	-- Goblin Shaman
	[ 77] = {["SpellChance"] = 20, ["Spell"] = "Fire Bolt", ["SpellSkill"] = JoinSkill(4, const.Novice), },
	-- Goblin King
	[ 78] = {["SpellChance"] = 30, ["Spell"] = "Fire Bolt", ["SpellSkill"] = JoinSkill(6, const.Novice), },
	-- Ghost
	[ 73] = {["SpellChance"] = 10, ["Spell"] = "Mind Blast", ["SpellSkill"] = JoinSkill(5, const.Novice), },
	-- Evil Spirit
	[ 74] = {["SpellChance"] = 20, ["Spell"] = "Psychic Shock", ["SpellSkill"] = JoinSkill(2, const.Novice), },
	-- Specter
	[ 75] = {["SpellChance"] = 30, ["Spell"] = "Psychic Shock", ["SpellSkill"] = JoinSkill(4, const.Novice), },
	--Initiate Monk
	[110] = {["FullHP"] = 50,["Level"] =12,["Experience"]= 264,["Attack1"] = {["Type"] = const.Damage.Elec, ["DamageDiceCount"] = 2, ["DamageDiceSides"] = 4, ["DamageAdd"] = 4, ["Missile"] = missiles["Elec"], }, ["SpellChance"] = 20, ["SpellName"] = "Lightning Bolt", ["SpellSkill"] = JoinSkill(2, const.Novice), },
	--Master Monk
	[111] = {["FullHP"] = 73,["Level"] =16,["Experience"]= 416,["ArmorClass"]=22,["Attack1"] = {["Type"] = const.Damage.Cold, ["DamageDiceCount"] = 2, ["DamageDiceSides"] = 4, ["DamageAdd"] = 8, ["Missile"] = missiles["Cold"], }, ["SpellChance"] = 20, ["SpellName"] = "Ice Bolt", ["SpellSkill"] = JoinSkill(4, const.Novice), ["MagicResistance"] = 30,},	
	-- steal crash workaround	
	-- Cutpurse
	[127] = {["Bonus"] = 0, ["BonusMul"] = 0},
	-- Bounty Hunter
	[128] = {["Bonus"] = 0, ["BonusMul"] = 0},
	-- Thief
	[163] = {["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 3, ["DamageDiceSides"] = 4, ["DamageAdd"] = 0,},["Attack2"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 3, ["DamageDiceSides"] = 4, ["DamageAdd"] = 3,},["Level"] = 6,["FullHP"] = 21, ["ArmorClass"]=8, ["Experience"]= 96, ["Bonus"] = 0, ["BonusMul"] = 0},
	-- Burglar
	[164] = {["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 3, ["DamageDiceSides"] = 4, ["DamageAdd"] = 3,},["Attack2"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 3, ["DamageDiceSides"] = 4, ["DamageAdd"] = 6,},["Level"] = 8,["FullHP"] = 30, ["ArmorClass"]=10, ["Experience"]= 144, ["Bonus"] = 0, ["BonusMul"] = 0},
	-- Rogue
	[165] = {["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 3, ["DamageDiceSides"] = 4, ["DamageAdd"] = 6,},["Attack2"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 3, ["DamageDiceSides"] = 4, ["DamageAdd"] = 9,},["Level"] = 12,["FullHP"] = 50, ["ArmorClass"]=14, ["Experience"]= 264, ["Bonus"] = 0, ["BonusMul"] = 0},
	--Swordsman A
	--[112] = {["FullHP"] = 217,["Level"] = 34,["ArmorClass"]=40, ["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 7, ["DamageDiceSides"] = 7, ["DamageAdd"] = 12,}, ["Experience"]= 1496},
	--Swordsman B
	--[113] = {["FullHP"] = 325,["Level"] = 44,["ArmorClass"]=50, ["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 8, ["DamageDiceSides"] = 7, ["DamageAdd"] = 16,}, ["Experience"]= 2376},
	--Swordsman C
	--[114] = {["FullHP"] = 453,["Level"] = 54,["ArmorClass"]=60, ["Attack1"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 9, ["DamageDiceSides"] = 7, ["DamageAdd"] = 20,},["Attack2"] = {["Type"] = const.Damage.Phys, ["DamageDiceCount"] = 9, ["DamageDiceSides"] = 7, ["DamageAdd"] = 50}, ["Experience"]= 3456},


	--The Unpeasanting
	[103] = {["Name"] = "Manservant", ["Level"] = 4,},
	[104] = {["Name"] = "Craftsman", ["Level"] = 6,},
	[105] = {["Name"] = "Merchantman", ["Level"] = 10, },

	[124] = {["Name"] = "Maidservant", ["Level"] = 2, },
	[125] = {["Name"] = "Craftswoman", ["Level"] = 6, },
	[126] = {["Name"] = "Merchantess", ["Level"] = 10, },
	
	-- reduced phys resist for Dragon
	[40] = {["PhysResistance"] = 10,},
	[41] = {["PhysResistance"] = 15,},
	[42] = {["PhysResistance"] = 20,},
}

-- mergeTables function, from https://stackoverflow.com/a/29133654
function mergeTables(a, b)
    if (type(a) == 'table' and type(b) == 'table') then
        for k,v in pairs(b) do 
		if (type(v)=='table' and type(a[k] or false)=='table') then 
			mergeTables(a[k],v) 
		else 
			a[k]=v 
		end 
	end
    end
    return a
end

function calculateTierLevelOffset(monsterArray)
	id = monsterArray["Id"]
	name = monsterArray["Name"]
	genericArray = Game.MonstersTxt[id]
	if not (name == genericArray["Name"])
	then
		return 10
	else
		pic = genericArray["Picture"]
		tier = string.sub(pic, -1)
		if (tier == "A")
		then
			tierBLev = Game.MonstersTxt[id+1]["Level"]
			return genericArray["Level"] - tierBLev
		elseif (tier == "C")
		then
			tierBLev = Game.MonstersTxt[id-1]["Level"]
			return genericArray["Level"] - tierBLev
		else
		return 0
		end
	end
end

function calculateMonsterArmor(monsterArray)
	oldArmor = monsterArray["ArmorClass"]
	newArmor = oldArmor * baseArmorMultiplier
	return math.max(newArmor, oldArmor)
end

function calculateMovespeed(monsterArray) 
	speed = monsterArray["MoveSpeed"]
	if (speed > 0)
	then
		if (monsterArray["Attack1"]["Missile"] == 0)
		then
			speed = (speed + (400 - speed) / 2 + 100) * 101 / 100
		else
			speed = speed * 99 / 100
		end
	end
	return speed
end

function applyMonsterResistanceAdjustments(MonsterID, easy_flag)
	for k,_ in pairs(resistanceTypes)
	do
		key = k .. "Resistance"
		value = Game.MonstersTxt[MonsterID][key]
		if (easy_flag == true) 
		then
			Game.MonstersTxt[MonsterID][key] = value * resist_cap / 200
		else
			Game.MonstersTxt[MonsterID][key] = math.min(value, resist_cap)
		end
	end
end

function calculatePartyAverage()
	total_exp = 0
	for i=0, 3 
	do
		total_exp = total_exp + Party.Players[i].Experience
	end
	average = total_exp / 4
	level = math.floor((1 + math.sqrt(1 + (4 * average/ 500))) / 2)
	return level
end

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

function calculateMapAverage()
	total_levels = 0
	total_monsters = 0
	debug_string = ""

	for i=0, Map.Monsters.High
	do
		if not (Map.Monsters[i].Name == "Peasant")
		then
			total_monsters = total_monsters + 1
			total_levels = total_levels + Map.Monsters[i].Level
		end
	end

	mapAvgLevel = calculateAdjustedAverage(total_levels, total_monsters)
	return mapAvgLevel
end

function getAdaptiveMultiplier(switch)
	if (switch == "preset") 
	then
		output = getAdaptiveMultiplier("map")
	elseif (switch == "map") 
	then
		mode = "Map"
		output = calculateMapAverage()
	elseif (switch == "party") 
	then
		mode = "Party"
		output = calculatePartyAverage()
	else
		
		output = getAdaptiveMultiplier("map")
	end
	
	return output
end

function calculateDamageMultiplier(level, divisor, constant)
	multiplier = (level + 5) / divisor + constant
	return multiplier
end

function calculateMonsterExperience(monsterArray)
	old_exp = monsterArray["Experience"]
	new_exp = old_exp * baseExperienceMultiplier
	return new_exp
end

function calculateMonsterHealth(monsterArray)
	level = monsterArray["Level"]
	oldHealth = monsterArray["FullHitPoints"]
	healthMod = 1
	
	--HEALTH FIX FOR ITEM/STATS REWORK
	if SETTINGS["ItemRework"]==true and SETTINGS["StatsRework"]==true then
	reworkMult = 1 * (1+level/200)
		else
		reworkMult = 1
	end
	-----------------------------------
	lookupID = monsterArray["Id"]
	pic = Game.MonstersTxt[lookupID]["Picture"]
	tier = string.sub(pic, -1)
	
	if (tier == "A")
	then
		tier3Level = Game.MonstersTxt[lookupID + 2]["Level"]
		if (tier3Level >= (level * 2))
	then
		healthMod = healthMod + tier3Level/(level * 5)
	end
	elseif (tier == "B")
	then
		tier3Level = Game.MonstersTxt[lookupID + 1]["Level"]
		if (tier3Level >= (Game.MonstersTxt[lookupID - 1]["Level"] * 2))
	then
		healthMod = healthMod + tier3Level/(level * 5)
	end
	else
		tier3Level = 0
	end
	
	
	
	newHealth = oldHealth * baseHealthMultiplier * healthMod * reworkMult
	return math.max(newHealth, oldHealth)
end

function calculateMonsterDamageMultipliers(monsterArray, easy_flag)
	lookupID = monsterArray["Id"]
	pic = Game.MonstersTxt[lookupID]["Picture"]
	tier = string.sub(pic, -1)
	
	divisor = 20
	constant = 1.75

	if (easy_flag == true)
	then
		divisor = 25
		constant = 1.25
	end
	
	if (tier == "A")
	then
		Monster2ID = lookupID + 1
	elseif (tier == "C")
	then
		Monster2ID = lookupID - 1
	else
		Monster2ID = lookupID
	end
	monsterLevel = Game.MonstersTxt[Monster2ID]["Level"]
	
	damageMultiplier = calculateDamageMultiplier(monsterLevel, divisor, constant)
	rankMultiplier = calculateDamageMultiplier(monsterLevel, 30, 1)
	return damageMultiplier, rankMultiplier
end

function calculateMonsterTreasures(monsterArray, easy_flag)
	if (easy_flag == true)
	then 
		extraBonus = 1
	else
		extraBonus = 0
	end

	baseDice = math.max(monsterArray["TreasureDiceCount"], extraBonus)
	baseSides = math.max(monsterArray["TreasureDiceSides"], extraBonus)
	
	sides = baseSides
	dice = math.min(baseDice * baseGoldMultiplier,250) 

	return dice, sides
end

function applyMonsterDamageMultipliers(monsterArray, damageMultiplier, rankMultiplier, easy_flag)
	genericForm = Game.MonstersTxt[monsterArray["Id"]]
	dampener = 1
	
	--FIX FOR ITEM/STATS REWORK
	if SETTINGS["ItemRework"]==true and SETTINGS["StatsRework"]==true then
	damageMultiplier = damageMultiplier*((monsterArray.Level^1.6-1)/1000+1)
	for i=1,173 do
	Game.MonstersTxt[i].Ally=2
	end
	end
	-----------------------------
	
	if (monsterArray.Level > 60)
	then
		local levelmod = monsterArray.Level - 60
		if levelmod > 50 then
			levelmod = 50
		end
		--dampener = 1 - (levelmod / 100)
		dampener = 1
	end

	for i=1,2 do
		key = "Attack" .. i
		dice = genericForm[key]["DamageDiceCount"]
		if not (dice == 0)
		then
			resist = genericForm[key]["Type"]
			sides = genericForm[key]["DamageDiceSides"]
			bonus = genericForm[key]["DamageAdd"] 
			if (resist == const.Damage.Energy)
			then
				if (easy_flag == true)
				then -- if it's easy mode, we don't apply any multipliers to Energy attacks
					sides = sides
					bonus = bonus 
				else -- if it's not easy mode, we apply multipliers and then divide by EnergyMod
					sides = sides * damageMultiplier / EnergyMod
					bonus = math.min(bonus * damageMultiplier / EnergyMod, 250)
				end
			elseif (resist == const.Damage.Phys) 	
			then
				sides = sides * damageMultiplier * dampener
				bonus = bonus * damageMultiplier
			else
				sides = sides * damageMultiplier
				
				bonus = bonus * damageMultiplier
			end
			if bonus>250 then
				overflowbonus=bonus-250
				bonus=250
				sides=(overflowbonus/dice)*2+sides
			end
			dmesg = monsterArray.Name .. ", Attack " .. i .. ": ".. genericForm[key]["DamageDiceCount"].."d"..genericForm[key]["DamageDiceSides"].."+"..genericForm[key]["DamageAdd"].." -> "..dice.."d"..sides.."+"..bonus
			-- if sides overflows, clamp sides to 250 and increase dice count 
			if (sides > 250) then
				fix = sides / 250
				dice = dice * fix
				sides = 250
				dmesg = dmesg .. ", fixed to " .. dice .. "d" .. sides .. "+" .. bonus
			end

			monsterArray[key]["DamageDiceCount"] = dice	
			monsterArray[key]["DamageDiceSides"] = sides
			monsterArray[key]["DamageAdd"] = bonus
		end
	end
--[[NOT NEEDED, MOVED IN SPELLSTAT OVERRIDE	
	if not(genericForm["SpellChance"] == 0)
	then
		local rank, mastery = SplitSkill(genericForm["SpellSkill"])
		
		if (easy_flag == true)
		then
			rank = math.max(1, math.floor(rank * rankMultiplier * 60 / 63))
		else
			rank = math.ceil(math.min(rank * rankMultiplier, 60))
		end
	
		monsterArray["SpellSkill"] = JoinSkill(rank, mastery)
	end
	--]]
end

function applyDirectMonsterOverrides(i)
-- set manual overrides first, so that they get iterated upon
	if not (monsterInfos[i] == nil)
	then
	--	debug.Message("Direct Overrides for " .. Game.MonstersTxt[i]["Name"])
		monsterInfos[i]["Spell"] = spellTxtIds[monsterInfos[i]["Spell"]]
		Game.MonstersTxt[i] = mergeTables(Game.MonstersTxt[i],monsterInfos[i])
	end	
end

function applyStaticMonsterOverrides(monsterID, easy_flag)
	monsterArray = Game.MonstersTxt[monsterID]
	i = monsterArray["Id"]
	-- debug.Message("Static Pass Overrides for " .. monsterArray["Name"])
	monsterArray["offset"] = calculateTierLevelOffset(monsterArray)
	offset = monsterArray["offset"]
	
	

	-- resistances
	applyMonsterResistanceAdjustments(monsterID, easy_flag)
	
	-- damage multipliers; calculated using a different level for Adaptive mode
	if ADAPTIVE == "disabled"
	then
		local damageMultiplier, rankMultiplier = calculateMonsterDamageMultipliers(monsterArray, easy_flag)
		applyMonsterDamageMultipliers(monsterArray, damageMultiplier, rankMultiplier, easy_flag)
	end
	
	-- other static adjustments
	monsterArray["Experience"] = calculateMonsterExperience(monsterArray)
	monsterArray["TreasureDiceCount"], monsterArray["TreasureDiceSides"] = calculateMonsterTreasures(monsterArray, easy_flag)
	monsterArray["FullHitPoints"] = calculateMonsterHealth(monsterArray)
	monsterArray["ArmorClass"] = calculateMonsterArmor(monsterArray)
	
	-- these changes are exclusive to easy mode
	if easy_flag == true
	then
		-- under easy mode, all fliers are melee
		if (monsterArray["Fly"] == 1 and not (monsterArray["Attack1"]["Missile"] == 0))
		then
			monsterArray["Attack1"]["Missile"] = 0
		end
	end
	
	-- always end with movespeed adjustments, since they depend on other adjustments
	monsterArray["MoveSpeed"] = calculateMovespeed(monsterArray)

	Game.MonstersTxt[monsterID] = mergeTables(Game.MonstersTxt[monsterID], monsterArray)
end

function applyAdaptiveMonsterOverrides(monsterID, monsterArray, adaptive_level)


	genericForm = Game.MonstersTxt[monsterArray["Id"]]

	oldLevel = math.max(genericForm["Level"],1)
	offset = calculateTierLevelOffset(genericForm)
	Mlevel = monsterArray["Level"]
	
	if Mlevel == oldLevel or adaptive_level > (Mlevel*0.7-5) then
	
	xLevel = (adaptive_level+2+offset/4*adaptive_level^0.2) *((57+math.random(1,30)+math.random(1,30))/100)
	newLevel = math.max(1, xLevel)
ItemMod = 1
if SETTINGS["ItemRework"]==true	then	
	ItemMod = (newLevel^1.15-1)/1000+1
			end
	if SETTINGS["StatsRework"]==true then
ItemMod = ItemMod * (newLevel^1.15-1)/1000+1
end

	levelMultiplier = (newLevel+1) / (oldLevel+1)

	bonusx1 = genericForm["Attack1"]["DamageAdd"]
	dicex1 = genericForm["Attack1"]["DamageDiceCount"]
	sidesx1 = genericForm["Attack1"]["DamageDiceSides"]
	
	bonusx1 = math.max(1, (bonusx1 * levelMultiplier * (newLevel/20 + 1.75)*ItemMod))
	sidesx1 = math.max(1, (sidesx1  * levelMultiplier^0.5 * (newLevel/20 + 1.75)*ItemMod))
	dicex1 = math.max(1, (dicex1 * levelMultiplier^0.5)*ItemMod)

	if bonusx1 > 250 then
	sidesx1 = sidesx1 + (bonusx1 - 250) / dicex1 * 2
	bonusx1 =250
	end
	
	monsterArray["Attack1"]["DamageAdd"] = bonusx1
	monsterArray["Attack1"]["DamageDiceCount"] = dicex1
	monsterArray["Attack1"]["DamageDiceSides"] = sidesx1

	if not (monsterArray["Attack2Chance"] == 0)
	then

	bonusx2 = genericForm["Attack2"]["DamageAdd"]
	dicex2 = genericForm["Attack2"]["DamageDiceCount"]
	sidesx2 = genericForm["Attack2"]["DamageDiceSides"]
	
	bonusx2 = math.max(1, (bonusx2 * levelMultiplier * (newLevel/20 + 1.75)*ItemMod))
	sidesx2 = math.max(1, (sidesx2 * levelMultiplier^0.5 * (newLevel/20 + 1.75)*ItemMod))
	dicex2 = math.max(1, (dicex2 * levelMultiplier^0.5*ItemMod))

	if bonusx2 > 250 then
	sidesx2 = sidesx2 + (bonusx2 - 250) / dicex2 * 2
	bonusx2 =250
	end
	
	monsterArray["Attack2"]["DamageAdd"] = bonusx2
	monsterArray["Attack2"]["DamageDiceCount"] = dicex2
	monsterArray["Attack2"]["DamageDiceSides"] = sidesx2


	elseif not (monsterArray["SpellChance"] == 0)
	then
		r,m = SplitSkill(genericForm["SpellSkill"])
		r = math.max(1, math.round(r * levelMultiplier/1.5*ItemMod))
		monsterArray["SpellSkill"] = JoinSkill(r,m)
	end


	monsterArray["FullHP"] = math.round(newLevel*(newLevel/10+3)) * 2 * ItemMod

	monsterArray["HP"] = math.round(newLevel*(newLevel/10+3)) * 2 * ItemMod

	monsterArray["ArmorClass"] = genericForm["ArmorClass"] * levelMultiplier
	monsterArray["Level"] = newLevel
	monsterArray["Experience"] = math.round(newLevel*(newLevel+10))
	monsterArray["TreasureDiceCount"] = genericForm["TreasureDiceCount"] * levelMultiplier^1.2
	monsterArray["TreasureItemPercent"] = genericForm["TreasureItemPercent"]*levelMultiplier
	monsterArray["TreasureItemLevel"] = genericForm["TreasureItemLevel"]+newLevel^0.4-oldLevel^0.39
	
	if (adaptive_level > genericForm["Level"])
	then
		for k,_ in pairs(resistanceTypes)
		do
			if not (k == "Energy")
			then
				key = k .. "Resistance"
				value = genericForm[key]
				value = value * (adaptive_level + 100)/(genericForm["Level"] + 100) + (adaptive_level - genericForm["Level"])/5
				monsterArray[key] = value
			end
		end
	end
	
	Map.Monsters[monsterID] = mergeTables(Map.Monsters[monsterID],monsterArray)
end
end

function applyAdaptiveMonsterOverrides100(monsterID, monsterArray, adaptive_level)


	genericForm = Game.MonstersTxt[monsterArray["Id"]]
	oldLevel = math.max(genericForm["Level"],1)
	offset = calculateTierLevelOffset(genericForm)
	Mlevel = monsterArray["Level"]

	if Mlevel == oldLevel or Mlevel == (200 + oldLevel) then
	xLevel = oldLevel * 1.25 + 100
	newLevel = math.max(1, xLevel)
ItemMod = 1
if SETTINGS["ItemRework"]==true	then	
	ItemMod = (newLevel^1.15-1)/1000+1
			end
	if SETTINGS["StatsRework"]==true then
ItemMod = ItemMod * (newLevel^1.15-1)/1000+1
end

	levelMultiplier = (100+2) / (oldLevel+2)
	

	bonusx1 = genericForm["Attack1"]["DamageAdd"]
	dicex1 = genericForm["Attack1"]["DamageDiceCount"]
	sidesx1 = genericForm["Attack1"]["DamageDiceSides"]
	damax1 = dicex1 *(1+sidesx1) / 2 + bonusx1
	
	bonusx1 = math.max(1, (bonusx1 * levelMultiplier * (newLevel/20 + 1.75)) *(newLevel/100)*ItemMod)
	sidesx1 = math.max(1, (sidesx1 * levelMultiplier^0.5 * (newLevel/20 + 1.75)^0.5) *(newLevel/100)^0.5*ItemMod)
	dicex1 = math.max(1, (dicex1 * levelMultiplier^0.5 * (newLevel/20 + 1.75)^0.5) *(newLevel/100)^0.5*ItemMod)

	if newLevel>35 and (genericForm["Attack1"]["Type"] == const.Damage.Phys) or (genericForm["Attack1"]["Type"] == const.Damage.Energy) then
	bonusx1 = bonusx1 * (60 - newLevel / 13) /100 * math.max(1, (oldLevel/damax1)^0.8)
	sidesx1 = sidesx1 * (60 - newLevel / 13 ) /100 * math.max(1, (oldLevel/damax1)^0.8)
	end	

	if bonusx1 > 250 then
	sidesx1 = sidesx1 + (bonusx1 - 250) / dicex1 * 2
	bonusx1 =250
	end
				
	if sidesx1 > 250 then
	dicex1 = dicex1 + (sidesx1 - 250) * dicex1 / 250
	sidesx1 = 250
	end
	
	monsterArray["Attack1"]["DamageAdd"] = bonusx1
	monsterArray["Attack1"]["DamageDiceCount"] = dicex1
	monsterArray["Attack1"]["DamageDiceSides"] = sidesx1

	if not (monsterArray["Attack2Chance"] == 0)
	then

	bonusx2 = genericForm["Attack2"]["DamageAdd"]
	dicex2 = genericForm["Attack2"]["DamageDiceCount"]
	sidesx2 = genericForm["Attack2"]["DamageDiceSides"]
	damax2 = dicex2 *(1+sidesx2) / 2 + bonusx2
			
	bonusx2 = math.max(1, (bonusx2 * levelMultiplier * (newLevel/20 + 1.75) *(newLevel/100)*ItemMod))
	sidesx2 = math.max(1, (sidesx2 * levelMultiplier^0.5 * (newLevel/20 + 1.75)^0.5) *(newLevel/100)^0.5*ItemMod)
	dicex2 = math.max(1, (dicex2 * levelMultiplier^0.5 * (newLevel/20 + 1.75)^0.5) *(newLevel/100)^0.5*ItemMod)

	if newLevel>35 and (genericForm["Attack2"]["Type"] == const.Damage.Phys) or (genericForm["Attack2"]["Type"] == const.Damage.Energy) then

	bonusx2 = bonusx2 * (60 - newLevel / 13) /100 * math.max(1, (oldLevel/damax2)^0.8)
	sidesx2 = sidesx2 * (60 - newLevel / 13 ) /100 * math.max(1, (oldLevel/damax2)^0.8)

	end

	if bonusx2 > 250 then
	sidesx2 = sidesx2 + (bonusx2 - 250) / dicex2 *2
	bonusx2 =250
	end
	
	if sidesx2 > 250 then
	dicex2 = dicex2 + (sidesx2 - 250) * dicex2 / 250
	sidesx2 = 250
	end	
			
	monsterArray["Attack2"]["DamageAdd"] = bonusx2
	monsterArray["Attack2"]["DamageDiceCount"] = dicex2
	monsterArray["Attack2"]["DamageDiceSides"] = sidesx2


	elseif not (monsterArray["SpellChance"] == 0)
	then
		r,m = SplitSkill(genericForm["SpellSkill"])
		r = math.max(1, math.round(r*ItemMod))
		monsterArray["SpellSkill"] = JoinSkill(r,m)
	end


	monsterArray["FullHP"] = math.round(100*(100/10+3)) * 2  * newLevel / 125

	monsterArray["HP"] = math.round(100*(100/10+3)) * 2  * newLevel / 125

	monsterArray["ArmorClass"] = genericForm["ArmorClass"] * levelMultiplier * newLevel / 100
	monsterArray["Level"] = newLevel
	monsterArray["Experience"] = math.round(newLevel*(newLevel+10)/3)
	monsterArray["TreasureDiceCount"] = genericForm["TreasureDiceCount"] * levelMultiplier
	monsterArray["TreasureDiceSides"] = genericForm["TreasureDiceSides"] * (newLevel / 100) * levelMultiplier
	monsterArray["TreasureItemPercent"] = (100-genericForm["TreasureItemPercent"])/5+genericForm["TreasureItemPercent"]
	monsterArray["TreasureItemLevel"] = genericForm["TreasureItemLevel"]+math.random(0,6-genericForm["TreasureItemLevel"])
	
	if (adaptive_level > 0)
	then
		for k,_ in pairs(resistanceTypes)
		do
			if not (k == "Energy")
			then
				key = k .. "Resistance"
				value = genericForm[key]
				value = value * 200/(genericForm["Level"]+100) + (120+genericForm["Level"]-value)/4
				monsterArray[key] = value
			end
		end
	end
	monsterArray["Magic".."Resistance"] = monsterArray["Magic".."Resistance"] + (255 - monsterArray["Magic".."Resistance"])/5
	Map.Monsters[monsterID] = mergeTables(Map.Monsters[monsterID],monsterArray)
end
end

mem.asmpatch(0x431A7D, [[
	mov ecx, dword [esi + 0x64] ; ecx - total experience award, esi - monster pointer, 0x64 - experience field offset
	jmp short ]] .. (0x431A8C - 0x431A7D)
, 0xF)

mem.asmpatch(0x431299, [[
	mov ecx, dword [esi + 0x64]
	jmp short ]] .. (0x4312A8 - 0x431299)
, 0xF)

mem.asmpatch(0x401937, [[
	mov ecx, dword [esi - 0x3C]
	jmp short ]] .. (0x401946 - 0x401937)
, 0xF)

function events.GameInitialized2()
	for spellTxtId = 1, Game.SpellsTxt.high do
		spellTxtIds[Game.SpellsTxt[spellTxtId].Name] = spellTxtId
	end
--	debug.Message("Direct Overrides")
	for monsterID = 1, Game.MonstersTxt.high do
		applyDirectMonsterOverrides(monsterID)
	end
--	debug.Message("Static Pass Overrides")
	for monsterID = 1, Game.MonstersTxt.high do
		applyStaticMonsterOverrides(monsterID, EASY_OVERRIDES)
	end
end

function events.LoadMap()
	if not (ADAPTIVE == "disabled")
	then
		adaptive_level = getAdaptiveMultiplier(ADAPTIVE)
		if (ADAPTIVE == "party") 
		then 
			if not (mapvars["adaptive"] == nil)
			then
				if not (adaptive_level > (mapvars["adaptive"] + 10))
				then
					adaptive_level = mapvars["adaptive"]
				else
					mapvars["adaptive"] = adaptive_level
				end
			else
				mapvars["adaptive"] = adaptive_level
			end
		end
		for monsterID = 0, Map.Monsters.high do
			monsterArray = Map.Monsters[monsterID]
			if not (monsterArray.Name == "Peasant")
			then
			if (ADAPTIVE == "100") then
				applyAdaptiveMonsterOverrides100(monsterID, monsterArray, adaptive_level)
			else
				applyAdaptiveMonsterOverrides(monsterID, monsterArray, adaptive_level)
			end
		end
--		 debug.Message("Adaptive Mode:  "..ADAPTIVE..", using Adaptive Level " .. adaptive_level)
	end
end
end
--[[ monster power spawn event
local idsToBasePics = {}
function events.GameInitialized2()
	local a, c = string.byte("ac", 1, 2)
	for i, v in Game.MonstersTxt do
		local pic = v.Picture:lower()
		if pic:len() > 0 then
			local byte = string.byte(pic:sub(-1))
			if byte >= a and byte <= c then
				pic = pic:sub(1, -2)
			end
			idsToBasePics[pic] = idsToBasePics[pic] or i
		end
	end
end
-- function events.RandomSpawnMonster(t)
-- t.Id = monster id
-- t.Power = monster power (1-3), pass 0 to skip this monster
-- supports only random power spawnpoints (doesn't fire on mxa/mxb/mxc spawnpoints, mx only)
mem.hook(0x455BF4, function(d)
	local pictureBase = mem.string(d.esp + 0x34):lower()
	local id = idsToBasePics[pictureBase] or error("Unknown monster pic (Game.MonstersTxt[n].Picture): " .. pictureBase)
	local t = {Id = id, Power = d.esi}
	events.call("RandomSpawnMonster", t)
	if t.Power == 0 then
		mem.u4[d.esp] = 0x455E76 -- return address
		return
	end
	t.Id = type(t.Id) == "number" and (t.Id - 1):Div(3) * 3 -- id before A variation (with Power it'll be right)
	local pic = t.Id ~= nil and Game.MonstersTxt[t.Id + t.Power] and Game.MonstersTxt[t.Id + t.Power].Picture or error("Invalid monster id in RandomSpawnMonster() event")
	mem.copy(d.esp + 0x5C, pic .. string.char(0))
	mem.u4[d.esp] = 0x455C3A
end, 6)

function events.RandomSpawnMonster(t)
	
end


function events.LoadMap()	
if SETTINGS["ItemRework"]==true and SETTINGS["StatsRework"]==true then
	for i=0, Map.Monsters.High do
	if not (Map.Monsters[i].Ally == 1) then
				Map.Monsters[i].Ally = 1
			Map.Monsters[i].FullHitPoints = Map.Monsters[i].FullHitPoints * (1+Map.Monsters[i].Level/200)
			Map.Monsters[i].HitPoints = Map.Monsters[i].HitPoints * (1+Map.Monsters[i].Level/200)
		
	-- bonus damage
				DamageMultiplier=(Map.Monsters[i].Level^1.5-1)/1000+1
				--attack 1
				a=Map.Monsters[i].Attack1.DamageAdd * DamageMultiplier
				Map.Monsters[i].Attack1.DamageAdd = Map.Monsters[i].Attack1.DamageAdd * DamageMultiplier
				b=Map.Monsters[i].Attack1.DamageDiceSides * DamageMultiplier
				Map.Monsters[i].Attack1.DamageDiceSides = Map.Monsters[i].Attack1.DamageDiceSides * DamageMultiplier
				
				--attack 2
				c=Map.Monsters[i].Attack2.DamageAdd * DamageMultiplier
				Map.Monsters[i].Attack2.DamageAdd = Map.Monsters[i].Attack2.DamageAdd * DamageMultiplier
				d=Map.Monsters[i].Attack2.DamageDiceSides * DamageMultiplier
				Map.Monsters[i].Attack2.DamageDiceSides = Map.Monsters[i].Attack2.DamageDiceSides * DamageMultiplier
				--OVERFLOW FIX
					--Attack 1 Overflow fix
					--add damage fix
					if (a > 250) then
					Overflow = a - 250
					Map.Monsters[i].Attack1.DamageAdd = 250
					b=b + (math.round(2*Overflow/Map.Monsters[i].Attack1.DamageDiceCount))
					Map.Monsters[i].Attack1.DamageDiceSides = b 
					end
					--Dice Sides fix
					if (b > 250) then
					Overflow = b / 250
					Map.Monsters[i].Attack1.DamageDiceSides = 250
					--checking for dice count overflow
					e = Map.Monsters[i].Attack1.DamageDiceCount * Overflow
					Map.Monsters[i].Attack1.DamageDiceCount = Map.Monsters[i].Attack1.DamageDiceCount * Overflow
					end
					--Just in case Dice Count fix
					if not (e == nil) then
						if (e > 250) then
						Map.Monsters[i].Attack1.DamageDiceCount = 250
						end
					end
					--Attack 2 Overflow fix, same formula
					--add damage fix
					if (c > 250) then
					Overflow = c - 250
					Map.Monsters[i].Attack2.DamageAdd = 250
					d=d + (math.round(2*Overflow/Map.Monsters[i].Attack2.DamageDiceCount))
					Map.Monsters[i].Attack2.DamageDiceSides = d
					end
					--Dice Sides fix
					if (d > 250) then
					Overflow = d / 250
					Map.Monsters[i].Attack2.DamageDiceSides = 250
					--checking for dice count overflow
					f=Map.Monsters[i].Attack2.DamageDiceCount * Overflow
					Map.Monsters[i].Attack2.DamageDiceCount = Map.Monsters[i].Attack2.DamageDiceCount * Overflow
					end
					--Just in case Dice Count fix
					if not (f ==nil) then
						if (f > 250) then
						Map.Monsters[i].Attack2.DamageDiceCount = 250
						end
					end

		end
	end
end

--SPARK BUG FIX
function events.CalcDamageToPlayer(t)
	local data=WhoHitPlayer()
	if data.Spell==15 then
		t.Result=0
		end
end


end

--]]

--fix for item/stats rework
function events.LoadMap()	
if SETTINGS["ItemRework"]==true and SETTINGS["StatsRework"]==true then
	for i=0, Map.Monsters.High do
	if not (Map.Monsters[i].Ally == 2) and mapvars.boosted==nil and not (Map.Monsters[i].Name == Game.MonstersTxt[Map.Monsters[i].Id].Name) or not (Map.Monsters[i].FullHitPoints == Game.MonstersTxt[Map.Monsters[i].Id].FullHitPoints) then
			Map.Monsters[i].Ally = 2
			Map.Monsters[i].FullHitPoints = Map.Monsters[i].FullHitPoints * (1+Map.Monsters[i].Level/200)
			Map.Monsters[i].HitPoints = Map.Monsters[i].HitPoints * (1+Map.Monsters[i].Level/200)
		
	-- bonus damage
				
				DamageMultiplier=(Map.Monsters[i].Level^1.6-1)/1000+1
				--attack 1
				a=Map.Monsters[i].Attack1.DamageAdd * DamageMultiplier
				Map.Monsters[i].Attack1.DamageAdd = Map.Monsters[i].Attack1.DamageAdd * DamageMultiplier
				b=Map.Monsters[i].Attack1.DamageDiceSides * DamageMultiplier
				Map.Monsters[i].Attack1.DamageDiceSides = Map.Monsters[i].Attack1.DamageDiceSides * DamageMultiplier
				
				--attack 2
				c=Map.Monsters[i].Attack2.DamageAdd * DamageMultiplier
				Map.Monsters[i].Attack2.DamageAdd = Map.Monsters[i].Attack2.DamageAdd * DamageMultiplier
				d=Map.Monsters[i].Attack2.DamageDiceSides * DamageMultiplier
				Map.Monsters[i].Attack2.DamageDiceSides = Map.Monsters[i].Attack2.DamageDiceSides * DamageMultiplier
				--OVERFLOW FIX
					--Attack 1 Overflow fix
					--add damage fix
					if (a > 250) then
					Overflow = a - 250
					Map.Monsters[i].Attack1.DamageAdd = 250
					b=b + (math.round(2*Overflow/Map.Monsters[i].Attack1.DamageDiceCount))
					Map.Monsters[i].Attack1.DamageDiceSides = b 
					end
					--Dice Sides fix
					if (b > 250) then
					Overflow = b / 250
					Map.Monsters[i].Attack1.DamageDiceSides = 250
					--checking for dice count overflow
					e = Map.Monsters[i].Attack1.DamageDiceCount * Overflow
					Map.Monsters[i].Attack1.DamageDiceCount = Map.Monsters[i].Attack1.DamageDiceCount * Overflow
					end
					--Just in case Dice Count fix
					if not (e == nil) then
						if (e > 250) then
						Map.Monsters[i].Attack1.DamageDiceCount = 250
						end
					end
					--Attack 2 Overflow fix, same formula
					--add damage fix
					if (c > 250) then
					Overflow = c - 250
					Map.Monsters[i].Attack2.DamageAdd = 250
					d=d + (math.round(2*Overflow/Map.Monsters[i].Attack2.DamageDiceCount))
					Map.Monsters[i].Attack2.DamageDiceSides = d
					end
					--Dice Sides fix
					if (d > 250) then
					Overflow = d / 250
					Map.Monsters[i].Attack2.DamageDiceSides = 250
					--checking for dice count overflow
					f=Map.Monsters[i].Attack2.DamageDiceCount * Overflow
					Map.Monsters[i].Attack2.DamageDiceCount = Map.Monsters[i].Attack2.DamageDiceCount * Overflow
					end
					--Just in case Dice Count fix
					if not (f ==nil) then
						if (f > 250) then
						Map.Monsters[i].Attack2.DamageDiceCount = 250
						end
					end

		end
	end
	
	mapvars.boosted=true
end
end
