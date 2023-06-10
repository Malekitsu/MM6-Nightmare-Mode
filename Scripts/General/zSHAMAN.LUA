
SHAMAN=SETTINGS["DruidAsShaman"]
HERBALIST=SETTINGS["DruidAsHerbalist"]
if HERBALIST==false then
if SHAMAN==true then

function events.HealingSpellPower(t)
	if (t.Caster.Class==const.Class.ArchDruid or t.Caster.Class==const.Class.GreatDruid or t.Caster.Class==const.Class.Druid) then	m1=t.Caster.Skills[const.Skills.Air]
		if m1>=64 then 
		m1=m1-64
		end
		if m1>=64 then
		m1=m1-64
		end
	m2=t.Caster.Skills[const.Skills.Earth]
		if m2>=64 then 
		m2=m2-64
		end
		if m2>=64 then
		m2=m2-64
		end
	m3=t.Caster.Skills[const.Skills.Fire]
		if m3>=64 then 
		m3=m3-64
		end
		if m3>=64 then
		m3=m3-64
		end
	m4=t.Caster.Skills[const.Skills.Water]
		if m4>=64 then 
		m4=m4-64
		end
		if m4>=64 then
		m4=m4-64
		end
	m5=t.Caster.Skills[const.Skills.Spirit]
		if m5>=64 then 
		m5=m5-64
		end
		if m5>=64 then
		m5=m5-64
		end
	m6=t.Caster.Skills[const.Skills.Body]
		if m6>=64 then 
		m6=m6-64
		end
		if m6>=64 then
		m6=m6-64
		end
	m7=t.Caster.Skills[const.Skills.Mind]
		if m7>=64 then 
		m7=m7-64
		end
		if m7>=64 then
		m7=m7-64
		end
m8=m2+m3+m4+m5+m1+m6+m7

t.Result =t.Result+t.Result*m8/200
end
end

function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.ArchDruid or data.Player.Class==const.Class.GreatDruid or data.Player.Class==const.Class.Druid) then	
	m1=data.Player.Skills[const.Skills.Air]
		if m1>=64 then 
		m1=m1-64
		end
		if m1>=64 then
		m1=m1-64
		end
	m2=data.Player.Skills[const.Skills.Earth]
		if m2>=64 then 
		m2=m2-64
		end
		if m2>=64 then
		m2=m2-64
		end
	m3=data.Player.Skills[const.Skills.Fire]
		if m3>=64 then 
		m3=m3-64
		end
		if m3>=64 then
		m3=m3-64
		end
	m4=data.Player.Skills[const.Skills.Water]
		if m4>=64 then 
		m4=m4-64
		end
		if m4>=64 then
		m4=m4-64
		end
	m5=data.Player.Skills[const.Skills.Spirit]
		if m5>=64 then 
		m5=m5-64
		end
		if m5>=64 then
		m5=m5-64
		end
	m6=data.Player.Skills[const.Skills.Body]
		if m6>=64 then 
		m6=m6-64
		end
		if m6>=64 then
		m6=m6-64
		end
	m7=data.Player.Skills[const.Skills.Mind]
		if m7>=64 then 
		m7=m7-64
		end
		if m7>=64 then
		m7=m7-64
		end
m8=m2+m3+m4+m5+m1+m6+m7

t.Result =t.Result+t.Result*m8/200
end
end

function events.CalcDamageToPlayer(t)
	if (t.Player.Class==const.Class.ArchDruid or t.Player.Class==const.Class.GreatDruid or t.Player.Class==const.Class.Druid) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0  then
	m1=t.Player.Skills[const.Skills.Air]
		if m1>=64 then 
		m1=m1-64
		end
		if m1>=64 then
		m1=m1-64
		end
	m4=t.Player.Skills[const.Skills.Water]
		if m4>=64 then 
		m4=m4-64
		end
		if m4>=64 then
		m4=m4-64
		end
		
t.Result=t.Result*(1-m1^0.5/10+0.09)-m4^1.25
end
end

