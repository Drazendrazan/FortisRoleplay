QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
end)


local Garages = {
    ["locaties"] = {
        [1] = {x = -322.33, y = -96.26, z = 38.01, h = 160.17},
        [2] = {x = 732.61,      y = -1076.9,    z = 21.17, h = 179.26},
        [3] = {x = -1164.77,    y = -2019.81,   z = 12.18, h = 313.37},
        [4] = {x = 1176.51,     y = 2636.16,    z = 36.75, h = 359.48},
        [5] = {x = 106.57,      y = 6628.33,    z = 30.79, h = 223.73},
        [6] = {x = -226.82,     y = -1329.78,   z = 29.89, h = 269.45},
        [7] = {x = 934.5,       y = -981.37,    z = 38.47, h = 271.42},
        [8] = {x = 1199.39,     y = -3193.06,   z = -9.16, h = 183.07},
        [9] = {x = -33.69,      y = -1070.11,   z = 27.40, h = 338.46}
    },
    ["driftBanden"] = {
        [1] = {x = 1176.42, y = -3242.56, z = -9.93, h = 23.08}, -- banden plek voor auto
        [2] = {x = 1178.12, y = -3246.73, z = -9.27, h = 23.08}, -- pedspawn
    },
}

local npcSpawn = true
local npcSpawnDrift = true
local letsleep = true
local inbanden = false

