local web = CreateWebUI(0, 0, 0, 0)
SetWebAnchors(web, 0, 0, 1, 1)
SetWebAlignment(web, 0, 0)
SetWebURL(web, "http://asset/onfreeroam/ui/hud.html")

local playerCount = {}

function UISetGamemodeData(mode, players)
    ExecuteWebJS(web, "SetGamemodeData('"..mode.."', "..players..");")
end

function UISetGamemodePlaying(name)
    ExecuteWebJS(web, "SetGamemodePlaying('"..name.."');")
end

AddRemoteEvent("OnPlayerSwitchGamemode", function(from, to)
    if to == "freeroam" then
        UISetGamemodePlaying("Freeroam")
    end
    if to == "gungame" then
        UISetGamemodePlaying("Gungame")
    end
end)

AddRemoteEvent("UpdateGamemodePlayerCount", function(gamemode, count)
    if playerCount ~= nil then
        playerCount[gamemode] = count
    else
        UISetGamemodeData(gamemode, count)
    end
end)

AddEvent("_freeroam_hud_ready", function()
    for k,v in pairs(playerCount) do
        UISetGamemodeData(k, v)
    end
    playerCount = nil
end)