ASHIKARI=SETTINGS["ArcherAsAshikari"]
ASSASSIN=SETTINGS["ArcherAsAssassin"]
Mastery=SETTINGS["Mastery"]
if Mastery==true then
if ASSASSIN==false then
if ASHIKARI==false then

function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattlerMage or data.Player.Class==const.Class.Archer) then	
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
--t.Result =t.Result
end
end

function events.CalcDamageToMonster(t)	
local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattlerMage or data.Player.Class==const.Class.Archer) and t.DamageKind==0 then	
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
	m7=data.Player.Skills[const.Skills.Dark]
		if m7>=64 then 
		m7=m7-64
		end
		if m7>=64 then
		m7=m7-64
		end
	m9=data.Player.Skills[const.Skills.Bow]
		if m9>=64 then 
		m9=m9-64
		end
		if m9>=64 then
		m9=m9-64
		end
	m19=data.Player.Skills[const.Skills.Dagger]
		if m19>=64 then 
		m19=m19-64
		end
		if m19>=64 then
		m19=m19-64
		end
m111 = (m9 + m19)/2
m18=math.max(m2, m3, m4, m5, m1, m6, m7, m111)

t.Result =t.Result*(1+m18^0.7*mastery^0.7/100)
--t.Result =t.Result

end
end

function events.GameInitialized2()

Game.ClassKinds.StartingSkills[4][const.Skills.Thievery] = 1

end
end
end
end
