local Rebalance
Rebalance = 1
Rebalanze = 1
if SETTINGS["ImbaSubClasses"]==false then
Rebalance = 0.95
Rebalanze = 0
end

BERSERKER=SETTINGS["PaladinAsBerseker"]
if BERSERKER==true then

--removes Raise dead:
function events.CalcDamageToMonster(t)	
	local data = WhoHitMonster()	
	if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and data.Player.Insane==0 and t.DamageKind==0 and data.Object==nil then
		if data.Player.Spells[53]==true then
		data.Player.Spells[53]=false
		Message("Berserkers are known for taking lives rather than giving them. They are not typically associated with the ability to bring the dead back to life. You lost your raise dead ability. Here some gold.")
		--get merchant skill
		merchant=data.Player.Skills[const.Skills.Merchant]
		if merchant<64 then
		evt.Add("Gold",7000)
		end
		if merchant>64 and merchant<128 then
		evt.Add("Gold",14000)
		end
		if merchant>128 and merchant<192 then
		evt.Add("Gold",20000)
		end
		end
	end
end


--scales with might
function events.CalcDamageToMonster(t)
local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and t.DamageKind==0 then
		might=data.Player:GetMight()
		bonusDamage=might/500
		t.Result=t.Result*(1+bonusDamage*Rebalanze)*Rebalance
	end
	
end
--when insane deals 50% extra damage and attack will consume 10 sp, when no SP insane will be removed
function events.CalcDamageToMonster(t)	
local data = WhoHitMonster()	
	if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and data.Player.Insane==1 and t.DamageKind==0 and data.Object==nil then
		t.Result=t.Result*1.5
		data.Player.HP=data.Player.HP+t.Result*0.1
		data.Player.SP=data.Player.SP-15
		if data.Player.SP<1 then
		data.Player.Insane=0
		end
	end
end

--when 100 or above SP you have 50% to get insane
function events.CalcDamageToMonster(t)	
local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and data.Player.Insane==0 and data.Player.SP>=100 and t.DamageKind==0 and data.Object==nil then
		if math.random(1,100)>50 then
			data.Player.Insane=1
	--get mastery info		
			mastery=data.Player.Skills[const.Skills.Thievery]
			if mastery>=64 then 
			mastery=mastery-64
			rank=2
			end
			if mastery>=64 then
			mastery=mastery-64
			rank=3
			end
			previousMightBonus=data.Player.MightBonus
			previousSpeedBonus=data.Player.SpeedBonus
			data.Player.MightBonus=mastery*10+previousMightBonus
			data.Player.SpeedBonus=mastery*10+previousSpeedBonus
			wentBerserker=1
		end
	end
end

--adds 15 SP when attacking and not insane and reset bonus speed
function events.CalcDamageToMonster(t)	
local data = WhoHitMonster()	
	if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and data.Player.Insane==0 and t.DamageKind==0 and data.Object==nil then
		if data.Player.SP<0 then
			data.Player.SP=0
		end
		data.Player.SP=data.Player.SP+15
--LOT OF CODE TO RESET BONUS STATS FROM BERSERKER, might have been done in a more simple manner
		if previousSpeedBonus ~=nil then
		data.Player.SpeedBonus=previousSpeedBonus
		data.Player.MightBonus=previousMightBonus
		end
		if wentBerserker==1 then
		data.Player.SpeedBonus=previousSpeedBonus
		data.Player.MightBonus=previousMightBonus
		wentBerserker=0
		end
		if data.Player.SpeedBonus>30 and data.Player.MightBonus>30 then
		--get mastery
			mastery=data.Player.Skills[const.Skills.Thievery]
			if mastery>=64 then 
			mastery=mastery-64
			rank=2
			end
			if mastery>=64 then
			mastery=mastery-64
			rank=3
			end
			--remove bonus
			data.Player.SpeedBonus=data.Player.SpeedBonus-(mastery*10)
			data.Player.MightBonus=data.Player.MightBonus-(mastery*10)
			--failsave
			if data.Player.SpeedBonus<0 or data.Player.MightBonus<0 then
			data.Player.SpeedBonus=0
			data.Player.MightBonus=0
			end
		end
	end
end

