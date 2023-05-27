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
		extraDataProc=math.random(1,100)
		if extraDataProc<=extraBonusChance[t.Strength] then
			lowerLimit=t.Strength
			t.Item.ExtraData = math.random(14 * extraBonusPowerLow[t.Strength]-13, 14 * extraBonusPowerHigh[t.Strength])
			--make it standard bonus if no standard bonus
			if t.Item.Bonus==0 then
				t.Item.Bonus=t.Item.ExtraData%14+1
				t.Item.BonusStrength=math.ceil(t.Item.ExtraData/14)
				t.Item.ExtraData=0
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
				t.Item.ExtraData=math.random(1064,1400)
				t.Item.Bonus=math.random(1,14)
				t.Item.BonusStrength=math.random(76,100)
				if t.Item.Number>=94 and t.Item.Number<=99 then
				t.Item.Charges=2000+math.random(90,100)
				end
			end
		end
		
		--primordial item
		primordial=math.random(1,200)
		if primordial<=t.Strength-4 or Game.Map.Name=="sci-fi.blv" then
			t.Item.ExtraData=math.random(1387,1400)
			t.Item.Bonus=math.random(1,14)
			t.Item.BonusStrength=100
			if t.Item.Number>60 then
				t.Item.Bonus2=math.random(1,2)
				else
				t.Item.Bonus2=41
			end
			--crowns/hats
			if t.Item.Number>=94 and t.Item.Number<=99 then
			t.Item.Charges=2100
			end
		end	
		--buff to hp and mana items
		if t.Item.Bonus==8 or t.Item.Bonus==9 then
			t.Item.BonusStrength=t.Item.BonusStrength*2
		end
		if t.Item.ExtraData%14==7 or t.Item.ExtraData%14==8 then
			t.Item.ExtraData=t.Item.ExtraData+14*math.ceil(t.Item.ExtraData/14)
		end
		
		--CROWNS & HATS
		if t.Item.Number>=94 and t.Item.Number<=99 and (t.Item.Bonus~=0 or t.Item.Bonus2~=0) and t.Item.Charges==0 then
			hatpower={}
			hatpower[1]=math.random(35,41)
			hatpower[2]=math.random(38,45)
			hatpower[3]=math.random(41,50)
			hatpower[4]=math.random(46,57)
			hatpower[5]=math.random(52,65)
			hatpower[6]=math.random(60,75)
			roll=math.random(1,100)
			if roll<=25 then
			t.Item.Charges=hatpower[t.Strength]+2000
			else if t.Item.Number>=94 and t.Item.Number<=96 then
				t.Item.Charges=hatpower[t.Strength]
				else
				t.Item.Charges=hatpower[t.Strength]+1000
				end
			end
		end
	end
end



--apply extra data effect
function events.CalcStatBonusByItems(t)
	for it in t.Player:EnumActiveItems() do
		if it.ExtraData ~= nil then
			stat=it.ExtraData%14
			bonus=math.ceil(it.ExtraData/14)
				if t.Stat==stat then
				t.Result = t.Result + bonus
				end				
		end
	end
end

--apply crown effect
function events.CalcSpellDamage(t)
data=WhoHitMonster()
	if data.Player then
		it=data.Player:GetActiveItem(4)
		if it then
		bonus=it.Charges
			if it.Charges<1000 or it.Charges>2000 then
			t.Result=math.ceil(t.Result*((it.Charges%1000)/100+1))
			end
		end
	end
end

function events.HealingSpellPower(t)
	it=t.Caster:GetActiveItem(4)
	if it then
		if it.Charges>1000 then
			if t.Spell ~= 54 then
			t.Result=math.ceil(t.Result*((it.Charges%1000)/100+1))
			end
		end
	end
end



