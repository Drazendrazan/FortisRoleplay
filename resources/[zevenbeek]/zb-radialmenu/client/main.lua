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

local inRadialMenu = false
ramenbeneden = false
ramenbenedenbesuurder = false
ramenbenedenbijrijder = false
ramenbenedenrechtsachter = false
ramenbenedenlinksachter = false 

function setupSubItems()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] then
            if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
                Config.MenuItems[4].items = {
                    [1] = {
                        id = 'emergencybutton2',
                        title = 'Noodknop',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:SendPoliceEmergencyAlert',
                        shouldClose = true,
                    },
                }
            end
        else 
            if Config.JobInteractions[PlayerData.job.name] ~= nil and next(Config.JobInteractions[PlayerData.job.name]) ~= nil then
                if PlayerData.job.onduty and PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "mechanic" then
                    Config.MenuItems[4].items = Config.JobInteractions[PlayerData.job.name]
                elseif PlayerData.job.name ~= "police" and PlayerData.job.name ~= "ambulance" and PlayerData.job.name ~= "mechanic" then
                    Config.MenuItems[4].items = Config.JobInteractions[PlayerData.job.name]
                else
                    Config.MenuItems[4].items = {}
                end
            else 
                Config.MenuItems[4].items = {}
            end
        end
    end)

    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))

    if Vehicle ~= nil or Vehicle ~= 0 then
        local AmountOfSeats = GetVehicleModelNumberOfSeats(GetEntityModel(Vehicle))

        if AmountOfSeats == 2 then
            Config.MenuItems[3].items[3].items = {
                [1] = {
                    id    = -1,
                    title = 'Bestuurder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [2] = {
                    id    = 0,
                    title = 'Bijrijder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        elseif AmountOfSeats == 3 then
            Config.MenuItems[3].items[3].items = {
                [4] = {
                    id    = -1,
                    title = 'Bestuurder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [1] = {
                    id    = 0,
                    title = 'Bijrijder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [3] = {
                    id    = 1,
                    title = 'Overige',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        elseif AmountOfSeats == 4 then
            Config.MenuItems[3].items[3].items = {
                [4] = {
                    id    = -1,
                    title = 'Bestuurder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [1] = {
                    id    = 0,
                    title = 'Bijrijder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [3] = {
                    id    = 1,
                    title = 'Achterbank Links',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [2] = {
                    id    = 2,
                    title = 'Achterbank Rechts',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            }
        elseif AmountOfSeats == 6 then
            Config.MenuItems[3].items[3].items = {
                [4] = {
                    id    = -1,
                    title = 'Bestuurder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [1] = {
                    id    = 0,
                    title = 'Bijrijder',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [3] = {
                    id    = 1,
                    title = 'Achterbank Links',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [2] = {
                    id    = 2,
                    title = 'Achterbank Rechts',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [5] = {
                    id    = 3,
                    title = 'Bak links',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
                [6] = {
                    id    = 4,
                    title = 'Bak rechts',
                    icon = '#vehicleseat',
                    type = 'client',
                    event = 'qb-radialmenu:client:ChangeSeat',
                    shouldClose = false,
                },
            } 
        end
    end
end

function openRadial(bool)    
    setupSubItems()

    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        radial = bool,
        items = Config.MenuItems
    })
    inRadialMenu = bool
end

function closeRadial(bool)    
    SetNuiFocus(false, false)
    inRadialMenu = bool
end

function getNearestVeh()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)

        if IsControlJustPressed(0, Keys["F1"]) then
            openRadial(true)
            SetCursorLocation(0.5, 0.5)
        end
    end
end)

RegisterNUICallback('closeRadial', function()
	Wait(3)
    closeRadial(false)
	Wait(5)
	SetNuiFocus(false, false)
end)

RegisterNUICallback('selectItem', function(data)
    local itemData = data.itemData

    if itemData.type == 'client' then
        TriggerEvent(itemData.event, itemData)
    elseif itemData.type == 'server' then
        TriggerServerEvent(itemData.event, itemData)
    end
end)

RegisterNetEvent('qb-radialmenu:client:noPlayers')
AddEventHandler('qb-radialmenu:client:noPlayers', function(data)
    QBCore.Functions.Notify('Er zijn geen spelers dichtbij!', 'error', 2500)
end)

RegisterNetEvent('qb-radialmenu:client:giveidkaart')
AddEventHandler('qb-radialmenu:client:giveidkaart', function(data)
end)

RegisterNetEvent('qb-radialmenu:client:openDoor')
AddEventHandler('qb-radialmenu:client:openDoor', function(data)
    local string = data.id
    local replace = string:gsub("door", "")
    local door = tonumber(replace)
    local ped = GetPlayerPed(-1)
    local closestVehicle = nil

    if IsPedInAnyVehicle(ped, false) then
        closestVehicle = GetVehiclePedIsIn(ped)
    else
        closestVehicle = getNearestVeh()
    end

    if closestVehicle ~= 0 then
        if closestVehicle ~= GetVehiclePedIsIn(ped) then
            local plate = GetVehicleNumberPlateText(closestVehicle)
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('qb-radialmenu:trunk:server:Door', false, plate, door)
                else
                    SetVehicleDoorShut(closestVehicle, door, false)
                end
            else
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('qb-radialmenu:trunk:server:Door', true, plate, door)
                else
                    SetVehicleDoorOpen(closestVehicle, door, false, false)
                end
            end
        else
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                SetVehicleDoorShut(closestVehicle, door, false)
            else
                SetVehicleDoorOpen(closestVehicle, door, false, false)
            end
        end
    else
        QBCore.Functions.Notify('Er is geen voertuig dichtbij!', 'error', 2500)
    end
end)

RegisterNetEvent('qb-radialmenu:client:setExtra')
AddEventHandler('qb-radialmenu:client:setExtra', function(data)
    local string = data.id
    local replace = string:gsub("extra", "")
    local extra = tonumber(replace)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)
    local class = GetVehicleClass(veh)
    local enginehealth = 1000.0
    local bodydamage = 1000.0

    if veh ~= nil then
        if class ~= 15 and class ~= 16 then 
            local plate = GetVehicleNumberPlateText(closestVehicle)
            
            if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
                SetVehicleAutoRepairDisabled(veh, true)
                if DoesExtraExist(veh, extra) then 
                    if IsVehicleExtraTurnedOn(veh, extra) then
                        enginehealth = GetVehicleEngineHealth(veh)
                        bodydamage = GetVehicleBodyHealth(veh)
                        SetVehicleExtra(veh, extra, 1)
                        SetVehicleEngineHealth(veh, enginehealth)
                        QBCore.Functions.Notify('Extra ' .. extra .. ' gedeactiveerd!', 'error', 2500)
                    else
                        enginehealth = GetVehicleEngineHealth(veh)
                        bodydamage = GetVehicleBodyHealth(veh)
                        SetVehicleExtra(veh, extra, 0)
                        SetVehicleEngineHealth(veh, enginehealth)
                        QBCore.Functions.Notify('Extra ' .. extra .. ' geactiveerd!', 'success', 2500)
                    end    
                else
                    QBCore.Functions.Notify('Extra ' .. extra .. ' bestaat niet op dit voertuig!', 'error', 2500)
                end
            else
                QBCore.Functions.Notify('Je zit niet in een voertuig!', 'error', 2500)
            end
        else
            QBCore.Functions.Notify('Je kan geen extras van dit type voertuigen halen!', 'error', 2500)
        end
    end
end)

RegisterNetEvent('qb-radialmenu:trunk:client:Door')
AddEventHandler('qb-radialmenu:trunk:client:Door', function(plate, door, open)
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1))

    if veh ~= 0 then
        local pl = GetVehicleNumberPlateText(veh)

        if pl == plate then
            if open then
                SetVehicleDoorOpen(veh, door, false, false)
            else
                SetVehicleDoorShut(veh, door, false)
            end
        end
    end
end)

local Seats = {
    ["-1"] = "Bestuurder's stoel",
    ["0"] = "Bijrijder's stoel",
    ["1"] = "Achterbank Links",
    ["2"] = "Achterbank Rechts",
}

RegisterNetEvent('qb-radialmenu:client:ChangeSeat')
AddEventHandler('qb-radialmenu:client:ChangeSeat', function(data)
    local Veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    local IsSeatFree = IsVehicleSeatFree(Veh, data.id)
    local speed = GetEntitySpeed(Veh)
	if IsSeatFree then
		if kmh == nil or kmh <= 50.0then
			SetPedIntoVehicle(GetPlayerPed(-1), Veh, data.id)
			QBCore.Functions.Notify('Je zit nu op de '..data.title..'!')
		else
			QBCore.Functions.Notify('Het voertuig gaat te snel')
		end
	else
		QBCore.Functions.Notify('Er zit al iemand op deze stoel!')
	end
end)

local motorAan = false
local veh = nil

RegisterNetEvent('qb-radialmenu:client:VehicleEngine')
AddEventHandler('qb-radialmenu:client:VehicleEngine', function()
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        motorAan = true
        veh = GetVehiclePedIsIn(GetPlayerPed(-1))
        
        while true do
          Citizen.Wait(1)
          if not IsPedInAnyVehicle(GetPlayerPed(-1)) and veh ~= nil then
            SetVehicleEngineOn(veh, true, true, true)
            motorAan = false
            veh = nil
            return
          end
        end
        
      else  
        QBCore.Functions.Notify("Je zit niet in een voertuig!")
    end
end)

RegisterNetEvent('qb-radialmenu:client:raampjeszakuuuhhhh')
AddEventHandler('qb-radialmenu:client:raampjeszakuuuhhhh', function()
    if IsPedInAnyVehicle(PlayerPedId()) then
        voertuig = GetVehiclePedIsIn(PlayerPedId())
        class = GetVehicleClass(voertuig)
        if class ~= 15 and class ~= 16 and class ~= 14 then 
            if not ramenbeneden then
                RollDownWindow(voertuig, 0)
                RollDownWindow(voertuig, 1)
                RollDownWindow(voertuig, 2)
                RollDownWindow(voertuig, 3)
                RollDownWindow(voertuig, 4)
                RollDownWindow(voertuig, 5)
                ramenbeneden = true
            else
                RollUpWindow(voertuig, 0)
                RollUpWindow(voertuig, 1)
                RollUpWindow(voertuig, 2)
                RollUpWindow(voertuig, 3)
                RollUpWindow(voertuig, 4)
                RollUpWindow(voertuig, 5)
                ramenbeneden = false
            end
        else
            QBCore.Functions.Notify("Van dit voertuig kunnen de ramen niet naar benenden", "error")
        end
    end
end)

RegisterNetEvent('qb-radialmenu:client:raampjeszakuuuhhhhbesuurder')
AddEventHandler('qb-radialmenu:client:raampjeszakuuuhhhhbesuurder', function()
    if IsPedInAnyVehicle(PlayerPedId()) then
        voertuig = GetVehiclePedIsIn(PlayerPedId())
        class = GetVehicleClass(voertuig)
        if class ~= 15 and class ~= 16 and class ~= 14 then 
            if not ramenbenedenbesuurder then
                RollDownWindow(voertuig, 0)
                ramenbenedenbesuurder = true
            else
                RollUpWindow(voertuig, 0)
                ramenbenedenbesuurder = false
            end
        else
            QBCore.Functions.Notify("Van dit voertuig kunnen de ramen niet naar benenden", "error")
        end
    end
end)

RegisterNetEvent('qb-radialmenu:client:raampjeszakuuuhhhhrechts')
AddEventHandler('qb-radialmenu:client:raampjeszakuuuhhhhrechts', function()
    if IsPedInAnyVehicle(PlayerPedId()) then
        voertuig = GetVehiclePedIsIn(PlayerPedId())
        class = GetVehicleClass(voertuig)
        if class ~= 15 and class ~= 16 and class ~= 14 then 
            if not ramenbenedenbijrijder then
                RollDownWindow(voertuig, 1)
                ramenbenedenbijrijder = true
            else
                RollUpWindow(voertuig, 1)
                ramenbenedenbijrijder = false
            end
        else
            QBCore.Functions.Notify("Van dit voertuig kunnen de ramen niet naar benenden", "error")
        end
    end
end)

RegisterNetEvent('qb-radialmenu:client:raampjeszakuuuhhhhlinksachter')
AddEventHandler('qb-radialmenu:client:raampjeszakuuuhhhhlinksachter', function()
    if IsPedInAnyVehicle(PlayerPedId()) then
        voertuig = GetVehiclePedIsIn(PlayerPedId())
        class = GetVehicleClass(voertuig)
        if class ~= 15 and class ~= 16 and class ~= 14 then 
            if not ramenbenedenlinksachter then
                RollDownWindow(voertuig, 2)
                ramenbenedenlinksachter = true
            else
                RollUpWindow(voertuig, 2)
                ramenbenedenlinksachter = false
            end
        else
            QBCore.Functions.Notify("Van dit voertuig kunnen de ramen niet naar benenden", "error")
        end
    end
end)

RegisterNetEvent('qb-radialmenu:client:raampjeszakuuuhhhhrechtsachter')
AddEventHandler('qb-radialmenu:client:raampjeszakuuuhhhhrechtsachter', function()
    if IsPedInAnyVehicle(PlayerPedId()) then
        voertuig = GetVehiclePedIsIn(PlayerPedId())
        class = GetVehicleClass(voertuig)
        if class ~= 15 and class ~= 16 and class ~= 14 then 
            if not ramenbenedenrechtsachter then
                RollDownWindow(voertuig, 3)
                ramenbenedenrechtsachter = true
            else
                RollUpWindow(voertuig, 3)
                ramenbenedenrechtsachter = false
            end
        else
            QBCore.Functions.Notify("Van dit voertuig kunnen de ramen niet naar benenden", "error")
        end
    end
end)

RegisterNetEvent("qb-radialmenu:client:switchNeon")
AddEventHandler("qb-radialmenu:client:switchNeon", function()
    local curVeh = GetVehiclePedIsIn(PlayerPedId(), false)
    local kenteken = GetVehicleNumberPlateText(curVeh)
    local spawnNaam = GetDisplayNameFromVehicleModel(GetEntityModel(curVeh))
    local hash = GetHashKey(spawnNaam)

    QBCore.Functions.TriggerCallback("zb-anwbmissies:server:checkNeon", function(resultaat)
        if resultaat ~= "straatvoertuig" then
            if resultaat[3][1] == 1 then
                mogelijk = true
                if IsVehicleNeonLightEnabled(curVeh, 1) then
                    var = false
                else
                    var = true
                end
            end 
        else
            mogelijk = false
        end 
        Citizen.Wait(500)
        if mogelijk then 
            if var then
                SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 0, true)
                SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 1, true)
                SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 2, true)
                SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 3, true)
                SetVehicleNeonLightsColour(curVeh, resultaat[4][1], resultaat[4][2], resultaat[4][3])
            else
                SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 0, false)
                SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 1, false)
                SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 2, false)
                SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId(), false), 3, false)
            end
        else
            QBCore.Functions.Notify("Dit voertuig heeft geen neon", "error") 
        end
    end, kenteken, hash, spawnNaam)
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

function DrawText3Ds(x, y, z, text)
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