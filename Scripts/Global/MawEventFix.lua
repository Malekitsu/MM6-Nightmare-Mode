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
