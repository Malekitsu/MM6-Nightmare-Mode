GREYKNIGHT=SETTINGS["KnightAsGreyKnight"]
BLOODKNIGHT=SETTINGS["KnightAsBloodKnight"]
if BLOODKNIGHT==false then
if GREYKNIGHT==true then


function events.GameInitialized2()
Game.ClassNames[const.Class.Knight]="Grey Knight"
Game.ClassNames[const.Class.Cavalier]="Moon knight"
Game.ClassNames[const.Class.Champion]="Champion of the Midnight Sun"
--Game.ClassKinds.StartingSkills[0][const.Skills.Thievery] = 1
Game.ClassKinds.StartingSkills[0][const.Skills.Dark] = 1
Game.ClassKinds.StartingSkills[0][const.Skills.Light] = 1
Game.ClassDescriptions[const.Class.Knight] = "A rare order of knights that uses magic to increase their strength. Has no class skill to damage but access to Light and Dark magic and can cast buff spells for 0 mana and at double power."
Game.ClassDescriptions[const.Class.Cavalier] = "A rare order of knights that uses magic to increase their strength. Has no class skill to damage but access to Light and Dark magic and can cast buff spells for 0 mana and at double power."
Game.ClassDescriptions[const.Class.Champion] = "A rare order of knights that uses magic to increase their strength. Has no class skill to damage but access to Light and Dark magic and can cast buff spells for 0 mana and at double power."
end

-- Day of Protection

-- Novice power = 2 (same as in vanilla - no change)
-- Expert power = 2
mem.asmpatch(0x0042961A, "lea    edx,[eax+eax*1]", 3)
-- Master power = 2
mem.asmpatch(0x0042960D, "lea    ecx,[eax*4+0x0]", 7)

-- duration = 1 hour * skill
mem.asmpatch(0x0042962E, [[
		lea    eax,[eax+eax*4]
		nop
	]], 4)


-- Day of the Gods

-- Novice power = 0 + skill * 2
mem.asmpatch(0x00428A90, [[
		lea    edx,[ecx*2*+0x0]
		nop
	]], 4)
-- Expert power = 0 + skill * 4
mem.asmpatch(0x00428A7B, [[
		lea    ecx,[ecx*3+0x5]
		nop
	]], 4)
-- Master power = 5 + skill * 4
mem.asmpatch(0x00428A62, [[
		lea    eax,[ecx*4+0x10]
		nop
		nop
		nop
		nop
	]], 7)

-- Novice duration = skill * 1 hour
mem.asmpatch(0x00428A9E, "shl     eax, 4", 3)
-- Expert duration = skill * 1 hour
mem.asmpatch(0x00428A75, "imul    eax, 3600", 6)
-- Novice duration = skill * 1 hour
mem.asmpatch(0x00428A5B, "shl     eax, 4", 3)


function events.CalcDamageToPlayer(t)
	if (t.Player.Class==const.Class.Champion or t.Player.Class==const.Class.Cavalier or t.Player.Class==const.Class.Knight) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0  then

--GET MASTERY SKILL
	mastery=t.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end
x=t.Player:GetFullHP()
y=t.Player.HP
if y < x*mastery^0.55/10 then

	t.Result=t.Result*(1-mastery^0.45/7)

	end
end
end
function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()
		if data.Player and (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) then	
	t.Result=t.Result*0.01
end
end
end
end

