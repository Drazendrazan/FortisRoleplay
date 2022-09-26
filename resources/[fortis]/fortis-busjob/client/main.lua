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
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

local lastLocation = nil
local route = 1
local max = 0

for k,v in pairs(Config.NPCLocations.Locations) do
    max = max + 1
end

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
    CountDown = 180
}

-- Functions

local function ResetNpcTask()
    NpcData = {
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
    }
end

local function whitelistedVehicle()
    local ped = PlayerPedId()
    local veh = GetEntityModel(GetVehiclePedIsIn(ped))
    local retval = false

    for i = 1, #Config.AllowedVehicles, 1 do
        if veh == GetHashKey(Config.AllowedVehicles[i].model) then
            retval = true
        end
    end

    if veh == GetHashKey("dynasty") then
        retval = true
    end

    return retval
end

local function IsDriver()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end

local function DrawText3D(x, y, z, text)
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

local function GetDeliveryLocation()
    if route <= (max - 1) then
        route = route + 1
    else
        route = 1
    end

    if NpcData.DeliveryBlip ~= nil then
        RemoveBlip(NpcData.DeliveryBlip)
    end
    NpcData.DeliveryBlip = AddBlipForCoord(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z)
    SetBlipColour(NpcData.DeliveryBlip, 3)
    SetBlipRoute(NpcData.DeliveryBlip, true)
    SetBlipRouteColour(NpcData.DeliveryBlip, 3)
    NpcData.LastDeliver = route

    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = #(pos - vector3(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z))
            if dist < 20 then
                DrawMarker(2, Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                if dist < 7 then
                    DrawText3D(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z, '~g~[E]~w~ Bus halte')
                    if IsControlJustPressed(0, 38) then
                        local veh = GetVehiclePedIsIn(ped, 0)
                        TaskLeaveVehicle(NpcData.Npc, veh, 0)
                        SetEntityAsMissionEntity(NpcData.Npc, false, true)
                        SetEntityAsNoLongerNeeded(NpcData.Npc)
                        local targetCoords = Config.NPCLocations.Locations[NpcData.LastNpc]
                        TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                        QBCore.Functions.Notify('De passagier is afgezet', 'success')
                        if NpcData.DeliveryBlip ~= nil then
                            RemoveBlip(NpcData.DeliveryBlip)
                        end
                        local RemovePed = function(ped)
                            SetTimeout(60000, function()
                                DeletePed(ped)
                            end)
                        end
                        RemovePed(NpcData.Npc)
                        ResetNpcTask()
                        route = route + 1
                        TriggerEvent('qb-busjob:client:DoBusNpc')
                        break                          
                        
                    end
                end
            end
            Wait(1)
        end
    end)
end

