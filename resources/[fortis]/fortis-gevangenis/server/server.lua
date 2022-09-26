QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("celstraf", "Stuurt persoon naar de gevangenis. (Politie)", {{name="maanden", help="Maanden"}, {name="id", help="Spelers ID"}}, true, function(source, args)
    local maanden = tonumber(args[1])
    local spelerID = tonumber(args[2])
    TriggerClientEvent("fortis-gevangenis:client:stuurGevangenis", source, maanden, spelerID)
end)

RegisterNetEvent("fortis-gevangenis:server:stuurGevangenis")
AddEventHandler("fortis-gevangenis:server:stuurGevangenis", function(maanden, spelerID)
    if spelerID ~= source then
        TriggerClientEvent('fortis-gevangenis:client:uitzitten', spelerID, maanden, true)
        local steam = GetPlayerIdentifiers(spelerID)[1]
        QBCore.Functions.ExecuteSql(true, "INSERT INTO `cellstraf` (`steam`, `maanden`) VALUES ('"..steam.."', '"..maanden.."')")

        local data = {
            ["actie"] = "Celstraf gegeven",
            ["aan"] = steam,
            ["maanden"] = maanden
        }
        QBCore.Functions.AddLog(source, "gevangenis", data)
    end
end)

RegisterNetEvent("fortis-gevangenis:server:updateMaanden")
AddEventHandler("fortis-gevangenis:server:updateMaanden", function(maanden)
    local steam = GetPlayerIdentifiers(source)[1]
    QBCore.Functions.ExecuteSql(true, "UPDATE `cellstraf` SET maanden = '"..maanden.."' WHERE steam = '"..steam.."'")
end)

RegisterNetEvent("fortis-gevangenis:server:loginStrafCheck")
AddEventHandler("fortis-gevangenis:server:loginStrafCheck", function(spelerID)
    local steam = GetPlayerIdentifiers(spelerID)[1]
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `cellstraf` WHERE steam = '"..steam.."'", function(resultaat)
        if #resultaat == 0 then
        else
            Wait(4500)
            TriggerClientEvent('fortis-gevangenis:client:uitzitten', spelerID, resultaat[1].maanden, false)
        end
    end)
end)

-- Jobs

RegisterNetEvent("fortis-gevangenis:server:krijgGeld")
AddEventHandler("fortis-gevangenis:server:krijgGeld", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local aantal = math.random(250, 500)

    Player.Functions.AddMoney("cash", aantal, "Opdrukken/schoonmaken in de gevangenis")
    TriggerClientEvent('QBCore:Notify', src, "Goed gedaan! Je kreeg €"..aantal, "success")
end)

RegisterNetEvent("fortis-gevangenis:server:krijgBroodjes")
AddEventHandler("fortis-gevangenis:server:krijgBroodjes", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem("sandwich", 5)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["sandwich"], "add")
    TriggerClientEvent('QBCore:Notify', src, "De kok is blij met je, je kreeg 5 broodjes!", "success")
end)

RegisterNetEvent("fortis-gevangenis:server:guardOmkopen")
AddEventHandler("fortis-gevangenis:server:guardOmkopen", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local steam = GetPlayerIdentifiers(source)[1]
    local kans = math.random(1,3)

    if Player.PlayerData.money["bank"] >= 1000 then
        Player.Functions.RemoveMoney("bank", 1000, "Beveiliger omkopen in de gevangenis")
    else
        TriggerClientEvent('QBCore:Notify', src, "Je hebt niet genoeg geld om de beveiliger om te kopen!", "error")
    end
        
end)




