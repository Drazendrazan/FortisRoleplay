QBCore = nil

local cam = nil
local Drone = nil
local flydrone = false
local picking = false
local soundon = false
local Sound = nil
local show_information = false

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

-- Citizen.CreateThread(function()
--     local blip = AddBlipForCoord(-659.83, -937.61, 21.83)
-- 	SetBlipSprite(blip, 589)
-- 	SetBlipScale(blip, 0.8)
-- 	SetBlipColour(blip, 0)
-- 	SetBlipAsShortRange(blip, true)
-- 	BeginTextCommandSetBlipName("STRING")
-- 	AddTextComponentString("Drone shop")
-- 	EndTextCommandSetBlipName(blip)
-- end)

Citizen.CreateThread(function()
    if Config.Droneshops['enabled'] then
        SpawnDrones()
        while true do
            Wait(0)
            local pos = GetEntityCoords(PlayerPedId())
            local letSleep = true
            for k,v in pairs(Config.Droneshops['Shops']) do
                local dist = GetDistanceBetweenCoords(pos, v['coords']['x'], v['coords']['y'], v['coords']['z'], true)
                if dist < 25 then
                    letSleep = false
                    if dist < 5 then
                        DrawMarker(2, v['coords']['x'], v['coords']['y'], v['coords']['z'] + 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.15, 0.15, 0.15, 120, 10, 20, 155, false, false, false, 1, false, false, false)
                        if dist < 2 and not show_information then
                            DrawText3D(v['coords']['x'], v['coords']['y'], v['coords']['z'] - 0.15, Config.Droneshops['text'])
                            DrawText3D(v['coords']['x'], v['coords']['y'], v['coords']['z'] - 0.30, Config.Droneshops['text_information'])
                            DrawText3D(v['coords']['x'], v['coords']['y'], v['coords']['z'] - 0.45, Config.Droneshops['text_purchase'])
                            if IsDisabledControlJustReleased(0, 161) then
                                TriggerServerEvent('zb-drones:server:purchaseDrone', v['drone_type'])
                                congratzPurchase(v['coords']['x'], v['coords']['y'], v['coords']['z'])
                            end
                        end
                        if dist < 2 and show_information then
                            local ctype = v['drone_type']
                            DrawText3D(v['coords']['x'], v['coords']['y'], v['coords']['z'] - 0.15, Config.Droneshops['text_type'] .. "€" ..Config.Drones[ctype]['price'])
                            DrawText3D(v['coords']['x'], v['coords']['y'], v['coords']['z'] - 0.30, Config.Droneshops['text_distance'] .. Config.Drones[ctype]['maxDistance'])
                            DrawText3D(v['coords']['x'], v['coords']['y'], v['coords']['z'] - 0.45, Config.Droneshops['text_return'])
                        end
                        if dist < 2 and IsControlJustReleased(0, 174) then
                            changeModel(k, 'left')
                        end
                        if dist < 2 and IsControlJustReleased(0, 175) then
                            changeModel(k, 'right')
                        end
                        if dist < 2 and IsControlJustReleased(0, 38) then
                            show_information = not show_information
                        end
                    end
                end
            end

            if letSleep then
                Wait(500)
            end
        end
    end
end)

congratzPurchase = function(x, y, z)
    local success = 0
    while true do
        Wait(1)
        success = success + 1
        if success > 499 then
            return
        end
        DrawText3D(x, y, z, Config.Droneshops['purchased-drone'])
    end
end

