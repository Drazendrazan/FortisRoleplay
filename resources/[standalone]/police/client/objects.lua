local ObjectList = {}
local spelerPed = GetPlayerPed(-1)

local speedZoneActive = false
local speedzones = {}

local currentRadIndex = 1
local selectedRadIndex = 1
local currentSpeedIndex = 1
local selectedSpeedIndex = 1

RegisterNetEvent('police:client:objectMenu')
AddEventHandler('police:client:objectMenu', function()
    WarMenu.OpenMenu('objecten')
end)

RegisterNetEvent('police:client:snelheidsZoneMenu')
AddEventHandler('police:client:snelheidsZoneMenu', function()
    
    WarMenu.CreateMenu('snelheidszone', 'Snelheids Zones')
    WarMenu.SetMenuX('snelheidszone', 0.71)
    WarMenu.SetMenuY('snelheidszone', 0.15)
    WarMenu.SetMenuWidth('snelheidszone', 0.23)
    WarMenu.SetTitleColor('snelheidszone', 255, 255, 255, 255)
    WarMenu.SetTitleBackgroundColor('snelheidszone', 0, 0, 0, 111)
    WarMenu.OpenMenu('snelheidszone')
    while true do
        Citizen.Wait(1)
        if WarMenu.IsMenuOpened('snelheidszone') then
            WarMenu.Display()
            local radiusnum = { }
            local speednum = { }
            local speed = 0
            local radius = 25
      
            for k,v in pairs(Config.SpeedZone.Radius) do 
                table.insert(radiusnum, v)
            end
          
            for k,v in pairs(Config.SpeedZone.Speed) do 
                table.insert(speednum, v)
            end
      
            if WarMenu.ComboBox('Radius (Druk op enter)', radiusnum, currentRadIndex, selectedRadIndex, function(currentIndex, selectedIndex)
                currentRadIndex = currentIndex
                selectedRadIndex = selectedIndex
                radius = radiusnum[currentIndex]
            end) then

      
            elseif WarMenu.ComboBox('Snelheid (Druk op enter)', speednum, currentSpeedIndex, selectedSpeedIndex, function(currentIndex, selectedIndex)
                currentSpeedIndex = currentIndex
                selectedSpeedIndex = selectedIndex
                speed = speednum[currentIndex]
            end) then
      
            elseif WarMenu.Button('Maak Zone') then
                if not speedZoneActive then
                    if not speed then
                        speed = 0
                    end
                
                    if not radius then
                        radius = 25
                    end
                
                    speedZoneActive = true
                    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
                    radius = radius + 0.0
                    speed = speed + 0.0
                
                    TriggerServerEvent('ZoneActivated', speed, radius, x, y, z)
                else
                    QBCore.Functions.Notify("Haal eerst de vorige snelheidszone weg!", "error")
                end
      
            elseif WarMenu.Button('Verwijder Zone') then
                speedZoneActive = false
                TriggerServerEvent('Disable')      
            end
        end
    end
end)

Citizen.CreateThread(function()
    WarMenu.CreateMenu('objecten', 'Objecten Menu')
    WarMenu.SetMenuX('objecten', 0.71)
    WarMenu.SetMenuY('objecten', 0.15)
    WarMenu.SetMenuWidth('objecten', 0.23)
    WarMenu.SetTitleColor('objecten', 255, 255, 255, 255)
    WarMenu.SetTitleBackgroundColor('objecten', 0, 0, 0, 111)

    while true do
        Citizen.Wait(3)
        if WarMenu.IsMenuOpened('objecten') then
            WarMenu.Display()
            if WarMenu.Button('Snelheids Zone') then
                TriggerEvent('police:client:snelheidsZoneMenu')
            end
            if WarMenu.Button('Pion') then
                TriggerEvent('police:client:spawnPion')
            end
            if WarMenu.Button('Spijkermat') then
                TriggerEvent('police:client:SpawnSpikeStrip')
            end
            if WarMenu.Button('Tent') then
                TriggerEvent('police:client:spawnTent')
            end
            if WarMenu.Button('Lamp') then
                TriggerEvent('police:client:spawnLight')
            end
            if WarMenu.Button('Barrière') then
                TriggerEvent('police:client:spawnBarier')
            end
            if WarMenu.Button('Stop Bord') then
                TriggerEvent('police:client:spawnSchotten')
            end
            if WarMenu.Button('Verwijder Object') then
                TriggerEvent('police:client:deleteObject')
            end

        end
    end
end)

