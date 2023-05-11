SHADOW=SETTINGS["SorcererAsShadow"]
NECROMANCER=SETTINGS["SorcererAsNecromancer"]
Mastery=SETTINGS["Mastery"]
if Mastery==true then
if NECROMANCER==false then
if SHADOW==false then

function events.HealingSpellPower(t)
	if (t.Caster.Class==const.Class.ArchMage or t.Caster.Class==const.Class.Wizard or t.Caster.Class==const.Class.Sorcerer) then
	mastery=t.Caster.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end
XSP = t.Caster.SP * (mastery^0.1-1)/15
t.Caster.SP = t.Caster.SP - XSP
t.Result =t.Result+XSP^0.7*mastery
end
end

function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.ArchMage or data.Player.Class==const.Class.Wizard or data.Player.Class==const.Class.Sorcerer) then	
	mastery=data.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end
YSP = data.Player.SP * (mastery^0.1-1)/15
data.Player.SP = data.Player.SP - YSP
t.Result =t.Result+YSP^0.7*mastery
end
end

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
WSP = t.Result-t.Result*0.97^mastery
t.Player.SP = t.Player.SP - WSP / mastery^0.5
t.Result=t.Result*0.97^mastery

end
end


function events.GameInitialized2()
Game.ClassKinds.StartingSkills[2][const.Skills.Thievery] = 1

end
end
end
end
