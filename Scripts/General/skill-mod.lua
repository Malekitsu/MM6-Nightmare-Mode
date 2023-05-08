-- Beta 0.8.5
-- added experimental medidation regeneration.  Disable by removing meditation-sp-regen.lua. Added Eksekks bow and shield changes

--[[ list of expected files:

skill-mod.lua <-- you are here
skem-item-overrides.lua
skem-monster-overrides.lua
skem-mapstats-overrides.lua
skem-monster-infobox.lua
skem-skill-linking.lua
skem-spell-overrides.lua
meditation-sp-regen.lua

]]
----------------------------------------------------------------------------------------------------
-- global constants and lists
----------------------------------------------------------------------------------------------------

local blastersUseClassMultipliers = true
local shieldDoubleSkillEffectForKnights = true
local knightClasses = {const.Class.Knight, const.Class.Cavalier, const.Class.Champion}

local newMMExt
function events.GameInitialized2()
	newMMExt = Game.ItemsTxt[1].Skill == const.Skills.Sword and true or false -- hack
end

-- red distance

local meleeRangeDistance = 307.2

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

-- spellTxt id resolver

local spellTxtIds = {}

----------------------------------------------------------------------------------------------------
-- configuration
----------------------------------------------------------------------------------------------------

-- party melee range (experimental)

mem.prot(true)
-- that is default value - change it
mem.u8[0x004B9418] = 0x4074000000000000
mem.prot(false)
-- mem.u1[0x004B9418] = 0x33

-- melee recovery cap

local meleeRecoveryCap = 10

--
-- attribute breakpoints
local attributeBreakpoints =
{
400,
350,
300,
275,
250,
225,
200,
180,
160,
140,
120,
100,
90,
80,
70,
60,
50,
40,
35,
30,
25,
21,
19,
17,
15,
13,
11,
9,
-1000,
}


local attributeEffects =
{
80,
70,
60,
55,
50,
45,
40,
36,
32,
28,
24,
20,
18,
16,
14,
12,
10,
8,
7,
6,
5,
4,
3,
2,
1,
0,
-1,
-2,
-3,
}
--

-- weapon base recovery bonuses

local oldWeaponBaseRecoveryBonuses =
{
	[const.Skills.Bow] = 0,
	[const.Skills.Blaster] = 70,
	[const.Skills.Staff] = 0,
	[const.Skills.Axe] = 0,
	[const.Skills.Sword] = 10,
	[const.Skills.Spear] = 20,
	[const.Skills.Mace] = 20,
	[const.Skills.Dagger] = 40,
}
local newWeaponBaseRecoveryBonuses =
{
	[const.Skills.Bow] = 0,
	[const.Skills.Blaster] = 100,
	[const.Skills.Staff] = 0,
	[const.Skills.Axe] = 20,
	[const.Skills.Sword] = 10,
	[const.Skills.Spear] = 10,
	[const.Skills.Mace] = 20,
	[const.Skills.Dagger] = 40,
}

-- weapon skill attack bonuses (by rank)

local oldWeaponSkillAttackBonuses =
{
	[const.Skills.Staff]	= {1, 1, 1, },
	[const.Skills.Sword]	= {1, 1, 1, },
	[const.Skills.Dagger]	= {1, 1, 1, },
	[const.Skills.Axe]		= {1, 1, 1, },
	[const.Skills.Spear]	= {1, 1, 1, },
	[const.Skills.Bow]		= {1, 1, 1, },
	[const.Skills.Mace]		= {1, 1, 1, },
	[const.Skills.Blaster]	= {1, 2, 3, },
}
local newWeaponSkillAttackBonuses =
{
	[const.Skills.Staff]	= {1, 2, 2, },
	[const.Skills.Sword]	= {1, 2, 2, },
	[const.Skills.Dagger]	= {1, 2, 2, },
	[const.Skills.Axe]		= {1, 2, 2, },
	[const.Skills.Spear]	= {1, 2, 3, },
	[const.Skills.Bow]		= {3, 3, 3, },
	[const.Skills.Mace]		= {1, 2, 2, },
	[const.Skills.Blaster]	= {5, 10, 15, },
}

-- weapon skill recovery bonuses (by rank)

local oldWeaponSkillRecoveryBonuses =
{
	[const.Skills.Staff]	= {0, 0, 0, },
	[const.Skills.Sword]	= {0, 1, 1, },
	[const.Skills.Dagger]	= {0, 0, 0, },
	[const.Skills.Axe]		= {0, 1, 1, },
	[const.Skills.Spear]	= {0, 0, 0, },
	[const.Skills.Bow]		= {0, 1, 1, },
	[const.Skills.Blaster]	= {0, 0, 0, },
	[const.Skills.Mace]		= {0, 0, 0, },
}
local newWeaponSkillRecoveryBonuses =
{
	[const.Skills.Staff]	= {0, 0, 0, },
	[const.Skills.Sword]	= {0, 2, 2, },
	[const.Skills.Dagger]	= {0, 0, 1, },
	[const.Skills.Axe]		= {0, 2, 2, },
	[const.Skills.Spear]	= {0, 0, 0, },
	[const.Skills.Bow]		= {1, 2, 2, },
	[const.Skills.Mace]		= {0, 0, 0, },
	[const.Skills.Blaster]	= {0, 0, 0, },
}

-- weapon skill damage bonuses (by rank)
-- ranged weapon damage bonus has no effect

local oldWeaponSkillDamageBonuses =
{
	[const.Skills.Staff]	= {0, 0, 0, },
	[const.Skills.Sword]	= {0, 0, 0, },
	[const.Skills.Dagger]	= {0, 0, 0, },
	[const.Skills.Axe]		= {0, 0, 1, },
	[const.Skills.Spear]	= {0, 0, 1, },
	[const.Skills.Bow]		= {0, 0, 0, },
	[const.Skills.Mace]		= {0, 1, 1, },
	[const.Skills.Blaster]	= {0, 0, 0, },
}
local newWeaponSkillDamageBonuses =
{
	[const.Skills.Staff]	= {0, 0, 1, },
	[const.Skills.Sword]	= {0, 0, 1, },
	[const.Skills.Dagger]	= {0, 0, 0, },
	[const.Skills.Axe]		= {0, 1, 2, },
	[const.Skills.Spear]	= {0, 1, 2, },
	[const.Skills.Bow]		= {1, 2, 2, },
	[const.Skills.Mace]		= {0, 1, 2, },
	[const.Skills.Blaster]	= {0, 0, 0, },
	
}

-- weapon skill AC bonuses (by rank)

local oldWeaponSkillACBonuses =
{
	[const.Skills.Staff]	= {0, 1, 1, },
	[const.Skills.Sword]	= {0, 0, 0, },
	[const.Skills.Dagger]	= {0, 0, 0, },
	[const.Skills.Axe]		= {0, 0, 0, },
	[const.Skills.Spear]	= {0, 1, 1, },
	[const.Skills.Bow]		= {0, 0, 0, },
	[const.Skills.Mace]		= {0, 0, 0, },
	[const.Skills.Blaster]	= {0, 0, 0, },
}
local newWeaponSkillACBonuses =
{
	[const.Skills.Staff]	= {2, 2, 2, },
	[const.Skills.Sword]	= {0, 0, 0, },
	[const.Skills.Dagger]	= {0, 0, 0, },
	[const.Skills.Axe]		= {0, 0, 0, },
	[const.Skills.Spear]	= {0, 2, 4, },
	[const.Skills.Bow]		= {0, 0, 0, },
	[const.Skills.Mace]		= {0, 0, 0, },
	[const.Skills.Blaster]	= {0, 0, 0, },
}

-- weapon skill resistance bonuses (by rank)

local newWeaponSkillResistanceBonuses =
{
	[const.Skills.Staff]	= {0, 1, 2, },
	[const.Skills.Sword]	= {0, 0, 0, },
	[const.Skills.Dagger]	= {0, 0, 0, },
	[const.Skills.Axe]		= {0, 0, 0, },
	[const.Skills.Spear]	= {0, 0, 0, },
	[const.Skills.Bow]		= {0, 0, 0, },
	[const.Skills.Mace]		= {0, 0, 0, },
	[const.Skills.Blaster]	= {0, 0, 0, },
}

-- armor skill AC bonuses (by rank)

local newArmorSkillACBonuses =
{
	[const.Skills.Shield]	= {1, 2, 3, },
	[const.Skills.Leather]	= {3, 3, 3, },
	[const.Skills.Chain]	= {3, 3, 3, },
	[const.Skills.Plate]	= {3, 3, 3, },
}

-- armor skill resistance bonuses (by rank)

local newArmorSkillResistanceBonuses =
{
	[const.Skills.Leather]	= {3, 3, 6, },
	[const.Skills.Chain]	= {3, 3, 3, },
	[const.Skills.Plate]	= {0, 0, 0, },
}

-- armor skill damage reduction exponential multiplier (by rank)

local newArmorSkillDamageMultiplier =
{
	[const.Skills.Leather]	= {1.00, 1.00, 1.00, },
	[const.Skills.Chain]	= {1.00, 0.99, 0.99, },
	[const.Skills.Plate]	= {1.00, 0.98, 0.98, },
}

-- local recoveryBonusByMastery = {[const.Novice] = 4, [const.Expert] = 5, [const.Master] = 6, }
-- local damageBonusByMastery = {[const.Novice] = 2, [const.Expert] = 3, [const.Master] = 4, }
-- local weaponACBonusByMastery = {[const.Novice] = 4, [const.Expert] = 6, [const.Master] = 8, }
-- local weaponResistanceBonusByMastery = {[const.Novice] = 0, [const.Expert] = 1, [const.Master] = 2, }
local twoHandedWeaponDamageBonus = 3
local twoHandedWeaponDamageBonusByMastery = {[const.Novice] = twoHandedWeaponDamageBonus/3, [const.Expert] = twoHandedWeaponDamageBonus/3*2, [const.Master] = twoHandedWeaponDamageBonus, }
local learningSkillExtraMultiplier = 2
local learningSkillMultiplierByMastery = {[const.Novice] = 1 + learningSkillExtraMultiplier, [const.Expert] = 2 + learningSkillExtraMultiplier, [const.Master] = 3 + learningSkillExtraMultiplier, }

-- special modifiers
local daggerCrowdDamageMultiplier = 0

local daggerClassCriticalMultipliers = {
	[const.Class.Archer] = {1, 1.75, 3},
	[const.Class.BattleMage] = {1, 1.75, 3},
	[const.Class.WarriorMage] = {1, 1.75, 3},
}

local daggerDefaultCriticalMultipliers = {1, 1.4, 2.5}

local classDaggerCriticalChanceBonus = {
	[const.Class.Archer] = 5,
	[const.Class.BattleMage] = 5,
	[const.Class.WarriorMage] = 5,
}

-- special weapon skill chances
local staffEffect = {["base"] = 10, ["multiplier"] = 2, ["duration"] = 5, }
local maceEffect = {["base"] = 5, ["multiplier"] = 0.25, ["duration"] = 5, }

-- class weapon skill damage bonus
local classMeleeWeaponSkillDamageBonus =
{
	[const.Class.Knight] = 0.5,
	[const.Class.Cavalier] = 1,
	[const.Class.Champion] = 2,
	[const.Class.Paladin] = 0,
	[const.Class.Crusader] = 0.5,
	[const.Class.Hero] = 1,
	[const.Class.Archer] = 0,
	[const.Class.BattleMage] = 0.5,
	[const.Class.WarriorMage] = 1,
}
local classRangedWeaponSkillAttackBonusMultiplier =
{
	[const.Class.Archer] = 5/3,
	[const.Class.BattleMage] = 5/3,
	[const.Class.WarriorMage] = 5/3,
}
--ranged class speed bonus not working apparently
local classRangedWeaponSkillSpeedBonusMultiplier =
{
	[const.Class.Archer] = 0,
	[const.Class.BattleMage] = 0,
	[const.Class.WarriorMage] = 0,
}
local classRangedWeaponSkillDamageBonus =
{
	[const.Class.Archer] = 0,
	[const.Class.BattleMage] = 1,
	[const.Class.WarriorMage] = 2,
	[const.Class.Knight] = 0,
	[const.Class.Cavalier] = 0,
	[const.Class.Champion] = 1,
}

-- plate cover chances by rank
local plateCoverChances = {[const.Novice] = 0.1, [const.Expert] = 0.2, [const.Master] = 0.3, }

-- shield projectile damage multiplier by mastery
local shieldProjectileDamageReductionPerLevel = 0.01

-- Spell Overrides:spellPowers{} was externalized as of 0.8.3 to skem-spell-overrides

-- monster engagement distance

local standardEngagementDistance = 0x1600
local extendedEngagementDistance = 0x1900

-- house prices

local templeHealingPricePerHP = 0.25
local templeHealingPricePerSP = 0.25
local templeHealingPrice = 10
local innRoomPrice = 10
local innFoodQuantity = 10
local innFoodPrice = 60
local housePrices =
{
	-- training grounds
	["New Sorpigal Training Grounds"] = 5,
	["Training-by-the-Sea"] = 10,
	["Island Testing Center"] = 15,
	["Abdul's Discount Training Center"] = 20,
	["Riverside Academy"] = 25,
	["Free Haven Academy"] = 30,
	["Lone Tree Training"] = 40,
	["Wolf's Den"] = 50,
	["Royal Gymnasium"] = 100,
	["The Sparring Ground"] = 150,
}

-- set melee recovery cap

mem.asmpatch(0x00406886, string.format("cmp    eax,%d", meleeRecoveryCap), 3)
-- originally 0x0040688B then moved to MM6patch.dll
-- .text:00406889     call    near ptr address + 2
mem.asmpatch(0x03322D6A, string.format("mov    eax,%d", meleeRecoveryCap), 5)

mem.asmpatch(0x0042A237, string.format("cmp    eax,%d", meleeRecoveryCap), 3)
mem.asmpatch(0x0042A240, string.format("mov    DWORD [esp+0x28],%d", meleeRecoveryCap), 8)

-- buried in the MM6patch.dll
mem.asmpatch(0x03322951, string.format("cmp    edi,%d", meleeRecoveryCap), 3)
mem.asmpatch(0x03322960, string.format("mov    edi,%d", meleeRecoveryCap), 5)

----------------------------------------------------------------------------------------------------
-- additional structures
----------------------------------------------------------------------------------------------------

function structs.f.GameExtraStructure(define)
	define
	[0x0056B76C].array(31).EditPChar  'SkillDescriptionsNormal'
	[0x0056F29C].array(31).EditPChar  'SkillDescriptionsExpert'
	[0x0056F318].array(31).EditPChar  'SkillDescriptionsMaster'
end
GameExtra = structs.GameExtraStructure:new(0)
local SkillDescriptionsRanks =
{
	[const.Novice] = GameExtra.SkillDescriptionsNormal,
	[const.Expert] = GameExtra.SkillDescriptionsExpert,
	[const.Master] = GameExtra.SkillDescriptionsMaster,
}

----------------------------------------------------------------------------------------------------
-- helper functions
----------------------------------------------------------------------------------------------------

-- converts float int bytes representation to float

local function convertIntToFloat(x)

  local sign = 1
  if bit.band(x, 0x80000000) ~= 0 then sign = -1 end
	
  local mantissa = bit.band(x, 0x007FFFFF)
	
  local exponent = bit.band(bit.rshift(x, 23), 0xFF)
  if exponent == 0 then return 0 end
	
  mantissa = (math.ldexp(mantissa, -23) + 1) * sign
	
  return math.ldexp(mantissa, exponent - 127)
	
end

-- formats number for skill rank description

