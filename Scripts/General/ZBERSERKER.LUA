BERSERKER=SETTINGS["PaladinAsBerseker"]
if BERSERKER==true then
--adds 15 SP when attacking and not insane
function events.CalcDamageToMonster(t)	
local data = WhoHitMonster()	
	if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and data.Player.Insane==0 and t.DamageKind==0 then
		if data.Player.SP<0 then
			data.Player.SP=0
		end
		data.Player.SP=data.Player.SP+15
	end
end
--scales with might
function events.CalcDamageToMonster(t)
local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and t.DamageKind==0 then
		might=data.Player:GetMight()
		bonusDamage=might/500
		t.Result=t.Result*(1+bonusDamage)
	end
	
end
--when insane deals 50% extra damage and attack will consume 10 sp, when no SP insane will be removed
function events.CalcDamageToMonster(t)	
local data = WhoHitMonster()	
	if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and data.Player.Insane==1 and t.DamageKind==0 then
		t.Result=t.Result*1.5
		data.Player.HP=data.Player.HP+t.Result*0.1
		data.Player.SP=data.Player.SP-10
		if data.Player.SP<1 then
		data.Player.Insane=0
		end
	end
end

--when 100 or above SP you have 50% to get insane
function events.CalcDamageToMonster(t)	
local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.Hero or data.Player.Class==const.Class.Crusader or data.Player.Class==const.Class.Paladin) and data.Player.Insane==0 and data.Player.SP>=100 and t.DamageKind==0 then
		if math.random(1,100)>50 then
			data.Player.Insane=1
		end
	end
end


--No light, SP base to 100 and factor to 0
function events.GameInitialized2()
	Game.ClassKinds.StartingSkills[3][const.Skills.Light] = 0
	Game.ClassKinds.StartingSkills[3][const.Skills.Plate] = 0
	Game.Classes.SPFactor[const.Class.Paladin] = 0
	Game.Classes.SPFactor[const.Class.Crusader] = 0
	Game.Classes.SPFactor[const.Class.Hero] = 0
	Game.ClassKinds.SPBase[3] = 100
end
--Mana items will only account for 1/5 of the effect
function events.CalcStatBonusByItems(t)
	if (t.Player.Class==const.Class.Paladin or t.Player.Class==const.Class.Crusader or t.Player.Class==const.Class.Hero) and t.Stat == const.Stats.SP then
		for it in t.Player:EnumActiveItems() do
			if it.Bonus==9 then
				t.Result = t.Result/5
			end
		end
	end
end

end