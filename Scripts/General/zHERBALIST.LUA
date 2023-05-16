
HERBALIST=SETTINGS["DruidAsHerbalist"]
SHAMAN=SETTINGS["DruidAsShaman"]
if SHAMAN==false then
if HERBALIST==true then

function events.HealingSpellPower(t)
	if (t.Caster.Class==const.Class.ArchDruid or t.Caster.Class==const.Class.GreatDruid or t.Caster.Class==const.Class.Druid) then
		--get body
			body=t.Caster.Skills[const.Skills.Body]
			if body>=64 then 
			body=body-64
			rank=2
			end
			if body>=64 then
			body=body-64
			rank=3
			end
FHP = t.Target:GetFullHP()
CHP = t.Target.HP
CSP = t.Target.SP
if t.Target.SP > 0 then
t.Target.SP = t.Target.SP + t.Result * 0.1
end
t.Result =(t.Result * 1.5 - 2 * body)*(1.5-CHP/FHP)
end
end

function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.ArchDruid or data.Player.Class==const.Class.GreatDruid or data.Player.Class==const.Class.Druid) then	
t.Result =t.Result*0.85
end
end

function events.CalcDamageToPlayer(t)
		
if t.Result>=t.Player.HP+t.Player.LevelBase*0.5 then
FHPx = t.Player:GetFullHP()
from=t.Player.LevelBase*2
if FHPx > from then
		--calculate healing
		mastery=t.Player.Skills[const.Skills.Thievery]
			if mastery>=64 then 
			mastery=mastery-64
			end
			if mastery>=64 then
			mastery=mastery-64
			end
chance=mastery*3+5
			if math.random(1,200)<chance then
					heal=t.Result-t.Player.LevelBase*0.5-t.Player.HP
					evt[t.PlayerIndex].Add("HP",heal)
			Game.ShowStatusText("Forces of Nature saves you from lethal damage")
	end
end	
end
end

function events.GameInitialized2()
Game.ClassNames[const.Class.Druid]="Herbalist"
Game.ClassNames[const.Class.GreatDruid]="Mender"
Game.ClassNames[const.Class.ArchDruid]="Restorer"
Game.ClassKinds.StartingSkills[5][const.Skills.Light] = 1
Game.ClassKinds.StartingSkills[5][const.Skills.Earth] = 0
Game.ClassKinds.StartingSkills[5][const.Skills.Fire] = 0
Game.ClassKinds.StartingSkills[5][const.Skills.Mind] = 0
Game.ClassKinds.StartingSkills[5][const.Skills.Spirit] = 0
Game.ClassKinds.StartingSkills[5][const.Skills.Thievery] = 1
end
end
--end
