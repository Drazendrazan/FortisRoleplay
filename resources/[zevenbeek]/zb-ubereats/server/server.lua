QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent("zb-ubereats:server:addBestelling")
AddEventHandler("zb-ubereats:server:addBestelling", function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("bestelling", 1)
end)

RegisterServerEvent("zb-ubereats:server:removeBestelling")
AddEventHandler("zb-ubereats:server:removeBestelling", function()
    local Player = QBCore.Functions.GetPlayer(source)
    
    local bezorgKosten = math.random(400, 800)
    Player.Functions.RemoveItem("bestelling", 1)
    Player.Functions.AddMoney('cash', bezorgKosten, "Burgershot aflevering")
    TriggerClientEvent("QBCore:Notify", source, "Je hebt de bestelling afgeleverd, je kreeg €"..bezorgKosten, "success")
end)

QBCore.Functions.CreateCallback("zb-ubereats:server:requestBestelling", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("bestelling") ~= nil then
        local aantal = Player.Functions.GetItemByName("bestelling").amount
        cb(aantal)
    else
        cb(0)
    end
end)