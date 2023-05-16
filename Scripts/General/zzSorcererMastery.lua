SHADOW=SETTINGS["SorcererAsShadow"]
NECROMANCER=SETTINGS["SorcererAsNecromancer"]
Mastery=SETTINGS["Mastery"]
if Mastery==true then
if NECROMANCER==false then
if SHADOW==false then

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
			if  t.Spell == 6 or 8 or 15 or 26 or 41 or 92 or 97 then
				YSP = data.Player.SP * mastery * 0.001
				data.Player.SP = data.Player.SP - YSP / 4
				t.Result = t.Result+YSP^0.7*mastery^0.7/4
			elseif t.Spell == 9 or 10 or 22 or 84 or 7 or 96 or 32 or 98 then
				t.Result = t.Result*(1+mastery/100)
				else
				data.Player.SP = data.Player.SP - YSP
				YSP = data.Player.SP * mastery * 0.001
				data.Player.SP = data.Player.SP - YSP
				t.Result = t.Result+YSP^0.7*mastery^0.7
			end
		end
	end

function events.CalcDamageToPlayer(t)
	if (t.Player.Class==const.Class.ArchMage or t.Player.Class==const.Class.Wizard or t.Player.Class==const.Class.Sorcerer) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0 and t.DamageKind==0 then
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
