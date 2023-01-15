
Game.MapEvtLines:RemoveEvent(13)
evt.hint[13] = evt.str[4]  -- "Cabinet"
evt.map[13] = function()
	if not evt.Cmp("QBits", 51) then         -- 51 T4, Given when characters find Silver Chalice.
		evt.Set("QBits", 51)         -- 51 T4, Given when characters find Silver Chalice.
		Message("Looks like there is no chalice here, but just a bunch of armors")         -- "Sacred Chalice"
		evt.Set("QBits", 188)         -- Quest item bits for seer
	elseif not evt.Cmp("MapVar4", 1) then
		evt.GiveItem{Strength = 4, Type = const.ItemType.Sword, Id = 0}
		evt.GiveItem{Strength = 4, Type = const.ItemType.Armor_, Id = 0}
		evt.GiveItem{Strength = 4, Type = const.ItemType.Shield_, Id = 0}
		evt.Set("MapVar4", 1)
	end
end
