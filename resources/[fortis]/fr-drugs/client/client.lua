QBCore = nil
local sync = {}

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
            Citizen.Wait(200)
            QBCore.Functions.TriggerCallback('fr-drugs:server:requestTable', function(table)
                sync = table
            end)
        end
    end
end)

RegisterNetEvent('fr-drugs:client:resyncTable')
AddEventHandler('fr-drugs:client:resyncTable', function(table)
    sync = table
end)

Citizen.CreateThread(function()
    while sync == nil do Wait(500) end
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        letSleep = true
        for k,v in pairs(sync) do
            local dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.coords.x, v.coords.y, v.coords.z, true)
            if dist < 5 then
				letSleep = false
                DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 222, 11, 11, 155, false, false, false, true, false, false, false)
                if dist < 3 then
                    QBCore.Functions.DrawText3D(v.coords.x, v.coords.y, v.coords.z - 0.10, v.text)
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent('fr-drugs:server:requestSort', k)
                    end
                end
            end
        end

        if letSleep then
            Wait(500)
        end
    end
end)