----------------------
--weapon rework
----------------------
function events.GameInitialized2()
--2h dice bonus
for i = 6, 8 do
	Game.ItemsTxt[i].Mod1DiceSides = math.round(Game.ItemsTxt[i].Mod1DiceSides^(2^(1*Game.ItemsTxt[i].Mod2/13)))
end
for i = 28, 41 do
	Game.ItemsTxt[i].Mod1DiceSides = math.round(Game.ItemsTxt[i].Mod1DiceSides^(2^(1*Game.ItemsTxt[i].Mod2/13)))
end

--2h artifacts bonus
Game.ItemsTxt[402].Mod1DiceSides = math.round(Game.ItemsTxt[402].Mod1DiceSides^(2^(1*Game.ItemsTxt[402].Mod2/13)))
Game.ItemsTxt[417].Mod1DiceSides = math.round(Game.ItemsTxt[417].Mod1DiceSides^(2^(1*Game.ItemsTxt[417].Mod2/13)))
Game.ItemsTxt[419].Mod1DiceSides = math.round(Game.ItemsTxt[419].Mod1DiceSides^(2^(1*Game.ItemsTxt[419].Mod2/13)))

--weapon bonus
for i = 1, 63 do
	Game.ItemsTxt[i].Mod2=math.round(Game.ItemsTxt[i].Mod2^1.4)
end

for i = 400, 405 do
	Game.ItemsTxt[i].Mod2=math.round(Game.ItemsTxt[i].Mod2^1.4)
end

for i = 415, 420 do
	Game.ItemsTxt[i].Mod2=math.round(Game.ItemsTxt[i].Mod2^1.4)
end
------------
--Change item drop%
------------
--[[ REMOVED AS IT CAUSES ITEMS BUG
Game.ItemsTxt[4].ChanceByLevel[3]=0
Game.ItemsTxt[11].ChanceByLevel[4]=0
Game.ItemsTxt[14].ChanceByLevel[3]=0
Game.ItemsTxt[14].ChanceByLevel[4]=2
Game.ItemsTxt[37].ChanceByLevel[2]=0
Game.ItemsTxt[37].ChanceByLevel[3]=2
Game.ItemsTxt[40].ChanceByLevel[3]=2
Game.ItemsTxt[40].ChanceByLevel[4]=10
--]]
--armors fix
Game.ItemsTxt[71].Mod2=2
Game.ItemsTxt[72].Mod2=7
Game.ItemsTxt[73].Mod2=16
Game.ItemsTxt[74].Mod2=28
Game.ItemsTxt[75].Mod2=44

Game.ItemsTxt[76].Mod2=8
Game.ItemsTxt[77].Mod2=24
Game.ItemsTxt[78].Mod2=60

Game.ItemsTxt[79].Mod2=3
Game.ItemsTxt[80].Mod2=5
Game.ItemsTxt[81].Mod2=9
Game.ItemsTxt[82].Mod2=18
Game.ItemsTxt[83].Mod2=33
Game.ItemsTxt[84].Mod2=2
Game.ItemsTxt[85].Mod2=5
Game.ItemsTxt[86].Mod2=9
Game.ItemsTxt[87].Mod2=18
Game.ItemsTxt[88].Mod2=33

Game.ItemsTxt[406].Mod2=46
Game.ItemsTxt[407].Mod2=64
Game.ItemsTxt[408].Mod2=38

Game.ItemsTxt[421].Mod2=60
Game.ItemsTxt[422].Mod2=77
Game.ItemsTxt[423].Mod2=61