--No light, SP base to 100 and factor to 0
function events.GameInitialized2()
	Game.ClassKinds.StartingSkills[3][const.Skills.Light] = 0
	Game.ClassKinds.StartingSkills[3][const.Skills.Meditation] = 0
	Game.ClassKinds.StartingSkills[3][const.Skills.Plate] = 0
	Game.ClassKinds.StartingSkills[3][const.Skills.Thievery] = 1
	Game.Classes.SPFactor[const.Class.Paladin] = 0
	Game.Classes.HPFactor[const.Class.Crusader] = 4.5
	Game.Classes.SPFactor[const.Class.Crusader] = 0
	Game.Classes.SPFactor[const.Class.Hero] = 0
	Game.ClassKinds.SPBase[3] = 100
	Game.ClassNames[const.Class.Paladin]="Berserker"
	Game.ClassNames[const.Class.Crusader]="Reaver"
	Game.ClassNames[const.Class.Hero]="Fury"
	Game.ClassDescriptions[const.Class.Paladin] ="The Berserker is a combatfocused class that excels in dealing damage and sustaining themselves in battle. They gain health each level and use Rage as a resource to enter Berserker mode, which significantly increases their damage and healing abilities while also consuming mana with each attack.\n\nStats:\nGain 3 HP per level and a fixed amount of 100 Spell Points\nCan use Spirit/Mind/Body skills\n\nCombat Mechanics:\nEach 5 points in Might will increase damage by 1%\nRage decays at a rate of 10 per 10 seconds\nEach attack increases Rage by 15\nAt 100 or more Rage, melee attacks have a 50% chance to trigger Berserker mode\nIn Berserker mode, Might and damage are increased by 50%, attacks heal the Berserker by 10% of damage dealt, and attacks consume 15 mana\nOnce mana is depleted, Berserker mode ends with the next attack\nDamage taken also increases Rage (1% of base health of damage taken = 1% Rage)\nEach point in Mastery increases Might and speed by 10 in Berserker mode\n\nAdditional Details:\nItems that increase SP for other classes will instead increase max Rage by 20% of the effect\nBerserkers cannot learn Raise Dead"
	Game.ClassDescriptions[const.Class.Crusader] ="The Reaver, the ultimate evolution of the Berserker. They are unstoppable forces of destruction, feared for their unparalleled combat prowess. Their attacks deal massive damage and they are able to sustain themselves in battle. Their Rage unleashes devastating abilities, transforming them into a whirlwind of destruction. But beware, their insatiable bloodlust may consume them, leading them to the brink of madness. \n\nStats:\nGain 4.5 HP per level and fixed amount of 100 Spell Points\nCan use Spirit/Mind/Body skills\n\nCombat Mechanics:\nEach 5 points in Might will increase damage by 1%\nRage decays at a rate of 10 per 10 seconds\nEach attack increases Rage by 15\nAt 100 or more Rage, melee attacks have a 50% chance to trigger Berserker mode\nIn Berserker mode, Might and damage are increased by 50%, attacks heal the Berserker by 10% of damage dealt, and attacks consume 15 mana\nOnce mana is depleted, Berserker mode ends with the next attack\nDamage taken also increases Rage (1% of base health of damage taken = 1% Rage)\nEach point in Mastery increases Might and speed by 10 in Berserker mode\n\nAdditional Details:\nItems that increase SP for other classes will instead increase max Rage by 20% of the effect\nBerserkers cannot learn Raise Dead"
	Game.ClassDescriptions[const.Class.Hero]="The Fury, the ultimate evolution of the Reaver. They are the embodiment of rage and fury, feared for their unpredictable and devastating attacks. Their wild, untamed nature and lack of control can lead them to complete madness, entering a state of unstoppable frenzy that tears through anything in their path.\n\nStats:\nGain 6 HP per level and fixed amount of 100 Spell Points\nCan use Spirit/Mind/Body skills\n\nCombat Mechanics:\nEach 5 points in Might will increase damage by 1%\nRage decays at a rate of 10 per 10 seconds\nEach attack increases Rage by 15\nAt 100 or more Rage, melee attacks have a 50% chance to trigger Berserker mode\nIn Berserker mode, Might and damage are increased by 50%, attacks heal the Berserker by 10% of damage dealt, and attacks consume 15 mana\nOnce mana is depleted, Berserker mode ends with the next attack\nDamage taken also increases Rage (1% of base health of damage taken = 1% Rage)\nEach point in Mastery increases Might and speed by 10 in Berserker mode\n\nAdditional Details:\nItems that increase SP for other classes will instead increase max Rage by 20% of the effect\nBerserkers cannot learn Raise Dead"
end
--Mana items will only account for 1/5 of the effect
function events.CalcStatBonusByItems(t)
	if (t.Player.Class==const.Class.Paladin or t.Player.Class==const.Class.Crusader or t.Player.Class==const.Class.Hero) and t.Stat == const.Stats.SP then
		for it in t.Player:EnumActiveItems() do
			if it.Bonus==9 then
				t.Result = t.Result/5
			end
		end
	end
end

function events.CalcDamageToPlayer(t)
	if (t.Player.Class==const.Class.Hero or t.Player.Class==const.Class.Crusader or t.Player.Class==const.Class.Paladin) then
		--get base hp
		if t.Player.Class==const.Class.Hero then
			baseHP=t.Player.LevelBase*6+25
			else if t.Player.Class==const.Class.Crusader then
					baseHP=t.Player.LevelBase*4+25
					else if t.Player.Class==const.Class.Paladin then
					baseHP=t.Player.LevelBase*3+25
					end
			end
		end			
		t.Player.SP=t.Player.SP+(t.Result/baseHP)*100
	end
end

--mana regen
function events.LoadMap(wasInGame)
local function restoreManaWarriorMage() 
	for _, pl in Party do 
		if pl.Class == const.Class.Hero or pl.Class == const.Class.Crusader or pl.Class == const.Class.Paladin then 
			pl.SP = math.max(pl.SP -1, 0) 
		end 
	end 
end
Timer(restoreManaWarriorMage, const.Minute/2) 
end

end
