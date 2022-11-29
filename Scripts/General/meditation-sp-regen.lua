-- Add a bit of sp regeneration by meditation skill

function regenAutoRepair(player, item)
	r,m = SplitSkill(player.Skills[const.Skills.Repair])
	cap = r * m
	generic = item.T(item)
	diff = generic.IdRepSt
	if (cap >= diff) then
		item.Broken = false
	end
end

function calculateMeditationSPRegen(rank, mastery, fullSP)
	scaled = math.ceil(fullSP^0.5 * rank^2/400)
	return math.floor(scaled)
end

function events.Regeneration(t)
	v = Party[t.PlayerIndex]
	class = v.Class
	mediFactor = 1
	if (class == const.Class.Hero) or (class == const.Class.WarriorMage)
	then
		mediFactor = 3/2
	end
	
	ko = v.Eradicated or v.Dead or v.Stoned or v.Paralyzed or v.Unconscious or v.Asleep
	if (ko == 0) then
		for k=1, v.Items.High do
			if (v.Items[k].Broken == true) then
				regenAutoRepair(v,v.Items[k])
			end
		end
	end

	r,m = SplitSkill(v.Skills[const.Skills.Meditation])
	cap = v:GetFullSP()
	cur = v.SpellPoints
	gain = t.SP + (calculateMeditationSPRegen(r, m, cap) * mediFactor)
	v.SpellPoints = math.min(cap,cur+gain)
end
