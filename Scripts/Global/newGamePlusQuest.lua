local mysteriousScrollId = 580
local oracle, seer = 8, 9 -- npc IDs
local NGSeer = "newGamePlusSeer" -- quest ID as a string, mmext quests are identified by them
local NGOracle = "newGamePlusOracle"
vars.Quests = vars.Quests or {} -- just in case, this is the table where quest data is saved by default
vars.newGameQuest = vars.newGameQuest or {}
local Q = vars.Quests -- convenient alias
--[[ helpers for testing
function goToQueen()
    evt.MoveToMap{Name = "hive.blv", X = 3970, Y = 26861, Z = -2287}
end
function goToSeer()
    evt.MoveToMap{Name = "outd3.odm", X = -3824, Y = 19719, Z = 3297}
end
function goToControlCenter()
    evt.MoveToMap{Name = "sci-fi.blv", X = -9280, Y = 4160, Z = 197}
end
function goToOracle()
    evt.MoveToMap{Name = "oracle.blv", X = -1415, Y = 1920, Z = -511}
end
]]
function events.AfterLoadMap()
    if Map.Name ~= "oracle.blv" then return end
    evt.Set  {"MapVar6", Value = 1} -- power panel on
    for k, v in Map.Doors do
        evt.SetDoorState(v.Id, 1)
    end
end

function killMouseover()
    Map.Monsters[Mouse:GetTarget().Index].HP = 0
end

local qBits = {seer = 238, oracle = 239, controlCenter = 240}
Game.QuestsTxt[qBits.seer] = "You found mysterious scroll. Go talk to seer to shed some light on its purpose."

-- give scroll to queen
function events.AfterLoadMap()
    if Map.Name == "hive.blv" then
        if mapvars.scrollAdded then return end
        mapvars.scrollAdded = true
        for i, mon in Map.Monsters do
            if mon.Name == "Demon Queen" then
                mon.Item = mysteriousScrollId
                break
            end
        end
    end
end

-- add quest "go to seer" if queen is looted
function events.PickCorpse(t)
    if Map.Name == "hive.blv" and t.Monster.Name == "Demon Queen" then
        evt.Set("QBits", qBits.seer)
    end
end

Quest {
    NGSeer, -- quest id
    NPC = seer, -- NPC who manages quest
    Slot = 2, -- topic number (0-2 in mm6, 0-5 in mm7+) which will host quest topic
    Quest = qBits.oracle,
    CheckDone = function()
        return Q[NGOracle] -- if oracle quest is started, this is completed
    end,
    CanShow = function() -- if it returns false, no topic will appear
        return evt.All.Cmp("Inventory", mysteriousScrollId) or Q[NGSeer] -- has item or quest is started
    end,
    Texts = {
        Topic = "Mysterious Scroll",
        Give = "Ah, the scroll you bring holds the key to a forgotten prophecy, seek the wisdom of the Oracle to unveil its true purpose.",
        Undone = "The Oracle has the answers you need",
        Done = "The Oracle has the answers you need",
        After = "The Oracle has the answers you need",
        Quest = "Ask the Oracle about the Misterious Scroll",
    },
    Give = function() -- run on topic click if quest is given
        evt.Sub("QBits", qBits.seer) -- remove "go to seer" quest
    end
}

Quest {
    NGOracle,
    NPC = oracle,
    Slot = 2,
    Gold = 200000, -- gold reward
    Exp = 200000, -- exp reward
    Quest = qBits.controlCenter,
    CheckDone = function()
        return vars.newGameQuest.ccDone
    end,
    CanShow = function()
        return Q[NGSeer] or Q[NGOracle]
    end,
    Give = function()
        -- uncomment to remove item from inventory
        -- evt.All.Sub("Inventory", mysteriousScrollId)

        -- uncomment to remove seer quest here (might be confusing)
        -- evt.Sub("QBits", qBits.oracle)
    end,
    Done = function()
        -- enable new game stuff here
        
        -- if you need to test later whether quest is done, this will suffice:
        -- if Q[NGOracle] == "Done" then ...
    end,
    Texts = {
        Topic = "Dimensional Prison", -- topic text
        -- shown when quest is done and clicked previous topic
        -- if you wish for it to change after completing objective, but before clicking, this can be done too
        TopicDone = "New World",
        Give = "Ah, seeker of truth, your arrival heralds a long-awaited moment, for the scroll you possess holds within it the means to unlock the dimensional prison in control center, a place where an insidious and malevolent evil has been locked away for ages, and I, as the keeper of prophecies, have patiently awaited its arrival so that we may join forces and wield the combined might of the scroll and your valiant spirit to vanquish this ancient threat once and for all, restoring peace and harmony to our troubled world.",
        Undone = "The dimensional prison, ensconced within the very heart of the control center. For countless eons, it has stood undisturbed, untouched by mortal hands. Yet, in this moment, I must confess that I can no longer offer certitude regarding the secrets it conceals. Steel your spirit and fortify your resolve, for what lies within demands caution and preparedness.",
        Done = "Heroes of Enroth, you have proven yourselves capable of defeating the Creator, but in the process, a space-time fracture has manifested within the control center; should you choose to investigate it, be aware that there might be no coming back, yet the opportunity to uncover hidden truths and mend the shattered reality awaits you.",
        Quest = "Open the dimensional prison in Control Center.",
        After = "The space-time fracture looks stable; should you choose to investigate it, be aware that there might be no coming back, yet the opportunity to uncover hidden truths and mend the shattered reality awaits you.",
    }
}

function events.LeaveMap()
    -- put check for having cleared control center here
    if vars.GameOver and Q[NGOracle] == "Given" then
        vars.newGameQuest.ccDone = true
    end
end

--[[
so:
looting the queen will get you a misterious scroll
after teleport to new sorpigal you get the quest, saying that you should ask someone about it, probably the seer
the seer sends you to the oracle, but the oracle inform you that there is no time for that, as some danger is awaiting in the control center
you go there and do the long chains of events
after that you talk to the oracle, complete the quest and you are able to reset the game
10:57
so basically:
quest given after the hive
step 1 seer
step 2 oracle
step 3 complete the event
turn to oracle
give a new quest saying that you are free to explore the world finishing some business or just start over at higher difficulty

]]