local function formatSkillRankNumber(number, rightPosition)

	if rightPosition == nil then
		return "--"
	end

	local formattedString = ""

	local numberString = string.format("%d", number)
	local valueNumberShift = 8
	local position = rightPosition - valueNumberShift * string.len(numberString)

	for c in string.gmatch(numberString, ".") do
		local adjustedPosition = position
		--[[
		if c == "4" then
			adjustedPosition = adjustedPosition + 1
		end
		--]]
		formattedString = formattedString .. string.format("\t%03d%s", adjustedPosition, c)
		position = position + valueNumberShift
	end
	
	return formattedString
	
end

-- Player hooks

local function GetPlayer(p)
	local i = (p - Party.PlayersArray["?ptr"]) / Party.PlayersArray[0]["?size"]
	return i, Party.PlayersArray[i]
end

local function GetMonster(p)
	if p == 0 then
		return
	end
	local i = (p - Map.Monsters["?ptr"]) / Map.Monsters[0]["?size"]
	return i, Map.Monsters[i]
end

local function GetMonsterTxt(p)
	if p == 0 then
		return
	end
	local i = (p - Game.MonstersTxt["?ptr"]) / Game.MonstersTxt[0]["?size"]
	return i, Game.MonstersTxt[i]
end

-- collects relevant player weapon data

local function getPlayerEquipmentData(player)

	local equipmentData =
	{
		twoHanded = false,
		dualWield = false,
		bow =
		{
			equipped = false,
			item = nil,
			equipStat = nil,
			weapon = false,
			skill = nil,
			rank = nil,
			level = nil,
		},
		main =
		{
			equipped = false,
			item = nil,
			equipStat = nil,
			weapon = false,
			skill = nil,
			rank = nil,
			level = nil,
		},
		extra =
		{
			equipped = false,
			item = nil,
			equipStat = nil,
			weapon = false,
			skill = nil,
			rank = nil,
			level = nil,
		},
		shield =
		{
			equipped = false,
			item = nil,
			skill = nil,
			rank = nil,
			level = nil,
		},
		armor =
		{
			equipped = false,
			item = nil,
			skill = nil,
			rank = nil,
			level = nil,
		},
	}
	
	-- get ranged weapon data
	
	if player.ItemBow ~= 0 then
		
		equipmentData.bow.equipped = true
		
		equipmentData.bow.item = player.Items[player.ItemBow]
		local itemBowTxt = Game.ItemsTxt[equipmentData.bow.item.Number]
		equipmentData.bow.equipStat = itemBowTxt.EquipStat + 1
		equipmentData.bow.skill = itemBowTxt.Skill - (newMMExt and 0 or 1)
		
		if equipmentData.bow.skill >= 0 then
			equipmentData.bow.level, equipmentData.bow.rank = SplitSkill(player.Skills[equipmentData.bow.skill])
		end
		
		if equipmentData.bow.skill >= 0 and equipmentData.bow.skill <= 7 then
			equipmentData.bow.weapon = true
		end
		
	end
	
	-- get main hand weapon data
			
	if player.ItemMainHand ~= 0 then
		
		equipmentData.main.equipped = true
		
		equipmentData.main.item = player.Items[player.ItemMainHand]
		equipmentData.main.itemTxt = Game.ItemsTxt[equipmentData.main.item.Number]
		equipmentData.main.equipStat = equipmentData.main.itemTxt.EquipStat + 1
		equipmentData.main.skill = equipmentData.main.itemTxt.Skill - (newMMExt and 0 or 1)
		
		if equipmentData.main.skill >= 0 then
			equipmentData.main.level, equipmentData.main.rank = SplitSkill(player.Skills[equipmentData.main.skill])
		end
		
		if equipmentData.main.skill >= 0 and equipmentData.main.skill <= 7 then
			equipmentData.main.weapon = true
		end
		
	end
	
	-- get extra hand weapon data only if not holding blaster in main hand
			
	if (player.ItemMainHand == 0 or equipmentData.main.skill ~= const.Skills.Blaster) and player.ItemExtraHand ~= 0 then
		
		equipmentData.extra.equipped = true
		
		equipmentData.extra.item = player.Items[player.ItemExtraHand]
		equipmentData.extra.itemTxt = Game.ItemsTxt[equipmentData.extra.item.Number]
		equipmentData.extra.equipStat = equipmentData.extra.itemTxt.EquipStat + 1
		equipmentData.extra.skill = equipmentData.extra.itemTxt.Skill - (newMMExt and 0 or 1)
		
		if equipmentData.extra.skill >= 0 then
			equipmentData.extra.level, equipmentData.extra.rank = SplitSkill(player.Skills[equipmentData.extra.skill])
		end
		
		if equipmentData.extra.skill >= 0 and equipmentData.extra.skill <= 7 then
			equipmentData.extra.weapon = true
		end
		
	end
	
	-- populate other info
	
	if equipmentData.main.weapon and equipmentData.main.equipStat == const.ItemType.Weapon2H then
		equipmentData.twoHanded = true
	elseif equipmentData.main.skill == const.Skills.Spear and not equipmentData.extra.equipped then
		equipmentData.twoHanded = true
	elseif equipmentData.main.weapon and equipmentData.extra.weapon then
		equipmentData.dualWield = true
	end
	
	-- get shield data
	
	if player.ItemExtraHand ~= 0 then
		
		equipmentData.extra.item = player.Items[player.ItemExtraHand]
		local itemExtraHandTxt = Game.ItemsTxt[equipmentData.extra.item.Number]
		equipmentData.extra.equipStat = itemExtraHandTxt.EquipStat + 1
		equipmentData.extra.skill = itemExtraHandTxt.Skill - (newMMExt and 0 or 1)
		
		if equipmentData.extra.skill == const.Skills.Shield then
			equipmentData.shield.equipped = true
			equipmentData.shield.skill = equipmentData.extra.skill
			equipmentData.shield.level, equipmentData.shield.rank = SplitSkill(player.Skills[equipmentData.shield.skill])
		end
		
	end
	
	-- get armor data
	
	if player.ItemArmor ~= 0 then
		
		equipmentData.armor.equipped = true
		
		equipmentData.armor.item = player.Items[player.ItemArmor]
		local itemArmorTxt = Game.ItemsTxt[equipmentData.armor.item.Number]
		equipmentData.armor.skill = itemArmorTxt.Skill - (newMMExt and 0 or 1)
		equipmentData.armor.level, equipmentData.armor.rank = SplitSkill(player.Skills[equipmentData.armor.skill])
		
	end
	
	-- account for hirelings skill boost
	
	local hiredNPC = Game.Party.HiredNPC
	if
		(hiredNPC[1] ~= nil and hiredNPC[1].Profession == const.NPCProfession.ArmsMaster)
		or
		(hiredNPC[2] ~= nil and hiredNPC[2].Profession == const.NPCProfession.ArmsMaster)
	then
		if equipmentData.bow.level ~= nil then
			equipmentData.bow.level = equipmentData.bow.level + 2
		end
		if equipmentData.main.level ~= nil then
			equipmentData.main.level = equipmentData.main.level + 2
		end
		if equipmentData.extra.level ~= nil then
			equipmentData.extra.level = equipmentData.extra.level + 2
		end
	end
	if
		(hiredNPC[1] ~= nil and hiredNPC[1].Profession == const.NPCProfession.WeaponsMaster)
		or
		(hiredNPC[2] ~= nil and hiredNPC[2].Profession == const.NPCProfession.WeaponsMaster)
	then
		if equipmentData.bow.level ~= nil then
			equipmentData.bow.level = equipmentData.bow.level + 3
		end
		if equipmentData.main.level ~= nil then
			equipmentData.main.level = equipmentData.main.level + 3
		end
		if equipmentData.extra.level ~= nil then
			equipmentData.extra.level = equipmentData.extra.level + 3
		end
	end
	if
		(hiredNPC[1] ~= nil and hiredNPC[1].Profession == const.NPCProfession.Squire)
		or
		(hiredNPC[2] ~= nil and hiredNPC[2].Profession == const.NPCProfession.Squire)
	then
		if equipmentData.bow.level ~= nil then
			equipmentData.bow.level = equipmentData.bow.level + 2
		end
		if equipmentData.main.level ~= nil then
			equipmentData.main.level = equipmentData.main.level + 2
		end
		if equipmentData.extra.level ~= nil then
			equipmentData.extra.level = equipmentData.extra.level + 2
		end
		if equipmentData.shield.level ~= nil then
			equipmentData.shield.level = equipmentData.shield.level + 2
		end
		if equipmentData.armor.level ~= nil then
			equipmentData.armor.level = equipmentData.armor.level + 2
		end
	end
	
	return equipmentData
	
end

-- calculate new and old recovery difference

local function getWeaponRecoveryCorrection(equipmentData1, equipmentData2, player)

	local correction = 0
	
	-- single wield
	if equipmentData2 == nil then
	
		-- calculate old and new recovery bonuses
	
		local oldRecoveryBonus = 0
		local newRecoveryBonus = 0
	
		-- base bonuses
		
		oldRecoveryBonus = oldRecoveryBonus + oldWeaponBaseRecoveryBonuses[equipmentData1.skill]
		newRecoveryBonus = newRecoveryBonus + newWeaponBaseRecoveryBonuses[equipmentData1.skill]
		
		-- skill bonuses
		
		if equipmentData1.rank >= const.Expert then
			oldRecoveryBonus = oldRecoveryBonus + (oldWeaponSkillRecoveryBonuses[equipmentData1.skill][equipmentData1.rank] * equipmentData1.level)
		end
		newRecoveryBonus = newRecoveryBonus + (newWeaponSkillRecoveryBonuses[equipmentData1.skill][equipmentData1.rank] * equipmentData1.level)
		
		-- class bonus
		
		if equipmentData1.skill == const.Skills.Bow or (blastersUseClassMultipliers and equipmentData1.skill == const.Skills.Blaster) then
			local rangedWeaponSkillSpeedBonusMultiplier = classRangedWeaponSkillSpeedBonusMultiplier[player.Class]
			if rangedWeaponSkillSpeedBonusMultiplier ~= nil then
				newRecoveryBonus = newRecoveryBonus * rangedWeaponSkillSpeedBonusMultiplier
			end
		end
		
		-- replace old with new bonus

		correction = correction 
			+ oldRecoveryBonus
			- newRecoveryBonus
		
	-- dual wield
	else
	
		-- calculate effective skill levels
		
		local meleeWeapon1EffectiveSkillLevel
		local meleeWeapon2EffectiveSkillLevel
		
		if equipmentData1.skill == equipmentData2.skill then
			meleeWeapon1EffectiveSkillLevel = equipmentData1.level
			meleeWeapon2EffectiveSkillLevel = equipmentData2.level
		else
			-- effective skill level is not divided by sqrt(2) anymore
			meleeWeapon1EffectiveSkillLevel = equipmentData1.level
			meleeWeapon2EffectiveSkillLevel = equipmentData2.level
		end
	
		-- calculate old and new recovery bonuses
	
		local oldRecoveryBonus1 = 0
		local newRecoveryBonus1 = 0
		local newRecoveryBonus2 = 0
	
		-- weapon 1
		
		-- base bonuses
		
		oldRecoveryBonus1 = oldRecoveryBonus1 + oldWeaponBaseRecoveryBonuses[equipmentData1.skill]
		newRecoveryBonus1 = newRecoveryBonus1 + newWeaponBaseRecoveryBonuses[equipmentData1.skill]
		newRecoveryBonus2 = newRecoveryBonus2 + newWeaponBaseRecoveryBonuses[equipmentData2.skill]
		
		-- swiftness
		
		if equipmentData1.item.Bonus2 == 59 then
			oldRecoveryBonus1 = oldRecoveryBonus1 + 20
			newRecoveryBonus1 = newRecoveryBonus1 + 20
		end
		if equipmentData2.item.Bonus2 == 59 then
			newRecoveryBonus2 = newRecoveryBonus2 + 20
		end
		
		-- skill bonuses
		
		if equipmentData1.rank >= const.Expert then
			oldRecoveryBonus1 = oldRecoveryBonus1 + (oldWeaponSkillRecoveryBonuses[equipmentData1.skill][equipmentData1.rank] * equipmentData1.level)
		end
		newRecoveryBonus1 = (newRecoveryBonus1 + (newWeaponSkillRecoveryBonuses[equipmentData1.skill][equipmentData1.rank] * meleeWeapon1EffectiveSkillLevel))
		newRecoveryBonus2 = (newRecoveryBonus2 + (newWeaponSkillRecoveryBonuses[equipmentData2.skill][equipmentData2.rank] * meleeWeapon2EffectiveSkillLevel))
		
		-- replace old with new bonus
		
		correction = correction
			+ oldRecoveryBonus1
			- (newRecoveryBonus1 + newRecoveryBonus2)
		
	end
	
	return correction
	
end
-- Spell Overrides:function randomSpellPower(spellPower, level) was externalized as of 0.8.3 to skem-spell-overrides

-- calculate distance from party to monster side

local function getDistanceToMonster(monster)
	return math.sqrt((Party.X - monster.X) * (Party.X - monster.X) + (Party.Y - monster.Y) * (Party.Y - monster.Y)) - monster.BodyRadius
end

-- fast flat distance from party to monster

local function fastDistance(monsterX, monsterY)

	local dx = Party.X - monsterX
	local dy = Party.Y - monsterY

	local a = math.max(dx, dy)
	local b = math.min(dx, dy)
	
	return a + 11 / 32 * b
	
end

-- get party experience level

local function getPartyExperienceLevel()

	local partyExperience = 0
	
	for i = 0, 3 do
		partyExperience = partyExperience + Party.Players[i].Experience
	end
	
	local averagePlayerExperience = partyExperience / 4
	
	local partyExperienceLevel = math.floor((1 + math.sqrt(1 + (4 * averagePlayerExperience / 500))) / 2)
	
	return partyExperienceLevel

end

-- profession functions

local professionsRandomTotalAddress = 0x006BA538
local professionStructureSize = 0x4C
local professionChanceAddress = 0x006B5DC8
local professionCostAddress = 0x006B5DCC
local professionJoinTextAddress = 0x006B5DD8

local function setProfessionChance(professionIndex, chance)

	local oldChance = mem.u4[professionChanceAddress + professionStructureSize * professionIndex]
	mem.u4[professionChanceAddress + professionStructureSize * professionIndex] = chance
	mem.u4[professionsRandomTotalAddress] = mem.u4[professionsRandomTotalAddress] - oldChance + chance
	
end

local function setProfessionCost(professionIndex, cost)

	-- get join text byte array address
	
	local joinTextPointer = mem.u4[professionJoinTextAddress + professionStructureSize * professionIndex]
	
	-- read bytes to string
	
	local joinText = ""
	
	local memoryBytePointer = joinTextPointer
	while mem.u1[memoryBytePointer] ~= 0 do
		joinText = joinText .. string.char(mem.u1[memoryBytePointer])
		memoryBytePointer = memoryBytePointer + 1
	end
	
	-- get old cost
	
	local oldCost = mem.u4[professionCostAddress + professionStructureSize * professionIndex]
	
	-- replace cost text
	
	joinText = string.gsub(joinText, string.format("%d", oldCost), string.format("%d", cost))
	
	-- write bytes to memory
	
	for i = 1, string.len(joinText) do
		mem.u1[joinTextPointer + (i - 1)] = string.byte(joinText, i)
	end
	mem.u1[joinTextPointer + string.len(joinText)] = 0
	
	-- modify numeric cost value
	
	mem.u4[professionCostAddress + professionStructureSize * professionIndex] = cost
	
end

----------------------------------------------------------------------------------------------------
-- modification events
----------------------------------------------------------------------------------------------------

-- corrects attack delay