RegisterNetEvent("qb-busjob:client:TakeVehicle", function()
    local spawnLocatie = {x = 462.26, y = -641.95, z = 28.45, h = 175.0}
    QBCore.Functions.SpawnVehicle("bus", function(veh)
        SetVehicleNumberPlateText(veh, "BUS"..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, spawnLocatie, true)
    Wait(1000)
    TriggerEvent('qb-busjob:client:DoBusNpc')
end)

function closeMenuFull()
    exports['fortis-menu']:closeMenu()
end
-- Events

RegisterNetEvent('qb-busjob:client:DoBusNpc', function()
    if whitelistedVehicle() then
        if not NpcData.Active then
            local Gender = math.random(1, #Config.NpcSkins)
            local PedSkin = math.random(1, #Config.NpcSkins[Gender])
            local model = GetHashKey(Config.NpcSkins[Gender][PedSkin])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            NpcData.Npc = CreatePed(3, model, Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z - 0.98, Config.NPCLocations.Locations[route].w, false, true)
            PlaceObjectOnGroundProperly(NpcData.Npc)
            FreezeEntityPosition(NpcData.Npc, true)
            if NpcData.NpcBlip ~= nil then
                RemoveBlip(NpcData.NpcBlip)
            end
            QBCore.Functions.Notify('Ga naar de bus halte!', 'success')
            NpcData.NpcBlip = AddBlipForCoord(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z)
            SetBlipColour(NpcData.NpcBlip, 3)
            SetBlipRoute(NpcData.NpcBlip, true)
            SetBlipRouteColour(NpcData.NpcBlip, 3)
            NpcData.LastNpc = route
            NpcData.Active = true

            CreateThread(function()
                while not NpcData.NpcTaken do

                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    local dist = #(pos - vector3(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z))

                    if dist < 20 then
                        DrawMarker(2, Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)

                        if dist < 5 then
                            DrawText3D(Config.NPCLocations.Locations[route].x, Config.NPCLocations.Locations[route].y, Config.NPCLocations.Locations[route].z, '~g~[E]~w~ Bus halte')
                            if IsControlJustPressed(0, 38) then
                                local veh = GetVehiclePedIsIn(ped, 0)
                                local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)

                                for i=maxSeats - 1, 0, -1 do
                                    if IsVehicleSeatFree(veh, i) then
                                        freeSeat = i
                                        break
                                    end
                                end

                                lastLocation = GetEntityCoords(PlayerPedId())
                                ClearPedTasksImmediately(NpcData.Npc)
                                FreezeEntityPosition(NpcData.Npc, false)
                                TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
                                QBCore.Functions.Notify('Ga naar de bushalte', "success")
                                if NpcData.NpcBlip ~= nil then
                                    RemoveBlip(NpcData.NpcBlip)
                                end
                                GetDeliveryLocation()
                                NpcData.NpcTaken = true
                                TriggerServerEvent('qb-busjob:server:NpcPay', math.random(50, 80))
                            end
                        end
                    end

                    Wait(1)
                end
            end)
        else
           QBCore.Functions.Notify('Je bestuurd al een bus')
        end
    else
        QBCore.Functions.Notify('Je zit niet in een bus!')
    end
end)


-- Threads
Citizen.CreateThread(function()
    local kaasje = false

    while true do
        Citizen.Wait(1)
        while PlayerData == nil do Wait(500) end
        while PlayerData.job == nil do Wait(500) end
        if PlayerData.job.name == "bus" then
            if not kaasje then
                BusBlip = AddBlipForCoord(Config.Location)
                SetBlipSprite (BusBlip, 513)
                SetBlipDisplay(BusBlip, 4)
                SetBlipScale  (BusBlip, 0.6)
                SetBlipAsShortRange(BusBlip, true)
                SetBlipColour(BusBlip, 49)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName("Bus Depot")
                EndTextCommandSetBlipName(BusBlip)
                kaasje = true
            end
        else
            kaasje = false
            RemoveBlip(BusBlip)
            Citizen.Wait(2000)
        end
    end
end)

CreateThread(function()
    while true do
        inRange = false
        if not isLoggedIn then
            local Player = QBCore.Functions.GetPlayerData()
            if Player.job.name == "bus" then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)

                local vehDist = #(pos - vector3(Config.Location.x, Config.Location.y, Config.Location.z))
                local busdist = #(pos - vector3(Config.busLocation.x, Config.busLocation.y, Config.busLocation.z))

                if vehDist < 30 then
                    inRange = true

                    DrawMarker(2, Config.Location.x, Config.Location.y, Config.Location.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                    if whitelistedVehicle() then
                        DrawMarker(2, Config.busLocation.x, Config.busLocation.y, Config.busLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                    end

                    if vehDist < 1.5 or busdist <2.5 then
                        if whitelistedVehicle() and busdist <2.5 then
                            DrawText3D(Config.busLocation.x, Config.busLocation.y, Config.busLocation.z + 0.3, '~g~[E]~w~ Stop met werken')
                            if IsControlJustReleased(0, 38) then
                                if not NpcData.Active then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                    end
                                else
                                    ResetNpcTask()
                                    Citizen.Wait(250)
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                    end
                                end
                            end
                            
                        elseif vehDist < 1.5 and not whitelistedVehicle() then
                            DrawText3D(Config.Location.x, Config.Location.y, Config.Location.z + 0.3, '~g~[E]~w~ Bus pakken')
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent("qb-busjob:client:TakeVehicle")
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Wait(3000)
        end

        Wait(3)
    end
end)

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end
