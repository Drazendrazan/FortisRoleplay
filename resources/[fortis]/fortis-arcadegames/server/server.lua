QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterNetEvent("rcore_arcade:server:buyTicket")
AddEventHandler("rcore_arcade:server:buyTicket", function(ticket)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local data = Config.ticketPrice[ticket.k]
    local bank = Player.PlayerData.money['bank']
    if bank > data.price then
        Player.Functions.RemoveMoney('bank', data.price, "Arcade")
        TriggerClientEvent("rcore_arcade:ticketResult", source, ticket);
    else
        TriggerClientEvent("rcore_arcade:ticketResult", source, _U("gold"));
    end
end)       