-- Communicatie middelen
RegisterNetEvent("fortis-gevangenis:server:pakTelliesAf")
AddEventHandler("fortis-gevangenis:server:pakTelliesAf", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    local steam = GetPlayerIdentifiers(source)[1]

    local telefoonAantal2 = 0
    local fortelAantal2 = 0 
    local portofoonAantal2 = 0 
    local simkaart = 0
    

    if Player.Functions.GetItemByName("phone") ~= nil then
        while true do 
            if Player.Functions.GetItemByName("phone") ~= nil then
                local telefoonAantal = Player.Functions.GetItemByName("phone").amount
                Player.Functions.RemoveItem("phone", telefoonAantal)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["phone"], "remove")
                telefoonAantal2 = telefoonAantal2 + telefoonAantal
            else
                break
            end
        end
    end

    if Player.Functions.GetItemByName("fortel") ~= nil then
        while true do 
            if Player.Functions.GetItemByName("fortel") ~= nil then
                local fortel = Player.Functions.GetItemByName("fortel")
                local fortelAantal = Player.Functions.GetItemByName("fortel").amount
                Player.Functions.RemoveItem("fortel", fortelAantal)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["fortel"], "remove")
                fortelAantal2 = fortelAantal2 + fortelAantal

                if fortel.info.simkaart ~= nil then
                    simkaart = 1
                end
            else
                break
            end
        end
    end

    if Player.Functions.GetItemByName("radio") ~= nil then
        while true do 
            if Player.Functions.GetItemByName("radio") ~= nil then
                local portofoonAantal = Player.Functions.GetItemByName("radio").amount
                Player.Functions.RemoveItem("radio", portofoonAantal)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["radio"], "remove")
                portofoonAantal2 = portofoonAantal2 + portofoonAantal
            else
                break
            end
        end
    end

    QBCore.Functions.ExecuteSql(true, "UPDATE `cellstraf` SET telefoon = "..telefoonAantal2..", portofoon = "..portofoonAantal2..", fortel = "..fortelAantal2..", simkaart = "..simkaart.." WHERE steam = '"..steam.."' ")

    TriggerClientEvent('qb-radio:onRadioDrop', src)
end)

RegisterNetEvent("fortis-gevangenis:server:klaarMetStraf")
AddEventHandler("fortis-gevangenis:server:klaarMetStraf", function()
    local src = source
    local steam = GetPlayerIdentifiers(source)[1]
    local Player = QBCore.Functions.GetPlayer(source)

    local telefoonAantal = 0
    local portofoonAantal = 0
    local fortelAantal = 0

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `cellstraf` WHERE steam = '"..steam.."'", function(resultaat)
        telefoonAantal = resultaat[1].telefoon
        portofoonAantal = resultaat[1].portofoon
        fortelAantal = resultaat[1].fortel
        simkaart = resultaat[1].simkaart
    end)

    Wait(2000)

    QBCore.Functions.ExecuteSql(true, "DELETE FROM `cellstraf` WHERE steam = '"..steam.."'")

    Wait(2000)

    if telefoonAantal > 0 then
        Player.Functions.AddItem("phone", telefoonAantal)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["phone"], "add")
    end

    if fortelAantal > 0 then
        if simkaart then
            local info = {simkaart=true}
            Player.Functions.AddItem("fortel", 1, nil, info)
        else
            Player.Functions.AddItem("fortel", 1)
        end
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["fortel"], "add")
    end

    if portofoonAantal > 0 then
        Player.Functions.AddItem("radio", portofoonAantal)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["radio"], "add")
    end
end)

RegisterNetEvent("fortis-gevangenis:server:klaarUitbraak")
AddEventHandler("fortis-gevangenis:server:klaarUitbraak", function()
    local src = source
    local steam = GetPlayerIdentifiers(source)[1]
    local Player = QBCore.Functions.GetPlayer(source)

    QBCore.Functions.ExecuteSql(true, "DELETE FROM `cellstraf` WHERE steam = '"..steam.."'")
    TriggerClientEvent("QBCore:Notify", src, "Je bent uitgebroken!", "error")

    local data = {
        ["actie"] = "uitgebroken",
    }
    QBCore.Functions.AddLog(source, "gevangenis", data)
end)