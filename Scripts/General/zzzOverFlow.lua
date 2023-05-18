function events.HealingSpellPower(t)
if t.Spell == 54 then
	play = 0
	if Party[0].Dead~=1 and Party[0].Eradicated~=1 and Party[0].HP > 0 then
	play = play + 1
	if Party[1].Dead~=1 and Party[1].Eradicated~=1 and Party[1].HP > 0 then
	play = play + 1
	if Party[2].Dead~=1 and Party[2].Eradicated~=1 and Party[2].HP > 0 then
	play = play + 1
	if Party[3].Dead~=1 and Party[3].Eradicated~=1 and Party[3].HP > 0 then
	play = play + 1
end
end
end
end
--healHP = ((t.Skill*9)+t.Result)/4
--healHP = t.Result/play
healHP = (Party[0].HP + Party[1].HP + Party[2].HP + Party[3].HP + t.Skill * 9)/play
		a = Party[0]:GetFullHP()-Party[0].HP+healHP
	if Party[0].Dead~=1 and Party[0].Eradicated~=1 then
	
		if Party[0].HP < 0 then
		a2 = 0
		a3 = 1
		elseif healHP > Party[0]:GetFullHP() then
		a2 = healHP - Party[0]:GetFullHP()
		a3 = 1
		elseif Party[0].HP > Party[0]:GetFullHP()*0.9 then
		a2 = 0
		a3 = 1
		else
		a2 = 0
		a3 = 1
		end
		end

		b = Party[1]:GetFullHP()-Party[1].HP+healHP
	if Party[1].Dead~=1 and Party[1].Eradicated~=1 then
		b2 = 0
		b3 = 0
		if Party[1].HP < 0 then
		b2 = 0
		b3 = 0
		elseif healHP > Party[1]:GetFullHP() then
		b2 = healHP - Party[1]:GetFullHP()
		b3 = 1
		elseif Party[1].HP > Party[1]:GetFullHP()*0.9 then
		a2 = 0
		a3 = 1
		else
		b2 = 0
		b3 = 0

		end
		end

		c = Party[2]:GetFullHP()-Party[2].HP+healHP
	if Party[2].Dead~=1 and Party[2].Eradicated~=1 then
		c2 = 0
		c3 = 0
		if Party[2].HP < 0 then
		c2 = 0
		c3 = 0
		elseif healHP > Party[2]:GetFullHP() then
		c2 = healHP - Party[2]:GetFullHP()
		c3 = 1
		elseif Party[2].HP > Party[2]:GetFullHP()*0.9 then
		a2 = 0
		a3 = 1
		else
		c2 = 0
		c3 = 0

		end
		end

		d = Party[3]:GetFullHP()-Party[3].HP+healHP
	if Party[3].Dead~=1 and Party[3].Eradicated~=1 then
		d2 = 0
		d3 = 0
		if Party[3].HP < 0 then
		d2 = 0
		d3 = 0
		elseif healHP > Party[3]:GetFullHP() then
		d2 = healHP - Party[3]:GetFullHP()
		d3 = 1
		elseif Party[3].HP > Party[3]:GetFullHP()*0.9 then
		a2 = 0
		a3 = 1
		else
		d2 = 0
		d3 = 0

		end
		end

		surplus = a2+b2+c2+d2
		Play = a3+b3+c3+d3
t.Result = t.Result+surplus*4/(4.5-Play)
end
if t.Spell == 77 then
a2=0
b2=0
c2=0
d2=0
	a = Party[0]:GetFullHP()-Party[0].HP-t.Result
	if a < 0 then
	a2 = a * -1
	a = 0
	end
 		b = Party[1]:GetFullHP()-Party[1].HP-t.Result
	if b < 0 then
	b2 = b * -1
	b = 0
	end
		c = Party[2]:GetFullHP()-Party[2].HP-t.Result
	if c < 0 then
	c2 = c * -1
	c = 0
	end
		d = Party[3]:GetFullHP()-Party[3].HP-t.Result
	if d < 0 then
	d2 = d * -1
	d = 0
	end

	if a2 < 0 then
	a2 = 0
	end
	if b2 < 0 then
	b2 = 0
	end
	if c2 < 0 then
	c2 = 0
	end
	if d2 < 0 then
	d2 = 0
	end
MissHP = a + b + c + d
surplus = a2 + b2 + c2 + d2
if a > surplus * a / MissHP * 0.75 then
a3 = a
else
a3 = surplus * b / MissHP * 0.75
end
if b > surplus * b / MissHP * 0.75 then
b3 = b
else
b3 = surplus * b / MissHP * 0.75
end
if c > surplus * c / MissHP * 0.75 then
c3 = c
else
c3 = surplus * c / MissHP * 0.75
end
if d > surplus * d / MissHP * 0.75 then
d3 = d
else
d3 = surplus * d / MissHP * 0.75
end



Party[0].HP = math.max(Party[0]:GetFullHP(), Party[0].HP + a3)
Party[1].HP = math.max(Party[1]:GetFullHP(), Party[1].HP + b3)
Party[2].HP = math.max(Party[2]:GetFullHP(), Party[2].HP + c3)
Party[3].HP = math.max(Party[2]:GetFullHP(), Party[3].HP + d3)
end
end