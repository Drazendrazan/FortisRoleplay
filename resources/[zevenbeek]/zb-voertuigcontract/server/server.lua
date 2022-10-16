QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateUseableItem("contract", function(source, item)
    TriggerClientEvent("zb-voertuigcontract:client:useItem", source)
end)

verkopers = {}

QBCore.Functions.CreateCallback("zb-voertuigcontract:server:checkVoertuigOwner", function(source, cb, kenteken, boot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local kenteken = kenteken
    print(kenteken, boot)

    if not boot then
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE citizenid = '"..citizenid.."' AND plate = '"..kenteken.."'", function(resultaat)
            if #resultaat == 0 then
                cb(false)
            else
                cb(true)
            end
        end)
    else
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_boats` WHERE citizenid = '"..citizenid.."' AND plate = '"..kenteken.."'", function(resultaat)
            if #resultaat == 0 then
                cb(false)
            else
                cb(true)
            end
        end)
    end
end)

RegisterServerEvent("zb-voertuigcontract:server:geefContract")
AddEventHandler("zb-voertuigcontract:server:geefContract", function(target, bedrag, kenteken)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    local citizenid = Player.PlayerData.citizenid

    verkopers[kenteken] = {
        ["owner"] = citizenid,
        ["ownersrc"] = src,
        ["bedrag"] = bedrag
    }

    TriggerClientEvent("zb-voertuigcontract:client:krijgContract", target, bedrag, kenteken)
    print(dump(verkopers))
end)

RegisterServerEvent("zb-voertuigcontract:server:koopVoertuig")
AddEventHandler("zb-voertuigcontract:server:koopVoertuig", function(bedrag, kenteken, boot)
    local src = source
    local bedrag = tonumber(bedrag)

    for k, v in pairs(verkopers) do
        if k == kenteken then
            if tonumber(v.bedrag) == bedrag then
                local koperSrc = v.ownersrc

                local playerKoper = QBCore.Functions.GetPlayer(src)
                local playerVerkoper = QBCore.Functions.GetPlayer(koperSrc)

                local oudeCitizenid = playerVerkoper.PlayerData.citizenid
                local nieuweCitizenid = playerKoper.PlayerData.citizenid
                local nieuweSteamID = playerKoper.PlayerData.steam

                if playerKoper.PlayerData.money["bank"] >= bedrag and playerKoper.PlayerData.money["bank"] > 0 then
                    if playerVerkoper.Functions.GetItemByName("contract") ~= nil and playerVerkoper.Functions.GetItemByName("contract").amount > 0 then
                        verkopers[k] = nil
                    
                        playerKoper.Functions.RemoveMoney("bank", bedrag, "Kocht voertuig via voertuigcontract: "..kenteken)
                        playerVerkoper.Functions.AddMoney("bank", bedrag, "Verkocht voertuig via voertuigcontract: "..kenteken)

                        playerVerkoper.Functions.RemoveItem("contract", 1)
    
                        TriggerClientEvent('QBCore:Notify', v.ownersrc, "Je hebt je voertuig verkocht voor €"..v.bedrag.."!", "success")
                        TriggerClientEvent('QBCore:Notify', src, "Je hebt het voertuig gekocht voor €"..v.bedrag.."!", "success")
                        if not boot then
                            QBCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET citizenid = '"..nieuweCitizenid.."', steam = '"..nieuweSteamID.."' WHERE plate = '"..kenteken.."'")
                        else
                            QBCore.Functions.ExecuteSql(true, "UPDATE `player_boats` SET citizenid = '"..nieuweCitizenid.."' WHERE plate = '"..kenteken.."'")
                        end
                    else
                        TriggerClientEvent('QBCore:Notify', v.ownersrc, "Je hebt geen voertuig contract meer... vaag?", "error")
                    end
                else
                    verkopers[k] = nil
                    TriggerClientEvent('QBCore:Notify', v.ownersrc, "De persoon die je voertuig probeerde te kopen had niet genoeg geld op de bank.", "error")
                    TriggerClientEvent('QBCore:Notify', src, "Je hebt niet genoeg geld op je bank staan!", "error")
                end
            else
                verkopers[k] = nil
                local src = source
                local reason = "Verbannen voor hacken, bedrag aanpassen tijdens het verkopen van een auto met een autocontract."
                QBCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(src).."', '"..GetPlayerIdentifiers(src)[1].."', '"..GetPlayerIdentifiers(src)[2].."', '"..GetPlayerIdentifiers(src)[3].."', '"..GetPlayerIdentifiers(src)[4].."', '"..reason.."', 2145913200, '"..GetPlayerName(src).."')")
                DropPlayer(src, "Verbannen voor hacken, bedrag aanpassen tijdens het verkopen van een auto met een autocontract.")
            end
        end
    end
end)

QBCore.Functions.CreateCallback("zb-voertuigcontract:server:checkVliegtuigOwner", function(source, cb, kenteken, boot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local kenteken = kenteken
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_planes` WHERE citizenid = '"..citizenid.."' AND plate = '"..kenteken.."'", function(resultaat)
        if #resultaat == 0 then
            cb(false)
        else
            cb(true)
        end
    end)
