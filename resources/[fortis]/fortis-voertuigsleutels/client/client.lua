QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

local laatsteVoertuig = nil
local heeftSleutel = false
local IsHotwiring = false
local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0
local AlertSend = false
local engineUit = false
-- Check of persoon op L drukt

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        -- Check of de persoon op L drukt
        if IsControlJustPressed(1, 182) then
            local pedPos = GetEntityCoords(GetPlayerPed(-1))
            local voertuig = QBCore.Functions.GetClosestVehicle()
            local voertuigPos = GetEntityCoords(voertuig)

            if GetDistanceBetweenCoords(pedPos, voertuigPos) < 4 then
                local kenteken = GetVehicleNumberPlateText(voertuig)
                QBCore.Functions.TriggerCallback("fortis-voertuigsleutels:server:checkOwner", function(callback)
                    if callback then
                        local slotStatus = GetVehicleDoorLockStatus(voertuig)
                        loadAnimDict("anim@mp_player_intmenu@key_fob@")
                        TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
                        if slotStatus == 2 then -- Opslot
                            SetVehicleDoorsLocked(voertuig, 1)
                            QBCore.Functions.Notify("Je hebt het voertuig van het slot gehaald", "success")
                            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3)
                        else
                            SetVehicleDoorsLocked(voertuig, 2)
                            QBCore.Functions.Notify("Je hebt het voertuig op slot gedaan", "error")
                            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                            SetVehicleDoorsShut(voertuig, false)
                        end
                        Citizen.Wait(750)
                        ClearPedTasks(GetPlayerPed(-1))
                    else
                        QBCore.Functions.Notify("Je hebt de sleutel niet!", "error")
                    end
                end, kenteken)
            end
        end

        -- Check of persoon in een voertuig zit/stapt
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), true), -1) == GetPlayerPed(-1) then
            local kenteken = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
            if laatsteVoertuig ~= GetVehiclePedIsIn(GetPlayerPed(-1), false) then
                QBCore.Functions.TriggerCallback("fortis-voertuigsleutels:server:checkOwner", function(callback)
                    if callback then
                        heeftSleutel = true
                        SetVehicleEngineOn(veh, true, false, true)
                    else
                        heeftSleutel = false
                        SetVehicleEngineOn(veh, false, false, true)
                    end
                    laatsteVoertuig = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                end, kenteken)
            end
        else
            if SucceededAttempts ~= 0 then
                SucceededAttempts = 0
            end
            if NeededAttempts ~= 0 then
                NeededAttempts = 0
            end
            if FailedAttemps ~= 0 then
                FailedAttemps = 0
            end  
        end

        if not heeftSleutel and IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) and QBCore ~= nil and not IsHotwiring then
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetVehicleEngineOn(veh, false, false, true)
        elseif IsHotwiring then
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetVehicleEngineOn(veh, false, false, true)
        end

    end
end)

RegisterNetEvent("vehiclekeys:client:SetOwner")
AddEventHandler("vehiclekeys:client:SetOwner", function(kenteken)
    local kenteken = kenteken
    if kenteken == nil then
        kenteken = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
    end

    TriggerServerEvent("fortis-voertuigsleutels:server:setVoertuigOwner", kenteken)
end)

RegisterNetEvent("fortis-voertuigsleutels:server:maakSleutelMogelijk")
AddEventHandler("fortis-voertuigsleutels:server:maakSleutelMogelijk", function()
    laatsteVoertuig = nil
end)

RegisterNetEvent('fortis-voertuigsleutels:client:geefSleutels')
AddEventHandler('fortis-voertuigsleutels:client:geefSleutels', function(target)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        local kenteken = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
        TriggerServerEvent('fortis-voertuigsleutels:server:geefSleutels', kenteken, target)
    else
        QBCore.Functions.Notify("Je moet in het voertuig zitten om de sleutel te geven!", "error")
    end
end)

-- Admin

RegisterNetEvent("fortis-voertuigsleutels:client:adminSleutel")
AddEventHandler("fortis-voertuigsleutels:client:adminSleutel", function()
    local pedPos = GetEntityCoords(GetPlayerPed(-1))
    local voertuig = QBCore.Functions.GetClosestVehicle()
    local voertuigPos = GetEntityCoords(voertuig)

    if GetDistanceBetweenCoords(pedPos, voertuigPos) < 4 then
        local kenteken = GetVehicleNumberPlateText(voertuig)
        TriggerEvent("vehiclekeys:client:SetOwner", kenteken)
        QBCore.Functions.Notify("Je hebt nu de sleutels van "..kenteken)
    end
end)

