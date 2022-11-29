-- skill linking code, from Skill Emphasis Mod
-- if using with Skill Emphasis, comment out lines 3737 - 3812 in skill-mod.lua

-- set EASY_SKILLS to true to enable linked Spell groups, and to link Bows/Blasters across the party
local EASY_SKILLS = SETTINGS["MoreLinkedSkills"]

-- Skill groups linked "vertically" - within only one character
local characterLinkedSkillGroups =
{
	["meleeMain"] =
		{
			[const.Skills.Staff] = true,
			[const.Skills.Axe] = true,
			[const.Skills.Spear] = true,
			[const.Skills.Mace] = true,
		},
	["meleeExtra"] =
		{
			[const.Skills.Sword] = true,
			[const.Skills.Dagger] = true,
		},
	["ranged"] =
		{
			[const.Skills.Bow] = not(EASY_SKILLS),
			[const.Skills.Blaster] = not(EASY_SKILLS),
		},
	["armor"] =
		{
			[const.Skills.Leather] = true,
			[const.Skills.Chain] = true,
			[const.Skills.Plate] = true,
			-- [const.Skills.Bodybuilding] = EASY_SKILLS,
		},
	["elemental"] = 
		{
			[const.Skills.Fire] = EASY_SKILLS,
			[const.Skills.Air] = EASY_SKILLS,
			[const.Skills.Water] = EASY_SKILLS,
			[const.Skills.Earth] = EASY_SKILLS,
			[const.Skills.Dark] = EASY_SKILLS,
			[const.Skills.Learning] = EASY_SKILLS,
		},
	["self"] = 
		{
			[const.Skills.Spirit] = EASY_SKILLS,
			[const.Skills.Mind] = EASY_SKILLS,
			[const.Skills.Body] = EASY_SKILLS,
			[const.Skills.Light] = EASY_SKILLS,
			[const.Skills.Meditation] = EASY_SKILLS,
		},
}

-- Skills linked "Horizontally" - across the entire party

local partyLinkedSkills =
{
	[const.Skills.IdentifyItem] = true,
	[const.Skills.Merchant] = true,
	[const.Skills.Repair] = true,
	[const.Skills.Perception] = true,
	[const.Skills.DisarmTraps] = true,
	[const.Skills.Diplomacy] = true,
	[const.Skills.Bow] = EASY_SKILLS,
	[const.Skills.Blaster] = EASY_SKILLS,
}

function skillAdvance(t)
	-- get current player
	
	local currentPlayer = Party.Players[Party.CurrentPlayer]
	
	-- get skill
	
	local skill = t.Param

	-- check if skill is advanceable
	
	local skillLevel, skillMastery = SplitSkill(currentPlayer.Skills[skill])
	local skillAdvanceable = (currentPlayer.SkillPoints >= skillLevel + 1)


	if skillAdvanceable then
	
		-- If the skill ID is not Thievery, then follow the normal linking rules
		if not (skill == const.Skills.Thievery) 
		then	
			-- Vertical:  Player Linked Skills
			for key, characterLinkedSkills in pairs(characterLinkedSkillGroups) 
			do
				if (characterLinkedSkills[skill] == true )
				then
				-- advance all other skills to at least same level
					for characterLinkedSkill, value in pairs(characterLinkedSkills) 
					do
						if characterLinkedSkill ~= skill 
						then
							local characterLinkedSkillLevel, characterLinkedSkillMastery = SplitSkill(currentPlayer.Skills[characterLinkedSkill])
							if characterLinkedSkillMastery ~= 0 and characterLinkedSkillLevel <= skillLevel 
							then
									currentPlayer.Skills[characterLinkedSkill] = JoinSkill(skillLevel + 1, characterLinkedSkillMastery)
							end
						end
					end
				end	
			end
			
			-- Horizontal:  Party Linked Skills
			if ((partyLinkedSkills[skill] ~= nil) and (partyLinkedSkills[skill] == true)) then
				-- advance same skill for other party members to at least same level
				for i = 0, 3 
				do
					if i ~= Party.CurrentPlayer 
					then
						local player = Party.Players[i]
						local partyLinkedSkillLevel, partyLinkedSkillMastery = SplitSkill(player.Skills[skill])
						if ((partyLinkedSkillMastery ~= 0) and (partyLinkedSkillLevel <= skillLevel)) 
						then
							player.Skills[skill] = JoinSkill(skillLevel + 1, partyLinkedSkillMastery)
						end
					end
				end
			end
		end
	end
end 

function events.Action(t)
	-- clicked on skill in skill screen
	if t.Action == 121 then
		skillAdvance(t)
	end
end
