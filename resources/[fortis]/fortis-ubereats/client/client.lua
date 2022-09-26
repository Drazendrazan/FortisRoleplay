QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

-- Zet de blip op de kaart
Citizen.CreateThread(function ()
    local UberEatsBlip = AddBlipForCoord(-1194.8326, -893.4853, 15.0999)
    SetBlipSprite(UberEatsBlip, 106)
    SetBlipColour(UberEatsBlip, 1)
    SetBlipScale(UberEatsBlip, 0.6)
    SetBlipAsShortRange(UberEatsBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Burger Shot")
    EndTextCommandSetBlipName(UberEatsBlip)
end)

kassaLocatie = {
    ["locatie"] = {
        [1] = {x = -1194.5326, y = -893.2253, z = 14.3999,  text = "~g~E~w~ - Bestelling ophalen", type = "ophalen"}
    }
}

local bezorgLocaties = {
    ["locaties"] = {
        [1] = {x = -1931.8753, y = 162.4334, z = 84.6526},
        [2] = {x = -1896.3166, y = 642.6059, z =  130.2090},
        [3] = {x = -476.7636, y = 647.5765, z = 144.3866},
        [4] = {x = 224.7177, y = -160.8143, z = 59.2623},
        [5] = {x = 1101.0622, y = -411.3604, z =  67.5552},
        [6] = {x = 269.6034, y = -1712.8166, z =  29.6687},
        [7] = {x = 357.8389, y = -2073.4580, z =  21.7444},
        [8] = {x = -147.9474, y = -1687.5255, z =  33.0675},
        [9] = {x = 1315.8728, y = -1526.4689, z =  51.8070},
        [10] = {x = -293.4584, y = 600.8189, z =  181.5755},
        [11] = {x = -1023.4494, y = -1614.3505, z = 5.0884},
        [12] = {x = -946.7526, y = -1051.3629, z = 2.1718},
        [13] = {x = -1630.0017, y = 36.3674, z = 62.9361},
        [14] = {x = -1793.5295, y = -663.8021, z = 10.6047},
        [15] = {x = -1328.6535, y = -919.4862, z = 11.5008},
    }
}

local ophalenMogelijk = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        letsleep = true
        
        for k, locatie in pairs(kassaLocatie["locatie"]) do
            local kassa = GetDistanceBetweenCoords(pos, -1194.8326, -893.4853, 15.0999)
            if kassa < 15 then
                letsleep = false
                DrawMarker(2, locatie.x, locatie.y, locatie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                if kassa < 3 then
                    QBCore.Functions.DrawText3D(locatie.x, locatie.y, locatie.z - 0.10, locatie.text)

                    if IsControlJustPressed(0, 38) then
                        if ophalenMogelijk == false then
                            QBCore.Functions.Progressbar("verzamel", "Bestelling ophalen...", 7000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "anim@heists@ornate_bank@grab_cash",
                                anim = "grab",
                                flags = 16,
                            }, {}, {}, function()
                                QBCore.Functions.Notify("Je hebt een bestelling ontvangen!", "success")
                                TriggerServerEvent("fortis-ubereats:server:addBestelling")
                                TriggerEvent("fortis-ubereats:client:krijgLocatie")
                                ClearPedTasks(GetPlayerPed(-1))

                                ophalenMogelijk = true
                            end)

                        else
                            QBCore.Functions.Notify("Je hebt al een bestelling opgehaald, bezorg deze eerst.", "error")
                        end                        
                    end
                end
            end
        end

        if letsleep then
            Wait(500)
        end
    end
end)

AddEventHandler("fortis-ubereats:client:krijgLocatie", function()
    local randomLocatie = math.random(1, #bezorgLocaties["locaties"])
    local missieLocatie = bezorgLocaties["locaties"][randomLocatie]

    MissieBlip = AddBlipForCoord(missieLocatie.x, missieLocatie.y, missieLocatie.z)
    SetBlipColour(MissieBlip, 41)
    SetBlipRoute(MissieBlip, true)
    SetBlipRouteColour(MissieBlip, 41)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)

            local missiePedPositie = GetEntityCoords(GetPlayerPed(-1))
            local missiePed = GetPlayerPed(-1)

            local missieDistance = GetDistanceBetweenCoords(missiePedPositie, missieLocatie.x, missieLocatie.y, missieLocatie.z)
            if ophalenMogelijk == true then
                if missieDistance < 10 then
                    DrawMarker(2, missieLocatie.x, missieLocatie.y, missieLocatie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                    if missieDistance < 2 then
                        QBCore.Functions.DrawText3D(missieLocatie.x, missieLocatie.y, missieLocatie.z - 0.10, "~g~E~w~ - Bezorgen")
                        if IsControlJustPressed(0, 38) then
                            if IsPedInAnyVehicle(missiePed, false) then
                                QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
                            else
                                QBCore.Functions.TriggerCallback("fortis-ubereats:server:requestBestelling", function(aantal)
                                    if aantal < 1 then
                                        QBCore.Functions.Notify("Je hebt de bestelling niet bij je!", "error")
                                    else
                                        TriggerServerEvent("fortis-ubereats:server:removeBestelling")
                                        ophalenMogelijk = false
                                        RemoveBlip(MissieBlip)
                                        return
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)
end)