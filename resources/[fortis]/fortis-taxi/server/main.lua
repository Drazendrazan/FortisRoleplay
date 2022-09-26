QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterNetEvent("qb-taxi:server:uitbetalingNPC")
AddEventHandler("qb-taxi:server:uitbetalingNPC", function()
    local Player = QBCore.Functions.GetPlayer(source)

    local bedrag = math.random(400, 700)
    local betaalWijze = math.random(1, 2)

    if betaalWijze == 1 then
        Player.Functions.AddMoney("cash", bedrag, "Taxi NPC rit")
        TriggerClientEvent("QBCore:Notify", source, "De klant betaalde €"..bedrag.." via contant geld!", "success")
    else
        Player.Functions.AddMoney("bank", bedrag, "Taxi NPC rit")
        TriggerClientEvent("QBCore:Notify", source, "De klant betaalde €"..bedrag.." via een bankoverschrijving!", "success")
    end
end)