QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


QBCore.Functions.CreateCallback("fortis-shisha:server:reserveerPlek", function(source, cb, plek)
    local src = source
    local steam = GetPlayerIdentifier(src, 1)

    if Config.loungeLocaties[plek].actief == true then
        -- Plek is al bezet
        cb(true)
    else
        Config.loungeLocaties[plek].actief = true
        Config.loungeLocaties[plek].steam = steam
        cb(false)
    end
end)

RegisterNetEvent("fortis-shisha:server:maakPlekVrij")
AddEventHandler("fortis-shisha:server:maakPlekVrij", function(plek)
    local src = source
    Config.loungeLocaties[plek].actief = false
end)

RegisterNetEvent("fortis-shisha:server:betaal")
AddEventHandler("fortis-shisha:server:betaal", function(prijs)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveMoney("bank", prijs, "shisha kosten")
end)

-- Als een speler uitlogt in een plek, wordt zn plek vrij gemaakt
AddEventHandler('playerDropped', function(reason)
    local src = source
    local steam = GetPlayerIdentifier(src, 1)
    for k, v in pairs(Config.loungeLocaties) do
        if v.steam == steam then
            Config.loungeLocaties[k].actief = false
            return
        end
    end
end)