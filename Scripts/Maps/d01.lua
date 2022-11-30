
local TXT = Localize{
	[0] = " ",
	[1] = "Exit Door",
	[2] = "Chest",
	[3] = "Switch",
	[4] = "Empty",
	[5] = "Empty",
	[6] = "Empty",
	[7] = "Door",
	[8] = "A",
	[9] = "B",
	[10] = "C",
	[11] = "D",
	[12] = "E",
	[13] = "F",
	[14] = "G",
	[15] = "H",
	[16] = "I",
	[17] = "J",
	[18] = "K",
	[19] = "L",
	[20] = "M",
	[21] = "N",
	[22] = "O",
	[23] = "P",
	[24] = "GoblinWatch",
	[25] = "You feel the knowledge flowing through your mind",
}
table.copy(TXT, evt.str, true)


evt.map[105] = function()
	if mapvars.learned == nil then
			for _, pl in Party do
			local skill, mastery = SplitSkill(pl.Skills[const.Skills.IdentifyItem])
			pl.Skills[const.Skills.IdentifyItem] = JoinSkill(math.max(skill, 4), math.max(mastery, const.Expert))
			end
		evt.StatusText(25)
		evt.ForPlayer("All")
		evt.Add("Experience", 500)
		mapvars.learned = 1
	end
end


evt.map[100] = function()
    Message("Trespassers shall die.")
end