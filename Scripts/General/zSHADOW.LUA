SHADOW=SETTINGS["SorcererAsShadow"]
NECROMANCER=SETTINGS["SorcererAsNecromancer"]
if NECROMANCER==false then
if SHADOW==true then


function events.GameInitialized2()
Game.ClassNames[const.Class.Sorcerer]="Nethermancer"
Game.ClassNames[const.Class.Wizard]="Shade"
Game.ClassNames[const.Class.ArchMage]="Gloom"
	Game.ClassDescriptions[const.Class.Sorcerer] = "Nethermancers are mages that have delved so deep into the netherdimensions that their being has almost entirely crossed over into those fell worlds. Damage taken is 1% pr mastery (new skill) rank, making shadows almost invulnerable. Damage is reduced by ca 1 pr level. Shadows have very low HP and SP, and cant use armor or weapons. Each point in mastery increase damage taken but also increases damage by ca 0.5 pr level (making shadows strong AOE dealers) and mana regeneration by 1 pr rank. If the party loses all nonshadow members the shadows immediately die as well."
	Game.ClassDescriptions[const.Class.Wizard] = "Nethermancers are mages that have delved so deep into the netherdimensions that their being has almost entirely crossed over into those fell worlds. Damage taken is 1% pr mastery (new skill) rank, making shadows almost invulnerable. Damage is reduced by ca 1 pr level. Shadows have very low HP and SP, and cant use armor or weapons. Each point in mastery increase damage taken but also increases damage by ca 0.5 pr level (making shadows strong AOE dealers) and mana regeneration by 1 pr rank. If the party loses all nonshadow members the shadows immediately die as well."
	Game.ClassDescriptions[const.Class.ArchMage] = "Nethermancers are mages that have delved so deep into the netherdimensions that their being has almost entirely crossed over into those fell worlds. Damage taken is 1% pr mastery (new skill) rank, making shadows almost invulnerable. Damage is reduced by ca 1 pr level. Shadows have very low HP and SP, and cant use armor or weapons. Each point in mastery increase damage taken but also increases damage by ca 0.5 pr level (making shadows strong AOE dealers) and mana regeneration by 1 pr rank. If the party loses all nonshadow members the shadows immediately die as well."

	Game.ClassKinds.StartingSkills[2][const.Skills.Dagger] = 0
	Game.ClassKinds.StartingSkills[2][const.Skills.Leather] = 0
	Game.ClassKinds.StartingSkills[2][const.Skills.Staff] = 0
	Game.ClassKinds.StartingSkills[2][const.Skills.Bow] = 0
	Game.ClassKinds.StartingSkills[2][const.Skills.Light] = 0
	Game.ClassKinds.StartingSkills[2][const.Skills.Dark] = 1
	Game.ClassKinds.StartingSkills[2][const.Skills.Meditation] = 0
	Game.ClassKinds.StartingSkills[2][const.Skills.Perception] = 2

    Game.Classes.HPFactor[const.Class.Sorcerer] = 1
	Game.Classes.SPFactor[const.Class.Sorcerer] = 1
    Game.Classes.HPFactor[const.Class.Wizard] = 1
	Game.Classes.SPFactor[const.Class.Wizard] =1.1
    Game.Classes.HPFactor[const.Class.ArchMage] = 1
	Game.Classes.SPFactor[const.Class.ArchMage] = 1.2
	Game.ClassKinds.SPBase[2] = 10
	Game.ClassKinds.HPBase[2] = 1
end

function events.CalcDamageToPlayer(t)
	if (t.Player.Class==const.Class.ArchMage or t.Player.Class==const.Class.Wizard or t.Player.Class==const.Class.Sorcerer) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0  then
	shadowImmunity=0
		for i = 0, 3 do
			if Party[i].Class~= const.Class.Sorcerer and Party[i].Class~= 7  and Party[i].Class~= 8 then
				if Party[i].Unconscious==0 and Party[i].Dead==0 and Party[i].Eradicated==0 and Party[i].Paralyzed==0 then
					shadowImmunity=shadowImmunity+1
				end
			end
		end
		if shadowImmunity>0 then
--GET MASTERY SKILL
	mastery=t.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end

	modi = t.Player.LevelBase+3
	t.Player.SP=t.Player.SP+t.Result/modi*mastery
	t.Result=t.Result/100*mastery
	Game.ShowStatusText("Absorbed")
	end
end
end


function events.CalcSpellDamage(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.ArchMage or data.Player.Class==const.Class.Wizard or data.Player.Class==const.Class.Sorcerer) then	
		--get Mastery level
	mastery=data.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end

	modik = data.Player.LevelBase
	t.Result = math.max(t.Result - modik^0.7 * (2.5 - 0.5 * mastery), 1)
	end
end

function events.CalcStatBonusByItems(t)
	if (t.Player.Class==const.Class.ArchMage or t.Player.Class==const.Class.Wizard or t.Player.Class==const.Class.Sorcerer) and t.Stat == const.Stats.SP then
	t.Result=t.Result^0.67
	end
end

function events.CalcStatBonusByItems(t)
	if (t.Player.Class==const.Class.ArchMage or t.Player.Class==const.Class.Wizard or t.Player.Class==const.Class.Sorcerer) and t.Stat == const.Stats.HP then
	t.Result=t.Result^0.67
	end
end

function events.Regeneration(t)
--GET MASTERY SKILL
	mastery=t.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end

	v = Party[t.PlayerIndex]
	class = v.Class
	mediFactor = 1
	
	if (class == const.Class.ArchMage) then
	
	ko = v.Eradicated or v.Dead or v.Stoned or v.Paralyzed or v.Unconscious or v.Asleep
	if (ko == 0) then
	cap = v:GetFullSP()
	cur = v.SpellPoints
	gain = (1+mastery^2.25/10)*(cap^0.15-0.4)
	v.SpellPoints = math.min(cap,cur+gain)
end
end
end
end
end