------------
--tooltips
------------
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
				if (it.Bonus2 >= 4 and it.Bonus2 <= 15) or it.Bonus2 == 46 then
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
			if (it.Bonus2 >= 4 and it.Bonus2 <= 15) or it.Bonus2 == 46 then
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
			if (it.Bonus2 >= 4 and it.Bonus2 <= 15) or it.Bonus2 == 46 then
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
function events.GameInitialized2()
	itemName = {}
	itemDesc = {}
	Game.ItemsTxt[580].NotIdentifiedName="Reality Scroll"
	Game.ItemsTxt[580].Notes="The Reality Scroll is an ancient artifact of immense power, said to possess the ability to restore reality itself.\nAccording to the legend, it went long gone, stolen by Kreegans. The scroll must be brought to a special fountain created by the gods, which possesses the power to purify anything that touches its waters.\nTo activate the scroll's power, one must immerse it in the fountain's waters and recite the ancient incantation inscribed upon it. However, be warned that the ritual might summon the force of dark.\nOnly those who can pass a series of trials testing their strength, cunning, and purity of heart will be granted access to strongest relic. With the power of the Reality Scroll, one can hope to manipulate the fabric of reality and save the world from chaos."
	Game.ItemsTxt[579].NotIdentifiedName="Celestial Amulet"
	Game.ItemsTxt[579].Notes="The celestial dragon amulet is a breathtaking artifact that glimmers with otherworldly radiance. Fashioned from an otherworldly metal that is said to have been forged in the heart of a star, the amulet is adorned with intricate engravings of celestial dragons in mid-flight, their wings outstretched as if to take to the heavens themselves. Wearing this amulet is said to imbue the wielder with immense power, allowing them to channel the energies of the cosmos and bend them to their will. But the amulet's true strength lies in its ability to protect its allies. With a mere thought, the wearer can summon a shield of celestial energy that envelops their comrades, shielding them from harm and granting them the strength to fight on. It is said that only the most noble and righteous of warriors are able to wield the celestial dragon amulet, and that those who do so are blessed with the favor of the Gods themselves. ( +50 to all seven stats, protection to Death and Eradicate)"
	
	--FINAL AWARD
	Game.AwardsTxt[61]="Completed MAW in Nightmare Mode"
	Game.ItemsTxt[546].Notes="Congratulation, you were able to clear MAW at its highest difficulty!!!"
	Game.ScrollTxt[546]="To enter the Hall of Fame write me on Discord at Malekith#5670 and send me the save file to verify your run.\nDevs are proud of you" 	
		
	for i = 1, 578 do
	  itemName[i] = Game.ItemsTxt[i].Name
	end
	
	for i = 94, 99 do
	  itemDesc[i] = Game.ItemsTxt[i].Notes
	end
	
	itemName[580] = "Reality Scroll"
	itemName[579] = "Celestial Dragon Amulet"
	--fix long tooltips causing crash 
	Game.SpcItemsTxt[40].BonusStat= "Drain target Life and Increased Weapon speed."
	Game.SpcItemsTxt[41].BonusStat= " +1 to All Statistics."
	Game.SpcItemsTxt[43].BonusStat=" +10 HP and Regenerate HP over time."
	Game.SpcItemsTxt[45].BonusStat= "Adds 150-300 points of Fire damage, +25 Might."
	Game.SpcItemsTxt[46].BonusStat= " +10 Spell points and SP Regeneration."
	Game.SpcItemsTxt[49].BonusStat= " +30 Fire Resistance and HP Regeneration."	 
	Game.SpcItemsTxt[53].BonusStat=" +15 Endurance and Regenerate HP over time."
	--new tooltips
	Game.SpcItemsTxt[17].BonusStat="Disease and Curse Immunity"
	Game.SpcItemsTxt[18].BonusStat="Insanity and fear Immunity"
	Game.SpcItemsTxt[19].BonusStat="Paralysis and SP drain Immunity"
	Game.SpcItemsTxt[20].BonusStat="Poison and weakness Immunity"
	Game.SpcItemsTxt[21].BonusStat="Sleep and Unconscious Immunity"
	Game.SpcItemsTxt[22].BonusStat="Stone and premature ageing Immunity"
	Game.SpcItemsTxt[24].BonusStat="Death and eradication Immunity, +5 Levels"
end