function events.GetAttackDelay(t)

	local equipmentData = getPlayerEquipmentData(t.Player)
	
	-- weapon
	
	if t.Ranged then
	
		local bow = equipmentData.bow
	
		if bow.weapon then
		
			t.Result = t.Result + getWeaponRecoveryCorrection(bow, nil, t.Player)
			
		end
		
	else
	
		local main = equipmentData.main
		local extra = equipmentData.extra
		
		if main.weapon then
			
			-- single wield
			if not equipmentData.dualWield then
				
				t.Result = t.Result + getWeaponRecoveryCorrection(main, nil, t.Player)
				
			-- dual wield
			else
			
				-- no axe and no sword in main hand and sword in extra hand = extra hand skill defines recovery
				if main.skill ~= const.Skills.Axe and main.skill ~= const.Skills.Sword and extra.skill == const.Skills.Sword then
					t.Result = t.Result + getWeaponRecoveryCorrection(extra, main, t.Player)
				-- everything else = main hand skill defines recovery
				else
					t.Result = t.Result + getWeaponRecoveryCorrection(main, extra, t.Player)
				end
				
			end
			
		end
		
	end
	
	-- turn recovery time into a multiplier rather than divisor
	
	local recoveryBonus = 100 - t.Result
	local correctedRecoveryTime = math.floor(100 / (1 + recoveryBonus / 100))
	
	t.Result = correctedRecoveryTime
	
	-- cap melee recovery
	
	if not t.Ranged then
		t.Result = math.max(meleeRecoveryCap, t.Result)
	end
	
end

-- calculate stat bonus by item

function events.CalcStatBonusByItems(t)

	local equipmentData = getPlayerEquipmentData(t.Player)
	
	local main = equipmentData.main
	local extra = equipmentData.extra
	local armor = equipmentData.armor
	
	-- calculate resistance
	
	if
		t.Stat == const.Stats.FireResistance
		or
		t.Stat == const.Stats.ElecResistance
		or
		t.Stat == const.Stats.ColdResistance
		or
		t.Stat == const.Stats.PoisonResistance
		or
		t.Stat == const.Stats.MagicResistance
	then
	
		-- resistance bonus from weapon
		
		for playerIndex = 0,3 do
		
			local weaponResistancePlayer = Party.Players[playerIndex]
			local weaponResistancePlayerEquipmentData = getPlayerEquipmentData(weaponResistancePlayer)
			local weaponResistancePlayerMain = weaponResistancePlayerEquipmentData.main
			local weaponResistancePlayerExtra = weaponResistancePlayerEquipmentData.extra
		
			if weaponResistancePlayerMain.equipped and weaponResistancePlayerMain.weapon then
				t.Result = t.Result + (newWeaponSkillResistanceBonuses[weaponResistancePlayerMain.skill][weaponResistancePlayerMain.rank] * weaponResistancePlayerMain.level)
			end
			
			if weaponResistancePlayerExtra.equipped and weaponResistancePlayerExtra.weapon then
				t.Result = t.Result + (newWeaponSkillResistanceBonuses[weaponResistancePlayerExtra.skill][weaponResistancePlayerExtra.rank] * weaponResistancePlayerExtra.level)
			end
			
		end
		
		-- resistance bonus from armor
		
		if armor.equipped then
			t.Result = t.Result + (newArmorSkillResistanceBonuses[armor.skill][armor.rank] * armor.level)
		end
		
	end
	
end


-- calculate stat bonus by skill

function events.CalcStatBonusBySkills(t)

	local equipmentData = getPlayerEquipmentData(t.Player)
	
	-- calculate ranged attack bonus by skill
	
	if t.Stat == const.Stats.RangedAttack then
	
		local bow = equipmentData.bow
	
		if bow.weapon then
		
			-- calculate old bonus
			
			local oldBonus = (oldWeaponSkillAttackBonuses[bow.skill][bow.rank] * bow.level)
			
			-- calculate new bonus
			
			local newBonus = (newWeaponSkillAttackBonuses[bow.skill][bow.rank] * bow.level)
			
			if bow.skill == const.Skills.Bow then
				local rangedWeaponSkillAttackBonusMultiplier = classRangedWeaponSkillAttackBonusMultiplier[t.Player.Class]
				if rangedWeaponSkillAttackBonusMultiplier ~= nil then
					newBonus = newBonus * rangedWeaponSkillAttackBonusMultiplier
				end
			end
			
			-- recalculate bonus
			
			t.Result = t.Result - oldBonus + newBonus
			
		end
		
	-- calculate ranged damage bonus by skill
	
	elseif t.Stat == const.Stats.RangedDamageBase then
	
		local bow = equipmentData.bow
	
		if bow.weapon then
		
			-- calculate old bonus
			
			local oldBonus = 0
			
			-- calculate new bonus
			
			local newBonus = 0
			
			-- add new bonus for ranged weapon
			
			t.Result = t.Result + newWeaponSkillDamageBonuses[bow.skill][bow.rank] * bow.level
			
			-- add class bonus for ranged weapon
			
			if classRangedWeaponSkillDamageBonus[t.Player.Class] ~= nil then
				t.Result = t.Result + (classRangedWeaponSkillDamageBonus[t.Player.Class] * bow.level)
			end
			
			-- recalculate bonus
			
			t.Result = t.Result - oldBonus + newBonus
			
		end
		
	-- calculate melee attack bonus by skill
	
	elseif t.Stat == const.Stats.MeleeAttack then
	
		local main = equipmentData.main
		local extra = equipmentData.extra
		
		if main.weapon then
			
			-- single wield
			if not equipmentData.dualWield then
				
				-- calculate old bonus
				
				local oldBonus = (oldWeaponSkillAttackBonuses[main.skill][main.rank] * main.level)
				
				-- calculate new bonus
				
				local newBonus = (newWeaponSkillAttackBonuses[main.skill][main.rank] * main.level)
				
				-- class bonus
			
				if main.skill == const.Skills.Blaster and blastersUseClassMultipliers then
					local rangedWeaponSkillAttackBonusMultiplier = classRangedWeaponSkillAttackBonusMultiplier[t.Player.Class]
					if rangedWeaponSkillAttackBonusMultiplier ~= nil then
						newBonus = newBonus * rangedWeaponSkillAttackBonusMultiplier
					end
				end
				
				-- recalculate bonus
				
				t.Result = t.Result - oldBonus + newBonus
				
			-- dual wield
			else
						
				-- calculate effective skill levels
				
				local mainEffectiveSkillLevel
				local extraEffectiveSkillLevel
				
				if main.skill == extra.skill then
					mainEffectiveSkillLevel = main.level
					extraEffectiveSkillLevel = extra.level
				else
					-- effective skill level is not divided by sqrt(2) anymore
					mainEffectiveSkillLevel = main.level
					extraEffectiveSkillLevel = extra.level
				end
			
				-- calculate old bonus
				
				local oldBonus = (oldWeaponSkillAttackBonuses[extra.skill][extra.rank] * main.level)
				
				-- calculate new bonus
				
				local newBonus = ((newWeaponSkillAttackBonuses[main.skill][main.rank] * mainEffectiveSkillLevel) + (newWeaponSkillAttackBonuses[extra.skill][extra.rank] * extraEffectiveSkillLevel))
			
				-- recalculate bonus
				
				t.Result = t.Result - oldBonus + newBonus
				
			end
			
		end
		
	-- calculate melee damage bonus by skill
	
	elseif t.Stat == const.Stats.MeleeDamageBase then
	
		local main = equipmentData.main
		local extra = equipmentData.extra
		local shield = equipmentData.shield
		if main.weapon then
			if shield.equipped then
				if classMeleeWeaponSkillDamageBonus[t.Player.Class] ~= nil then
					t.Result = t.Result + (classMeleeWeaponSkillDamageBonus[t.Player.Class] * shield.level)
				end
			end
			-- single wield
			
			if not equipmentData.dualWield then
				
				-- subtract old bonus
				
				if
					(main.skill == const.Skills.Axe and main.rank >= const.Master)
					or
					(main.skill == const.Skills.Spear and main.rank >= const.Master)
					or
					(main.skill == const.Skills.Mace and main.rank >= const.Expert)
				then
					t.Result = t.Result - main.level
				end
				
				-- add new bonus for main weapon
				
				t.Result = t.Result + newWeaponSkillDamageBonuses[main.skill][main.rank] * main.level

				
				-- add class bonus for main hand weapon
				
				if classMeleeWeaponSkillDamageBonus[t.Player.Class] ~= nil then
					t.Result = t.Result + (classMeleeWeaponSkillDamageBonus[t.Player.Class] * main.level)
				end
				
				-- add bonus for two handed weapon
				
				if equipmentData.twoHanded and equipmentData.main.skill ~= const.Skills.Staff then
					t.Result = t.Result + twoHandedWeaponDamageBonusByMastery[main.rank] * main.level
				end
				
			-- dual wield
			
			else
				
				-- calculate effective skill levels
				
				local mainEffectiveSkillLevel
				local extraEffectiveSkillLevel
				
				if main.skill == extra.skill then
					mainEffectiveSkillLevel = main.level
					extraEffectiveSkillLevel = extra.level
				else
					-- effective skill level is not divided by sqrt(2) anymore
					mainEffectiveSkillLevel = main.level
					extraEffectiveSkillLevel = extra.level
				end
			
				-- subtract old bonus
				
				if
					(main.skill == const.Skills.Axe and main.rank >= const.Master)
					or
					(main.skill == const.Skills.Spear and main.rank >= const.Master)
					or
					(main.skill == const.Skills.Mace and main.rank >= const.Expert)
				then
					t.Result = t.Result - main.level
				end
				local classMeleeDamageBonus = classMeleeWeaponSkillDamageBonus[t.Player.Class] or 0
				
				-- add new bonus for main weapon
				-- removing the class bonus from main hand if main hand sword or dagger
				if main.skill == const.Skills.Sword then
				t.Result = t.Result + (newWeaponSkillDamageBonuses[main.skill][main.rank] * mainEffectiveSkillLevel)-(classMeleeDamageBonus*mainEffectiveSkillLevel)
					elseif main.skill == const.Skills.Dagger then
					t.Result = t.Result + (newWeaponSkillDamageBonuses[main.skill][main.rank] * mainEffectiveSkillLevel)-(classMeleeDamageBonus*mainEffectiveSkillLevel)
						else
						t.Result = t.Result + (newWeaponSkillDamageBonuses[main.skill][main.rank] * mainEffectiveSkillLevel)
				end
				
				-- add new bonus for extra weapon if any
				
				if extra.weapon then
					t.Result = t.Result + math.round((newWeaponSkillDamageBonuses[extra.skill][extra.rank]+classMeleeDamageBonus) * (extraEffectiveSkillLevel))
				end
				
				-- add class bonus for main hand weapon
				
				if classMeleeWeaponSkillDamageBonus[t.Player.Class] ~= nil then
					t.Result = t.Result + (classMeleeDamageBonus * mainEffectiveSkillLevel)
				end
				
				--[[ add class bonus for extra hand weapon if any and different from main weapon
				
				if extra.weapon and extra.skill ~= main.skill then
					if classMeleeWeaponSkillDamageBonus[t.Player.Class] ~= nil then
						t.Result = t.Result + math.round(classMeleeWeaponSkillDamageBonus[t.Player.Class] * extraEffectiveSkillLevel)
					end
				end
				]]
			end
			
			-- dagger crowd damage
			
			if main.skill == const.Skills.Dagger or extra.skill == const.Skills.Dagger then
			
				local meleeRangeMonsterCount = 0
				
				for monsterIndex = 0, Map.Monsters.high do
					local monster = Map.Monsters[monsterIndex]
					local distanceToMonster = getDistanceToMonster(monster)
					if distanceToMonster < meleeRangeDistance and monster.Active then
						meleeRangeMonsterCount = meleeRangeMonsterCount + 1
					end
				end
				
				if main.skill == const.Skills.Dagger then
					t.Result = t.Result + math.floor(daggerCrowdDamageMultiplier * meleeRangeMonsterCount * main.level)
				end
				if extra.skill == const.Skills.Dagger then
					t.Result = t.Result + math.floor(daggerCrowdDamageMultiplier * meleeRangeMonsterCount * extra.level)
				end
				
			end
			
		end
		
	-- calculate AC bonus by skill
	
	elseif t.Stat == const.Stats.ArmorClass then
	
		-- AC bonus from weapon skill
		
		local main = equipmentData.main
		
		if main.weapon then
		
			if main.skill == const.Skills.Staff then
			
				-- subtract old bonus
				
				if main.skill == const.Skills.Staff and main.rank >= const.Expert then
					t.Result = t.Result - main.level
				end
				
				-- add new bonus
				
				t.Result = t.Result + (newWeaponSkillACBonuses[const.Skills.Staff][main.rank] * main.level)
				
			-- spear grant AC again
			
			elseif main.skill == const.Skills.Spear then
			
				-- subtract old bonus
				
				if main.skill == const.Skills.Spear and main.rank >= const.Expert then
					t.Result = t.Result - main.level
				end
				
			
				
				-- add new bonus
				t.Result = t.Result + (newWeaponSkillACBonuses[const.Skills.Spear][main.rank] * main.level)
				--]]
				
			end
			
		end
		
		-- AC bonus from shield skill
		
		local shield = equipmentData.shield
		
		if shield.equipped then
		
			-- subtract old bonus
			
			t.Result = t.Result - shield.rank * shield.level
			
			-- add new bonus
			
			t.Result = t.Result + (newArmorSkillACBonuses[shield.skill][shield.rank] * shield.level * (shieldDoubleSkillEffectForKnights and table.find(knightClasses, t.Player.Class) and 2 or 1))
			
		end
		
		-- AC bonus from armor skill
		
		local armor = equipmentData.armor
		
		if armor.equipped then
		
			-- subtract old bonus
			
			t.Result = t.Result - armor.level
			
			-- add new bonus
			
			t.Result = t.Result + (newArmorSkillACBonuses[armor.skill][armor.rank] * armor.level)
			
		end
		
	end
	
end

-- modify damage to player



	--[[ compute damage reduction
	
	local damageMultiplier = 1.0
	
	for playerIndex = 0, 3 do
	
		local player = Party.Players[playerIndex]
		local playerEquipmentData = getPlayerEquipmentData(player)
		
		if playerEquipmentData.shield.equipped then
			damageMultiplier = damageMultiplier * math.pow(1 - shieldProjectileDamageReductionPerLevel, playerEquipmentData.shield.level)
		end
		
	end
	
	damage = math.ceil(damage * damageMultiplier)
]]





function events.CalcDamageToPlayer(t)

	local equipmentData = getPlayerEquipmentData(t.Player)
	
	
	-- calculate physical damage by armor skill
	
	if t.DamageKind == const.Damage.Phys then
	
		local armor = equipmentData.armor
	
		if armor.equipped then

			local damageMultiplier = math.pow(newArmorSkillDamageMultiplier[armor.skill][armor.rank], equipmentData.armor.level)

			t.Result = math.round(t.Damage * damageMultiplier)

			
		end
		
	end
	
end

-- applySpecialWeaponSkill

