local u1, u2, u4, i1, i2, i4 = mem.u1, mem.u2, mem.u4, mem.i1, mem.i2, mem.i4
local hook, autohook, autohook2, asmpatch = mem.hook, mem.autohook, mem.autohook2, mem.asmpatch
local StaticAlloc = mem.StaticAlloc
local max, min, floor, ceil, round, random = math.max, math.min, math.floor, math.ceil, math.round, math.random
local format = string.format

local mmver = offsets.MMVersion
function mmv(...)
	local r = select(mmver - 5, ...)
	assert(r ~= nil)
	return r
end

if mmver ~= 6 then return end

Items = Items or {} -- global containing item tools

-- HELP --

---------------------
------ GENERAL ------
---------------------

-- Items.CanItemBeRandomlyFound decides, well, whether the item can be found :) It's indexed by item id. When you set false, item can't be generated randomly no matter what. Custom items are set to true by default (if they have nonzero rnditems.txt chances).

-- rnditems.txt file is slightly changed. You can add rows corresponding to any item defined in items.txt (but you don't need to fill in all rows, unfilled ones will simply be zeroed). You don't need to update total chance sums when changing specific items, they are only informational (it was like that in vanilla).

-- Items.RndItemsChanceSums allows you to modify column sums from rnditems.txt. You don't need to do it though, I have done so that changing ChanceByLevel field or fields like "Arm", "Shld" etc. will automatically change corresponding chances.

-- like above, there's also Items.StdBonusChanceSums and Items.SpcBonusChanceSums. You don't need to modify them either.

-- Items.StdBonusStrengthRanges allows you to change default bonuses power. Table is indexed first by treasure level (1-6) and then by either "Min" or "Max", or by aliases defined below. When you simply index it, you get current value. When you assign to it, that range bound is modified (note that no checks are made for invalid ranges, they might crash the game). You can also assign an array with two fields (either to "MinMax" key or directly to table) to set both range ends at once.
-- examples:
--[[
    local range = Items.StdBonusStrengthRanges[2]
    -- supported low end indexes: range[0], range.Min, range.Low
    -- supported high end indexes: range[1], range.Max, range.High
    -- supported full range indexes: range[2] (only for assignment, returns table without data), range.LowHigh, range.MinMax, range.Range, range.Full
    Items.StdBonusStrengthRanges[2] = {3, 4}
    Items.StdBonusStrengthRanges[5].LowHigh = {3, 4}
    local ranges = Items.StdBonusStrengthRanges

    local low, high = unpack(ranges[3].MinMax)
    -- warning: assigning new values to returned table won't work, you need to use this instead:
    ranges[3].MinMax = {low + 1, high + 5}
    ranges[4].Low = math.max(20, ranges[4].Low) -- note: range might become invalid without adjusting upper end
    ranges[4].Max = ranges[4].Low -- now it should be ok
    local low = ranges[2][0]
    ranges[3].Range = {low + 5, low + 15}
]]

-- new event: GetItemName
-- parameters:
    -- IdentifiedNameOnly -> if true, means that function should only set full item names (when item is identified). If false, vanilla logic expects that you'll provide unidentified name if item is not identified (it's not binding though).
    -- Item -> item whose name is being obtained,
    -- Name -> default name from vanilla code

-- example:
--[[
    function events.GetItemName(t)
        if t.Item:T().EquipStat == const.ItemType.Potion - 1 then
            t.Name = t.Item:T().Name
        end
    end
]]

-- new event: GenerateArtifact(t)
-- parameters:
--     Item -> item being generated (in this event it's really just space assigned for item, will be overwritten)
--     Allow -> if you set this to false, item won't be generated
-- new event: ArtifactGenerated(t) [called only if previous event sets (or leaves) "Allow = true"]
-- parameters:
--      Item -> carried over from previous event, contains generated item data
--      Allow -> carried over
--      GenerationSuccessful -> is true if vanilla code managed to generate an artifact

---------------------
------ ALCHEMY ------
---------------------

-- Items.IsItemMixable is an array of booleans indexed by item id. Value indicates whether item with given id is mixable (activates potion mixing code).
-- Items.IsItemPotionBottle (format same as above) determines if item is a potion bottle. Items which are true there will be changed into basic empty bottle (item id 163) on any potion mix attempt. No, I don't know why there are multiple potion bottles.
-- Items.IsItemPotion determines whether item is a potion. It's not used by vanilla, I use it for determining whether item can have "power" (bonus field) displayed

-- new event: MixPotion(t)
-- parameters:
--     Result -> item id of result potion. If 0, vanilla code runs and selects new item id. If false, mix cannot be performed (item tooltip is shown)
--     ClickedPower -> power ("Bonus" field) of clicked potion
--     MousePower -> power of mouse potion,
--     ClickedPotion -> rightclicked item,
--     MousePotion -> mouse item,
--     Player -> player doing the mixing,
--     Handled -> If it's true, nothing is done at all, (mouse item is not removed, item tooltip is not shown, it's as if you didn't rightclick),
--     ResultPower -> power of result potion (0 by default),
--     Explosion -> if it's nonzero, makes mix attempt result in explosion with specified power (range of powers: [1-4])
--     CheckCombination(id1, id2) -> utility function. Returns true if one of mouse or rightclicked potions has first id, and another one has second id, no matter which potion is held by mouse.

-- example:
--[=[
    local superResistance, magicPotion, divinePower, protection, curePoison, resistance = 173, 165, 178, 167, 169, 168
    local pots = {173, 165, 178, 167, 169, 168}
    for i, pot in ipairs(pots) do
        for j = 1, 5 do
            evt.GiveItem{Id = pot}
        end
    end
    function events.MixPotion(t)
        local idMouse, idClicked = t.MousePotion.Number, t.ClickedPotion.Number
        if idMouse == superResistance then
            t.Result = magicPotion
            t.ResultPower = random(5, 24)
        elseif idMouse == magicPotion and idClicked == magicPotion then
            t.Result = divinePower
            t.ResultPower = random(100, 200)
        elseif t.CheckCombination(protection, curePoison) then
            t.Result = math.random(2) == 1 and divinePower or resistance
            t.ResultPower = 0
        elseif t.CheckCombination(magicPotion, protection) then
            t.Explosion = 4
        elseif t.CheckCombination(curePoison, magicPotion) then
            t.Result = false -- cannot mix
        elseif t.CheckCombination(curePoison, curePoison) then
            t.Handled = true -- do nothing at all
        end
    end
]=]

-- new event: DrinkPotion(t)
-- parameters:
--     CannotDrink -> If this is true: message "item cannot be used that way" is displayed and item is not consumed. TODO: allow changing message
--     Handled -> If this is true: don't run vanilla potion logic, but make drink sound, add recovery and remove mouse item. Otherwise, if it's false, full vanilla code runs (in addition to your handler)
--     Player -> drinking player,
--     Potion -> the item being drunk. Note: as of now called only for items whose EquipStat is "Bottle", "Herb" uses other code
--     MakeFaceAnimation() -> makes drinking face animation.

-- NEW ITEM BITMAPS --

-- new bitmaps for belts/helmets/armors (other items need only those used in inventory) are loaded automatically, but they need to have fixed naming scheme:
--     for armors: let base name be "MyPlate". Then file name of inventory bitmaps and items.txt picture should be "MyPlateicon", main worn armor part should be "MyPlatebod", 1st arm "MyPlatearm1", 2nd arm "MyPlatearm2".
--     for belts: if base name is "MyBelt1" (it needs to end with a number), inventory icon should be "MyBelt1a", and belt on paperdoll should have file name "MyBelt1b"
--     for helmets:
--         actual helmets: if base name is "helm1", then inventory sprite must be named "hlm1" (without the "e"), and paperdoll sprite "helm1" (with the "e")
--         hats: if base name is "hat1", then inventory sprite must be named like that, and character sprite "hat1b"
--         crowns: if base name is "crown1", then inventory sprite must be named like that, and character sprite "crown1b" (same as hats except for prefix)

-- Items.PaperdollArmorCoords - this table allows you setting custom armor coordinates. It has three "layers": 
--     1. First layer is indexed by item id. You get back a table...
--     2. Which can be indexed with either "Body" or 1, "ArmOneHanded" or 2, and "ArmTwoHanded" or 3 to get setter/getter table for coords of specific armor body part. The new table...
--     3. Can be indexed with X or 1, Y or 2, and XY or 3. If you simply index, you get current value (as number in first two cases, as table in third). When you assign to it, expected input is the same. New items using existing pictures (armors/belt/helms from original game) will have coords filled in automatically, custom ones must be supplied manually.

-- when you want to assign coords, you can assign a two-layered table to specific item id and it'll work just fine. See below for example. If you do it, parts having already good coords can be skipped.

-- once you assign any coords to an item, it will use those coords. To restore vanilla coords (only for vanilla items, others will crash!), execute function Items.PaperdollArmorCoords.ClearCustomCoords(itemId)

--[[
    example usage:
    local goldenPlateId = 78
    local coords = Items.PaperdollArmorCoords
    local plate = coords[goldenPlateId]
    local x, y = unpack(plate.Body.XY)
    -- or:
    ---- local x = plate.Body.X
    ---- local y = plate.Body.Y
    coords[goldenPlateId] = { -- this WOULDN'T work: "plate = {...}", you need to assign key to table directly
        Body = {X = 50, Y = 30},
        ArmOneHanded = {x, Y = 30} -- can mix key types
        ArmTwoHanded = {20, 20}
    }
    local coords2 = coords[72]
    coords2.Body.XY = coords2.Body.X + 20, coords2.Body.Y + 50
    coords2.ArmTwoHanded[1] = 88 -- same as X
    coords2.ArmOneHanded[2] = plate.Body.Y -- same as Y
]]

-- HELP END --

-- TODO: de-hardcoding artifacts, wands, scrolls, basically any item group that has special behavior

local function callWhenGameInitialized(f, ...)
    if GameInitialized2 then
        f(...)
    else
        local args = {...}
        events.GameInitialized2 = function() f(unpack(args)) end
    end
end

local function GetPlayer(ptr)
    return Party[(ptr - Party[0]["?ptr"]) / Party[0]["?size"]]
end

local function checkIndex(index, minIndex, maxIndex, level, formatStr)
    if index < minIndex or index > maxIndex then
        error(format(formatStr or "Index (%d) out of bounds [%d, %d]", index, minIndex, maxIndex), level + 1)
    end
end

local function makeMemoryTogglerTable(t)
    local arr, buf, minIndex, maxIndex = t.arr, t.buf, t.minIndex, t.maxIndex
    local bool, errorFormat, size, minValue, maxValue = t.bool, t.errorFormat, t.size, t.minValue, t.maxValue
    local aliases = t.aliases or {} -- string aliases for some indexes
    local mt = {__index = function(_, i)
        i = aliases[i] or i 
        checkIndex(i, minIndex, maxIndex, 2, errorFormat)
        local off = buf + (i - minIndex) * size
        if bool then
            return arr[off] ~= 0
        else
            return arr[off]
        end
    end,
    __newindex = function (_, i, val)
        i = aliases[i] or i
        checkIndex(i, minIndex, maxIndex, 2, errorFormat)
        local off = buf + (i - minIndex) * size
        if bool then
            arr[off] = val and val ~= 0 and 1 or 0
        else
            local smaller, greater = val < (minValue or val), val > (maxValue or val)
            if smaller or greater then
                local str
                if smaller then
                    str = format("New value (%d) is smaller than minimum possible value (%d)", val, minValue)
                elseif greater then
                    str = format("New value (%d) is greater than maximum possible value (%d)", val, maxValue)
                end
                error(str, 2)
            end
            arr[off] = val
        end
    end}
    return setmetatable({}, mt)
end

--[[
    REMOVE LIMITS WORKFLOW:
    1) generate table offsets data to facilitate finding references
    2) find all references which are findable by search (incl. size, limit, high, count, relative)
    3) patch each place where files are loaded, allocating space for data, asmpatching some addresses to use new data, and replace all references with function call
    4) take care of various stuff related to specific tables (like, for items, patch function drawing paperdolls, patch alchemy so newly added potions will work etc.)
    5) test and fix all bugs you can find
]]

