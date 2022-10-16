QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback('qb-diving:server:GetDivingConfig', function(source, cb)
    cb(QBDiving.Locations)
end)

RegisterServerEvent('qb-diving:server:TakeCoral')
AddEventHandler('qb-diving:server:TakeCoral', function(Area, Coral, Bool)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local kans = math.random(1, 10)
    if kans == 1 then
        TriggerClientEvent("QBCore:Notify", src, "Geluksvogel! Je hebt een horloge gevonden!", "success")
        Player.Functions.AddItem("rolex", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["rolex"], "add")
        Citizen.Wait(250)
    elseif kans == 2 then
        TriggerClientEvent("QBCore:Notify", src, "Geluksvogel! Je hebt een ketting gevonden!", "success")
        Player.Functions.AddItem("goldchain", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["goldchain"], "add")
        Citizen.Wait(250)
    else
        Player.Functions.AddItem("onderwatervondst", math.random(2,5))
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["onderwatervondst"], "add")
        Citizen.Wait(250)
    end
end)

RegisterServerEvent("zb-duiken:server:verkopen")
AddEventHandler("zb-duiken:server:verkopen", function()
    local Player = QBCore.Functions.GetPlayer(source)
    local onderwatervondstAantal = Player.Functions.GetItemByName("onderwatervondst").amount
    local betaling = onderwatervondstAantal * 55

    Player.Functions.RemoveItem("onderwatervondst", onderwatervondstAantal)

    Player.Functions.AddMoney('bank', betaling, "Verkoop van onderwater vondsten")
    TriggerClientEvent("QBCore:Notify", source, "Je hebt je onderwatervondsten verkocht, je kreeg €"..betaling, "success")
end)

QBCore.Functions.CreateCallback("zb-duiken:server:requestOnderwatervondst", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("onderwatervondst") ~= nil then
        local aantal = Player.Functions.GetItemByName("onderwatervondst").amount
        cb(aantal)
    else
        cb(0)
    end
end)
















RegisterServerEvent('qb-diving:server:RemoveGear')
AddEventHandler('qb-diving:server:RemoveGear', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["diving_gear"], "remove")
end)

RegisterServerEvent('qb-diving:server:GiveBackGear')
AddEventHandler('qb-diving:server:GiveBackGear', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    Player.Functions.AddItem("diving_gear", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["diving_gear"], "add")
end)