local function applySpecialWeaponSkill(d, def, TextBuffer, delay)

	local player = Party.Players[Game.CurrentPlayer]
	local monster = Map.Monsters[(d.esi - Map.Monsters["?ptr"]) / Map.Monsters[0]["?size"]]

	-- player holds weapon in main hand
	
	if	player.ItemMainHand ~= 0 then
		
		-- Staff in main hand
		
		if	(Game.ItemsTxt[player.Items[player.ItemMainHand].Number].Skill - (newMMExt and 0 or 1)) == const.Skills.Staff then
			
			-- Staff skill
			
			if player.Skills[const.Skills.Staff] ~= 0 then
			
				local level, rank = SplitSkill(player.Skills[const.Skills.Staff])
				
				local chance = staffEffect["base"] + staffEffect["multiplier"] * level
				local duration = staffEffect["duration"]
				
				-- roll dice
				
				if math.random(1, 100) <= chance then
				
					-- roll dice for an effect
					
					if math.random() < 0.5 then
						
						-- apply buff
						
						local spellBuff = monster.SpellBuffs[const.MonsterBuff.ShrinkingRay]
						spellBuff:Set(Game.Time + const.Minute * duration, rank, rank + 1, 0, 0)
						
						-- append to message
						
						Game.TextBuffer = Game.TextBuffer .. " /Shrunk"
						
					else
					
						-- apply buff
						
						local spellBuff = monster.SpellBuffs[const.MonsterBuff.Feeblemind]
						spellBuff:Set(Game.Time + const.Minute * duration, rank, 0, 0, 0)
						
						-- append to message
						
						Game.TextBuffer = Game.TextBuffer .. " /Feebleminded"
						
					end
					
				end
				
			end
			
		end
		
		-- Mace in main hand
		
		if	(Game.ItemsTxt[player.Items[player.ItemMainHand].Number].Skill - (newMMExt and 0 or 1)) == const.Skills.Mace then
			
			-- Mace skill
			
			if player.Skills[const.Skills.Mace] ~= 0 then
			
				local level, rank = SplitSkill(player.Skills[const.Skills.Mace])
				
				local chance = maceEffect["base"] + maceEffect["multiplier"] * level
				local duration = maceEffect["duration"]
				
				-- roll dice
				
				if math.random(1, 100) <= chance then
				
					-- apply buff
					
					local spellBuff = monster.SpellBuffs[const.MonsterBuff.Paralyze]
					spellBuff:Set(Game.Time + const.Minute * duration, rank, 0, 0, 0)
					
					-- append to message
					
					Game.TextBuffer = Game.TextBuffer .. " /Paralyzed"
				
				end
				
			end
			
		end
		
	end
	
	-- show message
	
	def(TextBuffer, delay)
	
end
mem.hookcall(0x00431358, 2, 0, applySpecialWeaponSkill)

-- Spell Overrides - a bunch of stuff that was here was externalized as of 0.8.3 to skem-spell-overrides

----------------------------------------------------------------------------------------------------
-- game initialization
----------------------------------------------------------------------------------------------------

function events.GameInitialized2()

	-- spell cost overrides were externalized as of 0.8.3 to skem-spell-overrides

	----------------------------------------------------------------------------------------------------
	-- populate global references
	----------------------------------------------------------------------------------------------------
	
	-- spellTxt id resolver - need to externalize to a module since multiple subcomponents need/want this
	
	for spellTxtId = 1, Game.SpellsTxt.high do
		spellTxtIds[Game.SpellsTxt[spellTxtId].Name] = spellTxtId
	end
	
	----------------------------------------------------------------------------------------------------
	-- monster customization was moved to skem-monster-overrides.lua as of 0.8.1
	-- modify monster statistics was moved to skem-monster-overrides.lua as of 0.8.1
	--	
	-- house prices
	----------------------------------------------------------------------------------------------------

	for houseIndex = 0, Game.Houses.high do
	
		house = Game.Houses[houseIndex]

		local housePrice = housePrices[house.Name]
		if housePrice ~= nil then
			house.Val = housePrice
		end
		
	end

	----------------------------------------------------------------------------------------------------
	-- book values adjustments were moved to skem-item-overrides.lua as of 0.8.2
	-- 
	-- class descriptions
	----------------------------------------------------------------------------------------------------
	Game.ClassDescriptions[const.Class.Paladin] ="A cross between Knight and Cleric, Paladins perform both roles well, but not as well as the more focused classes they borrow from.  Like Knights, Paladins can learn to use any type of weapon or armor, although they don’t have as many choices to begin with.  Paladins also begin with the Spirit realm of magic, and can also learn to use the Clerical Mind, Body and Light realms.  They cannot, however, learn to use the greater realm of Dark, nor any of the Elemental realms.  Paladins that are true to their cause may be promoted to Crusader (gaining one hit point and spell point per level) and ultimately to Hero (gaining another hit point and spell point per level).  Paladins may learn all of the secondary skills."
	Game.ClassDescriptions[const.Class.Crusader] = "Crusader is the first Paladin promotion.  Crusaders can learn to use any type of weapon or armor, and they can learn the Clerical magics of Spirit, Mind, and Body.  Crusaders enjoy the benefit of an extra hit point and spell point per level, and can be promoted to Heroes, gaining an additional hit point and spell point per level."
	Game.ClassDescriptions[const.Class.Hero] = "Hero is the second and last Paladin promotion.  Heroes can learn to use any type of weapon or armor, and they can learn the Clerical magics of Spirit, Mind, and Body.  Heroes enjoy the benefit of an extra two hit points and spell points per level." 
	Game.ClassDescriptions[const.Class.Archer] = "Like Paladins, the Archer is a hybrid of the Knight and Sorcerer classes.  Archers may learn to use any type of weapon (specializing in the bow, of course) but they may never learn the shield or plate armor skills.  They are compensated by beginning with the Air realm of magic and may eventually learn to use the rest of the Elemental realms.  The greater realm of Light is, however, beyond their grasp.  Archers can be promoted to Battle Mage (gaining one hit point and one spell point per level) and eventually may become Warrior Mages (gaining another hit point and spell point per level).  All of the secondary skills are open to the Archer.\n\nArchers are skilled Bow users and add 2 Attack per skill level.\n\nArchers are also swift dagger users, having a 5% bonus crit chance and critical damage at 75% with 1 dagger, 200% with 2 daggers"
	Game.ClassDescriptions[const.Class.BattleMage] = "Battle Mage is the first Archer promotion.  Battle Mages may learn to use any type of weapon, but they may never learn the shield or plate armor skills.  They may also learn the four elemental schools of magic of the Sorcerer.  Battle Mages enjoy the benefit of an extra hit point and spell point per level, and may be promoted to Warrior Mage, gaining another hit point and spell point per level.\n\nBattle Mage are Great Bow users and add 2 attack and 1 damage per skill level.\n\nArchers are also swift dagger users, having a 5% bonus crit chance and critical damage at 75% with 1 dagger, 200% with 2 daggers"
	Game.ClassDescriptions[const.Class.WarriorMage] = "Warrior Mage is the second and last Archer promotion.  Warrior Mages may learn to use any type of weapon, but they may never learn the shield or plate armor skills.  They may also learn the four elemental schools of magic of the Sorcerer.  Warrior Mages enjoy the benefit of an extra two hit points and spell points per level.\n\nWarrior Mage are formidable Bow users and add 2 attack, 2 damage and 1% Attack Speed per skill level.\n\nArchers are also swift dagger users, having a 5% bonus crit chance and critical damage at 75% with 1 dagger, 200% with 2 daggers"
	
	-- melee damage bonus
	
	
	
	for classIndex, value in pairs(classMeleeWeaponSkillDamageBonus) do
	
		Game.ClassDescriptions[classIndex] = Game.ClassDescriptions[classIndex] ..
			string.format(
				"\n\n%s - %s - %s adds %d - %.1f - %d additional damage per skill level to each distinct melee weapon type in hands.",
				Game.ClassNames[math.floor(classIndex / 3) * 3 + 0],
				Game.ClassNames[math.floor(classIndex / 3) * 3 + 1],
				Game.ClassNames[math.floor(classIndex / 3) * 3 + 2],	
				classMeleeWeaponSkillDamageBonus[math.floor(classIndex / 3) * 3 + 0],
				classMeleeWeaponSkillDamageBonus[math.floor(classIndex / 3) * 3 + 1],
				classMeleeWeaponSkillDamageBonus[math.floor(classIndex / 3) * 3 + 2]
			)
			
	end
	
	----------------------------------------------------------------------------------------------------
	-- skill descriptions
	----------------------------------------------------------------------------------------------------
	Game.SkillDescriptions[const.Skills.Bodybuilding] = "Bodybuilding skill adds hit points directly to your character’s hit point totals.  Multiply the skill in bodybuilding by the character's base class bonus (4 for knights, 2 for sorcerers, etc.) to get the total.  Expert ranking doubles this total and master triples it.\n\nEach point in skill will also grant Skill^2 of extra maximum health per skill level."
	--Game.SkillDescriptions[const.Skills.Bodybuilding] = string.format("Bodybuilding skill adds hit points directly to your character’s hit point totals.  Multiply the skill in bodybuilding by the character's base class bonus (4 for knights, 2 for sorcerers, etc.) to get the total.  Expert ranking doubles this total and master triples it.\n\nEach point in skill will also grant Skill^2 of extra maximum health per skill level.\nCurrent bonus is: %s",(Party[Game.CurrentPlayer].Skills[const.Skills.Bodybuilding]%64)^2)
	
	Game.SkillDescriptions[const.Skills.Meditation] = "Meditation skill adds spell points directly to your character’s spell point totals.  Multiply the skill in meditation by the character’s base class bonus (4 for sorcerers, 0 for knights, etc.) to get the total.  Expert ranking doubles this total and master triples it.\n\nEach point in skill will grant mana regeneration depending on maximum Mana and Meditation skill.\nHero and Warrior Mage get an extra 50% mana regeneration bonus."
	
	Game.SkillDescriptions[const.Skills.Bow] = Game.SkillDescriptions[const.Skills.Bow] ..
		string.format(
			"\n\nBase bonus Attack Speed: %d\n\nBonus increment per skill level\n------------------------------------------------------------\n          attack | speed | damage ",
			newWeaponBaseRecoveryBonuses[const.Skills.Bow]
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Bow] =
			string.format(
				"     %s |     %s |     %s | %s",
				formatSkillRankNumber(newWeaponSkillAttackBonuses[const.Skills.Bow][rank], 101),
				formatSkillRankNumber(newWeaponSkillRecoveryBonuses[const.Skills.Bow][rank], 158),
				formatSkillRankNumber(newWeaponSkillDamageBonuses[const.Skills.Bow][rank], 185),
				(rank == const.Master and "two arrows per shot" or "")
			)
	end

	Game.SkillDescriptions[const.Skills.Blaster] = Game.SkillDescriptions[const.Skills.Blaster] ..
		string.format(
			"\n\nBase bonus Attack speed: %d\n\nBonus increment per skill level\n------------------------------------------------------------\n          attack |",
			newWeaponBaseRecoveryBonuses[const.Skills.Blaster]
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Blaster] =
			string.format(
				"     %s |",
				formatSkillRankNumber(newWeaponSkillAttackBonuses[const.Skills.Blaster][rank], 101)
			)
	end
	
	Game.SkillDescriptions[const.Skills.Staff] = Game.SkillDescriptions[const.Skills.Staff] ..
		string.format(
			"\n\nBase bonus Attack speed: %d\n\nSpecial effects: Shrink and Feeblemind\nchance = %d%% + %d%% * level, duration = %d minutes\n\nBonus increment per skill level\n------------------------------------------------------------\n          attack | AC | resistance to all |",
			newWeaponBaseRecoveryBonuses[const.Skills.Staff],
			staffEffect["base"],
			staffEffect["multiplier"],
			staffEffect["duration"]
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Staff] =
			string.format(
				"     %s | %s |                  %s |",
				formatSkillRankNumber(newWeaponSkillAttackBonuses[const.Skills.Staff][rank], 101),
				formatSkillRankNumber(newWeaponSkillACBonuses[const.Skills.Staff][rank], 136),
				formatSkillRankNumber(newWeaponSkillResistanceBonuses[const.Skills.Staff][rank], 263)
			)
	end
	
	Game.SkillDescriptions[const.Skills.Sword] = Game.SkillDescriptions[const.Skills.Sword] ..
		string.format(
			"\n\nBase bonus Attack speed: %d\n\nCan be held in left hand as an auxiliary weapon.\n\nHolding by two hands adds %d damage per skill level.\n\nOne-hand Sword do not get any class damage bonus when in main hand\n\nBonus increment per skill level\n------------------------------------------------------------\n          attack | speed | damage |",
			newWeaponBaseRecoveryBonuses[const.Skills.Sword],
			twoHandedWeaponDamageBonus
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Sword] =
			string.format(
				"     %s |     %s |     %s |",
				formatSkillRankNumber(newWeaponSkillAttackBonuses[const.Skills.Sword][rank], 101),
				formatSkillRankNumber(newWeaponSkillRecoveryBonuses[const.Skills.Sword][rank], 158),
				formatSkillRankNumber(newWeaponSkillDamageBonuses[const.Skills.Sword][rank], 225)
			)
	end
	
