QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback("fortis-sneeuwpoppen:server:checkpoppies", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local steam = Player.PlayerData.steam

    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `sneeuwpoppen` WHERE gevonden NOT LIKE '%"..steam.."%'", function(resultaat)
        cb(resultaat)
    end)
end)

RegisterNetEvent("fortis-sneeuwpoppen:server:gevonden")
AddEventHandler("fortis-sneeuwpoppen:server:gevonden", function(id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local steam = Player.PlayerData.steam
    
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `sneeuwpoppen` WHERE id = '"..id.."'", function(resultaat)
        if resultaat ~= nil then
            local tabel = json.decode(resultaat[1]["gevonden"])
            table.insert(tabel, steam)
            QBCore.Functions.ExecuteSql(true, "UPDATE `sneeuwpoppen` SET gevonden = '"..json.encode(tabel).."' WHERE `id` = "..id.."")

            QBCore.Functions.ExecuteSql(true, "SELECT * FROM `sneeuwpoppen` WHERE gevonden NOT LIKE '%"..steam.."%'", function(resultaat)
                if #resultaat <= 0 then
                    TriggerClientEvent("fortis-sneeuwpoppen:client:email", src)
                end
            end)
        end
    end)
end)

RegisterServerEvent("fortis-sneeuwpoppen:server:gefeliciteerd")
AddEventHandler("fortis-sneeuwpoppen:server:gefeliciteerd", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local betaling = 45000

    Player.Functions.AddMoney('bank', betaling, "Alle paaseieren gevonden")
    Player.Functions.AddItem("beer", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["beer"], "add")
end)

-- Dev kanker
-- RegisterNetEvent("fortis-sneeuwpoppen:server:kanker")
-- AddEventHandler("fortis-sneeuwpoppen:server:kanker", function(tmp_table)
--     QBCore.Functions.ExecuteSql(true, "INSERT INTO sneeuwpoppen (coords, gevonden) VALUES ('"..json.encode(tmp_table).."', '[]')")
-- end)