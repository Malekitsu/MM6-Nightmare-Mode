-- functions related to showing Monster Info in the right-click pane
-- taken from Skill Emphasis mod, version 0.8.0

-- 2022-08-29:  various fixes; infobox now should use the live stats of the selected monster and not the generic version from MonstersTxt 
--				fixed CHANCE flag being backwards

-- resistances table by default shows the average reduction.
-- set CHANCE to true to show the chance to reduce damage instead.

local DEBUG = false
local CHANCE = SETTINGS["ResistancesDisplayMode"]

if CHANCE == "default"
then
	rezstr = "Resist Chance"
elseif CHANCE == "effect"
then
	rezstr = "Usefulness"
else
	rezstr = "Resistances"
end

-- if using with Skill Emphasis, comment out lines 3818 - 3933 in skill-mod.lua

local masteries =
{
	[const.Novice] = "n",
	[const.Expert] = "e",
	[const.Master] = "m",
}

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

local function GetMonster(p)
	if p == 0 then
		return
	end
	local i = (p - Map.Monsters["?ptr"]) / Map.Monsters[0]["?size"]
	return i, Map.Monsters[i]
end

local function getHitChance(player, ranged, monsterArmorClass)

	-- set default armor class
	
	if monsterArmorClass == nil then
		monsterArmorClass = 100
	end

	-- get combat parameters
	
	local attack
	
	if ranged then
		attack = player:GetRangedAttack()
	else
		attack = player:GetMeleeAttack()
	end
	
	if attack == nil or type(attack) ~= "number" then
		return 0
	end
	
	local chanceToHit = (15 + 2 * attack) / (30 + 2 * attack + monsterArmorClass)
	return string.format("%d%%",chanceToHit * 100) 
	
end

local function getDodgeChance(player, monsterLevel)
	armor = player:GetArmorClass()
	rate = (5 + monsterLevel * 2)/(10 + monsterLevel * 2 + armor)
	rate = 1 - rate
	return string.format("%d%%",100 * rate)
end

function calculateMonsterDebuffRate(level,magicResist,is_resist)
	rate = 30/(30 + (level / 4) + magicResist)
	if (is_resist == true) then
		rate = 1 - rate
	end
	return string.format("%d%%",100 * rate)
end

function calculateResistanceAverageReduction(resist, show_chance)
	if (show_chance == true)
	then
		rate = 1 - (30/(30 + resist))
		return string.format("%d%%",100 * rate)
	elseif (show_chance == false)
	then
		rate = (30/(30+resist)+(30/(30+resist))*(1-(30/(30+resist)))/2+(30/(30+resist))*(1-(30/(30+resist)))^2/4+(30/(30+resist))*(1-(30/(30+resist)))^3/8+(1-(30/(30+resist)))^4/16)
		return string.format("%d%%",100 * rate)
	else
		return string.format("%u",resist)
	end
end

function calculateAverageDiceRoll(dice, sides)
	return ((sides + 1)/2) * dice
end

function variance(sides)
	result = 0
	mean = (sides + 1)/2
	for x=1,sides do
		result = result + (x - mean)^2
	end
	return (result / sides)
end

function calculateProbableRange(dice, sides)
	mean = (sides + 1)/2
	deviation = ((dice * variance(sides)) ^ (1/2)) * 1.96
	lower = dice * mean - deviation
	upper = dice * mean + deviation
	return math.max(lower,dice), math.min(upper,dice*sides)
end

