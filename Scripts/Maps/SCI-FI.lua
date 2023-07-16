local TXT = Localize{
	[0] = " ",
	[1] = "Door",
	[2] = "Storage Container",
	[3] = "Computer Terminal",
	[4] = "It's a short circuit!",
	[5] = "The door won't budge.",
	[6] = "Control Center",
	[7] = "Exit",
	[8] = "",
	[9] = "",
	[10] = "",
	[11] = "Hello and welcome to this self-guided tour of the Varn Planetary Control Facility.  We gladly welcome all visitors.  As you arrive at each key area, be sure to check any of our display screens for more information.  Enjoy your tour!",
	[12] = "This is the main equipment storage and repair facility.  By now, you may have noticed several floating Drone-bots.  They are responsible both for maintaining the key systems of this facility as well as sanitation.  If a unit becomes damaged, it is brought here to be repaired.",
	[13] = "The room to your left is the main meeting hall.  Visiting dignitaries from around the world have feasted at banquets held in their honor.  In fact, it is said that at his 21st birthday party King Sheridan nearly choked to death on a piece of mogred, but was saved by a serving girl who he later married and made his Queen.  Ahh, l’amour.",
	[14] = "Chief Engineer Wilson’s Personal Log.  I have locked myself in Storage Room #6 but currently have no means of escape.  The drone-bots have gone mad and have started killing everyone in sight.  I was able to access the main control terminal on Level Four despite warnings of a hazardous leak, and I sent a distress signal, but since we have not had contact with any of the colonies for several weeks, I do not believe that a rescue is possible.  I have also managed to seal this facility so that the drones can not escape.  It is my hope that the colonists will be able to mount some sort of defense by the time my encryption codes are broken.  Tell Emma I love her.  Wilson out.",
	[15] = "We apologize for any inconvenience, but we ask that all personnel evacuate the facility at this time.  Please do not be alarmed.  Thank you.",
	[16] = "Before entering the Planetary Reaction Chamber, please request a pair of Safety Goggles from one of our Drones.  During peak hours of operation, this facility can generate enough power to produce a light bright enough to be seen from space.  Please avoid looking directly into the light.",
	[17] = "Alert, environmental controls are offline on Level Four, Sections 18 through 96.  Access restricted to drones until further notice.",
	[18] = "Warning, intruder alert, Level Four, Section.  All drones proceed to Level Four to intercept intruders.  Reactor is offline.  Encryption integrity at 2.064%.  Warning, intruder alert, Level Four…",
	[19] = "Blaster weapons provide an effective, accurate ranged attack.  To operate the blaster, hold the grip comfortably in your hand, point the barrel at your target, and gently squeeze the trigger.  Should the weapon misfire, do not look into the barrel- give the weapon to an instructor and let them fix the problem.  Never point a blaster at something you do not want to vaporize.",
	[20] = "Are you sure? (yes/no)",
	[21] = "yes"
}
table.copy(TXT, evt.str, true)

Game.MapEvtLines.Count = 0  -- Deactivate all standard events

evt.MazeInfo = evt.str[6]  -- "Control Center"

evt.hint[1] = evt.str[1]  -- "Door"
evt.map[1] = function()
	evt.StatusText(5)         -- "The door won't budge."
end

evt.hint[2] = evt.str[1]  -- "Door"
evt.map[2] = function()
	evt.SetDoorState{Id = 2, State = 2}         -- switch state
	evt.SetDoorState{Id = 3, State = 2}         -- switch state
	evt.SetDoorState{Id = 15, State = 0}
	evt.SetDoorState{Id = 16, State = 0}
end

evt.hint[3] = evt.str[1]  -- "Door"
evt.map[3] = function()
	evt.SetDoorState{Id = 3, State = 1}
end