--[[	Game.SkillDescriptions[const.Skills.Dagger] = Game.SkillDescriptions[const.Skills.Dagger]:gsub( "slower opponents'.", "slower opponents'. The dagger can also do more damage when you're fighting multiple enemies at once.")
	Game.SkillDescriptions[const.Skills.Dagger] = Game.SkillDescriptions[const.Skills.Dagger]:gsub( "Expert dagger fighters can wield a dagger in their left hand while using another weapon in their right.", "\nCan be held in left hand as an auxiliary weapon.")
	Game.SkillDescriptions[const.Skills.Dagger] = Game.SkillDescriptions[const.Skills.Dagger]:gsub( "Master dagger fighters have a chance of doing a triple damage attack.", "\nChance to deliver triple damage per attack.")
	Game.SkillDescriptions[const.Skills.Dagger] = Game.SkillDescriptions[const.Skills.Dagger] ..
		string.format(
			"\n\nBase bonus Attack speed: %d\n\n+ %2.1f damage per close enemy per skill level.\n\nBonus increment per skill level\n------------------------------------------------------------\n          attack | speed |",
			newWeaponBaseRecoveryBonuses[const.Skills.Dagger],
			daggerCrowdDamageMultiplier
		)
		]]
	Game.SkillDescriptions[const.Skills.Dagger] = "While daggers don't do the kind of damage that a sword or an axe can deliver, they are very quick—sometimes letting you get two attacks for every one of your slower opponents'.\n\nMain hand dagger do not get any class damage bonus\n\nDagger can be dual wielded at Novice Level and has 5+1% chance per skill level to deal critical damage, dealing 40% extra damage.\nDual wielding dagger will make your critical hits to deal 150% extra damage, allowing huge critical hits.\n\nBase bonus Attack speed: 40\n\nBonus increment per skill level\n------------------------------------------------------------\n          attack | speed |"
		
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Dagger] =
			string.format(
				"     %s |     %s |",
				formatSkillRankNumber(newWeaponSkillAttackBonuses[const.Skills.Dagger][rank], 101),
				formatSkillRankNumber(newWeaponSkillRecoveryBonuses[const.Skills.Dagger][rank], 158)
			)
	end
	
	Game.SkillDescriptions[const.Skills.Axe] = Game.SkillDescriptions[const.Skills.Axe] ..
		string.format(
			"\n\nBase bonus Attack speed: %d\n\nHolding by two hands adds %d damage per skill level.\n\nBonus increment per skill level\n------------------------------------------------------------\n          attack | speed | damage |",
			newWeaponBaseRecoveryBonuses[const.Skills.Axe],
			twoHandedWeaponDamageBonus
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Axe] =
			string.format(
				"     %s |     %s |       %s |",
				formatSkillRankNumber(newWeaponSkillAttackBonuses[const.Skills.Axe][rank], 101),
				formatSkillRankNumber(newWeaponSkillRecoveryBonuses[const.Skills.Axe][rank], 158),
				formatSkillRankNumber(newWeaponSkillDamageBonuses[const.Skills.Axe][rank], 228)
			)
	end
	
	Game.SkillDescriptions[const.Skills.Spear] = Game.SkillDescriptions[const.Skills.Spear] ..
		string.format(
			"\n\nBase bonus Attack speed: %d\n\nHolding by two hands adds %d damage per skill level.\n\nBonus increment per skill level\n------------------------------------------------------------\n          attack | damage | AC |",
			newWeaponBaseRecoveryBonuses[const.Skills.Spear],
			twoHandedWeaponDamageBonus
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Spear] =
			string.format(
				"     %s |       %s | %s |",
				formatSkillRankNumber(newWeaponSkillAttackBonuses[const.Skills.Spear][rank], 101),
				formatSkillRankNumber(newWeaponSkillDamageBonuses[const.Skills.Spear][rank], 171),
				formatSkillRankNumber(newWeaponSkillACBonuses[const.Skills.Spear][rank], 206)
			)
	end
	
	Game.SkillDescriptions[const.Skills.Mace] = Game.SkillDescriptions[const.Skills.Mace] ..
		string.format(
			"\n\nBase bonus Attack speed: %d\n\nSpecial effects: Paralyze\nchance = %d%% + 0.25 * level, duration = %d minutes\n\nBonus increment per skill level\n------------------------------------------------------------\n          attack | damage |",
			newWeaponBaseRecoveryBonuses[const.Skills.Mace],
			maceEffect["base"],
			maceEffect["multiplier"],
			maceEffect["duration"]
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Mace] =
			string.format(
				"     %s |       %s |",
				formatSkillRankNumber(newWeaponSkillAttackBonuses[const.Skills.Mace][rank], 101),
				formatSkillRankNumber(newWeaponSkillDamageBonuses[const.Skills.Mace][rank], 171)
			)
	end
	
	Game.SkillDescriptions[const.Skills.Shield] = Game.SkillDescriptions[const.Skills.Shield] ..
		string.format(
			"\n\nExperienced shield users can effectively cover the team from all kind of physical and magical projectiles reducing their impact damage. Each shield wearer in the party reduces damage by =%d%%= per each skill level multiplicatively. Knights reduces 2 percent per skill point instead.\n\nBonus increment per skill level and recovery penalty\n------------------------------------------------------------\n          AC | recovery penalty |",
			math.round(shieldProjectileDamageReductionPerLevel * 100)
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Shield] =
			string.format(
				" %s |                 %s |",
				formatSkillRankNumber(newArmorSkillACBonuses[const.Skills.Shield][rank], 77),
formatSkillRankNumber(Game.SkillRecoveryTimes[const.Skills.Shield + 1] * (rank == const.Novice and 1 or (rank == const.Expert and 0.5 or 0)), 209)
			)
	end
	
	Game.SkillDescriptions[const.Skills.Leather] = Game.SkillDescriptions[const.Skills.Leather] ..
		string.format(
			"\n\nLeather armor is the weakest but grants best resistance.\n\nBonus increment per skill level and recovery penalty\n------------------------------------------------------------\n          AC | recovery penalty | resistance |"
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Leather] =
			string.format(
				" %s |                 %s |          %s |",
				formatSkillRankNumber(newArmorSkillACBonuses[const.Skills.Leather][rank], 77),
				formatSkillRankNumber(Game.SkillRecoveryTimes[const.Skills.Leather + 1] * (rank == const.Novice and 1 or (rank == const.Expert and 0.5 or 0)), 209),
				formatSkillRankNumber(newArmorSkillResistanceBonuses[const.Skills.Leather][rank], 295)
			)
	end
	
	Game.SkillDescriptions[const.Skills.Chain] = Game.SkillDescriptions[const.Skills.Chain] ..
		string.format(
			"\n\nChain armor grants medium protection and mild resistance.\n\nBonus increment per skill level and recovery penalty\n------------------------------------------------------------\n          AC | recovery penalty | resistance |"
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Chain] =
			string.format(
				" %s |                 %s |          %s |",
				formatSkillRankNumber(newArmorSkillACBonuses[const.Skills.Chain][rank], 77),
				formatSkillRankNumber(Game.SkillRecoveryTimes[const.Skills.Chain + 1] * (rank == const.Novice and 1 or (rank == const.Expert and 0.5 or 0)), 209),
				formatSkillRankNumber(newArmorSkillResistanceBonuses[const.Skills.Chain][rank], 295)
			)
	end
	
	Game.SkillDescriptions[const.Skills.Plate] = Game.SkillDescriptions[const.Skills.Plate] ..
		string.format(
			"\n\nPlate armor is the strongest one.\n\nPlate wearer is percieved as a true battle hero who can learn swift maneuvering on a battlefield shielding the rest of the team from melee attackers.\n\nBonus increment per skill level and recovery penalty and cover chance\n------------------------------------------------------------\n          AC | recovery penalty | cover chance |"
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Plate] =
			string.format(
				" %s |                 %s |              %s |",
				formatSkillRankNumber(newArmorSkillACBonuses[const.Skills.Plate][rank], 77),
				formatSkillRankNumber(Game.SkillRecoveryTimes[const.Skills.Plate + 1] * (rank == const.Novice and 1 or (rank == const.Expert and 0.5 or 0)), 209),
				formatSkillRankNumber(plateCoverChances[rank] * 100, 316)
			)
	end
	
	Game.SkillDescriptions[const.Skills.Learning] =
		string.format(
			"Learning skill directly increases the experience your character receives from killed monsters with 9%% starting bonus."
		)
	for rank = const.Novice, const.Master do
		SkillDescriptionsRanks[rank][const.Skills.Learning] =
			string.format(
				"Experience increase = %d * level",
				learningSkillMultiplierByMastery[rank]
			)
	end

	----------------------------------------------------------------------------------------------------
	-- spell descriptions - externalized to spell-overrides as of 0.8.3
	
	-- professions
	----------------------------------------------------------------------------------------------------
	
	setProfessionChance(const.NPCProfession.Smith, 0)
	setProfessionChance(const.NPCProfession.Armorer, 0)
	setProfessionChance(const.NPCProfession.Alchemist, 0)
	setProfessionChance(const.NPCProfession.Guide, 0)
	setProfessionChance(const.NPCProfession.Counselor, 0)
	setProfessionChance(const.NPCProfession.Barrister, 0)
	setProfessionChance(const.NPCProfession.QuarterMaster, 0)
	setProfessionChance(const.NPCProfession.Cook, 0)
	setProfessionChance(const.NPCProfession.Negotiator, 0)
	setProfessionChance(const.NPCProfession.Peasant, 0)
	setProfessionChance(const.NPCProfession.Serf, 0)
	setProfessionChance(const.NPCProfession.Tailor, 0)
	setProfessionChance(const.NPCProfession.Laborer, 0)
	setProfessionChance(const.NPCProfession.Farmer, 0)
	setProfessionChance(const.NPCProfession.Cooper, 0)
	setProfessionChance(const.NPCProfession.Potter, 0)
	setProfessionChance(const.NPCProfession.Weaver, 0)
	setProfessionChance(const.NPCProfession.Cobbler, 0)
	setProfessionChance(const.NPCProfession.DitchDigger, 0)
	setProfessionChance(const.NPCProfession.Miller, 0)
	setProfessionChance(const.NPCProfession.Carpenter, 0)
	setProfessionChance(const.NPCProfession.StoneCutter, 0)
	setProfessionChance(const.NPCProfession.Jester, 0)
	setProfessionChance(const.NPCProfession.Trapper, 0)
	setProfessionChance(const.NPCProfession.Beggar, 0)
	setProfessionChance(const.NPCProfession.Rustler, 0)
	setProfessionChance(const.NPCProfession.Hunter, 0)
	setProfessionChance(const.NPCProfession.Scribe, 0)
	setProfessionChance(const.NPCProfession.Missionary, 0)
	setProfessionChance(const.NPCProfession.Clerk, 0)
	setProfessionChance(const.NPCProfession.Guard, 0)
	setProfessionChance(const.NPCProfession.FollowerofBaa, 0)
	setProfessionChance(const.NPCProfession.Noble, 0)
	setProfessionChance(const.NPCProfession.Gambler, 0)
	
	setProfessionCost(const.NPCProfession.ArmsMaster, 500)
	setProfessionCost(const.NPCProfession.WeaponsMaster, 2000)
	setProfessionCost(const.NPCProfession.Squire, 1500)
	setProfessionCost(const.NPCProfession.Burglar, 500)
	setProfessionCost(const.NPCProfession.Factor, 100)
	setProfessionCost(const.NPCProfession.Banker, 200)
	setProfessionCost(const.NPCProfession.Apprentice, 1500)
	setProfessionCost(const.NPCProfession.Instructor, 1500)
	setProfessionCost(const.NPCProfession.Teacher, 800)
	--setProfessionCost(const.NPCProfession.SpellMaster, 4000)
	--setProfessionCost(const.NPCProfession.Mystic, 2500)
	
	----------------------------------------------------------------------------------------------------
	-- class starting skills
	----------------------------------------------------------------------------------------------------
	
	-- knight
	Game.ClassKinds.StartingSkills[0][const.Skills.Spear] = 1
	Game.ClassKinds.StartingSkills[0][const.Skills.Leather] = 3
	Game.ClassKinds.StartingSkills[0][const.Skills.Sword] = 2
	Game.ClassKinds.StartingSkills[0][const.Skills.Chain] = 1
	Game.ClassKinds.StartingSkills[0][const.Skills.Repair] = 0
	Game.ClassKinds.StartingSkills[0][const.Skills.IdentifyItem] = 0
	-- cleric
	Game.ClassKinds.StartingSkills[1][const.Skills.Repair] = 0
	Game.ClassKinds.StartingSkills[1][const.Skills.IdentifyItem] = 0
	-- sorcerer
	Game.ClassKinds.StartingSkills[2][const.Skills.Repair] = 0
	Game.ClassKinds.StartingSkills[2][const.Skills.IdentifyItem] = 0
	-- paladin
	Game.ClassKinds.StartingSkills[3][const.Skills.Spear] = 1
	Game.ClassKinds.StartingSkills[3][const.Skills.Bodybuilding] = 2
	Game.ClassKinds.StartingSkills[3][const.Skills.Sword] = 2
	Game.ClassKinds.StartingSkills[3][const.Skills.Leather] = 3
	Game.ClassKinds.StartingSkills[3][const.Skills.Spirit] = 2
	Game.ClassKinds.StartingSkills[3][const.Skills.Mind] = 2
	Game.ClassKinds.StartingSkills[3][const.Skills.Body] = 2
	Game.ClassKinds.StartingSkills[3][const.Skills.Chain] = 1
	Game.ClassKinds.StartingSkills[3][const.Skills.Diplomacy] = 3
	Game.ClassKinds.StartingSkills[3][const.Skills.Light] = 3
	Game.ClassKinds.StartingSkills[3][const.Skills.Dagger] = 0
	Game.ClassKinds.StartingSkills[3][const.Skills.Repair] = 0
	Game.ClassKinds.StartingSkills[3][const.Skills.IdentifyItem] = 0
	-- archer

	Game.ClassKinds.StartingSkills[4][const.Skills.Spear] = 2
	Game.ClassKinds.StartingSkills[4][const.Skills.Leather] = 2
	Game.ClassKinds.StartingSkills[4][const.Skills.Dagger] = 1
	Game.ClassKinds.StartingSkills[4][const.Skills.Bow] = 1
	Game.ClassKinds.StartingSkills[4][const.Skills.Air] = 2
	Game.ClassKinds.StartingSkills[4][const.Skills.Water] = 2
	Game.ClassKinds.StartingSkills[4][const.Skills.Earth] = 2
	Game.ClassKinds.StartingSkills[4][const.Skills.Axe] = 3
	Game.ClassKinds.StartingSkills[4][const.Skills.Diplomacy] = 3
	Game.ClassKinds.StartingSkills[4][const.Skills.Water] = 2
	Game.ClassKinds.StartingSkills[4][const.Skills.Dark] = 3
	Game.ClassKinds.StartingSkills[4][const.Skills.Perception] = 3
	Game.ClassKinds.StartingSkills[4][const.Skills.Repair] = 0
	Game.ClassKinds.StartingSkills[4][const.Skills.IdentifyItem] = 0
	-- druid
	Game.ClassKinds.StartingSkills[5][const.Skills.Fire] = 2
	Game.ClassKinds.StartingSkills[5][const.Skills.Air] = 2
	Game.ClassKinds.StartingSkills[5][const.Skills.Mind] = 3
	Game.ClassKinds.StartingSkills[5][const.Skills.Repair] = 3
	Game.ClassKinds.StartingSkills[5][const.Skills.Learning] = 3
	Game.ClassKinds.StartingSkills[5][const.Skills.Meditation] = 2
	Game.ClassKinds.StartingSkills[5][const.Skills.Shield] = 0
	Game.ClassKinds.StartingSkills[5][const.Skills.Repair] = 0
	Game.ClassKinds.StartingSkills[5][const.Skills.IdentifyItem] = 0
	
		----------------------------------------------------------------------------------------------------
	-- Class starting HP/SP
	----------------------------------------------------------------------------------------------------
	--Paladin
	Game.Classes.HPFactor[const.Class.Paladin] = 3
	Game.Classes.HPFactor[const.Class.Crusader] = 4
	Game.Classes.HPFactor[const.Class.Hero] = 6
	Game.Classes.SPFactor[const.Class.Paladin] = 2
	Game.Classes.SPFactor[const.Class.Crusader] = 3
	Game.Classes.SPFactor[const.Class.Hero] = 3
	Game.ClassKinds.SPBase[3] = 8
	--Archer
	Game.Classes.HPFactor[const.Class.Archer] = 3
	Game.Classes.HPFactor[const.Class.BattleMage] = 4
	Game.Classes.HPFactor[const.Class.WarriorMage] = 5
	Game.Classes.SPFactor[const.Class.Archer] = 2
	Game.Classes.SPFactor[const.Class.BattleMage] = 3
	Game.Classes.SPFactor[const.Class.WarriorMage] = 4	
	Game.ClassKinds.SPBase[4] = 8
	Game.Classes.SPFactor[const.Class.ArchMage] = 6
	
	----------------------------------------------------------------------------------------------------
	-- item stats were externalized to skem-item-overrides.lua as of 0.8.2
	----------------------------------------------------------------------------------------------------
	
end

--
----------------------------------------------------------------------------------------------------
-- primary statistics effect
----------------------------------------------------------------------------------------------------

for index,value in ipairs(attributeBreakpoints) do
	mem.bytecodepatch(0x004C2860 + 2 * (index - 1), string.char(bit.band(value, 0xFF), bit.band(bit.rshift(value, 8), 0xFF)), 2)
end
for index,value in ipairs(attributeEffects) do
	mem.bytecodepatch(0x004C289C + 1 * (index - 1), string.char(bit.band(value, 0xFF)), 1)
end
--

--
--[[ skill advancement
local function calculateSkillAdvancementCost(level)
	return math.min(10, level + 1)
end
local function calculateSkillAdvancementCostToCheck(d, def)
	local level = bit.band(d.eax, 0x3F)
	local cost = calculateSkillAdvancementCost(level)
	d.edx = cost
end
mem.hook(0x0042D0E2, calculateSkillAdvancementCostToCheck, 0x6)
local function calculateRemainedSkillPointsAfterAdvancement(d, def)
	local level = bit.band(d.eax, 0x3F) - 1
	local cost = calculateSkillAdvancementCost(level)
	d.edi = d.edi - cost
end
mem.hook(0x0042D109, calculateRemainedSkillPointsAfterAdvancement, 0x5)
local function calculateSkillAdvancementCostToDisplay(d, def)
	local level = bit.band(d.eax, 0x3F) - 1
	local cost = calculateSkillAdvancementCost(level)
	d.eax = cost
end
mem.autohook2(0x0041F8E5, calculateSkillAdvancementCostToDisplay, 0xE)
local function adjustSkillPointsForSkillHighlight(d, def)
	local level = d.esi
	local cost = calculateSkillAdvancementCost(level)
	if d.ecx >= cost then
		d.ecx = level + 1
	else
		d.ecx = level
	end
end
mem.autohook2(0x00415A0B, adjustSkillPointsForSkillHighlight, 0x7)
--]]

