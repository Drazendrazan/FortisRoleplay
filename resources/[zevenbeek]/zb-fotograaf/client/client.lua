QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

-- Zet de blip op de kaart
Citizen.CreateThread(function ()
    local FotograafBlip = AddBlipForCoord(-1082.1395, -247.5019, 37.7633)
    SetBlipSprite(FotograafBlip, 184)
    SetBlipColour(FotograafBlip, 0)
    SetBlipScale(FotograafBlip, 0.7)
    SetBlipAsShortRange(FotograafBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Foto studio")
    EndTextCommandSetBlipName(FotograafBlip)
end)

local fotoLocaties = {
    ["locaties"] = {
        [1] = {x = -412.96, y = 1169.41, z = 325.85},
        [2] = {x = 99.24, y = 801.33, z = 211.12},
        [3] = {x = 678.77, y = 554.96, z = 129.04},
        [4] = {x = 1157.51, y = 278.48, z = 81.99},
        [5] = {x = -1153.30, y = 927.06, z = 198.38},
        [6] = {x = -1878.17, y = -1211.79, z = 13.01},
        [7] = {x = -1204.42, y = -1555.22, z = 4.37},
        [8] = {x = -705.62, y = -1324.23, z = 5.10},
        [9] = {x = -1160.21, y = -2910.20, z = 13.94},
        [10] = {x = 1211.18, y = -3033.05, z = 5.87},
        [11] = {x = 2783.68, y = -711.48, z = 4.98},
        [12] = {x = 1660.78, y = -27.76, z = 182.76},
        [13] = {x = 1366.53, y = 1147.27, z = 113.75},
        [14] = {x = 160.46, y = -990.25, z = 30.09},
        [15] = {x = 1143.15, y = -710.63, z = 56.80},
        [16] = {x = -3428.33, y = 967.82, z = 8.34},
        [17] = {x = -1694.52, y = 154.01, z = 64.28},
        [18] = {x = -245.39, y = -1874.54, z = 27.75},
        [19] = {x = -869.14, y = -848.39, z = 19.31},
        [20] = {x = 284.68, y = -1558.84, z = 29.52},
    }
}

local ophalenMogelijk = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local letsleep = true
        
        if GetDistanceBetweenCoords(pos, -1082.1395, -247.5019, 37.7633, true) < 15 then
            letsleep = false
            DrawMarker(2, -1082.1395, -247.5019, 37.7633, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
            if GetDistanceBetweenCoords(pos, -1082.1395, -247.5019, 37.7633, true) < 3 then
                QBCore.Functions.DrawText3D(-1082.1395, -247.5019, 37.7633 - 0.10, "~g~E~w~ - Camera ophalen")
                if IsControlJustPressed(0, 38) then
                    if ophalenMogelijk == false then
                        QBCore.Functions.Progressbar("verzamel", "Camera ophalen...", 3000, false, false, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "anim@heists@ornate_bank@grab_cash",
                            anim = "grab",
                            flags = 16,
                        }, {}, {}, function()
                            QBCore.Functions.Notify("Je hebt je camera opgehaald. Als je geen foto's meer wilt maken, dan kan je ze boven op de computer uploaden.", "success")
                            TriggerServerEvent("zb-fotograaf:server:addCamera")
                            TriggerEvent("zb-fotograaf:client:krijgLocaties")
                            ophalenMogelijk = true

                            ClearPedTasksImmediately(GetPlayerPed(-1))

                            ComputerBlip = AddBlipForCoord(-1055.5723, -242.8580, 44.0210)
                            SetBlipSprite(ComputerBlip, 606)
                            SetBlipColour(ComputerBlip, 0)
                            SetBlipScale(ComputerBlip, 0.5)
                            SetBlipAsShortRange(ComputerBlip, true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString("Computer")
                            EndTextCommandSetBlipName(ComputerBlip)
                        end, function()
                        end)
                    else
                        QBCore.Functions.Notify("Je hebt je camera al opgehaald. Als je geen foto's meer wilt maken, dan kan je ze boven op de computer uploaden.", "error")
                    end                        
                end
            end
        end

        if letsleep then
            Wait(1000)
        end
    end
end)






Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local pos = GetEntityCoords(GetPlayerPed(-1))

        letsleep = true

        if ophalenMogelijk == true then
            if GetDistanceBetweenCoords(pos, -1055.5723, -242.8580, 44.0210, true) < 10 then
                letsleep = false
                DrawMarker(2, -1055.5723, -242.8580, 44.0210, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                if GetDistanceBetweenCoords(pos, -1055.5723, -242.8580, 44.0210, true) < 2 then
                    QBCore.Functions.DrawText3D(-1055.5723, -242.8580, 44.0210 - 0.10, "~g~E~w~ - Upload je foto's")
                    if IsControlJustPressed(0, 38) then
                        QBCore.Functions.TriggerCallback("zb-fotograaf:server:requestCamera", function(cameraAantal)
                            if cameraAantal < 1 then
                                QBCore.Functions.Notify("Je hebt je camera niet bij je, zo kan je toch geen foto's uploaden?", "error")
                            else 
                                QBCore.Functions.TriggerCallback("zb-fotograaf:server:requestFotoAantal", function(fotoAantal)
                                    if fotoAantal >= 1 then
                                        local uploadTijd = fotoAantal * 3000
                                        QBCore.Functions.Progressbar("kaas", "Foto's aan het uploaden...", uploadTijd, false, false, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "anim@amb@warehouse@laptop@",
                                            anim = "idle_a",
                                            flags = 9,
                                        }, {}, {}, function()
                                            QBCore.Functions.TriggerCallback("zb-fotograaf:server:requestFotoAantal", function(fotoAantal)
                                                if fotoAantal < 1 then
                                                    QBCore.Functions.Notify("Je hebt je SD kaart niet meer, dat vind ik vreemd!", "error")
                                                else
                                                    ClearPedTasks(GetPlayerPed(-1))
                                                    RemoveBlip(MissieBlip)
                                                    RemoveBlip(ComputerBlip)
                                                    TriggerServerEvent("zb-fotograaf:server:removeCamera")
                                                    ophalenMogelijk = false
                                                end
                                            end)
                                        end, function()
                                        end)
                                    else
                                        QBCore.Functions.Notify("Je hebt geen SD kaart bij je!", "error")   
                                    end
                                end)
                            end 
                        end)
                    end
                end
            end
        end


        if letsleep then
            Wait(1000)
        end
    end
end)