RegisterNetEvent("fortis-voertuigsleutels:client:startStopMotor")
AddEventHandler("fortis-voertuigsleutels:client:startStopMotor", function()
    local ped = GetPlayerPed(-1)
    local voertuig = GetVehiclePedIsIn(ped)
    local kenteken = GetVehicleNumberPlateText(voertuig)
    local class = GetVehicleClass(voertuig)

    QBCore.Functions.TriggerCallback("fortis-voertuigsleutels:server:checkOwner", function(callback)
        if callback then
            if class ~= 16 then
                if tonumber(IsVehicleEngineOn(voertuig)) == 1 then
                    engineUit = true
                else
                    engineUit = false
                end
            else
                QBCore.Functions.Notify("Dit kan niet in een vliegtuig!", "error")
            end
        else
            QBCore.Functions.Notify("Je hebt de sleutels niet!", "error")
        end
    end, kenteken)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if engineUit then
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local voertuig = GetVehiclePedIsIn(GetPlayerPed(-1))
                SetVehicleEngineOn(voertuig, false, false, false)
            else
                engineUit = false
            end
        end
    end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

-- Lockpick

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(isAdvanced)
    if (IsPedInAnyVehicle(GetPlayerPed(-1))) then
        if not heeftSleutel then
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                LockpickIgnition(isAdvanced)
            end
        end 
    end
end)