-- modified Body Building calculation
-- max HP is increased by skill%
local function BBHook(amountReg)
	return function(d)
		local i, pl = GetPlayer(d.esi)
		local amount = d[amountReg]
		local s, m = SplitSkill(pl.Skills[const.Skills.Bodybuilding])
		
		enduranceBonus=pl:GetEndurance()/500
		if s == 0 then	
			if SETTINGS["StatsRework"]==true then
			d[amountReg] = d[amountReg] * (1+enduranceBonus)
			end
		return end
		d[amountReg] = amount + s^2		
		if SETTINGS["StatsRework"]==true then
		d[amountReg] = d[amountReg] * (1+enduranceBonus)
		end
	end
end

-- GetFullHP()
mem.autohook(0x482089, BBHook("eax"))
-- AddHP()
mem.autohook(0x47FD71, BBHook("edi"))
-- Rest()
mem.autohook(0x484FF3, BBHook("edi"))
-- HP regeneration
mem.autohook(0x487F05, BBHook("edi"))
mem.autohook(0x487D8A, BBHook("edi"))

-- allow to hold sword in left hand at novice rank
mem.asmpatch(0x0045A4AB, "test   BYTE [ebp+0x61],0xFF", 0x4)

-- allow to hold dagger in left hand at novice rank
mem.asmpatch(0x0045A3E8, "test   BYTE [ebp+0x62],0xFF", 0x4)

-- stat boosts; externalized to spell-overrides as of 0.8.3 
-- learning skill bonus multiplier
local function setLearningSkillBonusMultiplier(d, def)
	d.ecx = d.ecx + learningSkillExtraMultiplier
end
mem.autohook(0x004215E5, setLearningSkillBonusMultiplier, 5)

-- navigateMissile
local function navigateMissile(object)

	-- exclude some special non targeting spells
	if
		-- Fire Blast
		object.SpellType == 8
		or
		-- Meteor Shower
		object.SpellType == 9
		or
		-- Sparks
		object.SpellType == 15
		or
		-- Starburst
		object.SpellType == 22
		or
		-- Poison Spray
		object.SpellType == 26
		or
		-- Shrapmetal
		object.SpellType == 92
		or
		-- Ice Blast
		object.SpellType == 32
		-- also need to add Toxic Cloud and Rock Blast to this set
	then
		return
	end
	
	-- object parameters
	local ownerKind = bit.band(object.Owner, 7)
	local targetKind = bit.band(object.Target, 7)
	local targetIndex = bit.rshift(object.Target, 3)
	
	if targetIndex > Map.Monsters.high then
		return
	end
	
	-- current position
	local currentPosition = {["X"] = object.X, ["Y"] = object.Y, ["Z"] = object.Z, }
	
	-- process only missiles between party and monster
	-- target position
	local targetPosition
	if ownerKind == const.ObjectRefKind.Party and targetKind == const.ObjectRefKind.Monster then
		local mapMonster = Map.Monsters[targetIndex]
		-- target only alive monster
		if mapMonster.HitPoints > 0 then
			targetPosition = {["X"] = mapMonster.X, ["Y"] = mapMonster.Y, ["Z"] = mapMonster.Z + mapMonster.BodyHeight * 0.75, }
		else
			return
		end
	-- assume all objects not owned by party and without target are targetting party
	-- this creates issues with cosmetic projectiles like CI Obelisk Arena Paralyze and Gharik/Baa lava fireballs
	elseif ownerKind ~= const.ObjectRefKind.Party and targetKind == const.ObjectRefKind.Nothing  then
		targetPosition = {["X"] = Party.X, ["Y"] = Party.Y, ["Z"] = Party.Z + 120, }
	else
		-- ignore other missiles targetting
		return
	end
	
	-- speed
	local speed = math.sqrt(object.VelocityX * object.VelocityX + object.VelocityY * object.VelocityY + object.VelocityZ * object.VelocityZ)
	
	-- process only objects with non zero speed
	if speed == 0 then
		return
	end
	
	-- direction
	local direction = {["X"] = targetPosition.X - currentPosition.X, ["Y"] = targetPosition.Y - currentPosition.Y, ["Z"] = targetPosition.Z - currentPosition.Z, }
	-- directionLength
	local directionLength = math.sqrt(direction.X * direction.X + direction.Y * direction.Y + direction.Z * direction.Z)
	
	-- normalization koefficient
	local koefficient = speed / directionLength
	
	-- new velocity
	local newVelocity = {["X"] = koefficient * direction.X, ["Y"] = koefficient * direction.Y, ["Z"] = koefficient * direction.Z, }
	
	-- set new velocity
	object.VelocityX = newVelocity.X
	object.VelocityY = newVelocity.Y
	object.VelocityZ = newVelocity.Z
	
end

-- game tick related functionality
local homingProjectiles = SETTINGS.HomingProjectiles
function events.Tick()

	-- navigateMissiles
	if homingProjectiles then
		for objectIndex = 1,Map.Objects.high do
			local object =  Map.Objects[objectIndex]
			navigateMissile(object)
		end
	end
end

-- feeblemind fix externalized to spell-overrides as of 0.8.3

-- Summon hirelings
local function bringMonsterToParty(monster)
	monster.X = Party.X
	monster.Y = Party.Y
	monster.Z = Party.Z
end
local function setNPCProfession(npcId, profession)
	-- mem.u4[0x006B74F0 + 0x3C * npcId + 0x18] = profession
	Game.StreetNPC[npcId].Profession = profession
end
local function bringHirelingsToParty(professions)
	if Map.IsIndoor() then
		MessageBox("This feature works outdoor only.")
		return
	end
	local professionIndex = 1
	for monsterIndex = 0, Map.Monsters.high do
		local monster = Map.Monsters[monsterIndex]
		if
			-- outdoor
			monster.Room == 0
			and
			-- peasant
			Game.MonstersTxt[monster.Id].HostileType == 0
			and
			-- not removed
			monster.AIState ~= const.AIState.Removed
		then
			setNPCProfession(monster.NPC_ID - 1, professions[professionIndex])
			bringMonsterToParty(monster)
			professionIndex = professionIndex + 1
			if professionIndex > #professions then
				break
			end
		end
	end
end
function events.KeyDown(t)
	-- Hirelings
	if t.Alt then
		if t.Key == const.Keys["1"] then
			bringHirelingsToParty({const.NPCProfession.WeaponsMaster, const.NPCProfession.Squire, })
		elseif t.Key == const.Keys["2"] then
			bringHirelingsToParty({const.NPCProfession.SpellMaster, const.NPCProfession.Mystic, })
		elseif t.Key == const.Keys["3"] then
			bringHirelingsToParty({const.NPCProfession.Enchanter, })
		elseif t.Key == const.Keys["4"] then
			bringHirelingsToParty({const.NPCProfession.Instructor, const.NPCProfession.Teacher, })
		elseif t.Key == const.Keys["5"] then
			bringHirelingsToParty({const.NPCProfession.Banker, const.NPCProfession.Factor, })
		elseif t.Key == const.Keys["6"] then
			bringHirelingsToParty({const.NPCProfession.Merchant, const.NPCProfession.Trader, })
		elseif t.Key == const.Keys["7"] then
			bringHirelingsToParty({const.NPCProfession.Pathfinder, const.NPCProfession.Tracker, })
		elseif t.Key == const.Keys["8"] then
			bringHirelingsToParty({const.NPCProfession.WindMaster, const.NPCProfession.WaterMaster, })
		end
	end
end

--[[ on load map - this block was externalized to the separate Map scripts

function events.LoadMap()
	
	-- disable stats fountains
	-- externalized to the separate map scripts as of 0.8.4
	-- Free Haven
	if Game.Map.Name == "outc2.odm" then
		-- Might fountain
		Game.MapEvtLines:RemoveEvent(161)
	-- Bootleg Bay
	elseif Game.Map.Name == "outd2.odm" then
		-- Intellect fountain
		Game.MapEvtLines:RemoveEvent(102)
		-- Personality fountain
		Game.MapEvtLines:RemoveEvent(103)
	-- Mire of the Damned
	elseif Game.Map.Name == "outc3.odm" then
		-- Endurance fountain
		Game.MapEvtLines:RemoveEvent(100)
	-- Silver Cove
	elseif Game.Map.Name == "outd1.odm" then
		-- Accuracy fountain
		Game.MapEvtLines:RemoveEvent(164)
		-- Speed fountain
		Game.MapEvtLines:RemoveEvent(165)
	-- New Sorpigal
	elseif Game.Map.Name == "oute3.odm" then
		-- Luck fountain
		Game.MapEvtLines:RemoveEvent(110)
	end
	
end]]

-- modify monster engagement distance

mem.asmpatch(0x004021A3, string.format("cmp     esi, %d", extendedEngagementDistance), 6)

local function modifiedFastDistance(d, def, dx, dy, dz)

	-- call original function
	
	local result = def(dx, dy, dz)
	
	-- pretend that distance to the monster is shorter if party is already engaged
	
	if bit.band(Party.StateBits, 0x20) ~= 0 then
	
		if result >= standardEngagementDistance and result < extendedEngagementDistance then
			result = standardEngagementDistance
		end
		
	end
		
	-- return result
	
	return result
	
end
mem.hookcall(0x00401117, 2, 1, modifiedFastDistance)

-- disable monster zig-zag movement

mem.asmpatch(0x00402CF6, string.format("add     edx, 0h"), 6)
mem.asmpatch(0x00402D09, string.format("add     eax, 0h"), 5)

----------------------------------------------------------------------------------------------------
-- temple healing price is scaled with party experience level
----------------------------------------------------------------------------------------------------

local function modifiedTempleHealingPrice(d, def, playerPointer, cost)

	local playerIndex, player = GetPlayer(playerPointer)
	
	-- call original function
	
	local result = def(playerPointer, cost)
	
	-- get ailment multiplier
	
	local ailmentMultiplier = (result / convertIntToFloat(cost))
	
	-- get party experience level
	
	local partyExperienceLevel = getPartyExperienceLevel()
	
	-- get restored HP and SP
	
	local fullHP = player:GetFullHP()
	local fullSP = player:GetFullSP()
	local restoredHP = math.max(0, fullHP - player.HP)
	local restoredSP = math.max(0, fullSP - player.SP)
	
	-- get healing price
	
	local healingPrice = math.max(0, math.round(partyExperienceLevel * (templeHealingPricePerHP * restoredHP + templeHealingPricePerSP * restoredSP)))
	
	-- get restoration price
	
	local restorationPrice = math.max(0, math.round(partyExperienceLevel * (templeHealingPricePerHP * fullHP + templeHealingPricePerSP * fullSP) * (ailmentMultiplier - 1)))
	
	-- get total price
	
	local totalPrice = (healingPrice + restorationPrice)^0.6
	
	-- return result
	
	return totalPrice
	
end
mem.hookcall(0x0049DD76, 1, 1, modifiedTempleHealingPrice)

----------------------------------------------------------------------------------------------------
-- inn room price is scaled with party experience level
----------------------------------------------------------------------------------------------------

local function modifiedInnRoomPrice(d, def)

	-- call original function
	
	local result = def()
	
	-- overwrite value
	
	result = innRoomPrice
	
	-- get party experience level
	
	local partyExperienceLevel = getPartyExperienceLevel()
	
	-- scale price with party experience level
	
	result = result * partyExperienceLevel
	
	-- return result
	
	return result
	
end
mem.hookcall(0x0049ED16, 0, 0, modifiedInnRoomPrice)

----------------------------------------------------------------------------------------------------
-- inn food quantity is constant
-- need to fix: only affects dialog, not actual results. 
-- re-evaluate pricing based on actual units of food sold?
----------------------------------------------------------------------------------------------------

local function modifiedInnFoodQuantity(d, def)

	-- call original function
	
	local result = def()
	
	-- overwrite value
	
	result = innFoodQuantity
	
	-- return result
	
	return result
	
end
mem.hookcall(0x0049EEF9, 0, 0, modifiedInnFoodQuantity)

----------------------------------------------------------------------------------------------------
-- inn food price is scaled with party experience level
-- need to modify this to be relative to amount of food inn is actually selling, so that food price
-- is constant across towns regardless of the actual amount of food provided
----------------------------------------------------------------------------------------------------

local function modifiedInnFoodPrice(d, def)

	-- call original function
	
	local result = def()
	
	-- overwrite value
	
	result = innFoodPrice
	
	-- get party experience level
	
	local partyExperienceLevel = getPartyExperienceLevel()
	
	-- scale price with party experience level
	
	result = result * partyExperienceLevel
	
	-- return result
	
	return result
	
end
mem.hookcall(0x0049ED69, 0, 0, modifiedInnFoodPrice)

-- plate wearer attracts attaks

local function modifiedMonsterChooseTargetMember(d, def, monsterPointer)

	-- execute original code
	
	local targetPlayerIndex = def(monsterPointer)
	
	-- get target player
	
	local targetPlayer = Party.Players[targetPlayerIndex]
	local targetPlayerEquipmentData = getPlayerEquipmentData(targetPlayer)
	
	-- set default substitute player = target player
	
	local substitutePlayerIndex = targetPlayerIndex
	
	-- switch target player only if they do not wear plate
	
	if targetPlayerEquipmentData.armor.skill ~= const.Skills.Plate then
		
		local roll = math.random()
		local substituteProbability = 0
		
		for playerIndex = 0,3 do
		
			if playerIndex ~= targetPlayerIndex then
			
				local player = Party.Players[playerIndex]
				local playerEquipmentData = getPlayerEquipmentData(player)
				
				-- switch to substitute player only if they wear plate
				
				if player:IsConscious() and playerEquipmentData.armor.skill == const.Skills.Plate then
				
					substituteProbability = substituteProbability + plateCoverChances[playerEquipmentData.armor.rank]
					
					if roll < substituteProbability then
						substitutePlayerIndex = playerIndex
						Game.ShowStatusText(string.format("%s covered %s", player.Name, targetPlayer.Name), 10)
						break
					end
					
				end
				
			end
			
		end
		
	end
	
	-- return substitute player index
	
	return substitutePlayerIndex

end
mem.hookcall(0x00430C4B, 0, 1, modifiedMonsterChooseTargetMember)

----------------------------------------------------------------------------------------------------
-- shield holder protects from projectiles
----------------------------------------------------------------------------------------------------

local function modifiedCharacterStrikeWithDamageProjectile(d, def, playerPointer, damage, damageKind)

	-- compute damage reduction
	
	local damageMultiplier = 1.0
	
	for playerIndex = 0, 3 do
	
		local player = Party.Players[playerIndex]
		local playerEquipmentData = getPlayerEquipmentData(player)
		
		if playerEquipmentData.shield.equipped then
			local classMultiplier = table.find(knightClasses, player.Class) and (shieldDoubleSkillEffectForKnights and 1 or 2) or 1
			damageMultiplier = damageMultiplier * math.pow(1 - (shieldProjectileDamageReductionPerLevel * classMultiplier), playerEquipmentData.shield.level)
		end
		
	end
	
	damage = math.ceil(damage * damageMultiplier)

	-- execute original code
	
	def(playerPointer, damage, damageKind)
	
end
mem.hookcall(0x0043203C, 1, 2, modifiedCharacterStrikeWithDamageProjectile)

----------------------------------------------------------------------------------------------------
-- display damage rate
----------------------------------------------------------------------------------------------------

-- shift positions in character stats display and remove mandatory + in attack

mem.bytecodepatch(0x004BD3FB, "\048\056\048\032\037", 5)
mem.bytecodepatch(0x004BD3EF, "\048\056\048\032\037", 5)
mem.bytecodepatch(0x004BD3E3, "\048\056\048\032\037", 5)