local function getSlot(player)
    for i, pl in Party do
        if pl == player then
            return i
        end
    end
end

local function getSpellQueueData(spellQueuePtr, targetPtr)
	local t = {Spell = i2[spellQueuePtr], Caster = Party.PlayersArray[i2[spellQueuePtr + 2]]}
	t.SpellSchool = ceil(t.Spell / 11)
	local flags = u2[spellQueuePtr + 8]
	if flags:And(0x10) ~= 0 then -- caster is target
		t.Caster = Party[i2[spellQueuePtr + 4]]
	end
    t.CasterIndex = getSlot(t.Caster)

	if flags:And(1) ~= 0 then
		t.FromScroll = true
		t.Skill, t.Mastery = SplitSkill(u2[spellQueuePtr + 0xA])
	else
		if mmver > 6 then
			t.Skill, t.Mastery = SplitSkill(t.Caster:GetSkill(const.Skills.Fire + t.SpellSchool - 1))
		else -- no GetSkill
			t.Skill, t.Mastery = SplitSkill(t.Caster.Skills[const.Skills.Fire + t.SpellSchool - 1])
		end
	end

	local targetIdKey = mmv("TargetIndex", "TargetIndex", "TargetRosterId")
	if targetPtr then
		if type(targetPtr) == "number" then
			t[targetIdKey], t.Target = internal.GetPlayer(targetPtr)
		else
			t[targetIdKey], t.Target = targetPtr:GetIndex(), targetPtr
		end
	else
		local pl = Party[i2[spellQueuePtr + 4]]
		t[targetIdKey], t.Target = pl:GetIndex(), pl
	end
	return t
end

function testItemGeneration()
    local item = Mouse.Item
    for _, itemType in pairs(const.ItemType) do
        for treasureLevel = 1, 6 do
            for cnt = 1, 1000 do
                item:Randomize(treasureLevel, itemType)
            end
        end
    end
end

local function tryGetItem(lev, field, wantedFieldVal, typ, itemId)
    --local typ = Game.ItemsTxt[id].EquipStat + 1
    local item = Mouse.Item
    for c = 1, 10000 do
        local useLev = lev or random(1, 6)
        item:Randomize(useLev, typ or 0)
        local hasWantedField
        if wantedFieldVal ~= nil then
            hasWantedField = item[field] == wantedFieldVal
        else
            hasWantedField = true
        end
        local hasItemId
        if itemId then
            hasItemId = (item.Number == itemId)
        else
            hasItemId = true
        end
        if hasWantedField and hasItemId then
            print(true, useLev, c)
            return
        end
    end
    print(false)
end

function tryGetMouseItem(id, lev, typ)
    return tryGetItem(lev, nil, nil, typ, id)
end
function tryGetStdBonus(bonus, lev, typ, id)
    return tryGetItem(lev, "Bonus", bonus, typ, id)
end
function tryGetSpcBonus(bonus, lev, typ, id)
    return tryGetItem(lev, "Bonus2", bonus, typ, id)
end

function arrayFieldOffsetName(arr, offset)
    if offset >= arr["?ptr"] then
        offset = offset - arr["?ptr"]
    end
    if offset < 0 then
        offset = offset + arr.ItemSize
    end
	local i = offset:div(arr.ItemSize)
	local off = offset % arr.ItemSize
    local minDiffBelow, minDiffBelowName
	for k, v in pairs(structs.o[structs.name(arr[0])]) do
		if v == off then
			return k
        elseif not minDiffBelow or off - v < minDiffBelow then
            minDiffBelow = off - v
            minDiffBelowName = k
        end
	end
    return minDiffBelowName, true
end

local arrs = {"ItemsTxt", "StdItemsTxt", "SpcItemsTxt", "PotionTxt", "ScrollTxt"}
local arrPtrs = {}
for i, v in ipairs(arrs) do
	arrPtrs[i] = Game[v]["?ptr"]
end
local npcDataPtr = Game.NPCDataTxt["?ptr"]
function npcArrayFieldOffsetName(offset)
	for i, v in ipairs(arrs) do
		local dataOffset = arrPtrs[i] - npcDataPtr
		local nextOffset = (i ~= #arrs and (arrPtrs[i + 1] - npcDataPtr) or 0)
		if offset >= dataOffset and offset <= nextOffset then
			print(v)
			arrayFieldOffsetName(Game[v], offset - dataOffset)
			return
		end
	end
	print("Couldn't find NPC array for given offset")
end

local itemsTxtRawAddresses = {
    0x40FEE0, 0x40FF00, 0x410FF2, 0x4123DC, 0x4123E2, 0x4123E9, 0x412497, 0x41249E, 0x412657, 0x41265E, 0x412708, 0x41270F, 0x41271D, 0x41289C, 0x4128A5, 0x41292F, 0x412936, 0x4129BC, 0x4129C3, 0x4129CA, 0x412A43, 0x412A4C, 0x412B14, 0x412B1D, 0x412C20, 0x412C30, 0x412C37, 0x412CA1, 0x412E58, 0x412F10, 0x412FAA, 0x4166A0, 0x41C4F2, 0x41C4FA, 0x41C57D, 0x41CB34, 0x41DECB, 0x41E0D6, 0x41E288, 0x41EB7A, 0x41ECF9, 0x41F11F, 0x41FE88, 0x41FFA4, 0x420569, 0x4205B0, 0x4206A8, 0x4207D0, 0x4207FC, 0x4208E1, 0x421700, 0x4217E5, 0x4218DB, 0x4218EE, 0x42558B, 0x425592, 0x4256AB, 0x4256C5, 0x4256CE, 0x4256EC, 0x4256F7, 0x425763, 0x4257BE, 0x425801, 0x42584F, 0x425964, 0x42597E, 0x425987, 0x4259A5, 0x4259B0, 0x425A1C, 0x425A77, 0x425ABA, 0x425B08, 0x425C07, 0x425C21, 0x425C2A, 0x425C48, 0x425C53, 0x427BAC, 0x427BDD, 0x429FAB, 0x42A396, 0x42AAF5, 0x42AB01, 0x42C706, 0x431CA0, 0x43E050, 0x44861A, 0x448670, 0x44868D, 0x448696, 0x4486B8, 0x44870B, 0x448B46, 0x448BD2, 0x44A089, 0x44A09A, 0x44C2F0, 0x44F0D6, 0x450D39, 0x4528BD, 0x452970, 0x4532B2, 0x453800, 0x454290, 0x454B62, 0x45609A, 0x456192, 0x4561B0, 0x45625A, 0x4564F2, 0x45664C, 0x457C66, 0x458A2D, 0x458B53, 0x458F91, 0x45907B, 0x45997F, 0x45A040, 0x45A063, 0x45A06D, 0x45A967, 0x45BB89, 0x45BD12, 0x46CC95, 0x47D697, 0x47D6EA, 0x47E462, 0x47E468, 0x47E47E, 0x47E4A8, 0x47E501, 0x47E578, 0x47E589, 0x47E58F, 0x47E5C2, 0x47E625, 0x47EB11, 0x47EB17, 0x47EB36, 0x480BEF, 0x480C60, 0x480CB9, 0x480CBF, 0x481AF4, 0x481AFB, 0x481B4A, 0x481B51, 0x481B9C, 0x481BC0, 0x481BFB, 0x481C60, 0x481C72, 0x482EEC, 0x482F00, 0x482F06, 0x4833A6, 0x4833B0, 0x4833EC, 0x4833FB, 0x483439, 0x483445, 0x48344B, 0x483453, 0x48349F, 0x4834AF, 0x4834B5, 0x4834F7, 0x4834FF, 0x483514, 0x48351D, 0x483529, 0x48352F, 0x48353A, 0x483578, 0x483588, 0x48358E, 0x48359A, 0x4835E5, 0x48362A, 0x483630, 0x48366E, 0x483674, 0x48367F, 0x483A2A, 0x483A34, 0x483B11, 0x483B1B, 0x483B87, 0x483B91, 0x483C16, 0x483C98, 0x48513F, 0x485164, 0x4857C2, 0x485826, 0x48588F, 0x4858F8, 0x485961, 0x4859B8, 0x485A0F, 0x485A66, 0x485ABD, 0x485B14, 0x485B6B, 0x485BC2, 0x486CFF, 0x486E43, 0x486F37, 0x4870E4, 0x4872B2, 0x48B2F3, 0x496E9E, 0x49758B, 0x49FCDD, 0x49FEDD, 0x4A4434, 0x4A46E6, 0x4A47F6, 0x4A499A, 0x4A4C42, 0x4A4C85,
}

function processRawAddresses(arrayName)
    -- 1. command size
    -- 2. array offset and field name
    
    -- only processes direct references - count, limit, size still need to be done manually
    local results = {}
    local arr = Game[arrayName]
    local lower, upper = arr["?ptr"] - arr.ItemSize, arr["?ptr"] + arr.Size + arr.ItemSize
    for i, addr in ipairs(itemsTxtRawAddresses) do
        local len = mem.GetInstructionSize(addr)
        if len < 5 then -- minimum size
            error(format("Address 0x%X has instruction size less than 5", addr))
        end
        -- find command size and if there are instruction bytes after memory offsets
        local cmdSize, hasFreeBytes
        for i = 0, len - 4 do
            local val = u4[addr + i]
            if val >= lower and val <= upper then -- found
                if cmdSize then -- found twice
                    error(format("Address 0x%X has two valid references to array", addr))
                end
                cmdSize = i
                hasFreeBytes = (i + 4 ~= len)
            end
        end
        if not cmdSize then
            error(format("No array reference found at address 0x%X", addr))
        end
        local name, notBeginning = arrayFieldOffsetName(arr, u4[addr + cmdSize])
        if not name then
            error(format("Couldn't find structure field for reference at address 0x%X", addr))
        end
        print(format("Address 0x%X, cmdSize %d, references 0x%X, field name %q (%s)",
            addr, cmdSize, u4[addr + cmdSize], name, notBeginning and "NB" or "B"))
        
        table.insert(results, {address = addr, cmdSize = cmdSize, reference = u4[addr + cmdSize], fieldName = name, notFieldBeginning = notBeginning, hasFreeBytes = hasFreeBytes})
    end
    local output = {}
    local ptr = arr["?ptr"]
    local justBeforeEnd = ptr + arr.Size - arr.ItemSize
    for _, data in ipairs(results) do
        if data.address == ptr + arr.ItemSize then -- end reference?
            table.insert(tget(output, "End"), data.address)
        elseif data.notFieldBeginning then
            table.insert(tget(output, "verify"), data.address)
        else
            if data.address >= justBeforeEnd then
                table.insert(tget(output, data.cmdSize), {addr = data.address, verifyMe = true})
            else
                table.insert(tget(output, data.cmdSize), data.address)
            end
        end
    end
    local text = dump(output, nil, true):gsub("%d+", function(num) return format("0x%X", num) end)
    --print(text)
end

function printSortedArraysData(arrs, dataOrigin)
    arrs = arrs or {"ItemsTxt", "StdItemsTxt", "SpcItemsTxt", "PotionTxt", "ScrollTxt"}
    dataOrigin = dataOrigin or Game.ItemsTxt["?ptr"] - 4
    local out = {}
    for k, name in pairs(arrs) do
        local s = Game[name]
        local low, high, size, itemSize, dataOffset = s["?ptr"], s["?ptr"] + s.Limit * s.ItemSize, s.Size, s.ItemSize, s["?ptr"] - dataOrigin
        table.insert(out, {name = name, low = low, high = high, size = size, itemSize = itemSize, dataOffset = dataOffset})
    end
    table.sort(out, function(a, b) return a.low < b.low end)
    for _, data in ipairs(out) do
        print(format("%-15s %-17s %-17s %-17s %-17s %-17s",
            data.name .. ":",
            format("low = 0x%X", data.low),
            format("high = 0x%X", data.high),
            format("size = 0x%X", data.size),
            format("itemSize = 0x%X", data.itemSize), 
            format("dataOffset = 0x%X", data.dataOffset)
        ))
    end
end

function replacePtrs(t) -- addrTable, newAddr, origin, cmdSize, check)
    local func = t.func
    local arr = t.arr or u4
	for i, oldAddr in ipairs(t.addrTable) do
        local arr, oldAddr = arr, oldAddr
        if type(oldAddr) == "table" then
            arr = oldAddr.arr
            oldAddr = oldAddr[1]
        end
		local old = arr[oldAddr + t.cmdSize]
        local new
        if func then
            new = func(old)
        else
		    new = t.newAddr - (t.origin - old)
        end
		t.check(old, new, t.cmdSize, i)
		arr[oldAddr + t.cmdSize] = new
	end
