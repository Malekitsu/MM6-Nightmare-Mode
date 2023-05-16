SHAMAN=SETTINGS["DruidAsShaman"]
HERBALIST=SETTINGS["DruidAsHerbalist"]
Mastery=SETTINGS["Mastery"]
if Mastery==true then
if HERBALIST==false then
if SHAMAN==false then

function events.HealingSpellPower(t)
	if (t.Caster.Class==const.Class.ArchDruid or t.Caster.Class==const.Class.GreatDruid or t.Caster.Class==const.Class.Druid) then
	mastery=t.Caster.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end
XSP = t.Caster.SP * mastery * 0.001
t.Caster.SP = t.Caster.SP - XSP
t.Result =t.Result+XSP^0.7*mastery
end
end

function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.ArchDruid or data.Player.Class==const.Class.GreatDruid or data.Player.Class==const.Class.Druid) then	
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
	if (t.Player.Class==const.Class.ArchDruid or t.Player.Class==const.Class.GreatDruid or t.Player.Class==const.Class.Druid) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0 and t.DamageKind==0 then
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
Game.ClassKinds.StartingSkills[5][const.Skills.Thievery] = 1


end
end
end
end