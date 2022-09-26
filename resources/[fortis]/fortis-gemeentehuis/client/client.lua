QBCore = nil
Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(1)
    end
end)

inComputer = false
balieGoonSpawn = true

Citizen.CreateThread(function()
    local CityhallBlip = AddBlipForCoord(-553.71, -191.24, 37.27)
    SetBlipSprite(CityhallBlip, 487)
    SetBlipColour(CityhallBlip, 0)
    SetBlipScale(CityhallBlip, 0.7)
    SetBlipAsShortRange(CityhallBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Gemeentehuis")
    EndTextCommandSetBlipName(CityhallBlip)

    while true do
        Citizen.Wait(1)
        local letsleep = true

        local ped = GetPlayerPed(-1)
        local pedCoords = GetEntityCoords(ped)

        if balieGoonSpawn == true then
            local hash = GetHashKey('cs_molly')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            balieGoon = CreatePed(4, hash, -553.71, -191.24, 37.27, 209.25, false, true)

            FreezeEntityPosition(balieGoon, true)    
            SetEntityInvincible(balieGoon, true)
            SetBlockingOfNonTemporaryEvents(balieGoon, true)

            loadAnimDict("rcmnigel1cnmt_1c")
            TaskPlayAnim(balieGoon, "rcmnigel1cnmt_1c", "base", 8.0, -8, -1, 3, 0, 0, 0, 0)


            balieGoonSpawn = false
        end

        if GetDistanceBetweenCoords(pedCoords, -553.71, -191.24, 37.27, false) < 10 then
            letsleep = false
            DrawMarker(2, -553.51, -191.64, 37.67, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
			if GetDistanceBetweenCoords(pedCoords, -553.71, -191.24, 37.27, true) < 2.0 then
                QBCore.Functions.DrawText3D(-553.71, -191.24, 38.47, " ~g~E~w~ - Koop ID-kaart")
                QBCore.Functions.DrawText3D(-553.71, -191.24, 38.37, " ~g~G~w~ - Koop Rijbewijs")
                QBCore.Functions.DrawText3D(-553.71, -191.24, 38.27, " ~g~X~w~ - Koop Werkpas")
                if IsControlJustPressed(0, 47) then
                    TriggerEvent('qb-gemeentehuis:client:ID', "driver_license")
                end
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('qb-gemeentehuis:client:ID', "id_card")
                end
                if IsControlJustPressed(0, 73) then
                    TriggerEvent('qb-gemeentehuis:client:ID', "werkpas")
                end
            end
        end

        if letsleep then
            Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local letsleep = true

        local ped = GetPlayerPed(-1)
        local pedCoords = GetEntityCoords(ped)

        if GetDistanceBetweenCoords(pedCoords, -549.07, -190.90, 38.22, false) < 10 then
            letsleep = false
            DrawMarker(2, -549.00, -190.90, 38.22, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
			if GetDistanceBetweenCoords(pedCoords, -549.07, -190.90, 38.22, true) < 1.5 then
                QBCore.Functions.DrawText3D(-549.00, -190.90, 38.32, "~g~E~w~ - Gebruik laptop")
                if IsControlJustPressed(0, 38) then
                    SendNUIMessage({
                        type = "open"
                    })
                    SetNuiFocus(true, true)
                    inComputer = true
                end
            end
        end

        if letsleep then
            Wait(1000)
        end

    end
end)

RegisterNetEvent('qb-gemeentehuis:client:ID', function(data)
    TriggerServerEvent('qb-cityhall:server:requestId', data)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        if inComputer then
            TriggerEvent("fortis-afkkick:client:resetTimer")
        end
    end
end)

RegisterNUICallback("sluiten", function(data, cb)
    SetNuiFocus(false, false)
    inComputer = false
end)

RegisterNUICallback("krijgJob", function(data, cb)
    if inComputer then
        if data.baan ~= "police" and data.baan ~= "ambulance" and data.baan ~= "mechanic" then
            local baan = data.baan
            TriggerServerEvent("fortis-gemeentehuis:server:setJob", baan)
        else
            -- Chappie probeert overheids baan
            TriggerServerEvent("fortis-gemeentehuis:server:kauloHacker", "#aaa")
        end
    else
        -- Chappie zit niet eens in lappie
        TriggerServerEvent("fortis-gemeentehuis:server:kauloHacker", "#bbb")
    end
end)

RegisterNetEvent("fortis-gemeentehuis:client:gepaktZemmel")
AddEventHandler("fortis-gemeentehuis:client:gepaktZemmel", function()
    -- Run wanneer de zemmel gecatched wordt :)
    TriggerServerEvent("fortis-gemeentehuis:server:kauloHacker", "#ccc")
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end