evt.hint[4] = "Dimensional Prison" -- "Door"
evt.map[4] = function()
if vars.endDoor==nil then
	if evt.Cmp("QBits", 240) then
	evt.SetDoorState{Id = 4, State = 1}
	vars.endDoor=1
	Game.ShowStatusText("Access Granted")
	for i=0,3 do
		Party[i].Spells[19]=false
		Party[i].Spells[21]=false
		Party[i].Spells[31]=false
		Party[i].Spells[33]=false
	end
	mapvars.event=true
	Sleep(250)
	Message("???:\nFINALLY FREE! I've been waiting for Centuries!")
	Sleep(100)
	Message("???:\nWho are you? I see, you are here to end my sufferings, what a fool.\nI will not let you interfere with my plans.\n\nI EXILE YOU!")
	Sleep(150)
	evt.MoveToMap{X = -512, Y = -1088, Z = -450, Direction = 1536, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 0, Name = "zddb10.blv"}
	else
	Message("Access Denied - only those who are allowed by the Oracle can access")
	end
end
end

evt.hint[5] = evt.str[1]  -- "Door"
evt.map[5] = function()
	evt.SetDoorState{Id = 5, State = 1}
end

evt.hint[6] = evt.str[1]  -- "Door"
evt.map[6] = function()
	evt.SetDoorState{Id = 6, State = 1}
end

evt.hint[7] = evt.str[1]  -- "Door"
evt.map[7] = function()
	evt.SetDoorState{Id = 7, State = 1}
	evt.SetDoorState{Id = 8, State = 0}
	evt.SetDoorState{Id = 9, State = 0}
end

evt.hint[8] = evt.str[1]  -- "Door"
evt.map[8] = function()
	evt.SetDoorState{Id = 8, State = 1}
	evt.SetDoorState{Id = 7, State = 0}
	evt.SetDoorState{Id = 9, State = 0}
end

evt.hint[9] = evt.str[1]  -- "Door"
evt.map[9] = function()
	evt.SetDoorState{Id = 9, State = 1}
	evt.SetDoorState{Id = 8, State = 0}
	evt.SetDoorState{Id = 7, State = 0}
end

evt.hint[10] = evt.str[1]  -- "Door"
evt.map[10] = function()
	evt.SetDoorState{Id = 10, State = 1}
	evt.SetDoorState{Id = 11, State = 1}
end

evt.hint[11] = evt.str[1]  -- "Door"
evt.map[11] = function()
	evt.SetDoorState{Id = 10, State = 1}
	evt.SetDoorState{Id = 11, State = 1}
end

evt.hint[12] = evt.str[1]  -- "Door"
evt.map[12] = function()
	evt.SetDoorState{Id = 12, State = 1}
end

evt.hint[13] = evt.str[1]  -- "Door"
evt.map[13] = function()
	evt.SetDoorState{Id = 13, State = 1}
end

evt.hint[14] = evt.str[1]  -- "Dimension Door"
evt.map[14] = function()
	if vars.CelestialArena1 and vars.GameOver then
	evt.SetDoorState{Id = 14, State = 1}
	else
	Game.ShowStatusText("Locked")
	end
end

evt.hint[15] = evt.str[1]  -- "Door"
evt.map[15] = function()
	evt.SetDoorState{Id = 15, State = 2}         -- switch state
	evt.SetDoorState{Id = 16, State = 2}         -- switch state
	evt.SetDoorState{Id = 2, State = 0}
	evt.SetDoorState{Id = 3, State = 0}
end

evt.hint[16] = evt.str[1]  -- "Door"
evt.map[16] = function()
	evt.SetDoorState{Id = 16, State = 1}
end

evt.hint[17] = evt.str[1]  -- "Door"
evt.map[17] = function()
	evt.SetDoorState{Id = 17, State = 1}
end

evt.hint[18] = evt.str[1]  -- "Door"
evt.map[18] = function()
	evt.SetDoorState{Id = 18, State = 1}
end

evt.hint[19] = evt.str[1]  -- "Door"
evt.map[19] = function()
	evt.SetDoorState{Id = 19, State = 1}
end

evt.hint[20] = evt.str[1]  -- "Door"
evt.map[20] = function()
	evt.SetDoorState{Id = 20, State = 1}
end

evt.hint[21] = evt.str[1]  -- "Door"
evt.map[21] = function()
	evt.SetDoorState{Id = 21, State = 1}