function events.ShowItemTooltip(item)
	if item.Item.Bonus~=0 and item.Item.Bonus2~=0 and item.Item.ExtraData~=0 then
	Game.StdItemsTxt[item.Item.Bonus-1].BonusStat=string.format("%s\n%s +%s\n%s",Game.SpcItemsTxt[item.Item.Bonus2-1].BonusStat,itemStatName[item.Item.ExtraData%14+1],math.ceil(item.Item.ExtraData/14), itemStatName[item.Item.Bonus])
		else if item.Item.Bonus~=0 and item.Item.Bonus2~=0 and item.Item.ExtraData==0 then
			Game.StdItemsTxt[item.Item.Bonus-1].BonusStat=string.format("%s\n%s",Game.SpcItemsTxt[item.Item.Bonus2-1].BonusStat, itemStatName[item.Item.Bonus])
			else if item.Item.Bonus~=0 and item.Item.ExtraData~=0 and item.Item.Bonus2==0 then
				Game.StdItemsTxt[item.Item.Bonus-1].BonusStat=string.format("\n%s +%s\n%s",itemStatName[item.Item.ExtraData%14+1],math.ceil(item.Item.ExtraData/14), itemStatName[item.Item.Bonus])
				else if item.Item.Bonus~=0 and item.Item.ExtraData==0 and item.Item.Bonus2==0 then
					Game.StdItemsTxt[item.Item.Bonus-1].BonusStat=string.format("%s",itemStatName[item.Item.Bonus])
				end
			end
		end
	end
	
--Change item name
--Change item name
ancient=0
bonus=item.Item.BonusStrength
if item.Item.Bonus==8 or item.Item.Bonus==9 then
	bonus=bonus/2
end
extrabonus=math.ceil(item.Item.ExtraData/14)
if item.Item.ExtraData%14==7 or item.Item.ExtraData%14==8 then
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
	if item.Item.Number>=94 and item.Item.Number<=99 and item.Item.Charges>0 then
		local statbonus=item.Item.Charges
			if statbonus>2000 then
			statbonus="Damage and Healing"
			else if statbonus>1000 then
				statbonus="Healing"
				else statbonus="Damage"
			end
		end			
		Game.ItemsTxt[item.Item.Number].Notes=string.format("Increases spell %s by: %s%s\n\n%s",statbonus,item.Item.Charges%1000,"%",itemDesc[item.Item.Number])
		else
		Game.ItemsTxt[item.Item.Number].Notes=itemDesc[item.Item.Number]
	end
end

-----------------------------
---IMMUNITY REWORK
-----------------------------

--disease/curse
function events.DoBadThingToPlayer(t)
for it in t.Player:EnumActiveItems() do
		if it.Bonus2 == 18 then
			if t.Thing==9 or t.Thing==10 or t.Thing==11 or t.Thing==1 then
			t.Allow=false
				if t.Thing==9 or t.Thing==10 or t.Thing==11 then
				Game.ShowStatusText(string.format("Enchantment protects %s from disease",t.Player.Name))
				else 
				Game.ShowStatusText(string.format("Enchantment protects %s from curse",t.Player.Name))
				end
			end
		end
	end
end
--insanity/drainsp
function events.DoBadThingToPlayer(t)
for it in t.Player:EnumActiveItems() do
		if it.Bonus2 == 19 then
			if t.Thing==5 or t.Thing==22 then
			t.Allow=false
				if t.Thing==5 then
				Game.ShowStatusText(string.format("Enchantment protects %s from insanity",t.Player.Name))
				else 
				Game.ShowStatusText(string.format("Enchantment protects %s from spell drain",t.Player.Name))
				end

			end
		end
	end
end
--Paralysis/fear
function events.DoBadThingToPlayer(t)
for it in t.Player:EnumActiveItems() do
		if it.Bonus2 == 20 then
			if t.Thing==12 or t.Thing==23 then
			t.Allow=false
				if t.Thing==12 then
				Game.ShowStatusText(string.format("Enchantment protects %s from paralysis",t.Player.Name))
				else 
				Game.ShowStatusText(string.format("Enchantment protects %s from fear",t.Player.Name))
				end
			end
		end
	end
