-- Markers op E drukken
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local pedCoords = GetEntityCoords(GetPlayerPed(-1))
        local letsleep = true
        -- Garages
        for k, v in pairs(VliegtuigHangars) do
            -- Take plane
            if GetDistanceBetweenCoords(pedCoords, VliegtuigHangars[k].takePlane.x, VliegtuigHangars[k].takePlane.y, VliegtuigHangars[k].takePlane.z, true) < 25 then
                letsleep = false
                DrawMarker(2, VliegtuigHangars[k].takePlane.x, VliegtuigHangars[k].takePlane.y, VliegtuigHangars[k].takePlane.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 28, 202, 155, 222, false, false, false, true, false, false, false)

                if GetDistanceBetweenCoords(pedCoords, VliegtuigHangars[k].takePlane.x, VliegtuigHangars[k].takePlane.y, VliegtuigHangars[k].takePlane.z, true) < 2 then
                    DrawText3Ds(VliegtuigHangars[k].takePlane.x, VliegtuigHangars[k].takePlane.y, VliegtuigHangars[k].takePlane.z + 0.5, "~g~E~w~ - Hangar")
                    if IsControlJustPressed(0, 38) then
                        openHangar(k)
                    end
                end
            end

            -- Put plane
            if GetDistanceBetweenCoords(pedCoords, VliegtuigHangars[k].putPlane.x, VliegtuigHangars[k].putPlane.y, VliegtuigHangars[k].putPlane.z, true) < 25 and IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 15 or GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 16 then
                    letsleep = false
                    DrawMarker(25, VliegtuigHangars[k].putPlane.x, VliegtuigHangars[k].putPlane.y, VliegtuigHangars[k].putPlane.z - 0.98, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.5001, 28, 202, 155, 255, 0, 0, 0, 0)

                    if GetDistanceBetweenCoords(pedCoords, VliegtuigHangars[k].putPlane.x, VliegtuigHangars[k].putPlane.y, VliegtuigHangars[k].putPlane.z, true) < 5 then
                        DrawText3Ds(VliegtuigHangars[k].putPlane.x, VliegtuigHangars[k].putPlane.y, VliegtuigHangars[k].putPlane.z + 0.5, "~g~E~w~ - Parkeren")
                        if IsControlJustPressed(0, 38) then
                            local vliegtuig = GetVehiclePedIsIn(GetPlayerPed(-1))

                            local vliegtuigData = {}
                            vliegtuigData["plate"] = GetVehicleNumberPlateText(vliegtuig)
                            vliegtuigData["fuel"] = exports["LegacyFuel"]:GetFuel(vliegtuig)
                            vliegtuigData["hangar"] = k

                            TriggerServerEvent("qb-garages:server:putVliegtuig", vliegtuigData, 1)

                            local props = QBCore.Functions.GetVehicleProperties(vliegtuig)
                            if props == nil then props = 0 end
                            TriggerServerEvent("qb-garage:server:updateVliegtuigTuning", vliegtuigData, props)

                            DeleteVehicle(vliegtuig)
                            QBCore.Functions.Notify("Je hebt het vliegtuig geparkeerd in de hangar!", "success")
                        end
                    end
                end
            end
        end

        -- Depot
        if GetDistanceBetweenCoords(pedCoords, VliegtuigDepot["stad"].takePlane.x, VliegtuigDepot["stad"].takePlane.y, VliegtuigDepot["stad"].takePlane.z, true) < 25 then
            letsleep = false
            DrawMarker(2, VliegtuigDepot["stad"].takePlane.x, VliegtuigDepot["stad"].takePlane.y, VliegtuigDepot["stad"].takePlane.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 28, 202, 155, 222, false, false, false, true, false, false, false)
            if GetDistanceBetweenCoords(pedCoords, VliegtuigDepot["stad"].takePlane.x, VliegtuigDepot["stad"].takePlane.y, VliegtuigDepot["stad"].takePlane.z, true) < 2 then
                DrawText3Ds(VliegtuigDepot["stad"].takePlane.x, VliegtuigDepot["stad"].takePlane.y, VliegtuigDepot["stad"].takePlane.z + 0.5, "~g~E~w~ - Depot")
                if IsControlJustPressed(0, 38) then
                    openDepot()
                end
                Menu.renderGUI()
            else
                closeMenuFull()
            end
        end


        -- Tankstation
        for k, v in pairs(VliegtuigTanken) do
            if GetDistanceBetweenCoords(pedCoords, VliegtuigTanken[k].coords.x, VliegtuigTanken[k].coords.y, VliegtuigTanken[k].coords.z, true) < 50 and IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 15 or GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 16 then
                    letsleep = false
                    DrawMarker(25, VliegtuigTanken[k].coords.x, VliegtuigTanken[k].coords.y, VliegtuigTanken[k].coords.z - 0.98, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.5001, 28, 202, 155, 255, 0, 0, 0, 0)
                    if GetDistanceBetweenCoords(pedCoords, VliegtuigTanken[k].coords.x, VliegtuigTanken[k].coords.y, VliegtuigTanken[k].coords.z, true) < 5 then
                        DrawText3Ds(VliegtuigTanken[k].coords.x, VliegtuigTanken[k].coords.y, VliegtuigTanken[k].coords.z + 0.5, "~g~E~w~ - Kerosine bijvullen")
                        if IsControlJustPressed(0, 38) then
                            local tmp_benzine = math.floor(exports["LegacyFuel"]:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1))))
                            if tmp_benzine < 99 then
                                QBCore.Functions.TriggerCallback("qb-garages:server:tankVliegtuig", function(magTanken, bedrag)
                                    if magTanken then
                                        -- Geld afgeschreven, kerosine bijvullen...
                                        SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)), false, true, true)
                                        local tijd = 100 - tmp_benzine
                                        local tijd = tijd * 500

                                        QBCore.Functions.Progressbar("kerosinebalk", "Kerosine bijvullen...", tijd, false, false, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {}, {}, {}, function() -- Done
                                            SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)), true, true, false)
                                            exports["LegacyFuel"]:SetFuel(GetVehiclePedIsIn(GetPlayerPed(-1)), 100)
                                            QBCore.Functions.Notify("Je hebt je vliegtuig bijgevuld met kerosine, dit kostte je: €"..bedrag, "success")
                                        end)
                                    else
                                        -- Niet genoeg geld!
                                        QBCore.Functions.Notify("Je hebt niet genoeg geld op je bank om je vliegtuig bij te vullen! Kosten: ("..berag..")", "error")
                                    end
                                end, tmp_benzine)
                            else
                                QBCore.Functions.Notify("Je vliegtuig zit al vol met kerosine!", "error")
                            end
                        end
                    end
                end
            end
        end

        -- Slapen papa
        if letsleep then
            Wait(1000)
        end
    end
