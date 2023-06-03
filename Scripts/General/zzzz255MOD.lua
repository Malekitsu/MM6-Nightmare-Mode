if SETTINGS["255MOD"]==true then
function events.GenerateItem(t)
	--get party average level
	partyExperience = 0
	Handled = false
	for i = 0, 3 do
		partyExperience = partyExperience + Party.Players[i].Experience
	end
	
	averagePlayerExperience = partyExperience / 4
	
	partyLevel = math.floor((1 + math.sqrt(1 + (4 * averagePlayerExperience / 500))) / 2)-100
	
	--buff if item is weak
	if t.Strength*20<partyLevel and t.Strength<6 then
		roll=math.random(1,t.Strength*20)
		if roll<(partyLevel-t.Strength*20) then
			t.Strength=math.min(t.Strength+1,6)
		end
		
		if partyLevel>t.Strength*20+20 and t.Strength<6 then
		roll=math.random(1,t.Strength*20+20)
			if roll<(partyLevel-(t.Strength*20+20)) then
				t.Strength=math.min(t.Strength+1,6)
			end	
		end
	end
	--nerf if item is strong
	if partyLevel<(t.Strength-3)*20 and t.Strength<7 then
		t.Strength=math.max(t.Strength-1,1)
	end
	if (t.Strength-1)*20>partyLevel and t.Strength>2 and t.Strength<7 then
		roll=math.random((t.Strength-3)*20,(t.Strength-2)*20)
		if roll>partyLevel then
			t.Strength=t.Strength-1
		end
	end
	if t.Item.Number>580 then
	t.Item.Number=0
	end

end

