--[[
function events.MonsterSpriteScale(t)
	if t.Monster.Name~=Game.MonstersTxt[t.Monster.Id].Name then
	--check for mm6 hd
		if Game.SFTBin[1].Scale==65536 then
			t.Scale=t.Scale*1.40
		else
			t.Scale=t.Scale*0.7
		end
	end
end
]]
