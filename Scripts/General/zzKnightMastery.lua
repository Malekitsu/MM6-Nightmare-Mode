GREYKNIGHT=SETTINGS["KnightAsGreyKnight"]
BLOODKNIGHT=SETTINGS["KnightAsBloodKnight"]
if BLOODKNIGHT==false then
if GREYKNIGHT==false then


function events.CalcDamageToPlayer(t)
	if (t.Player.Class==const.Class.ArchMage or t.Player.Class==const.Class.Wizard or t.Player.Class==const.Class.Sorcerer) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0  then
	mastery=t.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end

t.Result=t.Result*0.99^mastery

end
end

function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()
		if data.Player and (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and t.DamageKind==0 then
	mastery=data.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end	
	t.Result=t.Result*1.01^mastery
end
end

function events.GameInitialized2()
Game.ClassKinds.StartingSkills[5][const.Skills.Thievery] = 1

end
end
end

