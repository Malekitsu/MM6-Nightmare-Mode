
local npc = 399
Game.NPC[399].House=169
Game.NPC[399].Pic=616
Game.NPC[399].Name="The Master"
NPCTopic {
    NPC = npc,
    Slot = 0, -- adjust slot here
    Branch = "", -- initial branch after entering npc dialog if there is no persisted one
    Ungive = function() -- run on topic click
        QuestBranch("doRespec") -- switch to actual respec branch (topic and code)
    end,
    Texts = {   
        Topic = "Respec",
        Ungive = "Do you want to reset all your learned skills (with a fee)?",
    },
}

vars.respecs = vars.respecs or {}

local function calcGoldCost(p)
    cost=0
	for i=0, p.Skills.High do
		skill=p.Skills[i]%64
		refund=math.max(skill*(skill+1)/2-1,0)
		cost=cost+refund
	end
	cost=cost*50
	return cost
end

local function respec(player)
vars.oldPlayerMasteries=vars.oldPlayerMasteries or {}
	vars.oldPlayerMasteries[player]={}
	respecMastery(player)
	refund=0
	p=Party[player]
	for i=0, p.Skills.High do
		if i==21 or i==22 or i==23 or i==26 or i==27 or i==29 then
			goto continue
		end
		skill=p.Skills[i]%64
		if skill>1 then
			if i==0 or i==3 or i==4 or i==6 then
				skill=math.max(p.Skills[0]%64,p.Skills[3]%64,p.Skills[4]%64,p.Skills[6]%64)
				refund=skill*(skill+1)/2-1
				if p.Skills[0]>0 then
				p.Skills[0] = 1
				end
				if p.Skills[3]>0 then
				p.Skills[3] = 1
				end
				if p.Skills[4]>0 then
				p.Skills[4] = 1
				end
				if p.Skills[6]>0 then
				p.Skills[6] = 1
				end
				p.SkillPoints=p.SkillPoints+refund
			elseif i==1 or i==2 then
				skill=math.max(p.Skills[1]%64,p.Skills[2]%64)
				refund=skill*(skill+1)/2-1
				if p.Skills[1]>0 then
					p.Skills[1] = 1
				end
				if p.Skills[2]>0 then
					p.Skills[2] = 1
				end
				p.SkillPoints=p.SkillPoints+refund
			elseif i==5 or i==7 then
				skill=math.max(p.Skills[5]%64,p.Skills[7]%64)
				refund=skill*(skill+1)/2-1
				if p.Skills[5]>0 then
					p.Skills[5] = 1
				end
				if p.Skills[7]>0 then
					p.Skills[7] = 1
				end
				p.SkillPoints=p.SkillPoints+refund
			elseif i==9 or i==10 or i==11 then
				skill=math.max(p.Skills[9]%64,p.Skills[10]%64,p.Skills[11]%64)
				refund=skill*(skill+1)/2-1
				if p.Skills[9]>0 then
					p.Skills[9] = 1
				end
				if p.Skills[10]>0 then
					p.Skills[10] = 1
				end
				if p.Skills[11]>0 then
					p.Skills[11] = 1
				end
				p.SkillPoints=p.SkillPoints+refund
			elseif i>=12 and i<=20 then
				lastSkill=2
				--reset mastery
				for i=12,20 do
					p.Skills[i]=p.Skills[i]%64
				end	
				while lastSkill>1 do
					maxSkill=0
					count=1	
					for v=12,20 do
						if p.Skills[v]>maxSkill then
							maxSkill = p.Skills[v]
							maxIndex=v
							count=1
						elseif p.Skills[v]==maxSkill then
							count=count+1
						end
					end
					lastSkill=maxSkill
					refund=math.ceil(maxSkill/count)
					if lastSkill>1 then
						p.SkillPoints=p.SkillPoints+refund
						p.Skills[maxIndex]=p.Skills[maxIndex]-1
					end
				end
			else
				refund=skill*(skill+1)/2-1
				--reset to 1 and reset skill points
				if p.Skills[i]>0 then
					p.Skills[i]=1
				end
				p.SkillPoints=p.SkillPoints+refund
			end
		end
		::continue::
	end
end

function respecMastery(player)
	p=Party[player]
	for i=0, p.Skills.High do
		vars.oldPlayerMasteries[player][i]=math.floor(p.Skills[i]/64)
	end
end


