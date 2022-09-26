QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent("ambu:server:krijggeld")
AddEventHandler("ambu:server:krijggeld", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local geld = math.random(100, 200)

    Player.Functions.AddMoney("bank", geld, "Ambulance NPC missie")
    TriggerClientEvent("QBCore:Notify", source, "Je hebt persoon goed geholpen, je kreeg €"..geld, "success")
end)