-- Citizen.CreateThread(function()
--     WarMenu.CreateMenu('snelheidszone', 'Snelheids Zones')
--     WarMenu.SetMenuX('snelheidszone', 0.71)
--     WarMenu.SetMenuY('snelheidszone', 0.15)
--     WarMenu.SetMenuWidth('snelheidszone', 0.23)
--     WarMenu.SetTitleColor('snelheidszone', 255, 255, 255, 255)
--     WarMenu.SetTitleBackgroundColor('snelheidszone', 0, 0, 0, 111)

--     while true do
--         Citizen.Wait(1)
--         if WarMenu.IsMenuOpened('snelheidszone') then
--             WarMenu.Display()
--             local radiusnum = { }
--             local speednum = { }
--             local speed = 0
--             local radius = 25
      
--             for k,v in pairs(Config.SpeedZone.Radius) do 
--                 table.insert(radiusnum, v)
--             end
          
--             for k,v in pairs(Config.SpeedZone.Speed) do 
--                 table.insert(speednum, v)
--             end
      
--             if WarMenu.ComboBox('Radius (Druk op enter)', radiusnum, currentRadIndex, selectedRadIndex, function(currentIndex, selectedIndex)
--                 currentRadIndex = currentIndex
--                 selectedRadIndex = selectedIndex
--                 radius = radiusnum[currentIndex]
--             end) then

      
--             elseif WarMenu.ComboBox('Snelheid (Druk op enter)', speednum, currentSpeedIndex, selectedSpeedIndex, function(currentIndex, selectedIndex)
--                 currentSpeedIndex = currentIndex
--                 selectedSpeedIndex = selectedIndex
--                 speed = speednum[currentIndex]
--             end) then
      
--             elseif WarMenu.Button('Maak Zone') then
--                 if not speedZoneActive then
--                     if not speed then
--                         speed = 0
--                     end
                
--                     if not radius then
--                         radius = 25
--                     end
                
--                     speedZoneActive = true
--                     local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
--                     radius = radius + 0.0
--                     speed = speed + 0.0
                
--                     TriggerServerEvent('ZoneActivated', speed, radius, x, y, z)
--                 else
--                     QBCore.Functions.Notify("Haal eerst de vorige snelheidszone weg!", "error")
--                 end
      
--             elseif WarMenu.Button('Verwijder Zone') then
--                 speedZoneActive = false
--                 TriggerServerEvent('Disable')      
--             end
--         end
--     end
-- end)

RegisterNetEvent('Zone')
AddEventHandler('Zone', function(speed, radius, x, y, z)
    blip = AddBlipForRadius(x, y, z, radius)
    SetBlipColour(blip,idcolor)
    SetBlipAlpha(blip,80)
    SetBlipSprite(blip,9)

    speedZone = AddSpeedZoneForCoord(x, y, z, radius, speed, false)
    table.insert(speedzones, {x, y, z, speedZone, blip})
end)

RegisterNetEvent('RemoveBlip')
AddEventHandler('RemoveBlip', function()

    if speedzones == nil then
      return
    end

    local playerPed = GetPlayerPed(-1)
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    local closestSpeedZone = 0
    local closestDistance = 1000

    for i = 1, #speedzones, 1 do
        local distance = Vdist(speedzones[i][1], speedzones[i][2], speedzones[i][3], x, y, z)
        if distance < closestDistance then
            closestDistance = distance
            closestSpeedZone = i
        end
    end

    if speedzones[closestSpeedZone] ~= nil then
        RemoveSpeedZone(speedzones[closestSpeedZone][4])
        RemoveBlip(speedzones[closestSpeedZone][5])
        table.remove(speedzones, closestSpeedZone)
    end
end)

RegisterNetEvent('police:client:spawnPion')
AddEventHandler('police:client:spawnPion', function()
    if IsPedInAnyVehicle(spelerPed, false) then
        QBCore.Functions.Notify('Je mag niet in een voertuig zitten als je een object plaatst!', 'error')
    else
        QBCore.Functions.Progressbar("spawn_object", "Voorwerp plaatsen..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@narcotics@trash",
            anim = "drop_front",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
            TriggerServerEvent("police:server:spawnObject", "cone")
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
            QBCore.Functions.Notify("Geannuleerd..", "error")
        end)
    end
end)