changeModel = function(type, sort)
    local number = Config.Droneshops['Shops'][type]['drone_type']
    if sort == 'left' then
        Config.Droneshops['Shops'][type]['drone_type'] = number - 1
        number = number - 1
        if number < 1 then
            number = #Config.Drones 
            Config.Droneshops['Shops'][type]['drone_type'] = #Config.Drones
        end
        DeleteEntity(Config.Droneshops['Shops'][type]['model'])

        local new_type = Config.Drones[number]
        while not IsModelValid(new_type['spawnname']) do
            Wait(0)
            RequestModel(new_type['spawnname'])
        end
        local created = CreateObject(new_type['spawnname'], Config.Droneshops['Shops'][number]['coords']['x'], Config.Droneshops['Shops'][number]['coords']['y'], Config.Droneshops['Shops'][number]['coords']['z'], true, true, false)
        FreezeEntityPosition(created, true)
        Config.Droneshops['Shops'][type]['model'] = created
        Config.Droneshops['Shops'][type]['type'] = number
    else
        Config.Droneshops['Shops'][type]['drone_type'] = number + 1
        number = number + 1
        if number > #Config.Drones then
            number = 1 
            Config.Droneshops['Shops'][type]['drone_type'] = 1
        end
        DeleteEntity(Config.Droneshops['Shops'][type]['model'])

        local new_type = Config.Drones[number]
        while not IsModelValid(new_type['spawnname']) do
            Wait(0)
            RequestModel(new_type['spawnname'])
        end
        local created = CreateObject(new_type['spawnname'], Config.Droneshops['Shops'][number]['coords']['x'], Config.Droneshops['Shops'][number]['coords']['y'], Config.Droneshops['Shops'][number]['coords']['z'], true, true, false)
        FreezeEntityPosition(created, true)
        Config.Droneshops['Shops'][type]['model'] = created
        Config.Droneshops['Shops'][type]['type'] = number
    end
end

SpawnDrones = function()
    while not IsModelValid(Config.Droneshops['spawnname']) do
        Wait(0)
        RequestModel(Config.Droneshops['spawnname'])
    end
    for k,v in pairs(Config.Droneshops['Shops']) do
        local created = CreateObject(Config.Droneshops['spawnname'], v['coords']['x'], v['coords']['y'], v['coords']['z'], true, true, false)
        FreezeEntityPosition(created, true)
        Config.Droneshops['Shops'][k]['model'] = created
        Config.Droneshops['Shops'][k]['type'] = 1
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if Drone ~= nil and not flydrone and not picking then
            local coords = GetEntityCoords(Drone)
            local pos = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(coords, pos, true) < 45 then
                DrawMarker(2, coords['x'], coords['y'], coords['z'] + 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.15, 0.15, 0.15, 120, 10, 20, 155, false, false, false, 1, false, false, false)
                if GetDistanceBetweenCoords(coords, pos, true) < 2 then
                    DrawText3D(coords['x'], coords['y'], coords['z'] - 0.15, Config.PickupText)
                    if IsControlJustReleased(0, 38) then
                        picking = true
                        QBCore.Functions.Progressbar("pickup_drone", Config.ProgressbarsText['pickupDrone'], 5000, false, false, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "anim@mp_fireworks",
                            anim = "place_firework_3_box",
                            flags = 16,
                        }, {}, {}, function() -- Actie netjes afgemaakt
                            TriggerServerEvent('zb-drone:server:pickupDrone')
                            DeleteEntity(Drone)
                            Drone = nil
                            picking = false
                        end)
                    end
                end
            else
                Wait(500)
            end
        else
            Wait(500)
        end
    end
end)

RegisterNetEvent('zb-drones:client:makeDrone')
AddEventHandler('zb-drones:client:makeDrone', function(type)
    if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
        TriggerServerEvent("zb-drones:server:droneGebruiken", type)
        QBCore.Functions.Progressbar("place_drone", Config.ProgressbarsText['placingDrone'], 2500, false, false, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@mp_fireworks",
            anim = "place_firework_3_box",
            flags = 16,
        }, {}, {}, function() -- Actie netjes afgemaakt
            PlaceDrone(type)
        end)
    else
        QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
        -- TriggerServerEvent("zb-drone:server:refundDrone", type)
    end
end)

LostConnection = function()
    DoScreenFadeOut(1500)
    ResetDrone()
