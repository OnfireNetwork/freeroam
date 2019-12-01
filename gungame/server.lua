local levels = {
    {
        weapon = 3
    },
    {
        weapon = 2
    },
    {
        weapon = 20
    },
    {
        weapon = 15
    }
}

local maps = {
    {
        name = "Gas Station",
        spawns = {
            {131161.640625, 79054.2109375, 1574.5587158203, -178.66088867188},
            {129873.421875, 82380.8125, 1566.9012451172, -148.51818847656},
            {123265.1171875, 82792.8671875, 1409.0029296875, -44.013805389404},
            {122486.1015625, 75004.5390625, 1298.1226806641, 43.572582244873},
            {126611.578125, 73577.1875, 1589.3677978516, 82.827476501465},
            {129922.7265625, 74345.953125, 1569.6334228516, 100.33822631836},
            {129237.203125, 76153.0546875, 1566.6707763672, 142.04124450684},
            {128886.703125, 79091.1953125, 1577.8374023438, -171.4998626709},
            {126444.796875, 78383.3984375, 1568.9000244141, 30.305746078491}
        }
    }
}

local noFire = false

local map = 1

local player_levels = {}

local function EquipPlayer(player)
    SetPlayerHealth(player, 100)
    SetPlayerWeapon(player, levels[player_levels[player]].weapon, 10000, true, 1, true)
end

local function GetRandomSpawnLocation()
    return table.unpack(maps[map].spawns[Random(1,#maps[map].spawns)])
end

AddEvent("OnPlayerSwitchGamemode", function(player, from, to)
    if from == "gungame" then
        player_levels[player] = nil
    end
    if to == "gungame" then
        player_levels[player] = 1
        SetPlayerDimension(player, 1)
        local x, y, z, h = GetRandomSpawnLocation()
        SetPlayerLocation(player, x, y, z)
        SetPlayerHeading(player, h)
        SetPlayerHealth(player, 100)
        SetPlayerArmor(player, 0)
        EquipPlayer(player)
    end
end)

AddEvent("OnPlayerDeath", function(player, killer)
    if GetPlayerGamemode(player) ~= "gungame" then
        return
    end
    if killer ~= 0 then
        if GetPlayerEquippedWeaponSlot(killer) ~= 1 then
            if player_levels[player] > 1 then
                player_levels[player] = player_levels[player] - 1
            end
        end
        if player_levels[killer] < #levels then
            player_levels[killer] = player_levels[killer] + 1
            Delay(1, function()
                EquipPlayer(killer)
            end)
        else
            noFire = true
            local players = GetGamemodePlayers("gungame")
            AddPlayerChatAll(GetPlayerName(killer).." has won gungame!")
            Delay(5000, function()
                players = GetGamemodePlayers("gungame")
                for i=1,#players do
                    player_levels[players[i]] = 1
                    EquipPlayer(players[i])
                    SetPlayerHealth(players[i], 100)
                    local x, y, z, h = GetRandomSpawnLocation()
                    SetPlayerLocation(players[i], x, y, z)
                    SetPlayerHeading(players[i], h)
                    AddPlayerChat(player, "New round started! Protection ends in 5 seconds!")
                end
            end)
            Delay(10000, function()
                noFire = false
            end)
        end
    else
        if player_levels[player] > 1 then
            player_levels[player] = player_levels[player] - 1
        end
    end
end)

AddEvent("OnPlayerSpawn", function(player)
    if GetPlayerGamemode(player) ~= "gungame" then
        return
    end
    local x, y, z, h = GetRandomSpawnLocation()
    SetPlayerSpawnLocation(player, x, y, z, h)
    EquipPlayer(player)
end)

AddEvent("OnPlayerWeaponShot", function(player, weapon, hittype, hitid, hitX, hitY, hitZ, startX, startY, normalX, normalY, normalZ)
    if GetPlayerGamemode(player) ~= "gungame" then
        return
    end
    if noFire then
        return false
    end
end)