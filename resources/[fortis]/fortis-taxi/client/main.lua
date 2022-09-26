QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local onduty = true
local isLoggedIn = false
local PlayerData = {}

local meterIsOpen = false

local meterActive = false
local currentTaxi = nil

local lastLocation = nil

local meterData = {
    fareAmount = 45,
    currentFare = 0,
    distanceTraveled = 0,
}

local dutyPlate = nil

local NpcData = {
    Active = false,
    CurrentNpc = nil,
    LastNpc = nil,
    CurrentDeliver = nil,
    LastDeliver = nil,
    Npc = nil,
    NpcBlip = nil,
    DeliveryBlip = nil,
    NpcTaken = false,
    NpcDelivered = false,
    CountDown = 5
}

function TimeoutNpc()
    Citizen.CreateThread(function()
        while NpcData.CountDown ~= 0 do
            NpcData.CountDown = NpcData.CountDown - 1
            Citizen.Wait(1000)
        end
        NpcData.CountDown = 5
    end)
end


local bezigNPC = false
RegisterNetEvent('qb-taxi:client:DoTaxiNpc')
AddEventHandler('qb-taxi:client:DoTaxiNpc', function()
    if onduty then
        if whitelistedVehicle() then
            if not bezigNPC then
                TriggerEvent("qb-taxi:client:nieuweKlant")
            else
                QBCore.Functions.Notify("Je bent al bezig met een taxi rit!", "error")
            end
        else
            QBCore.Functions.Notify("Je zit niet in een taxi voertuig!", "error")
        end
    else
        QBCore.Functions.Notify("Je bent niet indienst!", "error")
    end
end)





AddEventHandler("qb-taxi:client:nieuweKlant", function()
    bezigNPC = true
    local npcKlantPed = nil
    local geroepen = false
    local spawnedNPC = false
    local locatie = math.random(1, #Config.NPCLocations.TakeLocations)
    local locatie = Config.NPCLocations.TakeLocations[locatie]

    local klantBlipje = AddBlipForCoord(locatie.x, locatie.y, locatie.z)
    SetBlipSprite(klantBlipje, 280)
    SetBlipScale(klantBlipje, 0.9)
    SetBlipRoute(klantBlipje, true)
    SetBlipColour(locatieBlip, 2)
    SetBlipRouteColour(klantBlipje, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Taxi Klant")
    EndTextCommandSetBlipName(klantBlipje)

    QBCore.Functions.Notify("Rijd naar de locatie op je kaart!", "success")

    while true do
        Citizen.Wait(1)
        letsleep = true
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))

        if not whitelistedVehicle() then
            QBCore.Functions.Notify("Taxi missie beëindigd!", "error")
            bezigNPC = false
            geroepen = false
            RemoveBlip(klantBlipje)
            if spawnedNPC and npcKlantPed ~= nil then
                DeletePed(npcKlantPed)
            end
            return
        end

        if GetDistanceBetweenCoords(PlayerCoords, locatie.x, locatie.y, locatie.z, true) < 80 and not spawnedNPC then
            -- Spawn de NPC
            spawnedNPC = true
            local randomNPCSkin = math.random(1, #Config.NpcSkins[1])
            local hash = GetHashKey(Config.NpcSkins[1][randomNPCSkin])
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(1)
            end
            npcKlantPed = CreatePed(4, hash, locatie.x, locatie.y, locatie.z - 1.00, locatie.h, true, true)
            FreezeEntityPosition(npcKlantPed, true)
            SetEntityInvincible(npcKlantPed, true)
            SetBlockingOfNonTemporaryEvents(npcKlantPed, true)
        end

        -- Ophalen drukken
        if GetDistanceBetweenCoords(PlayerCoords, locatie.x, locatie.y, locatie.z, true) < 5 and not geroepen then
            letsleep = false
            QBCore.Functions.DrawText3D(locatie.x, locatie.y, locatie.z, "~g~[E]~w~ Roepen")
            if IsControlJustPressed(0, 38) then
                geroepen = true
                local veh = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
                local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)
                for i=maxSeats - 1, 0, -1 do
                    if IsVehicleSeatFree(veh, i) then
                        freeSeat = i
                        break
                    end
                end
                ClearPedTasksImmediately(npcKlantPed)
                SetBlockingOfNonTemporaryEvents(npcKlantPed, true)
                FreezeEntityPosition(npcKlantPed, false)
                TaskEnterVehicle(npcKlantPed, GetVehiclePedIsIn(GetPlayerPed(-1)), -1, freeSeat, 1.0, 0)
            end
        end

        if geroepen and IsPedInAnyVehicle(npcKlantPed, false) then
            RemoveBlip(klantBlipje)
            TriggerEvent("qb-taxi:client:klantAfleveren", npcKlantPed)
            return
        end

        if letsleep then
            Wait(1000)
        end
    end

end)

