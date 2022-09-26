QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Create usable item
QBCore.Functions.CreateUseableItem("gitaar", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("fortis-gitaar:client:speelgitaar", source, item.name)
end)

RegisterServerEvent("fortis-gitaar:server:geefGeld")
AddEventHandler("fortis-gitaar:server:geefGeld", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local betaling = math.random(40, 90)

    Player.Functions.AddMoney("cash", betaling, "Gitaar")
    TriggerClientEvent("QBCore:Notify", source, "Wat mooi gespeeld! Hier heb je €"..betaling, "success")
end)