PowerCureOverflow=SETTINGS["PowerCureOverflow"]
function events.HealingSpellPower(t)
  if t.Spell == 54 then
    active = 0
    for i = 0, 3 do
      if Party[i].Dead == 0 and Party[i].Eradicated == 0 and Party[i].Stoned == 0 and Party[i].Unconscious == 0 then
        active = active + 1
      end
    end

    SETTEDHP = t.Result / active
    overflow = 0
	needheal = 0
    for i = 0, 3 do
      if Party[i].Dead == 0 and Party[i].Eradicated == 0 and Party[i].Stoned == 0 and Party[i].Unconscious == 0 then
        if SETTEDHP > Party[i]:GetFullHP() then
          overflow = overflow + (SETTEDHP - Party[i]:GetFullHP())
		else
		needheal=needheal+1
        end
      end
    end
	if needheal>0 and overflow>0 then
	t.Result=t.Result+overflow*4/needheal
	end
end


if t.Spell == 77 and PowerCureOverflow then
--t.Result = t.Result / 4
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
surplus = surplus/4


Party[0].HP = math.min(Party[0]:GetFullHP(), Party[0].HP + surplus * a / MissHP)
Party[1].HP = math.min(Party[1]:GetFullHP(), Party[1].HP + surplus * b / MissHP)
Party[2].HP = math.min(Party[2]:GetFullHP(), Party[2].HP + surplus * c / MissHP)
Party[3].HP = math.min(Party[3]:GetFullHP(), Party[3].HP + surplus * d / MissHP)
if Party[0].HP > Party[0]:GetFullHP() then
Party[0].HP = Party[0]:GetFullHP()
end
if Party[1].HP > Party[1]:GetFullHP() then
Party[1].HP = Party[1]:GetFullHP()
end
if Party[2].HP > Party[2]:GetFullHP() then
Party[2].HP = Party[2]:GetFullHP()
end
if Party[3].HP > Party[3]:GetFullHP() then
Party[3].HP = Party[3]:GetFullHP()
end
--t.Result = t.Result * 4
end
end