function modifiedDrawMonsterInfoName(d, def, dialog, font, left, top, color, str, a6)

	-- get monster
	
	local blankLine = {["key"] = "", ["value"] = ""}

	local monsterIndex, monster = GetMonster(d.edi)
	local monsterTxt = Game.MonstersTxt[monster.Id]
	
	local dice = { }
	local sides = { }
	local add = { }
	local element = { }
	local missile = { }

	local damageString = { }

	local low = { }
	local high = { }

	for j=1,2 do
		key = "Attack" .. j
		dice[j] = monster[key]["DamageDiceCount"]
		sides[j] = monster[key]["DamageDiceSides"]
		add[j] = monster[key]["DamageAdd"]
		element[j] = monster[key]["Type"]
		missile[j] = monster[key]["Missile"]

		damageString[j] = dice[j] .. "D" .. sides[j] .. "+" .. add[j]
		low[j], high[j] = calculateProbableRange(dice[j], sides[j])
	end

	-- invoke original function
	
	def(dialog, font, left, top, color, str, a6)
	
	-- display monster txt statistics
	
	local textLines = {}

	if (DEBUG == true) then
		table.insert(textLines, {["key"] = "Experience", ["value"] = string.format("%d (%d)", monster["Experience"], monsterTxt["Experience"])})
	end
	
	-- player damage rate on monster
	if Game.CurrentPlayer >= 0 and Game.CurrentPlayer <= 3 then
		local player = Party.Players[Game.CurrentPlayer]
		local name = player["Name"]
		local meleeDamageRate = getHitChance(player, false, monster.ArmorClass)
		local rangedDamageRate = getHitChance(player, true, monster.ArmorClass)
		local dodgeRate = getDodgeChance(player, monster.Level)
		
		table.insert(textLines, {["key"] = string.format("%s's Hit Chance", name), ["value"] = string.format("%s", meleeDamageRate), ["type"] = "damageRate", })
		table.insert(textLines, {["key"] = "(ranged attacks)", ["value"] = string.format("%s", rangedDamageRate), ["type"] = "damageRate", })
		table.insert(textLines, {["key"] = "Block Chance", ["value"] = string.format("%s",dodgeRate), ["type"] = "damageRate", })
	else
		for _=1,3 do
			table.insert(textLines, blankLine)
		end
	end
	
	table.insert(textLines, {["key"] = "Level", ["value"] = string.format("%d", monster.Level)})
	table.insert(textLines, {["key"] = "Max HP", ["value"] = string.format("%d", monster["FullHP"])})
	table.insert(textLines, {["key"] = "Armor Class", ["value"] = string.format("%d", monster.ArmorClass)})
	table.insert(textLines, {["key"] = string.format("%s %s %s", damageString[1], attackTypes[element[1]], (missile[1] == 0) and "melee" or "ranged"), ["value"] = string.format("%d-%d", add[1] + low[1], add[1] + high[1])})
	if ((monster.Attack2Chance == 0) and (monster.SpellChance == 0)) 
	then
		table.insert(textLines, blankLine)
	elseif not (monster.Attack2Chance == 0)
	then
		table.insert(textLines, {["key"] = string.format("%s %s %s", damageString[2], attackTypes[element[2]], (missile[2] == 0) and "melee" or "ranged"), ["value"] = string.format("%d-%d", add[2] + low[2], add[2] + high[2])})
	elseif not (monster.SpellChance == 0) 
	then
		local spellLevel, spellMastery = SplitSkill(monster.SpellSkill)
		table.insert(textLines, {["key"] = string.format("Spell: %s (%s.%d)", Game.SpellsTxt[monster.Spell].Name, masteries[spellMastery], spellLevel), ["value"] = ""})
	end

	table.insert(textLines,{["key"] = "", ["value"] = rezstr})

	for k,v in pairs(attackTypes) do
		if not (v == "Energy")
		then
			table.insert(textLines,{["key"] = v, ["value"] = calculateResistanceAverageReduction(monster[v.."Resistance"], CHANCE), ["type"] = "resistance", })
		end
	end
	
	table.insert(textLines, {["key"] = "Debuffs", ["value"] = string.format("%s", calculateMonsterDebuffRate(monster.Level,monster.MagicResistance,CHANCE)), ["type"] = "resistance",})

	-- draw info
	
	font = Game.Smallnum_fnt
	local top = 36
	local lineHeight = 11
	local normalKeyMargin = 20
	local normalKeyColor = 0x0000					-- white
	local resistanceKeyMargin = 160
	local resistanceKeyColor = 0xFFC0			-- yellow
	local damageRateKeyMargin = normalKeyMargin
	local damageRateKeyColor = 0x07C0
	local valueRightMargin = 230
	local valueNumberShift = 8
	local normalValueColor = 0x07FE				-- cyan
	local damageRateValueColor = 0xF8C6		-- reddish
	
	for index, tuple in pairs(textLines) do
	
		-- draw key
	
		local keyMargin;
		local keyColor;
	
		if tuple.type == "resistance" then
			keyMargin = resistanceKeyMargin
			keyColor = resistanceKeyColor
		elseif tuple.type == "damageRate" then
			keyMargin = damageRateKeyMargin
			keyColor = damageRateKeyColor
		else
			keyMargin = normalKeyMargin
			keyColor = normalKeyColor
		end
		
		Game.TextBuffer = tuple.key .. string.rep(" ", 100)
		def(dialog, font, keyMargin, top + lineHeight * index, keyColor, str, 0)
		
		-- draw value
		
		local valueColor;
	
		if tuple.type == "damageRate" then
			valueColor = damageRateValueColor
		else
			valueColor = normalValueColor
		end
		
		local valueMargin = valueRightMargin - valueNumberShift * string.len(tuple.value)
		for c in string.gmatch(tuple.value, ".") do
			valueMargin = valueMargin + valueNumberShift
			local adjustedValueMargin = valueMargin
			if c == "-" then
				adjustedValueMargin = adjustedValueMargin + 1
			elseif c == "4" then
				adjustedValueMargin = adjustedValueMargin - 1
			end
			Game.TextBuffer = c .. string.rep(" ", 100)
			def(dialog, font, adjustedValueMargin, top + lineHeight * index, valueColor, str, 0)
		end
		
	end
	
end

mem.hookcall(0x0041D18D, 2, 5, modifiedDrawMonsterInfoName)
