-- REFACTORING
-- what I did:
-- 1. removed useless quotes (table fields can be specified without [""] if they form a valid identifier (like variable name)). IMO it reads much better.
-- 2. changed set description structure (there is one table indexed by set name, and it contains item type names mapped to bonuses and item ids)
-- 3. when creating sets data, assigned item id of current item once, and then everywhere else using that value, so if ids are updated, only one place needs to be changed
-- 4. introduced one function (with cache) for getting all sets' items wear state at once - performance improvement and code size reduction
-- 5. small improvements in random item generation event handler
-- 6. used select function to get rid of multiple if statements

--sets 

-- 5 piece sets will include: armor, helm, boots, belt and gloves, sets bonuses will be at 2 and 4 pieces, 2 set has stats bonus, 4 sets has special effect
--knight set 
legendaries={}
legendaries.temper = {}
local curr = legendaries.temper
curr.armor={itemId = 600, bonus=1, strlow=20, strhigh=30, bonus2=4, bonus2low=40, bonus2high=50, bonusSpc=23, extra=0,}
curr.helm={itemId = 601, bonus=1, strlow=40, strhigh=50, bonus2=4, bonus2low=20, bonus2high=30, bonusSpc=22, extra=0}
curr.boots={itemId = 602, bonus=5, strlow=40, strhigh=50, bonus2=7, bonus2low=20, bonus2high=30, bonusSpc=21, extra=0}
curr.belt={itemId = 603, bonus=5, strlow=20, strhigh=30, bonus2=7, bonus2low=40, bonus2high=50, bonusSpc=20, extra=0}
curr.gloves={itemId = 604, bonus=6, strlow=40, strhigh=50, bonus2=10, bonus2low=20, bonus2high=30, bonusSpc=18, extra=0}

-- this one was for illustration, below not converted yet --

