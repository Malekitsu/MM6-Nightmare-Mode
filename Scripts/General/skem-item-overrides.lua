-- now uses same iteration method that the other skem-foo-overrides scripts use
-- added RANDO toggle for randomizer-specific overrides
-- 
-- removed the Flute entry, since it needs an ASM hack to work right
-- removed the Horn of Ros entry, since the vanilla descriptions are now getting appended to instead of overwritten

--[[ 0.8.6
-- The initialization project begins!
]]
local RANDO = SETTINGS["ImprovedQuestItems"]

local modifiedBookValues =
{
	[0] = 100,
	[1] = 200,
	[2] = 300,
	[3] = 500,
	[4] = 1000,
	[5] = 2000,
	[6] = 4000,
	[7] = 6000,
	[8] = 20000,
	[9] = 40000,
	[10] = 60000,
}

function skemWeaponOverrides(itemId)
	local itemTxt = Game.ItemsTxt[itemId]
		
	-- 2h staffs
	if ((itemTxt.Skill - 1 == const.Skills.Staff) and (itemTxt.Mod1DiceCount == 2) and (itemTxt.Mod1DiceSides == 4)) 
	then
		if (itemTxt.Mod2 == 3) 
		then
			itemTxt.Mod2 = 5
		elseif (itemTxt.Mod2 == 7)
		then
			itemTxt.Mod2 = 10
		end
	-- 2h swords
	elseif ((itemTxt.Skill - 1 == const.Skills.Sword) and (itemTxt.Mod1DiceCount == 4) and (itemTxt.Mod1DiceSides == 5)) 
	then
		if (itemTxt.Mod2 == 2) 
		then
			itemTxt.Mod2 = 12
		elseif (itemTxt.Mod2 == 8) 
		then
			itemTxt.Mod2 = 24
		end
	-- 2h axes
	elseif ((itemTxt.Skill - 1 == const.Skills.Axe) and (itemTxt.Mod1DiceCount == 3) and (itemTxt.Mod1DiceSides == 7))
	then
		if (itemTxt.Mod2 == 3) 
		then
			itemTxt.Mod2 = 12
		elseif (itemTxt.Mod2 == 9)
		then
			itemTxt.Mod2 = 24
		end
	-- 1h/2h spears
	elseif (itemTxt.Skill - 1 == const.Skills.Spear) 
	then 
		if ((itemTxt.Mod1DiceCount == 1) and (itemTxt.Mod1DiceSides == 9)) 
		then 
			-- spear changes
			itemTxt.Mod1DiceCount = 1
			itemTxt.Mod1DiceSides = 11
			itemTxt.Notes = string.gsub(itemTxt.Notes, "+1D9", "extra dice roll")
			if (itemTxt.Mod2 == 1) 
			then
				itemTxt.Mod2 = 3
			elseif (itemTxt.Mod2 == 5) 
			then
				itemTxt.Mod2 = 6
			elseif (itemTxt.Mod2 == 9) 
			then
				itemTxt.Mod2 = 9
			elseif (itemTxt.Mod2 == 13) 
			then
				itemTxt.Mod2 = 12
			end
		elseif ((itemTxt.Mod1DiceCount == 2) and (itemTxt.Mod1DiceSides == 6))
		then
			-- trident changes
			itemTxt.Mod1DiceCount = 2
			itemTxt.Mod1DiceSides = 6
			itemTxt.Notes = string.gsub(itemTxt.Notes, "+1D6", "extra dice roll")
			if (itemTxt.Mod2 == 4) then
				itemTxt.Mod2 = 6
			end
		elseif ((itemTxt.Mod1DiceCount == 3) and (itemTxt.Mod1DiceSides == 6)) 
		then
			-- halberd changes
			itemTxt.Mod1DiceCount = 4
			itemTxt.Mod1DiceSides = 3
			itemTxt.Notes = string.gsub(itemTxt.Notes, "+1D6", "extra dice roll")
			if (itemTxt.Mod2 == 4)
			then
				itemTxt.Mod2 = 6
			elseif (itemTxt.Mod2 == 10) then
				itemTxt.Mod2 = 12
			end
		end
	end