end)

RegisterServerEvent("zb-voertuigcontract:server:koopVliegmachine")
AddEventHandler("zb-voertuigcontract:server:koopVliegmachine", function(bedrag, kenteken, heli)
    local src = source
    local bedrag = tonumber(bedrag)

    for k, v in pairs(verkopers) do
        if k == kenteken then
            if tonumber(v.bedrag) == bedrag then
                local koperSrc = v.ownersrc

                local playerKoper = QBCore.Functions.GetPlayer(src)
                local playerVerkoper = QBCore.Functions.GetPlayer(koperSrc)

                local oudeCitizenid = playerVerkoper.PlayerData.citizenid
                local nieuweCitizenid = playerKoper.PlayerData.citizenid
                local nieuweSteamID = playerKoper.PlayerData.steam

                if playerKoper.PlayerData.money["bank"] >= bedrag and playerKoper.PlayerData.money["bank"] > 0 then
                    if playerVerkoper.Functions.GetItemByName("contract") ~= nil and playerVerkoper.Functions.GetItemByName("contract").amount > 0 then
                        verkopers[k] = nil
                    
                        playerKoper.Functions.RemoveMoney("bank", bedrag, "Kocht voertuig via voertuigcontract: "..kenteken)
                        playerVerkoper.Functions.AddMoney("bank", bedrag, "Verkocht voertuig via voertuigcontract: "..kenteken)

                        playerVerkoper.Functions.RemoveItem("contract", 1)
    
                        TriggerClientEvent('QBCore:Notify', v.ownersrc, "Je hebt je voertuig verkocht voor €"..v.bedrag.."!", "success")
                        TriggerClientEvent('QBCore:Notify', src, "Je hebt het voertuig gekocht voor €"..v.bedrag.."!", "success")
                        QBCore.Functions.ExecuteSql(true, "UPDATE `player_planes` SET citizenid = '"..nieuweCitizenid.."', steam = '"..nieuweSteamID.."' WHERE plate = '"..kenteken.."'")
                    else
                        TriggerClientEvent('QBCore:Notify', v.ownersrc, "Je hebt geen voertuig contract meer... vaag?", "error")
                    end
                else
                    verkopers[k] = nil
                    TriggerClientEvent('QBCore:Notify', v.ownersrc, "De persoon die je voertuig probeerde te kopen had niet genoeg geld op de bank.", "error")
                    TriggerClientEvent('QBCore:Notify', src, "Je hebt niet genoeg geld op je bank staan!", "error")
                end
            else
                verkopers[k] = nil
                local src = source
                local reason = "Verbannen voor hacken, bedrag aanpassen tijdens het verkopen van een auto met een autocontract."
                QBCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(src).."', '"..GetPlayerIdentifiers(src)[1].."', '"..GetPlayerIdentifiers(src)[2].."', '"..GetPlayerIdentifiers(src)[3].."', '"..GetPlayerIdentifiers(src)[4].."', '"..reason.."', 2145913200, '"..GetPlayerName(src).."')")
                DropPlayer(src, "Verbannen voor hacken, bedrag aanpassen tijdens het verkopen van een auto met een autocontract.")
            end
        end
    end
end)

RegisterServerEvent("zb-voertuigcontract:server:koopcontract")
AddEventHandler("zb-voertuigcontract:server:koopcontract", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.money["bank"] >= 5000 then
        Player.Functions.RemoveMoney("bank", 5000, "Voertuig contract gekocht")
        Player.Functions.AddItem("contract", 1)
        TriggerClientEvent('QBCore:Notify', src, "Je hebt een voertuig contract gekocht!", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Je hebt geen €5000 om een voertuig contract te kunnen kopen!", "error")
    end

end)






function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end