QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
end)


RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name == ("pakketpost")  then
        local PakketBezorgerBlip = AddBlipForCoord(717.02856445312, -964.10101318359, 30.395351409912)
        SetBlipSprite(PakketBezorgerBlip, 478)
        SetBlipColour(PakketBezorgerBlip, 2)
        SetBlipScale(PakketBezorgerBlip, 0.8)
        SetBlipAsShortRange(PakketBezorgerBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Pakket post")
        EndTextCommandSetBlipName(PakketBezorgerBlip)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name == ("pakketpost")  then
        local PakketBezorgerBlip = AddBlipForCoord(717.02856445312, -964.10101318359, 30.395351409912)
        SetBlipSprite(PakketBezorgerBlip, 478)
        SetBlipColour(PakketBezorgerBlip, 2)
        SetBlipScale(PakketBezorgerBlip, 0.8)
        SetBlipAsShortRange(PakketBezorgerBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Pakket post")
        EndTextCommandSetBlipName(PakketBezorgerBlip)
    end
end)

-- -- Zet de blip op de kaart
-- Citizen.CreateThread(function()
--     local PlayerData = QBCore.Functions.GetPlayerData()
--     local job = PlayerData.job.name
--     if job == ("pakketpost")  then
--         local PakketBezorgerBlip = AddBlipForCoord(717.02856445312, -964.10101318359, 30.395351409912)
--         SetBlipSprite(PakketBezorgerBlip, 478)
--         SetBlipColour(PakketBezorgerBlip, 2)
--         SetBlipScale(PakketBezorgerBlip, 0.8)
--         SetBlipAsShortRange(PakketBezorgerBlip, true)
--         BeginTextCommandSetBlipName("STRING")
--         AddTextComponentString("Pakket post")
--         EndTextCommandSetBlipName(PakketBezorgerBlip)
--     end
-- end)

-- Locaties
actieLocaties = {
    ["locaties"] = {
        [1] = {x = 716.15350341797, y = -959.59428955078, z = 30.39533996582, text = "~g~E~w~ - Verzamel pakketjes", type = "verzamel"}, -- Verzamel
        [2] = {x = 711.51831054688, y = -969.5615234375, z = 30.395318984985, text = "~g~E~w~ - Verpak pakketjes", type = "verpak"}, -- Verpak
        [3] = {x = 707.17913818359, y = -966.89337158203, z = 30.412853240967, text = "~g~E~w~ - Bezorgen", type= "bezorg"}, -- Bezorgen
        [4] = {x = 718.18780517578, y = -979.06732177734, z = 24.117416381836, text = "~g~E~w~ - Auto inleveren", type = "inleveren"}, -- Auto wegzet cirkel
    }
}

local bezorgLocaties = {
    ["locaties"] = {
        [1] = {x = 871.67578125, y = -1016.4053955078, z = 31.867671966553},
        [2] = {x = 807.28857421875, y = -1073.4519042969, z = 28.920904159546},
        [3] = {x = 444.32208251953, y = -942.99645996094, z = 28.763458251953},
        [4] = {x = -177.06715393066, y = -1157.7791748047, z = 23.489805221558},
        [5] = {x = -59.524757385254, y = -616.23559570312, z = 37.356781005859},
        [6] = {x = -244.85289001465, y = -353.99560546875, z = 29.990398406982},
        [7] = {x = -600.0240785156, y = -251.34255981445, z = 36.256271362305},
        [8] = {x = -581.52258300781, y = -985.14300537109, z = 22.329704284668},
        [9] = {x = -827.69653320312, y = -1090.0422363281, z = 11.138589859009},
        [10] = {x = -1069.3345947266, y = -1514.9318847656, z = 5.1072626113892},
        [11] = {x = -1471.4276123047, y = -920.48583984375, z = 10.024920463562},
        [12] = {x = -1411.7338867188, y = -654.01287841797, z = 28.673391342163},
        [13] = {x = -786.95733642578, y = 37.083892822266, z = 48.238098144531},
        [14] = {x = 876.59722900391, y = -1577.21484375, z = 30.82706451416},
        [15] = {x = 495.62289428711, y = -1822.8928222656, z = 28.869707107544},
        [16] = {x = 225.01724243164, y = -1511.3317871094, z = 29.291654586792},
        [17] = {x = -39.147750854492, y = -1388.1015625, z = 30.491800308228},
        [18] = {x = -428.93130493164, y = -1728.1534423828, z = 19.783836364746},
        [19] = {x = -534.37286376953, y = -2200.9018554688, z = 6.3033423423767},
        [20] = {x = -1042.53100858594, y = -2023.3486328125, z = 13.161571502686},
        [21] = {x = 119.34064483643, y = 494.17959594727, z = 147.34295654297},
        [22] = {x = -762.53363037109, y = 431.7184753418, z = 100.05448150635},
        [23] = {x = -1492.7642822266, y = -149.51332092285, z = 52.50927734375},
        [24] = {x = -1546.7828369141, y = -467.12973022461, z = 36.189575195312},
        [25] = {x = -3031.177734375, y = 92.63159942627, z = 12.346241950989},
    }
}

-- Locals
local bezorgStatus = false
local missieStatus = false
local start = false

-- Zet interacties neer
Citizen.CreateThread(function()
    while PlayerData == nil do Wait(500) end
    while PlayerData.job == nil do Wait(500) end
    while true do
        if PlayerData.job.name == "pakketpost" then

            Citizen.Wait(1)
            local pedPositie = GetEntityCoords(GetPlayerPed(-1))
            local ped = GetPlayerPed(-1)
            
            letsleep = true
            
            for k, locatie in pairs(actieLocaties["locaties"]) do
                local distance = GetDistanceBetweenCoords(pedPositie, locatie.x, locatie.y, locatie.z, true)
                if distance < 9 then
                    letsleep = false
                    DrawMarker(2, locatie.x, locatie.y, locatie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 222, 11, 11, 155, false, false, false, true, false, false, false)
                    if distance < 3 then
                        QBCore.Functions.DrawText3D(locatie.x, locatie.y, locatie.z - 0.10, locatie.text)
                        
                        -- Wanneer E wordt ingedrukt:
                        if IsControlJustPressed(0, 38) then
                            local typeActie = locatie.type
                            if typeActie == "verzamel" then -- Verzamel
                                QBCore.Functions.Progressbar("verzamel", "Pakketje verzamelen...", 5000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = "anim@heists@narcotics@trash",
                                    anim = "pickup",
                                    flags = 16,
                                }, {}, {}, function() -- Actie netjes afgemaakt
                                    QBCore.Functions.Notify("Je hebt 1 pakketje erbij gekregen.", "success")
                                    TriggerServerEvent("fortis-pakketpost:server:addPakketje")
                                end, function() -- Actie geannuleerd
                                    QBCore.Functions.Notify("Je hebt de actie geannuleerd", "error")
                                end)
                            elseif typeActie == "verpak" then -- Verpak
                                QBCore.Functions.TriggerCallback("fortis-pakketpost:server:requestPakketjesAantal", function(aantal)
                                    if aantal == 1 then
                                        QBCore.Functions.Progressbar("verpak", "Pakketje verpakken...", 5000, false, true, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "anim@heists@narcotics@trash",
                                            anim = "pickup",
                                            flags = 16,
                                        }, {}, {}, function() -- Actie netjes afgemaakt
                                            QBCore.Functions.TriggerCallback("fortis-pakketpost:server:requestPakketjesAantal", function(aantal)
                                                if aantal == 0 then
                                                    -- Persoon doet iets raar, hij heeft de pakketjes gedropt
                                                    QBCore.Functions.Notify("Je hebt geen 5 pakketjes meer... dit vind ik vreemd.", "error")
                                                elseif aantal == 1 then
                                                    -- Persoon heeft niet de items gedropt tussendoor
                                                    QBCore.Functions.Notify("Je hebt 1 pakketje verpakt.", "success")
                                                    TriggerServerEvent("fortis-pakketpost:server:addVerpaktPakketje")
                                                end
                                            end)
                                        end, function() -- Actie geannuleerd
                                            QBCore.Functions.Notify("Je hebt de actie geannuleerd", "error")
                                        end)
                                    elseif aantal == 0 then
                                        QBCore.Functions.Notify("Je hebt niet genoeg pakketjes.", "error")
                                    end
                                end)
                            elseif typeActie == "bezorg" then -- Bezorg missie starten
                                QBCore.Functions.TriggerCallback("fortis-pakketpost:server:requestVerpaktePakketjesAantal", function(aantalCode, aantal)
                                    if aantalCode == 0 then
                                        -- Persoon heeft niet genoeg verpakte pakketjes (5)
                                        QBCore.Functions.Notify("Je moet minimaal 5 verpakte pakketjes hebben!", "error")
                                    elseif aantalCode == 1 then
                                        -- Persoon heeft genoeg verpakte pakketjes (5+)
                                        if missieStatus == false then -- Kijk of er al een missie gestart is
                                            local coords = {x = 715.36926269531, y = -985.32025146484, z = 24.133749008179, h = 269.8}
                                            QBCore.Functions.SpawnVehicle("pakketpost", function(voertuig)
                                                SetEntityHeading(voertuig, coords.h)
                                                exports['LegacyFuel']:SetFuel(voertuig, 100.0)
                                                SetEntityAsMissionEntity(voertuig, true, true)
                                                TaskWarpPedIntoVehicle(GetPlayerPed(-1), voertuig, -1)
                                                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(voertuig))
                                                SetVehicleEngineOn(voertuig, true, true)
                                            end, coords, true)
                                            missieStatus = true -- Zet de missie status op true zodat hij er niet nog een kan starten
                                            TriggerServerEvent("fortis-pakketpost:server:borg", true)
                                            TriggerEvent("fortis-pakketpost:client:nieuweMissieLocatie", aantal)
                                            QBCore.Functions.Notify("Je hebt je bezorg ronde gestart, er is €1000 borg afgeschreven voor je busje", "success")
                                        else
                                            QBCore.Functions.Notify("Je bent al bezig met een missie, of je hebt je voertuig niet ingeleverd!", "error")
                                        end
                                    
                                    end
                                end)
                            elseif typeActie == "inleveren" then -- Voertuig inleveren
                                if missieStatus == true then
                                    if IsPedInAnyVehicle(ped, false) then
                                        local inleverVoertuig = GetEntityModel(GetVehiclePedIsIn(ped))
                                        if inleverVoertuig == GetHashKey("pakketpost") then
                                            DeleteVehicle(GetVehiclePedIsIn(ped))
                                            missieStatus = false
                                            QBCore.Functions.Notify("Je hebt je voertuig netjes ingeleverd en de borg is teruggestort.", "success")
                                            TriggerServerEvent("fortis-pakketpost:server:borg", false)
                                            RemoveBlip(MissieBlip)
                                            start = false
                                        else
                                            QBCore.Functions.Notify("Je zit niet in je bedrijfs voertuig!", "error")
                                        end
                                    else
                                        QBCore.Functions.Notify("Je zit niet in je bedrijfs voertuig!", "error")
                                    end
                                else
                                    QBCore.Functions.Notify("Je hebt geen voertuig om in te leveren!", "error")
                                end
                            end
                        end
                    end
                end
            end
        
            if letsleep then
                Wait(500)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

