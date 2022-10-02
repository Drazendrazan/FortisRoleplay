QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end) 

local RainbowNeon = false
LastEngineMultiplier = 1.0

function setVehData(veh,data)
    local ban = false
    local multp = 1.1
    local gearp = 1.01
    local dTrain = 0.0
    local speed = data.acceleration
    local boost = data.boost
    local gears = data.gearchange
    if tonumber(boost) > 5 then
        ban = true
    elseif tonumber(speed) > 5 then
        ban = true
    elseif tonumber(gears) > 5 then
        ban = true
    end
    if tonumber(data.drivetrain) == 2 then dTrain = 0.5 elseif tonumber(data.drivetrain) == 3 then dTrain = 1.0 end
    if not DoesEntityExist(veh) or not data then return nil end
    if ban then
        TriggerServerEvent("zb-tunerchip:server:foei")
    else
        local fInitialDriveForcestandard = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
        local fDriveInertiastandard = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveInertia')
        local fDriveBiasFrontstandard = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveBiasFront')
        local fBrakeBiasFrontstandard = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeBiasFront')
        local topspeed = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel')
        SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", fInitialDriveForcestandard * multp)
        SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", fDriveInertiastandard * multp)
        -- print(topspeed * gearp)
        -- SetVehicleEnginePowerMultiplier(veh, topspeed * gearp)
        -- LastEngineMultiplier = data.gearchange * gearp 
        -- SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront", fDriveBiasFrontstandard * 1.0)
        -- SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", data.breaking * multp) 
    end
end
 
function resetVeh(veh)
    local fInitialDriveForcestandard = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
    local fDriveInertiastandard = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveInertia')
    local fDriveBiasFrontstandard = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fDriveBiasFront')
    local fBrakeBiasFrontstandard = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fBrakeBiasFront')
    Citizen.Wait(200)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", fInitialDriveForcestandard)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", fDriveInertiastandard)
    ModifyVehicleTopSpeed(veh, 1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront", fDriveBiasFrontstandard)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", fBrakeBiasFrontstandard)
end

RegisterNUICallback('save', function(data)
    QBCore.Functions.TriggerCallback('zb-tunerchip:server:HasChip', function(HasChip)
        if HasChip then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsUsing(ped)
            setVehData(veh, data)
            QBCore.Functions.Notify('TunerChip v1.05: voertuig getuned!', 'success')

            TriggerServerEvent('zb-tunerchip:server:TuneStatus', GetVehicleNumberPlateText(veh), true)
        end
    end)
end) 

RegisterNetEvent('zb-tunerchip:client:TuneStatus')
AddEventHandler('zb-tunerchip:client:TuneStatus', function()
    local ped = PlayerPedId()
    local closestVehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)
    local plate = QBCore.Functions.GetPlate(closestVehicle)
    local vehModel = GetEntityModel(closestVehicle)
    if vehModel ~= 0 then
        QBCore.Functions.TriggerCallback('zb-tunerchip:server:GetStatus', function(status)
            if status then
                QBCore.Functions.Notify('Dit voertuig is getuned!', 'success')
            else
                QBCore.Functions.Notify('Dit voertuig is niet getuned!', 'error')
            end
        end, plate)
    else
        QBCore.Functions.Notify('Geen voertuig in  de buurt!', 'error')
    end
end)

RegisterNUICallback('checkItem', function(data, cb)
    local retval = false
    local item = "tunerlaptop"
    QBCore.Functions.TriggerCallback("zb-tunerchip:server:HasChip", function(result)
        if result then
            retval = true 
        end
        cb(retval)
    end, item)
end)

RegisterNUICallback('reset', function(data)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsUsing(ped)
    resetVeh(veh)
    QBCore.Functions.Notify('TunerChip v1.05: Voertuig is gereset!', 'error')
end)

RegisterNetEvent('zb-tunerchip:client:openChip')
AddEventHandler('zb-tunerchip:client:openChip', function()
    local ped = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle(ped)

    if inVehicle then
        QBCore.Functions.Progressbar("connect_laptop", "Tunerchip aan het aansluiten!", 2000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            openTunerLaptop(true)
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            QBCore.Functions.Notify("Geannuleerd", "error")
        end)
    else
        QBCore.Functions.Notify("Je zit niet in een voertuig!", "error")
    end
end)

RegisterNUICallback('exit', function()
    openTunerLaptop(false)
    SetNuiFocus(false, false)
end)

local LastRainbowNeonColor = 0

