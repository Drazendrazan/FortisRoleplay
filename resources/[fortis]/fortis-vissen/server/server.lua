QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local vissen = {
    ["item"] = {
        [1] = {naam = "schol"},
        [2] = {naam = "zalm"},
        [3] = {naam = "baars"},
        [4] = {naam = "snoek"},
    }
}

local paletocove = 1
local paletocoveSpot1 = false
local paletocoveSpot2 = false
local paletocoveSpot3 = false

local kanaalstad = 1
local kanaalstad1 = false
local kanaalstad2 = false
local kanaalstad3 = false

local vinewood = 1
local vinewood1 = false
local vinewood2 = false
local vinewood3 = false

local cayo = 1
local cayo1 = false
local cayo2 = false
local cayo3 = false


-- Hengel opvragen
QBCore.Functions.CreateCallback("fortis-vissen:server:checkHengel", function(source, cb)
    Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("vishengel") ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

-- Visspot aantal opvragen
QBCore.Functions.CreateCallback("fortis-vissen:server:vraagSpotAantal", function(source, cb, visspotNaam)
    local Player = QBCore.Functions.GetPlayer(source)
    local visspotNaam = visspotNaam

    if visspotNaam == "paletocove" then
        cb(paletocove)
    elseif visspotNaam == "kanaalstad" then
        cb(kanaalstad)
    elseif visspotNaam == "vinewood" then
        cb(vinewood)
    elseif visspotNaam == "cayo" then
        cb(cayo)
    end
end)

-- Visspot reservatie
RegisterServerEvent("fortis-vissen:server:reserveerVisspot")
AddEventHandler("fortis-vissen:server:reserveerVisspot", function(visspotNaam)
    local visspotNaam = visspotNaam
    local steam = GetPlayerIdentifiers(source)[1]

    if visspotNaam == "paletocove" then
        if not paletocoveSpot1 then
            paletocove = paletocove + 1
            paletocoveSpot1 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 1, 2)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'paletocove', 1)")
            return
        end

        if not paletocoveSpot2 then
            paletocove = paletocove + 1
            paletocoveSpot2 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 1, 3)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'paletocove', 2)")
            return
        end

        if not paletocoveSpot3 then
            paletocove = paletocove + 1
            paletocoveSpot3 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 1, 4)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'paletocove', 3)")
            return
        end
        
    elseif visspotNaam == "kanaalstad" then
        if not kanaalstad1 then
            kanaalstad = kanaalstad + 1
            kanaalstad1 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 2, 2)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'kanaalstad', 1)")
            return
        end

        if not kanaalstad2 then
            kanaalstad = kanaalstad + 1
            kanaalstad2 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 2, 3)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'kanaalstad', 2)")
            return
        end

        if not kanaalstad3 then
            kanaalstad = kanaalstad + 1
            kanaalstad3 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 2, 4)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'kanaalstad', 3)")
            return
        end
    elseif visspotNaam == "vinewood" then
        if not vinewood1 then
            vinewood = vinewood + 1
            vinewood1 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 3, 2)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'vinewood', 1)")
            return
        end

        if not vinewood2 then
            vinewood = vinewood + 1
            vinewood2 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 3, 3)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'vinewood', 2)")
            return
        end

        if not vinewood3 then
            vinewood = vinewood + 1
            vinewood3 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 3, 4)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'vinewood', 3)")
            return
        end
    elseif visspotNaam == "cayo" then
        if not cayo1 then
            cayo = cayo + 1
            cayo1 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 4, 2)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'cayo', 1)")
            return
        end

        if not cayo2 then
            cayo = cayo + 1
            cayo2 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 4, 3)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'cayo', 2)")
            return
        end

        if not cayo3 then
            cayo = cayo + 1
            cayo3 = true
            TriggerClientEvent("fortis-vissen:server:startVissen", source, 4, 4)
            QBCore.Functions.ExecuteSql(true, "INSERT INTO `vissen` (steam, plek, positie) VALUES ('"..steam.."', 'cayo', 3)")
            return
        end
    end

end)

RegisterServerEvent("fortis-vissen:server:verwijderVisspot")
AddEventHandler("fortis-vissen:server:verwijderVisspot", function(visspot, verwijderSpotNummer)
    local steam = GetPlayerIdentifiers(source)[1]
    if visspot == "paletocove" then
        if verwijderSpotNummer == 1 then
            paletocove = paletocove - 1
            paletocoveSpot1 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end
        
        if verwijderSpotNummer == 2 then
            paletocove = paletocove - 1
            paletocoveSpot2 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end

        if verwijderSpotNummer == 3 then
            paletocove = paletocove - 1
            paletocoveSpot3 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end
    elseif visspot == "kanaalstad" then
        if verwijderSpotNummer == 1 then
            kanaalstad = kanaalstad - 1
            kanaalstad1 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end
        
        if verwijderSpotNummer == 2 then
            kanaalstad = kanaalstad - 1
            kanaalstad2 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end

        if verwijderSpotNummer == 3 then
            kanaalstad = kanaalstad - 1
            kanaalstad3 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end
    elseif visspot == "vinewood" then
        if verwijderSpotNummer == 1 then
            vinewood = vinewood - 1
            vinewood1 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end
        
        if verwijderSpotNummer == 2 then
            vinewood = vinewood - 1
            vinewood2 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end

        if verwijderSpotNummer == 3 then
            vinewood = vinewood - 1
            vinewood3 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end
    elseif visspot == "cayo" then
        if verwijderSpotNummer == 1 then
            cayo = cayo - 1
            cayo1 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end
        
        if verwijderSpotNummer == 2 then
            cayo = cayo - 1
            cayo2 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end

        if verwijderSpotNummer == 3 then
            cayo = cayo - 1
            cayo3 = false
            QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
            return
        end
    end
end)