RegisterNetEvent('police:client:spawnBarier')
AddEventHandler('police:client:spawnBarier', function()
    if IsPedInAnyVehicle(spelerPed, false) then
        QBCore.Functions.Notify('Je mag niet in een voertuig zitten als je een object plaatst!', 'error')
    else
        QBCore.Functions.Progressbar("spawn_object", "Voorwerp plaatsen..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@narcotics@trash",
            anim = "drop_front",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
            TriggerServerEvent("police:server:spawnObject", "barier")
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
            QBCore.Functions.Notify("Geannuleerd..", "error")
        end)
    end
end)

RegisterNetEvent('police:client:spawnSchotten')
AddEventHandler('police:client:spawnSchotten', function()
    if IsPedInAnyVehicle(spelerPed, false) then
        QBCore.Functions.Notify('Je mag niet in een voertuig zitten als je een object plaatst!', 'error')
    else
        QBCore.Functions.Progressbar("spawn_object", "Voorwerp plaatsen..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@narcotics@trash",
            anim = "drop_front",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
            TriggerServerEvent("police:server:spawnObject", "schotten")
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
            QBCore.Functions.Notify("Geannuleerd..", "error")
        end)
    end
end)

RegisterNetEvent('police:client:spawnTent')
AddEventHandler('police:client:spawnTent', function()
    if IsPedInAnyVehicle(spelerPed, false) then
        QBCore.Functions.Notify('Je mag niet in een voertuig zitten als je een object plaatst!', 'error')
    else
        QBCore.Functions.Progressbar("spawn_object", "Voorwerp plaatsen..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@narcotics@trash",
            anim = "drop_front",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
            TriggerServerEvent("police:server:spawnObject", "tent")
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
            QBCore.Functions.Notify("Geannuleerd..", "error")
        end)
    end
end)

RegisterNetEvent('police:client:spawnLight')
AddEventHandler('police:client:spawnLight', function()
    if IsPedInAnyVehicle(spelerPed, false) then
        QBCore.Functions.Notify('Je mag niet in een voertuig zitten als je een object plaatst!', 'error')
    else
        local coords = GetEntityCoords(GetPlayerPed(-1))
        QBCore.Functions.Progressbar("spawn_object", "Voorwerp plaatsen..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@narcotics@trash",
            anim = "drop_front",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
            TriggerServerEvent("police:server:spawnObject", "light")
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
            QBCore.Functions.Notify("Geannuleerd..", "error")
        end)
    end
end)

RegisterNetEvent('police:client:deleteObject')
AddEventHandler('police:client:deleteObject', function()
    if IsPedInAnyVehicle(spelerPed, false) then
        QBCore.Functions.Notify('Je mag niet in een voertuig zitten als je een object plaatst!', 'error')
    else
        local objectId, dist = GetClosestPoliceObject()
        if dist < 5.0 then
            QBCore.Functions.Progressbar("remove_object", "Object oppakken...", 2500, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
                anim = "plant_floor",
                flags = 16,
            }, {}, {}, function() -- Done
                StopAnimTask(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
                TriggerServerEvent("police:server:deleteObject", objectId)
            end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
                QBCore.Functions.Notify("Geannuleerd..", "error")
            end)
        end
    end
end)

RegisterNetEvent('police:client:removeObject')
AddEventHandler('police:client:removeObject', function(objectId)
    NetworkRequestControlOfEntity(ObjectList[objectId].object)
    DeleteObject(ObjectList[objectId].object)
    ObjectList[objectId] = nil
end)

RegisterNetEvent('police:client:spawnObject')
AddEventHandler('police:client:spawnObject', function(objectId, type, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local heading = GetEntityHeading(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(-1))
    local x, y, z = table.unpack(coords + forward * 0.5)
    local spawnedObj = CreateObject(Config.Objects[type].model, x, y, z, false, false, false)
    PlaceObjectOnGroundProperly(spawnedObj)
    SetEntityHeading(spawnedObj, heading)
    FreezeEntityPosition(spawnedObj, Config.Objects[type].freeze)
    ObjectList[objectId] = {
        id = objectId,
        object = spawnedObj,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

function GetClosestPoliceObject()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, data in pairs(ObjectList) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true)
            current = id
        end
    end
    return current, dist
end

local SpikeConfig = {
    MaxSpikes = 5
}
local SpawnedSpikes = {}
local spikemodel = "P_ld_stinger_s"
local nearSpikes = false
local spikesSpawned = false
local ClosestSpike = nil

Citizen.CreateThread(function()
    while true do

        if isLoggedIn then
            GetClosestSpike()
        end

        Citizen.Wait(500)
    end
end)

function GetClosestSpike()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil

    for id, data in pairs(SpawnedSpikes) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, SpawnedSpikes[id].coords.x, SpawnedSpikes[id].coords.y, SpawnedSpikes[id].coords.z, true) < dist)then
                current = id
            end
        else
            dist = GetDistanceBetweenCoords(pos, SpawnedSpikes[id].coords.x, SpawnedSpikes[id].coords.y, SpawnedSpikes[id].coords.z, true)
            current = id
        end
    end
    ClosestSpike = current