local function getAverageDamageRate(player, ranged, monsterArmorClass)

	-- set default armor class
	
	if monsterArmorClass == nil then
		monsterArmorClass = 100
	end

	-- get combat parameters
	
	local recovery = player:GetAttackDelay(ranged)
	local attack
	local damageRangeText
	if ranged then
		attack = player:GetRangedAttack()
	else
		attack = player:GetMeleeAttack()
	end
	if ranged then
		damageRangeText = player:GetRangedDamageRangeText()
	else
		damageRangeText = player:GetMeleeDamageRangeText()
	end
	
	if attack == nil or type(attack) ~= "number" or recovery == nil  or type(recovery) ~= "number" or damageRangeText == nil or type(damageRangeText) ~= "string" then
		return 0
	end
	
	local damageMinText, damageMaxText = string.match(damageRangeText, "(-?%d+)%s*-%s(-?%d+)")
	local damageMin = tonumber(damageMinText)
	local damageMax = tonumber(damageMaxText)
	
	if damageMin == nil or type(damageMin) ~= "number" or damageMax == nil or type(damageMax) ~= "number" then
		return 0
	end
	
	local averageDamage = (damageMax + damageMin) / 2
	
	-- calculate average damage rate against monster and no physical resistance
	
	local chanceToHit = (15 + 2 * attack) / (15 + 2 * attack + 15 + monsterArmorClass)
	local averageDamageRate = math.round(averageDamage * chanceToHit * (100 / recovery))
	
	-- return value
	
	return averageDamageRate
	
end
local function modifiedDisplayReferenceMeleeAttack(d, def, dlg, font, x, y, color, text, arg_10, arg_14)

	-- get player
	
	local playerIndex, player = GetPlayer(d.ebp)
	
	-- get average damage rate
	
	local averageDamageRate = getAverageDamageRate(player, false)
	
	-- modify text buffer
	
	if averageDamageRate ~= nil then
		local averageDamageRateText = string.format("%d", averageDamageRate)
		averageDamageRateText = StrColor(0x00,0xFF,0x00) .. StrLeft(40) .. "/" .. StrLeft(84 - 12 * string.len(averageDamageRateText)) .. averageDamageRateText .. StrColor(0,0,0)
		Game.TextBuffer = string.gsub(Game.TextBuffer, "^+", "")
		Game.TextBuffer = Game.TextBuffer .. averageDamageRateText
	end
	
	-- execute original code
	
	def(dlg, font, x, y, color, text, arg_10, arg_14)
	
end
mem.hookcall(0x00416F51, 2, 6, modifiedDisplayReferenceMeleeAttack)
local function modifiedDisplayReferenceRangedAttack(d, def, dlg, font, x, y, color, text, arg_10, arg_14)

	-- get player
	
	local playerIndex, player = GetPlayer(d.ebp)
	
	-- get average damage rate
	
	local averageDamageRate = getAverageDamageRate(player, true)
	
	-- append to text buffer
	
	if averageDamageRate ~= nil then
		local averageDamageRateText = string.format("%d", averageDamageRate)
		averageDamageRateText = StrColor(0x00,0xFF,0x00) .. StrLeft(40) .. "/" .. StrLeft(84 - 12 * string.len(averageDamageRateText)) .. averageDamageRateText .. StrColor(0,0,0)
		Game.TextBuffer = string.gsub(Game.TextBuffer, "^+", "")
		Game.TextBuffer = Game.TextBuffer .. averageDamageRateText
	end
	
	-- execute original code
	
	def(dlg, font, x, y, color, text, arg_10, arg_14)
	
end
mem.hookcall(0x00416FF8, 2, 6, modifiedDisplayReferenceRangedAttack)
local function modifiedDisplayStatistictsMeleeAttack(d, def, dlg, font, x, y, color, str)

	-- get player
	
	local player = Party.Players[Game.CurrentPlayer]
	
	-- get average damage rate
	
	local averageDamageRate = getAverageDamageRate(player, false)

	-- append to text buffer

	if averageDamageRate ~= nil then
		local averageDamageRateText = string.format("%d", averageDamageRate)
		averageDamageRateText = StrColor(0x00,0xFF,0x00) .. StrLeft(140) .. "/" .. StrLeft(184 - 12 * string.len(averageDamageRateText)) .. averageDamageRateText .. StrColor(0,0,0)
		Game.TextBuffer = string.sub(Game.TextBuffer, 1, string.len(Game.TextBuffer) - 1) .. averageDamageRateText .. "\n"
	end
	
	-- execute original code
	
	def(dlg, font, x, y, color, str)
	
end
mem.hookcall(0x00414A3B, 2, 4, modifiedDisplayStatistictsMeleeAttack)
local function modifiedDisplayStatisticsRangedAttack(d, def, dlg, font, x, y, color, str)

	-- get player
	
	local player = Party.Players[Game.CurrentPlayer]
	
	-- get average damage rate
	
	local averageDamageRate = getAverageDamageRate(player, true)

	-- append to text buffer

	if averageDamageRate ~= nil then
		local averageDamageRateText = string.format("%d", averageDamageRate)
		averageDamageRateText = StrColor(0x00,0xFF,0x00) .. StrLeft(140) .. "/" .. StrLeft(184 - 12 * string.len(averageDamageRateText)) .. averageDamageRateText .. StrColor(0,0,0)
		Game.TextBuffer = string.sub(Game.TextBuffer, 1, string.len(Game.TextBuffer) - 1) .. averageDamageRateText .. "\n"
	end
	
	-- execute original code
	
	def(dlg, font, x, y, color, str)
	
end
mem.hookcall(0x00414AD5, 2, 4, modifiedDisplayStatisticsRangedAttack)

----------------------------------------------------------------------------------------------------
-- handle game actions

-- Skill Linking code was externalized to skem-skill-linking.lua as of 0.8.1
-- The skill linking code was the only code injected into evt.Action(t), so the whole function has been removed 
--
-- Monster Infobox code was externalized to skem-monster-infobox.lua as of 0.8.1
--
-- raise immunity threshold (revert for RA)
----------------------------------------------------------------------------------------------------

mem.asmpatch(0x00421DD9, string.format("cmp     eax, %d", 1000), 5)

----------------------------------------------------------------------------------------------------
-- shrine events
----------------------------------------------------------------------------------------------------

function configureShrineEvent(eventId, shrineIndex, statisticsName, hintStringIndex, statusTextNothingIndex, statusText10Index, statusText3Index)

	-- initialize shrine blessings table and value

	if vars.shrineBlessings == nil then
		vars.shrineBlessings = {}
	end
	if vars.shrineBlessings[shrineIndex] == nil then
		vars.shrineBlessings[shrineIndex] = 0
	end

	-- calculate number of blessings available

	local availableBlessings = 1 + (Game.Year - Game.BaseYear)

	-- rewrite event

	Game.MapEvtLines:RemoveEvent(eventId)
	evt.hint[eventId] = evt.str[hintStringIndex]
	evt.map[eventId] = function()
		if availableBlessings > vars.shrineBlessings[shrineIndex] then
			if evt.Cmp("QBits", 207 + shrineIndex) then
				evt.ForPlayer("All")
				evt.Add(statisticsName, 3)
				evt.StatusText(statusText3Index)
			else
				evt.Set("QBits", 207 + shrineIndex)
				evt.ForPlayer("All")
				evt.Add(statisticsName, 10)
				evt.StatusText(statusText10Index)
			end
			vars.shrineBlessings[shrineIndex] = vars.shrineBlessings[shrineIndex] + 1
		else
			--evt.StatusText(statusTextNothingIndex)
			Game.ShowStatusText("Return next year")
		end
	end

end

----------------------------------------------------------------------------------------------------
-- melee damage monster from party hook
----------------------------------------------------------------------------------------------------

local function meleeAttackMonster(d, def, attackStructure, monsterIndex, knockbackParameter)

	local attackType = bit.band(attackStructure, 7)
	local playerIndex = bit.rshift(attackStructure, 2)
	
	-- execute original function
	
	def(attackStructure, monsterIndex, knockbackParameter)
	
	-- non melee attack
	
	if attackType ~= 2 then
		return
	end
	
	-- process extra hits
	
	local attackType = bit.band(attackStructure, 7)
	local playerIndex = bit.rshift(attackStructure, 2)
	

	
end
mem.hookcall(0x0042A228, 2, 1, meleeAttackMonster)

----------------------------------------------------------------------------------------------------
-- guardian angel changes externalized to spell-overrides as of 0.8.3

--[[ Monster_CalculateDamage externalized to spell-overrides as of 0.8.3
----------------------------------------------------------------------------------------------------

local function modifiedMonsterCalculateDamage(d, def, monsterPointer, attackType)

	-- get monster

	local monsterIndex, monster = GetMonster(d.edi)

	-- execute original code

	local damage = def(monsterPointer, attackType)

	if attackType == 0 then
		-- primary attack is calculated correctly
		return damage
	elseif attackType == 1 then
		-- secondary attach uses attack1 DamageAdd
		-- replace Attack1.DamageAdd with Attack2.DamageAdd
		damage = damage - monster.Attack1.DamageAdd + monster.Attack2.DamageAdd
		return damage
	elseif attackType == 2 and (monster.Spell == 44 or monster.Spell == 95) then
		-- don't recalculate Mass Distortion or Finger of Death
		return damage
	end

	-- calculate spell damage same way as for party

	local spellSkill, spellMastery = SplitSkill(monster.SpellSkill)
	damage = Game.CalcSpellDamage(monster.Spell, spellSkill, spellMastery, 0)

	return damage

end
mem.hookcall(0x00431D4F, 1, 1, modifiedMonsterCalculateDamage)
mem.hookcall(0x00431EE3, 1, 1, modifiedMonsterCalculateDamage)
]]

-- dagger critical chance hooks
local DaggerCritsIgnoreElementalBonuses = false
-- crit messages
-- variables need to be global (in table to not pollute namespace) for mem.topointer to always work correctly
CritStrings = {attack = "%s critically hits %s for %lu damage!", kill = "%s critically inflicts %lu points killing %s!"}
-- disable old crits
-- mainhand
mem.asmpatch(0x47E4F8, "jmp short " .. (0x47E526 - 0x47E4F8))
-- offhand
mem.asmpatch(0x47E61C, "jmp short " .. (0x47E652 - 0x47E61C))

-- new crit hook
local NewCode = mem.asmpatch(0x47E7FA, [[
	nop
	nop
	nop
	nop
	nop
	cmp eax,1
	pop ebx
	jge @skip
	mov eax,1
	@skip:
]], 0xB)

local crit, mul
mem.hook(NewCode, function(d)
	-- when not using hookjmp() (for example in plain hook()), esp points to return address,
	-- not to position before return address (the one esp pointed to before hook proc call)
	-- need to add 4 to esp
	local i, pl = GetPlayer(mem.u4[d.esp + 4])
	local s, m = SplitSkill(pl.Skills[const.Skills.Dagger])
	crit = false -- just in case
	if s == 0 or m < const.Expert then return end
	-- returns item struct, not item index
	local main, off = pl:GetActiveItem(const.ItemSlot.MainHand, false), pl:GetActiveItem(const.ItemSlot.ExtraHand, false)
	-- damage multiplier
	local daggerAmount = (main and main:T().Skill == const.Skills.Dagger and 1 or 0) + (off and off:T().Skill == const.Skills.Dagger and 1 or 0)
	if daggerAmount > 0 then
		-- (5 + skill * 1) / 100 is equal to 5% + 1% per skill
		local chance = 5 + s + (classDaggerCriticalChanceBonus[pl.Class] or 0)
		if math.random(1, 100) <= chance then
			local classMul = daggerClassCriticalMultipliers[pl.Class] and daggerClassCriticalMultipliers[pl.Class][daggerAmount + 1]
			mul = classMul or daggerDefaultCriticalMultipliers[daggerAmount + 1]
			d.eax = d.eax * mul
			crit = true
		end
	end
end)

-- elemental spcbonus damage is buried in mm6patch dll
if not DaggerCritsIgnoreElementalBonuses and mem.dll.kernel32.GetPrivateProfileIntA("Settings", "DaggerCritsIgnoreElementalBonuses", 0, ".\\mm6.ini") ~= 1 then
	local errorMsg = "%s and dagger crit mechanic change will no longer work correctly. " ..
	string.format("To disable problematic part, edit this file, that is %q, and change line %q to %q, or ",
		debug.getinfo(1, "S").short_src, "local DaggerCritsIgnoreElementalBonuses = false", "local DaggerCritsIgnoreElementalBonuses = true"
	) .. string.format("edit file %q in main game directory, and add line %q in [Settings] section, " ..
	"or if the option already exists, modify it", "mm6.ini", "DaggerCritsIgnoreElementalBonuses=1"
	) .. ". Elemental damage won't be multiplied by crits anymore."
	local patchAddr = mem.dll.mm6patch and mem.dll.mm6patch["?ptr"]
	if not patchAddr or patchAddr == 0 then
		error(string.format(errorMsg, "Couldn't get MM6Patch.dll address"))
	end
	-- failsafe in case of patch update changing instructions/addresses
	if mem.GetInstructionSize(patchAddr + 0x34444) ~= 5 or mem.GetInstructionSize(patchAddr + 0x34449) ~= 2 then
		error(string.format(errorMsg, "MM6Patch.dll code changed"))
	end
	local maxMonHP = bit.lshift(1, 15) - 1;
	mem.autohook2(patchAddr + 0x34444, function(d)
		if crit then
			d.ax = math.min(maxMonHP, d.ax * mul)
		end
	end, 0x7)
end
if SETTINGS["StatsRework"]==true then
	function events.CalcDamageToMonster(t)
		local data = WhoHitMonster()	
		--luck/accuracy bonus
			luck=data.Player:GetLuck()
			accuracy=data.Player:GetAccuracy()
			critDamage=accuracy/250
			critChance=5+luck/10
			roll=math.random(1, 100)
			if roll <= critChance then
				t.Result=t.Result*(1.5+critDamage)
				crit2=true
			end
	end
else
crit2=false
end

mem.autohook2(0x431276, function(d)
	if crit or crit2 then
		d.eax = mem.topointer(CritStrings.kill)		
		if crit then
			mul = 1
		end
		crit2 = false
		crit = false
	end
end)
mem.autohook2(0x431339, function(d)
	if crit or crit2 then
		d.eax = mem.topointer(CritStrings.attack)
		if crit then
			mul = 1
		end
		crit2 = false
		crit = false
	end
end)

--Bow Calculation
function events.ModifyItemDamage(t)
    local s, m = SplitSkill(t.Player.Skills[const.Skills.Bow])
    if t.Item:T().EquipStat == const.ItemType.Missile - 1 then
        local masteryBonus = 0
        if m == const.Basic then
            masteryBonus = 1
        elseif m == const.Expert then
            masteryBonus = 2
        elseif m == const.Master then
            masteryBonus = 2
        end
				-- increase s based on ArmsMaster, WeaponsMaster, or Squire professions of hired NPCs
		local hiredNPC = Game.Party.HiredNPC
		local npcBonus = 0
		if (hiredNPC[1] ~= nil and hiredNPC[1].Profession == const.NPCProfession.ArmsMaster) or
			(hiredNPC[2] ~= nil and hiredNPC[2].Profession == const.NPCProfession.ArmsMaster) then
			npcBonus = npcBonus + 2
		end
		if (hiredNPC[1] ~= nil and hiredNPC[1].Profession == const.NPCProfession.WeaponsMaster) or
			(hiredNPC[2] ~= nil and hiredNPC[2].Profession == const.NPCProfession.WeaponsMaster) then
			npcBonus = npcBonus + 3
		end
		if (hiredNPC[1] ~= nil and hiredNPC[1].Profession == const.NPCProfession.Squire) or
			(hiredNPC[2] ~= nil and hiredNPC[2].Profession == const.NPCProfession.Squire) then
			npcBonus = npcBonus + 2
		end
		s = s + npcBonus
        t.Result = t.Result + s * (masteryBonus)
        if classRangedWeaponSkillDamageBonus[t.Player.Class] ~= nil then
            t.Result = t.Result + classRangedWeaponSkillDamageBonus[t.Player.Class] * s
        end
    end
