AES(2454, 100)
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

AES(1898, 101)

evt.map[101] = function()
	if mapvars.death ~= 1 then 
    Message("Trespassers shall die.")
	mapvars.death = 1	
	end
end

AES(2276, 102)

evt.map[101] = function()
	if mapvars.stench ~= 1 then 
    Message("'The stench fills your lungs.'")
	mapvars.stench = 1	
	end
end