end

evt.hint[22] = evt.str[1]  -- "Door"
evt.map[22] = function()
	evt.SetDoorState{Id = 22, State = 1}
end

evt.hint[23] = evt.str[1]  -- "Door"
evt.map[23] = function()
	evt.SetDoorState{Id = 23, State = 1}
end

evt.hint[24] = evt.str[1]  -- "Door"
evt.map[24] = function()
	evt.SetDoorState{Id = 24, State = 2}         -- switch state
	evt.SetDoorState{Id = 25, State = 2}         -- switch state
end

evt.hint[25] = evt.str[1]  -- "Door"
evt.map[25] = function()
	evt.SetDoorState{Id = 25, State = 1}
end

evt.hint[26] = evt.str[1]  -- "Door"
evt.map[26] = function()
	evt.SetDoorState{Id = 26, State = 2}         -- switch state
	evt.SetDoorState{Id = 1, State = 2}         -- switch state
end

evt.hint[27] = evt.str[1]  -- "Door"
evt.map[27] = function()
	evt.SetDoorState{Id = 27, State = 2}         -- switch state
	evt.SetDoorState{Id = 28, State = 2}         -- switch state
end

evt.hint[28] = evt.str[1]  -- "Door"
evt.map[28] = function()
	evt.SetDoorState{Id = 28, State = 1}
	evt.SetDoorState{Id = 27, State = 1}
end

evt.hint[29] = evt.str[2]  -- "Storage Container"
evt.map[29] = function()
	evt.OpenChest(0)
end

evt.hint[30] = evt.str[2]  -- "Storage Container"
evt.map[30] = function()
	evt.OpenChest(1)
end

evt.hint[31] = evt.str[2]  -- "Storage Container"
evt.map[31] = function()
	evt.OpenChest(2)
end

evt.hint[32] = evt.str[2]  -- "Storage Container"
evt.map[32] = function()
	evt.OpenChest(3)
end

evt.hint[33] = evt.str[2]  -- "Storage Container"
evt.map[33] = function()
	evt.OpenChest(4)
end

evt.hint[34] = evt.str[2]  -- "Storage Container"
evt.map[34] = function()
	evt.OpenChest(5)
	evt.ForPlayer("All")
	evt.Set("Awards", 61)         -- "Super-Goober"
end

evt.hint[35] = evt.str[2]  -- "Storage Container"
evt.map[35] = function()
	evt.OpenChest(6)
end

evt.hint[36] = evt.str[2]  -- "Storage Container"
evt.map[36] = function()
	evt.OpenChest(7)
end

evt.hint[37] = evt.str[2]  -- "Storage Container"
evt.map[37] = function()
	evt.OpenChest(8)
end

evt.map[38] = function()
	evt.SetLight{Id = 45, On = true}
	evt.SetLight{Id = 46, On = true}
	evt.SetLight{Id = 47, On = true}
	evt.SetLight{Id = 48, On = true}
	evt.SetLight{Id = 49, On = true}
end

evt.map[39] = function()
	evt.SetLight{Id = 31, On = true}
	evt.SetLight{Id = 32, On = true}
	evt.SetLight{Id = 33, On = true}
	evt.SetLight{Id = 34, On = true}
	evt.SetLight{Id = 35, On = true}
	evt.SetLight{Id = 36, On = true}
	evt.SetLight{Id = 37, On = true}
	evt.SetLight{Id = 38, On = true}
	evt.SetLight{Id = 39, On = true}
	evt.SetLight{Id = 40, On = true}
	evt.SetLight{Id = 41, On = true}
	evt.SetLight{Id = 42, On = true}
	evt.SetLight{Id = 43, On = true}
	evt.SetLight{Id = 44, On = true}
	evt.SetLight{Id = 391, On = true}
end

evt.map[40] = function()
	evt.SetLight{Id = 50, On = true}
	evt.SetLight{Id = 51, On = true}
	evt.SetLight{Id = 52, On = true}
	evt.SetLight{Id = 53, On = true}
	evt.SetLight{Id = 54, On = true}
	evt.SetLight{Id = 55, On = true}
	evt.SetLight{Id = 56, On = true}
	evt.SetLight{Id = 57, On = true}
	evt.SetLight{Id = 58, On = true}
	evt.SetLight{Id = 59, On = true}