end)

-- Hangar
function openHangar(hangar)
    local vliegtuigMenu = {
        {
            header = "✈️ - Mijn vlietuigen",
            isMenuHeader = true
        } 
    }
    QBCore.Functions.TriggerCallback("qb-garages:server:getVliegtuigen", function(result)
        local shouldContinue = false
        if result == nil then
            QBCore.Functions.Notify("Hier heb je geen vliegtuigen staan!", "error", 5000)
        else
            shouldContinue = true
            for _ , v in pairs(result) do
                local currentFuel = v.fuel

                vliegtuigMenu[#vliegtuigMenu+1] = {
                    header = v.plane.." ",
                    txt = "Brandstof: "..currentFuel.. "%",
                    params = {
                        event = "fortis-garages:client:TakeOutvliegtuig",
                        args = {
                            vehicle = v,
                        }
                    }
                }
            end
        end


        if shouldContinue then
            vliegtuigMenu[#vliegtuigMenu+1] = {
                header = "⬅ Sluit Menu",
                txt = "",
                params = {
                    event = "fortis-menu:client:closeMenu"
                }

            }
            exports['fortis-menu']:openMenu(vliegtuigMenu)
        end
    end, hangar)
end

RegisterNetEvent("fortis-garages:client:TakeOutvliegtuig", function(vliegtuig)
    local vehicle = vliegtuig.vehicle
    haalUitGarage(vehicle)
end)

