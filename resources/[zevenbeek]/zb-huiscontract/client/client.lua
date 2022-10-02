QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

closestPlayer, closestPlayerDistance = nil
verkoper = false

RegisterNetEvent("zb-huiscontract:client:useItem")
AddEventHandler("zb-huiscontract:client:useItem", function()
    verkoper = false
    if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
        -- Begin
        local huis = exports['zb-houses']:closestHuis()
        closestPlayer, closestPlayerDistance = QBCore.Functions.GetClosestPlayer()
    
        local ped = GetPlayerPed(-1)
        local pedCoords = GetEntityCoords(ped)
    
        local vehicleCoords = GetEntityCoords(vehicle)
        local kenteken = GetVehicleNumberPlateText(vehicle)
    
        if closestPlayer ~= -1 and closestPlayer ~= nil ~= 0 then
            QBCore.Functions.TriggerCallback("zb-huiscontract:server:checkHuisOwner", function(owner)
                if owner then
                    SendNUIMessage({
                        type = "openVerkoper",
                        kenteken = huis,
                    })
                    SetNuiFocus(true, true)
                    verkoper = true
                    ExecuteCommand("e clipboard")
                else
                    QBCore.Functions.Notify("Dit huis is niet van jou!", "error")
                end
            end, huis)
        else
            QBCore.Functions.Notify("Er is geen persoon in de buurt!", "error")
        end
        -- Eind
    else
        QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
    end
end)
 

-- Als de verkoper het contract heeft ingevuld
RegisterNUICallback("plaatsContract", function(data)
    local bedrag = data.bedrag
    local huis = data.kenteken
    local target = GetPlayerServerId(closestPlayer)

    if verkoper then
        SetNuiFocus(false, false)
        ExecuteCommand("e c")    
        TriggerServerEvent("zb-huiscontract:server:geefContract", target, bedrag, huis)    
    else
        SetNuiFocus(false, false)
        ExecuteCommand("e c")
        TriggerServerEvent("zb-huiscontract:server:koopHuis", bedrag, huis)
    end
end)


--Annuleren
RegisterNUICallback("annuleer", function(data)
    ExecuteCommand("e c")
    SetNuiFocus(false, false)
    QBCore.Functions.Notify("Je hebt het voertuig contract gesloten, en dus geannuleerd.", "error")
end)

RegisterNetEvent("zb-huiscontract:client:krijgContract")
AddEventHandler("zb-huiscontract:client:krijgContract", function(bedrag, huis)
    verkoper = false
    SendNUIMessage({
        type = "openKopen",
        bedrag = bedrag,
        kenteken = huis
    })
    SetNuiFocus(true, true)
    ExecuteCommand("e clipboard")
end)

-- Koop cirkel dinges

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        
        local ped = GetPlayerPed(-1)
        local pedPos = GetEntityCoords(ped)

        letsleep = true
        if GetDistanceBetweenCoords(pedPos, -1910.78, -570.30, 19.09) < 20 then
            letsleep = false
            DrawMarker(2, -1910.78, -570.30, 19.09, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
            if GetDistanceBetweenCoords(pedPos, -1910.78, -570.30, 19.09, true) < 2 then
                QBCore.Functions.DrawText3D(-1910.78, -570.30, 19.09 - 0.10, "~g~[G]~w~ Huis overschrijf contract kopen [€5000]")
                if IsControlJustPressed(0, 47) then
                    TriggerServerEvent("zb-huiscontract:server:koopcontract")
                end
            end
        end
 
        if letsleep then
            Wait(1000)
        end

    end
end)