function events.ItemGenerated(t)	
	if t.Item.Number<=134 then

		if t.Item.Number>580 then
			t.Item.Number=0
		end
		
		
		--------------------------------------------------------
		--255 MOD, UPSCALE ITEMS MOD 2 FOR WEAPONS AND RANDOMIZE
		--------------------------------------------------------
		for i=1,65 do
			if i==t.Item.Number then
			upTierDifference=0
			downTierDifference=0
			downDamage=0
			--set goal damage for weapons (end game weapon damage)
			goalWeaponMultiplier=3
			currentDamage = Game.ItemsTxt[i].Mod1DiceCount*(listDiceSides[i]+1)/2+listMod2[i]
				for v=1,4 do
					if Game.ItemsTxt[i].NotIdentifiedName==Game.ItemsTxt[i+v].NotIdentifiedName then
					upTierDifference=upTierDifference+1
					maxWeapon = Game.ItemsTxt[i+v].Mod1DiceCount*(listDiceSides[i+v]+1)/2+listMod2[i+v]
					elseif upTierDifference==0 then
						maxWeapon = currentDamage
					end
					if Game.ItemsTxt[i].NotIdentifiedName==Game.ItemsTxt[math.max(i-v,0)].NotIdentifiedName then
					downTierDifference=downTierDifference+1
					end
				end

			--calculate expected value
			tierRange=upTierDifference+downTierDifference+1
			damageRange=maxWeapon*2
			expectedDamageIncrease=goalWeaponMultiplier^((downTierDifference+1)/(tierRange))
			t.Item.ExtraData=maxWeapon*expectedDamageIncrease-currentDamage
			end
		end
		
		--ARMORS
		
		for i=66,134 do
			if i==t.Item.Number then
			upTierDifference=0
			downTierDifference=0
			downArmor=0
			--set goal damage for weapons (end game weapon damage)
			goalArmorMultiplier=3
			currentArmor = Game.ItemsTxt[i].Mod1DiceCount+Game.ItemsTxt[i].Mod2 
				for v=1,4 do
					if Game.ItemsTxt[i].NotIdentifiedName==Game.ItemsTxt[i+v].NotIdentifiedName then
					upTierDifference=upTierDifference+1
					maxArmor = Game.ItemsTxt[i+v].Mod1DiceCount+Game.ItemsTxt[i+v].Mod2
					elseif upTierDifference==0 then
						maxArmor = currentArmor
					end
					if Game.ItemsTxt[i].NotIdentifiedName==Game.ItemsTxt[math.max(i-v,0)].NotIdentifiedName then
					downTierDifference=downTierDifference+1
					end
				end

			--calculate expected value
			tierRange=upTierDifference+downTierDifference+1
			armorRange=maxArmor*2
			expectedArmorIncrease=goalArmorMultiplier^((downTierDifference+1)/(tierRange))
			t.Item.ExtraData=maxArmor*expectedArmorIncrease-currentArmor
				if t.Item.ExtraData==0 then
					t.Item.ExtraData=1
				end
			end
		end
		
		--give bonus a chance to proc even if bonus2 is already in the item
		if t.Item.Bonus2~=0 then
		bonusprocChance=math.random(1,100)
			if bonusprocChance<=40 and t.Strength~=1 or (t.Strength==6 and bonusprocChance<=75) then
				t.Item.Bonus = math.random(1,14)
				local bonuses = {{38, 45}, {41, 50}, {46, 57}, {52, 65}, {60, 75}}
				local bonus = bonuses[t.Strength - 1]
				t.Item.BonusStrength = math.random(bonus[1], bonus[2])
			end
		end
		--extra bonus proc
		extraBonusChance={30,40,50,50,50,50}
		extraBonusPowerLow={35,38,41,46,52,60}
		extraBonusPowerHigh={40,45,50,57,65,75}
		ChargesProc=math.random(1,100)
		if ChargesProc<=extraBonusChance[t.Strength] then
			lowerLimit=t.Strength
			t.Item.Charges = math.random(14 * extraBonusPowerLow[t.Strength]-13, 14 * extraBonusPowerHigh[t.Strength])
			--make it standard bonus if no standard bonus
			if t.Item.Bonus==0 then
				t.Item.Bonus=t.Item.Charges%14+1
				t.Item.BonusStrength=math.ceil(t.Item.Charges/14)
				t.Item.Charges=0
			end
		end
		--fix for standard bonus
		if t.Item.BonusStrength<26 then
			t.Item.BonusStrength=(t.Item.BonusStrength+35)*1.25
		end
		--of x spell proc chance
		if t.Item.Number>=120 and t.Item.Number<=134 and t.Item.Bonus2~=0 and t.Strength < 6 then
			roll=math.random(1,100)
			if roll<(t.Strength-1)*10 then
				t.Item.Bonus2=math.random(26,34)
			end
		end
		
		--chance for ancient item, only if bonus 2 is spawned
		if t.Item.Bonus2~=0 or Game.Map.Name=="zddb10.blv" then 
			ancient=math.random(1,50)
			if ancient<=t.Strength-3 or Game.Map.Name=="zddb10.blv" then
				t.Item.Charges=math.random(1064,1400)
				t.Item.Bonus=math.random(1,14)
				t.Item.BonusStrength=math.random(76,100)
				if t.Item.Number>=94 and t.Item.Number<=99 then
				t.Item.ExtraData=13000+math.random(90,100)
				end
			end
		end
		
		--primordial item
		primordial=math.random(1,200)
		if primordial<=t.Strength-4 or Game.Map.Name=="sci-fi.blv" then
			t.Item.Charges=math.random(1387,1400)
			t.Item.Bonus=math.random(1,14)
			t.Item.BonusStrength=100
			if t.Item.Number>60 then
				t.Item.Bonus2=math.random(1,2)
				else
				t.Item.Bonus2=41
			end
			--crowns/hats
			if t.Item.Number>=94 and t.Item.Number<=99 then
			t.Item.ExtraData=13100
			end
		end	
		--buff to hp and mana items
		if t.Item.Bonus==8 or t.Item.Bonus==9 then
			t.Item.BonusStrength=t.Item.BonusStrength*4
		end
		if t.Item.Charges%14==7 or t.Item.Charges%14==8 then
			t.Item.Charges=t.Item.Charges+42*math.ceil(t.Item.Charges/14)
		end
		
		--CROWNS & HATS
		if t.Item.ExtraData~=nil then
			if t.Item.Number>=94 and t.Item.Number<=99 and t.Item.ExtraData==0 then
					hatpower={}
					hatpower[1]=math.random(35,41)
					hatpower[2]=math.random(38,45)
					hatpower[3]=math.random(41,50)
					hatpower[4]=math.random(46,57)
					hatpower[5]=math.random(52,65)
					hatpower[6]=math.random(60,75)
					roll=math.random(1,100)
				if roll<=25 then
				t.Item.ExtraData=hatpower[t.Strength]+13000
				else if t.Item.Number>=94 and t.Item.Number<=96 then
					t.Item.ExtraData=hatpower[t.Strength]+11000
					else
					t.Item.ExtraData=hatpower[t.Strength]+12000
					end
				end
			end
		end
	end