--sorcerer set
legendaries.newton = {}
local curr = legendaries.newton
curr.armor={itemId = 605,bonus=2, strlow=20, strhigh=30, bonus2=4, bonus2low=40, bonus2high=50, bonusSpc=23, extra=0,}
curr.helm={itemId = 606,bonus=2, strlow=40, strhigh=50, bonus2=4, bonus2low=20, bonus2high=30, bonusSpc=22, extra=0}
curr.boots={itemId = 607,bonus=7, strlow=40, strhigh=50, bonus2=10, bonus2low=20, bonus2high=30, bonusSpc=21, extra=0}
curr.belt={itemId = 608,bonus=7, strlow=20, strhigh=30, bonus2=10, bonus2low=40, bonus2high=50, bonusSpc=20, extra=0}
curr.gloves={itemId = 609,bonus=9, strlow=80, strhigh=100, bonus2=9, bonus2low=80, bonus2high=100, bonusSpc=18, extra=0}
--cleric set
legendaries.stone = {}
local curr = legendaries.stone
curr.armor={itemId = 610,bonus=3, strlow=20, strhigh=30, bonus2=4, bonus2low=40, bonus2high=50, bonusSpc=23, extra=0,}
curr.helm={itemId = 611,bonus=3, strlow=40, strhigh=50, bonus2=4, bonus2low=20, bonus2high=30, bonusSpc=22, extra=0}
curr.boots={itemId = 612,bonus=7, strlow=40, strhigh=50, bonus2=10, bonus2low=20, bonus2high=30, bonusSpc=21, extra=0}
curr.belt={itemId = 613,bonus=7, strlow=20, strhigh=30, bonus2=10, bonus2low=40, bonus2high=50, bonusSpc=20, extra=0}
curr.gloves={itemId = 614,bonus=9, strlow=80, strhigh=100, bonus2=9, bonus2low=80, bonus2high=100, bonusSpc=18, extra=0}
--paladin
legendaries.ironfist = {}
local curr = legendaries.ironfist
curr.armor={itemId = 615,bonus=1, strlow=20, strhigh=30, bonus2=4, bonus2low=40, bonus2high=50, bonusSpc=23, extra=0,}
curr.helm={itemId = 616,bonus=3, strlow=40, strhigh=50, bonus2=4, bonus2low=20, bonus2high=30, bonusSpc=22, extra=0}
curr.boots={itemId = 617,bonus=7, strlow=40, strhigh=50, bonus2=10, bonus2low=20, bonus2high=30, bonusSpc=21, extra=0}
curr.belt={itemId = 618,bonus=7, strlow=20, strhigh=30, bonus2=10, bonus2low=40, bonus2high=50, bonusSpc=20, extra=0}
curr.gloves={itemId = 619,bonus=1, strlow=40, strhigh=50, bonus2=3, bonus2low=40, bonus2high=50, bonusSpc=18, extra=0}
--archer set
legendaries.stromgard = {}
local curr = legendaries.stromgard
curr.armor={itemId = 620,bonus=1, strlow=20, strhigh=30, bonus2=4, bonus2low=40, bonus2high=50, bonusSpc=23, extra=0,}
curr.helm={itemId = 621,bonus=3, strlow=40, strhigh=50, bonus2=4, bonus2low=20, bonus2high=30, bonusSpc=22, extra=0}
curr.boots={itemId = 622,bonus=7, strlow=40, strhigh=50, bonus2=10, bonus2low=20, bonus2high=30, bonusSpc=21, extra=0}
curr.belt={itemId = 623,bonus=7, strlow=20, strhigh=30, bonus2=10, bonus2low=40, bonus2high=50, bonusSpc=20, extra=0}
curr.gloves={itemId = 624,bonus=1, strlow=30, strhigh=40, bonus2=3, bonus2low=30, bonus2high=40, bonusSpc=18, extra=0}
--druid set
legendaries.fleise = {}
local curr = legendaries.fleise
curr.armor={itemId = 625,bonus=2, strlow=20, strhigh=30, bonus2=4, bonus2low=40, bonus2high=50, bonusSpc=23, extra=0,}
curr.helm={itemId = 626,bonus=3, strlow=40, strhigh=50, bonus2=4, bonus2low=20, bonus2high=30, bonusSpc=22, extra=0}
curr.boots={itemId = 627,bonus=7, strlow=40, strhigh=50, bonus2=10, bonus2low=20, bonus2high=30, bonusSpc=21, extra=0}
curr.belt={itemId = 628,bonus=7, strlow=20, strhigh=30, bonus2=10, bonus2low=40, bonus2high=50, bonusSpc=20, extra=0}
curr.gloves={itemId = 629,bonus=2, strlow=30, strhigh=40, bonus2=3, bonus2low=30, bonus2high=40, bonusSpc=18, extra=0}

