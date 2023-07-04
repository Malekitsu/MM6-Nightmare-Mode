function events.AfterLoadMap()	
	function events.MonsterSpriteScale(t)
		if t.Monster.Name~=Game.MonstersTxt[t.Monster.Id].Name then				
			t.Scale=t.Scale*1.35	
		end
	end
end