end



--ENCHANTS HERE
--MELEE bonuses
enchantbonusdamage = {}
enchantbonusdamage[4] = 15
enchantbonusdamage[5] = 15
enchantbonusdamage[6] = 15
enchantbonusdamage[7] = 15
enchantbonusdamage[8] = 15
enchantbonusdamage[9] = 15
enchantbonusdamage[10] = 15
enchantbonusdamage[11] = 15
enchantbonusdamage[12] = 15
enchantbonusdamage[13] = 15
enchantbonusdamage[14] = 15
enchantbonusdamage[15] = 15
enchantbonusdamage[46] = 15

function events.CalcDamageToMonster(t)
    local data = WhoHitMonster()
    if data.Player and t.DamageKind ~= 0 and data.Object == nil then
	n=1
	bonusDamage2=1
        for i = 0,1 do
			it=data.Player:GetActiveItem(i)
			
			--generate randoms

			bonusDamage=0
			-- calculation
			if it then
				if (it.Bonus2 >= 4 and it.Bonus2 <= 15) or it.Bonus2 == 46 and it.ExtraData>0 then
				local bonusDamage1 = bonusDamage+enchantbonusdamage[it.Bonus2] or 0
				bonusDamage2=(bonusDamage2*bonusDamage1)^(1/n)
				n=n+1
				end
			end
        end	
		
		if n~=0 and bonusDamage2~=0 then
		t.Result = bonusDamage2*t.Result
		end
    end
end

--bows 

function events.CalcDamageToMonster(t)
    local data = WhoHitMonster()
    if data.Player and t.DamageKind ~= 0 and data.Object~=nil then
			if data.Object.Spell==100 then
			it=data.Player:GetActiveItem(2)
			-- calculation
			if (it.Bonus2 >= 4 and it.Bonus2 <= 15) or it.Bonus2 == 46 and it.ExtraData>0 then
			local bonusDamage = enchantbonusdamage[it.Bonus2] or 0
			t.Result=t.Result*bonusDamage
			end	
		end
	end
 end

spellbonusdamage={}

spellbonusdamage[13] = 75
spellbonusdamage[14] = 120
spellbonusdamage[15] = 180

aoespells = {6, 7, 8, 9, 10, 15, 22, 26, 32, 41, 43, 84, 92, 97, 98, 99}
function events.CalcSpellDamage(t)
data=WhoHitMonster()
	if data.Player then
		it=data.Player:GetActiveItem(1)
		if it then
			if (it.Bonus2 >= 4 and it.Bonus2 <= 15) or it.Bonus2 == 46 and it.ExtraData>0 then
				spellbonusdamage[4] = math.random(45, 60)
				spellbonusdamage[5] = math.random(90, 120)
				spellbonusdamage[6] = math.random(135, 180)
				spellbonusdamage[7] = math.random(30, 75)
				spellbonusdamage[8] = math.random(60, 150)
				spellbonusdamage[9] = math.random(90, 225)
				spellbonusdamage[10] = math.random(15, 90)
				spellbonusdamage[11] = math.random(30, 180)
				spellbonusdamage[12] = math.random(45, 270)
				spellbonusdamage[46] = math.random(150, 300)
				buffed=0
				bonusDamage = spellbonusdamage[it.Bonus2] or 0
				for i = 1, #aoespells do
					if aoespells[i] == t.Spell then
						t.Result = t.Result+bonusDamage/5
						buffed=1
						break
					end
				end
				if buffed==0 then
				t.Result = t.Result+bonusDamage
				end
			end
		end
	end
end



