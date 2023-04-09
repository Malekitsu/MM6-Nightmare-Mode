if SETTINGS["ItemRework"]==true then
function events.GenerateItem(t)
	--get party average level
	partyExperience = 0
	
	for i = 0, 3 do
		partyExperience = partyExperience + Party.Players[i].Experience
	end
	
	averagePlayerExperience = partyExperience / 4
	
	partyLevel = math.floor((1 + math.sqrt(1 + (4 * averagePlayerExperience / 500))) / 2)
	
	--buff if item is weak
	if t.Strength*20<partyLevel then
		roll=math.random(1,t.Strength*20)
		if roll<(partyLevel-t.Strength*20) then
			t.Strength=math.min(t.Strength+1,6)
		end
		
		if partyLevel>t.Strength*20+20 then
		roll=math.random(1,t.Strength*20+20)
			if roll<(partyLevel-(t.Strength*20+20)) then
				t.Strength=math.min(t.Strength+1,6)
			end	
		end
	end
	--nerf if item is strong
	if partyLevel<(t.Strength-3)*20 and t.Strength<7 then
		t.Strength=t.Strength-1
	end
	if (t.Strength-1)*20>partyLevel and t.Strength>2 and t.Strength<7 then
		roll=math.random((t.Strength-3)*20,(t.Strength-2)*20)
		if roll>partyLevel then
			t.Strength=t.Strength-1
		end
	end
end

function events.ItemGenerated(t)	
	if t.Item.Number<=134 then
		t.Handled=true
		
		extraDataProc=math.random(1,100)
		if extraDataProc<=(t.Strength-1)*10 then
			t.Item.ExtraData = math.random(1, 14 * 25)
		end
		
		if t.Item.Bonus2~=0 then
		bonusprocChance=math.random(1,100)
			if bonusprocChance<=40 and t.Strength~=1 or (t.Strength==6 and bonusprocChance<=75) then
				t.Item.Bonus = math.random(0,13)
				local bonuses = {{1, 5}, {3, 8}, {6, 12}, {10, 17}, {15, 25}}
				local bonus = bonuses[t.Strength - 1]
				t.Item.BonusStrength = math.random(bonus[1], bonus[2])
			end
		end
		
		ancient=math.random(1,100)
		if ancient<=t.Strength-3 then
			t.Item.ExtraData=math.random(350,560)
			t.Item.Bonus=math.random(0,13)
			t.Item.BonusStrength=math.random(25,40)
			t.Item.Bonus2=math.random(1,63)
		end
		
		primordial=math.random(1,200)
		if primordial<=t.Strength-4 then
			t.Item.ExtraData=math.random(547,560)
			t.Item.Bonus=math.random(0,13)
			t.Item.BonusStrength=40
			t.Item.Bonus2=math.random(1,63)
			Sleep(1)
			Message("WOW")
		end	
	end
end



function events.CalcStatBonusByItems(t)
	for it in t.Player:EnumActiveItems() do
		if it.ExtraData ~= nil then
			stat=it.ExtraData%14
			bonus=math.ceil(it.ExtraData/14)
				if t.Stat==stat then
				t.Result = t.Result + bonus
				end				
		end
	end
end

end
