BLOODKNIGHT=SETTINGS["KnightAsBloodKnight"]
if BLOODKNIGHT==true then

--scaling with might
function events.CalcDamageToMonster(t)
	bonusDamage=0
	local data = WhoHitMonster()
		if data.Player and (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and t.DamageKind==0 then	
		might=data.Player:GetMight()
		bonusDamage=might/500
		end
	t.Result=t.Result*(1+bonusDamage)
end
--when above 33% health every attack will cost 8% of hp but will deal 1% more damage for each 1% of missing health
function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and t.DamageKind==0 and data.Object==nil then
	
	--Get Mastery
	mastery=data.Player.Skills[const.Skills.Thievery]
	if mastery>=64 then 
	mastery=mastery-64
	rank=2
	end
	if mastery>=64 then
	mastery=mastery-64
	rank=3
	end
	
	--get hp
	currentHP=data.Player.HP
	totalHP=data.Player:GetFullHP()
		if currentHP>totalHP*0.40 then
		--calculate base HP
		if data.Player.Class==const.Class.Champion then
			baseHP=data.Player.LevelBase*8+30
			else if data.Player.Class==const.Class.Cavalier then
					baseHP=data.Player.LevelBase*6+30
					else if data.Player.Class==const.Class.Knight then
					baseHP=data.Player.LevelBase*4+30
					end
			end
		end

		healthConsumed=baseHP*0.08
		data.Player.HP=data.Player.HP-healthConsumed
		t.Result=t.Result+healthConsumed*(1+mastery*0.1)
		end
		t.Result=t.Result*(1.5-(currentHP/totalHP)*0.5)
	end
end
--When health is below 40% instead of consuming HP your next 3 attacks will heal you by 10% of damage
function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()
		currentHP=data.Player.HP
		vampiricTreshold=data.Player:GetFullHP()*0.40
			if data.Player and (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and currentHP<vampiricTreshold and t.DamageKind==0 and data.Object==nil then
			vampiricAttacks=2
			end
		if data.Player and (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and vampiricAttacks~=nil and vampiricAttacks>0 and t.DamageKind==0 and data.Object==nil then
		vampiricAttacks=vampiricAttacks-1
		data.Player.HP=data.Player.HP+t.Result*(0.1+0.005*mastery)
		end
end

function events.GameInitialized2()
Game.ClassNames[const.Class.Knight]="Blood Knight"
Game.ClassNames[const.Class.Cavalier]="Bloodborn"
Game.ClassNames[const.Class.Champion]="Blood Lord"
Game.ClassKinds.StartingSkills[0][const.Skills.Thievery] = 1
Game.ClassDescriptions[const.Class.Knight] = "The Blood Knight, a warrior class that harnesses the power of their own life force, is a force to be reckoned with on the battlefield. With a fierce focus on high HP and devastating damage output, they charge headfirst into combat, their weapons ablaze with power that draws from their very essence.\nWith each strike, they unleash a torrent of raw power that is fueled by their own vitality, their enemies cowering in fear before the sheer force of their onslaught.\n\nCharacter Stats\nHP per level increases by 4, 6, and 8 points each level.\nEach 5 points invested in Might will increase damage output by 1%.\n\nAbilities:\nWhen above 40% health, each attack will consume 8% of the character's total base HP.\nConsumed health will be converted into damage\nEach 2% of missing health will increase your damage by 1%\nAttacking when below 40% health will cause the character's next three attacks to heal them for 10% of the damage dealt.\n\nMastery\nMastery will increase damage granted by health consumed by 10% and leech by 0.5%."
end	

end

