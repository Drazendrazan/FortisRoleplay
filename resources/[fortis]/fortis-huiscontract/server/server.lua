QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateUseableItem("makelaarscontract", function(source, item)
    TriggerClientEvent("fortis-huiscontract:client:useItem", source)
end)

verkopers = {}

QBCore.Functions.CreateCallback("fortis-huiscontract:server:checkHuisOwner", function(source, cb, huis)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local kenteken = kenteken

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE citizenid = '"..citizenid.."' AND house = '"..huis.."'", function(resultaat)
        if #resultaat == 0 then
            cb(false)
        else
            cb(true)
        end
    end)
end)
 
RegisterServerEvent("fortis-huiscontract:server:geefContract")
AddEventHandler("fortis-huiscontract:server:geefContract", function(target, bedrag, huis)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    local citizenid = Player.PlayerData.citizenid

    verkopers[huis] = {
        ["owner"] = citizenid,
        ["ownersrc"] = src,
        ["bedrag"] = bedrag
    }

    TriggerClientEvent("fortis-huiscontract:client:krijgContract", target, bedrag, huis)
end)

RegisterServerEvent("fortis-huiscontract:server:koopHuis")
AddEventHandler("fortis-huiscontract:server:koopHuis", function(bedrag, huis)
    local src = source
    local bedrag = tonumber(bedrag)

    for k, v in pairs(verkopers) do
        if k == huis then
            if tonumber(v.bedrag) == bedrag then
                local koperSrc = v.ownersrc

                local playerKoper = QBCore.Functions.GetPlayer(src)
                local playerVerkoper = QBCore.Functions.GetPlayer(koperSrc)
 
                local oudeCitizenid = playerVerkoper.PlayerData.citizenid
                local nieuweCitizenid = playerKoper.PlayerData.citizenid
                local nieuweSteamID = playerKoper.PlayerData.steam

                if playerKoper.PlayerData.money["bank"] >= bedrag and playerKoper.PlayerData.money["bank"] > 0 then
                    if playerVerkoper.Functions.GetItemByName("makelaarscontract") ~= nil and playerVerkoper.Functions.GetItemByName("makelaarscontract").amount > 0 then
                        verkopers[k] = nil
                    
                        playerKoper.Functions.RemoveMoney("bank", bedrag, "Kocht een woning via huiscontract: "..huis)
                        playerVerkoper.Functions.AddMoney("bank", bedrag, "Verkocht een woning via huiscontract: "..huis)

                        playerVerkoper.Functions.RemoveItem("makelaarscontract", 1)
    
                        TriggerClientEvent('QBCore:Notify', v.ownersrc, "Je hebt je woning verkocht voor €"..v.bedrag.."!", "success")
                        TriggerClientEvent('QBCore:Notify', src, "Je hebt de woning gekocht voor €"..v.bedrag.."!", "success")
                        local keyholders = "null"
                        QBCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET citizenid = '"..nieuweCitizenid.."', identifier = '"..nieuweSteamID.."' WHERE house = '"..huis.."'")
                    	QBCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `keyholders` = '["..json.encode(nieuweCitizenid).."]' WHERE `house` = '"..huis.."'")
                        TriggerClientEvent('qb-houses:client:refreshHouse', playerKoper)
                        TriggerClientEvent('qb-houses:client:refreshHouse', playerVerkoper)
                    else
                        TriggerClientEvent('QBCore:Notify', v.ownersrc, "Je hebt geen huis contract meer... vaag?", "error")
                    end 
                else
                    verkopers[k] = nil
                    TriggerClientEvent('QBCore:Notify', v.ownersrc, "De persoon die je huis probeerde te kopen had niet genoeg geld op de bank.", "error")
                    TriggerClientEvent('QBCore:Notify', src, "Je hebt niet genoeg geld op je bank staan!", "error")
                end
            else
                verkopers[k] = nil
                local src = source
                local reason = "Verbannen voor hacken, bedrag aanpassen tijdens het verkopen van een huis met een huis."
                QBCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(src).."', '"..GetPlayerIdentifiers(src)[1].."', '"..GetPlayerIdentifiers(src)[2].."', '"..GetPlayerIdentifiers(src)[3].."', '"..GetPlayerIdentifiers(src)[4].."', '"..reason.."', 2145913200, '"..GetPlayerName(src).."')")
                DropPlayer(src, "Verbannen voor hacken, bedrag aanpassen tijdens het verkopen van een huis met een huiscontract.")
            end
        end
    end
end)
 
RegisterServerEvent("fortis-huiscontract:server:koopcontract")
AddEventHandler("fortis-huiscontract:server:koopcontract", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.money["bank"] >= 5000 then
        Player.Functions.RemoveMoney("bank", 5000, "Voertuig contract gekocht")
        Player.Functions.AddItem("makelaarscontract", 1)
        TriggerClientEvent('QBCore:Notify', src, "Je hebt een huis contract gekocht!", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Je hebt geen €5000 om een huis contract te kunnen kopen!", "error")
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