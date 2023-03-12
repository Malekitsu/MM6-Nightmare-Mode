SERAPHIN=SETTINGS["ClericAsSeraphin"]
if SERAPHIN==true then

--light magic will increase damage done melee
function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.HighPriest or data.Player.Class==const.Class.Priest or data.Player.Class==const.Class.Cleric) and t.DamageKind==0 and data.Object==nil then
		mastery=data.Player.Skills[const.Skills.Light]
		rankBonus=1
		if mastery>=64 then 
		mastery=mastery-64
		rankBonus=1.5
		end
		if mastery>=64 then
		mastery=mastery-64
		rankBonus=2
		end
		t.Result=t.Result+2*mastery*rankBonus
	end
end



--body magic will increase healing done on attack
function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.HighPriest or data.Player.Class==const.Class.Priest or data.Player.Class==const.Class.Cleric) and t.DamageKind==0 and data.Object==nil then
		--get body
		body=data.Player.Skills[const.Skills.Body]
		rankBonus=1
		if body>=64 then 
		body=body-64
		rankBonus=1.25
		end
		if body>=64 then
		body=body-64
		rankBonus=1.5
		end
		--get mastery
		mastery=data.Player.Skills[const.Skills.Thievery]
		if mastery>=64 then 
		mastery=mastery-64
		end
		if mastery>=64 then
		mastery=mastery-64
		end
		
		--bunch of code for healing most injured player
		function indexof(table, value)
		for i, v in ipairs(table) do
		if v == value then
		return i
		end
		end
		return nil
		end

		-- Define the variables
		if Party[0].Dead==0 and Party[0].Eradicated==0 then
		a = Party[0].HP/Party[0]:GetFullHP()
		else 
		a=2
		end
		if Party[1].Dead==0 and Party[1].Eradicated==0 then
		b = Party[1].HP/Party[1]:GetFullHP()
		else
		b=2
		end
		if Party[2].Dead==0 and Party[2].Eradicated==0 then
		c = Party[2].HP/Party[2]:GetFullHP()
		else
		c=2
		end
		if Party[3].Dead==0 and Party[3].Eradicated==0 then
		d = Party[3].HP/Party[3]:GetFullHP()
		else
		d=2
		end

		-- Find the maximum value and its position
		min_value = math.min(a, b, c, d)
		min_index = indexof({a, b, c, d}, min_value)
		min_index = min_index - 1
		--Calculate heal value and apply
		healValue=2*body*rankBonus*(1+mastery*0.05)
		evt[min_index].Add("HP",healValue)		
		--bug fix
		if Party[min_index].HP>0 then
		Party[min_index].Unconscious=0
		end
	end
		
end

--light and mastery increases melee damage

function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.HighPriest or data.Player.Class==const.Class.Priest or data.Player.Class==const.Class.Cleric) and t.DamageKind==0 and data.Object==nil then
		--get light
		light=data.Player.Skills[const.Skills.Light]
		rankBonus=1
		if light>=64 then 
		light=light-64
		rankBonus=1.5
		end
		if light>=64 then
		light=light-64
		rankBonus=2
		end
		--get mastery
		mastery=data.Player.Skills[const.Skills.Thievery]
		if mastery>=64 then 
		mastery=mastery-64
		end
		if mastery>=64 then
		mastery=mastery-64
		end
		t.Result=t.Result+2*light*rankBonus*(1+mastery*0.1)
		end
end

--Scales with might and personality (10 stat=1% damage)
function events.CalcDamageToMonster(t)
	local data = WhoHitMonster()
	if data.Player and (data.Player.Class==const.Class.HighPriest or data.Player.Class==const.Class.Priest or data.Player.Class==const.Class.Cleric) and t.DamageKind==0 and data.Object==nil then
			might=data.Player:GetMight()
			personality=data.Player:GetPersonality()
			bonusDamage=might/1000 + personality/1000
			t.Result=t.Result*(1+bonusDamage)
		end
end

--AUTORESS SKILL
function events.CalcDamageToPlayer(t)
	if (t.Player.Class==const.Class.HighPriest or t.Player.Class==const.Class.Priest or t.Player.Class==const.Class.Cleric) and t.Player.Unconscious==0 and t.Player.Dead==0 and t.Player.Eradicated==0  and ressed~=1 then
		if t.Result>=t.Player.HP then
			totMana=t.Player:GetFullSP()
			currentMana=t.Player.SP
			treshold=totMana/4
			if currentMana>treshold then
			t.Player.SP=t.Player.SP-(totMana/4)
			--calculate healing
			mastery=t.Player.Skills[const.Skills.Thievery]
				if mastery>=64 then 
				mastery=mastery-64
				end
				if mastery>=64 then
				mastery=mastery-64
				end
				t.Player.HP=t.Player.HP+(totMana/4)*(1+mastery*0.05)
			
--			ressed=1
--			Sleep(16000)
			ressed=0

			end
		end	
	end
end




function events.GameInitialized2()
Game.ClassKinds.StartingSkills[1][const.Skills.Plate] = 3
Game.ClassKinds.StartingSkills[1][const.Skills.Light] = 1
Game.ClassKinds.StartingSkills[1][const.Skills.Sword] = 1
Game.ClassKinds.StartingSkills[1][const.Skills.Leather] = 3
Game.ClassKinds.StartingSkills[1][const.Skills.Chain] = 2
Game.ClassKinds.StartingSkills[1][const.Skills.Mace] = 3
Game.ClassKinds.StartingSkills[1][const.Skills.Thievery] = 1
Game.ClassKinds.StartingSkills[1][const.Skills.Dark] = 0

    Game.Classes.HPFactor[const.Class.Cleric] = 3
	Game.Classes.SPFactor[const.Class.Cleric] = 2
	Game.Classes.HPFactor[const.Class.Priest] = 4
	Game.Classes.SPFactor[const.Class.Priest] = 3
	Game.Classes.HPFactor[const.Class.HighPriest] = 5
	Game.Classes.SPFactor[const.Class.HighPriest] = 4
--LORE BONUS Seraphin are blessed with divine powers, giving him +20 starting hp and +10 mana and light skill
	Game.ClassKinds.HPBase[1] = 40
	Game.ClassKinds.SPBase[1] = 20

Game.ClassNames[const.Class.Cleric]="Seraphin"
Game.ClassNames[const.Class.Priest]="Angel"
Game.ClassNames[const.Class.HighPriest]="Archangel"
Game.ClassDescriptions[const.Class.Cleric] = "Seraphin is a divine warrior, blessed by the gods with otherworldly powers that set him apart from mortal fighters. His origins are shrouded in mystery, but it is said that he was chosen by the divine to carry out their will on the mortal plane. Some whisper that he was born from the union of a mortal and an angel, while others believe that he was created by the gods themselves. Regardless of his origins, there is no denying the power that Seraphin wields, and his presence on the battlefield is a testament to the will of the divine.\n\nStats:\n+20 starting HP and +10 mana points\n\nProficiency in Plate, Sword, Mace, and Shield (offhand must be disabled)\n3-4-5 HP and 2-3-4 mana points\ngained per level\nDamage scaling based on Might and Personality (each 10 points adds 1% damage)\n\nAbilities:\nDivine Attacks that deal extra damage based on Light skill (2-3-4 damage added per point in Light at Novice/Expert/Master, increased by 10% per mastery point)\nAttacking will heal the most injured party member based on Body skill (2-2.5-3 points per point in Body at Novice/Expert/Master, increased by 5% per mastery point)\nDivine Protection that converts up to 25% of mana into self-healing when facing lethal attacks (increased by 5% per mastery point)."

end

end
