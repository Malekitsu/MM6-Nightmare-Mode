--VANILLA
function respecPrice(player)
	cost=0
	p=Party[player]
	for i=0, p.Skills.High do
		skill=p.Skills[i]%64
		refund=skill*(skill+1)/2-1
		cost=cost+refund
	end
	cost=cost*50
	return cost
end

--VANILLA
function respecVanilla(player)
	refund=0
	p=Party[player]
	for i=0, p.Skills.High do
		skill=p.Skills[i]%64
		refund=skill*(skill+1)/2-1
		--reset to 1 and reset skill points
		if p.Skills[i]>0 then
			p.Skills[i]=1
		end
		p.SkillPoints=p.SkillPoints+refund
	end
end


--MAW
function respecMaw(player)
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

--this will be called when respeccing
function respecMastery(player)
	p=Party[player]
	for i=0, p.Skills.High do
		vars.oldPlayerMasteries[player][i]=math.floor(p.Skills[i]/64)
	end
end

--refund masteries
function relearnMastery(player)
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
skillRequirementsMaster[11]=10
skillRequirementsMaster[12]=12
skillRequirementsMaster[13]=4
skillRequirementsMaster[14]=12
skillRequirementsMaster[15]=12
skillRequirementsMaster[16]=4
skillRequirementsMaster[17]=12
skillRequirementsMaster[18]=12
skillRequirementsMaster[19]=4
skillRequirementsMaster[20]=4
