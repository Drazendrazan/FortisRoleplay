QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local witgeldData = {}

QBCore.Functions.CreateCallback("fortis-witwas:server:checkAantal", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("viesgeld") ~= nil then
        local aantal = Player.Functions.GetItemByName("viesgeld").amount

        cb(aantal)
    else
        cb(0)
    end
end)

RegisterNetEvent("fortis-witwas:server:verwijderViesgeld")
AddEventHandler("fortis-witwas:server:verwijderViesgeld", function(aantal)
    local Player = QBCore.Functions.GetPlayer(source)

    witgeldData[source] = {waarde = aantal}
    Player.Functions.RemoveItem("viesgeld", aantal)
end)

RegisterNetEvent("fortis-witwas:server:geefWitgeld")
AddEventHandler("fortis-witwas:server:geefWitgeld", function(witgeld)
    local Player = QBCore.Functions.GetPlayer(source)
    local continue = false

    for k, v in pairs(witgeldData) do
        if k == source then
            continue = true
        end
    end

    if continue then
        local witgeld = (witgeldData[source].waarde / 100) * math.random(75, 100)
        local witgeld = round(witgeld, 0)

        Player.Functions.AddMoney("cash", witgeld, "Witgeld witgewassen")
        witgeldData[source] = nil
    else
        TriggerClientEvent("fortis-witwas:client:gepaktZemmel", source)
    end
end)

RegisterNetEvent("fortis-witwas:server:cancelWassen", function(aantal)
    local Player = QBCore.Functions.GetPlayer(source)
    local continue = false

    for k, v in pairs(witgeldData) do
        if k == source then
            continue = true
        end
    end

    if continue then
        Player.Functions.AddItem("viesgeld", witgeldData[source].waarde)
        witgeldData[source] = nil
    else
        TriggerClientEvent("fortis-witwas:client:gepaktZemmel", source)
    end
end)



RegisterNetEvent("fortis-witwas:server:kauloHacker")
AddEventHandler("fortis-witwas:server:kauloHacker", function(errorAfhandeling)
    local src = source
    TriggerClientEvent('chatMessage', -1, "Fortis AntiCheat", "error", GetPlayerName(src).." is automatisch verbannen voor het incheaten van viesgeld.")
    local reason = "Incheaten van viesgeld"
    QBCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(src).."', '"..GetPlayerIdentifiers(src)[1].."', '"..GetPlayerIdentifiers(src)[2].."', '"..GetPlayerIdentifiers(src)[3].."', '"..GetPlayerIdentifiers(src)[4].."', '"..reason.."', 2145913200, '"..GetPlayerName(src).."')")
    DropPlayer(src, "Incheaten van viesgeld: https://fortisroleplay.nl/discord")
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end