function relearnMasteries(player)
for v=1,2 do
	p=Party[player]
	for i=0, p.Skills.High do
		if p.Skills[i]>=skillRequirementsExpert[i] and p.Skills[i]<12 then
			p.Skills[i]=p.Skills[i]+math.min(vars.oldPlayerMasteries[player][i],1)*64
		elseif  p.Skills[i]>=skillRequirementsMaster[i] and p.Skills[i]<64 then
			p.Skills[i]=p.Skills[i]+vars.oldPlayerMasteries[player][i]*64
		elseif  p.Skills[i]>=skillRequirementsMaster[i]+64 and p.Skills[i]<128 then
			p.Skills[i]=p.Skills[i]+math.max(vars.oldPlayerMasteries[player][i]-1,0)*64			
		end
	end
end
end

Quest {
    Name = "respecQuest", -- means it's part of above quest
    NPC = npc,
    Slot = 0,
    Branch = "doRespec", -- only show if respec topic was clicked
    NeverGiven = true, -- skip given state
    NeverDone = true, -- quest completable multiple times
    GetTopic = function()
        return string.format("Respec for %d gold", calcGoldCost(Party[Game.CurrentPlayer]))
    end,
    CheckDone = function()
        return Party.Gold >= calcGoldCost(Party[Game.CurrentPlayer])
    end,
    Done = function()
        Party.Gold = Party.Gold - calcGoldCost(Party[Game.CurrentPlayer])
        QuestBranch"" -- return to "respec" topic
        respec(Game.CurrentPlayer)
        vars.respecs[Game.CurrentPlayer] = true
    end,
    Texts = {
        Undone = "You don't have enough gold.",
        Done = "Skills are reset. Enjoy building your character again."
    }
}

NPCTopic {
    "Relearn masteries",
    NPC = npc,
    Slot = 1,
    NeverDone = true,
    NeverGiven = true,
    CheckDone = function()
        return vars.respecs[Game.CurrentPlayer] == true
    end,
    Done = function()
        relearnMasteries(Game.CurrentPlayer)
    end,
    Texts = {
        Done = "Masteries have been restored.",
        Undone = "You haven't performed respec yet.",
    }
}



--skill requirements
skillRequirementsExpert={}
for i=0,30 do
	skillRequirementsExpert[i]=4
end
skillRequirementsExpert[1]=6
skillRequirementsExpert[2]=6
skillRequirementsExpert[3]=6
skillRequirementsExpert[4]=6
skillRequirementsExpert[6]=6

skillRequirementsMaster={}
for i=0,30 do
	skillRequirementsMaster[i]=7
end
skillRequirementsMaster[0]=8
skillRequirementsMaster[1]=12
skillRequirementsMaster[2]=12
skillRequirementsMaster[3]=12
skillRequirementsMaster[4]=12
skillRequirementsMaster[5]=8
skillRequirementsMaster[6]=12
skillRequirementsMaster[8]=10
skillRequirementsMaster[9]=10
skillRequirementsMaster[10]=10
skillRequirementsMaster[11]=4
skillRequirementsMaster[12]=12
skillRequirementsMaster[13]=4
skillRequirementsMaster[14]=12
skillRequirementsMaster[15]=12
skillRequirementsMaster[16]=4
skillRequirementsMaster[17]=12
skillRequirementsMaster[18]=12
skillRequirementsMaster[19]=4
skillRequirementsMaster[20]=4

if SETTINGS["255MOD"]==true then
	--skill requirements
	for i=0,20 do
		skillRequirementsExpert[i]=32
	end
	for i=21,30 do	
	skillRequirementsExpert[i]=4
	end
	skillRequirementsExpert[0]=24
	skillRequirementsExpert[5]=24
	skillRequirementsExpert[8]=24
	skillRequirementsExpert[9]=24
	skillRequirementsExpert[10]=24
	skillRequirementsExpert[11]=24
	skillRequirementsExpert[14]=12
	skillRequirementsExpert[16]=12
	
	skillRequirementsMaster={}
	for i=21,30 do	
	skillRequirementsMaster[i]=7
	end
	for i=0,20 do
		skillRequirementsMaster[i]=48
	end
	skillRequirementsMaster[0]=36
	skillRequirementsMaster[5]=36
	skillRequirementsMaster[8]=36
	skillRequirementsMaster[9]=36
	skillRequirementsMaster[10]=36
	skillRequirementsMaster[11]=36
	skillRequirementsMaster[12]=12
end
