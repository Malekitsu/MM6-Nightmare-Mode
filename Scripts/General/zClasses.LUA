
ASHIKARI=SETTINGS["ArcherAsAshikari"]
ASSASSIN=SETTINGS["ArcherAsAssassin"]
if ASSASSIN~=true then
	if ASHIKARI==true then
	-- damage scaling with speed (meant to be like classic Agility stat)
		function events.CalcDamageToMonster(t)
			local data = WhoHitMonster()
			if data and data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattleMage or data.Player.Class==const.Class.Archer) and t.DamageKind==0 then
				m1=SplitSkill(data.Player.Skills[const.Skills.Air])
				m2=SplitSkill(data.Player.Skills[const.Skills.Earth])
				m3=SplitSkill(data.Player.Skills[const.Skills.Fire])
				m4=SplitSkill(data.Player.Skills[const.Skills.Water])
				m5=SplitSkill(data.Player.Skills[const.Skills.Dark])
				m6=math.max(m2, m3, m4, m5, m1)
				data.Player.SP=data.Player.SP+t.Result*20/100
				t.Result=t.Result*0.85+m6*2
			end
		end

		function events.CalcSpellDamage(t)
		--get mastery
			local data = WhoHitMonster()
			if data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattleMage or data.Player.Class==const.Class.Archer) then	
				mastery=SplitSkill(data.Player.Skills[const.Skills.Thievery])
				modif = data.Player.LevelBase
					modik = data.Player.Exp
					modit = modik-modif *(modif-1)*500
				t.Result = t.Result + modit^(mastery^0.5/10)
			end		
		end
		
		function events.GameInitialized2()
			Game.Classes.HPFactor[const.Class.Archer] = 3
			Game.Classes.SPFactor[const.Class.Archer] = 1
			Game.Classes.HPFactor[const.Class.BattleMage] = 4
			Game.Classes.SPFactor[const.Class.BattleMage] = 1
			Game.Classes.HPFactor[const.Class.WarriorMage] = 5
			Game.Classes.SPFactor[const.Class.WarriorMage] = 1
		--	Game.ClassKinds.StartingSkills[4][const.Skills.Dark] = 2
		--	Game.ClassKinds.StartingSkills[4][const.Skills.Axe] = 0
		--	Game.ClassKinds.StartingSkills[4][const.Skills.Spear] = 0
		--	Game.ClassKinds.StartingSkills[4][const.Skills.Chain] = 0
			Game.ClassKinds.StartingSkills[4][const.Skills.Bodybuilding] = 2
			Game.ClassKinds.StartingSkills[4][const.Skills.Thievery] = 1
			Game.ClassKinds.StartingSkills[4][const.Skills.Meditation] = 2
			Game.ClassNames[const.Class.Archer]="Ashikari"
			Game.ClassNames[const.Class.BattleMage]="Rune Master"
			Game.ClassNames[const.Class.WarriorMage]="Hex Lord"
			Game.ClassDescriptions[const.Class.Archer] = "Ashikaris are mystical warriors covered in magical tatoos. Physical attacks are increased by 2 for every rank in your highest magic skill. Their mana is low but melee attacks regenerate mana (20% of damage done). In addition their damage with spells is increased by about 3 pr rank in mastery, depending how much XP they have more than required for current level (the more extra XP, the higher bonus damage)." 
			Game.ClassDescriptions[const.Class.BattleMage] ="Ashikaris are mystical warriors covered in magical tatoos. Physical attacks are increased by 1 for every rank in every magic skill. Their mana is low but melee attacks regenerate mana (20% of damage done). In addition their damage with spells is increased by about 3 pr rank in mastery, depending how much XP they have more than required for current level (the more extra XP, the higher bonus damage)." 
			Game.ClassDescriptions[const.Class.WarriorMage] ="Ashikaris are mystical warriors covered in magical tatoos. Physical attacks are increased by 1 for every rank in every magic skill. Their mana is low but melee attacks regenerate mana (20% of damage done). In addition their damage with spells is increased by about 3 pr rank in mastery, depending how much XP they have more than required for current level (the more extra XP, the higher bonus damage)."
		end
	end
end



----------------------------------------------------------------------
--ASSASSIN
----------------------------------------------------------------------


