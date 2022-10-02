local status = false

Citizen.CreateThread(function()
    while true do
        Wait(1)
        local ped = GetPlayerPed(-1)
        if IsControlPressed(0, 25) and not status then
            if IsPedArmed(ped, 4 | 2) then
                if not IsPedInAnyVehicle(ped) then
                    SendNUIMessage({
                        type = "aan"
                    })
                    status = true
                end
            end
        elseif not IsControlPressed(0, 25) and status then
            SendNUIMessage({
                type = "uit"
            })
            status = false
        end
    end
end)