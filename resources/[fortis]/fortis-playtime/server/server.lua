QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback("fortis-playtime:server:ontvangPlaytime", function(source, cb)
    if source ~= nil then
        local steam = GetPlayerIdentifiers(source)[1]
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `playtime_final` WHERE steam = '"..steam.."'", function(resultaat)
            if #resultaat == 0 then
                local cbTable = {
                    ["minuten"] = 0,
                    ["db_id"] = 0
                }
                cb(cbTable)
                return
            else
                local cbTable = {
                    ["minuten"] = resultaat[1].minuten,
                    ["db_id"] = resultaat[1].id
                }
                cb(cbTable)
                return
            end
        end)
    end
end)

RegisterNetEvent("fortis-playtime:server:updatePlaytime")
AddEventHandler("fortis-playtime:server:updatePlaytime", function(minuten, db_id)
    if source ~= nil then
        local db_id = db_id
        local minuten = minuten
        local steam = GetPlayerIdentifiers(source)[1]

        if db_id > 0 then
            QBCore.Functions.ExecuteSql(false, "SELECT * FROM `playtime_final` WHERE id = '"..db_id.."'", function(resultaat)
                QBCore.Functions.ExecuteSql(true, "UPDATE `playtime_final` SET minuten = "..minuten.." WHERE id = '"..db_id.."'")
            end)
        else
            -- fasdijklafsdjlk
            QBCore.Functions.ExecuteSql(false, "SELECT * FROM `playtime_final` WHERE steam = '"..steam.."'", function(resultaat)
                if #resultaat == 0 then
                    -- Persoon heeft GEEN playtime in de database, wazebai maak aan a sah
                    QBCore.Functions.ExecuteSql(true, "INSERT INTO `playtime_final` (`steam`, `minuten`) VALUES ('"..steam.."', "..minuten..") ")
                else
                    -- Persoon heeft al een actieve playtime in de database, wazebai update oulleh
                    QBCore.Functions.ExecuteSql(true, "UPDATE `playtime_final` SET minuten = "..minuten.." WHERE steam = '"..steam.."'")
                end
            end)
        end
    end
end)