ASSASSIN=SETTINGS["ArcherAsAssassin"]
if ASSASSIN==true then

	comboPoint={}

	function events.LoadMap()
		for i=0,3 do
			comboPoint[i]=0
		end
	end
	--Energy Spender, when energy is 30 or more and adds a combo point up to 5
	function events.CalcDamageToMonster(t)		
		local data = WhoHitMonster()
		if data and data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattleMage or data.Player.Class==const.Class.Archer) and data.Player.SP>=30 and t.DamageKind==0 and data.Object==nil then
		--get mastery
		mastery=data.Player.Skills[const.Skills.Thievery]
		mastery,masteryM=SplitSkill(mastery)
		--2-3-4 damage based on promotion
		bonusDamage=mastery*(data.Player.Class%3+2)
		res=t.Monster.PoisonResistance 
		roll = 1
		while (math.random() < (1 - 30/(30 + res))) and (roll <= 4) do
			bonusDamage = bonusDamage / 2
			roll = roll + 1
		end		
		if t.Result==0 then 
			bonusDamage=0 
		end
		t.Result=t.Result*1.2+bonusDamage
		data.Player.SP=data.Player.SP-30
		i=data.Player:GetIndex()
			if comboPoint[i]==nil then
			comboPoint[i]=0
				else if comboPoint[i]<5 then
				comboPoint[i]=comboPoint[i]+1
				end
			end
		end
	end
	--have a 30% chance to replenish 15 energy when attacking
	function events.CalcDamageToMonster(t)		
		data = WhoHitMonster()
		if data and data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattleMage or data.Player.Class==const.Class.Archer) and t.DamageKind==0 and data.Object==nil then	
			if math.random(1,100)<=30 then
				data.Player.SP=data.Player.SP+15
			end
		end
	end


	--consume combo points
	function events.CalcSpellDamage(t)
	--get mastery

		local data = WhoHitMonster()
		if data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattleMage or data.Player.Class==const.Class.Archer) then		
		mastery, rank=SplitSkill(data.Player.Skills[const.Skills.Thievery])
		i=data.Player:GetIndex()
		if comboPoint[i]==nil then
			comboPoint[i]=0
		end
		if comboPoint[i]==0 then
			if data.Player.Class==const.Class.Archer then 			
			t.Result=t.Result*0.5
				else if data.Player.Class==const.Class.BattleMage then
				t.Result=t.Result*0.65
					else if data.Player.Class==const.Class.WarriorMage then
						t.Result=t.Result*0.8
					end
				end
			end			
		elseif comboPoint[i]<=5 then
			t.Result=t.Result*(1+0.2*comboPoint[i]+mastery*comboPoint[i]*0.01)
			comboPoint[i]=0		
		end
			comboPoint[i]=0
		end

		
	end

	--function events.CalcDamageToPlayer(t)
	--	evt.FaceExpression{Player = "Current", Frame = 33}
	--	t.Result=0
	--end
	--SP increase items will add only 1/5 of SP
	function events.CalcStatBonusByItems(t)
		if (t.Player.Class==const.Class.WarriorMage or t.Player.Class==const.Class.BattleMage or t.Player.Class==const.Class.Archer) and t.Stat == const.Stats.SP then
		t.Result=t.Result/5
		end
	end


	--Dodge
	function events.CalcDamageToPlayer(t)
		if (t.Player.Class==const.Class.WarriorMage or t.Player.Class==const.Class.BattleMage or t.Player.Class==const.Class.Archer and t.DamageKind==0) then
			--GET MASTERY SKILL
			mastery, rank=SplitSkill(t.Player.Skills[const.Skills.Thievery])
			roll=math.random(1, 100)
			--dodge change=5 base +1% per skill point
			if roll<=mastery*0.5+5 then
				t.Result=0
				Game.ShowStatusText("Dodged")
				evt.FaceExpression{Player = t.PlayerIndex, Frame = 33}
			end
		end
	end


	--Set base of 100 energy and starting skills




	function events.GameInitialized2()
		Game.Classes.HPFactor[const.Class.Archer] = 2
		Game.Classes.SPFactor[const.Class.Archer] = 0
		Game.Classes.HPFactor[const.Class.BattleMage] = 3
		Game.Classes.SPFactor[const.Class.BattleMage] = 0
		Game.Classes.HPFactor[const.Class.WarriorMage] = 4
		Game.Classes.SPFactor[const.Class.WarriorMage] = 0
		Game.ClassKinds.StartingSkills[4][const.Skills.Dark] = 0
		Game.ClassKinds.StartingSkills[4][const.Skills.Axe] = 0
		Game.ClassKinds.StartingSkills[4][const.Skills.Spear] = 0
		Game.ClassKinds.StartingSkills[4][const.Skills.Chain] = 0
		Game.ClassKinds.StartingSkills[4][const.Skills.Bodybuilding] = 2
		Game.ClassKinds.StartingSkills[4][const.Skills.Thievery] = 1
		Game.ClassKinds.StartingSkills[4][const.Skills.Meditation] = 0
		Game.ClassKinds.SPBase[4] = 100
		Game.ClassNames[const.Class.Archer]="Rogue"
		Game.ClassNames[const.Class.BattleMage]="Shadow"
		Game.ClassNames[const.Class.WarriorMage]="Assassin"
		Game.ClassDescriptions[const.Class.Archer] = "A rogue is a daring and cunning warrior, skilled in the art of deception and quick thinking. Their agility and speed allow them to strike with deadly precision, always staying one step ahead of their opponents.\n\nStats:\nHP: 2 per level\nEnergy (SP): 100 base, regenerating 2 per second\n5% dodge+0.5% per Mastery point\n\nAbilities:\nCan use Elemental Spells\n\nMelee attacks have a 30% chance to restore 15 energy.\n\nAttack:\nConsumes 30 energy to deal 20% increased damage adding a combo point, up to 5\n\nSpell Cast:\nConsumes all combo points\nDeals 20% increased damage per combo point consumed\nIf 5 combo points are consumed, damage will increase by 250%\nSpell cast with no combo points will do half the damage\n\nMastery\nEach point of mastery add 2 poison damage of energy spender, and combo point ability by 1% per combo point" 
		Game.ClassDescriptions[const.Class.BattleMage] ="Shadow, the ultimate evolution of the rogue. Masters of deadly precision, they strike with unmatched agility and cunning. Their blades cut through enemies with ease, and their power lies in their ability to manipulate darkness. They are the masters of fear, striking terror into the hearts of their foes. The Shadow is a force feared by all who stand in their way.\nStats:\nHP: 3 per level\nEnergy (SP): 100 base, regenerating 3 per second\n5% dodge+0.5 per Mastery point\nAbilities:\nCan use Elemental Spells\nMelee attacks have a 30% chance to restore 15 energy.\n\nAttack:\nConsumes 30 energy to deal 20% increased damage adding a combo point, up to 5\n\nSpell Cast:\nConsumes all combo points\nDeals 20% increased damage per combo point consumed\nIf 5 combo points are consumed, damage will increase by 250%\nSpell cast with no combo points will do half the damage\n\nMastery\nEach point of mastery add 3 poison damage of energy spender, and combo point ability by 1% per combo point"
		Game.ClassDescriptions[const.Class.WarriorMage] ="Assassin, the ultimate evolution of the shadow. They strike with ruthless precision and deadly blades, able to eliminate their targets with a single, fatal blow. Their movements are graceful and silent, and their mastery of assassination is unmatched. \n\nStats:\nHP: 4 per level\nEnergy (SP): 100 base, regenerating 4 per second\n5% dodge+0.5 per Mastery point\n\nAbilities:\nCan use Elemental Spells\nMelee attacks have a 30% chance to restore 15 energy.\n\nAttack:\nConsumes 30 energy to deal 20% increased damage adding a combo point, up to 5\n\nSpell Cast:\nConsumes all combo points\nDeals 20% increased damage per combo point consumed\nIf 5 combo points are consumed, damage will increase by 250%\nSpell cast with no combo points will do half the damage\n\nMastery\nEach point of mastery add 4 poison damage of energy spender, and combo point ability by 1% per combo point"
	end	

	function events.LoadMap(wasInGame)
		local function restoreManaArcher() 
			for _, pl in Party do 
				if pl.Class == const.Class.Archer then 
					pl.SP = math.min(pl.SP + 2, pl:GetFullSP()) 
				end 
			end 
		end
		Timer(restoreManaArcher, const.Minute/2) 

		local function restoreManaBattleMage() 
			for _, pl in Party do 
				if pl.Class == const.Class.BattleMage then 
					pl.SP = math.min(pl.SP + 3, pl:GetFullSP()) 
				end 
			end 
		end
		Timer(restoreManaBattleMage, const.Minute/2) 

		local function restoreManaWarriorMage() 
			for _, pl in Party do 
				if pl.Class == const.Class.WarriorMage then 
					pl.SP = math.min(pl.SP + 4, pl:GetFullSP()) 
				end 
			end 
		end
		Timer(restoreManaWarriorMage, const.Minute/2) 
	end
end





----------------------------------------------------------------------
--BERSERKER
----------------------------------------------------------------------

