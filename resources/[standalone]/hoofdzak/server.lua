QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)




QBCore.Functions.CreateUseableItem("cagoule", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-headbag:puton', source, item)
end)

RegisterNetEvent('qb-handbag:MaskPlayer', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local MaskedPlayer = QBCore.Functions.GetPlayer(playerId)
    if (MaskedPlayer.PlayerData.metadata["ishandcuffed"] or MaskedPlayer.PlayerData.metadata["inlaststand"] or MaskedPlayer.PlayerData.metadata["isdead"]) then
        if Player.Functions.GetItemByName("cagoule") then
            TriggerClientEvent("qb-handbag:GetMasked", MaskedPlayer.PlayerData.source, Player.PlayerData.source)
            TriggerClientEvent("inventory:client:glitch", src)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "De persoon is niet geboeid of dood", 'error')
    end
end)