end
--poison/weak
function events.DoBadThingToPlayer(t)
for it in t.Player:EnumActiveItems() do
		if it.Bonus2 == 21 then
			if t.Thing==6 or t.Thing==7 or t.Thing==8 or t.Thing==2 then
			t.Allow=false
				if t.Thing==6 or t.Thing==7 or t.Thing==8 then
				Game.ShowStatusText(string.format("Enchantment protects %s from poison",t.Player.Name))
				else 
				Game.ShowStatusText(string.format("Enchantment protects %s from weakness",t.Player.Name))
				end
			end
		end
	end
end
--sleep/unconscious
function events.DoBadThingToPlayer(t)
for it in t.Player:EnumActiveItems() do
		if it.Bonus2 == 22 then
			if t.Thing==3 or t.Thing==13 then
			t.Allow=false
				if t.Thing==3 then
				Game.ShowStatusText(string.format("Enchantment protects %s from sleep",t.Player.Name))
				else 
				Game.ShowStatusText(string.format("Enchantment protects %s from unconscious",t.Player.Name))
				end
			end
		end
	end
end
--stone/age
function events.DoBadThingToPlayer(t)
for it in t.Player:EnumActiveItems() do
		if it.Bonus2 == 23 then
			if t.Thing==15 or t.Thing==21 then
			t.Allow=false
				if t.Thing==15 then
				Game.ShowStatusText(string.format("Enchantment protects %s from stone",t.Player.Name))
				else 
				Game.ShowStatusText(string.format("Enchantment protects %s from premature ageing",t.Player.Name))
				end
			end
		end
	end
end

--death/erad
function events.DoBadThingToPlayer(t)
for it in t.Player:EnumActiveItems() do
		if it.Bonus2 == 25 then
			if t.Thing==14 or t.Thing==16 then
			t.Allow=false
				if t.Thing==14 then
				Game.ShowStatusText(string.format("Enchantment protects %s from death",t.Player.Name))
				else 
				Game.ShowStatusText(string.format("Enchantment protects %s from eradication",t.Player.Name))
				end
			end
		end
	end
end



end

---------------------------------------
--NEW SCALING
---------------------------------------
if SETTINGS["255MOD"]==true then
	function events.GameInitialized2()
	--knight
	Game.Classes.HPFactor[0] = Game.Classes.HPFactor[2]
	Game.Classes.HPFactor[1] = Game.Classes.HPFactor[2]*1.5
	Game.Classes.HPFactor[2] = Game.Classes.HPFactor[2]*2
	--cleric
	Game.Classes.HPFactor[3] = Game.Classes.HPFactor[5]
	Game.Classes.HPFactor[4] = Game.Classes.HPFactor[5]*1.5
	Game.Classes.HPFactor[5] = Game.Classes.HPFactor[5]*2
	Game.Classes.SPFactor[3] = Game.Classes.SPFactor[2]
	Game.Classes.SPFactor[4] = Game.Classes.SPFactor[2]*1.5
	Game.Classes.SPFactor[5] = Game.Classes.SPFactor[2]	*2
	--sorcerer
	Game.Classes.HPFactor[6] = Game.Classes.HPFactor[8]
	Game.Classes.HPFactor[7] = Game.Classes.HPFactor[8]*1.5
	Game.Classes.HPFactor[8] = Game.Classes.HPFactor[8]*2
	Game.Classes.SPFactor[6] = Game.Classes.SPFactor[5]
	Game.Classes.SPFactor[7] = Game.Classes.SPFactor[5]*1.5
	Game.Classes.SPFactor[8] = Game.Classes.SPFactor[5]*2
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
	end
end