function events.CalcDamageToMonster(t)	
local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.ArchDruid or data.Player.Class==const.Class.GreatDruid or data.Player.Class==const.Class.Druid) and t.DamageKind==0 and data.Object==nil then	
	mastery=data.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end
	m1=data.Player.Skills[const.Skills.Air]
		if m1>=64 then 
		m1=m1-64
		end
		if m1>=64 then
		m1=m1-64
		end
	m2=data.Player.Skills[const.Skills.Earth]
		if m2>=64 then 
		m2=m2-64
		end
		if m2>=64 then
		m2=m2-64
		end
	m3=data.Player.Skills[const.Skills.Fire]
		if m3>=64 then 
		m3=m3-64
		end
		if m3>=64 then
		m3=m3-64
		end
	m4=data.Player.Skills[const.Skills.Water]
		if m4>=64 then 
		m4=m4-64
		end
		if m4>=64 then
		m4=m4-64
		end
	m5=data.Player.Skills[const.Skills.Spirit]
		if m5>=64 then 
		m5=m5-64
		end
		if m5>=64 then
		m5=m5-64
		end
	m6=data.Player.Skills[const.Skills.Body]
		if m6>=64 then 
		m6=m6-64
		end
		if m6>=64 then
		m6=m6-64
		end
	m7=data.Player.Skills[const.Skills.Mind]
		if m7>=64 then 
		m7=m7-64
		end
		if m7>=64 then
		m7=m7-64
		end
m8=m2+m3+m4+m5+m1+m6+m7
data.Player.SP=data.Player.SP+m7
t.Result=t.Result*(1+m5/100)+m8*(1+mastery/20)+t.Monster.HP*(m3^0.5/500)+mastery*2
data.Player.HP=(data.Player.HP+m6)+m2/100*t.Result
end
end

function events.GameInitialized2()
Game.ClassNames[const.Class.Druid]="Shaman"
Game.ClassNames[const.Class.GreatDruid]="Sekhem"
Game.ClassNames[const.Class.ArchDruid]="MarabouFetishist"
Game.ClassKinds.StartingSkills[5][const.Skills.Spear] = 2
Game.ClassKinds.StartingSkills[5][const.Skills.Shield] = 2
Game.ClassKinds.StartingSkills[5][const.Skills.Thievery] = 1
--Game.ClassKinds.StartingSkills[5][const.Skills.Dagger] = 0
	Game.Classes.SPFactor[const.Class.Druid] = 1
	Game.Classes.SPFactor[const.Class.GreatDruid] =2
	Game.Classes.SPFactor[const.Class.ArchDruid] = 2
	Game.ClassDescriptions[const.Class.Druid] = "The Shaman is a mystical warrior whose knowledge of magic enhances his martial prowess. Each rank in magic increases melee damage by 1. In addition Fire and Earth increases damage by 1 more, spirit by 1%. Each skill in Air reduces damage taken by ca 1.5%, and each rank in Water by 1. Each rank in Mind increases current spellpoints by 1 pr rank on succesful hit."
	Game.ClassDescriptions[const.Class.GreatDruid] = "The Shaman is a mystical warrior whose knowledge of magic enhances his martial prowess. Each rank in magic increases melee damage by 1. In addition Fire and Earth increases damage by 1 more, spirit by 1%. Each skill in Air reduces damage taken by ca 1.5%, and each rank in Water by 1. Each rank in Mind increases current spellpoints by 1 pr rank on succesful hit."
	Game.ClassDescriptions[const.Class.ArchDruid] = "The Shaman is a mystical warrior whose knowledge of magic enhances his martial prowess. Each rank in magic increases melee damage by 1. In addition Fire and Earth increases damage by 1 more, spirit by 1%. Each skill in Air reduces damage taken by ca 1.5%, and each rank in Water by 1. Each rank in Mind increases current spellpoints by 1 pr rank on succesful hit."

end
end
end