AddEventHandler("qb-taxi:client:klantAfleveren", function(npcKlantPed)
    local npcKlantPed = npcKlantPed

    local locatie = math.random(1, #Config.NPCLocations.DeliverLocations)
    local locatie = Config.NPCLocations.DeliverLocations[locatie]

    local bestemingBlipje = AddBlipForCoord(locatie.x, locatie.y, locatie.z)
    SetBlipSprite(bestemingBlipje, 280)
    SetBlipScale(bestemingBlipje, 0.9)
    SetBlipRoute(bestemingBlipje, true)
    SetBlipColour(bestemingBlipje, 2)
    SetBlipRouteColour(bestemingBlipje, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Klant besteming")
    EndTextCommandSetBlipName(bestemingBlipje)
    
    QBCore.Functions.Notify("Breng de klant naar de locatie op je GPS!", "success")
    while true do
        Citizen.Wait(1)
        letsleep = true
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        
        if not whitelistedVehicle() then
            QBCore.Functions.Notify("Taxi missie beëindigd!", "error")
            bezigNPC = false
            DeletePed(npcKlantPed)
            RemoveBlip(bestemingBlipje)
            return
        end

        if GetDistanceBetweenCoords(PlayerCoords, locatie.x, locatie.y, locatie.z, true) < 25 then
            letsleep = false
            DrawMarker(2, locatie.x, locatie.y, locatie.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
            if GetDistanceBetweenCoords(PlayerCoords, locatie.x, locatie.y, locatie.z, true) < 5 then
                QBCore.Functions.DrawText3D(locatie.x, locatie.y, locatie.z, "~g~[E]~w~ Afleveren")
                if IsControlJustPressed(0, 38) then
                    RemoveBlip(bestemingBlipje)
                    TaskLeaveVehicle(npcKlantPed, GetVehiclePedIsIn(npcKlantPed))
                    SetEntityAsNoLongerNeeded(npcKlantPed)
                    bezigNPC = false
                    TriggerServerEvent("qb-taxi:server:uitbetalingNPC")
                    return
                end
            end
        end

        if letsleep then
            Wait(1000)
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name == "taxi" then
        TriggerServerEvent("QBCore:ToggleDuty")
        onduty = PlayerData.job.onduty

        TaxiBlip = AddBlipForCoord(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"])

        SetBlipSprite (TaxiBlip, 198)
        SetBlipDisplay(TaxiBlip, 4)
        SetBlipScale  (TaxiBlip, 0.6)
        SetBlipAsShortRange(TaxiBlip, true)
        SetBlipColour(TaxiBlip, 5)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Taxibedrijf Downtown Cabs")
        EndTextCommandSetBlipName(TaxiBlip)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    onduty = PlayerData.job.onduty
    local PlayerData = QBCore.Functions.GetPlayerData()

    if PlayerData.job.name == ("taxi")  then
        TaxiBlip = AddBlipForCoord(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"])

        SetBlipSprite (TaxiBlip, 198)
        SetBlipDisplay(TaxiBlip, 4)
        SetBlipScale  (TaxiBlip, 0.6)
        SetBlipAsShortRange(TaxiBlip, true)
        SetBlipColour(TaxiBlip, 5)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Taxibedrijf Downtown Cabs")
        EndTextCommandSetBlipName(TaxiBlip)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    Wait(1000)
    print("Script restart gedetecteerd... data opnieuw ophalen... #kaasje")
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerData.job = PlayerData.job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        calculateFareAmount()
    end
end)

function calculateFareAmount()
    if meterIsOpen and meterActive then
        start = lastLocation
  
        if start then
            current = GetEntityCoords(GetPlayerPed(-1))
            distance = CalculateTravelDistanceBetweenPoints(start, current)
            meterData['distanceTraveled'] = distance
    
            fareAmount = (meterData['distanceTraveled'] / 400.00) * meterData['fareAmount']
    
            meterData['currentFare'] = math.ceil(fareAmount)

            SendNUIMessage({
                action = "updateMeter",
                meterData = meterData
            })
        end
    end
end

Citizen.CreateThread(function()
    while true do

        inRange = false

        if QBCore ~= nil then
            if isLoggedIn then

                if PlayerData.job.name == "taxi" and onduty then
                    local ped = GetPlayerPed(-1)
                    local pos = GetEntityCoords(ped)

                    local vehDist = GetDistanceBetweenCoords(pos, Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"])

                    if vehDist < 30 then
                        inRange = true

                        DrawMarker(2, Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)

                        if vehDist < 1.5 then
                            if whitelistedVehicle() then
                                DrawText3D(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"] + 0.3, '~g~[E]~w~ - Parkeren')
                                if IsControlJustReleased(0, Keys["E"]) then
                                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                        DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                    end
                                end
                            else
                                DrawText3D(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"] + 0.3, '~g~[E]~w~ Garage')
                                if IsControlJustReleased(0, Keys["E"]) then
                                    TaxiGarage()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(1500)
        end

        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if QBCore ~= nil and isLoggedIn then
            letsleep = true
            if PlayerData.job.name == "taxi" then
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 903.17, -172.78, 74.07, true) < 10 then
                    letsleep = false
                    DrawMarker(2, 903.17, -172.78, 74.07 + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 903.17, -172.78, 74.07, true) < 2.5 then
                        if onduty then
                            QBCore.Functions.DrawText3D(903.17, -172.78, 74.07, "~r~[E]~w~ Uitklokken")
                            if IsControlJustPressed(0, 38) then
                                onduty = not onduty
                                TriggerServerEvent("QBCore:ToggleDuty")
                            end
                        else
                            QBCore.Functions.DrawText3D(903.17, -172.78, 74.07, "~g~[E]~w~ Inklokken")
                            if IsControlJustPressed(0, 38) then
                                onduty = not onduty
                                TriggerServerEvent("QBCore:ToggleDuty")
                            end
                        end
                    end
                end
            end

            if letsleep then
                Wait(1500)
            end
        end
    end
end)

RegisterNetEvent('qb-taxi:client:toggleMeter')
AddEventHandler('qb-taxi:client:toggleMeter', function()
    local ped = GetPlayerPed(-1)
    
    if IsPedInAnyVehicle(ped, false) then
        if whitelistedVehicle() then
            if not meterIsOpen then
                SendNUIMessage({
                    action = "openMeter",
                    toggle = true,
                    meterData = Config.Meter
                })
                meterIsOpen = true
            else
                SendNUIMessage({
                    action = "openMeter",
                    toggle = false
                })
                meterIsOpen = false
            end
        else
            QBCore.Functions.Notify('Dit voertuig heeft geen taximeter!', 'error')
        end
    else
        QBCore.Functions.Notify('Je zit niet in een voertuig!', 'error')
    end
end)

RegisterNetEvent('qb-taxi:client:enableMeter')
AddEventHandler('qb-taxi:client:enableMeter', function()
    local ped = GetPlayerPed(-1)

    if meterIsOpen then
        SendNUIMessage({
            action = "toggleMeter"
        })
    else
        QBCore.Functions.Notify('De taximeter is niet actief!', 'error')
    end
end)

RegisterNUICallback('enableMeter', function(data)
    meterActive = data.enabled

    if not data.enabled then
        SendNUIMessage({
            action = "resetMeter"
        })
    end
    lastLocation = GetEntityCoords(GetPlayerPed(-1))
end)

RegisterNetEvent('qb-taxi:client:toggleMuis')
AddEventHandler('qb-taxi:client:toggleMuis', function()
    Citizen.Wait(400)
    if meterIsOpen then
        if not mouseActive then
            SetNuiFocus(true, true)
            mouseActive = true
        end
    else
        QBCore.Functions.Notify('Er zit geen taximeter in dit voertuig!', 'error')
    end
end)

RegisterNUICallback('hideMouse', function()
    SetNuiFocus(false, false)
    mouseActive = false
end)

function whitelistedVehicle()
    local ped = GetPlayerPed(-1)
    local veh = GetEntityModel(GetVehiclePedIsIn(ped))
    local retval = false

    for i = 1, #Config.AllowedVehicles, 1 do
        if veh == GetHashKey(Config.AllowedVehicles[i].model) then
            retval = true
        end
    end
    return retval
end

function TaxiGarage()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Voertuigen", "VehicleList", nil)
    Menu.addButton("Sluiten", "closeMenuFull", nil) 
end

function VehicleList()
    ped = GetPlayerPed(-1);
    MenuTitle = "Voertuigen:"
    ClearMenu()
    for k, v in pairs(Config.AllowedVehicles) do
        Menu.addButton(Config.AllowedVehicles[k].label, "TakeVehicle", k, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Terug", "TaxiGarage",nil)
end

function TakeVehicle(k)
    local coords = {x = Config.Locations["vehicle"]["x"], y = Config.Locations["vehicle"]["y"], z = Config.Locations["vehicle"]["z"]}
    QBCore.Functions.SpawnVehicle(Config.AllowedVehicles[k].model, function(veh)
        SetVehicleNumberPlateText(veh, "TAXI"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, Config.Locations["vehicle"]["h"])
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        dutyPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Citizen.CreateThread(function()
--     TaxiBlip = AddBlipForCoord(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"])

--     SetBlipSprite (TaxiBlip, 198)
--     SetBlipDisplay(TaxiBlip, 4)
--     SetBlipScale  (TaxiBlip, 0.6)
--     SetBlipAsShortRange(TaxiBlip, true)
--     SetBlipColour(TaxiBlip, 5)

--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentSubstringPlayerName("Taxibedrijf Downtown Cabs")
--     EndTextCommandSetBlipName(TaxiBlip)
-- end)