--[[
function events.CalcDamageToMonster(t)
    local data = WhoHitMonster()
    if data.Player and data.Object ~= nil and data.Object.Spell<100 then
		
		it=data.Player:GetActiveItem(0)
			
		--generate randoms
		enchantbonusdamage = {}
		enchantbonusdamage[4] = math.random(6, 8)
		enchantbonusdamage[5] = math.random(18, 24)
		enchantbonusdamage[6] = math.random(36, 48)
		enchantbonusdamage[7] = math.random(4, 10)
		enchantbonusdamage[8] = math.random(12, 30)
		enchantbonusdamage[9] = math.random(24, 60)
		enchantbonusdamage[10] = math.random(2, 12)
		enchantbonusdamage[11] = math.random(6, 36)
		enchantbonusdamage[12] = math.random(12, 72)
		enchantbonusdamage[46] = math.random(20, 80)
		-- calculation
		if (it.Bonus2 >= 4 and it.Bonus2 <= 15) or it.Bonus2 == 46 then
		bonusDamage2 = enchantbonusdamage[it.Bonus2] or 0
		t.Damage = t.Damage+bonusDamage2
		debug.Message(dump(t.Damage))
		end
    end	
end
--]]
---------------------
--multiple enchant tooltip
---------------------


mem.autohook(0x41C440, function(d)
	local t = {Item = structs.Item:new(d.ecx)}
	events.call("ShowItemTooltip", t)
end)

mem.autohook(0x41CE00, function(d)
	events.call("AfterShowItemTooltip")
end)


--STAT NAMES for custom tooltip
itemStatName = {"Might", "Intellect", "Personality", "Endurance", "Accuracy", "Speed", "Luck", "Hit Points", "Spell Points", "Armor Class", "Fire Resistance", "Elec Resistance", "Cold Resistance", "Poison Resistance"}



--change tooltip

function events.ShowItemTooltip(item)
	if item.Item.Bonus~=0 and item.Item.Bonus2~=0 and item.Item.Charges~=0 then
	Game.StdItemsTxt[item.Item.Bonus-1].BonusStat=string.format("%s\n%s +%s\n%s",Game.SpcItemsTxt[item.Item.Bonus2-1].BonusStat,itemStatName[item.Item.Charges%14+1],math.ceil(item.Item.Charges/14), itemStatName[item.Item.Bonus])
		else if item.Item.Bonus~=0 and item.Item.Bonus2~=0 and item.Item.Charges==0 then
			Game.StdItemsTxt[item.Item.Bonus-1].BonusStat=string.format("%s\n%s",Game.SpcItemsTxt[item.Item.Bonus2-1].BonusStat, itemStatName[item.Item.Bonus])
			else if item.Item.Bonus~=0 and item.Item.Charges~=0 and item.Item.Bonus2==0 then
				Game.StdItemsTxt[item.Item.Bonus-1].BonusStat=string.format("\n%s +%s\n%s",itemStatName[item.Item.Charges%14+1],math.ceil(item.Item.Charges/14), itemStatName[item.Item.Bonus])
				else if item.Item.Bonus~=0 and item.Item.Charges==0 and item.Item.Bonus2==0 then
					Game.StdItemsTxt[item.Item.Bonus-1].BonusStat=string.format("%s",itemStatName[item.Item.Bonus])
				end
			end
		end
	end
	
--Change item name
ancient=0
bonus=item.Item.BonusStrength
if item.Item.Bonus==8 or item.Item.Bonus==9 then
	bonus=bonus/2
end
extrabonus=math.ceil(item.Item.Charges/14)
if item.Item.Charges%14==7 or item.Item.Charges%14==8 then
	extrabonus=extrabonus/2
end
	
if (bonus>75 and extrabonus>75) or bonus+extrabonus>150 then
	Game.ItemsTxt[item.Item.Number].Name=string.format("%s %s","Ancient", itemName[item.Item.Number])
	else 
	Game.ItemsTxt[item.Item.Number].Name=string.format("%s", itemName[item.Item.Number])
end

if bonus==100 and extrabonus==100 then
	Game.ItemsTxt[item.Item.Number].Name=string.format("%s %s","Primordial", itemName[item.Item.Number])
	end

--Crowns and HATS
	if item.Item.ExtraData~=nil then
		if item.Item.Number>=94 and item.Item.Number<=99 and item.Item.ExtraData>0 then
			local statbonus=item.Item.ExtraData
				if statbonus>3000 then
				statbonus="Damage and Healing"
				else if statbonus>2000 then
					statbonus="Healing"
					else statbonus="Damage"
				end
			end			
			Game.ItemsTxt[item.Item.Number].Notes=string.format("Increases spell %s by: %s%s\n\n%s",statbonus,item.Item.ExtraData%1000,"%",itemDesc[item.Item.Number])
			else
			Game.ItemsTxt[item.Item.Number].Notes=itemDesc[item.Item.Number]
		end
	end