SERAPHIM=SETTINGS["PaladinAsSeraphim"]
BERSERKER=SETTINGS["PaladinAsBerserker"]
if BERSERKER==true then
	if SERAPHIM~=true then
		--removes Raise dead:
		function events.CalcDamageToMonster(t)	
			local data = WhoHitMonster()	
			if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and data.Player.Insane==0 and t.DamageKind==0 and data.Object==nil then
				if data.Player.Spells[53]==true then
				data.Player.Spells[53]=false
				Message("Berserkers are known for taking lives rather than giving them. They are not typically associated with the ability to bring the dead back to life. You lost your raise dead ability.")
				evt.Add("Items",352)
				end
			end
		end


		--when insane deals 50% extra damage and attack will consume 10 sp, when no SP insane will be removed
		function events.CalcDamageToMonster(t)	
		local data = WhoHitMonster()	
			if data and data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and data.Player.Insane==1 and t.DamageKind==0 and data.Object==nil then
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
			if data and data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and data.Player.Insane==0 and data.Player.SP>=100 and t.DamageKind==0 and data.Object==nil then
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
			if data and data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and data.Player.Insane==0 and t.DamageKind==0 and data.Object==nil then
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
			Game.ClassDescriptions[const.Class.Paladin] ="The Berserker is a combatfocused class that excels in dealing damage and sustaining themselves in battle. They gain health each level and use Rage as a resource to enter Berserker mode, which significantly increases their damage and healing abilities while also consuming mana with each attack.\n\nStats:\nGain 3 HP per level and a fixed amount of 100 Spell Points\nCan use Spirit/Mind/Body skills\n\nCombat Mechanics:\nRage decays at a rate of 10 per 10 seconds\nEach attack and damage taken will increase the Rage\nAt 100 or more Rage, melee attacks have a 50% chance to trigger Berserker mode\nIn Berserker mode, Might and damage are increased, attacks heal the Berserker by 10% of damage dealt, and attacks consume 15 mana\nOnce mana is depleted, Berserker mode ends with the next attack\nDamage taken also increases Rage (1% of base health of damage taken = 1% Rage)\nEach point in Mastery increases Might and speed by 10 in Berserker mode\n\nAdditional Details:\nItems that increase SP for other classes will instead increase max Rage by 20% of the effect\nBerserkers cannot learn Raise Dead"
			Game.ClassDescriptions[const.Class.Crusader] ="The Reaver, the ultimate evolution of the Berserker. They are unstoppable forces of destruction, feared for their unparalleled combat prowess. Their attacks deal massive damage and they are able to sustain themselves in battle. Their Rage unleashes devastating abilities, transforming them into a whirlwind of destruction. But beware, their insatiable bloodlust may consume them, leading them to the brink of madness. \n\nStats:\nGain 4.5 HP per level and fixed amount of 100 Spell Points\nCan use Spirit/Mind/Body skills\n\nCombat Mechanics:\nRage decays at a rate of 10 per 10 seconds\nEach attack and damage taken will increase the Rage\nAt 100 or more Rage, melee attacks have a 50% chance to trigger Berserker mode\nIn Berserker mode, Might and damage are increased, attacks heal the Berserker by 10% of damage dealt, and attacks consume 15 mana\nOnce mana is depleted, Berserker mode ends with the next attack\nDamage taken also increases Rage (1% of base health of damage taken = 1% Rage)\nEach point in Mastery increases Might and speed by 10 in Berserker mode\n\nAdditional Details:\nItems that increase SP for other classes will instead increase max Rage by 20% of the effect\nBerserkers cannot learn Raise Dead"
			Game.ClassDescriptions[const.Class.Hero]="The Fury, the ultimate evolution of the Reaver. They are the embodiment of rage and fury, feared for their unpredictable and devastating attacks. Their wild, untamed nature and lack of control can lead them to complete madness, entering a state of unstoppable frenzy that tears through anything in their path.\n\nStats:\nGain 6 HP per level and fixed amount of 100 Spell Points\nCan use Spirit/Mind/Body skills\n\nCombat Mechanics:\nRage decays at a rate of 10 per 10 seconds\nEach attack and damage taken will increase the Rage\nAt 100 or more Rage, melee attacks have a 50% chance to trigger Berserker mode\nIn Berserker mode, Might and damage are increased, attacks heal the Berserker by 10% of damage dealt, and attacks consume 15 mana\nOnce mana is depleted, Berserker mode ends with the next attack\nDamage taken also increases Rage (1% of base health of damage taken = 1% Rage)\nEach point in Mastery increases Might and speed by 10 in Berserker mode\n\nAdditional Details:\nItems that increase SP for other classes will instead increase max Rage by 20% of the effect\nBerserkers cannot learn Raise Dead"
		end
		--Mana items will only account for 1/5 of the effect
		function events.CalcStatBonusByItems(t)
			if (t.Player.Class==const.Class.Paladin or t.Player.Class==const.Class.Crusader or t.Player.Class==const.Class.Hero) and t.Stat == const.Stats.SP then
			t.Result=t.Result/5
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
end




----------------------------------------------------------------------
--BLOOD KNIGHT
----------------------------------------------------------------------