end

evt.map[41] = function()
	evt.SetLight{Id = 60, On = true}
	evt.SetLight{Id = 61, On = true}
	evt.SetLight{Id = 62, On = true}
	evt.SetLight{Id = 63, On = true}
	evt.SetLight{Id = 64, On = true}
	evt.SetLight{Id = 65, On = true}
	evt.SetLight{Id = 66, On = true}
	evt.SetLight{Id = 67, On = true}
end

evt.map[42] = function()
	evt.SetLight{Id = 68, On = true}
	evt.SetLight{Id = 69, On = true}
	evt.SetLight{Id = 70, On = true}
	evt.SetLight{Id = 71, On = true}
	evt.SetLight{Id = 72, On = true}
	evt.SetLight{Id = 73, On = true}
	evt.SetLight{Id = 74, On = true}
	evt.SetLight{Id = 75, On = true}
end

evt.map[43] = function()
	evt.SetLight{Id = 77, On = true}
	evt.SetLight{Id = 78, On = true}
	evt.SetLight{Id = 79, On = true}
end

evt.map[44] = function()
	evt.SetLight{Id = 389, On = true}
	evt.SetLight{Id = 390, On = true}
end

evt.map[45] = function()
	evt.SetLight{Id = 45, On = false}
	evt.SetLight{Id = 46, On = false}
	evt.SetLight{Id = 47, On = false}
	evt.SetLight{Id = 48, On = false}
	evt.SetLight{Id = 49, On = false}
end

evt.map[46] = function()
	evt.SetLight{Id = 45, On = false}
	evt.SetLight{Id = 46, On = false}
	evt.SetLight{Id = 47, On = false}
	evt.SetLight{Id = 48, On = false}
	evt.SetLight{Id = 49, On = false}
	evt.SetLight{Id = 31, On = false}
	evt.SetLight{Id = 32, On = false}
	evt.SetLight{Id = 33, On = false}
	evt.SetLight{Id = 34, On = false}
	evt.SetLight{Id = 35, On = false}
	evt.SetLight{Id = 36, On = false}
	evt.SetLight{Id = 37, On = false}
	evt.SetLight{Id = 38, On = false}
	evt.SetLight{Id = 39, On = false}
	evt.SetLight{Id = 40, On = false}
	evt.SetLight{Id = 41, On = false}
	evt.SetLight{Id = 42, On = false}
	evt.SetLight{Id = 43, On = false}
	evt.SetLight{Id = 44, On = false}
	evt.SetLight{Id = 391, On = false}
end

evt.map[47] = function()
	evt.SetLight{Id = 31, On = false}
	evt.SetLight{Id = 32, On = false}
	evt.SetLight{Id = 33, On = false}
	evt.SetLight{Id = 34, On = false}
	evt.SetLight{Id = 35, On = false}
	evt.SetLight{Id = 36, On = false}
	evt.SetLight{Id = 37, On = false}
	evt.SetLight{Id = 38, On = false}
	evt.SetLight{Id = 39, On = false}
	evt.SetLight{Id = 40, On = false}
	evt.SetLight{Id = 41, On = false}
	evt.SetLight{Id = 42, On = false}
	evt.SetLight{Id = 43, On = false}
	evt.SetLight{Id = 44, On = false}
	evt.SetLight{Id = 391, On = false}
	evt.SetLight{Id = 50, On = false}
	evt.SetLight{Id = 51, On = false}
	evt.SetLight{Id = 52, On = false}
	evt.SetLight{Id = 53, On = false}
	evt.SetLight{Id = 54, On = false}
	evt.SetLight{Id = 55, On = false}
	evt.SetLight{Id = 56, On = false}
	evt.SetLight{Id = 57, On = false}
	evt.SetLight{Id = 58, On = false}
	evt.SetLight{Id = 59, On = false}
	evt.CastSpell{Spell = 15, Mastery = const.Master, Skill = 100, FromX = -10880, FromY = -4224, FromZ = 660, ToX = -10880, ToY = -4224, ToZ = 400}         -- "Sparks"
