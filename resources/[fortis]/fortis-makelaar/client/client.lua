QBCore = nil

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
    Wait(2000)
    local MakelaarBlip = AddBlipForCoord(-1911.98, -571.05, 19.84)
    SetBlipSprite(MakelaarBlip, 374)
    SetBlipColour(MakelaarBlip, 11)
    SetBlipScale(MakelaarBlip, 0.7)
    SetBlipAsShortRange(MakelaarBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Makelaars kantoor")
    EndTextCommandSetBlipName(MakelaarBlip)

    while true do
        Citizen.Wait(1)
        local letsleep = true
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

		if GetDistanceBetweenCoords(pos, -1911.98, -571.05, 19.84, true) < 3 then
            letsleep = false
            QBCore.Functions.DrawText3D(-1911.98, -571.05, 19.14, "~g~E~w~ - Gebruik computer")
            if IsControlJustPressed(0, 38) then
                SendNUIMessage({
                    type = "open"
                })
                SetNuiFocus(true, true)
                inComputer = true
            end
        end

        local liftBeneden = GetDistanceBetweenCoords(pos, -1898.4761, -572.4806, 11.8469)
        local liftBoven = GetDistanceBetweenCoords(pos, -1902.0549, -572.4638, 19.0972)

        if liftBeneden < 1 then
            letsleep = false
            QBCore.Functions.DrawText3D(-1898.4761, -572.4806, 11.8469 - 0.10, '~g~E~w~ - Lift naar boven')
            if IsControlJustPressed(0, 38) then
                SetEntityCoords(ped, -1902.0549, -572.4638, 19.0972)
            end
        elseif liftBoven < 1 then
            letsleep = false
            QBCore.Functions.DrawText3D(-1902.0549, -572.4638, 19.0972 - 0.10, '~g~E~w~ - Lift naar beneden')
            if IsControlJustPressed(0, 38) then
                SetEntityCoords(ped, -1898.4761, -572.4806, 11.8469)
            end
        end

        if letsleep then
            Citizen.Wait(1000)
        end
    end
end)

RegisterNUICallback("sluiten", function(data, cb)
    SetNuiFocus(false, false)
    inComputer = false
end)