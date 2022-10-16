QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

Citizen.CreateThread(function()
    QBCore.Functions.ExecuteSql(true, "DELETE FROM `portofoons`")
end)


QBCore.Functions.CreateUseableItem("radio", function(source, item)
    TriggerClientEvent("zb-radio:client:openRadio", source)
    print("Tomato")
end)

QBCore.Functions.CreateCallback("zb-radio:server:checkRadioFrequentie", function(source, cb, frequentie)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if frequentie > 10 then
        cb(true)
    elseif frequentie <= 10 then
        if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "mechanic" then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent("zb-radio:server:verbindFrequentie")
AddEventHandler("zb-radio:server:verbindFrequentie", function(frequentie, naam, portofoonOudeFrequentie)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    QBCore.Functions.ExecuteSql(true, "DELETE FROM `portofoons` WHERE citizenid = '"..citizenid.."'")
    QBCore.Functions.ExecuteSql(true, "INSERT INTO `portofoons` (`frequentie`, `naam`, `citizenid`) VALUES ('"..frequentie.."', '"..naam.."', '"..citizenid.."')")

    if portofoonOudeFrequentie ~= 0 then
        QBCore.Functions.ExecuteSql(false, "SELECT frequentie, naam FROM `portofoons` WHERE frequentie = '"..portofoonOudeFrequentie.."'", function(resultaat)
            if #resultaat > 0 then
                TriggerClientEvent("zb-radio:client:refreshLijst", -1, portofoonOudeFrequentie, json.encode(resultaat))
            else
                TriggerClientEvent("zb-radio:client:refreshLijst", -1, portofoonOudeFrequentie, json.encode(resultaat))
            end
        end)
    end

    QBCore.Functions.ExecuteSql(false, "SELECT frequentie, naam FROM `portofoons` WHERE frequentie = '"..frequentie.."' ORDER BY naam", function(resultaat)
        if #resultaat > 0 then
            TriggerClientEvent("zb-radio:client:refreshLijst", -1, frequentie, json.encode(resultaat))
        else
            TriggerClientEvent("zb-radio:client:refreshLijst", -1, frequentie, json.encode(resultaat))
        end
    end)
end)

RegisterServerEvent("zb-radio:server:verbreekFrequentie")
AddEventHandler("zb-radio:server:verbreekFrequentie", function(frequentie)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    QBCore.Functions.ExecuteSql(true, "DELETE FROM `portofoons` WHERE frequentie = '"..frequentie.."' AND citizenid = '"..citizenid.."'")

    QBCore.Functions.ExecuteSql(false, "SELECT frequentie, naam FROM `portofoons` WHERE frequentie = '"..frequentie.."' ORDER BY naam", function(resultaat)
        if #resultaat > 0 then
            TriggerClientEvent("zb-radio:client:refreshLijst", -1, frequentie, json.encode(resultaat))
        else
            TriggerClientEvent("zb-radio:client:refreshLijst", -1, frequentie, json.encode(resultaat))
        end
    end)
end)





AddEventHandler("playerDropped", function(reason) 
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then
        local citizenid = Player.PlayerData.citizenid
        local frequentie = 0

        QBCore.Functions.ExecuteSql(false, "SELECT frequentie FROM `portofoons` WHERE citizenid = '"..citizenid.."' ORDER BY naam", function(resultaat)
            if #resultaat > 0 then
                frequentie = resultaat[1].frequentie

                QBCore.Functions.ExecuteSql(true, "DELETE FROM `portofoons` WHERE frequentie = '"..frequentie.."' AND citizenid = '"..citizenid.."'")

                QBCore.Functions.ExecuteSql(false, "SELECT frequentie, naam FROM `portofoons` WHERE frequentie = '"..frequentie.."' ORDER BY naam", function(resultaat)
                    if #resultaat > 0 then
                        TriggerClientEvent("zb-radio:client:refreshLijst", -1, frequentie, json.encode(resultaat))
                    else
                        TriggerClientEvent("zb-radio:client:refreshLijst", -1, frequentie, json.encode(resultaat))
                    end
                end)
            end

        end)
    end

end)