end

evt.map[48] = function()
	evt.SetLight{Id = 50, On = false}
	evt.SetLight{Id = 51, On = false}
	evt.SetLight{Id = 52, On = false}
	evt.SetLight{Id = 53, On = false}
	evt.SetLight{Id = 54, On = false}
	evt.SetLight{Id = 55, On = false}
	evt.SetLight{Id = 56, On = false}
	evt.SetLight{Id = 57, On = false}
	evt.SetLight{Id = 58, On = false}
	evt.SetLight{Id = 59, On = false}
	evt.SetLight{Id = 60, On = false}
	evt.SetLight{Id = 61, On = false}
	evt.SetLight{Id = 62, On = false}
	evt.SetLight{Id = 63, On = false}
	evt.SetLight{Id = 64, On = false}
	evt.SetLight{Id = 65, On = false}
	evt.SetLight{Id = 66, On = false}
	evt.SetLight{Id = 67, On = false}
end

evt.map[49] = function()
	evt.SetLight{Id = 60, On = false}
	evt.SetLight{Id = 61, On = false}
	evt.SetLight{Id = 62, On = false}
	evt.SetLight{Id = 63, On = false}
	evt.SetLight{Id = 64, On = false}
	evt.SetLight{Id = 65, On = false}
	evt.SetLight{Id = 66, On = false}
	evt.SetLight{Id = 67, On = false}
	evt.SetLight{Id = 68, On = false}
	evt.SetLight{Id = 69, On = false}
	evt.SetLight{Id = 70, On = false}
	evt.SetLight{Id = 71, On = false}
	evt.SetLight{Id = 72, On = false}
	evt.SetLight{Id = 73, On = false}
	evt.SetLight{Id = 74, On = false}
	evt.SetLight{Id = 75, On = false}
end

evt.map[50] = function()
	evt.SetLight{Id = 68, On = false}
	evt.SetLight{Id = 69, On = false}
	evt.SetLight{Id = 70, On = false}
	evt.SetLight{Id = 71, On = false}
	evt.SetLight{Id = 72, On = false}
	evt.SetLight{Id = 73, On = false}
	evt.SetLight{Id = 74, On = false}
	evt.SetLight{Id = 75, On = false}
	evt.SetLight{Id = 77, On = false}
	evt.SetLight{Id = 78, On = false}
	evt.SetLight{Id = 79, On = false}
end

evt.map[51] = function()
	evt.SetLight{Id = 77, On = false}
	evt.SetLight{Id = 78, On = false}
	evt.SetLight{Id = 79, On = false}
	evt.SetLight{Id = 389, On = false}
	evt.SetLight{Id = 390, On = false}
end

evt.map[52] = function()
	evt.SetLight{Id = 389, On = false}
	evt.SetLight{Id = 390, On = false}
end

evt.hint[53] = evt.str[3]  -- "Computer Terminal"
evt.map[53] = function()
	evt.SetTexture{Facet = 2899, Name = "trekscOn"}
	evt.SetMessage(11)         -- "Hello and welcome to this self-guided tour of the Varn Planetary Control Facility.  We gladly welcome all visitors.  As you arrive at each key area, be sure to check any of our display screens for more information.  Enjoy your tour!"
	evt.SimpleMessage()
end

evt.hint[54] = evt.str[3]  -- "Computer Terminal"
evt.map[54] = function()
	evt.SetTexture{Facet = 2903, Name = "trekscOn"}
	evt.SetMessage(12)         -- "This is the main equipment storage and repair facility.  By now, you may have noticed several floating Drone-bots.  They are responsible both for maintaining the key systems of this facility as well as sanitation.  If a unit becomes damaged, it is brought here to be repaired."
	evt.SimpleMessage()
end