-- NPC Spawn
Citizen.CreateThread(function()
    local CarmeetBlip = AddBlipForCoord(1182.19, -3293.85, 4.88)
    SetBlipSprite(CarmeetBlip, 380)
    SetBlipColour(CarmeetBlip, 11)
    SetBlipScale(CarmeetBlip, 0.7)
    SetBlipAsShortRange(CarmeetBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Carmeet Garage")
    EndTextCommandSetBlipName(CarmeetBlip)
    while true do
        Citizen.Wait(1)
        if npcSpawn then
            Citizen.Wait(500)
            local hash = GetHashKey('a_m_y_salton_01')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            for k, locatie in pairs(Garages["locaties"]) do
                npcSpawnPed = CreatePed(4, hash, locatie.x, locatie.y, locatie.z, locatie.h, false, true)

                FreezeEntityPosition(npcSpawnPed, true)    
                SetEntityInvincible(npcSpawnPed, true)
                SetBlockingOfNonTemporaryEvents(npcSpawnPed, true) 

                loadAnimDict("anim@heists@humane_labs@finale@strip_club")
                TaskPlayAnim(npcSpawnPed, "anim@heists@humane_labs@finale@strip_club", "ped_b_celebrate_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
            npcSpawn = false
        end
        if npcSpawnDrift then
            Citizen.Wait(500)
            local hash = GetHashKey('a_m_y_salton_01')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            npcSpawnPedDrift = CreatePed(4, hash, Garages["driftBanden"][2].x,  Garages["driftBanden"][2].y,  Garages["driftBanden"][2].z - 1,  Garages["driftBanden"][2].h, false, true)

            FreezeEntityPosition(npcSpawnPedDrift, true)    
            SetEntityInvincible(npcSpawnPedDrift, true)
            SetBlockingOfNonTemporaryEvents(npcSpawnPedDrift, true) 

            -- loadAnimDict("anim@heists@humane_labs@finale@strip_club")
            -- TaskPlayAnim(npcSpawnPedDrift, "anim@heists@humane_labs@finale@strip_club", "ped_b_celebrate_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
            npcSpawnDrift = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local vehicle = GetVehiclePedIsIn(ped)
        letsleep = true

        for k, locatie in pairs(Garages["locaties"]) do
            if GetDistanceBetweenCoords(pos, locatie.x, locatie.y, locatie.z, true) < 10 and IsPedInAnyVehicle(ped) then
                letsleep = false
                DrawMarker(25, locatie.x, locatie.y, locatie.z + 0.05, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 28, 202, 155, 100, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(pos, locatie.x, locatie.y, locatie.z, true) < 4 then
                    QBCore.Functions.DrawText3D(locatie.x, locatie.y, locatie.z + 1.0, "~g~E~w~ - Repareer voertuig [€325]")
                    if IsControlJustPressed(0, 38) then
                        QBCore.Functions.TriggerCallback("repaira:server:AnwbAantal", function(aantalAnwb)
                            if aantalAnwb < 2 then
                                QBCore.Functions.TriggerCallback("repaira:server:RepareerAuto", function(resultaat)
                                    if resultaat then
                                        QBCore.Functions.Progressbar("repareren", "Repareren..", math.random(20000, 30000), false, false, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {}, {}, {}, function()
                                            local tmp_benzine = exports["LegacyFuel"]:GetFuel(vehicle, false)

                                            QBCore.Functions.Notify("Je hebt je voertuig gerepareerd voor €325!")
                                            SetVehicleDirtLevel(vehicle)
                                            SetVehicleUndriveable(vehicle, false)
                                            WashDecalsFromVehicle(vehicle, 1.0)
                                            SetVehicleFixed(vehicle)
                                            healthBodyLast=1000.0
                                            healthEngineLast=1000.0
                                            healthPetrolTankLast=1000.0
                                            SetVehicleEngineOn(vehicle, true, false)
                                            exports["LegacyFuel"]:SetFuel(vehicle, tmp_benzine)
                                            return
                                        end)
                                    end
                                end)
                            else
                                QBCore.Functions.Notify("Er is genoeg ANWB in dienst, bel de ANWB!", "error")
                            end
                        end)
                    end
                end
            end
        end

        if letsleep then
            Citizen.Wait(1000)
        end
    end
end)

-- drift torrie
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local positie = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(positie, Garages["driftBanden"][1].x, Garages["driftBanden"][1].y, Garages["driftBanden"][1].z) <10 then
            letsleep = false
            if not inbanden then
                if GetDistanceBetweenCoords(positie, Garages["driftBanden"][1].x, Garages["driftBanden"][1].y, Garages["driftBanden"][1].z) <5 then
                    DrawMarker(2, Garages["driftBanden"][1].x, Garages["driftBanden"][1].y, Garages["driftBanden"][1].z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.4, 0.4, 28, 202, 155, 155)
                    if GetDistanceBetweenCoords(positie, Garages["driftBanden"][1].x, Garages["driftBanden"][1].y, Garages["driftBanden"][1].z) <1.5 then
                        QBCore.Functions.DrawText3D(Garages["driftBanden"][1].x, Garages["driftBanden"][1].y, Garages["driftBanden"][1].z + 0.7, "~g~E~w~ - Drift banden monteren/verwijderen [€2000]")
                        if IsControlJustPressed(0, 38) then
                            if IsPedInAnyVehicle(PlayerPedId()) then
                                local voertuig = GetVehiclePedIsIn(PlayerPedId())
                                local class = GetVehicleClass(voertuig)
                                local plate = GetVehicleNumberPlateText(voertuig)
                                voertuigLocatie = GetEntityCoords(voertuig) 
                                freeze = false
                                if class ~= 18 and class ~= 8 and class ~= 13 then
                                    QBCore.Functions.TriggerCallback('zb-smallresources:server:checkAuto', function(resultaat)
                                        local resultaat2 = resultaat[1].drifttires
                                        if resultaat2 == 1 then
                                            SetEntityCoords(voertuig, Garages["driftBanden"][1].x, Garages["driftBanden"][1].y, Garages["driftBanden"][1].z)
                                            SetEntityHeading(voertuig, Garages["driftBanden"][1].h)
                                            FreezeEntityPosition(voertuig, true)
                                            freeze = true
                                            bandlr = GetEntityBoneIndexByName(voertuig, "wheel_lr")
                                            bandlf = GetEntityBoneIndexByName(voertuig, "wheel_lf")
                                            bandrf = GetEntityBoneIndexByName(voertuig, "wheel_rf")
                                            bandrr = GetEntityBoneIndexByName(voertuig, "wheel_rr")
                                            bandCoordslr =  GetWorldPositionOfEntityBone(voertuig, bandlr)
                                            bandCoordslf =  GetWorldPositionOfEntityBone(voertuig, bandlr)
                                            bandCoordsrf =  GetWorldPositionOfEntityBone(voertuig, bandrf)
                                            bandCoordsrr =  GetWorldPositionOfEntityBone(voertuig, bandrr)
                                            tekst = "Banden aan het verwijderen..."
                                            QBCore.Functions.Progressbar("repareren", ""..tekst.."", 20000, false, false, {
                                                disableMovement = true,
                                                disableCarMovement = true,
                                                disableMouse = false,
                                                disableCombat = true,
                                            }, {}, {}, {}, function()
                                                QBCore.Functions.Notify("De banden zijn verwijderd!")
                                                Citizen.InvokeNative(0x5AC79C98C5C17F05, voertuig, false)
                                                drift = 0
                                                TriggerServerEvent("zb-smallresources:server:slaAutoOp", voertuig, plate, drift)
                                                TriggerServerEvent("zb-smallresources:server:betaalAuto")
                                                FreezeEntityPosition(voertuig, false)
                                                inbanden = false
                                                letsleep = true
                                                return
                                            end)                                       
                                        else
                                            SetEntityCoords(voertuig, Garages["driftBanden"][1].x, Garages["driftBanden"][1].y, Garages["driftBanden"][1].z)
                                            SetEntityHeading(voertuig, Garages["driftBanden"][1].h)
                                            FreezeEntityPosition(voertuig, true)
                                            freeze = true
                                            bandlr = GetEntityBoneIndexByName(voertuig, "wheel_lr")
                                            bandlf = GetEntityBoneIndexByName(voertuig, "wheel_lf")
                                            bandrf = GetEntityBoneIndexByName(voertuig, "wheel_rf")
                                            bandrr = GetEntityBoneIndexByName(voertuig, "wheel_rr")
                                            bandCoordslr =  GetWorldPositionOfEntityBone(voertuig, bandlr)
                                            bandCoordslf =  GetWorldPositionOfEntityBone(voertuig, bandlf)
                                            bandCoordsrf =  GetWorldPositionOfEntityBone(voertuig, bandrf)
                                            bandCoordsrr =  GetWorldPositionOfEntityBone(voertuig, bandrr)
                                            tekst = "Banden aan het monteren..."
                                            QBCore.Functions.Progressbar("repareren", ""..tekst.."", 20000, false, false, {
                                                disableMovement = true,
                                                disableCarMovement = true,
                                                disableMouse = false,
                                                disableCombat = true,
                                            }, {}, {}, {}, function()
                                                QBCore.Functions.Notify("De banden zijn gemonteerd!")
                                                Citizen.InvokeNative(0x5AC79C98C5C17F05, voertuig, true)
                                                drift = 1
                                                TriggerServerEvent("zb-smallresources:server:slaAutoOp", voertuig, plate, drift)
                                                TriggerServerEvent("zb-smallresources:server:betaalAuto")
                                                FreezeEntityPosition(voertuig, false)
                                                inbanden = false
                                                letsleep = true
                                                return                                                                
                                            end)
                                        end
                                    end, voertuig, plate)
                                else
                                    QBCore.Functions.Notify("Onder dit voertuig ga ik geen driftbanden zetten!", "error")
                                end
                                
                            else
                                QBCore.Functions.Notify("Je zit niet in een voertuig!", "error")
                            end
                        end
                    end
                end
            end
        end
        if freeze then
            lopend()
            Citizen.Wait(100)
            freeze = false
        end
        if letsleep then
            Citizen.Wait(1000)
        end
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end 

function lopend()
    FreezeEntityPosition(npcSpawnPedDrift, false)
    TaskGoStraightToCoord(npcSpawnPedDrift, 1174.75, -3245.98, -9.27, 1, 1, 0, 1)
    Citizen.Wait(2000)
    TaskGoStraightToCoord(npcSpawnPedDrift, bandCoordslr.x, bandCoordslr.y,bandCoordslr.z, 1, 1, 295.00, 1)
    Citizen.Wait(2000)
    loadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
    TaskPlayAnim(npcSpawnPedDrift, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(2500)
    StopAnimTask(npcSpawnPedDrift, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
    TaskGoStraightToCoord(npcSpawnPedDrift, bandCoordslf.x, bandCoordslf.y,bandCoordslf.z, 1, 1, 295.00, 1)
    Citizen.Wait(2000)
    TaskPlayAnim(npcSpawnPedDrift, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(2500)
    StopAnimTask(npcSpawnPedDrift, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
    TaskGoStraightToCoord(npcSpawnPedDrift, voertuigLocatie.x, voertuigLocatie.y + 3, voertuigLocatie.z, 1, 1, 0, 1)
    Citizen.Wait(2500)
    TaskGoStraightToCoord(npcSpawnPedDrift, bandCoordsrf.x, bandCoordsrf.y,bandCoordsrf.z, 1, 1, 121.41, 1)
    Citizen.Wait(2000)
    TaskPlayAnim(npcSpawnPedDrift, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(2500)
    StopAnimTask(npcSpawnPedDrift, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
    TaskGoStraightToCoord(npcSpawnPedDrift, bandCoordsrr.x, bandCoordsrr.y,bandCoordsrr.z, 1, 1, 121.41, 1)
    Citizen.Wait(2000)
    TaskPlayAnim(npcSpawnPedDrift, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(2500)
    StopAnimTask(npcSpawnPedDrift, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
    TaskGoStraightToCoord(npcSpawnPedDrift, Garages["driftBanden"][2].x,  Garages["driftBanden"][2].y,  Garages["driftBanden"][2].z, 1, 1, 23.08, 1)
    Citizen.Wait(1000)
    SetEntityHeading(npcSpawnPedDrift, 23.08)
    FreezeEntityPosition(npcSpawnPedDrift, true)
end