--recommended level
function events.GameInitialized2()
--order is: dungeons, temples, castles, varn and hive
	recommendedLevel={"84-???","3-5","5-7","10-13","9-13","30-35","18-22","7-11","15-21","28-34","27-32","27-32","30-37","33-40","28-35","22-26","45-56","34-42","46-56","43-51","71-84","23-27","7-11","11-14","34-49","29-36","60-74","46-57","44-55","50-58","55-65","58-73","68-77","87-100"}
	for i = 1, 34 do
		Game.TransTxt[i+169]=string.format("%s\n \n\nLevel: %s",Game.TransTxt[i+169],recommendedLevel[i])
	end
--dragon cave and devil outpost
	recommendedLevel2={"80","63-73"}
	for i = 1, 2 do
		Game.TransTxt[i]=string.format("%s\n\nLevel: %s",Game.TransTxt[i],recommendedLevel2[i])
	end
end
