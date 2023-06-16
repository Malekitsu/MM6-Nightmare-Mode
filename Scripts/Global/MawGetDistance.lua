--get distance by Malekith

function getMonstersInRange(X,Y,Z,range)
	local monstersInRange = {}
	for i = 0, Map.Monsters.high do
		local X2, Y2, Z2 = XYZ(Map.Monsters[i])
		if X2<range and Y2<range and Z2<range and Map.Monsters[i].AIState ~= const.AIState.Dead and Map.Monsters[i].AIState ~= const.AIState.Removed then
			local distance = ((X2 - X)^2 + (Y2 - Y)^2 + (Z2 - Z)^2)^0.5
			if distance <= range and distance>0.005 then
				table.insert(monstersInRange,i)
			end
		end
	end
	return monstersInRange
end


--set reference coord and desired range
function getClosestMonsterInRange(X,Y,Z,range)
	local closestMonster = nil
	local closestDistance = math.huge
	for i=0,Map.Monsters.high do
		distance=range+1
		local X2, Y2, Z2 = XYZ(Map.Monsters[i])
		if X2<range and Y2<range and Z2<range and Map.Monsters[i].HP>0 then
		distance=((X-X2)^2+(Y-Y2)^2+(Z-Z2)^2)^0.5
		end
		if distance <= range and distance < closestDistance and distance>0.005 then
			closestMonster = i
			closestDistance = distance
		end
	end
	--will return as monster index
	return closestMonster
end