evt.hint[55] = evt.str[3]  -- "Computer Terminal"
evt.map[55] = function()
	evt.SetTexture{Facet = 2930, Name = "trekscOn"}
	evt.SetMessage(13)         -- "The room to your left is the main meeting hall.  Visiting dignitaries from around the world have feasted at banquets held in their honor.  In fact, it is said that at his 21st birthday party King Sheridan nearly choked to death on a piece of mogred, but was saved by a serving girl who he later married and made his Queen.  Ahh, l’amour."
	evt.SimpleMessage()
end

evt.hint[56] = evt.str[3]  -- "Computer Terminal"
evt.map[56] = function()
	evt.SetTexture{Facet = 2905, Name = "trekscOn"}
	evt.SetMessage(14)         -- "Chief Engineer Wilson’s Personal Log.  I have locked myself in Storage Room #6 but currently have no means of escape.  The drone-bots have gone mad and have started killing everyone in sight.  I was able to access the main control terminal on Level Four despite warnings of a hazardous leak, and I sent a distress signal, but since we have not had contact with any of the colonies for several weeks, I do not believe that a rescue is possible.  I have also managed to seal this facility so that the drones can not escape.  It is my hope that the colonists will be able to mount some sort of defense by the time my encryption codes are broken.  Tell Emma I love her.  Wilson out."
	evt.SimpleMessage()
end

evt.hint[57] = evt.str[3]  -- "Computer Terminal"
evt.map[57] = function()
	evt.SetTexture{Facet = 2911, Name = "trekscOn"}
	evt.SetMessage(15)         -- "We apologize for any inconvenience, but we ask that all personnel evacuate the facility at this time.  Please do not be alarmed.  Thank you."
	evt.SimpleMessage()
end

evt.hint[58] = evt.str[3]  -- "Computer Terminal"
evt.map[58] = function()
	evt.SetTexture{Facet = 2914, Name = "trekscOn"}
	evt.SetMessage(16)         -- "Before entering the Planetary Reaction Chamber, please request a pair of Safety Goggles from one of our Drones.  During peak hours of operation, this facility can generate enough power to produce a light bright enough to be seen from space.  Please avoid looking directly into the light."
	evt.SimpleMessage()
end

evt.hint[59] = evt.str[3]  -- "Computer Terminal"
evt.map[59] = function()
	evt.SetTexture{Facet = 2921, Name = "trekscOn"}
	evt.SetMessage(17)         -- "Alert, environmental controls are offline on Level Four, Sections 18 through 96.  Access restricted to drones until further notice."
	evt.SimpleMessage()
end

evt.hint[60] = evt.str[3]  -- "Computer Terminal"
evt.map[60] = function()
	evt.SetTexture{Facet = 2933, Name = "trekscOn"}
	evt.SetMessage(18)         -- "Warning, intruder alert, Level Four, Section.  All drones proceed to Level Four to intercept intruders.  Reactor is offline.  Encryption integrity at 2.064%.  Warning, intruder alert, Level Four…"
	evt.SimpleMessage()
end

evt.hint[61] = evt.str[3]  -- "Computer Terminal"
evt.map[61] = function()
	evt.SetTexture{Facet = 2927, Name = "trekscOn"}
	if not evt.Cmp("QBits", 276) then         -- NPC
		evt.ForPlayer("All")
		evt.Set("BlasterSkill", 1)
		evt.Set("QBits", 276)         -- NPC
	end
	evt.SetMessage(19)         -- "Blaster weapons provide an effective, accurate ranged attack.  To operate the blaster, hold the grip comfortably in your hand, point the barrel at your target, and gently squeeze the trigger.  Should the weapon misfire, do not look into the barrel- give the weapon to an instructor and let them fix the problem.  Never point a blaster at something you do not want to vaporize."
	evt.SimpleMessage()
end

evt.map[62] = function()
	evt.StatusText(4)         -- "It's a short circuit!"
	evt.DamagePlayer{Player = "Random", DamageType = const.Damage.Fire, Damage = 200}
end

evt.map[63] = function()
	evt.StatusText(4)         -- "It's a short circuit!"
	evt.DamagePlayer{Player = "Random", DamageType = const.Damage.Fire, Damage = 200}
