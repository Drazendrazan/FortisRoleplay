QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent("fortis-fotograaf:server:addCamera")
AddEventHandler("fortis-fotograaf:server:addCamera", function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("camera", 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["camera"], "add")
end)

RegisterServerEvent("fortis-fotograaf:server:addFoto")
AddEventHandler("fortis-fotograaf:server:addFoto", function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("sdkaart", 1)

    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["sdkaart"], "add")
end)

RegisterServerEvent("fortis-fotograaf:server:removeCamera")
AddEventHandler("fortis-fotograaf:server:removeCamera", function()
    local Player = QBCore.Functions.GetPlayer(source)
    local fotoAantal = Player.Functions.GetItemByName("sdkaart").amount
    local cameraAantal = Player.Functions.GetItemByName("camera").amount
    local betaling = fotoAantal * math.random(500,900)

    Player.Functions.RemoveItem("camera", cameraAantal)
    Player.Functions.RemoveItem("sdkaart", fotoAantal)

    Player.Functions.AddMoney('bank', betaling, "Fotos verkocht fotograaf job")
    TriggerClientEvent("QBCore:Notify", source, "Je hebt alle foto's geüpload, je kreeg €"..betaling, "success")

    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["sdkaart"], "remove")
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["camera"], "remove")
end)

QBCore.Functions.CreateCallback("fortis-fotograaf:server:requestCamera", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("camera") ~= nil then
        local cameraAantal = Player.Functions.GetItemByName("camera").amount
        cb(cameraAantal)
    else
        cb(0)
    end
end)

QBCore.Functions.CreateCallback("fortis-fotograaf:server:requestFotoAantal", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("sdkaart") ~= nil then
        local fotoAantal = Player.Functions.GetItemByName("sdkaart").amount
        cb(fotoAantal)
    else
        cb(0)
    end
end)