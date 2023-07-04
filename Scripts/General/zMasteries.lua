----------------------------------------------------
--ARCHER MASTERY
---------------------------------------------------
ASHIKARI=SETTINGS["ArcherAsAshikari"]
ASSASSIN=SETTINGS["ArcherAsAssassin"]
Mastery=SETTINGS["Mastery"]
if Mastery==true then
if ASSASSIN~=true then
if ASHIKARI~=true then

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





----------------------------------------------------
--CLERIC MASTERY
----------------------------------------------------
SERAPHIN=SETTINGS["ClericAsSeraphin"]
Mastery=SETTINGS["Mastery"]
if Mastery==true then
if SERAPHIN~=true then

function events.HealingSpellPower(t)
	if (t.Caster.Class==const.Class.HighPriest or t.Caster.Class==const.Class.Priest or t.Caster.Class==const.Class.Cleric) then
	mastery=t.Caster.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end
XSP = t.Caster.SP* mastery * 0.001
if t.Spell == 77 then
XSP = XSP / 4
end
t.Caster.SP = t.Caster.SP - math.floor(XSP)
t.Result =t.Result+XSP^0.7*mastery+mastery
end
end

function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.HighPriest or data.Player.Class==const.Class.Priest or data.Player.Class==const.Class.Cleric) then	
	mastery=data.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end
YSP = data.Player.SP * mastery * 0.001
data.Player.SP = data.Player.SP - math.floor(YSP)
t.Result =t.Result+YSP^0.7*mastery^0.7+mastery
end
end

function events.CalcDamageToPlayer(t)
	if (t.Player.Class==const.Class.HighPriest or t.Player.Class==const.Class.Priest or t.Player.Class==const.Class.Cleric) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0  then
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
t.Player.SP = t.Player.SP - math.floor(WSP^(0.85-mastery/100))
t.Result=t.Result*0.97^mastery

end
end


function events.GameInitialized2()
Game.ClassKinds.StartingSkills[1][const.Skills.Thievery] = 1


end
end
end




----------------------------------------------------
--DRUID MASTERY
----------------------------------------------------
SHAMAN=SETTINGS["DruidAsShaman"]
HERBALIST=SETTINGS["DruidAsHerbalist"]
Mastery=SETTINGS["Mastery"]
if Mastery==true then
if HERBALIST~=true then
if SHAMAN~=true then

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
if t.Spell == 77 then
XSP = XSP / 4
end
t.Caster.SP = t.Caster.SP - math.floor(XSP)
t.Result =t.Result+XSP^0.7*mastery+mastery
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
			if  t.Spell == 6 or t.Spell == 8 or t.Spell == 15 or t.Spell == 26 or t.Spell == 41 or t.Spell == 92 or t.Spell == 97 then
				YSP = math.floor(data.Player.SP * mastery * 0.001)
				data.Player.SP = data.Player.SP - YSP / 4
				t.Result = t.Result+YSP^0.7*mastery^0.7/4+mastery/4
			elseif t.Spell == 9 or t.Spell == 10 or t.Spell == 22 or t.Spell == 84 or t.Spell == 7 or t.Spell == 96 or t.Spell == 32 or t.Spell == 98 then
				t.Result = t.Result*(1+mastery/100)
				else
				YSP = data.Player.SP * mastery * 0.001
				data.Player.SP = data.Player.SP - math.floor(YSP)
				t.Result = t.Result+YSP^0.7*mastery^0.7+mastery
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
t.Player.SP = t.Player.SP - math.floor(WSP^(0.85-mastery/100))
t.Result=t.Result*0.97^mastery

end
end


function events.GameInitialized2()
Game.ClassKinds.StartingSkills[5][const.Skills.Thievery] = 1
	Game.SkillNames[const.Skills.Thievery]="Mastery"
	Game.SkillNames[const.Skills.Diplomacy]="Diplomacy"
	Game.SkillDescriptions[const.Skills.Thievery]="Mastery is a skill that allows players to increase their class bonus, making their character more powerful and effective in combat. The mastery skill is unique to each class, and players must invest points into it to improve their character's mastery level.\nRight-click on 'class name' on top of the 'stats' tab to access a wealth of information about your class's unique mastery abilities. "


end
end
end
end



----------------------------------------------------
--KNIGHT MASTERY
----------------------------------------------------
GREYKNIGHT=SETTINGS["KnightAsGreyKnight"]
BLOODKNIGHT=SETTINGS["KnightAsBloodKnight"]
Mastery=SETTINGS["Mastery"]
if Mastery==true then
if BLOODKNIGHT~=true then
if GREYKNIGHT~=true then


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
		if data and data.Player and (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and t.DamageKind==0 then
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
Game.ClassKinds.StartingSkills[0][const.Skills.Thievery] = 1

end
end
end
end



----------------------------------------------------
--PALADIN MASTERY
----------------------------------------------------
BERSERKER=SETTINGS["PaladinAsBerseker"]
Mastery=SETTINGS["Mastery"]
if Mastery==true then
if BERSERKER~=true then

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
if t.Spell == 54 then
t.Result = t.Result + 9 * t.Skill * (m8^0.7*m7^0.7/100)
end

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
	if data and data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and t.DamageKind==0 then	
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

Game.ClassKinds.StartingSkills[3][const.Skills.Thievery] = 1

end
end

end



----------------------------------------------------
--SORCERER MASTERY
----------------------------------------------------
SHADOW=SETTINGS["SorcererAsShadow"]
NECROMANCER=SETTINGS["SorcererAsNecromancer"]
Mastery=SETTINGS["Mastery"]
if Mastery==true then
if NECROMANCER~=true then
if SHADOW~=true then

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
			if  t.Spell == 6 or t.Spell == 8 or t.Spell == 15 or t.Spell == 26 or t.Spell == 41 or t.Spell == 92 or t.Spell == 97 then
				YSP = data.Player.SP * mastery * 0.001
				data.Player.SP = math.floor(data.Player.SP - YSP / 4)
				t.Result = t.Result+YSP^0.7*mastery^0.7/4+mastery/4
			elseif t.Spell == 9 or t.Spell == 10 or t.Spell == 22 or t.Spell == 84 or t.Spell == 7 or t.Spell == 96 or t.Spell == 32 or t.Spell == 98 then
				t.Result = t.Result*(1+mastery/100)
				else
				YSP = data.Player.SP * mastery * 0.001
				data.Player.SP = data.Player.SP - math.floor(YSP)
				t.Result = t.Result+mastery+YSP^0.7*mastery^0.7
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
t.Player.SP = t.Player.SP - math.floor(WSP^(0.85-mastery/100))
t.Result=t.Result*0.97^mastery

end
end


function events.GameInitialized2()
Game.ClassKinds.StartingSkills[2][const.Skills.Thievery] = 1
	Game.SkillNames[const.Skills.Thievery]="Mastery"
	Game.SkillNames[const.Skills.Diplomacy]="Diplomacy"
	Game.SkillDescriptions[const.Skills.Thievery]="Mastery is a skill that allows players to increase their class bonus, making their character more powerful and effective in combat. The mastery skill is unique to each class, and players must invest points into it to improve their character's mastery level.\nRight-click on 'class name' on top of the 'stats' tab to access a wealth of information about your class's unique mastery abilities. "

end
end
end
end