end

RegisterNetEvent('police:client:SpawnSpikeStrip')
AddEventHandler('police:client:SpawnSpikeStrip', function()
    if #SpawnedSpikes + 1 < SpikeConfig.MaxSpikes then
        local PlayerData = QBCore.Functions.GetPlayerData()
        if PlayerData.job.name == "police" and PlayerData.job.onduty then
            local spawnCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 2.0, 0.0)
            local spike = CreateObject(GetHashKey(spikemodel), spawnCoords.x, spawnCoords.y, spawnCoords.z, 1, 1, 1)
            local netid = NetworkGetNetworkIdFromEntity(spike)
            SetNetworkIdExistsOnAllMachines(netid, true)
            SetNetworkIdCanMigrate(netid, false)
            SetEntityHeading(spike, GetEntityHeading(GetPlayerPed(-1)))
            PlaceObjectOnGroundProperly(spike)
            table.insert(SpawnedSpikes, {
                coords = {
                    x = spawnCoords.x,
                    y = spawnCoords.y,
                    z = spawnCoords.z,
                },
                netid = netid,
                object = spike,
            })
            spikesSpawned = true
            TriggerServerEvent('police:server:SyncSpikes', SpawnedSpikes)
        end
    else
        QBCore.Functions.Notify('There are no Spikestrips left..', 'error')
    end
end)

RegisterNetEvent('police:client:SyncSpikes')
AddEventHandler('police:client:SyncSpikes', function(table)
    SpawnedSpikes = table
end)

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            if ClosestSpike ~= nil then
                local tires = {
                    {bone = "wheel_lf", index = 0},
                    {bone = "wheel_rf", index = 1},
                    {bone = "wheel_lm", index = 2},
                    {bone = "wheel_rm", index = 3},
                    {bone = "wheel_lr", index = 4},
                    {bone = "wheel_rr", index = 5}
                }

                for a = 1, #tires do
                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))
                    local spike = GetClosestObjectOfType(tirePos.x, tirePos.y, tirePos.z, 15.0, GetHashKey(spikemodel), 1, 1, 1)
                    local spikePos = GetEntityCoords(spike, false)
                    local distance = Vdist(tirePos.x, tirePos.y, tirePos.z, spikePos.x, spikePos.y, spikePos.z)

                    if distance < 1.8 then
                        if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
                            SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)
                        end
                    end
                end
            end
        end

        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            if ClosestSpike ~= nil then
                local ped = GetPlayerPed(-1)
                local pos = GetEntityCoords(ped)
                local dist = GetDistanceBetweenCoords(pos, SpawnedSpikes[ClosestSpike].coords.x, SpawnedSpikes[ClosestSpike].coords.y, SpawnedSpikes[ClosestSpike].coords.z, true)

                if dist < 4 then
                    if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                        local PlayerData = QBCore.Functions.GetPlayerData()
                        if PlayerJob.name == "police" and PlayerData.job.onduty then
                            DrawText3D(pos.x, pos.y, pos.z, '~g~[E] ~w~Oppakken')
                            if IsControlJustPressed(0, Keys["E"]) then
                                NetworkRegisterEntityAsNetworked(SpawnedSpikes[ClosestSpike].object)
                                NetworkRequestControlOfEntity(SpawnedSpikes[ClosestSpike].object)            
                                SetEntityAsMissionEntity(SpawnedSpikes[ClosestSpike].object) 
                                SetEntityAsNoLongerNeeded(SpawnedSpikes[ClosestSpike].object)       
                                DeleteEntity(SpawnedSpikes[ClosestSpike].object)
                                table.remove(SpawnedSpikes, ClosestSpike)
                                ClosestSpike = nil
                                TriggerServerEvent('police:server:SyncSpikes', SpawnedSpikes)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(3)
    end
end)