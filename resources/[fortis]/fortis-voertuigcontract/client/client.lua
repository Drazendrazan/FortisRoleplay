QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

closestPlayer, closestPlayerDistance = nil
verkoper = false

RegisterNetEvent("fortis-voertuigcontract:client:useItem")
AddEventHandler("fortis-voertuigcontract:client:useItem", function()
    verkoper = false
    if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
        -- Begin
        local vehicle = QBCore.Functions.GetClosestVehicle()
        closestPlayer, closestPlayerDistance = QBCore.Functions.GetClosestPlayer()
    
        local ped = GetPlayerPed(-1)
        local pedCoords = GetEntityCoords(ped)
    
        local vehicleCoords = GetEntityCoords(vehicle)
        local kenteken = GetVehicleNumberPlateText(vehicle)
    
        if GetDistanceBetweenCoords(pedCoords, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z) < 5 then
            if closestPlayer ~= -1 and closestPlayer ~= nil ~= 0 then
                if closestPlayerDistance < 5 then
                    if GetVehicleClass(vehicle) == 14 then
                        boot = true
                    else
                        boot = false
                    end
                    if GetVehicleClass(vehicle) ~= 15 and GetVehicleClass(vehicle) ~= 16 then
                        QBCore.Functions.TriggerCallback("fortis-voertuigcontract:server:checkVoertuigOwner", function(owner)
                            print(owner)
                            if owner then

                                SendNUIMessage({
                                    type = "openVerkoper",
                                    kenteken = kenteken,
                                }) 
                                SetNuiFocus(true, true)
                                verkoper = true
                                ExecuteCommand("e clipboard")

                            else
                                QBCore.Functions.Notify("Dit voertuig is niet van jou!", "error")
                            end
                        end, kenteken, boot)
                    else
                        QBCore.Functions.TriggerCallback("fortis-voertuigcontract:server:checkVliegtuigOwner", function(owner)
                            if owner then
                            
                                SendNUIMessage({
                                    type = "openVerkoper",
                                    kenteken = kenteken,
                                }) 
                                SetNuiFocus(true, true)
                                verkoper = true
                                ExecuteCommand("e clipboard")
                            
                            else
                                QBCore.Functions.Notify("Dit voertuig is niet van jou!", "error")
                            end
                        end, kenteken)
                    end
                else
                    QBCore.Functions.Notify("Er is geen persoon in de buurt!", "error")
                end
            else
                QBCore.Functions.Notify("Er is geen persoon in de buurt!", "error")
            end

        else
            QBCore.Functions.Notify("Je staat niet bij een voertuig!", "error")
        end
        -- Eind
    else
        QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
    end
end)
  

-- Als de verkoper het contract heeft ingevuld
RegisterNUICallback("plaatsContract", function(data)
    local bedrag = data.bedrag
    local kenteken = data.kenteken
    local target = GetPlayerServerId(closestPlayer)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    if verkoper then
        SetNuiFocus(false, false)
        ExecuteCommand("e c")    
        TriggerServerEvent("fortis-voertuigcontract:server:geefContract", target, bedrag, kenteken)    
    else
        SetNuiFocus(false, false)
        ExecuteCommand("e c")
        if GetVehicleClass(vehicle) ~= 14 and GetVehicleClass(vehicle) ~= 15 and GetVehicleClass(vehicle) ~= 16 then
            local boot = false
            TriggerServerEvent("fortis-voertuigcontract:server:koopVoertuig", bedrag, kenteken, boot)
        elseif GetVehicleClass(vehicle) ~= 15 and GetVehicleClass(vehicle) ~= 16 then
            local boot = true
            TriggerServerEvent("fortis-voertuigcontract:server:koopVoertuig", bedrag, kenteken, boot) 
        end
        if GetVehicleClass(vehicle) == 15 then
            local vliegmachine = false
            TriggerServerEvent("fortis-voertuigcontract:server:koopVliegmachine", bedrag, kenteken, vliegmachine) 
        elseif GetVehicleClass(vehicle) == 16 then
            local vliegmachine = true
            TriggerServerEvent("fortis-voertuigcontract:server:koopVliegmachine", bedrag, kenteken, vliegmachine) 
        end
    end
end)


--Annuleren
RegisterNUICallback("annuleer", function(data)
    ExecuteCommand("e c")
    SetNuiFocus(false, false)
    QBCore.Functions.Notify("Je hebt het voertuig contract gesloten, en dus geannuleerd.", "error")
end)

RegisterNetEvent("fortis-voertuigcontract:client:krijgContract")
AddEventHandler("fortis-voertuigcontract:client:krijgContract", function(bedrag, kenteken)
    verkoper = false
    SendNUIMessage({
        type = "openKopen",
        bedrag = bedrag,
        kenteken = kenteken
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

        if GetDistanceBetweenCoords(pedPos, -807.33, -205.96, 37.13) < 20 then
            letsleep = false
            DrawMarker(2, -807.33, -205.96, 37.13, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
            if GetDistanceBetweenCoords(pedPos, -807.33, -205.96, 37.13) < 2 then
                QBCore.Functions.DrawText3D(-807.33, -205.96, 37.13 - 0.10, "~g~[G]~w~ Voertuig overschrijf contract kopen [€5000]")
                if IsControlJustPressed(0, 47) then
                    TriggerServerEvent("fortis-voertuigcontract:server:koopcontract")
                end
            end
        end

        if letsleep then
            Wait(1000)
        end

    end
end)