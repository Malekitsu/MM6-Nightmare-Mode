BERSERKER=SETTINGS["PaladinAsBerseker"]
if BERSERKER==false then

function events.HealingSpellPower(t)
	if (t.Caster.Class==const.Class.Hero or t.Caster.Class==const.Class.Crusader or t.Caster.Class==const.Class.Paladin) then	
	m1=t.Caster.Skills[const.Skills.Axe]
		if m1>=64 then 
		m1=m1-64
		end
		if m1>=64 then
		m1=m1-64
		end
	m2=t.Caster.Skills[const.Skills.Mace]
		if m2>=64 then 
		m2=m2-64
		end
		if m2>=64 then
		m2=m2-64
		end
	m3=t.Caster.Skills[const.Skills.Staff]
		if m3>=64 then 
		m3=m3-64
		end
		if m3>=64 then
		m3=m3-64
		end
	m4=t.Caster.Skills[const.Skills.Bow]
		if m4>=64 then 
		m4=m4-64
		end
		if m4>=64 then
		m4=m4-64
		end
	m5=t.Caster.Skills[const.Skills.Dagger]
		if m5>=64 then 
		m5=m5-64
		end
		if m5>=64 then
		m5=m5-64
		end
	m6=t.Caster.Skills[const.Skills.Sword]
		if m6>=64 then 
		m6=m6-64
		end
		if m6>=64 then
		m6=m6-64
		end
	m7=t.Caster.Skills[const.Skills.Thievery]
		if m7>=64 then 
		m7=m7-64
		end
		if m7>=64 then
		m7=m7-64
		end

m8=math.max(m2, m3, m4, m5, m1, m6)

t.Result =t.Result*(1+m8^0.7*m7^0.7/100)
end
end

function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) then	
	m1=data.Player.Skills[const.Skills.Axe]
		if m1>=64 then 
		m1=m1-64
		end
		if m1>=64 then
		m1=m1-64
		end
	m2=data.Player.Skills[const.Skills.Dagger]
		if m2>=64 then 
		m2=m2-64
		end
		if m2>=64 then
		m2=m2-64
		end
	m3=data.Player.Skills[const.Skills.Sword]
		if m3>=64 then 
		m3=m3-64
		end
		if m3>=64 then
		m3=m3-64
		end
	m4=data.Player.Skills[const.Skills.Bow]
		if m4>=64 then 
		m4=m4-64
		end
		if m4>=64 then
		m4=m4-64
		end
	m5=data.Player.Skills[const.Skills.Staff]
		if m5>=64 then 
		m5=m5-64
		end
		if m5>=64 then
		m5=m5-64
		end
	m6=data.Player.Skills[const.Skills.Mace]
		if m6>=64 then 
		m6=m6-64
		end
		if m6>=64 then
		m6=m6-64
		end
	m7=data.Player.Skills[const.Skills.Thievery]
		if m7>=64 then 
		m7=m7-64
		end
		if m7>=64 then
		m7=m7-64
		end
m8=math.max(m2, m3, m4, m5, m1, m6)

t.Result =t.Result*(1+m8^0.7*m7^0.7/100)
end
end

function events.CalcDamageToMonster(t)	
local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and t.DamageKind==0 then	
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
	m4=data.Player.Skills[const.Skills.Mind]
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
	m7=data.Player.Skills[const.Skills.Light]
		if m7>=64 then 
		m7=m7-64
		end
		if m7>=64 then
		m7=m7-64
		end
m8=math.max(m2, m3, m4, m5, m1, m6, m7)

t.Result =t.Result*(1+m8^0.7*mastery^0.7/100)

end
end

function events.GameInitialized2()

Game.ClassKinds.StartingSkills[5][const.Skills.Thievery] = 1

end
end