local RainbowNeonColors = {
    [1] = {
        r = 255,
        g = 0,
        b = 0
    },
    [2] = {
        r = 255,
        g = 165,
        b = 0
    },
    [3] = {
        r = 255,
        g = 255,
        b = 0
    },
    [4] = {
        r = 0,
        g = 0,
        b = 255
    },
    [5] = {
        r = 75,
        g = 0,
        b = 130
    },
    [6] = {
        r = 238,
        g = 130,
        b = 238
    },
}

RegisterNUICallback('saveNeon', function(data)
    QBCore.Functions.TriggerCallback('zb-tunerchip:server:HasChip', function(HasChip)
        if HasChip then
            if not data.rainbowEnabled then
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)

                if tonumber(data.neonEnabled) == 1 then
                    SetVehicleNeonLightEnabled(veh, 0, true)
                    SetVehicleNeonLightEnabled(veh, 1, true)
                    SetVehicleNeonLightEnabled(veh, 2, true)
                    SetVehicleNeonLightEnabled(veh, 3, true)
                    if tonumber(data.r) ~= nil and tonumber(data.g) ~= nil and tonumber(data.b) ~= nil then
                        SetVehicleNeonLightsColour(veh, tonumber(data.r), tonumber(data.g), tonumber(data.b))
                    else
                        SetVehicleNeonLightsColour(veh, 255, 255, 255)
                    end
                    RainbowNeon = false
                else
                    SetVehicleNeonLightEnabled(veh, 0, false)
                    SetVehicleNeonLightEnabled(veh, 1, false)
                    SetVehicleNeonLightEnabled(veh, 2, false)
                    SetVehicleNeonLightEnabled(veh, 3, false)
                    RainbowNeon = false
                end
            else
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)

                if tonumber(data.neonEnabled) == 1 then
                    if not RainbowNeon then
                        RainbowNeon = true
                        SetVehicleNeonLightEnabled(veh, 0, true)
                        SetVehicleNeonLightEnabled(veh, 1, true)
                        SetVehicleNeonLightEnabled(veh, 2, true)
                        SetVehicleNeonLightEnabled(veh, 3, true)
                        Citizen.CreateThread(function()
                            while true do
                                if RainbowNeon then
                                    if (LastRainbowNeonColor + 1) ~= 7 then
                                        LastRainbowNeonColor = LastRainbowNeonColor + 1
                                        SetVehicleNeonLightsColour(veh, RainbowNeonColors[LastRainbowNeonColor].r, RainbowNeonColors[LastRainbowNeonColor].g, RainbowNeonColors[LastRainbowNeonColor].b)
                                    else
                                        LastRainbowNeonColor = 1
                                        SetVehicleNeonLightsColour(veh, RainbowNeonColors[LastRainbowNeonColor].r, RainbowNeonColors[LastRainbowNeonColor].g, RainbowNeonColors[LastRainbowNeonColor].b)
                                    end
                                else
                                    break
                                end

                                Citizen.Wait(350)
                            end
                        end)
                    end
                else
                    RainbowNeon = false
                    SetVehicleNeonLightEnabled(veh, 0, false)
                    SetVehicleNeonLightEnabled(veh, 1, false)
                    SetVehicleNeonLightEnabled(veh, 2, false)
                    SetVehicleNeonLightEnabled(veh, 3, false)
                end
            end
        end
    end)
end)

local RainbowHeadlight = false
local RainbowHeadlightValue = 0

RegisterNUICallback('saveHeadlights', function(data)
    QBCore.Functions.TriggerCallback('zb-tunerchip:server:HasChip', function(HasChip)
        if HasChip then
            if data.rainbowEnabled then
                RainbowHeadlight = true
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)
                local value = tonumber(data.value)

                Citizen.CreateThread(function()
                    while true do
                        if RainbowHeadlight then
                            if (RainbowHeadlightValue + 1) ~= 12 then
                                RainbowHeadlightValue = RainbowHeadlightValue + 1
                                ToggleVehicleMod(veh, 22, true)
                                SetVehicleHeadlightsColour(veh, RainbowHeadlightValue)
                            else
                                RainbowHeadlightValue = 1
                                ToggleVehicleMod(veh, 22, true)
                                SetVehicleHeadlightsColour(veh, RainbowHeadlightValue)
                            end
                        else
                            break
                        end
                        Citizen.Wait(300)
                    end
                end)
                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, value)
            else
                RainbowHeadlight = false
                local ped = PlayerPedId()
                local veh = GetVehiclePedIsIn(ped)
                local value = tonumber(data.value)

                ToggleVehicleMod(veh, 22, true)
                SetVehicleHeadlightsColour(veh, value)
            end
        end
    end)
end)

function openTunerLaptop(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool
    })
end