function LockpickIgnition(isAdvanced)
    local Skillbar = exports['fortis-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(2, 4)
    end
    if not heeftSleutel then
        Citizen.Wait(500)
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        if vehicle ~= nil and vehicle ~= 0 then
            if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
                IsHotwiring = true
                SucceededAttempts = 0
                PoliceCall()

                if isAdvanced then
                    local maxwidth = 10
                    local maxduration = 1750
                    if FailedAttemps == 1 then
                        maxwidth = 10
                        maxduration = 1500
                    elseif FailedAttemps == 2 then
                        maxwidth = 9
                        maxduration = 1250
                    elseif FailedAttemps >= 3 then
                        maxwidth = 8
                        maxduration = 1000
                    end
                    widthAmount = math.random(5, maxwidth)
                    durationAmount = math.random(500, maxduration)
                else        
                    local maxwidth = 10
                    local maxduration = 1500
                    if FailedAttemps == 1 then
                        maxwidth = 9
                        maxduration = 1250
                    elseif FailedAttemps == 2 then
                        maxwidth = 8
                        maxduration = 1000
                    elseif FailedAttemps >= 3 then
                        maxwidth = 7
                        maxduration = 800
                    end
                    widthAmount = math.random(5, maxwidth)
                    durationAmount = math.random(500, maxduration)
                end

                local dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
                local anim = "machinic_loop_mechandplayer"

                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    RequestAnimDict(dict)
                    Citizen.Wait(100)
                end

                Skillbar.Start({
                    duration = math.random(5000, 10000),
                    pos = math.random(10, 30),
                    width = math.random(10, 20),
                }, function()
                    if IsHotwiring then
                        if SucceededAttempts + 1 >= NeededAttempts then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                                QBCore.Functions.Notify("Succesvol open gebroken!")
                                heeftSleutel = true
                                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                                IsHotwiring = false
                                FailedAttemps = 0 
                                SucceededAttempts = 0
                                NeededAttempts = 0
                                TriggerServerEvent('qb-hud:Server:GainStress', math.random(2, 4))
                            else
                                StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                                QBCore.Functions.Notify("Je zit niet meer in het voertuig.", "error")
                                IsHotwiring = false
                                FailedAttemps = 0 
                                SucceededAttempts = 0
                                NeededAttempts = 0
                                TriggerServerEvent('qb-hud:Server:GainStress', math.random(2, 4))
                            end
                        else
                            if vehicle ~= nil and vehicle ~= 0 then
                                TaskPlayAnim(GetPlayerPed(-1), dict, anim, 8.0, 8.0, -1, 16, -1, false, false, false)
                                if isAdvanced then
                                    local maxwidth = 10
                                    local maxduration = 1750
                                    if FailedAttemps == 1 then
                                        maxwidth = 10
                                        maxduration = 1500
                                    elseif FailedAttemps == 2 then
                                        maxwidth = 9
                                        maxduration = 1250
                                    elseif FailedAttemps >= 3 then
                                        maxwidth = 8
                                        maxduration = 1000
                                    end
                                    widthAmount = math.random(5, maxwidth)
                                    durationAmount = math.random(400, maxduration)
                                else        
                                    local maxwidth = 10
                                    local maxduration = 1300
                                    if FailedAttemps == 1 then
                                        maxwidth = 9
                                        maxduration = 1150
                                    elseif FailedAttemps == 2 then
                                        maxwidth = 8
                                        maxduration = 900
                                    elseif FailedAttemps >= 3 then
                                        maxwidth = 7
                                        maxduration = 750
                                    end
                                    widthAmount = math.random(5, maxwidth)
                                    durationAmount = math.random(300, maxduration)
                                end

                                SucceededAttempts = SucceededAttempts + 1
                                Skillbar.Repeat({
                                    duration = durationAmount,
                                    pos = math.random(10, 50),
                                    width = widthAmount,
                                })
                            else
                                ClearPedTasksImmediately(GetPlayerPed(-1))
                                heeftSleutel = false
                                SetVehicleEngineOn(vehicle, false, false, true)
                                QBCore.Functions.Notify("Je moet in het voertuig zitten!", "error")
                                IsHotwiring = false
                                FailedAttemps = FailedAttemps + 1
                                local c = math.random(2)
                                local o = math.random(2)
                                if c == o then
                                    TriggerServerEvent('qb-hud:Server:GainStress', math.random(1, 4))
                                end
                            end
                        end
                    end
                end, function()
                    if IsHotwiring then
                        StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                        heeftSleutel = false
                        SetVehicleEngineOn(vehicle, false, false, true)
                        QBCore.Functions.Notify("Het slot was te sterk!", "error")
                        IsHotwiring = false
                        FailedAttemps = FailedAttemps + 1
                        local c = math.random(2)
                        local o = math.random(2)
                        if c == o then
                            TriggerServerEvent('qb-hud:Server:GainStress', math.random(1, 4))
                        end
                    end
                end)
            end
        end
    end
end

function PoliceCall()
    if not AlertSend then
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local chance = 20
        if GetClockHours() >= 1 and GetClockHours() <= 6 then
            chance = 10
        end
        if math.random(1, 100) <= chance then
            local msg = ""
            local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
            local streetLabel = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            if street2 ~= nil and street2 ~= "" then 
                streetLabel = streetLabel .. " " .. street2
            end
            local alertTitle = ""
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                local modelName = GetEntityModel(vehicle)
                if QBCore.Shared.VehicleModels[modelName] ~= nil then
                    Name = QBCore.Shared.Vehicles[QBCore.Shared.VehicleModels[modelName]["model"]]["brand"] .. ' ' .. QBCore.Shared.Vehicles[QBCore.Shared.VehicleModels[modelName]["model"]]["name"]
                else
                    Name = "Unknown"
                end
                local modelPlate = GetVehicleNumberPlateText(vehicle)
                local msg = "Poging voertuigdiefstal ter " ..streetLabel.. ". Voertuig: " .. Name .. ", Kentekenplaat: " .. modelPlate
                local alertTitle = "Poging voertuigdiefstal"
                TriggerServerEvent("police:server:VehicleCall", pos, msg, alertTitle, streetLabel, modelPlate, Name)
            else
                local vehicle = QBCore.Functions.GetClosestVehicle()
                local modelName = GetEntityModel(vehicle)
                local modelPlate = GetVehicleNumberPlateText(vehicle)
                if QBCore.Shared.VehicleModels[modelName] ~= nil then
                    Name = QBCore.Shared.Vehicles[QBCore.Shared.VehicleModels[modelName]["model"]]["brand"] .. ' ' .. QBCore.Shared.Vehicles[QBCore.Shared.VehicleModels[modelName]["model"]]["name"]
                else
                    Name = "Unknown"
                end
                local msg = "Poging voertuigdiefstal ter " ..streetLabel.. ". Voertuig: " .. Name .. ", Kentekenplaat: " .. modelPlate
                local alertTitle = "Poging voertuigdiefstal"
                TriggerServerEvent("police:server:VehicleCall", pos, msg, alertTitle, streetLabel, modelPlate, Name)
            end
        end
        AlertSend = true
        SetTimeout(2 * (60 * 1000), function()
            AlertSend = false
        end)
    end
end