--following sets will have 2 and 3 set bonus, will include necklace, ring and cloak. First will be defensive, 2nd offensive
--set 3 for casters
legendaries.caster = {}
local curr = legendaries.caster
curr.neck={itemId = 630,bonus=2, strlow=30, strhigh=40, bonus2=8, bonus2low=80, bonus2high=100, bonusSpc=23, extra=0,}
curr.ring={itemId = 631,bonus=2, strlow=30, strhigh=40, bonus2=9, bonus2low=80, bonus2high=100, bonusSpc=22, extra=0}
curr.cloak={itemId = 632,bonus=4, strlow=30, strhigh=40, bonus2=7, bonus2low=20, bonus2high=30, bonusSpc=21, extra=0}
--set 3 for melees
legendaries.melee = {}
local curr = legendaries.melee
curr.neck={itemId = 633,bonus=1, strlow=30, strhigh=40, bonus2=8, bonus2low=80, bonus2high=100, bonusSpc=23, extra=0,}
curr.ring={itemId = 634,bonus=5, strlow=30, strhigh=40, bonus2=10, bonus2low=30, bonus2high=40, bonusSpc=22, extra=0}
curr.cloak={itemId = 635,bonus=4, strlow=30, strhigh=40, bonus2=7, bonus2low=30, bonus2high=30, bonusSpc=21, extra=0}
--set 3 for tanks
legendaries.tank = {}
local curr = legendaries.tank
curr.neck={itemId = 636,bonus=1, strlow=30, strhigh=40, bonus2=8, bonus2low=80, bonus2high=100, bonusSpc=23, extra=0,}
curr.ring={itemId = 637,bonus=4, strlow=30, strhigh=40, bonus2=10, bonus2low=80, bonus2high=100, bonusSpc=22, extra=0}
curr.cloak={itemId = 638,bonus=4, strlow=30, strhigh=40, bonus2=6, bonus2low=30, bonus2high=40, bonusSpc=21, extra=0}
--set 3 for healers
legendaries.healer = {}
local curr = legendaries.healer
curr.neck={itemId = 639,bonus=3, strlow=30, strhigh=40, bonus2=8, bonus2low=80, bonus2high=100, bonusSpc=23, extra=0,}
curr.ring={itemId = 640,bonus=3, strlow=30, strhigh=40, bonus2=9, bonus2low=80, bonus2high=100, bonusSpc=22, extra=0}
curr.cloak={itemId = 641,bonus=4, strlow=30, strhigh=40, bonus2=7, bonus2low=20, bonus2high=30, bonusSpc=21, extra=0}

local itemIdToSetData = {} -- cache
for name, setData in pairs(legendaries) do
	for itemTypeStr, itemData in pairs(setData) do
		itemIdToSetData[itemData.itemId] = {setName = name, itemTypeStr = itemTypeStr}
	end
end

local setItems = {} -- for use when generating random set item
for _, data in pairs(legendaries) do
	for typ, itemData in pairs(data) do
		table.insert(setItems, itemData)
	end
end

local function getSetsWearState(player)
	local data = {}
	for setName in pairs(legendaries) do
		data[setName] = {count = 0} -- create tables for all sets, so that indexing for example getSetsWearState().bulKathos.count > 0 won't give "indexing nil value" error
	end
	for item in player:EnumActiveItems() do
		local entry = itemIdToSetData[item.Number]
		if entry then -- is part of any set and part of current set
			local curr = data[entry.setName]
			curr[entry.itemTypeStr] = true -- mark item type as worn
			curr.count = curr.count + 1 -- increase count of equipped items
		end
	end
	return data
end