end

ResetDrone = function()
    flydrone = false
    SetTimecycleModifier("eyeinthesky")
    SetTimecycleModifierStrength(1.0)
    Wait(1500)
    while not IsScreenFadedOut() do
        Wait(1)
    end
    ClearTimecycleModifier()
	SetCamActive(cam, false)
    RenderScriptCams(false, false, 500, true, true)
	DestroyCam(cam, false)
    cam = nil
    DoScreenFadeIn(500)
    StopSound(Sound)
    ReleaseSoundId(Sound)
    ClearPedTasks(PlayerPedId())
    Sound = nil
    soundon = false
end

PlaceDrone = function(type)
    local pos = GetEntityCoords(PlayerPedId())
    while not IsModelValid(Config.Drones[type]['spawnname']) do
        Wait(0)
        RequestModel(Config.Drones[type]['spawnname'])
    end
    Drone = CreateObject(Config.Drones[type]['spawnname'], pos['x'] + 0.50, pos['y'], pos['z'] - 1.0, true, true, false)
    flydrone = true
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(1)
    end
    FlyDrone(type)
end

DisableControls = function()
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 31, true)
    DisableControlAction(0, 30, true)
    DisableControlAction(0, 21, true)
    DisableControlAction(0, 22, true)
    DisableControlAction(0, 51, true)
    DisableControlAction(0, 52, true)
    DisableControlAction(0, 174, true)
    DisableControlAction(0, 175, true)
    DisableControlAction(0, 173, true)
    DisableControlAction(0, 172, true)
end

