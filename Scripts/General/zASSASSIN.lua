ASSASSIN=SETTINGS["ArcherAsAssassin"]
if ASSASSIN==true then

-- damage scaling with speed (meant to be like classic Agility stat)
function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattleMage or data.Player.Class==const.Class.Archer) and t.DamageKind==0 then
			speed=data.Player:GetSpeed()
			bonusDamage=speed/500
			t.Result=t.Result*(1+bonusDamage)
		end
	
end
--Energy Spender, when energy is 30 or more and adds a combo point up to 5
function events.CalcDamageToMonster(t)		
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattleMage or data.Player.Class==const.Class.Archer) and data.Player.SP>=30 and t.DamageKind==0 then
		t.Result=t.Result*1.5
		data.Player.SP=data.Player.SP-30
		    if comboPoint==nil then
		    comboPoint=0
				else if comboPoint<5 then
				comboPoint=comboPoint+1
				end
			end
	end
end
--have a 30% chance to replenish 15 energy when attacking
function events.CalcDamageToMonster(t)		
	data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattleMage or data.Player.Class==const.Class.Archer) and t.DamageKind==0 then	
		if math.random(1,100)<=30 then
			data.Player.SP=data.Player.SP+15
		end
	end
end
--Set base of 100 energy and starting skills
function events.GameInitialized2()
    Game.Classes.HPFactor[const.Class.Archer] = 2
	Game.Classes.SPFactor[const.Class.Archer] = 0
    Game.Classes.HPFactor[const.Class.BattleMage] = 3
	Game.Classes.SPFactor[const.Class.BattleMage] = 0
    Game.Classes.HPFactor[const.Class.WarriorMage] = 4
	Game.Classes.SPFactor[const.Class.WarriorMage] = 0
	Game.ClassKinds.StartingSkills[4][const.Skills.Dark] = 0
	Game.ClassKinds.StartingSkills[4][const.Skills.Axe] = 0
	Game.ClassKinds.StartingSkills[4][const.Skills.Spear] = 0
	Game.ClassKinds.StartingSkills[4][const.Skills.Chain] = 0
	Game.ClassKinds.StartingSkills[4][const.Skills.Bodybuilding] = 2
	Game.ClassKinds.SPBase[4] = 100
end

--consume combo points
function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.WarriorMage or data.Player.Class==const.Class.BattleMage or data.Player.Class==const.Class.Archer) then	
    if comboPoint==nil then
		comboPoint=0
		end
	if comboPoint<5 then
        t.Result=t.Result*(1+0.2*comboPoint) 
		comboPoint=0		
	else if comboPoint==5 then
            t.Result=t.Result*2.5
			comboPoint=0
	end
		comboPoint=0
    end
	end
	
end

--function events.CalcDamageToPlayer(t)
--	evt.FaceExpression{Player = "Current", Frame = 33}
--	t.Result=0
--end
--SP increase items will add only 1/5 of SP
function events.CalcStatBonusByItems(t)
	if (t.Player.Class==const.Class.WarriorMage or t.Player.Class==const.Class.BattleMage or t.Player.Class==const.Class.Archer) and t.Stat == const.Stats.SP then
		for it in t.Player:EnumActiveItems() do
			if it.Bonus==9 then
				t.Result = t.Result/5
			end
		end
	end
end
--[[ JUST TEST CODE
function events.CalcDamageToMonster(t)	
	 data = WhoHitMonster()
	if data.Player.Class==const.Class.WarriorMage then	
		roll=math.random(1,100)
		if roll>1 then
		data.Player.MightBonus=data.Player.MightBonus+(data.Player.LevelBase+10)
		Sleep(1000)
		data.Player.MightBonus=data.Player.MightBonus-(data.Player.LevelBase+10)
		end
	end
end
]]
end