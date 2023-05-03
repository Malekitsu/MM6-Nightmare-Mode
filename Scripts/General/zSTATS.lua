if SETTINGS["StatsRework"]==true then
function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()	
	--might bonus
		if t.DamageKind==0 and (data.Object==nil or data.Object.Spell==100) then
		might=data.Player:GetMight()
		damageBonus=might/500		
		t.Result=t.Result*(1+damageBonus)
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
function events.GameInitialized2()
Game.StatsDescriptions[0]= "Might is the statistic that represents a character's overall strength, and the ability to put that strength where it counts.  Characters with a high might statistic do more damage in combat.\n\nEvery 5 point in might will increase damage by 1 point and 1% of total melee damage"
Game.StatsDescriptions[1]="Intellect represents a character's ability to reason and understand complex, abstract concepts.  A high intellect contributes to Sorcerer, Archer, and Druid spell points.\n\nEvery 5 point in intellect will increase spell damage and healing by 1%. If personality is higher, personality will be used instead"
Game.StatsDescriptions[2]="Personality represents both a character's strength of will and personal charm.  Clerics, Paladins, and Druids depend on personality for their spell points.\n\nEvery 5 point in personality will increase spell damage and healing by 1%. If intellect is higher, intellect will be used instead"
Game.StatsDescriptions[3]="Endurance is a measure of the physical toughness and durability of a character.  A high endurance gives a character more hit points and less knockback when receiving hits.\n\nEvery 5 point in endurance will increase your Hit Points by 1%"
Game.StatsDescriptions[4]="Accuracy represents a character's precision and hand-eye coordination.  A high accuracy will allow a character to hit monsters more frequently in combat.\n\nEvery 5 point in accuracy will increase Critical Damage by 2%. Base Critical Damage is 150%"
Game.StatsDescriptions[5]="Speed is a measure of how quick a character is.  A high speed statistic will increase a character's armor class and the rate with which the character recovers from attacks.\n\nEvery 5 point in speed will grant 0.5% chance to Dodge incoming damage. Effect is multiplicative."
Game.StatsDescriptions[6]="Luck has a subtle influence throughout the game, but is most visible in the ability of a character to resist magical attacks and avoid taking (as much) damage from traps.\n\nEvery 5 point in luck will increase critical chance by 0.5%."


end
end