RegisterNetEvent("fortis-garages:client:TakeOutDepotvliegtuig", function(vliegtuig)
    local vehicle = vliegtuig.vehicle
    haalUitDepot(vehicle)
end)

-- Depot
function openDepot()
    local vliegtuigDepotMenu = {
        {
            header = "✈️ - Mijn depot vlietuigen",
            isMenuHeader = true
        } 
    }
    QBCore.Functions.TriggerCallback("qb-garages:server:getVliegtuigen", function(result)
        local shouldContinue = false
        if result == nil then
            QBCore.Functions.Notify("Hier heb je geen vliegtuigen staan!", "error", 5000)
        else
            shouldContinue = true
            for _ , v in pairs(result) do
                local currentFuel = v.fuel

                vliegtuigDepotMenu[#vliegtuigDepotMenu+1] = {
                    header = v.plane.." ",
                    txt = "Brandstof: "..currentFuel.. "%",
                    params = { 
                        event = "fortis-garages:client:TakeOutDepotvliegtuig",
                        args = {
                            vehicle = v,
                        }
                    }
                }
            end
        end


        if shouldContinue then
            vliegtuigDepotMenu[#vliegtuigDepotMenu+1] = {
                header = "⬅ Sluit Menu",
                txt = "",
                params = {
                    event = "fortis-menu:client:closeMenu"
                }

            }
            exports['fortis-menu']:openMenu(vliegtuigDepotMenu)
        end
    end, "depot")
end

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

-- Voertuig uit garage halen
function haalUitGarage(vliegtuig)
    if vliegtuig.state == 1 then
        QBCore.Functions.SpawnVehicle(vliegtuig.plane, function(veh)
            SetVehRadioStation(veh, "OFF")
		    SetVehicleFixed(veh)
		    SetVehicleDeformationFixed(veh)
		    SetVehicleUndriveable(veh, false)
		    SetVehicleEngineOn(veh, true, true)
		    SetEntityAsMissionEntity(veh, true, false)

            SetVehicleNumberPlateText(veh, vliegtuig.plate)
            SetEntityHeading(veh, VliegtuigHangars[vliegtuig.hangar].spawnPoint.h)
            exports["LegacyFuel"]:SetFuel(veh, vliegtuig.fuel)
            SetEntityAsMissionEntity(veh, true, true)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            -- Sluit het menu compleet
            closeMenuFull()
            TriggerServerEvent("qb-garages:server:setVliegtuigState", vliegtuig, 0)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            
            QBCore.Functions.TriggerCallback("fortis-garages:server:haalVliegtuigTuningsOp", function(properties)
                QBCore.Functions.SetVehicleProperties(veh, properties)
            end, vliegtuig.plate)
        end, VliegtuigHangars[vliegtuig.hangar].spawnPoint, true)
    else
        QBCore.Functions.Notify("Dit vliegtuig staat niet in de hangar, ga naar het depot!", "error")
    end
end