function events.ItemGenerated(t)
	local roll=math.random(1,30)
	if t.Strength>3 and t.Strength<7 and t.Strength>roll then
		--roll a legendary sets, for now the 5 sets from bul kathos
		local i=math.random(1, #setItems) -- set item index in "setItems" array
		local itemId, data = setItems[i].itemId, setItems[i] -- now get actual item id and its data
		t.Item.Number=itemId
		t.Item.Bonus=data.bonus
		t.Item.BonusStrength=math.random(data.strlow,data.strhigh)
		t.Item.Charges=math.random(data.bonus2low-1,data.bonus2high-1)*14+(data.bonus2-1)
		t.Item.Bonus2=data.bonusSpc
		t.Item.ExtraData=data.extra
	end
end

--apply stats bonuses for sets
function events.CalcStatBonusByItems(t)
--bul kathos
	local sets = getSetsWearState(t.Player)
	if t.Stat == const.Stats.HitPoints then
		local count = sets.ironfist.count
		local bonus = select(count + 1, 0, 0, 100, 200, 300, 500) -- selects appropriate bonus based on set items count
		-- if count is 0, returns second argument, if it's 1, returns third and so on
		t.Result = t.Result + bonus
	end

	-- below not done yet, above is for illustration --

--tal rasha
	if t.Stat == const.Stats.HitPoints or t.Stat == const.Stats.SpellPoints then
		set1=0
		for it in t.Player:EnumActiveItems() do
			if it.Number == 606 or it.Number == 607 or it.Number == 608 or it.Number == 609 or it.Number == 610 then
				set1=set1+1
			end
		end
		if set1>=2 then
			t.Result = t.Result + 50
		end
		if set1>=3 then
			t.Result = t.Result + 50
		end
		if set1>=4 then
			t.Result = t.Result + 50
		end
		if set1>=5 then
			t.Result = t.Result + 100
		end		
	end
end

--adjust chest coordinates
function events.GameInitialized2()
	Items.PaperdollArmorCoords[600] = {Body = {505, 95}, ArmOneHanded = {566, 95}, ArmTwoHanded = {569, 95}}
	Items.PaperdollArmorCoords[605] = {Body = {505, 95}, ArmOneHanded = {566, 95}, ArmTwoHanded = {569, 95}}
	Items.PaperdollArmorCoords[610] = {Body = {505, 95}, ArmOneHanded = {566, 95}, ArmTwoHanded = {569, 95}}
	Items.PaperdollArmorCoords[615] = {Body = {505, 95}, ArmOneHanded = {566, 95}, ArmTwoHanded = {569, 95}}
	Items.PaperdollArmorCoords[620] = {Body = {505, 95}, ArmOneHanded = {566, 95}, ArmTwoHanded = {569, 95}}
	Items.PaperdollArmorCoords[625] = {Body = {505, 95}, ArmOneHanded = {566, 95}, ArmTwoHanded = {569, 95}}
end

--adjust tooltip
setname={}
function events.ShowItemTooltip(t)
	if t.Item.Number>=600 and t.Item.Number<=641 then
		--knightset
		if t.Item.Number>=600 and t.Item.Number<=604 then
			setIndex=600
			nPieces=5
			setBonus1="2 Sets: Increase Strength by 50"
			setBonus2="4 Sets: Each kill will allow for an extra attack"
			setName="Temper's Fury"
		end
		--sorcerer set
		if t.Item.Number>=605 and t.Item.Number<=609 then
			setIndex=605
			nPieces=5
			setBonus1="2 Sets: Increase Intellect by 50"
			setBonus2="4 Sets: Spells will have a 10% chance to ignore resistances"
			setName="Newton's Lust"
		end
		--cleric set
		if t.Item.Number>=610 and t.Item.Number<=614 then
			setIndex=610
			nPieces=5
			setBonus1="2 Sets: Increase Personality by 50"
			setBonus2="4 Sets: Damage can no longer kill the user (cannot go below -50 HP)"
			setName="Stone's Vainglory"
		end
		--paladin set
		if t.Item.Number>=615 and t.Item.Number<=619 then
			setIndex=615
			nPieces=5
			setBonus1="2 Sets: Increase Might and Personality by 40"
			setBonus2="4 Sets: Each level of Magic will increase melee damage by 1\n  Each point of the highest weapon skill will increase healing by 2"
			setName="Ironfist's Wrath"
		end
		--archer set
		if t.Item.Number>=620 and t.Item.Number<=624 then
			setIndex=620
			nPieces=5
			setBonus1="2 Sets: Increase Might and Intellect by 40"
			setBonus2="4 Sets: Each level of Bow will increase spell damage by 2"
			setName="Stromgard's Sloth"
		end
		--druid set
		if t.Item.Number>=625 and t.Item.Number<=629 then
			setIndex=625
			nPieces=5
			setBonus1="2 Sets: Increase Intellect and Personality by 40"
			setBonus2="4 Sets: 20% of the lowest stat between intellect and personality will added to the highest one"
			setName="Fleise's Greed"
		end
		--------------
		--3 item sets
		--------------
		if t.Item.Number>=630 and t.Item.Number<=632 then
			setIndex=630
			nPieces=3
			setBonus1="2 Sets: Increase Intellect by 50"
			setBonus2="3 Sets: Reduce cast recovery by 10%"
			setName="Caster set"
		end
		if t.Item.Number>=633 and t.Item.Number<=635 then
			setIndex=633
			nPieces=3
			setBonus1="2 Sets: Increase Might by 50"
			setBonus2="3 Sets: Monsters below 35% health will take 20% extra damage"
			setName="Melee set"
		end
		if t.Item.Number>=636 and t.Item.Number<=638 then
			setIndex=636
			nPieces=3
			setBonus1="2 Sets: Increase Endurance by 50"
			setBonus2="3 Sets: cover chances increased by 10%"
			setName="Tank Set"
		end
		if t.Item.Number>=639 and t.Item.Number<=641 then
			setIndex=639
			nPieces=3
			setBonus1="2 Sets: Increase Personality by 50"
			setBonus2="3 Sets: increase healing up to 20% depending on missing health"
			setName="Healer Set"
		end
		
		--check for items
		for i=0,nPieces-1 do
		setname[setIndex+i]=StrColor(157,157,157,itemName[setIndex+i])
		end
		setCount=0
		local plInd=Game.CurrentPlayer
		for i=0,15 do
			item=Party[plInd]:GetActiveItem(i)
			if item then
				for i=0,4 do
					if item.Number==setIndex+i then
						setname[setIndex+i]=StrColor(255,255,102,itemName[setIndex+i])
						setCount=setCount+1
					end
				end
			end
		end
		----------------
		--5 pieces sets
		----------------
		--set bonus
		if nPieces==5 then
			if setCount>=2 then
				setBonus1=StrColor(30,255,0,setBonus1)
			else
				setBonus1=StrColor(157,157,157,setBonus1)
			end
			if setCount>=4 then
				setBonus2=StrColor(30,255,0,setBonus2)
			else
				setBonus2=StrColor(157,157,157,setBonus2)
			end
			--set name
			--adjust for tooltip
			setName=string.format("%s (%s/%s)",setName,setCount,nPieces)
			setName=StrColor(255,255,51,setName)
			Game.ItemsTxt[t.Item.Number].Notes=string.format("%s\n%s\n%s\n%s\n%s\n%s\n\n%s\n%s\n\n%s",setName,setname[setIndex],setname[setIndex+1],setname[setIndex+2],setname[setIndex+3],setname[setIndex+4],setBonus1,setBonus2,itemDesc[t.Item.Number])
			if t.Item.Bonus2>0 then
				Game.ItemsTxt[t.Item.Number].Notes=string.format("%s\n\n%s",StrColor(255,255,153,Game.SpcItemsTxt[t.Item.Bonus2-1].BonusStat),Game.ItemsTxt[t.Item.Number].Notes)
			end
		else
		----------------
		--3 piece sets
		----------------
		--set bonus
			if setCount>=2 then
				setBonus1=StrColor(30,255,0,setBonus1)
			else
				setBonus1=StrColor(157,157,157,setBonus1)
			end
			if setCount>=3 then
				setBonus2=StrColor(30,255,0,setBonus2)
			else
				setBonus2=StrColor(157,157,157,setBonus2)
			end
			--set name
			--adjust for tooltip
			setName=string.format("%s (%s/%s)",setName,setCount,nPieces)
			setName=StrColor(255,255,51,setName)
			Game.ItemsTxt[t.Item.Number].Notes=string.format("%s\n%s\n%s\n%s\n\n%s\n%s\n\n%s",setName,setname[setIndex],setname[setIndex+1],setname[setIndex+2],setBonus1,setBonus2,itemDesc[t.Item.Number])
			if t.Item.Bonus2>0 then
				Game.ItemsTxt[t.Item.Number].Notes=string.format("%s\n\n%s",StrColor(255,255,153,Game.SpcItemsTxt[t.Item.Bonus2-1].BonusStat),Game.ItemsTxt[t.Item.Number].Notes)
			end	
		end		
	end	
end