end

evt.map[64] = function()
	evt.StatusText(4)         -- "It's a short circuit!"
	evt.DamagePlayer{Player = "Random", DamageType = const.Damage.Fire, Damage = 200}
end

evt.hint[65] = evt.str[2]  -- "Storage Container"
evt.map[65] = function()
	evt.OpenChest(9)
end

evt.hint[66] = evt.str[2]  -- "Storage Container"
evt.map[66] = function()
	evt.OpenChest(10)
end

evt.hint[67] = evt.str[2]  -- "Storage Container"
evt.map[67] = function()
	evt.OpenChest(11)
end

evt.hint[68] = evt.str[2]  -- "Storage Container"
evt.map[68] = function()
	evt.OpenChest(12)
end

evt.hint[69] = evt.str[2]  -- "Storage Container"
evt.map[69] = function()
	evt.OpenChest(13)
end

evt.hint[70] = evt.str[7]  -- "Exit"
evt.map[70] = function()
	evt.MoveToMap{X = -1433, Y = 2204, Z = -495, Direction = 1536, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 6, Name = "Oracle.Blv"}
end

evt.map[71] = function()  -- Timer(<function>, 1.5*const.Minute)
	evt.CastSpell{Spell = 15, Mastery = const.Master, Skill = 100, FromX = -5632, FromY = -4736, FromZ = 660, ToX = -5632, ToY = -4000, ToZ = 660}         -- "Sparks"
end

Timer(evt.map[71].last, 1.5*const.Minute)

evt.hint[72] = evt.str[2]  -- "Storage Container"
evt.map[72] = function()
	evt.OpenChest(14)
end


-----------------------
----RESET
-----------------------
evt.hint[666] = "New World"
evt.map[666] = function()
if evt.Cmp("Awards", 61) then
	Message("In the new World your quests and awards will be resetted, there is no way back. (Changing settings to 255 mod is required after entering)")
	if evt.Question{Question = 20, Answer1 = 21} then   

	for i=1,60 do
		evt.ForPlayer("All")
		evt.Subtract("Awards", i)
	end
	for i=9,31 do
		evt.ForPlayer("All")
		evt.Add("Awards", i)
	end
	--reset class and skills to base
	for i= 0,3 do
		for v= 0,20 do
			Party[i].Skills[v]=Party[i].Skills[v]%64
		end
		Party[i].Class=Party[i].Class-Party[i].Class%3
	end
	

	--QUEST ITEM RESET
	evt.ForPlayer("All")
	evt.Subtract("Inventory", 433)
	evt.Subtract("Inventory", 434)
	for i=448,462 do
	evt.ForPlayer("All")
	evt.Subtract("Inventory", i)
	end
	for i=464,578 do
	evt.ForPlayer("All")
	evt.Subtract("Inventory", i)
	end
	for i=448,462 do
	evt.ForPlayer("All")
	evt.Subtract("Inventory", i)
	end
	for i=464,578 do
	evt.ForPlayer("All")
	evt.Subtract("Inventory", i)
	end
	for i=448,462 do
	evt.ForPlayer("All")
	evt.Subtract("Inventory", i)
	end
	for i=464,578 do
	evt.ForPlayer("All")
	evt.Subtract("Inventory", i)
	end

	--NPC RESET
	for i=0,398 do 
		Game.NPC[i].House=Game.NPCDataTxt[i].House
		for j = 0, 2 do Game.NPC[i].Events[j] = Game.NPCDataTxt[i].Events[j] 
		end 
	end
	
	--RESET QBITS CODE

		for i=1, 512 do
			Party.QBits[i-1] = false
		end
		Party.QBits[81] = true
		Party.QBits[181] = true

	--remove 1st promotions
		evt.SetNPCTopic{NPC = 6, Index = 1, Event = 70}   
		evt.SetNPCTopic{NPC = 5, Index = 1, Event = 59} 
		evt.SetNPCTopic{NPC = 4, Index = 1, Event = 13} 
		evt.SetNPCTopic{NPC = 16, Index = 1, Event = 37} 
		evt.SetNPCTopic{NPC = 15, Index = 1, Event = 93}
		evt.SetNPCTopic{NPC = 14, Index = 1, Event = 84}  
		
	--reset obelisks in notes
	for i=0,14 do
		evt.Subtract("AutonotesBits", 79+i)
	end
		evt.Set("ReputationIs", 0)
		Game.Time=Game.Time+250000000
		evt.MoveToMap{X = 48, Y = -512, Z = 0, Direction = 512, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 0, Name = "zddb04.blv"}
	end


	end
