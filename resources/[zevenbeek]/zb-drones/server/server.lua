QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local drones = {}

QBCore.Functions.CreateUseableItem("drone_1", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    -- local used = useDrone(1, src)

    TriggerClientEvent('zb-drones:client:makeDrone', source, 1)
end)

QBCore.Functions.CreateUseableItem("drone_2", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    -- local used = useDrone(2, src)

    TriggerClientEvent('zb-drones:client:makeDrone', source, 2)
end)

QBCore.Functions.CreateUseableItem("drone_3", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    -- local used = useDrone(3, src)

    TriggerClientEvent('zb-drones:client:makeDrone', source, 3)
end)

RegisterServerEvent("zb-drones:server:droneGebruiken")
AddEventHandler("zb-drones:server:droneGebruiken", function(type)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local used = useDrone(type, src)
end)

useDrone = function(type, src)
    if drones[src] == nil then
        local Player = QBCore.Functions.GetPlayer(src)
        drones[src] = {}
        drones[src][type] = {}
        Player.Functions.RemoveItem('drone_' .. type, 1)
        return true
    else
        return false
    end
end

RegisterServerEvent("zb-drone:server:refundDrone")
AddEventHandler("zb-drone:server:refundDrone", function(type)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem("drone_"..type, 1)
end)

RegisterServerEvent('zb-drone:server:pickupDrone')
AddEventHandler('zb-drone:server:pickupDrone', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if drones[src][1] ~= nil then
        local ItemData = QBCore.Shared.Items['drone_1']
        Player.Functions.AddItem('drone_1', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
        drones[src] = nil
    elseif drones[src][2] ~= nil then
        local ItemData = QBCore.Shared.Items['drone_2']
        Player.Functions.AddItem('drone_2', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
        drones[src] = nil
    elseif drones[src][3] ~= nil then
        local ItemData = QBCore.Shared.Items['drone_3']
        Player.Functions.AddItem('drone_3', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
        drones[src] = nil
    end
end)

RegisterServerEvent('zb-drones:server:purchaseDrone')
AddEventHandler('zb-drones:server:purchaseDrone', function(type)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bank = Player.PlayerData.money['bank']
    local cash = Player.PlayerData.money['cash']

    if bank >= Config.Drones[type]['price'] then
        local ItemData = QBCore.Shared.Items['drone_' .. type]
        Player.Functions.RemoveMoney('bank', Config.Drones[type]['price'], "bought-drone")
        Player.Functions.AddItem('drone_' .. type, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
    elseif cash >= Config.Drones[type]['price'] then
        local ItemData = QBCore.Shared.Items['drone_' .. type]
        Player.Functions.RemoveMoney('cash', Config.Drones[type]['price'], "bought-drone")
        Player.Functions.AddItem('drone_' .. type, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
    else
        TriggerClientEvent('QBCore:Notify', src, Config.ErrorMessages['notEnoughMoney'], 'error', Config.ErrorMessages['timestamp'])
    end
end)