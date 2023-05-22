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

function events.CalcDamageToPlayer(t)
	if t.DamageKind==0 then 
	AC=t.Player:GetArmorClass()
	t.Result=t.Result/(math.max(AC^0.85/100+0.5,1))
	end
end

function events.GameInitialized2()
Game.StatsDescriptionsRework={}
Game.StatsDescriptionsRework[0]= "Might is the statistic that represents a character's overall strength, and the ability to put that strength where it counts.  Characters with a high might statistic do more damage in combat.\n\nEvery 5 point in might will increase damage by 1 point and 1% of total melee damage"
Game.StatsDescriptionsRework[1]="Intellect represents a character's ability to reason and understand complex, abstract concepts.  A high intellect contributes to Sorcerer, Archer, and Druid spell points.\n\nEvery 5 point in intellect will increase spell damage and healing by 1%. If personality is higher, personality will be used instead"
Game.StatsDescriptionsRework[2]="Personality represents both a character's strength of will and personal charm.  Clerics, Paladins, and Druids depend on personality for their spell points.\n\nEvery 5 point in personality will increase spell damage and healing by 1%. If intellect is higher, intellect will be used instead"
Game.StatsDescriptionsRework[3]="Endurance is a measure of the physical toughness and durability of a character.  A high endurance gives a character more hit points and less knockback when receiving hits.\n\nEvery 5 point in endurance will increase your Hit Points by 1%"
Game.StatsDescriptionsRework[4]="Accuracy represents a character's precision and hand-eye coordination.  A high accuracy will allow a character to hit monsters more frequently in combat.\n\nEvery 5 point in accuracy will increase Critical Damage by 2%."
Game.StatsDescriptionsRework[5]="Speed is a measure of how quick a character is.  A high speed statistic will increase a character's armor class and the rate with which the character recovers from attacks.\n\nEvery 5 point in speed will grant 0.5% chance to Dodge incoming damage. Effect is multiplicative."
Game.StatsDescriptionsRework[6]="Luck has a subtle influence throughout the game, but is most visible in the ability of a character to resist magical attacks and avoid taking (as much) damage from traps.\n\nEvery 5 point in luck will increase critical chance by 0.5%."

end

--STATS TOOLTIPS

local newCode = mem.asmpatch(0x41330E, [[
	nop
	nop
	nop
	nop
	nop
	cmp edx,0x19
	ja absolute 0x41386E
]])

mem.hook(newCode, function(d)
	local t = {Stat = d.edx}
	events.call("ShowStatDescription", t)
end)

mem.autohook(0x41386E, function(d)
	events.call("AfterShowStatDescription")
end)

function events.ShowStatDescription(t)
	if t.Stat==0 then
	i=Game.CurrentPlayer
	might=Party[i]:GetMight()
	Game.StatsDescriptions[0]=string.format("%s\n\nBonus Meele/Bow Damage: %s%s",Game.StatsDescriptionsRework[0],might/5,"%")
	end
	if t.Stat==1 then
	i=Game.CurrentPlayer
	meditation=Party[i].Skills[25]%64
	fullSP=Party[i]:GetFullSP()
	SPregenItem=0
	bonusregen=0
	for it in Party[i]:EnumActiveItems() do
		if it.Bonus2 == 38 or it.Bonus2==47 or it.Bonus2==55 then		
			SPregenItem=SPregenItem+1
			bonusregen=1
		end
	end
	SPregenItem=SPregenItem+bonusregen
	regen=math.ceil((fullSP^0.5 * meditation^2/400)+fullSP*SPregenItem*0.005)
	personality=Party[i]:GetPersonality()
	intellect=Party[i]:GetIntellect()
	Game.StatsDescriptions[1]=string.format("%s\n\nBonus magic damage/healing: %s%s\n\nCritical spell strike damage/healing: %s%s\n\nSpell point regen per 10 seconds: %s",Game.StatsDescriptionsRework[1],intellect/5,"%",intellect/5+150,"%",regen)
	end
	if t.Stat==2 then
	i=Game.CurrentPlayer
	meditation=Party[i].Skills[25]%64
	fullSP=Party[i]:GetFullSP()
	SPregenItem=0
	bonusregen=0
	for it in Party[i]:EnumActiveItems() do
		if it.Bonus2 == 38 or it.Bonus2==47 or it.Bonus2==55 then		
			SPregenItem=SPregenItem+1
			bonusregen=1
		end
	end
	SPregenItem=SPregenItem+bonusregen
	regen=math.ceil((fullSP^0.5 * meditation^2/400)+fullSP*SPregenItem*0.005)
	personality=Party[i]:GetPersonality()
	Game.StatsDescriptions[2]=string.format("%s\n\nBonus magic damage/healing: %s%s\n\nCritical spell strike damage/healing: %s%s\n\nSpell point regen per 10 seconds: %s",Game.StatsDescriptionsRework[2],personality/5,"%",personality/5+150,"%",regen)
	end
	if t.Stat==3 then
	i=Game.CurrentPlayer
	endurance=Party[i]:GetEndurance()
	HPScaling=Game.Classes.HPFactor[Party[i].Class]
	
	m=math.ceil(Party[i].Skills[const.Skills.Bodybuilding]/64)
	s=Party[i].Skills[const.Skills.Bodybuilding]%64
	BBHP=s^2-4*s+s*m*HPScaling
	
	level=Party[i]:GetLevel()
	BASEHP=Game.ClassKinds.HPBase[i%3]+level*HPScaling
	
	Game.StatsDescriptions[3]=string.format("%s\n\nHealth bonus from Endurance: %s%s\n\nFlat HP bonus from endurance: %s\n\nBonus HP from Body building: %s\n\nBase HP: %s",Game.StatsDescriptionsRework[3],endurance/5,"%",math.floor(endurance/5)*HPScaling, BBHP,BASEHP)
	end
	if t.Stat==4 then
	i=Game.CurrentPlayer
	accuracy=Party[i]:GetAccuracy()
	Game.StatsDescriptions[4]=string.format("%s\n\nCritical melee and bow strike damage bonus: %s%s",Game.StatsDescriptionsRework[4],accuracy/2.5+150,"%")
	end
	if t.Stat==5 then
	i=Game.CurrentPlayer
	speed=Party[i]:GetSpeed()
	ac=Party[i]:GetArmorClass()
	Game.StatsDescriptions[5]=string.format("%s\n\nDodge chance: %s%s\n\nPhysical damage reduction from AC: %s%s",Game.StatsDescriptionsRework[5],math.floor(1000-0.995^(speed/5)*1000)/10,"%",math.round(1000-1000/math.max(ac^0.85/100+0.5,1))/10,"%")
	end
	if t.Stat==6 then
	i=Game.CurrentPlayer
	luck=Party[i]:GetLuck()
	Game.StatsDescriptions[6]=string.format("%s\n\nCritical strike chance: %s%s",Game.StatsDescriptionsRework[6],luck/10+5,"%")
	end
end

function events.AfterShowStatDescription()
	
end



end