BLOODKNIGHT=SETTINGS["KnightAsBloodKnight"]
if BLOODKNIGHT==true then
	--when above 33% health every attack will cost 8% of hp but will deal 1% more damage for each 1% of missing health
	function events.CalcDamageToMonster(t)
		local data = WhoHitMonster()
		if data and data.Player and (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and t.DamageKind==0 and data.Object==nil then
		
		--Get Mastery
		mastery=SplitSkill(data.Player.Skills[const.Skills.Thievery])
		--get hp
		currentHP=data.Player.HP
		totalHP=data.Player:GetFullHP()
			if currentHP>totalHP*0.40 then
			--calculate base HP
			if data.Player.Class==const.Class.Champion then
				baseHP=data.Player.LevelBase*8+30
				else if data.Player.Class==const.Class.Cavalier then
						baseHP=data.Player.LevelBase*6+30
						else if data.Player.Class==const.Class.Knight then
						baseHP=data.Player.LevelBase*4+30
						end
				end
			end

			healthConsumed=baseHP*0.08
			data.Player.HP=data.Player.HP-healthConsumed
			t.Result=t.Result+healthConsumed*(1+mastery*0.1)
			end
			t.Result=t.Result*(1.5-(currentHP/totalHP)*0.5)
		end
	end
	--When health is below 40% instead of consuming HP your next 3 attacks will heal you by 10% of damage
	function events.CalcDamageToMonster(t)
		local data = WhoHitMonster()
		if data and data.Player then
			currentHP=data.Player.HP
			vampiricTreshold=data.Player:GetFullHP()*0.40
			if (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and currentHP<vampiricTreshold and t.DamageKind==0 and data.Object==nil then
			vampiricAttacks=2
			end
			if (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and vampiricAttacks~=nil and vampiricAttacks>0 and t.DamageKind==0 and data.Object==nil then
			vampiricAttacks=vampiricAttacks-1
				if SETTINGS["TRUENIGHTMARE"]==true then
					data.Player.HP=data.Player.HP+t.Result*(0.1+0.005*mastery*0.75)
				else
					data.Player.HP=data.Player.HP+t.Result*(0.1+0.005*mastery)
				end
			end
		end
	end

	function events.GameInitialized2()
	Game.ClassNames[const.Class.Knight]="Blood Knight"
	Game.ClassNames[const.Class.Cavalier]="Bloodborn"
	Game.ClassNames[const.Class.Champion]="Blood Lord"
	Game.ClassKinds.StartingSkills[0][const.Skills.Thievery] = 1
	Game.ClassKinds.StartingSkills[0][const.Skills.Shield] = 0
	Game.ClassKinds.StartingSkills[0][const.Skills.Staff] = 0
	Game.ClassDescriptions[const.Class.Knight] = "The Blood Knight, a warrior class that harnesses the power of their own life force, is a force to be reckoned with on the battlefield. With a fierce focus on high HP and devastating damage output, they charge headfirst into combat, their weapons ablaze with power that draws from their very essence.\nWith each strike, they unleash a torrent of raw power that is fueled by their own vitality, their enemies cowering in fear before the sheer force of their onslaught.\n\nStats:\nHP per level increases by 4 points each level.\n\nAbilities:\nWhen above 40% health, each attack will consume 8% of the character's total base HP.\nConsumed health will be converted into damage\nEach 2% of missing health will increase your damage by 1%\nAttacking when below 40% health will cause the character's next two attacks to heal them for 10% of the damage dealt.\n\nMastery\nMastery will increase damage granted by health consumed by 10% and leech by 0.5%."
	Game.ClassDescriptions[const.Class.Cavalier] = "The Bloodborn are of the Blood Knight who undergone a blood ritual that has granted them new heights of power. They are reborn through the sacrifice of others, drawing upon their life force to fuel their own power. Their weapons are wreathed in crimson energy, and they unleash a torrent of raw power with every strike. With each strike, they draw upon the life force of their enemies, draining them of their vitality and adding it to their own.\n\nStats:\nHP per level increases by 6 points each level.\n\nAbilities:\nWhen above 40% health, each attack will consume 8% of the character's total base HP.\nConsumed health will be converted into damage\nEach 2% of missing health will increase your damage by 1%\nAttacking when below 40% health will cause the character's next two attacks to heal them for 10% of the damage dealt.\n\nMastery\nMastery will increase damage granted by health consumed by 10% and leech by 0.5%."
	Game.ClassDescriptions[const.Class.Champion] = "The Blood Lord is the ultimate evolution of the Bloodborne, having undergone a series of dark and twisted rituals that have granted them unimaginable power. They are the very embodiment of death and destruction, feared by all who hear their name. Their weapons are infused with the very essence of life and death, and they wield them with deadly precision. The Blood Lord is a master of blood, capable of controlling the very life force of their enemies and using it to fuel their own power.Those who dare to cross a Blood Lord must be prepared to face the consequences, for their wrath is as potent as their thirst for blood.\n\nStats:\nHP per level increases by 8 points each level.\n\nAbilities:\nWhen above 40% health, each attack will consume 8% of the character's total base HP.\nConsumed health will be converted into damage\nEach 2% of missing health will increase your damage by 1%\nAttacking when below 40% health will cause the character's next two attacks to heal them for 10% of the damage dealt.\n\nMastery\nMastery will increase damage granted by health consumed by 10% and leech by 0.5%."
	end	
end




----------------------------------------------------------------------
--HERBALIST
----------------------------------------------------------------------

HERBALIST=SETTINGS["DruidAsHerbalist"]
SHAMAN=SETTINGS["DruidAsShaman"]
if SHAMAN~=true then
	if HERBALIST==true then
		function events.HealingSpellPower(t)
			if (t.Caster.Class==const.Class.ArchDruid or t.Caster.Class==const.Class.GreatDruid or t.Caster.Class==const.Class.Druid) then
				--get body
				body, rank=SplitSkill(t.Caster.Skills[const.Skills.Body])
				FHP = t.Target:GetFullHP()
				CHP = t.Target.HP
				CSP = t.Target.SP
				if t.Target.SP > 0 then
				t.Target.SP = t.Target.SP + t.Result * 0.1
				end
				t.Result =(t.Result * 1.5 - 2 * body)*(1.5-CHP/FHP)
			end
		end

		function events.CalcSpellDamage(t)
			local data = WhoHitMonster()
			if data.Player and (data.Player.Class==const.Class.ArchDruid or data.Player.Class==const.Class.GreatDruid or data.Player.Class==const.Class.Druid) then	
				t.Result =t.Result*0.85
			end
		end

		function events.CalcDamageToPlayer(t)	
			if t.Result>=t.Player.HP+t.Player.LevelBase*0.5 then
			FHPx = t.Player:GetFullHP()
			from=t.Player.LevelBase*2
				if FHPx > from then
					--calculate healing
					mastery=t.Player.Skills[const.Skills.Thievery]
					if mastery>=64 then 
					mastery=mastery-64
					end
					if mastery>=64 then
					mastery=mastery-64
					end
					chance=mastery*3+5
					if math.random(1,200)<chance then
						heal=t.Result-t.Player.LevelBase*0.5-t.Player.HP
						if SETTINGS["TRUENIGHTMARE"]==true then
							heal=heal*(1-diffMod)
						end
						evt[t.PlayerIndex].Add("HP",heal)
					Game.ShowStatusText("Forces of Nature saves you from lethal damage")
					end
				end	
			end
		end

		function events.GameInitialized2()
			Game.ClassNames[const.Class.Druid]="Herbalist"
			Game.ClassNames[const.Class.GreatDruid]="Mender"
			Game.ClassNames[const.Class.ArchDruid]="Restorer"
			Game.ClassKinds.StartingSkills[5][const.Skills.Light] = 1
			Game.ClassKinds.StartingSkills[5][const.Skills.Earth] = 0
			Game.ClassKinds.StartingSkills[5][const.Skills.Fire] = 0
			Game.ClassKinds.StartingSkills[5][const.Skills.Mind] = 0
			Game.ClassKinds.StartingSkills[5][const.Skills.Spirit] = 0
			Game.ClassKinds.StartingSkills[5][const.Skills.Thievery] = 1
			Game.ClassDescriptions[const.Class.Druid] = "Gain light, lose Spirit, Mind, Earth, Fire. Damage done is -15%. Healing done is +50% and -2 pr rank, as well as multiplied by (1.5-current % HP), meaning Herbalists are adept at healing single targets at low HP, but not so strong casting Power Cure to a party at high HP. Healed targets gain 10% of the healed amount (before class modifications) as SP in addition. If an attack would reduce a partymember below -0.5 HP pr level, mastery gives a 1.5% chance to set the HP of the target to -0.5 HP pr level instead"
			Game.ClassDescriptions[const.Class.GreatDruid] = "Gain light, lose Spirit, Mind, Earth, Fire. Damage done is -15%. Healing done is +50% and -2 pr rank, as well as multiplied by (1.5-current % HP), meaning Herbalists are adept at healing single targets at low HP, but not so strong casting Power Cure to a party at high HP. Healed targets gain 10% of the healed amount (before class modifications) as SP in addition. If an attack would reduce a partymember below -0.5 HP pr level, mastery gives a 1.5% chance to set the HP of the target to -0.5 HP pr level instead"
			Game.ClassDescriptions[const.Class.ArchDruid] = "Gain light, lose Spirit, Mind, Earth, Fire. Damage done is -15%. Healing done is +50% and -2 pr rank, as well as multiplied by (1.5-current % HP), meaning Herbalists are adept at healing single targets at low HP, but not so strong casting Power Cure to a party at high HP. Healed targets gain 10% of the healed amount (before class modifications) as SP in addition. If an attack would reduce a partymember below -0.5 HP pr level, mastery gives a 1.5% chance to set the HP of the target to -0.5 HP pr level instead"
		end
	end
end



----------------------------------------------------------------------
--NECROMANCER
----------------------------------------------------------------------
NECROMANCER=SETTINGS["SorcererAsNecromancer"]
if NECROMANCER==true then
	--adds toxic cloud to spellbook	
	function events.NewGameMap() 
		for i= 0,3 do 
			if Party[i].Class==6 then 
			Party[i].Spells[90]=true
			end 
		end 
	end
	--mastery increasing cost by 5% and deal extra damage by mana*spent^0.7*mastery skill
	function events.CalcSpellDamage(t)
		local data = WhoHitMonster()
			if data.Player and (data.Player.Class==const.Class.ArchMage or data.Player.Class==const.Class.Wizard or data.Player.Class==const.Class.Sorcerer) then	
				--get Mastery level
			mastery=data.Player.Skills[const.Skills.Thievery]
			masteryS,masteryM=SplitSkill(mastery)
			school=math.ceil(t.Spell/11)+11
			schoolMastery=data.Player.Skills[school]
			local s,m=SplitSkill(schoolMastery)
			if m==1 then
				spellCost=Game.Spells[t.Spell]["SpellPointsNormal"]
			elseif m==2 then
				spellCost=Game.Spells[t.Spell]["SpellPointsExpert"]
			elseif m==3 then
				spellCost=Game.Spells[t.Spell]["SpellPointsMaster"]
			end
			for i = 1, #aoespells do
				if aoespells[i] == t.Spell then
					spellCost = spellCost/2.5
					break
				end
			end
			t.Result=t.Result+(spellCost^0.7*masteryS)
		end	
	end


	--leech 3% of damage and replenish 3% mana if spell kills an enemy
	function events.CalcSpellDamage(t)
		local data = WhoHitMonster()
		if data.Player and (data.Player.Class==const.Class.ArchMage or data.Player.Class==const.Class.Wizard or data.Player.Class==const.Class.Sorcerer) then	
		fullHP=data.Player:GetFullHP()
		if SETTINGS["TRUENIGHTMARE"]==true then
		data.Player.HP=math.min(data.Player.HP+t.Result*0.03,fullHP)
		else
		data.Player.HP=math.min(data.Player.HP+t.Result*0.04,fullHP)
		end
		--get endurance 
		endurance=data.Player:GetEndurance()
		if data.Player.HP>-endurance then
		data.Player.Dead=0
		end
			if t.Result>t.HP then
			fullSP=data.Player:GetFullSP()
			data.Player.SP=math.min(data.Player.SP+fullSP*0.03,fullSP)
			end
		end
	end




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
		Game.ClassDescriptions[const.Class.Sorcerer] = "A necromancer is a master of the dark arts, wielding the power of life and death itself. They have delved into the forbidden secrets of existence, learning to control the very forces that sustain life. Through their skills in divination and communication with the spirits, they are able to glimpse the hidden workings of the universe and unlock knowledge that is inaccessible to all but the bravest and most reckless. With their power to leech and to destroy, the necromancer is a figure of fear. Their magic is capable of and unspeakable evil. Those who dare to cross a necromancer must be prepared to face the consequences, for their wrath is as potent as their mercy. Whether champion or villain, the necromancer is a force to be reckoned with, and their mastery of the dark arts is a power to be feared and respected.\n\nStats:\nHP per level increases by 1.5 points each level and SP per level increases by 4 points each level\nSpell damage heals the caster for 3% of the damage done.\nKilling enemies will replenish 3% of the character's total mana.\n\nMastery\nEach point in Mastery increases spell damage by SpellCost^0.7 (5 damage at cost 10, 11 damage at cost 30, reduced effect for AoE spells) , but also increases the cost of spells by 5%.\n\nStarting Abilities\nThe character starts with dark magic as their initial ability."
		Game.ClassDescriptions[const.Class.Wizard] = "The Dread Necromancer, the evolution of the Necromancer. They have delved even deeper into the forbidden secrets of existence, surpassing the limits of life and death itself. Their power to manipulate the forces of the living and the dead is unparalleled, instilling terror in the hearts of their enemies. Feared for their unquenchable thirst for power and unwavering dedication to achieving their goals. Their mastery of the dark arts is a power to be both feared and respected, as their reign of terror serves as a warning to those who would dare to cross them.\n\nStats:\nHP per level increases by 2.25 points each level and SP per level increases by 8 points each level\nSpell damage heals the caster for 3% of the damage done.\nKilling enemies will replenish 3% of the character's total mana.\n\nMastery\nEach point in Mastery increases spell damage by SpellCost^0.7 (5 damage at cost 10, 11 damage at cost 30, reduced effect for AoE spells) , but also increases the cost of spells by 5%.\n\nStarting Abilities\nThe character starts with dark magic as their initial ability."
		Game.ClassDescriptions[const.Class.ArchMage] = "The Lich is the ultimate evolution of the Dread Necromancer, having achieved an immortal state through the darkest of rituals. Their mastery of necromancy is absolute, granting them unparalleled control over the forces of life and death. Through their mastery of the dark arts, they have transcended the limitations of the mortal body, and are now beings of pure magic. Their power is immense, capable of causing destruction on a scale that defies comprehension.\n\nStats:\nHP per level increases by 3 points each level and SP per level increases by 8 points each level\nSpell damage heals the caster for 3% of the damage done.\nKilling enemies will replenish 3% of the character's total mana.\n\nMastery\nEach point in Mastery increases spell damage by SpellCost^0.7 (5 damage at cost 10, 11 damage at cost 30, reduced effect for AoE spells) , but also increases the cost of spells by 5%.\n\nStarting Abilities\nThe character starts with dark magic as their initial ability."
		
	end
end

--MASTERY DESCRIPTION
function events.GameInitialized2()
	Game.SkillNames[const.Skills.Thievery]="Mastery"
	Game.SkillNames[const.Skills.Diplomacy]="Diplomacy"
	Game.SkillDescriptions[const.Skills.Thievery]="Mastery is a skill that allows players to increase their class bonus, making their character more powerful and effective in combat. The mastery skill is unique to each class, and players must invest points into it to improve their character's mastery level.\nRight-click on 'class name' on top of the 'stats' tab to access a wealth of information about your class's unique mastery abilities. "
end
	
	



----------------------------------------------------------------------
--SERAPHIM
----------------------------------------------------------------------
Seraphim=SETTINGS["PaladinAsSeraphim"]
BERSERKER=SETTINGS["PaladinAsBerserker"]
if BERSERKER~=true then
	if Seraphim==true then

		--body magic will increase healing done on attack
		function events.CalcDamageToMonster(t)
			local data = WhoHitMonster()
				if data and data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and t.DamageKind==0 and data.Object==nil then
				--get body
				body=data.Player.Skills[const.Skills.Body]
				bodyS,bodyM=SplitSkill(body)
				--get mastery
				mastery=data.Player.Skills[const.Skills.Thievery]
				masteryS,masteryM=SplitSkill(mastery)
				
				rankBonusM=3
				if data.Player.Class==const.Class.Crusader then
					rankBonusM=3
				end
				if data.Player.Class==const.Class.Hero then
					rankBonusM=3
				end

				--get spirit
				spirit=data.Player.Skills[const.Skills.Spirit]
				spiritS,spiritM=SplitSkill(spirit)
				
				--bunch of code for healing most injured player
				function indexof(table, value)
				for i, v in ipairs(table) do
				if v == value then
				return i
				end
				end
				return nil
				end

				-- Define the variables
				if Party[0].Dead==0 and Party[0].Eradicated==0 then
				a = Party[0].HP/Party[0]:GetFullHP()
				else 
				a=2
				end
				if Party[1].Dead==0 and Party[1].Eradicated==0 then
				b = Party[1].HP/Party[1]:GetFullHP()
				else
				b=2
				end
				if Party[2].Dead==0 and Party[2].Eradicated==0 then
				c = Party[2].HP/Party[2]:GetFullHP()
				else
				c=2
				end
				if Party[3].Dead==0 and Party[3].Eradicated==0 then
				d = Party[3].HP/Party[3]:GetFullHP()
				else
				d=2
				end

				-- Find the maximum value and its position
				min_value = math.min(a, b, c, d)
				min_index = indexof({a, b, c, d}, min_value)
				min_index = min_index - 1
				--Calculate heal value and apply
				healValue=bodyS*2+masteryS*3+spiritS*2
				personality=data.Player:GetPersonality()
				healValue=healValue*(1+personality/500)
				--calculate crit
				critchance=data.Player:GetLuck()+50
				roll=math.random(1,1000)
				if roll<critchance then
					healValue=healValue*(1.5+personality/500)
				end
				--apply heal
				evt[min_index].Add("HP",healValue)		
				--bug fix
				if Party[min_index].HP>0 then
				Party[min_index].Unconscious=0
				end
			end
				
		end

		--mind light and mastery increases melee damage

		function events.CalcStatBonusBySkills(t)
			if t.Stat==const.Stats.MeleeDamageBase then
				if t.Player.Class==const.Class.Hero or t.Player.Class==const.Class.Crusader or t.Player.Class==const.Class.Paladin then
					light=t.Player.Skills[const.Skills.Light]
					lightS,lightM=SplitSkill(light)
					--get mastery
					mastery=t.Player.Skills[const.Skills.Thievery]
					masteryS,masteryM=SplitSkill(mastery)
					rankBonusMD=4
					--get mind
					mind=t.Player.Skills[const.Skills.Mind]
					mindS,mindM=SplitSkill(mind)
					
					if t.Player.Class==const.Class.Crusader then
						rankBonusMD=4
					end
					if t.Player.Class==const.Class.Hero then
						rankBonusMD=4
					end
					damage=mindS*2+lightS*2+masteryS*4
					t.Result=t.Result+damage
				end
			end
		end

		--AUTORESS SKILL

		function events.LoadMap(wasInGame)
			vars.divineProtectionCooldown=vars.divineProtectionCooldown or {}
			for i=0,3 do
				vars.divineProtectionCooldown[i]=vars.divineProtectionCooldown[i] or 0
			end
		end


		function events.GameInitialized2()

			--divine shield

			function events.CalcDamageToPlayer(t)
				if (t.Player.Class==const.Class.Hero or t.Player.Class==const.Class.Crusader or t.Player.Class==const.Class.Paladin) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0  and vars.divineShield[t.PlayerIndex] and vars.divineShield[t.PlayerIndex]>0 then
					if t.Result>vars.divineShield[t.PlayerIndex] then
						Game.ShowStatusText("Shield Broken")
						t.Result=t.Result-vars.divineShield[t.PlayerIndex]
						t.Result=0
						vars.divineShield[t.PlayerIndex]=0
					else
						vars.divineShield[t.PlayerIndex]=math.max(vars.divineShield[t.PlayerIndex]-t.Result)
						t.Result=0
						Game.ShowStatusText("Absorb")
					end
				end
			--divine protection
				if (t.Player.Class==const.Class.Hero or t.Player.Class==const.Class.Crusader or t.Player.Class==const.Class.Paladin) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0 then
					if vars.divineProtectionCooldown[t.PlayerIndex]==nil then
						vars.divineProtectionCooldown[t.PlayerIndex]=0
					end		
					if t.Result>=t.Player.HP and Game.Time>vars.divineProtectionCooldown[t.PlayerIndex] then
						totMana=t.Player:GetFullSP()
						currentMana=t.Player.SP
						treshold=totMana/4
						if currentMana>=treshold then
							t.Player.SP=t.Player.SP-(totMana/4)
							--calculate healing
							mastery=SplitSkill(t.Player.Skills[const.Skills.Thievery])
							heal=(totMana/2)*(1+mastery*0.05)
							evt[t.PlayerIndex].Add("HP",heal)
							vars.divineProtectionCooldown[t.PlayerIndex] = Game.Time + const.Minute * 150
							Game.ShowStatusText("Divine Protection saves you from lethal damage")
							t.Result=math.min(t.Result, t.Player.HP-1)
						end
					end	
				end
			end

		end

		-- DIVINE SHIELD 
		--tables
		function events.LoadMap(wasInGame)
		vars.divineShieldTime=vars.divineShieldTime or {}
		vars.divineShieldCooldown=vars.divineShieldCooldown or {}
		vars.divineShield=vars.divineShield or {}
		end
		--activation button	
		function Keys.E(t)
		CPI=Game.CurrentPlayer
			if CPI==-1 or SETTINGS["SeraphDivineShield"]~=true then
			return
			end
		if Party[CPI].Class==const.Class.Hero or Party[CPI].Class==const.Class.Crusader or Party[CPI].Class==const.Class.Paladin then
			if vars.divineShield[CPI]==1 then
			Game.ShowStatusText(string.format("Divine Shield is already Active, expiring in %s seconds. ",math.max(math.floor((vars.divineShieldTime[CPI] - Game.Time) / 128 * 10) / 10,0)))
				else if vars.divineShieldCooldown[CPI] ~= nil and vars.divineShieldCooldown[CPI] > Game.Time then
				Game.ShowStatusText(string.format("Divine Shield is on cooldown. Try again in %s seconds.",math.floor((vars.divineShieldCooldown[CPI] - Game.Time) / 128 * 10) / 10))
					else
						cost=Party[CPI].LevelBase+5
						if Party[CPI].SP>cost then
							Party[CPI].SP=Party[CPI].SP-cost
							Game.ShowStatusText(string.format("%s activates 'Divine Shield'",Party[CPI].Name))
							vars.divineShield[CPI] = Party[CPI]:GetFullHP()
							vars.divineShieldTime[CPI] = Game.Time + const.Minute * 6
							vars.divineShieldCooldown[CPI] = Game.Time + const.Minute * 90
						else 
							Game.ShowStatusText(string.format("Not enought mana (%s mana needed)",cost))
						end
					end
				end
			end
		end

		--
		function events.LoadMap(wasInGame)
		local function divineShieldTimer() 
			for i = 0, 3 do
				if vars.divineShieldTime[i]~=nil and vars.divineShield[i]~=0 then
					if vars.divineShieldTime[i]<Game.Time then
					vars.divineShield[i]=0
					Game.ShowStatusText(string.format("%s's Divine Shield effect expired",Party[i].Name))
					end 
				end
			end
		end
		Timer(divineShieldTimer, const.Minute/2) 
		end
		--reduced damage when in divine shield
		function events.CalcDamageToMonster(t)
			 data=WhoHitMonster()
			 if data then
				ind=data.Player:GetIndex()
			 end
			if data and data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and vars.divineShield[ind]==1 then
				t.Result=t.Result/2
			end
		end

		-------------end of divine shield---------------

		---deactivate offhand weapon
		function events.CalcDamageToMonster(t)
			 data=WhoHitMonster()
			 if data then
				item=data.Player:GetActiveItem(0)
			 end
			 if item~=nil then
				if data and data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and ((item.Number >= 1 and item.Number <= 14) or (item.Number ==403 or item.Number == 415)) then
					t.Result=0
					Message("Seraphim aren't able to dual wield")
				end
			end
		end

		function events.GameInitialized2()
		Game.ClassKinds.StartingSkills[3][const.Skills.Plate] = 3
		Game.ClassKinds.StartingSkills[3][const.Skills.Light] = 1
		Game.ClassKinds.StartingSkills[3][const.Skills.Sword] = 1
		Game.ClassKinds.StartingSkills[3][const.Skills.Spear] = 0
		Game.ClassKinds.StartingSkills[3][const.Skills.Axe] = 0
		Game.ClassKinds.StartingSkills[3][const.Skills.Staff] = 0
		Game.ClassKinds.StartingSkills[3][const.Skills.Leather] = 3
		Game.ClassKinds.StartingSkills[3][const.Skills.Chain] = 2
		Game.ClassKinds.StartingSkills[3][const.Skills.Mace] = 3
		Game.ClassKinds.StartingSkills[3][const.Skills.Thievery] = 1


			Game.Classes.HPFactor[const.Class.Paladin] = 3
			Game.Classes.SPFactor[const.Class.Paladin] = 1
			Game.Classes.HPFactor[const.Class.Crusader] = 4
			Game.Classes.SPFactor[const.Class.Crusader] = 2
			Game.Classes.HPFactor[const.Class.Hero] = 5
			Game.Classes.SPFactor[const.Class.Hero] = 3
		--LORE BONUS Seraphim are blessed with divine powers, giving him +20 starting hp and +10 mana and light skill
		Game.ClassKinds.HPBase[3] = Game.ClassKinds.HPBase[3]+20
		Game.ClassKinds.SPBase[3] = Game.ClassKinds.SPBase[3]+10

		Game.ClassNames[const.Class.Paladin]="Seraphim"
		Game.ClassNames[const.Class.Crusader]="Angel"
		Game.ClassNames[const.Class.Hero]="Archangel"
		Game.ClassDescriptions[const.Class.Paladin] = "Seraphim is a divine warrior, blessed by the gods with otherworldly powers that set him apart from mortal fighters. His origins are shrouded in mystery, but it is said that he was chosen by the divine to carry out their will on the mortal plane. Some whisper that he was born from the union of a mortal and an angel, while others believe that he was created by the gods themselves. Regardless of his origins, there is no denying the power that Seraphim wields, and his presence on the battlefield is a testament to the will of the divine.\n\nStats:\n+20 starting HP and +10 mana points\nProficiency in Plate, Sword, Mace, and Shield (can't dual wield)\n3 HP and 1 mana points gained per level\n\nAbilities:\n\nGods Wrath:Attacks deal extra magic damage based on Light skill (2 damage added per point in Light and Mind, 4 points per mastery Skill)\n\nHoly Strikes: Attacking will heal the most injured party member based on Body skill (2 points per point in Body and Spirit, 3 points per mastery point)\n\nDivine Protection: converts 25% of mana into self-healing when facing lethal attacks (2 healing per mana spent, increased by 5% per mastery point), 5 minutes cooldown.\n\nDivine Shield: Grants a shield equal to Max HP for 12 seconds, but dealing half damage. 3 minutes cooldown."
		Game.ClassDescriptions[const.Class.Crusader] = "The Angel, the ultimate form of seraphic evolution. Radiant and powerful, they wield holy magic with grace, and their wings span great distances as they soar through the heavens. Their mere presence fills mortals with awe and courage, and they are protectors of the weak and defenders of the just. Truly, the Angel is a magnificent being, a testament to the glory of the divine.\n\nStats:\n+20 starting HP and +10 mana points\nProficiency in Plate, Sword, Mace, and Shield (can't dual wield)\n4 HP and 2 mana points gained per level\n\nAbilities:\n\nGods Wrath:Attacks deal extra magic damage based on Light skill (2 damage added per point in Light and Mind, 4 points per mastery Skill)\n\nHoly Strikes: Attacking will heal the most injured party member based on Body skill (2 points per point in Body and Spirit, 3 points per mastery point)\n\nDivine Protection: converts 25% of mana into self-healing when facing lethal attacks (2 healing per mana spent, increased by 5% per mastery point), 5 minutes cooldown.\n\nDivine Shield: Grants a shield equal to Max HP for 12 seconds, but dealing half damage. 3 minutes cooldown."
		Game.ClassDescriptions[const.Class.Hero] = "The Archangel, the pinnacle of angelic evolution. Radiant and powerful, their wings shine like the sun, and their divine presence inspires awe and reverence. They wield holy magic with effortless skill, their swords and shields imbued with the force of the cosmos. As the guardians of the divine realm, their judgment is swift and true, their mercy boundless. The Archangel is the embodiment of divine justice and the ultimate manifestation of angelic might.\n\nStats:\n+20 starting HP and +10 mana points\nProficiency in Plate, Sword, Mace, and Shield (can't dual wield)\n5 HP and 3 mana points gained per level\n\nAbilities:\n\nGods Wrath:Attacks deal extra magic damage based on Light skill (2 damage added per point in Light and Mind, 4 points per mastery Skill)\n\nHoly Strikes: Attacking will heal the most injured party member based on Body skill (2 points per point in Body and Spirit, 3 points per mastery point)\n\nDivine Protection: converts 25% of mana into self-healing when facing lethal attacks (2 healing per mana spent, increased by 5% per mastery point), 5 minutes cooldown.\n\nDivine Shield: Grants a shield equal to Max HP for 12 seconds, but dealing half damage. 3 minutes cooldown."
		end
	end
end


----------------------------------------------------------------------
--SHADOW
----------------------------------------------------------------------
SHADOW=SETTINGS["SorcererAsShadow"]
NECROMANCER=SETTINGS["SorcererAsNecromancer"]
if NECROMANCER~=true then
	if SHADOW==true then


		function events.GameInitialized2()
			Game.ClassNames[const.Class.Sorcerer]="Nethermancer"
			Game.ClassNames[const.Class.Wizard]="Shade"
			Game.ClassNames[const.Class.ArchMage]="Gloom"
			Game.ClassDescriptions[const.Class.Sorcerer] = "Nethermancers are mages that have delved so deep into the netherdimensions that their being has almost entirely crossed over into those fell worlds. Damage taken is 1% pr mastery (new skill) rank, making shadows almost invulnerable. Damage is reduced by ca 1 pr level. Shadows have very low HP and SP, and cant use armor or weapons. Each point in mastery increase damage taken but also increases damage by ca 0.5 pr level (making shadows strong AOE dealers) and mana regeneration by 1 pr rank. If the party loses all nonshadow members the shadows immediately die as well."
			Game.ClassDescriptions[const.Class.Wizard] = "Nethermancers are mages that have delved so deep into the netherdimensions that their being has almost entirely crossed over into those fell worlds. Damage taken is 1% pr mastery (new skill) rank, making shadows almost invulnerable. Damage is reduced by ca 1 pr level. Shadows have very low HP and SP, and cant use armor or weapons. Each point in mastery increase damage taken but also increases damage by ca 0.5 pr level (making shadows strong AOE dealers) and mana regeneration by 1 pr rank. If the party loses all nonshadow members the shadows immediately die as well."
			Game.ClassDescriptions[const.Class.ArchMage] = "Nethermancers are mages that have delved so deep into the netherdimensions that their being has almost entirely crossed over into those fell worlds. Damage taken is 1% pr mastery (new skill) rank, making shadows almost invulnerable. Damage is reduced by ca 1 pr level. Shadows have very low HP and SP, and cant use armor or weapons. Each point in mastery increase damage taken but also increases damage by ca 0.5 pr level (making shadows strong AOE dealers) and mana regeneration by 1 pr rank. If the party loses all nonshadow members the shadows immediately die as well."

			Game.ClassKinds.StartingSkills[2][const.Skills.Dagger] = 0
			Game.ClassKinds.StartingSkills[2][const.Skills.Leather] = 0
			Game.ClassKinds.StartingSkills[2][const.Skills.Staff] = 0
			Game.ClassKinds.StartingSkills[2][const.Skills.Bow] = 0
			Game.ClassKinds.StartingSkills[2][const.Skills.Light] = 0
			Game.ClassKinds.StartingSkills[2][const.Skills.Dark] = 1
			Game.ClassKinds.StartingSkills[2][const.Skills.Meditation] = 0
			Game.ClassKinds.StartingSkills[2][const.Skills.Perception] = 2
			Game.ClassKinds.StartingSkills[2][const.Skills.Thievery] = 1
			Game.Classes.HPFactor[const.Class.Sorcerer] = 1
			Game.Classes.SPFactor[const.Class.Sorcerer] = 1
			Game.Classes.HPFactor[const.Class.Wizard] = 1
			Game.Classes.SPFactor[const.Class.Wizard] =1.1
			Game.Classes.HPFactor[const.Class.ArchMage] = 1
			Game.Classes.SPFactor[const.Class.ArchMage] = 1.2
			Game.ClassKinds.SPBase[2] = 10
			Game.ClassKinds.HPBase[2] = 1
		end

		function events.CalcDamageToPlayer(t)
			if (t.Player.Class==const.Class.ArchMage or t.Player.Class==const.Class.Wizard or t.Player.Class==const.Class.Sorcerer) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0  then
				shadowImmunity=0
				for i = 0, 3 do
					if Party[i].Class~= const.Class.Sorcerer and Party[i].Class~= 7  and Party[i].Class~= 8 then
						if Party[i].Unconscious==0 and Party[i].Dead==0 and Party[i].Eradicated==0 and Party[i].Paralyzed==0 then
							shadowImmunity=shadowImmunity+1
						end
					end
				end
				if shadowImmunity>0 then
					--GET MASTERY SKILL
					mastery=SplitSkill(t.Player.Skills[const.Skills.Thievery])
					Boddy=SplitSkill(t.Player.Skills[const.Skills.Bodybuilding])
					Boddy = math.max(0, Boddy - 7)
					modi = t.Player.LevelBase+3
					t.Player.SP=t.Player.SP+t.Result/modi*mastery
					t.Result=t.Result/100*(mastery+Boddy)
					Game.ShowStatusText("Absorbed")
				end
			end
		end


		function events.CalcSpellDamage(t)
			local data = WhoHitMonster()
			if data.Player and (data.Player.Class==const.Class.ArchMage or data.Player.Class==const.Class.Wizard or data.Player.Class==const.Class.Sorcerer) then	
				--get Mastery level
				mastery=SplitSkill(data.Player.Skills[const.Skills.Thievery])
				modik = data.Player.LevelBase
				t.Result = math.max(t.Result - modik^0.7 * (2.5 - 0.5 * mastery), 1)
			end
		end

		function events.CalcStatBonusByItems(t)
			if (t.Player.Class==const.Class.ArchMage or t.Player.Class==const.Class.Wizard or t.Player.Class==const.Class.Sorcerer) and t.Stat == const.Stats.SP then
			t.Result=t.Result^0.67
			end
		end

		function events.CalcStatBonusByItems(t)
			if (t.Player.Class==const.Class.ArchMage or t.Player.Class==const.Class.Wizard or t.Player.Class==const.Class.Sorcerer) and t.Stat == const.Stats.HP then
			t.Result=t.Result^0.67
			end
		end

		function events.Regeneration(t)
		--GET MASTERY SKILL
			mastery=SplitSkill(t.Player.Skills[const.Skills.Thievery])
			v = Party[t.PlayerIndex]
			class = v.Class
			mediFactor = 1
			if (class == const.Class.ArchMage) then
				ko = v.Eradicated or v.Dead or v.Stoned or v.Paralyzed or v.Unconscious or v.Asleep
				if (ko == 0) then
				cap = v:GetFullSP()
				cur = v.SpellPoints
				gain = (1+mastery^2.25/10)*(cap^0.15-0.4)
				v.SpellPoints = math.min(cap,cur+gain)
				end
			end
		end
	end
end



----------------------------------------------------------------------
--SHAMAN
----------------------------------------------------------------------

SHAMAN=SETTINGS["DruidAsShaman"]
HERBALIST=SETTINGS["DruidAsHerbalist"]
if HERBALIST~=true then
	if SHAMAN==true then
		function events.HealingSpellPower(t)
			if (t.Caster.Class==const.Class.ArchDruid or t.Caster.Class==const.Class.GreatDruid or t.Caster.Class==const.Class.Druid) then	
				m1=SplitSkill(t.Caster.Skills[const.Skills.Air])
				m2=SplitSkill(t.Caster.Skills[const.Skills.Earth])
				m3=SplitSkill(t.Caster.Skills[const.Skills.Fire])
				m4=SplitSkill(t.Caster.Skills[const.Skills.Water])
				m5=SplitSkill(t.Caster.Skills[const.Skills.Spirit])
				m6=SplitSkill(t.Caster.Skills[const.Skills.Body])
				m7=SplitSkill(t.Caster.Skills[const.Skills.Mind])
				m8=m2+m3+m4+m5+m1+m6+m7
				t.Result =t.Result+t.Result*m8/200
			end
		end

		function events.CalcSpellDamage(t)
			local data = WhoHitMonster()
			if data.Player and (data.Player.Class==const.Class.ArchDruid or data.Player.Class==const.Class.GreatDruid or data.Player.Class==const.Class.Druid) then	
				m1=SplitSkill(data.Player.Skills[const.Skills.Air])
				m2=SplitSkill(data.Player.Skills[const.Skills.Earth])
				m3=SplitSkill(data.Player.Skills[const.Skills.Fire])
				m4=SplitSkill(data.Player.Skills[const.Skills.Water])
				m5=SplitSkill(data.Player.Skills[const.Skills.Spirit])
				m6=SplitSkill(data.Player.Skills[const.Skills.Body])
				m7=SplitSkill(data.Player.Skills[const.Skills.Mind])
				m8=m2+m3+m4+m5+m1+m6+m7
				t.Result =t.Result+t.Result*m8/200
			end
		end
		
		function events.GameInitialized2()
			function events.CalcDamageToPlayer(t)
				if (t.Player.Class==const.Class.ArchDruid or t.Player.Class==const.Class.GreatDruid or t.Player.Class==const.Class.Druid) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0  then
					m1=SplitSkill(t.Player.Skills[const.Skills.Air])
					m4=SplitSkill(t.Player.Skills[const.Skills.Water])			
					t.Result=math.max(t.Result*0.99^m1-m4^1.25,0)
				end
			end
		end
		
		function events.CalcDamageToMonster(t)	
			local data = WhoHitMonster()
			if data and data.Player and (data.Player.Class==const.Class.ArchDruid or data.Player.Class==const.Class.GreatDruid or data.Player.Class==const.Class.Druid) and t.DamageKind==0 and data.Object==nil then	
				mastery=SplitSkill(data.Player.Skills[const.Skills.Thievery])
				m2=SplitSkill(data.Player.Skills[const.Skills.Earth])
				m6=SplitSkill(data.Player.Skills[const.Skills.Body])
				m7=SplitSkill(data.Player.Skills[const.Skills.Mind])
				data.Player.SP=math.min(data.Player.SP+m7, data.Player:GetFullSP())
				data.Player.HP=math.min((data.Player.HP+m6)+(m2^0.4/250)/100*t.Result, data.Player:GetFullHP())
				t.Result=t.Result*(1+m5/100)+math.max(t.Monster.HP*(m3^0.4/250),m3)
			end
		end
		function events.CalcStatBonusBySkills(t)
			if t.Stat==const.Stats.MeleeDamageBase then
				if t.Player.Class==const.Class.ArchDruid or t.Player.Class==const.Class.GreatDruid or t.Player.Class==const.Class.Druid then	
					mastery=SplitSkill(t.Player.Skills[const.Skills.Thievery])
					m1=SplitSkill(t.Player.Skills[const.Skills.Air])
					m2=SplitSkill(t.Player.Skills[const.Skills.Earth])
					m3=SplitSkill(t.Player.Skills[const.Skills.Fire])
					m4=SplitSkill(t.Player.Skills[const.Skills.Water])
					m5=SplitSkill(t.Player.Skills[const.Skills.Spirit])
					m6=SplitSkill(t.Player.Skills[const.Skills.Body])
					m7=SplitSkill(t.Player.Skills[const.Skills.Mind])
					m8=m2+m3+m4+m5+m1+m6+m7
					t.Result=t.Result+m8*(0.5+mastery/10)+mastery*2
				end
			end
		end
		function events.GameInitialized2()
			Game.ClassNames[const.Class.Druid]="Shaman"
			Game.ClassNames[const.Class.GreatDruid]="Sekhem"
			Game.ClassNames[const.Class.ArchDruid]="MarabouFetishist"
			Game.ClassKinds.StartingSkills[5][const.Skills.Spear] = 2
			Game.ClassKinds.StartingSkills[5][const.Skills.Shield] = 2
			Game.ClassKinds.StartingSkills[5][const.Skills.Thievery] = 1
			--Game.ClassKinds.StartingSkills[5][const.Skills.Dagger] = 0
			Game.Classes.SPFactor[const.Class.Druid] = 1
			Game.Classes.SPFactor[const.Class.GreatDruid] = 1.5
			Game.Classes.SPFactor[const.Class.ArchDruid] = 2
			Game.ClassDescriptions[const.Class.Druid] = "The Shaman is a mystical warrior whose knowledge of magic enhances his martial prowess.\n\n - Each rank in Magic schools will increase spell damage and healing by 0.5%\n - Each point in Air will reduce damage by 1% (multiplicative)\n - Each point in Water will reduce damage by Skill^1.25 (not influenced by AC reduction)\n\nMelee damage calculation:\n - Each point in spirit will increase damage by 1%\n - Each point in any schools will increase damage by 1 (increased by 10% per mastery point) and 2 more per each point in mastery\n - Each point in Fire will deal around 0.025% of total monster HP as damage (cannot be resisted)\n\nRecovery on Melee attack:\n - Each point in Earth will heal by 1% of damage\n - Each point in Body will heal by 1\n - Each point in mind will restore 1 mana"
			Game.ClassDescriptions[const.Class.GreatDruid] = "The Sekhem is a mystical warrior whose knowledge of magic enhances his martial prowess.\n\n - Each rank in Magic schools will increase spell damage and healing by 0.5%\n - Each point in Air will reduce damage by 1% (multiplicative)\n - Each point in Water will reduce damage by Skill^1.25 (not influenced by AC reduction)\n\nMelee damage calculation:\n - Each point in spirit will increase damage by 1%\n - Each point in any schools will increase damage by 1 (increased by 5% per mastery point) and 2 more per each point in mastery (cannot be resisted)\n - Each point in Fire will deal around 0.025% of total monster HP as damage (cannot be resisted)\n\nRecovery on Melee attack:\n - Each point in Earth will heal by 1% of damage\n - Each point in Body will heal by 1\n - Each point in mind will restore 1 mana"
			Game.ClassDescriptions[const.Class.ArchDruid] = "The MarabouFetishist is a mystical warrior whose knowledge of magic enhances his martial prowess.\n\n - Each rank in Magic schools will increase spell damage and healing by 0.5%\n - Each point in Air will reduce damage by 1% (multiplicative)\n - Each point in Water will reduce damage by Skill^1.25 (not influenced by AC reduction)\n\nMelee damage calculation:\n - Each point in spirit will increase damage by 1%\n - Each point in any schools will increase damage by 1 (increased by 5% per mastery point) and 2 more per each point in mastery (cannot be resisted)\n - Each point in Fire will deal around 0.025% of total monster HP as damage (cannot be resisted)\n\nRecovery on Melee attack:\n - Each point in Earth will heal by 1% of damage\n - Each point in Body will heal by 1\n - Each point in mind will restore 1 mana"

		end
	end
end
