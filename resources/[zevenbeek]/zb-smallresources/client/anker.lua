local ankerStatus = false

Citizen.CreateThread(function()
    while true do
        Wait(1)
        local ped = GetPlayerPed(-1)
        local pedCoords = GetEntityCoords(GetPlayerPed(-1))

        letsleep = false

        if IsControlJustPressed(1, 81) then
            if not IsPedInAnyVehicle(ped) then
                local voertuig = QBCore.Functions.GetClosestVehicle(pedCoords)

                if GetDistanceBetweenCoords(pedCoords, GetEntityCoords(voertuig)) < 6 then
                    if GetVehicleClass(voertuig) == 14 then
                        letsleep = true
                        if ankerStatus == false then
                            SetBoatAnchor(voertuig, true)

                            TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                            QBCore.Functions.Progressbar("anker", "Anker uitgooien...", 8000, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, function() -- Actie netjes afgemaakt
                                QBCore.Functions.Notify("Je hebt het anker uitgegooid!", "success")
                                ankerStatus = true
                            end)

                            ClearPedTasks(ped)

                        else
                            SetBoatAnchor(voertuig, true)
                            ankerStatus = false

                            TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                            QBCore.Functions.Progressbar("anker", "Anker ophalen...", 8000, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, function() -- Actie netjes afgemaakt
                                QBCore.Functions.Notify("Je hebt het anker opgehaald!", "success")
                            end)

                            ClearPedTasks(ped)

                        end
                    end
                end
            end
        end

        if letsleep then
            Wait(1000)
        end
    end
end)