end



evt.map[600] = function()
	if vars.lastFight then
	evt.MoveToMap{X = -3657, Y =  -387, Z = 1185, Direction = 0, LookAngle = 0, SpeedZ = 0, HouseId = 0, Icon = 0, Name = "0"}
	Game.ShowStatusText("I won't let you escape")
	end
end

spawnlist={10,49,52,55,58,70}

evt.map[601] = function()
	if vars.lastFight and vars.CelestialArena1 then
	vars.lastFight=false
	pseudoSpawnpoint{monster = 109, x = 382, y = -383, z =1184, count = 1, powerChances = {0, 0, 100}, radius = 0, group = 255, transform = function(mon) genericTransform(200)(mon); mon.Name="The Creator" mon.TreasureItemPercent = 0 mon.FireResistance=150 mon.ColdResistance = 150 mon.ElecResistance=150 mon.PoisonResistance=150 mon.MagicResistance=250 mon.PhysResistance = 120 end}
	Sleep(100)
	pseudoSpawnpoint{monster = spawnlist[math.random(1,6)], x = 382, y = -383, z =1184, count = 3, powerChances = {34, 33, 23}, radius = 0, group = 255, transform = function(mon) genericTransform(math.random(80,120))(mon); mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
	Sleep(500)
	pseudoSpawnpoint{monster = spawnlist[math.random(1,6)], x = 382, y = -383, z =1184, count = 3, powerChances = {34, 33, 23}, radius = 0, group = 255, transform = function(mon) genericTransform(math.random(80,120))(mon); mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
	Sleep(750)
	pseudoSpawnpoint{monster = spawnlist[math.random(1,6)], x = 382, y = -383, z =1184, count = 3, powerChances = {34, 33, 23}, radius = 0, group = 255, transform = function(mon) genericTransform(math.random(80,120))(mon); mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
	Sleep(1000)
	pseudoSpawnpoint{monster = spawnlist[math.random(1,6)], x = 382, y = -383, z =1184, count = 3, powerChances = {34, 33, 23}, radius = 0, group = 255, transform = function(mon) genericTransform(math.random(80,120))(mon); mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
	end
end

function events.CalcDamageToPlayer(t)
local data=WhoHitPlayer()
if data then
	if data.Monster then
		if data.Monster.Id==111 then
		spawnChance=math.random(1,100)
			if spawnChance>60 then
				pseudoSpawnpoint{monster = spawnlist[math.random(1,6)], x = (Party.X+data.Monster.X)/2, y = (Party.Y+data.Monster.Y)/2, z = Party.Z, count = 1, powerChances = {34, 33, 23}, radius = 0, group = 255, transform = function(mon) genericTransform(math.random(80,120))(mon); mon.TreasureItemPercent = 0 mon.TreasureGold= 0 end}
			end
		end
	end
end
end

function events.CalcDamageToMonster(t)
	if t.Monster.Id==111 and t.Result>t.Monster.HP then
	vars.GameOver=true
	Sleep(200)
	Message("As the Creator dies, a path to a new dimension has been opened somewhere, you are now free to leave, but first let's report to Oracle")
	end
end


function events.CanSaveGame(t)
	if mapvars.event then
	t.Result=false
	Game.ShowStatusText("Can't save now")
	else
	t.Result=true
	end
end

function events.CanCastLloyd(t)
	if mapvars.event then
	t.Result=false
	Sleep(1)
	Game.ShowStatusText("Can't teleport now")
	else
	t.Result=true
	end
end

mapvars.event=false