end

local vals = 
{	1000,	200,
	995,	199,
	990,	198,
	985,	197,
	980,	196,
	975,	195,
	970,	194,
	965,	193,
	960,	192,
	955,	191,
	950,	190,
	945,	189,
	940,	188,
	935,	187,
	930,	186,
	925,	185,
	920,	184,
	915,	183,
	910,	182,
	905,	181,
	900,	180,
	895,	179,
	890,	178,
	885,	177,
	880,	176,
	875,	175,
	870,	174,
	865,	173,
	860,	172,
	855,	171,
	850,	170,
	845,	169,
	840,	168,
	835,	167,
	830,	166,
	825,	165,
	820,	164,
	815,	163,
	810,	162,
	805,	161,
	800,	160,
	795,	159,
	790,	158,
	785,	157,
	780,	156,
	775,	155,
	770,	154,
	765,	153,
	760,	152,
	755,	151,
	750,	150,
	745,	149,
	740,	148,
	735,	147,
	730,	146,
	725,	145,
	720,	144,
	715,	143,
	710,	142,
	705,	141,
	700,	140,
	695,	139,
	690,	138,
	685,	137,
	680,	136,
	675,	135,
	670,	134,
	665,	133,
	660,	132,
	655,	131,
	650,	130,
	645,	129,
	640,	128,
	635,	127,
	630,	126,
	625,	125,
	620,	124,
	615,	123,
	610,	122,
	605,	121,
	600,	120,
	595,	119,
	590,	118,
	585,	117,
	580,	116,
	575,	115,
	570,	114,
	565,	113,
	560,	112,
	555,	111,
	550,	110,
	545,	109,
	540,	108,
	535,	107,
	530,	106,
	525,	105,
	520,	104,
	515,	103,
	510,	102,
	505,	101,
	500, 100,
	495, 99,
	490, 98,
	485, 97,
	480, 96,
	475, 95,
	470, 94,
	465, 93,
	460, 92,
	455, 91,
	450, 90,
	445, 89,
	440, 88,
	435, 87,
	430, 86,
	425, 85,
	420, 84,
	415, 83,
	410, 82,
	405, 81,
	400, 80,
	395, 79,
	390, 78,
	385, 77,
	380, 76,
	375, 75,
	370, 74,
	365, 73,
	360, 72,
	355, 71,
	350, 70,
	345, 69,
	340, 68,
	335, 67,
	330, 66,
	325, 65,
	320, 64,
	315, 63,
	310, 62,
	305, 61,
	300, 60,
	295, 59,
	290, 58,
	285, 57,
	280, 56,
	275, 55,
	270, 54,
	265, 53,
	260, 52,
	255, 51,
	250, 50,
	245, 49,
	240, 48,
	235, 47,
	230, 46,
	225, 45,
	220, 44,
	215, 43,
	210, 42,
	205, 41,
	200, 40,
	195, 39,
	190, 38,
	185, 37,
	180, 36,
	175, 35,
	170, 34,
	165, 33,
	160, 32,
	155, 31,
	150, 30,
	145, 29,
	140, 28,
	135, 27,
	130, 26,
	125, 25,
	120, 24,
	115, 23,
	110, 22,
	105, 21,
	100, 20,
	95, 19,
	90, 18,
	85, 17,
	80, 16,
	75, 15,
	70, 14,
	65, 13,
	60, 12,
	55, 11,
	50, 10,
	45, 9,
	40, 8,
	35, 7,
	30, 6,
	25, 5,
	21, 4,
	19, 3,
	17, 2,
	15, 1,
	13, 0,
	11, -1,
	9, -2,
	7, -3,
	-20, -4,
	-25, -5,
	-30, -6,
	-35, -7,
	-40, -8,
	-45, -9,
	-50, -10,
	-55, -11,
	-60, -12,
	-65, -13,
	-70, -14,
	-75, -15,
	-80, -16,
	-85, -17,
	-90, -18,
	-95, -19,
	-100, -20
}
function events.GetStatisticEffect(t)
	for i = 1, #vals - 2, 2 do
		if t.Value >= vals[i] then
			t.Result = vals[i + 1]
			return
		end
	end
	t.Result = vals[#vals]
end

-- fix game code being weird by having a dedicated getStatisticEffect() function and yet
-- not using it everywhere...

local hooks = HookManager{getStatEffect = 0x482DC0, getFullLuck = 0x47E0E0}
local function patch(addr, valueReg, resultReg, jump, nopAddr)
	hooks.ref.valueReg = valueReg
	hooks.ref.resultReg = resultReg
	hooks.ref.jump = jump
	-- also disables jump effectively capping stat at 400
	-- REMEMBER: patch getStatisticEffect()
	-- AND check for registers if some need saving
	hooks.asmpatch(addr, [[
		push %valueReg%
		call absolute %getStatEffect%
		mov %resultReg%, eax
		jmp short %jump%
	]], jump) -- just so happens jump forward is the patch size
	if type(nopAddr) == "number" then
		hooks.nop(nopAddr) -- simple nop, usually move from [resultReg + offset] to resultReg, which is already computed
	else
		nopAddr() -- various other stuff, usually moving from preserved register to clobbered register
	end
end

local patches =
{
	{0x47E3B0, "eax", "edi", 27, function() hooks.asmpatch(0x47E3F3, "mov eax,edi") end},
	{0x47E7AE, "eax", "edi", 27, 0x47E7C9},
	{0x47E977, "eax", "ebx", 27, function() hooks.asmpatch(0x47E9BA, "mov eax,ebx") end},
	{0x47EA61, "eax", "ebx", 27, function() hooks.asmpatch(0x47EAA4, "mov eax,ebx") end},
	{0x47EC7E, "eax", "ebx", 27, function() hooks.asmpatch(0x47ECC9, "mov eax,ebx") end},
	{0x47EDAE, "eax", "ebp", 27, function() hooks.asmpatch(0x47EDF1, "mov eax,ebp") end},
	{0x47F897, "eax", "edi", 27, 0x47F8B2},
	{0x47F998, "eax", "edi", 27, 0x47F9B3},
	{0x47FA99, "eax", "edi", 27, 0x47FAB4},
	-- 0x47FAF0 done below
	{0x47FCF3, "eax", "ebp", 27, function() hooks.asmpatch(0x47FD2B, "mov edx,ebp") end},
	{0x480114, "eax", "edi", 27, 0x48012F},
	{0x48020C, "eax", "edi", 27, 0x480227},
	{0x480304, "eax", "edi", 27, 0x48031F},
	{0x4803FC, "eax", "edi", 27, 0x480417},
	{0x4804F4, "eax", "edi", 27, 0x48050F},
	{0x4805EC, "eax", "edi", 27, 0x480607},
	{0x4807B0, "eax", "edi", 27, 0x4807CB},
	{0x4808A8, "eax", "edi", 27, 0x4808C3},
	{0x4809A0, "eax", "edi", 27, 0x4809BB},
	{0x480A98, "eax", "edi", 27, 0x480AB3},
	{0x480DF1, "eax", "edi", 27, 0x480E0C},
	-- 00480F39 done below
	{0x481DD2, "eax", "ebx", 27, 0x481DF1},
	{0x482009, "eax", "ebp", 27, function() hooks.asmpatch(0x482041, "mov edx, ebp") end},
	{0x482176, "eax", "ebx", 27, function() hooks.asmpatch(0x4821AC, "mov ecx, ebx") end},
	{0x4822C3, "eax", "ebx", 27, function() hooks.asmpatch(0x4822F9, "mov ecx, ebx") end},
	{0x4824B3, "edi", "ebx", 27, function()
		hooks.asmpatch(0x482414, [[
			push eax
			call absolute %getStatEffect%
			mov dword [esp + 0x10], eax
			jmp short 0x1F
		]], 0x1F)
		hooks.asmpatch(0x4824EF, [[
			mov ecx,ebx
		]], 0xE) -- also disables next move, because [esp + 10] already contains effect, not breakpoint index
	end},
	{0x4826B0, "eax", "ebx", 27, function() hooks.asmpatch(0x4826E1, "mov eax, ebx") end},
	{0x482840, "eax", "ebx", 27, function() hooks.asmpatch(0x482880, "mov eax, ebx") end},
	{0x484086, "eax", "ebx", 27, function() hooks.asmpatch(0x4840BE, "mov edx, ebx") end},
	-- 00484F69 done below
	{0x487D10, "eax", "ebp", 27, function() hooks.asmpatch(0x487D46, "mov eax, ebp") end},
	{0x487E8B, "eax", "ebp", 27, function() hooks.asmpatch(0x487EC1, "mov eax, ebp") end},
	{0x4884E6, "edi", "ebx", 27, function() hooks.asmpatch(0x48851E, "mov edx, ebx") end},
}

for i, v in ipairs(patches) do
	patch(unpack(v))
end

-- luck is special
hooks.asmpatch(0x47FAEE, [[
	mov ecx, esi
	call absolute %getFullLuck%
	push eax
	call absolute %getStatEffect%
	mov esi, eax
	jmp short 0x29
]], 0x29)

-- other
hooks.asmpatch(0x480F39, [[
	push eax
	call absolute %getStatEffect%
	mov ebp, eax
	mov ebx, dword [esp + 0x14]
	jmp short 0x2A
]], 0x2A)

hooks.asmpatch(0x484F69, [[
	push eax
	call absolute %getStatEffect%
	mov dword [esp + 0x10], eax
	jmp short 0x23
]], 0x23)

hooks.asmpatch(0x484FB1, "mov edx, dword [esp + 0x10]", 7)


-- condition effect on statistics
-- effects are in percentages, no more than 255

-- example usage: setConditionEffects(const.Condition.Insane, {[const.Stats.Might] = 200, 200, 200, 200, 200, 200, 200}) -- insanity doubles each stat now
--[[
setConditionEffects({
	[const.Condition.Paralyzed] = {
		[const.Stats.Might] = 200
	}
}) -- paralyzed doubles might

setConditionEffects({
	[const.Condition.Paralyzed] = {
		[const.Stats.Luck] = 0,
		[const.Stats.Personality] = 50
	},
	[const.Condition.Weak] = {
		[const.Stats.Endurance] = 0
	}
}) -- paralyzed zeroes luck and halves personality, weakness zeroes endurance
]]




if SETTINGS["StatsRework"]==true then
	function events.GameInitialized2()
	setConditionEffects(const.Condition.Poison1, {[const.Stats.Might] = 100, 100, 100, 100, 100, 100, 100})
	setConditionEffects(const.Condition.Poison2, {[const.Stats.Might] = 100, 100, 100, 100, 100, 100, 100})
	setConditionEffects(const.Condition.Poison3, {[const.Stats.Might] = 100, 100, 100, 100, 100, 100, 100})
	setConditionEffects(const.Condition.Insane, {[const.Stats.Might] = 110, 65, 65, 105, 50, 105, 100})
	setConditionEffects(const.Condition.Afraid, {[const.Stats.Might] = 105, 80, 80, 100, 80, 105, 100})
	end
end

local conditionEffectBase = 0x4C27B4
local u1 = mem.u1
function setConditionEffects(cond, percentages)
	if type(cond) == "number" then -- single condition passed - set all effects for it (table indexed by stat)
		for stat, val in pairs(percentages) do
			u1[conditionEffectBase + cond + stat * 18] = val -- 18 = condition count (including "good")
		end
	else -- multiple conditions passed - set all effects for them (table indexed by condition, then stat)
		local condTable = cond -- for readability purposes
		for cond, values in pairs(condTable) do
			for stat, val in pairs(values) do
				u1[conditionEffectBase + cond + stat * 18] = val
			end
		end
	end
end

-- returns values like above input
function getConditionEffects(cond)
	local out = {}
	if cond then -- condition passed - get all effects for it (table indexed by stat)
		for stat = 0, const.Stats.Luck do
			out[stat] = u1[conditionEffectBase + cond + stat * 18]
		end
	else -- condition not passed - get all effects for all conditions (table indexed by condition, then stat)
		for cond = 0, const.Condition.Good do
			out[cond] = {}
			for stat = 0, const.Stats.Luck do
				out[cond][stat] = u1[conditionEffectBase + cond + stat * 18]
			end
		end
	end
	return out
end

-- 1/n spell skills
-- when ranking up spell skill, let n be number of other spell skills at skill level equal to or greater than next rank
-- then cost is (old cost / (n + 1)), no less than 1

local function getNewSkillCost(pl, newS, skillId)
	local equalOrHigherCount = 0
	if skillId >= const.Skills.Fire and skillId <= const.Skills.Dark then
		for i = const.Skills.Fire, const.Skills.Dark do
			if i ~= skillId then
				local otherS, _ = SplitSkill(pl.Skills[i])
				if otherS >= newS then
					equalOrHigherCount = equalOrHigherCount + 1
				end
			end
		end
	end
	local newCost = newS
	if equalOrHigherCount >= 1 then
		newCost = math.max(1, math.ceil(newCost / (equalOrHigherCount + 1)))
	end
	return newCost
end

local newCode = mem.asmpatch(0x42D0E4, [[
	; edx = current skill value
	; esi - current skill points
	; [esp + 0x10] - skill id
	; ecx - player ptr
	and edx,0x3F
	inc edx
	nop
	nop
	nop
	nop
	nop
	cmp esi,edx
]], 6)

local newCost
-- checking if enough skill points
mem.hook(newCode + 4, function(d)
	local skillId = mem.u4[d.esp + 0x14]
	local newS = d.dl
	local _, pl = GetPlayer(d.ecx)
	newCost = getNewSkillCost(pl, newS, skillId)
	d.dl = newCost
end)

-- actually subtracting skill points
-- need to do entire hook, because two earlier jumps might mess things up
mem.autohook(0x42D109, function(d)
	d.eax = assert(newCost)
end)

-- display on mouseover
mem.hook(0x41F8E9, function(d)
	local skillId = mem.u4[d.esi + 0x24]
	local newS, _ = SplitSkill(d.al) + 1
	local _, pl = GetPlayer(d.ecx)
	newCost = getNewSkillCost(pl, newS, skillId)
	d.eax = newCost
end, 10)

if SETTINGS["ShowDamageTaken"]==true then
--show damage taken
	function events.CalcDamageToPlayer(t)
	local i=t.Player:GetIndex() 
		if i==3 then
	Game.ShowStatusText(string.format("                                                   %s",t.Result))
			else if i==2 then
			Game.ShowStatusText(string.format("              %s",t.Result))
				else if i==1 then
				Game.ShowStatusText(string.format("%s                       ",30))
					else if i==0 then
					Game.ShowStatusText(string.format("%s                                                             ",30))
					end
				end
			end
		end
	end
end

if SETTINGS["ReworkedMagicDamageCalculation"]==true then
damage1=0
	function events.CalcDamageToPlayer(t)
		if t.DamageKind==1 or t.DamageKind==2 or t.DamageKind==3 or t.DamageKind==4 or t.DamageKind==5 then
		--get resistances
			if t.DamageKind==1 then
			res=t.Player:GetMagicResistance()
			end
			if t.DamageKind==2 then
			res=t.Player:GetFireResistance()
			end
			if t.DamageKind==3 then
			res=t.Player:GetElectricityResistance()
			end
			if t.DamageKind==4 then
			res=t.Player:GetColdResistance()
			end
			if t.DamageKind==5 then
			res=t.Player:GetPoisonResistance()
			end
			luck=t.Player:GetLuck()/5
			--start of new formula
			roll = 1
			while (math.random() < (1 - 30/(30 + res + luck))) and (roll <= 4) do
				damage1 = t.Damage / (1 + 0.5 * roll)
				roll = roll + 1
			end
			t.Result = damage1 * (1 / (1 + (res+luck)^0.7 / 100))
		end
	end
end