end

function skemSpellBookValues()
	for regularBook = 300, 376 do
		skemApplyBookValue(regularBook, false)
	end
	for pathBook = 377, 398 do
		skemApplyBookValue(pathBook, true)
	end
end

function skemApplyBookValue(itemID, is_mirror)
	if (is_mirror == true)
	then
		bookBase = 377
		bookMultiplier = 10
	else
		bookBase = 300
		bookMultiplier = 1
	end
	itemTxt = Game.ItemsTxt[itemID]
	bookLevel = math.fmod((itemID - bookBase), 11)
	itemTxt["Value"] = modifiedBookValues[bookLevel] * bookMultiplier
end

items = { 

}

commonNotes =

{
	["Pouch"] = "A leather pouch for holding... things?",
	["Unused Letter"] = "A scrap of paper that makes no sense.",
	["Map"] = "A map of... somewhere?",

	["Oracle"] = "One of four Memory Crystals needed to reawaken the Oracle.",
	["Twillen"] = "One of five statues for Twillen's Ritual.  This one goes to %1s.",
	["VARN"] = "One of six passwords needed to access the Well of VARN.",

	["Letter"] = "A letter from %1s to %2s.",
	["Quest"] = "Take this to %1s in %2s.",
	["Goods"] = "Sell this to %1s in %2s.",
}

randomizerNames = 
{
	[487] = "Inner Forge Key",
	[488] = "Snergle's Chamber Key",
	[489] = "Goblinwatch Key",
	[502] = "Proof of Betrayal",
	[545] = "Letter from King Roland",
	[555] = "West Bathhouse Key",
	[556] = "East Storage Key",
	[557] = "South Treasure Key",
	[559] = "Fire Lord's Key",
	[560] = "Hideout Room Key",
	[561] = "East Bathhouse Key",
	[562] = "West Storage Key",
	[563] = "North Treasure Key",
	[564] = "Kergmond's Key",
	[565] = "Warlord's Supply Key 1",
	[566] = "Tsantsa Jail Key",
	[568] = "Alamos Treasury Key",
	[569] = "Alamos Teleporter Key",
	[571] = "Warlord's Supply Key 2",
	[572] = "Dwarf Jail Key",
	[576] = "Library Chest Key",
	[578] = "Takao's Key",
}

