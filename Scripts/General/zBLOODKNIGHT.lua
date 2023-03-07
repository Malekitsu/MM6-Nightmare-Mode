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
	currentHP=data.Player.HP
	totalHP=data.Player:GetFullHP()
	if data.Player and (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and currentHP>totalHP*0.33 and t.DamageKind==0 then
	data.Player.HP=data.Player.HP-data.Player.HP*0.08
	t.Result=t.Result*(2-(currentHP/totalHP))
    end
end
--When health is below 33% instead of consuming HP your next 3 attacks will heal you by 10% of damage
function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()
		currentHP=data.Player.HP
		vampiricTreshold=data.Player:GetFullHP()*0.33
			if data.Player and (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and currentHP<vampiricTreshold and t.DamageKind==0 then
			vampiricAttacks=3
			end
		if data.Player and (data.Player.Class==const.Class.Champion or data.Player.Class==const.Class.Cavalier or data.Player.Class==const.Class.Knight) and vampiricAttacks~=nil and vampiricAttacks>0 and t.DamageKind==0 then
		vampiricAttacks=vampiricAttacks-1
		data.Player.HP=data.Player.HP+t.Result*0.1
		end
end

end