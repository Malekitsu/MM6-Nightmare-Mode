if SETTINGS["ItemRework"]==true then
function events.GenerateItem(t)
	--get party average level
	partyExperience = 0
	
	for i = 0, 3 do
		partyExperience = partyExperience + Party.Players[i].Experience
	end
	
	averagePlayerExperience = partyExperience / 4
	
	partyLevel = math.floor((1 + math.sqrt(1 + (4 * averagePlayerExperience / 500))) / 2)
	
	--buff if item is weak
	if t.Strength*20<partyLevel then
		roll=math.random(1,t.Strength*20)
		if roll<(partyLevel-t.Strength*20) then
			t.Strength=math.min(t.Strength+1,6)
		end
		
		if partyLevel>t.Strength*20+20 then
		roll=math.random(1,t.Strength*20+20)
			if roll<(partyLevel-(t.Strength*20+20)) then
				t.Strength=math.min(t.Strength+1,6)
			end	
		end
	end
	--nerf if item is strong
	if partyLevel<(t.Strength-3)*20 and t.Strength<7 then
		t.Strength=t.Strength-1
	end
	if (t.Strength-1)*20>partyLevel and t.Strength>2 and t.Strength<7 then
		roll=math.random((t.Strength-3)*20,(t.Strength-2)*20)
		if roll>partyLevel then
			t.Strength=t.Strength-1
		end
	end
end

function events.ItemGenerated(t)	
	if t.Item.Number<=134 then

		
		
		--give bonus a chance to proc even if bonus2 is already in the item
		if t.Item.Bonus2~=0 then
		bonusprocChance=math.random(1,100)
			if bonusprocChance<=40 and t.Strength~=1 or (t.Strength==6 and bonusprocChance<=75) then
				t.Item.Bonus = math.random(1,14)
				local bonuses = {{1, 5}, {3, 8}, {6, 12}, {10, 17}, {15, 25}}
				local bonus = bonuses[t.Strength - 1]
				t.Item.BonusStrength = math.random(bonus[1], bonus[2])
			end
		end
		--extra bonus proc
		extraBonusChance={0,20,25,30,40,50}
		extraBonusPowerLow={0,1,3,6,10,15}
		extraBonusPowerHigh={0,5,8,12,17,25}
		extraDataProc=math.random(1,100)
		if extraDataProc<=extraBonusChance[t.Strength] then
			lowerLimit=t.Strength
			t.Item.ExtraData = math.random(14 * extraBonusPowerLow[t.Strength]-13, 14 * extraBonusPowerHigh[t.Strength])
			--make it standard bonus if no standard bonus
			if t.Item.Bonus==0 then
				t.Item.Bonus=t.Item.ExtraData%14
				t.Item.BonusStrength=math.ceil(t.Item.ExtraData/14)
				t.Item.ExtraData=0
			end
		end
		
		--of x spell proc chance
		if t.Item.Number>=120 and t.Item.Number<=134 and t.Item.Bonus2~=0 and t.Strength < 6 then
			roll=math.random(1,100)
			if roll<(t.Strength-1)*10 then
				t.Item.Bonus2=math.random(26,34)
			end
		end
		
		--chance for ancient item, only if bonus 2 is spawned
		if t.Item.Bonus2~=0 then 
			ancient=math.random(1,50)
			if ancient<=t.Strength-3 then
				t.Item.ExtraData=math.random(364,560)
				t.Item.Bonus=math.random(1,14)
				t.Item.BonusStrength=math.random(26,40)
			end
		end
		
		--primordial item
		primordial=math.random(1,200)
		if primordial<=t.Strength-4 then
			t.Item.ExtraData=math.random(547,560)
			t.Item.Bonus=math.random(1,14)
			t.Item.BonusStrength=40
			if t.Item.Number>60 then
				t.Item.Bonus2=math.random(1,2)
				else
				t.Item.Bonus2=41
			end
		end	
		--buff to hp and mana items
		if t.Item.Bonus==8 or t.Item.Bonus==9 then
			t.Item.BonusStrength=t.Item.BonusStrength*2
		end
		if t.Item.ExtraData%14==7 or t.Item.ExtraData%14==8 then
			t.Item.ExtraData=t.Item.ExtraData+14*math.ceil(t.Item.ExtraData/14)
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
----------------------
--weapon rework
----------------------
function events.GameInitialized2()
--2h dice bonus
for i = 6, 8 do
	Game.ItemsTxt[i].Mod1DiceSides = Game.ItemsTxt[i].Mod1DiceSides^(2^(1*Game.ItemsTxt[i].Mod2/13))
end
for i = 28, 41 do
	Game.ItemsTxt[i].Mod1DiceSides = Game.ItemsTxt[i].Mod1DiceSides^(2^(1*Game.ItemsTxt[i].Mod2/13))
end