AddEventHandler("zb-fotograaf:client:krijgLocaties", function(aantal)
    local randomLocatie = math.random(1, #fotoLocaties["locaties"])
    local missieLocatie = fotoLocaties["locaties"][randomLocatie]

    MissieBlip = AddBlipForCoord(missieLocatie.x, missieLocatie.y, missieLocatie.z)
    SetBlipColour(MissieBlip, 41)
    SetBlipRoute(MissieBlip, true)
    SetBlipRouteColour(MissieBlip, 41)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            local pos = GetEntityCoords(GetPlayerPed(-1))
            local letsleep = true

            if ophalenMogelijk == true then
                if GetDistanceBetweenCoords(pos, missieLocatie.x, missieLocatie.y, missieLocatie.z, true) < 10 then
                    letsleep = false
                    DrawMarker(2, missieLocatie.x, missieLocatie.y, missieLocatie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                    if GetDistanceBetweenCoords(pos, missieLocatie.x, missieLocatie.y, missieLocatie.z, true) < 2 then
                        QBCore.Functions.DrawText3D(missieLocatie.x, missieLocatie.y, missieLocatie.z - 0.10, "~g~E~w~ - Maak een foto")
                        if IsControlJustPressed(0, 38) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
                            else
                                QBCore.Functions.TriggerCallback("zb-fotograaf:server:requestCamera", function(cameraAantal)
                                    if cameraAantal < 1 then
                                        QBCore.Functions.Notify("Je hebt je camera niet bij je, zo kan je toch geen foto maken?", "error")
                                    else 
                                        ExecuteCommand("e camera")
                                        QBCore.Functions.Progressbar("kaas", "Foto aan het maken...", 7000, false, false, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {}, {}, {}, function()
                                            QBCore.Functions.Notify("Je hebt de foto gemaakt, ga snel naar de volgende locatie!", "success")
                                            ExecuteCommand("e c")
                                            TriggerServerEvent("zb-fotograaf:server:addFoto")
                                            RemoveBlip(MissieBlip)
                                            TriggerEvent("zb-fotograaf:client:krijgLocaties")
                                        end)
                                    end
                                end)
                                return
                            end
                        end
                    end
                end
            end
        end
    end)
end)