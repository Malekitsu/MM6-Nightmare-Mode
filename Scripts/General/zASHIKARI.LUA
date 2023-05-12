
ASHIKARI=SETTINGS["ArcherAsAshikari"]
ASSASSIN=SETTINGS["ArcherAsAssassin"]
if ASSASSIN==false then
if ASHIKARI==true then


-- damage scaling with speed (meant to be like classic Agility stat)
function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattleMage or data.Player.Class==const.Class.Archer) and t.DamageKind==0 then
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
	m5=data.Player.Skills[const.Skills.Dark]
		if m5>=64 then 
		m5=m5-64
		end
		if m5>=64 then
		m5=m5-64
		end
m6=m2+m3+m4+m5+m1
		data.Player.SP=data.Player.SP+t.Result*20/100
			t.Result=t.Result*0.85+m6

end
end

function events.CalcSpellDamage(t)
--get mastery

	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattleMage or data.Player.Class==const.Class.Archer) then	
	
	mastery=data.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
end
modif = data.Player.LevelBase
	modik = data.Player.Exp
	modit = modik-modif *(modif-1)*500
t.Result = t.Result + modit^(mastery^0.5/10)
end
	
end



function events.GameInitialized2()
    Game.Classes.HPFactor[const.Class.Archer] = 3
	Game.Classes.SPFactor[const.Class.Archer] = 1
    Game.Classes.HPFactor[const.Class.BattleMage] = 4
	Game.Classes.SPFactor[const.Class.BattleMage] = 1
    Game.Classes.HPFactor[const.Class.WarriorMage] = 5
	Game.Classes.SPFactor[const.Class.WarriorMage] = 1
--	Game.ClassKinds.StartingSkills[4][const.Skills.Dark] = 2
--	Game.ClassKinds.StartingSkills[4][const.Skills.Axe] = 0
--	Game.ClassKinds.StartingSkills[4][const.Skills.Spear] = 0
--	Game.ClassKinds.StartingSkills[4][const.Skills.Chain] = 0
	Game.ClassKinds.StartingSkills[4][const.Skills.Bodybuilding] = 2
--	Game.ClassKinds.StartingSkills[4][const.Skills.Thievery] = 1
	Game.ClassKinds.StartingSkills[4][const.Skills.Meditation] = 2

Game.ClassNames[const.Class.Archer]="Ashikari"
Game.ClassNames[const.Class.BattleMage]="Rune Master"
Game.ClassNames[const.Class.WarriorMage]="Hex Lord"
Game.ClassDescriptions[const.Class.Archer] = "Ashikaris are mystical warriors covered in magical tatoos. Physical attacks are increased by 1 for every rank in every magic skill. Their mana is low but melee attacks regenerate mana (20% of damage done). In addition their damage with spells is increased by about 0.5 pr level, depending how much XP they have more than required for current level (the more extra XP, the higher bonus damage)." 
Game.ClassDescriptions[const.Class.BattleMage] ="Ashikaris are mystical warriors covered in magical tatoos. Physical attacks are increased by 1 for every rank in every magic skill. Their mana is low but melee attacks regenerate mana (20% of damage done). In addition their damage with spells is increased by about 0.5 pr level, depending how much XP they have more than required for current level (the more extra XP, the higher bonus damage)." 
Game.ClassDescriptions[const.Class.WarriorMage] ="Ashikaris are mystical warriors covered in magical tatoos. Physical attacks are increased by 1 for every rank in every magic skill. Their mana is low but melee attacks regenerate mana (20% of damage done). In addition their damage with spells is increased by about 0.5 pr level, depending how much XP they have more than required for current level (the more extra XP, the higher bonus damage)."

end
end
end
