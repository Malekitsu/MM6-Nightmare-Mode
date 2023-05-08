function genericTransform(level)
    return function(mon)
		oldlevel=mon.Level
		if mon.Id ==124 then
			oldlevel=25
			else if mon.Id == 125 then
				oldlevel=30
				else if mon.Id == 126 then
				oldlevel=35
				end
			end
		end
		mon.Level=level
        mon.FullHitPoints = level*(level+30)/10*2
		if SETTINGS["ItemRework"]==true and SETTINGS["StatsRework"]==true then
			mon.FullHitPoints = mon.FullHitPoints * (1+level/200) 
			statMul=((level^1.5-1)/1000+1)/((oldlevel^1.5-1)/1000+1)
			mon.Attack1.DamageDiceCount=mon.Attack1.DamageDiceCount*statMul
			mon.Attack1.DamageAdd=math.min(mon.Attack1.DamageAdd*statMul,255)
			mon.Attack2.DamageDiceCount=mon.Attack2.DamageDiceCount*statMul
			mon.Attack2.DamageAdd=math.min(mon.Attack1.DamageAdd*statMul,255)
			local s, m = SplitSkill(mon.SpellSkill)
			mon.SpellSkill=JoinSkill(math.min(s * statMul,60), m)
			--fix to fix monster getting upgraded
			mon.Ally = 2
		end
		
		--damage buff coefficient
		mult=level/oldlevel
		mult=mult*(level/20+1.75)/(oldlevel/20+1.75)
		check1=mon.Attack1.DamageDiceCount * mult
			if check1<250 then
			mon.Attack1.DamageDiceCount=mon.Attack1.DamageDiceCount * mult
			else if check1>250 then
				mon.Attack1.DamageDiceCount=250
				mon.Attack1.DamageDiceSides=mon.Attack1.DamageDiceSides*(1+(check1-250)/250)
				end
			end
		check2=mon.Attack2.DamageDiceCount * mult
			if check2<250 then
			mon.Attack2.DamageDiceCount=mon.Attack2.DamageDiceCount * mult
			else if check2>250 then
				mon.Attack2.DamageDiceCount=250
				mon.Attack2.DamageDiceSides=mon.Attack2.DamageDiceSides*(1+(check2-250)/250)		
				end
			end
		local s, m = SplitSkill(mon.SpellSkill)
			mon.SpellSkill=JoinSkill(math.min(s * mult,60), m)		
		mon.HP=mon.FullHitPoints
		mon.Experience=level^1.8+level*20
		mon.ArmorClass=level
		

    end
end

--[[EXAMPLE LINE
pseudoSpawnpoint{monster = 40, x = 3224, y = 3623, z = 0, count = 6, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(200)(mon) end}
pseudoSpawnpoint{monster = 40, x = 3224, y = 3623, z = 0, count = 6, powerChances = {100, 0, 0}, radius = 256, group = 255, transform = function(mon) genericTransform(100)(mon); mon.Level=150 end}
transform = function(mon) genericTransform(100)(mon); mon.Level=150 end
--]]