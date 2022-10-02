local seatbeltOn = false
local SpeedBuffer = {}
local vehVelocity = {x = 0.0, y = 0.0, z = 0.0}
local vehHealth = 0.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            seatbeltOn = false
        end
        
        if IsControlJustReleased(0, Keys["G"]) then 
            if IsPedInAnyVehicle(GetPlayerPed(-1)) and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 8 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 13 and GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 14 then
                if seatbeltOn then
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "carunbuckle", 0.25)
                else
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "carbuckle", 0.25)
                    ExecuteCommand("e damn2")
                end
                TriggerEvent("seatbelt:client:ToggleSeatbelt")
            end
        end
		if seatbeltOn then 
            DisableControlAction(0, 75, true)
            DisableControlAction(27, 75, true)
        end

        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            Wait(800)
        end
    end
end)

local handbrake = 0
RegisterNetEvent('resethandbrake')
AddEventHandler('resethandbrake', function()
    while handbrake > 0 do
        handbrake = handbrake - 1
        Citizen.Wait(30)
    end
end)

local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local car = GetVehiclePedIsIn(ped)
        
        if car ~= 0 and (wasInCar or IsCar(car)) then
            wasInCar = true
            speedBuffer[2] = speedBuffer[1]
            speedBuffer[1] = GetEntitySpeed(car)
            
            if speedBuffer[2] ~= nil and not seatbeltOn and GetEntitySpeedVector(car, true).y > 1.0 and speedBuffer[1] > 19.25 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
                local co = GetEntityCoords(ped)
                local fw = Fwv(ped)
                SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                Citizen.Wait(1)
                SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
            end
                
            velBuffer[2] = velBuffer[1]
            velBuffer[1] = GetEntityVelocity(car)
        else
            Wait(1000)
        end
    end
end)

IsCar = function(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end    

Fwv = function(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end


RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function()
    seatbeltOn = not seatbeltOn
end)