end


---------------------------------------
--NEW SCALING
---------------------------------------

	function events.GameInitialized2()
	--knight
	Game.Classes.HPFactor[0] = Game.Classes.HPFactor[2]
	Game.Classes.HPFactor[1] = Game.Classes.HPFactor[2]*1.5
	Game.Classes.HPFactor[2] = Game.Classes.HPFactor[2]*2
	--cleric
	Game.Classes.HPFactor[3] = Game.Classes.HPFactor[5]
	Game.Classes.HPFactor[4] = Game.Classes.HPFactor[5]*1.5
	Game.Classes.HPFactor[5] = Game.Classes.HPFactor[5]*2
	Game.Classes.SPFactor[3] = Game.Classes.SPFactor[5]
	Game.Classes.SPFactor[4] = Game.Classes.SPFactor[5]*1.5
	Game.Classes.SPFactor[5] = Game.Classes.SPFactor[5]	*2
	--sorcerer
	Game.Classes.HPFactor[6] = Game.Classes.HPFactor[8]
	Game.Classes.HPFactor[7] = Game.Classes.HPFactor[8]*1.5
	Game.Classes.HPFactor[8] = Game.Classes.HPFactor[8]*2
	Game.Classes.SPFactor[6] = Game.Classes.SPFactor[8]
	Game.Classes.SPFactor[7] = Game.Classes.SPFactor[8]*1.5
	Game.Classes.SPFactor[8] = Game.Classes.SPFactor[8]*2
	--paladin
	Game.Classes.HPFactor[9] = Game.Classes.HPFactor[11]
	Game.Classes.HPFactor[10] = Game.Classes.HPFactor[11]*1.5
	Game.Classes.HPFactor[11] = Game.Classes.HPFactor[11]*2
	Game.Classes.SPFactor[9] = Game.Classes.SPFactor[11]
	Game.Classes.SPFactor[10] = Game.Classes.SPFactor[11]*1.5
	Game.Classes.SPFactor[11] = Game.Classes.SPFactor[11]*2
	--archer
	Game.Classes.HPFactor[12] = Game.Classes.HPFactor[14]
	Game.Classes.HPFactor[13] = Game.Classes.HPFactor[14]*1.5
	Game.Classes.HPFactor[14] = Game.Classes.HPFactor[14]*2
	Game.Classes.SPFactor[12] = Game.Classes.SPFactor[14]
	Game.Classes.SPFactor[13] = Game.Classes.SPFactor[14]*1.5
	Game.Classes.SPFactor[14] = Game.Classes.SPFactor[14]*2
	--druid
	Game.Classes.HPFactor[15] = Game.Classes.HPFactor[17]
	Game.Classes.HPFactor[16] = Game.Classes.HPFactor[17]*1.5
	Game.Classes.HPFactor[17] = Game.Classes.HPFactor[17]*2
	Game.Classes.SPFactor[15] = Game.Classes.SPFactor[17]
	Game.Classes.SPFactor[16] = Game.Classes.SPFactor[17]*1.5
	Game.Classes.SPFactor[17] = Game.Classes.SPFactor[17]*2
	
	--names
		for i=0,17 do
			if i%3==0 then
				Game.ClassNames[i]=Game.ClassNames[i+2]
				Game.ClassDescriptions[i]=Game.ClassDescriptions[i+2]
			end
			if i%3==1 then
				Game.ClassNames[i]=Game.ClassNames[i+1]
				Game.ClassDescriptions[i]=Game.ClassDescriptions[i+1]
			end
		end
	end
	
	
end

--MOD2 CHANGER
function events.GameInitialized2()
	listMod2={}
	for i=1, 119 do
	listMod2[i]=Game.ItemsTxt[i].Mod2
	end
	listDiceSides={}
	for i=1, 119 do
	listDiceSides[i]=Game.ItemsTxt[i].Mod1DiceSides
	end
end
itemindex=1

