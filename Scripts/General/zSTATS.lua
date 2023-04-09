if SETTINGS["StatsRework"]==true then
function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()	
	--might bonus
		if t.DamageKind==0 and data.Object==nil then
		might=data.Player:GetMight()
		damageBonus=might/500		
		t.Result=t.Result*(1+damageBonus)
		end
	--luck/accuracy bonus	
		luck=data.Player:GetLuck()
		accuracy=data.Player:GetAccuracy()
		critDamage=accuracy/250
		critChance=5+luck/10
		roll=math.random(1, 100)
		if roll <= critChance then
			t.Result=t.Result*(1.5+critDamage)
		end
end

--speed
function events.CalcDamageToPlayer(t)
	speed=t.Player:GetSpeed()
	speedEffect=speed/5
	dodgeChance=(1-0.995^speedEffect)*100
		roll=math.random(1, 100)
		if roll<=dodgeChance then
			t.Result=0
			--Game.ShowStatusText("Evaded")
			evt.FaceExpression{Player = t.PlayerIndex, Frame = 33}
		end
end

--intellect/personality
function events.CalcSpellDamage(t)
	local data = WhoHitMonster()	
	intellect=data.Player:GetIntellect()	
	personality=data.Player:GetPersonality()
	bonus=math.max(intellect,personality)
	t.Result=t.Result*(1+bonus/500)
end
end