-- Geef de vis

RegisterServerEvent("fortis-vissen:server:geefVis")
AddEventHandler("fortis-vissen:server:geefVis", function()
    local Player = QBCore.Functions.GetPlayer(source)

    local kop = math.random (1, 20)
    local munt = math.random(1, 20)

    if kop == munt then
        Player.Functions.AddItem("haring", 1)
        local itemData = QBCore.Shared.Items["haring"]
        TriggerClientEvent('inventory:client:ItemBox', source, itemData, "add")
        TriggerClientEvent("QBCore:Notify", source, "Je ving een zeldzame vis, een haring!", "success")
    else
        local randomVis = math.random(1, #vissen["item"])
        Player.Functions.AddItem(vissen["item"][randomVis].naam, 1)
        TriggerClientEvent("QBCore:Notify", source, "Je ving een "..vissen["item"][randomVis].naam.."!", "success")
        local itemData = QBCore.Shared.Items[vissen["item"][randomVis].naam]
        TriggerClientEvent('inventory:client:ItemBox', source, itemData, "add")
    end
end)

-- Verkoop die vissen
RegisterServerEvent("fortis-vissen:server:verkoopVissen")
AddEventHandler("fortis-vissen:server:verkoopVissen", function()
    local Player = QBCore.Functions.GetPlayer(source)
    local src = source
    local bedrag = 0

    if Player.Functions.GetItemByName("schol") ~= nil then
        local aantalVis = Player.Functions.GetItemByName("schol").amount
        Player.Functions.RemoveItem("schol", aantalVis)
        bedrag = bedrag + aantalVis * math.random(200, 350)
    end

    if Player.Functions.GetItemByName("zalm") ~= nil then
        local aantalVis = Player.Functions.GetItemByName("zalm").amount
        Player.Functions.RemoveItem("zalm", aantalVis)
        bedrag = bedrag + aantalVis * math.random(200, 350)
    end

    if Player.Functions.GetItemByName("baars") ~= nil then
        local aantalVis = Player.Functions.GetItemByName("baars").amount
        Player.Functions.RemoveItem("baars", aantalVis)
        bedrag = bedrag + aantalVis * math.random(200, 350)
    end

    if Player.Functions.GetItemByName("snoek") ~= nil then
        local aantalVis = Player.Functions.GetItemByName("snoek").amount
        Player.Functions.RemoveItem("snoek", aantalVis)
        bedrag = bedrag + aantalVis * math.random(200, 350)
    end

    if Player.Functions.GetItemByName("haring") ~= nil then
        local aantalVis = Player.Functions.GetItemByName("haring").amount
        Player.Functions.RemoveItem("haring", aantalVis)
        bedrag = bedrag + aantalVis * math.random(600, 1000)
    end

    Wait(200)
    if bedrag > 0 then
        Player.Functions.AddMoney("bank", bedrag, "Visjes verkocht bij pier")
        TriggerClientEvent("QBCore:Notify", src, "Je hebt al je vissen verkocht, je kreeg €"..bedrag, "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "Je hebt geen vissen bij je om te verkopen!", "error")
    end

end)

AddEventHandler('playerDropped', function()
    local src = source
    local steam = GetPlayerIdentifiers(src)[1]

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `vissen` WHERE steam = '"..steam.."'", function(result)
        if #result ~= 0 then
            local plek = result[1].plek
            local positie = result[1].positie


            -- Begin met verwijderen
            if plek == "paletocove" then
                if positie == 1 then
                    paletocove = paletocove - 1
                    paletocoveSpot1 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
                
                if positie == 2 then
                    paletocove = paletocove - 1
                    paletocoveSpot2 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
        
                if positie == 3 then
                    paletocove = paletocove - 1
                    paletocoveSpot3 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
            elseif plek == "kanaalstad" then
                if positie == 1 then
                    kanaalstad = kanaalstad - 1
                    kanaalstad1 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
                
                if positie == 2 then
                    kanaalstad = kanaalstad - 1
                    kanaalstad2 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
        
                if positie == 3 then
                    kanaalstad = kanaalstad - 1
                    kanaalstad3 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
            elseif plek == "vinewood" then
                if positie == 1 then
                    vinewood = vinewood - 1
                    vinewood1 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
                
                if positie == 2 then
                    vinewood = vinewood - 1
                    vinewood2 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
        
                if positie == 3 then
                    vinewood = vinewood - 1
                    vinewood3 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
            elseif plek == "cayo" then
                if positie == 1 then
                    cayo = cayo - 1
                    cayo1 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
                
                if positie == 2 then
                    cayo = cayo - 1
                    cayo2 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
        
                if positie == 3 then
                    cayo = cayo - 1
                    cayo3 = false
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `vissen` WHERE steam='"..steam.."'")
                    return
                end
            end
        end
    end)
end)