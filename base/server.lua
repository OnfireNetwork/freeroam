local player_modes = {}

function SetPlayerGamemode(player, mode)
    local oldMode = GetPlayerGamemode(player)
    player_modes[player] = mode
    CallEvent("OnPlayerSwitchGamemode", player, oldMode, mode)
    CallRemoteEvent(player, "OnPlayerSwitchGamemode", oldMode, mode)
    SetPlayerPropertyValue(player, "gamemode", mode, true)
    local players = GetAllPlayers()
    for i=1,#players do
        if oldMode ~= nil then
            CallRemoteEvent(players[i], "UpdateGamemodePlayerCount", oldMode, #GetGamemodePlayers(oldMode))
        end
        if mode ~= nil then
            CallRemoteEvent(players[i], "UpdateGamemodePlayerCount", mode, #GetGamemodePlayers(mode))
        end
    end
end

function GetPlayerGamemode(player)
    return player_modes[player] 
end

function GetGamemodePlayers(gamemode)
    local pl = {}
    local all = GetAllPlayers()
    for i=1,#all do
        if GetPlayerGamemode(all[i]) == gamemode then
            table.insert(pl, all[i])
        end
    end
    return pl
end

AddEvent("OnPlayerJoin", function(player)
    SetPlayerGamemode(player, "freeroam")
end)

AddEvent("OnPlayerQuit", function(player)
    SetPlayerGamemode(player, nil)
end)

for k,v in pairs({"freeroam", "gungame"}) do
    AddCommand(v, function(player)
        if GetPlayerGamemode(player) == v then
            return
        end
        SetPlayerGamemode(player, v)
    end)
end