FlyDrone = function(type)
    DoScreenFadeIn(500)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 0.0, 0.0, 0.0, 0, 0, 0, 50 * 1.0)
    local min, max = GetModelDimensions(GetEntityModel(Config.Drones[type]['spawnname']))
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, false)
    AttachCamToEntity(cam, Drone, 0.0, 0.0, -max.z/2, false)
    SetFocusEntity(Drone, true)

    ClearTimecycleModifier()
    SetTimecycleModifier("eyeinthesky")
    SetTimecycleModifierStrength(1.0)

    local movement = vector3(0.0, 0.0, 0.0)
    local camrot = vector3(0.0, 0.0, 0.0)
    local head = 0.0
    local rot = 0.0
    local warning = false
    Sound = GetSoundId()

    loadAnimDict('anim@heists@ornate_bank@hack')

    QBCore.Functions.Notify(Config.Instructions['text'], "primary", Config.Instructions['timestamp'])

    while flydrone do
        Wait(0)
        local pos = GetEntityCoords(PlayerPedId())

        if not soundon then
            PlaySoundFromEntity(Sound, "Flight_Loop", Drone, "DLC_BTL_Drone_Sounds", true, 0) 
            soundon = true
        end

        DisableControls()

        local is_moved = false
        local forward, right, up, p = GetEntityMatrix(Drone)
        
        if not IsEntityPlayingAnim(GetPlayerPed(-1), "anim@heists@ornate_bank@hack", "hack_loop", 3) then
            TaskPlayAnim(GetPlayerPed(-1), "anim@heists@ornate_bank@hack", "hack_loop", 8.0, 8.0, -1, 2, false, false, false)
        end

        if IsDisabledControlPressed(0, 32) then
            movement = V3ClampMagnitude(movement + (forward * 2), 250)
            is_moved = true
        end

        if IsDisabledControlPressed(0, 33) then
            movement = V3ClampMagnitude(movement - (forward * 2), 250)
            is_moved = true
        end

        if IsDisabledControlPressed(0, 34) then
            movement = V3ClampMagnitude(movement - (right * 2), 250)
            is_moved = true
        end

        if IsDisabledControlPressed(0, 35) then
            movement = V3ClampMagnitude(movement + (right * 2), 250)
            is_moved = true
        end

        if IsDisabledControlPressed(0, 21) then
            movement = V3ClampMagnitude(movement - (up * 2), 250)
            is_moved = true
        end

        if IsDisabledControlPressed(0, 22) then
            movement = V3ClampMagnitude(movement + (up * 2), 250)
            is_moved = true
        end

        if IsDisabledControlPressed(0, 174) then
            camrot = camrot + (vector3(0.0, 0.0, 1.0))
        end
        
        if IsDisabledControlPressed(0, 175) then
            camrot = camrot - (vector3(0.0, 0.0, 1.0))
        end

        if IsDisabledControlPressed(0, 173) then
            camrot = camrot - (vector3(1.0, 0.0, 0.0))
        end
      
        if IsDisabledControlPressed(0, 172) then
            camrot = camrot + (vector3(1.0, 0.0, 0.0))
        end

        -- Reset drone camera dinges je weet
        if IsDisabledControlPressed(0, 80) then
            camrot = vector3(0.0, 0.0, 0.0)
        end

        if IsDisabledControlPressed(0, 51) then
            rot = math.max(-1.5, rot - 0.02)
        elseif IsDisabledControlPressed(0, 52) then
            rot = math.min(1.5, rot + 0.02)
        else
            if rot > 0.0 then
                rot = math.max(0.0, rot - 0.04)
            elseif rot< 0.0 then
                rot = math.min(0.0, rot + 0.04)
            end
        end
        
        if not is_moved then
            local mov = V3Magnitude(movement)
            if mov > 0.0 then
                movement = movement - (movement / 10.0)
            end
        end

        local head = head + (rot * 2)

        ApplyForceToEntity(Drone, 0, movement['x'], movement['y'], movement['z'] + 20.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
        SetEntityHeading(Drone, head)
        SetCamRot(cam, camrot['x'], camrot['y'], camrot['z'] + head, 2)
        local newpos = GetEntityCoords(Drone)
        if GetDistanceBetweenCoords(pos, newpos, true) > (Config.Drones[type]['maxDistance'] / 100 * 10) then
            SetTimecycleModifier("eyeinthesky")
            SetTimecycleModifierStrength(0.10)
        end
        if GetDistanceBetweenCoords(pos, newpos, true) > (Config.Drones[type]['maxDistance'] / 100 * 25) then
            SetTimecycleModifier("eyeinthesky")
            SetTimecycleModifierStrength(0.25)
        end
        if GetDistanceBetweenCoords(pos, newpos, true) > (Config.Drones[type]['maxDistance'] / 100 * 50) then
            SetTimecycleModifier("eyeinthesky")
            SetTimecycleModifierStrength(0.50)
        end
        if GetDistanceBetweenCoords(pos, newpos, true) > (Config.Drones[type]['maxDistance'] / 100 * 75) then
            SetTimecycleModifier("eyeinthesky")
            SetTimecycleModifierStrength(0.75)
        end
        if GetDistanceBetweenCoords(pos, newpos, true) > (Config.Drones[type]['maxDistance'] / 100 * 90) then
            SetTimecycleModifier("eyeinthesky")
            SetTimecycleModifierStrength(0.90)
        end
        if GetDistanceBetweenCoords(pos, newpos, true) > Config.Drones[type]['maxDistance'] then
            QBCore.Functions.Notify(Config.DroneMessages['reachedMaxDistance'], "error", Config.DroneMessages['timestamp'])
            LostConnection()
            return
        end

        if IsControlJustReleased(0, 105) then
            QBCore.Functions.Notify(Config.DroneMessages['pressedX'], "error", Config.DroneMessages['timestamp'])
            DoScreenFadeOut(750)
            ResetDrone()
            return
        end
    end
end

loadAnimDict = function(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

DrawText3D = function(x, y, z, text)
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

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for i=1, #Config.Droneshops['Shops'], 1 do
            DeleteEntity(Config.Droneshops['Shops'][i]['model'])
        end
    end
end)