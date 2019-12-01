player_vehicles = {}

AddEvent("OnPlayerSwitchGamemode", function(player, from, to)
    if from == "freeroam" then
        if player_vehicles[player] ~= nil then
            DestroyVehicle(player_vehicles[player])
            player_vehicles[player] = nil
        end
    end
    if to == "freeroam" then
        SetPlayerWeapon(player, 1, 0, true, 1)
        SetPlayerDimension(player, 0)
        SetPlayerSpawnLocation(player, 125773, 80246, 1645, 90)
        SetPlayerLocation(player, 125773, 80246, 1645)
        SetPlayerHealth(player, 100000)
    end
end)

AddCommand("v", function(player, model)
    if GetPlayerGamemode(player) ~= "freeroam" then
        return
    end
    if player_vehicles[player] ~= nil then
        DestroyVehicle(player_vehicles[player])
    end
    local x, y, z = GetPlayerLocation(player)
    local vehicle = CreateVehicle(model, x, y, z, GetPlayerHeading(player))
    SetPlayerInVehicle(player, vehicle)
    SetVehicleRespawnParams(vehicle, false)
    AttachVehicleNitro(vehicle, true)
    player_vehicles[player] = vehicle
end)

CreateTimer(function()
    for k,vehicle in pairs(player_vehicles) do
        SetVehicleHealth(vehicle, 2000)
    end
end, 1000)

AddEvent("OnPlayerDamage", function(player, damageType, amount)
    if GetPlayerGamemode(player) ~= "freeroam" then
        return
    end
    SetPlayerHealth(player, 100+amount)
end)