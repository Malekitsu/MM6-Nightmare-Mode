
EM=SETTINGS["EqualizedMode"]
if EM==true then
	function events.CalcDamageToMonster(t)	
		local data = WhoHitMonster()
		if data and data.Player then
			local PL = data.Player.LevelBase
			local ML = t.Monster.Level
			if PL > ML then
				t.Result=t.Result*(2+ML)/(2+PL)
			elseif ML > PL then
				t.Result=t.Result*(0.5+(2+ML)/(2+PL)/2)
			end
		end
	end

function events.CalcDamageToPlayer(t)

data=WhoHitPlayer()
--if data.monster then
if WhoHitPlayer() ~= nil then
if not data.Monster then return end
if (data ~= nil and data ~= '') then
if (data.Monster.Level ~= nil  and data.Monster.Level ~= '' and data.Monster.Level ~= "0" and data.Monster~= nil) then

	local ML = data.Monster.Level
	local data = WhoHitPlayer()
	local PL = t.Player.LevelBase

if PL > ML then
t.Result=t.Result*(2+PL)/(2+ML)
elseif ML > PL then
t.Result=t.Result*(0.5+(2+PL)/(2+ML)/2)
end
--end
end
end
end
end
end