end

local function processReferencesTable(args)
    local arrName, newAddress, newCount, addressTable, lenP = args.arrName, args.newAddress, args.newCount, args.addressTable, args.lenP
    local oldRelativeBegin, newRelativeBegin = args.oldRelativeBegin, args.newRelativeBegin
    local arr = Game[arrName]
    local origin = arr["?ptr"]
    local lowerBoundIncrease = (addressTable.lowerBoundIncrease or 0) * arr.ItemSize
    addressTable.lowerBoundIncrease = nil -- eliminate special case in loop below
    local oldMin, oldMax = origin - arr.ItemSize - lowerBoundIncrease, origin + (arr.Limit + 1) * arr.ItemSize
    local newMin, newMax = newAddress - arr.ItemSize - lowerBoundIncrease, newAddress + arr.ItemSize * (newCount + 1)
    local function check(old, new, cmdSize, i)
        assert(old >= oldMin and old <= oldMax, format("[%s] old address 0x%X [cmdSize %d; array index %d] is outside array bounds [0x%X, 0x%X] (new entry count: %d)", arrName, old, cmdSize, i, oldMin, oldMax, newCount))
        assert(new >= newMin and new <= newMax, format("[%s] new address 0x%X [cmdSize %d; array index %d] is outside array bounds [0x%X, 0x%X] (new entry count: %d)", arrName, new, cmdSize, i, newMin, newMax, newCount))
    end
    mem.prot(true)
    for cmdSize, addresses in pairs(addressTable) do
        if type(cmdSize) == "number" then
            -- normal refs
            replacePtrs{addrTable = addresses, newAddr = newAddress, origin = origin, cmdSize = cmdSize, check = check}
        else
            -- special refs
            local what = cmdSize
            local memArr = addresses.arr or i4
            for cmdSize, addresses in pairs(addresses) do
                if what == "relative" then
                    local function checkRelative(old, new, cmdSize, i)
                        check(old + oldRelativeBegin, new + newRelativeBegin, cmdSize, i)
                    end
                    replacePtrs{addrTable = addresses, newAddr = newAddress - assert(newRelativeBegin), origin = origin - assert(oldRelativeBegin),
                        cmdSize = cmdSize, check = checkRelative}
                else
                    for i, data in ipairs(addresses) do
                        -- support per-address mem array types
                        local memArr, addr = memArr -- intentionally override local
                        if type(data) == "table" then
                            memArr = data.arr or memArr
                            addr = data[1]
                        else
                            addr = data
                        end
                        if what == "limit" then
                            memArr[addr + cmdSize] = memArr[addr + cmdSize] - arr.Limit + newCount
                        elseif what == "count" then
                            -- skip (I don't move count addresses atm)
                        elseif what == "high" then
                            memArr[addr + cmdSize] = newCount - 1
                        elseif what == "size" then
                            memArr[addr + cmdSize] = arr.ItemSize * newCount
                        elseif what == "End" then
                            memArr[addr + cmdSize] = newAddress + arr.ItemSize * newCount
                        end
                    end
                end
            end
        end
    end
    mem.ChangeGameArray(arrName, newAddress, newCount, lenP)
    mem.prot()
end

-- DataTables.ComputeRowCountInPChar(p, minCols, needCol)
-- minCols is minimum cell count - if less, function stops reading file and returns current count
-- if col #needCol is not empty, current count is updated to its index, otherwise nothing is done - meant to exclude empty entries at the end of some files

local setItemDrawingHooks, setMiscItemHooks, setAlchemyHooks

do
	--[[
		ItemsTxt:       low = 0x560C14    high = 0x5666DC   size = 0x5AC8     itemSize = 0x28   dataOffset = 0x4 
        StdItemsTxt:    low = 0x5666DC    high = 0x5667F4   size = 0x118      itemSize = 0x14   dataOffset = 0x5ACC
        SpcItemsTxt:    low = 0x5667F4    high = 0x566E68   size = 0x674      itemSize = 0x1C   dataOffset = 0x5BE4
        PotionTxt:      low = 0x56A780    high = 0x56AAC9   size = 0x349      itemSize = 0x1D   dataOffset = 0x9B70

        ScrollTxt:      low = 0x6A86A8    high = 0x6A8804   size = 0x15C      itemSize = 0x4    dataOffset = 0x147A98
	]]

    ----0x5C

    local scrollTxtRefs = {
        [3] = {0x458EDD, 0x459010},
        [4] = {0x468097},
        End = {
            [1] = {0x46810E}
        }
    }

    local spcItemsTxtRefs = {
        [2] = {0x42574E, 0x425A07},
        [3] = {0x41CB6E, 0x42576C, 0x4257C6, 0x42580C, 0x425A25, 0x425A7F, 0x425AC5, 0x448640, 0x448754},
        limit = {
            [1] = {0x425734, 0x425786, 0x4259ED, 0x425A3F},
            [4] = {0x449D7F},
            -- [6] = {0x449ECB} -- handled manually below
        },
        relative = {
            [2] = {0x449D75, 0x449ED5, 0x448D0F}, 
            [3] = {0x448E44, 0x448E8D}
        }
    }

    local stdItemsTxtRefs = { -- relative done
        [2] = {0x4256CE, 0x425987, 0x425C2A},
        [3] = {0x41CB34, 0x4256F7, 0x4259B0, 0x425C53, 0x44870B},
        limit = {
            [1] = {0x449C46},
            [4] = {0x449B3B}
        },
        relative = {
            [2] = {0x449B31, 0x449C3C}, 
            [3] = {0x448C86, 0x448C4F},
        }
    }

    local itemsTxtRefs = {
        [1] = {
            0x4218DB, 0x42AB01, 0x43E050, 0x44A09A, 0x450D39, 0x4528BD, 0x452970, 0x4532B2, 0x453800, 0x454290, 0x454B62, 0x456192, 0x4564F2, 0x45664C,
            -- 0x457C66, -- this one is skipped, because it's used before new space is allocated
            0x458A2D, 0x458B53, 0x4857C2, 0x49FCDD, 0x49FEDD
        },
        [2] = {
            0x4123DC, 0x41271D, 0x41289C, 0x4128A5, 0x4129CA, 0x412A43, 0x412A4C, 0x412B14, 0x412B1D, 0x412C20, 0x412CA1, 0x4207D0, 0x4207FC, 0x427BAC, 0x427BDD, 0x42AAF5, 0x42C706, 0x44868D, 0x448696, 0x4486B8, 0x44A089, 0x45A063, 0x45A06D, 0x47D697, 0x47D6EA, 0x47E462, 0x47E468, 0x47E47E, 0x47E4A8, 0x47E578, 0x47E589, 0x47E58F, 0x47E5C2, 0x47EB11, 0x47EB17, 0x47EB36, 0x480CB9, 0x480CBF, 0x481C60, 0x481C72, 0x482EEC, 0x482F00, 0x482F06, 0x4833A6, 0x4833B0, 0x4833EC, 0x4833FB, 0x483439, 0x483445, 0x48344B, 0x483453, 0x48349F, 0x4834AF, 0x4834B5, 0x4834F7, 0x4834FF, 0x483514, 0x48351D, 0x483529, 0x48352F, 0x48353A, 0x483578, 0x483588, 0x48358E, 0x48359A, 0x48362A, 0x483630, 0x48366E, 0x483674, 0x48367F, 0x483A2A, 0x483A34, 0x483B11, 0x483B1B, 0x483B87, 0x483B91, 0x48513F, 0x485164, 0x485826, 0x48588F, 0x4858F8, 0x485961, 0x4859B8, 0x485A0F, 0x485A66, 0x485ABD, 0x485B14, 0x485B6B, 0x485BC2, 0x4A4C42, 0x4A4C85
        },
        [3] = {
            0x40FEE0, 0x40FF00, 0x410FF2, 0x4123E2, 0x4123E9, 0x412497, 0x41249E, 0x412657, 0x41265E, 0x412708, 0x41270F, 0x41292F, 0x412936, 0x4129BC, 0x4129C3, 0x412C30, 0x412C37, 0x412E58, 0x412F10, 0x412FAA, 0x4166A0, 0x41C4F2, 0x41C4FA, 0x41C57D, 0x41DECB, 0x41E0D6, 0x41E288, 0x41EB7A, 0x41ECF9, 0x41F11F, 0x41FE88, 0x420569, 0x4205B0, 0x4206A8, 0x421700, 0x4217E5, 0x4218EE, 0x42558B, 0x425592, 0x4256AB, 0x4256C5, 0x4256EC, 0x425763, 0x4257BE, 0x425801, 0x42584F, 0x425964, 0x42597E, 0x4259A5, 0x425A1C, 0x425A77, 0x425ABA, 0x425B08, 0x425C07, 0x425C21, 0x425C48, 0x429FAB, 0x42A396, 0x431CA0, 0x44861A, 0x448670, 0x448B46, 0x448BD2, 0x44F0D6, 0x458F91, 0x45907B, 0x45997F, 0x45A040, 0x45A967, 0x45BB89, 0x45BD12, 0x47E501, 0x47E625, 0x480BEF, 0x480C60, 0x481AF4, 0x481AFB, 0x481B4A, 0x481B51, 0x481B9C, 0x481BC0, 0x481BFB, 0x4835E5, 0x483C16, 0x483C98, 0x486CFF, 0x486E43, 0x486F37, 0x4870E4, 0x4872B2, 0x496E9E, 0x49758B, 0x4A4434, 0x4A46E6, 0x4A47F6, 0x4A499A
        },
        [5] = {
            0x41FFA4, 0x4208E1, 0x44C2F0, 0x45609A, 0x4561B0, 0x45625A, 0x46CC95, 0x48B2F3
        },
        limit = {
            [1] = {0x449852, 0x40FEC3, 0x448968, 0x448CDA},
            [2] = {0x44966C, 0x449678, 0x449805, 0x44A6F4}
        }
    }

    -- potion txt: 0x56A77F, 0x56AAC9, 0x9B6F, 0x9EB9

    -- rnditems.txt is ChanceByLevel field of ItemsTxtItem

    local potionTxtRefs = {
        [3] = {0x410BAF}, -- this one really references unused space before, but since it's indexed by [1st potion item id * 29] + [2nd potion id], it uses address inside as constant
        lowerBoundIncrease = 165,
        relative = {
            [2] = {0x4465DE}
        }
    }
	
    -- various enchantment power ranges etc.
	local otherItemDataRefs = {
        [1] = {0x425734, 0x425786, 0x4259ED, 0x425A3F},
        [2] = {0x425710, 0x425716, 0x4259C9, 0x4259CF, 0x425C6C, 0x425C72},
        [3] = {0x4256B5, 0x42596E, 0x425C11},
    }

    local relativeMiscDataRefs = { -- like above, but relative; refs after potions end
        [2] = {0x448F95, 0x44A69E, 0x44A65A, 0x4496C8, 0x44A645, 0x44A692, 0x44A683, 0x44A630, 0x449AFF, 0x44A66F, 0x44A61B, 0x449D43, 0x449835, 0x449946, 0x449993, 0x4499E0, 0x449A2D, 0x449A6D, 0x449AAD, 0x449932, 0x44997F, 0x4499CC, 0x449A19, 0x449A5C, 0x449A9C, 0x44991E, 0x44996B, 0x4499B8, 0x449A05, 0x449A4B, 0x449A8B, 0x449C32, 0x449EC1, 0x448CE7, 0x449ECB, 0x449EDD, 0x449EF4, 0x448E04}, 
        [3] = {0x448B00, 0x448C05, 0x448BE9, 0x448CC9, 0x448C10, 0x448B85, 0x448BA1, 0x448C3B, 0x448C9E, 0x448CAA}
    }
    
    local relativeItemDataRefs -- to silence "undefined global" warning
    -- relative offsets from item data start
    -- local relativeItemDataRefs = {
    --     [2] = {0x448F95, 0x4496C8, 0x449835, 0x44991E, 0x449932, 0x449946, 0x44996B, 0x44997F, 0x449993, 0x4499B8, 0x4499CC, 0x4499E0, 0x449A05, 0x449A19, 0x449A2D, 0x449A4B, 0x449A5C, 0x449A6D, 0x449A8B, 0x449A9C, 0x449AAD, 0x449AFF, 0x449B31, 0x449C32, 0x449C3C, 0x4465DE, 0x449D43, 0x449D75, 0x449EC1, 0x449ECB, 0x449ED5, 0x449EDD, 0x449EF4, 0x44A61B, 0x44A630, 0x44A645, 0x44A65A, 0x44A66F, 0x44A683, 0x44A692, 0x44A69E, 0x448CE7, 0x448D0F, 0x448E04},
    --     [3] = {0x448C3B, 0x448C4F, 0x448CC9, 0x448E44, 0x448E8D, 0x448B00, 0x448B85, 0x448BA1, 0x448BE9, 0x448C05, 0x448C10, 0x448C9E, 0x448CAA,
    --         -- stditems.txt
    --         0x448C86,
    --         -- 0x448D4E, 0x448D8A, 0x448DBC, 0x448DE2, -- these are not changed, because final offset is calculated with pointer to spcbonus with already corrected value
    --     }
    -- }
    -- so the issue was that relative item refs get breakpoint values assigned automatically, which is sometimes wrong
    -- (for example, value can be below lowest index of stditems.txt, meant to be used with ItemSize offset >= 1 entries)

    function categorizeRelativeItemRefs()
        for cmdSize, addrs in pairs(relativeItemDataRefs) do
            print("cmdSize:", cmdSize)
            local vals = {}
            for i, v in ipairs(addrs) do
                vals[#vals + 1] = {string.format("0x%X -> 0x%X", v, mem.u4[v + cmdSize]), mem.u4[v + cmdSize]}
            end
            table.sort(vals, function(a, b) return a[2] < b[2] end)
            for i, v in ipairs(vals) do
                print(v[1])
            end
        end
    end
    
    -- 0x6BA998 is scroll.txt contents
    autohook(0x468084, function(d)
        -- just loaded scroll.txt
        
        -- needs consideration: make item id be binding instead of row index?
        local count = DataTables.ComputeRowCountInPChar(d.eax, 1, 1)
        local newScrollSpaceAddr = StaticAlloc(count * 4) -- editpchar size
        processReferencesTable{arrName = "ScrollTxt", newAddress = newScrollSpaceAddr, newCount = count, addressTable = scrollTxtRefs}
    end)

    -- ITEM DATA MEMORY LAYOUT:
    -- items.txt size, items.txt, stditems.txt, spcitems.txt, 0x3918 placeholder bytes, potions.txt, 3 empty bytes, data pointers (items.txt, rnditems.txt, stditems.txt, spcitems.txt), 4 zero bytes
    -- [0] sum of all item chances for each of 6 treasure levels from rnditems.txt (0x56AADC, 6 dwords)
    -- [0x18] bonus chance by level from rnditems.txt (dword, level 1-6): standard, special, special% : 0x56AAF4, 18 dwords
    -- [0x60] std item bonus chances (column sums) : 0x56AB3C, 9 dwords
    -- [0x84] std bonus strength ranges: [min, max] for each treasure level: 0x56AB60, 12 dwords
    -- spc item bonus chances (column sums): 0x56AB90, 12 dwords
    -- 0x8 zero bytes
    -- spc items highest index (dword)
    -- 0x20 zero bytes
--do return end
    local NOP = string.char(0x90)

    local dataPtrs = 0x56AACC -- data pointers
    local itemsTxtDataPtr, rndItemsTxtDataPtr, stdItemsTxtDataPtr, spcItemsTxtDataPtr, useItemsTxtDataPtr = dataPtrs, dataPtrs + 4, dataPtrs + 8, dataPtrs + 12, 0x56F470
    local hooks = HookManager{itemsTxtDataPtr = itemsTxtDataPtr, rndItemsTxtDataPtr = rndItemsTxtDataPtr, stdItemsTxtDataPtr = stdItemsTxtDataPtr, spcItemsTxtDataPtr = spcItemsTxtDataPtr, useItemsTxtDataPtr = useItemsTxtDataPtr, itemsTxtFileName = 0x4BFE04, stdItemsTxtFileName = 0x4BFCD8, spcItemsTxtFileName = 0x4BFCC8, iconsLod = Game.IconsLod["?ptr"], loadFileFromLod = 0x40C1A0, useItemsTxtFileName = 0x4BF9BC, rndItemsTxtFileName = 0x4BFCE8}

    -- load tables
    -- address is just before loading useitems.txt
    local addr = hooks.asmpatch(0x44654D, [[
        ; items.txt
        mov ecx, %iconsLod%
        push 0
        push %itemsTxtFileName%
        call absolute %loadFileFromLod%
        mov [%itemsTxtDataPtr%], eax

        ; rnditems.txt
        mov ecx, %iconsLod%
        push 0
        push %rndItemsTxtFileName%
        call absolute %loadFileFromLod%
        mov [%rndItemsTxtDataPtr%], eax

        ; stditems.txt
        mov ecx, %iconsLod%
        push 0
        push %stdItemsTxtFileName%
        call absolute %loadFileFromLod%
        mov [%stdItemsTxtDataPtr%], eax

        ; spcitems.txt
        mov ecx, %iconsLod%
        push 0
        push %spcItemsTxtFileName%
        call absolute %loadFileFromLod%
        mov [%spcItemsTxtDataPtr%], eax

        ; useitems.txt
        mov ecx, %iconsLod%
        push 0
        push %useItemsTxtFileName%
        call absolute %loadFileFromLod%
        mov [%useItemsTxtDataPtr%], eax

        nop
        nop
        nop
        nop
        nop
    ]], 0x1B)

    --for i = 1, 100 do Party[0].Items[1]:Randomize(6) end
    hook(mem.findcode(addr, NOP), function(d)
        local itemCount, stdItemCount, spcItemCount = DataTables.ComputeRowCountInPChar(u4[itemsTxtDataPtr], 0, 2) - 3 + 1, -- 0th item also counts
            DataTables.ComputeRowCountInPChar(u4[stdItemsTxtDataPtr], 1, 1) - 4, DataTables.ComputeRowCountInPChar(u4[spcItemsTxtDataPtr], 1, 2) - 11
        local potionTxtRowCount = DataTables.ComputeRowCountInPChar(u4[useItemsTxtDataPtr], 0, 2) - 9 -- the file for this is useItems.txt
        local potionTxtCount = itemCount -- my change
        local potionTxtCols, potionTxtColIds = 0, {}
        do
            local t = mem.string(u4[useItemsTxtDataPtr]):split("\r\n")
            local c
            for i = 9, #t do
                _, c = t[i]:gsub("\t", "\t")
                potionTxtCols = max(potionTxtCols, c)
            end
            local ids = t[9]:split("\t")
            for i = 7, #ids do
                potionTxtColIds[i - 6] = tonumber(ids[i])
            end
        end
        local potionTxtColIdMap = StaticAlloc(potionTxtCols * 4)
        for i, v in ipairs(potionTxtColIds) do
            u4[potionTxtColIdMap + (i - 1) * 4] = v
        end

        local itemsSize, stdItemsSize, spcItemsSize, potionTxtSize = itemCount * Game.ItemsTxt.ItemSize, stdItemCount * Game.StdItemsTxt.ItemSize, spcItemCount * Game.SpcItemsTxt.ItemSize, potionTxtCount * potionTxtCount * 2
        local newSpace = StaticAlloc(itemsSize + stdItemsSize + spcItemsSize + potionTxtSize + 0x3A40)
        u4[newSpace] = itemCount -- Game.ItemsTxt lenP
        local itemsOffset = newSpace + 4
        local stdItemsOffset = itemsOffset + itemsSize
        local spcItemsOffset = stdItemsOffset + stdItemsSize
        local potionTxtOffset = spcItemsOffset + spcItemsSize + 0x3918
        local otherDataOffset = potionTxtOffset + potionTxtSize
        local enchantmentDataOffset = otherDataOffset + 3 + 0x10

        -- needed: old and new relative data start addresses (to compute relative offset, (newBegin - newRelativeBegin) - (old begin - oldRelativeBegin))
        --debug.Message(format("items %d, std %d, spc %d, potion %d", itemCount, stdItemCount, spcItemCount, potionTxtCount), format("size item %d, std %d, spc %d, potion %d, full %d", itemsSize, stdItemsSize, spcItemsSize, potionTxtSize, itemsSize + stdItemsSize + spcItemsSize + potionTxtSize + 0x3A43), format("after potion txt: 0x%X", potionTxtOffset + potionTxtSize))

        local itemDataBegin = 0x560C10
        
        local oldRelativeMiscDataOrigin = Game.PotionTxt["?ptr"] + Game.PotionTxt.Size - itemDataBegin
        local newRelativeMiscDataOrigin = otherDataOffset - newSpace
        --debug.Message((newRelativeMiscDataOrigin - oldRelativeMiscDataOrigin):tohex())

        local minOldOff, maxOldOff = itemDataBegin, Game.PotionTxt["?ptr"] + Game.PotionTxt.Size + 0x127
        local minNewOff, maxNewOff = newSpace, otherDataOffset + 0x127

        local function check(old, new, cmdSize, i)
            assert(old >= minOldOff and old <= maxOldOff, format("Old item data offset 0x%X (cmdSize %d, index %d) is outside bounds [0x%X, 0x%X]", old, cmdSize, i, minOldOff, maxOldOff))
            assert(new >= minNewOff and new <= maxNewOff, format("New item data offset 0x%X (cmdSize %d, index %d) is outside bounds [0x%X, 0x%X]", new, cmdSize, i, minNewOff, maxNewOff))
        end

        for cmdSize, addresses in pairs(otherItemDataRefs) do
            replacePtrs{addrTable = addresses, cmdSize = cmdSize, origin = oldRelativeMiscDataOrigin + itemDataBegin, newAddr = otherDataOffset, check = check}
        end

        -- relative offsets now
        minOldOff, maxOldOff = minOldOff - itemDataBegin, maxOldOff - itemDataBegin
        minNewOff, maxNewOff = minNewOff - newSpace, maxNewOff - newSpace

        for cmdSize, addresses in pairs(relativeMiscDataRefs) do
            replacePtrs{addrTable = addresses, cmdSize = cmdSize, check = check, origin = oldRelativeMiscDataOrigin, newAddr = newRelativeMiscDataOrigin}
        end

        -- fix stdbonus chance sums breaking due to weird addressing
        asmpatch(0x449C9D, "mov dword ptr [esp+0x1C]," .. enchantmentDataOffset - newSpace + 0x7C)
        asmpatch(0x449CF9, [[
            lea ecx, [ecx + ebp * 4]
            mov [ebx+ecx],eax
        ]], 5)
        HookManager{
            afterEnd = enchantmentDataOffset - newSpace + 0x7C + 6 * 2 * 4
        }.asmpatch(0x449D14, [[
            add eax, 8
            cmp eax, %afterEnd%
        ]])
        
        -- or, if offset due to more data was always a multiple of 4 (so no potion txt changes), this one line would do the trick
        -- asmpatch(0x449C9D, "mov dword ptr [esp+0x1C]," .. (enchantmentDataOffset - newSpace + 0x7C):div(4))

        setMiscItemHooks(itemCount, enchantmentDataOffset)
        setAlchemyHooks(itemCount)

        processReferencesTable{arrName = "ItemsTxt", newAddress = itemsOffset, newCount = itemCount, addressTable = itemsTxtRefs, lenP = newSpace,
            oldRelativeBegin = itemDataBegin, newRelativeBegin = newSpace}
        processReferencesTable{arrName = "StdItemsTxt", newAddress = stdItemsOffset, newCount = stdItemCount, addressTable = stdItemsTxtRefs,
            oldRelativeBegin = itemDataBegin, newRelativeBegin = newSpace}
        processReferencesTable{arrName = "SpcItemsTxt", newAddress = spcItemsOffset, newCount = spcItemCount, addressTable = spcItemsTxtRefs,
            oldRelativeBegin = itemDataBegin, newRelativeBegin = newSpace}
        
        -- "no" is converted to int as 0 (not mixable)
        -- "E4" = explosion, power 4
        processReferencesTable{arrName = "PotionTxt", newAddress = potionTxtOffset, newCount = potionTxtCount, addressTable = potionTxtRefs,
            oldRelativeBegin = itemDataBegin, newRelativeBegin = newSpace}
        
        local potionTxtHooks = HookManager{
            count = itemCount, potionTxt = potionTxtOffset, stringToInt = 0x4AEF19, potionTxtCols = potionTxtCols, potionTxtColIdMap = potionTxtColIdMap
        }

        asmpatch(0x4465E4, "mov dword ptr [esp+0x14]," .. potionTxtRowCount - 1)

        -- PotionTxt: CHANGE TO USE WORD INSTEAD OF BYTE
        -- also use dynamic column-itemId map (and support missing columns)
        potionTxtHooks.asmpatch(0x446641, [[
            lea ecx, [ebx - 6]
            mov ecx, [%potionTxtColIdMap% + ecx * 4]
            dec ecx
            mov [ecx*2+ebp],ax
            test ax,ax
        ]])
        potionTxtHooks.asmpatch(0x446666, [[
            lea ecx, [ebx - 6]
            mov ecx, [%potionTxtColIdMap% + ecx * 4]
            dec ecx
            mov [ecx*2+ebp],ax
            jmp absolute 0x446673
        ]])

        -- decide result potion by table indexes
        potionTxtHooks.asmpatch(0x410BA9, [[
            ; ecx = rightclicked id, eax = mouse item (first array index)
            xor ebx, ebx
            ; don't crash when holding no item
            test ecx, ecx
            je @zero
            test eax, eax
            je @zero
                dec ecx
                shl ecx, 1
                dec eax
                imul eax, %count%
                mov bx, [ecx + eax * 2 + %potionTxt%]
            @zero:
        ]], 0xD)

        -- get current index from first column
        -- also here: execute code for column indexes above 0x22
        potionTxtHooks.asmpatch(0x44662E, [[
            test ebx, ebx
            jne @std
                ; compute offset to put data at
                push esi
                call absolute %stringToInt%
                add esp, 4
                lea ebp, [eax - 1]
                imul ebp, %count% * 2
                add ebp, %potionTxt%
            @std:
            cmp ebx, 6
            jl absolute 0x446673
            cmp ebx, %potionTxtCols% ; more columns parsed
            jg absolute 0x446673
        ]], 0xA)

        mem.nop(0x446690) -- don't increase ebp (address to which data is written) by column count

        potionTxtHooks.asmpatch(0x44667B, [[
            cmp edx, %potionTxtCols% ; more columns parsed
            jg absolute 0x44668C
        ]], 5)

        -- fix Game.PotionTxt array
        do
            -- fortunately upvalues are shared, so no loop is needed
            local pot = Game.PotionTxt[Game.PotionTxt.Low]
            internal.SetArrayUpval(Game.PotionTxt, "low", 1)
            internal.SetArrayUpval(Game.PotionTxt, "size", itemCount * 2)
            internal.SetArrayUpval(pot, "low", 1)
            internal.SetArrayUpval(pot, "count", itemCount)
            local _, handler = debug.findupvalue(mem.structs.types.u2, "handler")
            internal.SetArrayUpval(pot, "f", handler)
            internal.SetArrayUpval(pot, "size", 2)
        end

        -- update mmextension hardcoded address
        do
            local i, val = debug.findupvalue(structs.Item.Randomize, "pItems")
            assert(i)
            debug.setupvalue(structs.Item.Randomize, i, newSpace)
        end

        -- esi points at start of data (items.txt size field)
        d.esi = newSpace

        -- correct base pointer
        hooks.ref.newSpace = newSpace
        hooks.asmhook(0x448F72, [[
            mov ebx, %newSpace%
            mov [esp + 0x18], ebx
        ]])

        -- use already loaded tables' data
        asmpatch(0x448F79, "mov eax, " .. u4[itemsTxtDataPtr], 0x16)
        asmpatch(0x4496AC, "mov eax, " .. u4[rndItemsTxtDataPtr], 0x16)
        asmpatch(0x449ADE, "mov eax, " .. u4[stdItemsTxtDataPtr], 0x1B)
        asmpatch(0x449D22, "mov eax, " .. u4[spcItemsTxtDataPtr], 0x1B)

        -- spcbonus limit fix (don't have time to investigate properly)
        mem.prot(true)
        u4[0x449ED1] = spcItemCount
        mem.prot()

        -- don't require rnditems.txt to have filled data for all items
        hooks.ref.itemCount = itemCount
        hooks.asmpatch(0x4497F9, [[
            ; if there is more data, next character is newline and then a digit
            mov al, [esi + 1]
            cmp al, '0'
            jb @done
            cmp al, '9'
            ja @done
            cmp edi, %itemCount%
            jae @done
            jmp @exit
            @done:
                jmp absolute 0x449805
            @exit:
                jmp absolute 0x4496F7
        ]], 0xC)

        -- generate item function stuff (use bigger "item ids suitable for generation" buffer)
        do
            local itemBuf = StaticAlloc(itemCount * 4)
            local hooks = HookManager{itemBuf = itemBuf}
            hooks.asmhook2(0x448973, [[
                mov edi, %itemBuf%
            ]])
            hooks.asmpatch(0x44897A, [[
                mov ecx, %itemBuf%
                sub edx,ebx
            ]])
            hooks.asmhook2(0x448A3F, [[
                mov eax, [%itemBuf%]
            ]])
            hooks.asmpatch(0x448A5A, [[
                jge absolute 0x448B40
                mov edi, %itemBuf%
            ]], 0xA)
            hooks.asmhook2(0x448CDF, [[
                mov edi, %itemBuf%
            ]])
            hooks.asmhook2(0x448CFB, [[
                mov edx, %itemBuf%
            ]])
            hooks.asmhook2(0x448E25, [[
                mov eax, [%itemBuf%]
            ]])
            hooks.asmhook2(0x448E5C, [[
                mov eax, %itemBuf%
            ]])
            -- TODO: change all to asmpatches to have no useless instructions? (low priority)
        end

        -- golden touch
        autohook2(0x428722, function(d)
            local t = getSpellQueueData(d.ebx, d.edi)
            t.Item = structs.Item:new(d.esi)
            t.Can = d.SF ~= d.OF -- doesn't include all checks, just the one for item number
            -- set nil to allow vanilla code to decide
            -- vanilla checks:
            -- item id < 400
            -- item not broken
            -- chance check (10% * skill) passed
            events.cocall("CanItemBeAffectedBySpell", t)
            if t.Can ~= nil then
                if t.Can then
                    d:push(0x428758)
                    return true
                else
                    d:push(0x425CE9)
                    return true
                end
            end
        end, 0xC)

        -- 0x448A1F, 0x4497F9, 0x44A70A CONTAIN HIGH OF ITEMS ABLE TO BE GENERATED EXCEPT ARTIFACTS (0x190, 400)
        -- 0x44A6E1 contains last artifact index
        -- 00440D43 - check if is artifact based on item id
        -- asmpatch(0x4497F9, "cmp edi," .. itemCount)

        -- random items from all treasure levels
        -- for i = 1, 6 do for j = 1, 30 do evt.GiveItem{Strength = i} end end

        -- random items of 5th level
        -- for j = 1, 300 do evt.GiveItem{Strength = 5} end

        setItemDrawingHooks()

        -- TODO: generateArtifact (0x44A6B0)

        -- 0x440D43, 0x441891 contains check for artifact added to mouse and if it's artifact, marks as found

        -- size: std done, spc done, items done, potion done, scroll done
        -- limit: 
        ------ hardcoded: scroll done, potion done, spc done, std done (?), items done (absolute limit), possible to generate (0x190) done and artifacts and below (.429) TODO-ed)
        ------ address of variable: items done?
        -- count: 
        -- end: 
        -- GAME EXIT CLEANUP FUNCTION
    end)
end

function setItemDrawingHooks()
    local itemCount = Game.ItemsTxt.Limit
    -- DRAWING --

    -- needed: belts, helms, armors

    local function getArmorPicsFromName(id, name, picture)
        local base = picture:match("(.-)icon")
        assert(base, format("Couldn't generate required bitmap names for item %d (name %q, picture in items.txt %q)", id, name, picture))
        return base .. "bod", base .. "arm1", base .. "arm2"
    end

    local beltBitmapIds, helmetBitmapIds, armorBitmapIds = StaticAlloc(itemCount * 4), StaticAlloc(itemCount * 4), StaticAlloc(itemCount * 4 * 3)
    local function process()
        for i, item in Game.ItemsTxt do
            if item.EquipStat == const.ItemType.Armor - 1 then
                local body, arm1, arm2 = getArmorPicsFromName(i, item.Name, item.Picture)
                local baseOff = armorBitmapIds + (i - 1) * 12
                u4[baseOff] = Game.IconsLod:LoadBitmap(body)
                u4[baseOff + 4] = Game.IconsLod:LoadBitmap(arm1)
                u4[baseOff + 8] = Game.IconsLod:LoadBitmap(arm2)
            elseif item.EquipStat == const.ItemType.Belt - 1 then
                local name = assert(item.Picture:match("(belt%d+)[abAB]")) .. "b"
                u4[beltBitmapIds + (i - 1) * 4] = Game.IconsLod:LoadBitmap(name)
            elseif item.EquipStat == const.ItemType.Helm - 1 then
                local id = item.Picture:match("he?lm(%d+)")
                local name
                if id then
                    name = "helm" .. id
                end
                id = item.Picture:match("hat(%d+)")
                if id then
                    name = "hat" .. id .. "b"
                end
                if not name then
                    name = assert(item.Picture:match("(crown%d+)")) .. "b"
                end
                u4[helmetBitmapIds + (i - 1) * 4] = Game.IconsLod:LoadBitmap(name)
            end
        end
    end

    callWhenGameInitialized(process)

    local hooks = HookManager{belts = beltBitmapIds, helmets = helmetBitmapIds, armors = armorBitmapIds}

    -- armors

    local armorXYbuf = StaticAlloc(itemCount * 3 * 2 * 2) -- body and both arms
    local armorXYwasSet = StaticAlloc(itemCount * 1)
    local paperdollArmorCoords = {}
    function paperdollArmorCoords.ClearCustomCoords(id)
        u1[armorXYwasSet + id - 1] = 0
    end
    local function makeCoordsAccessor(itemId, offset)
        return setmetatable({}, {
            __index = function(_, what)
                what = type(what) == "string" and what:lower() or what
                local x, y = i2[armorXYbuf + (itemId - 1) * 12 + offset], i2[armorXYbuf + (itemId - 1) * 12 + offset + 2]
                if what == "x" or what == 1 then
                    return x
                elseif what == "y" or what == 2 then
                    return y
                elseif what == "xy" or what == 3 then
                    return {X = x, Y = y, x, y}
                end
            end,
            __newindex = function (_, what, val)
                what = type(what) == "string" and what:lower() or what
                u1[armorXYwasSet + itemId - 1] = 1
                local xoff, yoff = armorXYbuf + (itemId - 1) * 12 + offset, armorXYbuf + (itemId - 1) * 12 + offset + 2
                if what == "x" or what == 1 then
                    i2[xoff] = val
                elseif what == "y" or what == 2 then
                    i2[yoff] = val
                elseif what == "xy" or what == 3 then
                    i2[xoff], i2[yoff] = val.X or val.x or val[1], val.Y or val.y or val[2]
                end
            end
        })
    end
    do
        local accessorsCache = {}
        setmetatable(paperdollArmorCoords, {
            __index = function(self, itemId)
                local ret = accessorsCache[itemId]
                if not ret then
                    ret = {Body = makeCoordsAccessor(itemId, 0), ArmOneHanded = makeCoordsAccessor(itemId, 4), ArmTwoHanded = makeCoordsAccessor(itemId, 8)}
                    ret[1], ret[2], ret[3] = ret.Body, ret.ArmOneHanded, ret.ArmTwoHanded
                    accessorsCache[itemId] = ret
                end
                -- rawset(self, itemId, ret) -- no rawset to make newindex work, use caching instead
                return ret
            end,
            __newindex = function(self, itemId, val)
                for i, arrName in ipairs{"Body", "ArmOneHanded", "ArmTwoHanded"} do
                    local a = self[itemId][arrName]
                    local innerVal = val[arrName] or val[i] or {}
                    for k, v in pairs(innerVal) do
                        a[k] = v
                    end
                end
            end
        })
    end
    Items.PaperdollArmorCoords = paperdollArmorCoords

    -- default coords for already existing images
    callWhenGameInitialized(function()
        local idsByPic = {}
        for armorId = 66, 78 do
            local pic = Game.ItemsTxt[armorId].Picture
            idsByPic[pic:lower()] = armorId
        end

        for i, item in Game.ItemsTxt do
            if idsByPic[item.Picture:lower()] then
                local index = idsByPic[item.Picture:lower()] - 66
                local off = index * 2

                paperdollArmorCoords[i] = {
                    Body = {i2[0x4BCDF8 + off], i2[0x4BCE14 + off]},
                    ArmOneHanded = {i2[0x4BCE30 + off], i2[0x4BCE4C + off]},
                    ArmTwoHanded = {i2[0x4BCE68 + off], i2[0x4BCE84 + off]}
                }

                -- fill in default coords from memory for easy modification, but don't use them by default
                if i >= 66 and i <= 78 then
                    paperdollArmorCoords.ClearCustomCoords(i)
                end
            end
        end
    end)

    hooks.ref.armorXYbuf = armorXYbuf
    hooks.ref.armorXYwasSet = armorXYwasSet

    -- armors
    Items.PaperdollArmorCoords[609] = {Body = {505, 95}, ArmOneHanded = {566, 95}, ArmTwoHanded = {569, 95}}
    Items.PaperdollArmorCoords[610] = {Body = {510, 95}, ArmOneHanded = {566, 95}, ArmTwoHanded = {569, 95}}
    -- correct bitmap id
    hooks.asmpatch(0x4125C8, [[
        push ecx
        mov eax, [ebp+0x1434] ; item armor
        lea ecx, [eax * 8]
        sub ecx, eax
        mov eax, [ebp+ecx*4+0x128] ; item id
        dec eax
        lea eax, [eax + eax * 2]
        mov edi, [eax * 4 + %armors%]
        pop ecx
        test cl, 2
    ]], 0xA)

    -- show custom armors with indexes other than builtin ones
    mem.nop(0x4125A7)

    -- armor coords
    hooks.asmhook(0x4125A9, [[
        push ecx
        mov edx, [ebp+0x1434] ; item armor
        lea ecx, [edx * 8]
        sub ecx, edx
        mov edx, [ebp+ecx*4+0x128] ; item id
        dec edx
        mov cl, [%armorXYwasSet% + edx]
        test cl, cl
        pop ecx
        je @std
        lea edx, [edx + edx * 2]
        movsx edi, word [%armorXYbuf% + edx * 4] ; X
        movsx edx, word [%armorXYbuf% + edx * 4 + 2] ; Y
        jmp absolute 0x4125B9

        @std:
    ]], 0x10)

    -- drawing armored arms

    local patch = [[
        ; bitmap id
        push edx
        add eax, 65 ; now has proper item id - 1
        lea edx, [eax + eax * 2]
        mov edi, [%armors% + edx * 4 + %bmpOff%] ; bitmap id

        ; coords
        mov dl, byte [%armorXYwasSet% + eax]
        test dl, dl
        jne @newCoords
            sub eax, 65
            movsx ecx,word ptr [eax*2+%defaultXoff%]
            movsx eax,word ptr [eax*2+%defaultYoff%]
            jmp @exit
        @newCoords:
            lea eax, [eax + eax * 2]
            movsx ecx,word ptr [eax*4+%armorXYbuf% + %coordsOffY%] ; Y
            movsx eax,word ptr [eax*4+%armorXYbuf% + %coordsOffX%] ; X
        @exit:
        pop edx
    ]]

    -- offhand equipped arm

    -- always draw
    asmpatch(0x412AE1, "test dword [ebp+0x1434], 0xFFFFFFFF", 0x11)

    -- armored arm bitmap id and XY coords
    table.copy({
        defaultXoff = 0x4BCE4C,
        defaultYoff = 0x4BCE30,
        coordsOffX = 4,
        coordsOffY = 6,
        bmpOff = 4,
    }, hooks.ref, true)
    hooks.asmpatch(0x412B39, patch, 0x17)

    -- no offhand equipped arm

    table.copy({
        defaultXoff = 0x4BCE68,
        defaultYoff = 0x4BCE84,
        coordsOffX = 8,
        coordsOffY = 10,
        bmpOff = 8,
    }, hooks.ref, true)
    hooks.asmpatch(0x412B76, patch, 0x17)

    -- belts, correct bitmap id
    hooks.asmpatch(0x412918, [[
        mov ebx, [eax * 4 + %belts% - 4]
    ]], 0x7)

    -- helmets, correct bitmap id
    hooks.asmpatch(0x412669, [[
        mov edi, [ecx * 4 + %helmets% - 4]
    ]], 0x19)

    -- scanline offset is top left pixel address
    -- value is offset in pixels
    -- value % Screen.Width (640) is y offset from top, value:div(Screen.Width) is x offset from left
    -- 0x4CA888 weakest chain armor scanline offset
end

function setMiscItemHooks(itemCount, enchantmentDataOffset)
    --[[
        -- [0] sum of all item chances for each of 6 treasure levels from rnditems.txt (0x56AADC, 6 dwords)
        -- [0x18] bonus chance by level from rnditems.txt (dword, level 1-6): standard, special, special% : 0x56AAF4, 18 dwords
        -- [0x60] std item bonus chances (column sums) : 0x56AB3C, 9 dwords
        -- [0x84] std bonus strength ranges: [min, max] for each treasure level: 0x56AB60, 12 dwords
        -- [0xB4] spc item bonus chances (column sums): 0x56AB90, 12 dwords
    ]]

    -- this function binds game array with my custom array for some sort of sums, so that updating relevant fields in structures automatically updates chances in new arrays
    local function bindHandlerWithItemDataArray(t)
        local size, memArr, bindTo, firstIndex, array = t.size, t.memArr, t.bindTo, t.firstIndex or 0, t.array
        local members, mname, arrayOrigin = t.members, t.mname, t.arrayOrigin
        callWhenGameInitialized(function()
            -- note: "obj" argument doesn't always refer to base structure, it can refer to arrays, member structs (that contain given member) etc.
            local handlerUpvalId, oldHandler
            if array then
                handlerUpvalId, oldHandler = debug.findupvalue(array, "f")
            else
                oldHandler = assert(members[mname])
            end
            local function myHandler(o, obj, name, val, ...)
                -- if val ~= nil then debug.Message(o:tohex(), obj["?ptr"]:tohex(), name, val, arrayOrigin) end
                local old = memArr[obj["?ptr"] + o]
                local ret = oldHandler(o, obj, name, val, ...)
                if val ~= nil then
                    local new = memArr[obj["?ptr"] + o]
                    if new ~= old then
                        -- if using array, then obj is array address, so "o" is offset from the beginning of array, otherwise it's offset from structure start
                        local index = array and (o / size) or ((o - arrayOrigin) / size)
                        index = index + firstIndex
                        bindTo[index] = bindTo[index] + (new - old)
                    end
                end
                return ret
            end
            if array then
                debug.setupvalue(array, handlerUpvalId, myHandler)
            else
                members[mname] = myHandler
            end
        end)
    end

    local rndItemsChanceSums = makeMemoryTogglerTable{arr = u4, size = 4, buf = enchantmentDataOffset,
        minIndex = 1, maxIndex = 6}
    Items.RndItemsChanceSums = rndItemsChanceSums

    bindHandlerWithItemDataArray{array = structs.m.ItemsTxtItem.ChanceByLevel, size = 1, memArr = u1, bindTo = rndItemsChanceSums, firstIndex = 1}

    -- Items.RndItemsBonusChanceByLevel[5].Standard = 50
    -- Items.RndItemsBonusChanceByLevel[2].Special = 50
    -- local per = Items.RndItemsBonusChanceByLevel[6].SpecialPercentage
    -- Items.RndItemsBonusChanceByLevel[6].SpecialPercentage = per + 12
    do
        local sums = enchantmentDataOffset + 0x18
        local function getOffset(key)
            local offsets = {["Standard"] = 0, ["Special"] = 6 * 4, ["SpecialPercentage"] = 6 * 4 * 2}
            local off = (offsets[key] or error(format("Invalid index %q", key), 3))
            return off
        end
        Items.RndItemsBonusChanceByLevel = setmetatable({}, {
            __index = function(t, i)
                checkIndex(i, 1, 6, 2)
                local tab = setmetatable({}, {
                    __index = function(self, key)
                        return u4[sums + getOffset(key) + (i - 1) * 4]
                    end,
                    __newindex = function(self, key, val)
                        u4[sums + getOffset(key) + (i - 1) * 4] = assertnum(val, 2)
                    end
                })
                rawset(t, i, tab)
                return tab
            end
        })
    end

    local stdBonusSlotNames = {Arm = 3, Shld = 4, Helm = 5, Belt = 6, Cape = 7, Gaunt = 8, Boot = 9, Ring = 10, Amul = 11}
    local spcBonusSlotNames = table.copy(stdBonusSlotNames)
    table.copy({
        W1 = 0, W2 = 1, Miss = 2
    }, spcBonusSlotNames, true)
    for k, v in pairs(stdBonusSlotNames) do
        stdBonusSlotNames[k] = v - 3 -- std bonuses don't use three lower values
    end
    -- Items.StdBonusSlotNames = stdBonusSlotNames
    -- Items.SpcBonusSlotNames = spcBonusSlotNames

    do
        local sums = makeMemoryTogglerTable{arr = u4, size = 4, buf = enchantmentDataOffset + 0x60, minIndex = 0, maxIndex = 8, aliases = stdBonusSlotNames}
        Items.StdBonusChanceSums = sums
        local members = structs.m.StdItemsTxtItem
        bindHandlerWithItemDataArray{array = members.ChanceForSlot, size = 1, memArr = u1, bindTo = sums}
        for mname in pairs(stdBonusSlotNames) do
            bindHandlerWithItemDataArray{members = members, mname = mname, size = 1, memArr = u1, bindTo = sums,
                arrayOrigin = structs.o.StdItemsTxtItem.ChanceForSlot}
        end
    end

    local enchOffset = 0x84
    do
        local accessorsCache = {}
        local rangePartTable = {Low = 0, Min = 0, High = 1, Max = 1, LowHigh = 2, MinMax = 2, Range = 2, Full = 2}
        Items.StdBonusStrengthRanges = setmetatable({}, {
            __index = function(self, i)
                checkIndex(i, 1, 6, 2, "Invalid treasure level")
                local ret = accessorsCache[i]
                if not ret then
                    local function index(_, rangePart, val)
                        local idx
                        if type(rangePart) == "number" then
                            checkIndex(rangePart, 0, 2, 2)
                            idx = rangePart
                        else
                            local what = rangePartTable[rangePart]
                            if not what then
                                error(format("Invalid index %q", rangePart), 2)
                            end
                            idx = what
                        end

                        local baseOff = enchantmentDataOffset + enchOffset + (i - 1) * 8
                        if val == nil then
                            local low, high = u4[baseOff], u4[baseOff + 4]
                            local rets = {low, high, {low, high}}
                            return rets[idx + 1]
                        end

                        if idx == 0 then
                            u4[baseOff] = val
                        elseif idx == 1 then
                            u4[baseOff + 4] = val
                        elseif idx == 2 then
                            if type(val) ~= "table" then
                                error(format("Table value expected, got %s", type(val)), 2)
                            end
                            local minIndex = val[0] ~= nil and 0 or 1
                            if not val[minIndex] or not val[minIndex + 1] then
                                error("Table needs to have at least 2 values, starting from 0 or 1", 2)
                            end
                            u4[baseOff], u4[baseOff + 4] = val[minIndex], val[minIndex + 1]
                        end
                    end
                    ret = setmetatable({}, {__index = index, __newindex = index})
                    accessorsCache[i] = ret
                end
                return ret
            end,
            __newindex = function(self, treasureLevel, val)
                checkIndex(treasureLevel, 1, 6, 2)
                if type(val) == "number" then -- identical range ends
                    local a = self[treasureLevel]
                    a.Low, a.High = val, val
                else -- assume table
                    self[treasureLevel].LowHigh = val
                end
            end
        })
    end

    do
        local sums = makeMemoryTogglerTable{arr = u4, size = 4, buf = enchantmentDataOffset + 0xB4,
        minIndex = 0, maxIndex = 11, aliases = spcBonusSlotNames}
        Items.SpcBonusChanceSums = sums
        local members = structs.m.SpcItemsTxtItem
        bindHandlerWithItemDataArray{array = members.ChanceForSlot, size = 1, memArr = u1, bindTo = sums}
        for mname in pairs(spcBonusSlotNames) do
            bindHandlerWithItemDataArray{members = members, mname = mname, size = 1, memArr = u1, bindTo = sums,
                arrayOrigin = structs.o.SpcItemsTxtItem.ChanceForSlot}
        end
    end

    -- can item be generated
    do
        local buf = StaticAlloc(itemCount)
        mem.fill(buf, 400, 1) -- normal items
        mem.fill(buf + 400, itemCount - 400, 0) -- artifacts and quest items and after
        local canBeFound = makeMemoryTogglerTable{buf = buf, arr = u1, size = 1, minIndex = 1, maxIndex = itemCount,
            bool = true}
        -- if value at index idx is 0, item idx cannot be generated (artifacts and quest items by default), otherwise it can
        Items.CanItemBeRandomlyFound = canBeFound
        HookManager{
            buf = buf, itemCount = itemCount, 
        }.asmpatch(0x448A1C, [[
            ; edi = item id
            mov cl, [%buf% + edi - 1]
            test cl, cl
            jne @nextIteration
                ; current cannot be generated - find first which can
                push esi
                xchg esi, edi
                lea edi, [%buf% + esi]
                mov ecx, %itemCount%
                sub ecx, esi
                push eax
                mov al, 1
                repne scasb
                pop eax
                xchg esi, edi
                pop esi
                jne @exit
                    ; correct item id
                    neg ecx
                    lea edi, [%itemCount% + ecx]
                    ; ptr to correct item chance for slot
                    lea eax, [edi + edi * 4]
                    lea eax, [esi + eax * 8 + 0x1A + 4] ; +4 to skip items size field
                    add eax, ebx ; treasure level - 1
                    jmp absolute 0x4489A2
            @nextIteration:
            add eax, 0x28
            jmp absolute 0x4489A2
            @exit:
        ]], 0xF)
        
        -- autofill findable items if they have nonzero chance in rnditems.txt
        callWhenGameInitialized(function()
            for i, entry in Game.ItemsTxt do
                local can
                for j, val in entry.ChanceByLevel do
                    if val ~= 0 then
                        can = true
                        break
                    end
                end

                if can then
                    canBeFound[i] = true
                end
            end
        end)
    end
    --Items.CanItemBeRandomlyFound[591] = true; tryGetMouseItem(591, 6)
    mem.hookfunction(0x44A6B0, 1, 0, function(d, def, itemPtr)
        local item = structs.Item:new(itemPtr)
        local t = {Item = item, Allow = true}
        events.cocall("GenerateArtifact", t)
        if t.Allow then
            local r = def(itemPtr)
            t.GenerationSuccessful = r ~= 0
            events.cocall("ArtifactGenerated", t)
            return r
        end
        return 0 -- couldn't generate
    end)

    -- ITEM NAME HOOK --
    -- there are two variations, one is for any item, second for only identified items. First one jumps to second if item is identified
    -- any item variant requires asmpatch to hookfunction it, because it has short jump
    -- since both variations are called by game code, I need two hooks here
    -- however, I opted for using hook manager to disable second hook if first is entered and reenable after finishing, to avoid unnecessary double hook
    -- so "identified items only" hook is called only if game calls precisely this address, and not "any item" address

    addr = asmpatch(0x448660, [[
        test byte ptr [ecx+0x14],1
        je absolute 0x44866B
    ]], 0x6)

    local function getOwnBufferHookFunction(identified)
        local itemNameBuf, itemNameBufLen
        return function(d, def, itemPtr)
            local defNamePtr = def(itemPtr)
            -- identified name only means that function should only set full item names, if it's false, when item is not identified, for example only "Chain Mail" may be set
            local t = {Item = structs.Item:new(d.ecx), Name = mem.string(defNamePtr), IdentifiedNameOnly = identified}
            local prevName = t.Name
            events.call("GetItemName", t)
            if t.Name ~= prevName then
                local len = t.Name:len()
                if len <= 0x63 then
                    mem.copy(0x56B708, t.Name .. string.char(0))
                else
                    if not itemNameBuf or itemNameBufLen < len + 1 then
                        if itemNameBuf then
                            mem.free(itemNameBuf)
                        end
                        itemNameBufLen = len + 1
                        itemNameBuf = mem.malloc(itemNameBufLen)
                    end
                    mem.copy(itemNameBuf, t.Name .. string.char(0))
                    return itemNameBuf
                end
            end
            return defNamePtr
        end
    end

    local identifiedItemNameHooks = HookManager()
    identifiedItemNameHooks.hookfunction(0x448680, 1, 0, getOwnBufferHookFunction(false))

    local secondHookFunc = getOwnBufferHookFunction(true)
    mem.hookfunction(addr, 1, 0, function(d, def, itemPtr)
        identifiedItemNameHooks.Switch(false)
        local r = secondHookFunc(d, def, itemPtr)
        identifiedItemNameHooks.Switch(true)
        return r
    end)

    -- tests
    local slotNames = table.invert(spcBonusSlotNames)
    local function showbonus(std, i, slot, useName)
        local arr, myarr = std and Game.StdItemsTxt or Game.SpcItemsTxt, std and Items.StdBonusChanceSums or Items.SpcBonusChanceSums
        if useName then
            local name = slotNames[slot + (std and 3 or 0)]
            return arr[i][name], myarr[name]
        else
            return arr[i].ChanceForSlot[slot], myarr[slot]
        end
    end
    function _G.stdb(i, slot, useName)
        return showbonus(true, i, slot, useName)
    end
    function _G.spcb(i, slot, useName)
        return showbonus(false, i, slot, useName)
    end

    local function runTests()
        -- 1. test rnditems array
        for _, itemIndex in ipairs{1, 3, 24, 53, 71, 80, 200, 222, 223, 321, 360, 450, itemCount - 200, itemCount - 133, itemCount - 71, itemCount - 3, itemCount - 1} do
            local itemTxt, myArr = Game.ItemsTxt[itemIndex], Items.RndItemsChanceSums
            for _, treasureLevel in ipairs{1, 3, 4, 6} do
                for _, add in ipairs{3, 12, -3, 0, 55, -21, -12, 4, 8, 64, -9, 20} do
                    local oldChance, myVal = itemTxt.ChanceByLevel[treasureLevel], myArr[treasureLevel]
                    itemTxt.ChanceByLevel[treasureLevel] = oldChance + add
                    assert(itemTxt.ChanceByLevel[treasureLevel] == oldChance + add)
                    assert(myArr[treasureLevel] == myVal + add)
                end
            end
        end

        -- 2. test std bonus strength ranges
        local ranges = Items.StdBonusStrengthRanges
        -- fail test
        local ok = pcall(function() local x = ranges[0] end)
        assert(not ok)
        ok = pcall(function() local x = ranges[7] end)
        assert(not ok)
        for treasureLevel = 1, 6 do
            local function testIndexes(low, high)
                local range = ranges[treasureLevel]
                local oldLow, oldHigh = range.Low, range.High
                if low then
                    assert(oldLow == low)
                end
                if high then
                    assert(oldHigh == high)
                end
                assert(oldLow == range[0])
                assert(oldHigh == range[1])
                assert(oldLow == range.Low)
                assert(oldLow == range.Min)
                assert(oldHigh == range.High)
                assert(oldHigh == range.Max)
                local tableLow, tableHigh = unpack(range.LowHigh)
                local tableLow2, tableHigh2 = unpack(range[2])
                assert(oldLow == tableLow and tableLow == tableLow2)
                assert(oldHigh == tableHigh and tableHigh == tableHigh2)
            end
            for _, low in ipairs{1, 4, 6, 9, 10, 14, 16, 34, 65, 122} do
                for _, high in ipairs{1, 2, 5, 6, 14, 15, 22, 33, 49, 72, 143} do
                    testIndexes()
                    ranges[treasureLevel].LowHigh = {low, high}
                    testIndexes(low, high)
                    ranges[treasureLevel] = {3, 5}
                    testIndexes(3, 5)
                    ranges[treasureLevel].Low = 10
                    testIndexes(10, 5)
                    ranges[treasureLevel].MinMax = {2, 222}
                    testIndexes(2, 222)
                    ranges[treasureLevel].Max = 15
                    ranges[treasureLevel].Min = 22
                    testIndexes(22, 15)
                    ranges[treasureLevel].Range = {77, 111}
                    testIndexes(77, 111)
                end
            end
        end

        local std, spc = Game.StdItemsTxt, Game.SpcItemsTxt
        -- 3. test std/spc arrays
        for _, gameArr in ipairs{std, spc} do
            local isStd = gameArr == std
            local count = isStd and 9 or 12
            for _, slot in ipairs{0, 2, 3, 5, 6, count - 1} do
                local maxEnch = gameArr.High
                local slotName = slotNames[slot + (isStd and 3 or 0)] -- std items doesn't use lower 3 slots (weapons and bow)
                for _, enchId in ipairs{1, 3, 6, 7, 11, 13, maxEnch - 1, maxEnch} do
                    local entry = gameArr[enchId]
                    local myArr = isStd and Items.StdBonusChanceSums or Items.SpcBonusChanceSums
                    for _, add in ipairs{5, 12, 33, -20, -4, 11, 23, 45, -32, 0, 3, -1, 1} do
                        local myVal = myArr[slot]
                        local oldChance = entry.ChanceForSlot[slot]
                        local initialVal, initialChance = myVal, oldChance
                        entry.ChanceForSlot[slot] = oldChance + add
                        assert(myVal + add == myArr[slot],
                            format("[%s, %s] Slot (%d), enchId (%d): old value %d after adding %d doesn't match expected (%d)",
                                isStd and "StdItemsTxt" or "SpcItemsTxt", "my array", slot, enchId, myVal, add, myVal + add
                            )
                        )
                        assert(entry.ChanceForSlot[slot] == oldChance + add,
                            format("[%s, %s] Slot (%d), enchId (%d): old value %d after adding %d doesn't match expected (%d)",
                                isStd and "StdItemsTxt" or "SpcItemsTxt", "MMExt array", slot, enchId, myVal, add, myVal + add
                            )
                        )

                        -- restore old value
                        entry.ChanceForSlot[slot] = oldChance

                        -- now do it again, but use slot names
                        assert(myVal == myArr[slotName], format("%d %d", myVal, myArr[slotName]))
                        --myVal = myArr[slotName]
                        assert(oldChance == entry[slotName], format("%d %d", oldChance, entry[slotName]))
                        --oldChance = entry[slotName]
                        entry[slotName] = oldChance + add
                        assert(myVal + add == myArr[slotName],
                            format("[%s, %s] Slot name %q, enchId (%d): old value %d after adding %d doesn't match expected (%d)",
                                isStd and "StdItemsTxt" or "SpcItemsTxt", "my array", slotName, enchId, myVal, add, myVal + add
                            )
                        )
                        assert(entry[slotName] == oldChance + add,
                            format("[%s, %s] Slot name %q, enchId (%d): old value %d after adding %d doesn't match expected (%d)",
                                isStd and "StdItemsTxt" or "SpcItemsTxt", "MMExt array", slotName, enchId, myVal, add, myVal + add
                            )
                        )
                        -- entry[slotName] = oldChance
                        -- local value, chance = myArr[slotName], entry[slotName] -- to show current values as locals
                        -- assert(value == initialVal and chance == initialChance, "Couldn't fully restore previous values")
                    end
                end
            end
        end
    end
    tget(Items, "debug").runTests = runTests
    --callWhenGameInitialized(runTests)
end

function setAlchemyHooks(itemCount)
    -- potions

    -- items that activate potion mixing code
    local isItemMixableBuf = StaticAlloc(itemCount)
    -- obsolete: decided to make every item mixable, because if both entries have 0 (that is, have "no" or simply are missing from useitems.txt)
    -- they won't be able to be mixed anyway. If this has unintended consequences, will be adjusted
    mem.fill(isItemMixableBuf, itemCount, 0)
    mem.fill(isItemMixableBuf + 160 - 1, 29, 1)
    --mem.fill(isItemMixableBuf, itemCount, 1)

    Items.IsItemMixable = makeMemoryTogglerTable{arr = u1, size = 1, buf = isItemMixableBuf, bool = true,
        minIndex = 1, maxIndex = itemCount, errorFormat = "Invalid item id"}
    
    local hooks = HookManager()
    hooks.ref.isItemIdMixable = HookManager{
        buf = isItemMixableBuf
    }.asmproc([[
        ; ecx - item id
        xor eax, eax
        test ecx, ecx ; avoid bug if there is no item (id == 0)
        jne @F
        inc ecx
        @@:
        mov al, [ecx + %buf% - 1]
        ret
    ]])

    local isItemPotionBottleBuf = StaticAlloc(itemCount)
    mem.fill(isItemPotionBottleBuf, itemCount, 0)
    u1[isItemPotionBottleBuf + 162] = 1
    mem.fill(isItemPotionBottleBuf + 188, 8, 1)
    Items.IsItemPotionBottle = makeMemoryTogglerTable{arr = u1, size = 1, buf = isItemPotionBottleBuf, bool = true, 
        minIndex = 1, maxIndex = itemCount, errorFormat = "Invalid item id"}
    hooks.ref.isItemPotionBottle = HookManager{
        buf = isItemPotionBottleBuf
    }.asmproc([[
        ; ecx - item id
        xor eax, eax
        test ecx, ecx
        jne @F
        inc ecx
        @@:
        mov al, [ecx + %buf% - 1]
        ret
    ]])

    local isItemPotionBuf = StaticAlloc(itemCount)
    mem.fill(isItemPotionBuf, itemCount, 0)
    mem.fill(isItemPotionBuf + 163, 25, 1)
    Items.IsItemPotion = makeMemoryTogglerTable{arr = u1, size = 1, buf = isItemPotionBuf, bool = true,
        minIndex = 1, maxIndex = itemCount, errorFormat = "Invalid item id"}
    hooks.ref.isItemPotion = HookManager{
        buf = isItemPotionBuf
    }.asmproc([[
        ; ecx - item id
        xor eax, eax
        test ecx, ecx
        jne @F
        inc ecx
        @@:
        mov al, [ecx + %buf% - 1]
        ret
    ]])
    
    hooks.asmpatch(0x410B1C, [[
        ; change weird empty potion bottles into common one (mouse item)
        push eax
        mov ecx, eax
        call absolute %isItemPotionBottle%
        test al, al
        pop eax
        je absolute 0x410B34
    ]], 0xE)

    hooks.asmpatch(0x410B4C, [[
        ; like above, but for rightclicked item
        push eax
        call absolute %isItemPotionBottle%
        test al, al
        pop eax
        je absolute 0x410B67
    ]], 0x10)

    hooks.ref.mouseItem = Mouse.Item["?ptr"]
    hooks.asmpatch(0x410B67, [[
        push eax
        mov ecx, eax
        call absolute %isItemPotionBottle%
        pop ecx
        test al, al
        jne absolute 0x41103A
        call absolute %isItemIdMixable%
        test al, al
        je absolute 0x41103A
        mov ecx,dword ptr [edi]
        call absolute %isItemIdMixable%
        test al, al
        je absolute 0x41103A
        mov eax, [%mouseItem%]
        mov ecx, [edi]
    ]], 0x3B)

    local potionBuf = StaticAlloc(9)
    -- potion id might not be needed (vanilla code sets it), but let's keep it just in case
    local customMixResult, newPotionId, newPower = potionBuf, potionBuf + 1, potionBuf + 5
    hook(0x410BA2, function(d)
        local clicked, mouse = structs.Item:new(d.edi), Mouse.Item
        if clicked.Number == 0 or mouse.Number == 0 then -- don't crash when holding no item
            return
        end
        -- set result to false to restrict mixing, 0 lets vanilla code select new potion (will probably crash for nonstandard ones)
        local t = {ClickedPotion = clicked, MousePotion = mouse, Player = GetPlayer(d.esi), Handled = false, Result = 0, ResultPower = 0, Explosion = false, PotionTxtResult = Game.PotionTxt[mouse.Number][clicked.Number]}
        t.ClickedPower, t.MousePower = t.ClickedPotion.Bonus, t.MousePotion.Bonus
        function t.CheckCombination(a, b) -- returns true if two provided ids are ids of any potion participating in mixing
            return clicked.Number == a and mouse.Number == b or clicked.Number == b and mouse.Number == a
        end
        events.cocall("MixPotion", t)
        u1[customMixResult] = 0
        if t.Handled then
            u4[d.esp] = 0x411028 -- exit, don't show item tooltip
        elseif t.Explosion then
            assert(t.Explosion >= 1 and t.Explosion <= 4, "Explosion power must be in [1, 4] range")
            d.ebx = t.Explosion
            u1[customMixResult] = 1
            u4[d.esp] = 0x410BB6
        elseif t.Result and t.Result ~= 0 then
            u1[customMixResult] = 1
            u4[newPotionId] = t.Result
            d.ebx = t.Result
            u4[newPower] = t.ResultPower or 0
            u4[d.esp] = 0x410BB6
        elseif not t.Result then -- cannot mix
            d.ebx = 0
            u4[d.esp] = 0x410BB6
        end
    end)

    table.copy({customMixResult = customMixResult, newPotionId = newPotionId, newPower = newPower}, hooks.ref, true)

    -- apply data from above event to potion
    hooks.asmhook2(0x410FD3, [[
        mov al, [%customMixResult%]
        and byte [%customMixResult%], 0
        test al, al
        je @exit
        mov eax, [%newPotionId%]
        mov [edi], eax
        mov eax, [%newPower%]
        mov [edi + 4], eax
        @exit:
    ]], 0xA)

    -- TODO: autonotes 0x410FDD

    -- tests
    do
        local superResistance, magicPotion, divinePower, protection, curePoison, resistance = 173, 165, 178, 167, 169, 168
        --[[
            local pots = {173, 165, 178, 167, 169, 168}
            for i, pot in ipairs(pots) do
                for j = 1, 5 do
                    evt.GiveItem{Id = pot}
                end
            end
        ]]
        function events.MixPotion(t)
            local idMouse, idClicked = t.MousePotion.Number, t.ClickedPotion.Number
            if idMouse == superResistance then
                t.Result = magicPotion
                t.ResultPower = random(5, 24)
            elseif idMouse == magicPotion and idClicked == magicPotion then
                t.Result = divinePower
                t.ResultPower = random(100, 200)
            elseif t.CheckCombination(protection, curePoison) then
                t.Result = math.random(2) == 1 and divinePower or resistance
                t.ResultPower = 0
            elseif t.CheckCombination(magicPotion, protection) then
                t.Explosion = 4
            elseif t.CheckCombination(curePoison, magicPotion) then
                t.Result = false -- cannot mix
            elseif t.CheckCombination(curePoison, curePoison) then
                t.Handled = true -- do nothing at all
            end
        end
    end

    table.copy({sprintf = 0x4AE273, formatText = mem.topointer("Power: %lu"), screenAddText = 0x442E90}, hooks.ref, true)

    -- show power in tooltip
    hooks.asmhook(0x41CB20, [[
        ; sprintf to get text
        ; put it where bonus text is put on stack (if first byte is not 0, it will be printed automatically)
        ; [esp + 0x10] = items txt entry ptr, ebx = item ptr
        mov ecx, [esp + 0x10]
        cmp byte [ecx + 0x14], 0xE ; potion bottle
        jne @std
        mov eax, [ebx + 4] ; bonus (power)
        test eax, eax
        je @std
        lea ecx, [esp+0x114]
        push eax
        push %formatText%
        push ecx
        call absolute %sprintf%
        add esp, 0xC
        jmp absolute 0x41CB54
        @std:
    ]])

    -- don't show bonus name in item name for potions (I use this field for power)
    -- DONE WITH ASMHOOK BELOW
    -- function events.GetItemName(t)
    --     if t.Item:T().EquipStat == const.ItemType.Potion - 1 then
    --         t.Name = t.Item:T().Name
    --     end
    -- end

    -- don't crash in item name function for potions ("bonus" index out of range)
    hooks.asmhook(0x4486CE, [[
        ; ebx - item pointer
        mov ecx, [ebx]
        call absolute %isItemPotion%
        mov dl, al ; FIXME: using potentially clobbered register
        mov ecx, [ebx]
        call absolute %isItemPotionBottle%
        or dl, al
        je @std
            add esp, 0xC
            jmp absolute 0x448714
        @std:
    ]], 0x8)

    -- DRINK POTION
    autohook(0x459103, function(d) -- overwrite mm6patch hook if custom effect is added
        local t = {Player = GetPlayer(d.esi), Potion = Mouse.Item, Handled = false, CannotDrink = false}
        function t.MakeFaceAnimation()
            t.Player:ShowFaceAnimation(const.FaceAnimation.DinkPotion)
        end
        events.cocall("DrinkPotion", t)
        -- either: run vanilla code, run custom code or prohibit drinking
        -- CannotDrink == true: message "item cannot be used that way"
        -- Handled == true: don't run vanilla potion logic, but make drink sound, add recovery and remove mouse item
        -- Handled == false: full vanilla code runs
        if t.CannotDrink then
            d:push(0x459EB8)
            return true
        elseif t.Handled then
            d:push(0x459977)
            return true
        end
    end)
end

function events.CanItemBeAffectedBySpell(t)
    -- TODO
end