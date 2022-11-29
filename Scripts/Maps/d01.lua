AE(2454, 100)
evt.map[100] = function()
	if mapvars.tyeksekk ~= 3 then 
    Message("This text is made possible by Eksekk, but now you are going to die")
		if mapvars.tyeksekk == nil then
		mapvars.tyeksekk = 0
		end
	mapvars.tyeksekk = mapvars.tyeksekk + 1
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	Sleep(120)
	pseudoSpawnpoint{monster = 76, x = Party.X, y = Party.Y, z = Party.Z, count = 1, powerChances = {100, 0, 0}, radius = 1024, group = 255}	
	
	end
end