--increase damage in the tooltip
function events.CalcStatBonusByItems(t)
--required to correct tooltip of unequipped items
	Game.ItemsTxt[itemindex].Mod2=listMod2[itemindex]
	Game.ItemsTxt[i].Mod1DiceSides=listDiceSides[i]
	itemindex=itemindex+1
		if itemindex>=119 then
			itemindex=1
		end
		
	for it in t.Player:EnumActiveItems() do
		-- fix current item
		Game.ItemsTxt[it.Number].Mod2=listMod2[it.Number]
		Game.ItemsTxt[it.Number].Mod1DiceSides=listDiceSides[it.Number]
		if it.ExtraData ~= nil then
			if t.Stat==const.Stats.ArmorClass and ((it.Number>=66 and it.Number<=93) or (it.Number>=100 and it.Number<=119)) then
				t.Result=t.Result+it.ExtraData
			end
			--melee
			if it.Number<=41 or (it.Number<=63 and it.Number>=50) then
				if t.Stat==const.Stats.MeleeDamageMin or t.Stat==const.Stats.MeleeDamageMax or t.Stat==const.Stats.MeleeAttack then
					t.Result=t.Result+it.ExtraData/2
				end
				if t.Stat==const.Stats.MeleeDamageMax then
					t.Result=t.Result+it.ExtraData
				end
			end
			--ranged
			if it.Number==65 or it.Number==64 or(it.Number>=42 and it.Number<=49) then
				if t.Stat==const.Stats.RangedDamageMin or t.Stat==const.Stats.RangedDamageMax then
					t.Result=t.Result+it.ExtraData/2
				end
				if t.Stat==const.Stats.RangedDamageMax then
					t.Result=t.Result+it.ExtraData
				end
			end 
		end
	end
end
--recalculate actual damage
function events.ModifyItemDamage(t)
bonusDamage=0
	if t.Item.Number<66 then
		if t.Item.ExtraData~=nil then
			bonusDamage=Game.ItemsTxt[t.Item.Number].Mod2+t.Item.ExtraData/2
			--calculate dices
			for i=1,Game.ItemsTxt[t.Item.Number].Mod1DiceCount do
				bonusDamage=bonusDamage+math.random(1,Game.ItemsTxt[t.Item.Number].Mod1DiceSides+t.Item.ExtraData/Game.ItemsTxt[t.Item.Number].Mod1DiceCount)
			end
		end
	end
t.Result=bonusDamage
end

--show extraData
function events.ShowItemTooltip(item)
	if item.Item.ExtraData ~=nil then
		--WEAPONS
		if item.Item.Number<=65 then
			Game.ItemsTxt[item.Item.Number].Mod2=listMod2[item.Item.Number]+item.Item.ExtraData/2
			Game.ItemsTxt[item.Item.Number].Mod1DiceSides=listDiceSides[item.Item.Number]+item.Item.ExtraData/Game.ItemsTxt[item.Item.Number].Mod1DiceCount
		end
		--ARMORS
		if item.Item.Number>=66 and item.Item.Number<=119 then
		Game.ItemsTxt[item.Item.Number].Mod2=listMod2[item.Item.Number]+item.Item.ExtraData
		end
		--enchant2
		if ((item.Item.ExtraData>0 and item.Item.ExtraData<1000) or item.Item.ExtraData>10000) and item.Item.Bonus2>0 and item.Item.Number<=134 then
		Game.SpcItemsTxt[item.Item.Bonus2-1].BonusStat=spcEnchTxt255[item.Item.Bonus2-1]
		elseif item.Item.Bonus2>0 and item.Item.Number<=134 then
		Game.SpcItemsTxt[item.Item.Bonus2-1].BonusStat=spcEnchTxtMaw[item.Item.Bonus2-1]
		end
	end
end

--swapper
function events.ShowItemTooltip(item)
	if item.Item.Refundable==false and item.Item.Number<=134 and swapper==true then
		charges=item.Item.Charges
		item.Item.Charges=item.Item.ExtraData
		item.Item.ExtraData=charges
		item.Item.Refundable=true
	end
end


--ENCHANTS FOR 255
effectsToEnchantmentsMap =
{
    [1] = {stats = {10,11,12,13}, effect = 20},
	[2] = {stats = {0,1,2,3,4,5,6}, effect = 20},
	[25] = {stats = {const.Stats.Level}, effect = 10},
	[42] = {stats = {1,2,3,4,5,6,7,8,9,10,11,12,13}, effect = 4},
	[43] = {stats = {3,7,9}, effect = 20},
	[44] = {stats = {7}, effect = 110},
	[45] = {stats = {4,5}, effect = 10},
	[46] = {stats = {0}, effect = 50},
	[47] = {stats = {8}, effect = 110},
	[48] = {stats = {3,9}, effect = 15},
	[49] = {stats = {1,6}, effect = 20},
	[50] = {stats = {10}, effect = 60},
	[51] = {stats = {1,5,8}, effect = 20},
	[52] = {stats = {3,4}, effect = 20},
	[53] = {stats = {0,2}, effect = 20},
	[54] = {stats = {3}, effect = 20},
	[55] = {stats = {6}, effect = 30},
	[56] = {stats = {0,3}, effect = 20},
	[57] = {stats = {1,2}, effect = 20},
}

