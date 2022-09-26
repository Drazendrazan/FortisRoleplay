QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent("fortis-hondjes:server:krijggeld")
AddEventHandler("fortis-hondjes:server:krijggeld", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local betaling = math.random(750, 1100)

    Player.Functions.AddMoney('cash', betaling, "Uitlaten van hond")
    TriggerClientEvent("QBCore:Notify", source, "Bedankt voor het uitlaten van mijn hond! Hier heb je €"..betaling, "success")
end)