-- Voertuig uit depot halen
function haalUitDepot(vliegtuig)
    if vliegtuig.state == 0 then
        QBCore.Functions.TriggerCallback("qb-garages:server:checkVliegtuigBestaan", function(resultaat)
            if resultaat then
                -- Mag vliegtuig pakken, bestaat nog niet op het eiland
                QBCore.Functions.SpawnVehicle(vliegtuig.plane, function(veh)
                    SetVehRadioStation(veh, "OFF")
                    SetVehicleFixed(veh)
                    SetVehicleDeformationFixed(veh)
                    SetVehicleUndriveable(veh, false)
                    SetVehicleEngineOn(veh, true, true)
                    SetEntityAsMissionEntity(veh, true, false)
        
                    SetVehicleNumberPlateText(veh, vliegtuig.plate)
                    SetEntityHeading(veh, VliegtuigDepot["stad"].spawnPoint.h)
                    exports["LegacyFuel"]:SetFuel(veh, vliegtuig.fuel)
                    SetEntityAsMissionEntity(veh, true, true)
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                    -- Sluit het menu compleet
                    closeMenuFull()
                    TriggerServerEvent("qb-garages:server:setVliegtuigState", vliegtuig, 0)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))

                    QBCore.Functions.TriggerCallback("fortis-garages:server:haalVliegtuigTuningsOp", function(properties)
                        QBCore.Functions.SetVehicleProperties(veh, properties)
                    end, vliegtuig.plate)
                end, VliegtuigDepot["stad"].spawnPoint, true)
            else
                -- Mag vliegtuig NIET pakken, bestaat al op het eiland!!!
                QBCore.Functions.Notify("Dit vliegtuig staat al ergens op het eiland!", "error")
                closeMenuFull()
            end
        end, vliegtuig)
    else
        QBCore.Functions.Notify("Dit vliegtuig staat niet in het depot!", "error")
    end
end


function geenKnop()
    QBCore.Functions.Notify("Dit is geen geldig voertuig... (Pijltje naar beneden)", "error", 3500)
end

-- Liften 
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local letsleep = true
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        for k,v in pairs(HelipadLift) do
            if GetDistanceBetweenCoords(pos, HelipadLift[k].coordsBeneden.x, HelipadLift[k].coordsBeneden.y, HelipadLift[k].coordsBeneden.z, true) or GetDistanceBetweenCoords(pos, HelipadLift[k].coordsBoven.x, HelipadLift[k].coordsBoven.y, HelipadLift[k].coordsBoven.z)< 50 then
                local liftBeneden = GetDistanceBetweenCoords(pos, HelipadLift[k].coordsBeneden.x, HelipadLift[k].coordsBeneden.y, HelipadLift[k].coordsBeneden.z)
                local liftBoven = GetDistanceBetweenCoords(pos, HelipadLift[k].coordsBoven.x, HelipadLift[k].coordsBoven.y, HelipadLift[k].coordsBoven.z)
                
                if liftBeneden < 1 then
                    letsleep = false
                    DrawMarker(2, HelipadLift[k].coordsBeneden.x, HelipadLift[k].coordsBeneden.y, HelipadLift[k].coordsBeneden.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 28, 202, 155, 222, false, false, false, true, false, false, false)
                    QBCore.Functions.DrawText3D(HelipadLift[k].coordsBeneden.x, HelipadLift[k].coordsBeneden.y, HelipadLift[k].coordsBeneden.z + 0.20, '~g~E~w~ - Lift')
                    if IsControlJustPressed(0, 38) then
                        DoScreenFadeOut(500)
                        Wait(4000)
                        DoScreenFadeIn(2000)
                        SetEntityCoords(ped, HelipadLift[k].coordsBoven.x, HelipadLift[k].coordsBoven.y, HelipadLift[k].coordsBoven.z)
                    end
                
                elseif liftBoven < 1 then
                    letsleep = false
                    DrawMarker(2, HelipadLift[k].coordsBoven.x, HelipadLift[k].coordsBoven.y, HelipadLift[k].coordsBoven.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 28, 202, 155, 222, false, false, false, true, false, false, false)
                    QBCore.Functions.DrawText3D(HelipadLift[k].coordsBoven.x, HelipadLift[k].coordsBoven.y, HelipadLift[k].coordsBoven.z + 0.20, '~g~E~w~ - Lift')
                    if IsControlJustPressed(0, 38) then
                        DoScreenFadeOut(500)
                        Wait(4000)
                        DoScreenFadeIn(2000)
                        SetEntityCoords(ped, HelipadLift[k].coordsBeneden.x, HelipadLift[k].coordsBeneden.y, HelipadLift[k].coordsBeneden.z)
                    end
                end 
            end
        end

        if letsleep then
            Citizen.Wait(1000)
        end
    end
end)