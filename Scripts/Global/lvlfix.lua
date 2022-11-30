-- AC FIX
function calculateMonsterArmor(monsterArray)
	oldArmor = monsterArray["ArmorClass"]
	newArmor = math.round(oldArmor * (1 + (100 - oldArmor) / 100)) * baseArmorMultiplier
	return math.max(newArmor, oldArmor)
end

--LEVEL FIX

for monsterTxtIndex = 1,Game.MonstersTxt.high,1 do
local monsterTxt = Game.MonstersTxt[monsterTxtIndex]
	local monsterLevel = monsterTxt.Level
	monsterLevel = math.round(monsterLevel * (1 + (100 - monsterLevel) / 100)) 
	monsterTxt.Level = monsterLevel
end