--2h artifacts bonus
Game.ItemsTxt[402].Mod1DiceSides = Game.ItemsTxt[402].Mod1DiceSides^(2^(1*Game.ItemsTxt[402].Mod2/13))
Game.ItemsTxt[417].Mod1DiceSides = Game.ItemsTxt[417].Mod1DiceSides^(2^(1*Game.ItemsTxt[417].Mod2/13))
Game.ItemsTxt[419].Mod1DiceSides = Game.ItemsTxt[419].Mod1DiceSides^(2^(1*Game.ItemsTxt[419].Mod2/13))

--weapon bonus
for i = 1, 63 do
	Game.ItemsTxt[i].Mod2=Game.ItemsTxt[i].Mod2^1.4
end

for i = 400, 405 do
	Game.ItemsTxt[i].Mod2=Game.ItemsTxt[i].Mod2^1.4
end

for i = 415, 420 do
	Game.ItemsTxt[i].Mod2=Game.ItemsTxt[i].Mod2^1.4
end

------------
--tooltips
------------
Game.SpcItemsTxt[3].BonusStat="Adds 9-12 points of Cold damage."
Game.SpcItemsTxt[4].BonusStat="Adds 18-24 points of Cold damage."
Game.SpcItemsTxt[5].BonusStat="Adds 27-36 points of Cold damage."
Game.SpcItemsTxt[6].BonusStat="Adds 6-15 points of Electrical damage."
Game.SpcItemsTxt[7].BonusStat="Adds 12-30 points of Electrical damage."
Game.SpcItemsTxt[8].BonusStat="Adds 18-45 points of Electrical damage."
Game.SpcItemsTxt[9].BonusStat="Adds 3-18 points of Fire damage."
Game.SpcItemsTxt[10].BonusStat="Adds 6-36 points of Fire damage."
Game.SpcItemsTxt[11].BonusStat="Adds 9-54 points of Fire damage."
Game.SpcItemsTxt[12].BonusStat="Adds 15 points of Poison damage."
Game.SpcItemsTxt[13].BonusStat="Adds 24 points of Poison damage."
Game.SpcItemsTxt[14].BonusStat="Adds 36 points of Poison damage."

end

--ENCHANTS HERE

function events.CalcDamageToMonster(t)
local data = WhoHitMonster()
	if data.Player and t.DamageKind~=0 and data.Object==nil then
		for it in data.Player:EnumActiveItems() do
			if t.DamageKind==2 then
				fix=math.random(0,math.round(t.Result))
				t.Result=t.Result-(fix*0.875)
			end
			if it.Bonus2 >= 4 and it.Bonus2 <= 15 or it.Bonus2 == 46 then
				t.Result = t.Result * 3	
				break
			end
			--rough fix for bugged enchant

		end		
	end	
end



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

	for i = 1, 580 do
	  itemName[i] = Game.ItemsTxt[i].Name
	end
	--fix long tooltips causing crash 
	Game.SpcItemsTxt[40].BonusStat= "Drain target Life and Increased Weapon speed."
	Game.SpcItemsTxt[41].BonusStat= " +1 to All Statistics."
	Game.SpcItemsTxt[45].BonusStat= "Adds 30-60 points of Fire damage, +25 Might."
	Game.SpcItemsTxt[46].BonusStat= " +10 Spell points and SP Regeneration."
	Game.SpcItemsTxt[49].BonusStat= " +30 Fire Resistance and HP Regeneration."	 
	Game.SpcItemsTxt[53].BonusStat=" +15 Endurance and Regenerate HP over time."
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
ancient=0
if (item.Item.BonusStrength>25 and item.Item.Bonus~=8 and item.Item.Bonus~=9) or (item.Item.BonusStrength>50 and (item.Item.Bonus==8 or item.Item.Bonus==9)) then
	Game.ItemsTxt[item.Item.Number].Name=string.format("%s %s","Ancient", itemName[item.Item.Number])
	else 
	Game.ItemsTxt[item.Item.Number].Name=string.format("%s", itemName[item.Item.Number])
end

if (item.Item.BonusStrength==40 and (item.Item.Bonus<8 or item.Item.Bonus>9) or item.Item.BonusStrength==80 and (item.Item.Bonus==8 or item.Item.Bonus==9)) and ((item.Item.ExtraData%14==7 or item.Item.ExtraData%14==8) and math.ceil(item.Item.ExtraData/14)==80) or (math.ceil(item.Item.ExtraData/14)==40 and (item.Item.ExtraData%14~=7 or item.Item.ExtraData%14~=8)) then
	Game.ItemsTxt[item.Item.Number].Name=string.format("%s %s","Primordial", itemName[item.Item.Number])
	end

end


end

-- some spare code, just in case
--[[
function AfterShowItemTooltip()
  debug.Message(dump(t))
end]]