randomizerNotes = 
{
	[430] = commonNotes["Pouch"],
	[431] = commonNotes["Pouch"],
	[432] = commonNotes["Pouch"],
	[433] = string.format(commonNotes["Quest"], "Albert Newton", "the Misty Islands"),
	[434] = string.format(commonNotes["Quest"], "the rebuilt temple", "Free Haven"),
	[446] = string.format(commonNotes["Quest"], "Prince Nicolai", "Castle Ironfist"),
	[448] = string.format(commonNotes["Quest"], "the ghost of Sir John Silver","Silver Cove"),
	[449] = string.format(commonNotes["Quest"], "Andover Potbello","New Sorpigal"),
	[450] = string.format(commonNotes["Twillen"], "Sweet Water"),
	[451] = string.format(commonNotes["Twillen"], "Kriegspire"),
	[452] = string.format(commonNotes["Twillen"], "the Mire of the Damned"),
	[453] = string.format(commonNotes["Twillen"], "Dragonsand"),
	[454] = string.format(commonNotes["Twillen"], "Bootleg Bay"),
	[455] = string.format(commonNotes["Quest"], "Wilbur Humphrey", "Castle Ironfist"),
	[456] = string.format(commonNotes["Quest"], "the Oracle", "Free Haven"),
	[457] = string.format(commonNotes["Quest"], "Albert Newton", "the Misty Islands"),
	[458] = string.format(commonNotes["Quest"], "the ghost of Balthazar", "the Lair of the Wolf"),
	[459] = string.format(commonNotes["Quest"], "the ghost of Balthazar", "the Lair of the Wolf"),
	[460] = "Baby, I compare you to a kiss from a rose on the grey.", -- from 'Kiss From A Rose', by Seal
	[461] = string.format(commonNotes["Quest"], "Archibald Ironfist", "the library above Castle Ironfist"),
	[462] = string.format(commonNotes["Goods"], "Lawrence Aleman", "Free Haven"),
	[463] = "Awards two Skill Points on use.",
	[464] = string.format(commonNotes["Quest"], "Gabriel Cartman", "Free Haven"),
	[465] = string.format(commonNotes["Goods"], "Lon Miller", "Free Haven"),
	[466] = "This will absorb radiation in the Tomb of VARN.",
	[467] = "Great! Dig it! Dig it! Dig to the center of the earth!", -- The Legend of Zelda: Link's Awakening (if you dig while Marin is following you)
	[468] = "The thief and the warrior by dawn will be gone.", -- from Mossflower, by Brian Jacques
	[469] = "I knew I'd want it, if I hadn't got it!", -- from The Lord of the Rings, by J.R.R. Tolkien
	[470] = "Worth one Circus Point at the Main Tent.\n" .. string.format(commonNotes["Goods"], "Davis Carp", "Free Haven"),
	[471] = "Worth three Circus Points at the Main Tent.\n" .. string.format(commonNotes["Goods"], "Bonnie Rotterdamn", "Free Haven"),
	[472] = "The Circus Master gives you this for 30 or more points.\nTrade these for equipment in Dragonsand.",
	[473] = "The Circus Master gives you this for 10 or more points.\nTrade these for equipment in Dragonsand.",
	[474] = string.format(commonNotes["Goods"], "Hejaz Mawsil", "New Sorpigal"),
	[475] = string.format(commonNotes["Quest"], "Janice", "New Sorpigal"),
	[476] = string.format(commonNotes["Goods"], "Sy Roth", "Free Haven"),
	[477] = "Worth five Circus Points at the Main Tent.\n" .. string.format(commonNotes["Goods"], "Geoff Southy", "Free Haven"),
	[479] = string.format(commonNotes["Quest"], "Andrew Vesper", "Castle Ironfist"),
	[480] = string.format(commonNotes["Quest"], "Emil Lime", "Kriegspire"),
	[481] = string.format(commonNotes["Quest"], "Buford T. Allman", "New Sorpigal"),
	[482] = "Used to unward the doors in the Hall of the Fire Lord.\n" ..  string.format(commonNotes["Goods"], "Dillan Robinson", "Free Haven"),
	[483] = string.format(commonNotes["Goods"], "Bendar Jahrom", "Dragonsand"),
	[484] = "Apples do not fall up!", -- oblique reference to I Wanna Be The Guy
	[485] = "Wear this to gain entry to the Supreme Temple of Baa in Kriegspire.",
	[486] = string.format(commonNotes["Quest"], "Erik von Stromgard", "the Frozen Highlands") .. "\nUse these to disable the Dragon Towers across Enroth.",
	[487] = "The key to the deeper parts of Gharik's Laboratory in New Sorpigal.",
	[488] = "The key to the deeper parts of Snergle's Caverns in Castle Ironfist.",
	[489] = "The key to Goblinwatch in New Sorpigal.",
	[490] = "Key #490, used to unlock an unknown lock.", -- I wasn't able to find this key's use condition in the decomp
	[491] = "Key #491, used to unlock an unknown lock.", -- I wasn't able to find this key's use condition in the decomp
	[492] = "One of two keys needed to open the locked chest in the Supreme Temple of Baa in Kriegspire.",
	[493] = commonNotes["Map"],
	[494] = commonNotes["Map"],
	[495] = commonNotes["Map"],
	[496] = commonNotes["Map"],
	[497] = commonNotes["Map"],
	[498] = string.format(commonNotes["Quest"], "Avinril Smythers", "Darkmoor"),
	[499] = string.format(commonNotes["Quest"], "Wilbur Humphrey", "Castle Ironfist"),
	[500] = commonNotes["Unused Letter"],
	[501] = commonNotes["Unused Letter"],
	[502] = string.format(commonNotes["Letter"], "Xenofex", "Slicker Silvertongue") .. "\n" .. string.format(commonNotes["Quest"], "Wilbur Humphrey", "Castle Ironfist"),
	[503] = string.format(commonNotes["Letter"], "Gerrard Blackames", "Jarvis") .. "\n" .. string.format(commonNotes["Quest"], "Charles d'Sorpigal", "the Misty Islands"),
	[504] = string.format(commonNotes["Letter"], "the Prince of Thieves", "Damian") .. "\n" .. string.format(commonNotes["Quest"], "Frank Fairchild", "New Sorpigal"),
	[505] = string.format(commonNotes["Letter"], "Xenofex", "Sulman") .. "\n" .. string.format(commonNotes["Quest"], "Andover Potbello", "New Sorpigal"),
	[506] = string.format(commonNotes["Quest"], "Osric Temper", "Free Haven"),
	[507] = "A record of the Temple of the Sun's activities in Enroth.",
	[508] = string.format(commonNotes["Letter"], "Osric Temper", "Kergmond the Warlord") .. "\n" .. string.format(commonNotes["Quest"], "Osric Temper", "Free Haven"),
	[509] = string.format(commonNotes["Letter"], "Xenofex", "an unknown recipient"),
	[510] = string.format(commonNotes["Letter"], "Cedric Druthers", "an unknown recipient"),
	[511] = "The riddle of the Monolith is contained within.",
	[512] = string.format(commonNotes["Letter"], "Lunstone", "Snergle"),
	[513] = string.format(commonNotes["Letter"], "the Prince of Thieves", "an unknown recipient"),
	[514] = commonNotes["Unused Letter"],
	[515] = string.format(commonNotes["Letter"], "Xenofex", "Gerrard Blackames"),
	[516] = string.format(commonNotes["Letter"], "Fetzil", "the Prince of Thieves"),
	[517] = commonNotes["Unused Letter"],
	[518] = "A diary page detailing an attack on the village of Kriegspire.",
	[519] = "A diary page from the mad artificer Agar.",
	[520] = "The remains of a diary page from Icewind Keep.",
	[521] = string.format(commonNotes["Letter"], "the Dragon Riders", "the occupiers of Icewind Keep"),
	[522] = string.format(commonNotes["Letter"], "the Temple of Baa", "the Temple of the Fist"),
	[523] = "A diary page detailing a failed attempt at attacking New Sorpigal.",
	[524] = commonNotes["Unused Letter"],
	[525] = string.format(commonNotes["Letter"], "Snergle", "his iron mines"),
	[526] = commonNotes["Unused Letter"],
	[527] = "A diary page detailing Corlagon's struggles with the Crystal of Terrax.",
	[528] = string.format(commonNotes["Letter"], "Gerrard Blackames", "Marcus"),
	[529] = "A diary page detailing Gharik's frustrations with Archibald Ironfist.",
	[530] = string.format(commonNotes["Letter"], "Cedric Druthers", "his order of Druids"),
	[531] = string.format(commonNotes["Letter"], "Archibald Ironfist", "Terrax"),
	[532] = "A loose page warning of some of the dangers of the Ritual of the Endless Night.",
	[533] = "A loose page detailing a failed raid on the Hall of the Fire Lord.",
	[534] = string.format(commonNotes["Letter"], "Archibald Ironfist", "Agar"),
	[535] = string.format(commonNotes["Letter"], "Archibald Ironfist", "Gharik"),
	[536] = "A scrap of paper indicating how the Shadow Guildhall is connected to their other haunts.",
	[537] = commonNotes["VARN"],
	[538] = commonNotes["VARN"],
	[539] = commonNotes["VARN"],
	[540] = commonNotes["VARN"],
	[541] = commonNotes["VARN"],
	[542] = commonNotes["VARN"],
	[543] = "The operating instructions for the Goblinwatch Gate.\n" .. string.format(commonNotes["Quest"],"Janice","New Sorpigal"),
	[544] = "Ancient Magic that will protect Enroth from the Kreegan Hive's destruction.",
	[545] = "The final words of King Roland Ironfist of Enroth.",
	[546] = "A strange, scroll-like object with a vaguely insulting message.",
	[547] = commonNotes["Unused Letter"],
	[548] = commonNotes["Unused Letter"],
	[549] = commonNotes["Unused Letter"],
	[550] = commonNotes["Oracle"], 
	[551] = commonNotes["Oracle"],
	[552] = commonNotes["Oracle"],
	[553] = commonNotes["Oracle"],
	[554] = "Smells like... victory.", -- The Order of the Stick, in turn quoting Apocalypse Now
	[555] = "The key to the West Bathhouse in the Temple of Baa in Castle Ironfist.",
	[556] = "The key to the East Storage Room in the Temple of Baa in Castle Ironfist.",
	[557] = "The key to the South Treasure Room in the Temple of Baa in Castle Ironfist.",
	[558] = "The key to the hidden door in the Temple of Baa in Castle Ironfist.",
	[559] = "The key to the locked chest in the Hall of the Fire Lord in Bootleg Bay.",
	[560] = "The key to the locked room in the Shadow Guild Hideout in Castle Ironfist.",
	[561] = "The key to the East Bathhouse in the Temple of Baa in Castle Ironfist.",
	[562] = "The key to the West Storage Room in the Temple of Baa in Castle Ironfist.",
	[563] = "The key to the North Treasure Room in the Temple of Baa in Castle Ironfist.",
	[564] = "The key to a small room in the Warlord's Fortress in Silver Cove.",
	[565] = "One of two keys needed to open the Supply Room in the Warlord's Fortress in Silver Cove.",
	[566] = "The key to the locked room in the Temple of Tsantsa in Bootleg Bay.",
	[567] = "One of two keys needed to open the locked chest in the Supreme Temple of Baa in Kriegspire.",
	[568] = "The key to the treasure room in Castle Alamos in the Eel-Infested Waters.",
	[569] = "The key to the teleporter room in Castle Alamos in the Eel-Infested Waters.",
	[570] = "The key to the Inner Sanctum of The Kreegan Hive in Sweet Water.",
	[571] = "One of two keys needed to open the Supply Room in the Warlord's Fortress in Silver Cove.",
	[572] = "The key to the jail in Snergle's Iron Mines in the Mire of the Damned.",
	[573] = "The key to the Water Temple in the Tomb of VARN beneath Dragonsand.",
	[574] = "The key to the Flame Door in the Tomb of VARN beneath Dragonsand.",
	[575] = "The key to the Back Door in the Tomb of VARN beneath Dragonsand.",
	[576] = "The key to the chest in the Library of the Tomb of VARN beneath Dragonsand.",
	[577] = "The key to the Chest of VARN deep below Dragonsand.",
	[578] = "The key to the locked room beneath Takao's House in the Free Haven Sewers.",
	[579] = "Rubies are my favorite!", -- MLP:FiM
	[580] = "Flashy!  Acrobatic!  Useless!", -- Shovel Knight
}

function randomizerOverrides(itemID)
	items[itemID] = { }
	if not (randomizerNames[itemID] == nil)
	then
		items[itemID]["Name"] = randomizerNames[itemID]
	end
	if not (randomizerNotes[itemID] == nil)
	then
		items[itemID]["Notes"] = Game.ItemsTxt[itemID]["Notes"] .. "\n\n" .. randomizerNotes[itemID]
	end
end

function traverseTable(input)
	if not (type(input) == "table")
	then
		return input
	else
		output = { }
		for key, value in pairs(input) do
			output[key] = traverseTable(input[key])
		end
		return output
	end
end

function itemOverrides(flag)
	for itemID = 1, Game.ItemsTxt.high do
		if (flag == true)
		then
			randomizerOverrides(itemID)
		end
		if not (items[itemID] == nil)
		then
			for k,v in pairs(items[itemID]) do
				if not (type(Game.ItemsTxt[itemID][k]) == "table")
				then
					Game.ItemsTxt[itemID][k] = v
				else
					Game.ItemsTxt[itemID][k] = traverseTable(items[itemID][k])
				end
			end
		end
		skemWeaponOverrides(itemID)
	end
end

function events.GameInitialized2()
	itemOverrides(RANDO)
	skemSpellBookValues()
end
