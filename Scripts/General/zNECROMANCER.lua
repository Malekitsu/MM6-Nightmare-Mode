local Rebalance
Rebalance = 1
Rebalanze = 1
if SETTINGS["ImbaSubClasses"]==false then
Rebalance = 0.95
Rebalanze = 0
end

NECROMANCER=SETTINGS["SorcererAsNecromancer"]
if NECROMANCER==true then
--Intellect increases damage
function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.ArchMage or data.Player.Class==const.Class.Wizard or data.Player.Class==const.Class.Sorcerer) then	
	intellect=data.Player:GetIntellect()
	t.Result=t.Result*(1+intellect/500*Rebalanze)*Rebalance
	end
end
--mastery increasing damage by 10% and cost by 5%
function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.ArchMage or data.Player.Class==const.Class.Wizard or data.Player.Class==const.Class.Sorcerer) then	
		--get Mastery level
	mastery=data.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end
		for i = 1,99 do
			if t.Spell==i then
			spellCost=Game.Spells[i]["SpellPointsNormal"]
			Game.SpellsTxt[i]["SpellPointsNormal"]=spellCost*mastery*0.1
			data.Player.SP=data.Player.SP-(spellCost*mastery*0.05)
			t.Result=t.Result*(1+mastery*0.1)
			end
		end
		
	end	
	
end

--leech 10% of damage and replenish 5% mana if spell kills an enemy
function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.ArchMage or data.Player.Class==const.Class.Wizard or data.Player.Class==const.Class.Sorcerer) then	
	data.Player.HP=data.Player.HP+t.Result*0.05
	--get endurance 
	endurance=data.Player:GetEndurance()
	if data.Player.HP>-endurance then
	data.Player.Dead=0
	end
		if t.Result>t.HP then
		fullSP=data.Player:GetFullSP()
		data.Player.SP=data.Player.SP+fullSP*0.05
		end
	end
end

--increases 

---25% hp + 50% mana
function events.GameInitialized2()
    Game.Classes.HPFactor[const.Class.Sorcerer] = 1.5
	Game.Classes.SPFactor[const.Class.Sorcerer] = 4
    Game.Classes.HPFactor[const.Class.Wizard] = 2.25
	Game.Classes.SPFactor[const.Class.Wizard] =6
    Game.Classes.HPFactor[const.Class.ArchMage] = 3
	Game.Classes.SPFactor[const.Class.ArchMage] = 8
	Game.ClassKinds.StartingSkills[2][const.Skills.Dark] = 1
	Game.ClassKinds.StartingSkills[2][const.Skills.Light] = 0
	Game.ClassKinds.StartingSkills[2][const.Skills.Dagger] = 0
	Game.ClassKinds.StartingSkills[2][const.Skills.Thievery] = 1
	Game.ClassKinds.SPBase[2] = 15
	Game.ClassNames[const.Class.Sorcerer]="Necromancer"
	Game.ClassNames[const.Class.Wizard]="Dread Necromancer"
	Game.ClassNames[const.Class.ArchMage]="Lich"
	Game.ClassDescriptions[const.Class.Sorcerer] = "A necromancer is a master of the dark arts, wielding the power of life and death itself. They have delved into the forbidden secrets of existence, learning to control the very forces that sustain life. Through their skills in divination and communication with the spirits, they are able to glimpse the hidden workings of the universe and unlock knowledge that is inaccessible to all but the bravest and most reckless. With their power to leech and to destroy, the necromancer is a figure of fear. Their magic is capable of and unspeakable evil. Those who dare to cross a necromancer must be prepared to face the consequences, for their wrath is as potent as their mercy. Whether champion or villain, the necromancer is a force to be reckoned with, and their mastery of the dark arts is a power to be feared and respected.\n\nStats:\nHP per level increases by 1.5 points each level and SP per level increases by 4 points each level\nSpell damage scales with intellect, where every 5 points of intellect increase damage by 1%.\nSpell damage also heals the caster for 5% of the damage done.\nKilling enemies will replenish 5% of the character's total mana.\n\nMastery\nMastery increases spell damage by 10% but also increases the cost of spells by 5%.\n\nStarting Abilities\nThe character starts with dark magic as their initial ability."
	Game.ClassDescriptions[const.Class.Wizard] = "The Dread Necromancer, the evolution of the Necromancer. They have delved even deeper into the forbidden secrets of existence, surpassing the limits of life and death itself. Their power to manipulate the forces of the living and the dead is unparalleled, instilling terror in the hearts of their enemies. Feared for their unquenchable thirst for power and unwavering dedication to achieving their goals. Their mastery of the dark arts is a power to be both feared and respected, as their reign of terror serves as a warning to those who would dare to cross them.\n\nStats:\nHP per level increases by 2.25 points each level and SP per level increases by 8 points each level\nSpell damage scales with intellect, where every 5 points of intellect increase damage by 1%.\nSpell damage also heals the caster for 5% of the damage done.\nKilling enemies will replenish 5% of the character's total mana.\n\nMastery\nMastery increases spell damage by 10% but also increases the cost of spells by 5%.\n\nStarting Abilities\nThe character starts with dark magic as their initial ability."
	Game.ClassDescriptions[const.Class.ArchMage] = "The Lich is the ultimate evolution of the Dread Necromancer, having achieved an immortal state through the darkest of rituals. Their mastery of necromancy is absolute, granting them unparalleled control over the forces of life and death. Through their mastery of the dark arts, they have transcended the limitations of the mortal body, and are now beings of pure magic. Their power is immense, capable of causing destruction on a scale that defies comprehension.\n\nStats:\nHP per level increases by 3 points each level and SP per level increases by 8 points each level\nSpell damage scales with intellect, where every 5 points of intellect increase damage by 1%.\nSpell damage also heals the caster for 5% of the damage done.\nKilling enemies will replenish 5% of the character's total mana.\n\nMastery\nMastery increases spell damage by 10% but also increases the cost of spells by 5%.\n\nStarting Abilities\nThe character starts with dark magic as their initial ability."
	
end

end

--MASTERY DESCRIPTION
function events.GameInitialized2()
	Game.SkillNames[const.Skills.Thievery]="Mastery"
	Game.SkillNames[const.Skills.Diplomacy]="Diplomacy"
	Game.SkillDescriptions[const.Skills.Thievery]="Mastery is a skill that allows players to increase their class bonus, making their character more powerful and effective in combat. The mastery skill is unique to each class, and players must invest points into it to improve their character's mastery level.\nRight-click on 'class name' on top of the 'stats' tab to access a wealth of information about your class's unique mastery abilities. "
	end
	
	