function events.CalcStatBonusByItems(t)
    for enchId, data in pairs(effectsToEnchantmentsMap) do
        if table.find(data.stats, t.Stat) then
            for it in t.Player:EnumActiveItems() do
                if it.Bonus2 == enchId and (it.ExtraData>0 and it.ExtraData<1000) or it.ExtraData>10000  then
                    t.Result = t.Result + data.effect
                end
            end
        end
    end
end

--change tooltips
------------
--tooltips
------------
function events.GameInitialized2()
spcEnchTxtMaw={}
for i=0,57 do
spcEnchTxtMaw[i]=Game.SpcItemsTxt[i].BonusStat
end
Game.SpcItemsTxt[3].BonusStat="Adds 45-60 points of Cold damage."
Game.SpcItemsTxt[4].BonusStat="Adds 90-120 points of Cold damage."
Game.SpcItemsTxt[5].BonusStat="Adds 135-180 points of Cold damage."
Game.SpcItemsTxt[6].BonusStat="Adds 30-75 points of Electrical damage."
Game.SpcItemsTxt[7].BonusStat="Adds 60-150 points of Electrical damage."
Game.SpcItemsTxt[8].BonusStat="Adds 90-225 points of Electrical damage."
Game.SpcItemsTxt[9].BonusStat="Adds 15-90 points of Fire damage."
Game.SpcItemsTxt[10].BonusStat="Adds 30-180 points of Fire damage."
Game.SpcItemsTxt[11].BonusStat="Adds 45-270 points of Fire damage."
Game.SpcItemsTxt[12].BonusStat="Adds 75 points of Poison damage."
Game.SpcItemsTxt[13].BonusStat="Adds 120 points of Poison damage."
Game.SpcItemsTxt[14].BonusStat="Adds 180 points of Poison damage."
Game.SpcItemsTxt[0].BonusStat= " +30 to all Resistances."
Game.SpcItemsTxt[1].BonusStat= " +30 to all Seven Statistics."
Game.SpcItemsTxt[24].BonusStat= "Death and eradication Immunity, +15 Levels"
Game.SpcItemsTxt[41].BonusStat= " +5 to All Statistics."
Game.SpcItemsTxt[42].BonusStat= " +30 to Endurance, Armor, Hit points."
Game.SpcItemsTxt[43].BonusStat=" +120 HP and Regenerate HP over time."
Game.SpcItemsTxt[44].BonusStat= " +15 Speed and Accuracy."
Game.SpcItemsTxt[45].BonusStat= "Adds 150-300 Fire damage, +75 Might."
Game.SpcItemsTxt[46].BonusStat= " +120 Spell points and SP Regeneration."
Game.SpcItemsTxt[47].BonusStat= " +30 Endurance and +20 Armor."
Game.SpcItemsTxt[48].BonusStat= " +30 Intellect and Luck."
Game.SpcItemsTxt[49].BonusStat= " +90 Fire Resistance and HP Regeneration."	 
Game.SpcItemsTxt[50].BonusStat= " +30 Spell points, Speed, Intellect."
Game.SpcItemsTxt[51].BonusStat= " +30 Endurance and Accuracy."
Game.SpcItemsTxt[52].BonusStat= " +30 Might and Personality."
Game.SpcItemsTxt[53].BonusStat=" +45 Endurance and Regenerate HP."
Game.SpcItemsTxt[54].BonusStat= " +45 Luck and Regenerate Spell points."
Game.SpcItemsTxt[55].BonusStat= " +25 Might and Endurance."
Game.SpcItemsTxt[56].BonusStat= " +25 Intellect and Personality."

spcEnchTxt255={}
for i=0,57 do
	spcEnchTxt255[i]=Game.SpcItemsTxt[i].BonusStat
end

end