AddEventHandler("fortis-pakketpost:client:nieuweMissieLocatie", function(aantal)
    local pakketAantal = aantal
    local randomLocatie = math.random(1, #bezorgLocaties["locaties"])
    local missieLocatie = bezorgLocaties["locaties"][randomLocatie]
    start = true

    MissieBlip = AddBlipForCoord(missieLocatie.x, missieLocatie.y, missieLocatie.z)
    SetBlipColour(MissieBlip, 3)
    SetBlipRoute(MissieBlip, true)
    SetBlipRouteColour(MissieBlip, 3)

    Citizen.CreateThread(function()
        while start do
            Citizen.Wait(1)

            local missiePedPositie = GetEntityCoords(GetPlayerPed(-1))
            local missiePed = GetPlayerPed(-1)
            letsleep = true

            local missieDistance = GetDistanceBetweenCoords(missiePedPositie, missieLocatie.x, missieLocatie.y, missieLocatie.z)
            if missieDistance < 15 then
                letsleep = false
                DrawMarker(2, missieLocatie.x, missieLocatie.y, missieLocatie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 222, 11, 11, 155, false, false, false, true, false, false, false)
                if missieDistance < 4 then
                    QBCore.Functions.DrawText3D(missieLocatie.x, missieLocatie.y, missieLocatie.z - 0.10, "~g~E~w~ - Bezorgen")
                    if IsControlJustPressed(0, 38) then
                        if IsPedInAnyVehicle(missiePed, false) then
                            QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
                        else
                            -- Haal pakketje weg, en bereken prijs
                            TriggerServerEvent("fortis-pakketpost:server:missieBetaal")
                            -- Doe de rest
                            QBCore.Functions.TriggerCallback("fortis-pakketpost:server:requestMissieVerpaktePakketjesAantal", function(aantal)
                                if aantal > 0 then
                                    RemoveBlip(MissieBlip)
                                    TriggerEvent("fortis-pakketpost:client:nieuweMissieLocatie", 1)
                                else
                                    QBCore.Functions.Notify("Je hebt geen verpakte pakketjes meer! Ga terug naar het bedrijf, en lever je voertuig in!", "error")
                                    RemoveBlip(MissieBlip)
                                end
                            end)
                            return
                        end
                    end
                end
            end

            -- Einde
            if letsleep then
                Wait(500)
            end
        end
    end)
end)