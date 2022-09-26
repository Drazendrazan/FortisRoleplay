QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)


local gestart = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local ped = GetPlayerPed(-1)
        local pedPositie = GetEntityCoords(ped)

        letsleep = true

        if GetDistanceBetweenCoords(pedPositie, 1136.08, -988.23, 46.11, true) < 4 then
            letsleep = false
            DrawMarker(2, 1136.08, -988.23, 46.11, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
            if not gestart then
                if GetDistanceBetweenCoords(pedPositie, 1136.08, -988.23, 46.11, true) < 1 then
                    QBCore.Functions.DrawText3D(1136.08, -988.23, 46.11 - 0.10, "~g~E~w~ - Witwassen")

                    if IsControlJustPressed(0, 38) then
                        QBCore.Functions.TriggerCallback("fortis-witwas:server:checkAantal", function(aantal)
                            local aantal = aantal

                            if aantal >= 1000 then
                                gestart = true
                                local tijdsDuur = (aantal * 0.1) * 20

                                TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
                                TriggerServerEvent("fortis-witwas:server:verwijderViesgeld", aantal)

                                QBCore.Functions.Progressbar("witwassen", "Geld schoonmaken...", tijdsDuur, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function() -- Done
                                    local witgeld = aantal
                                    TriggerServerEvent("fortis-witwas:server:geefWitgeld", witgeld)
                                    QBCore.Functions.Notify("Je hebt je viesgeld schoongemaakt!", "success")
                                    gestart = false
                                end, function() -- Cancel
                                    TriggerServerEvent("fortis-witwas:server:cancelWassen", aantal)
                                    ClearPedTasks(GetPlayerPed(-1))
                                    QBCore.Functions.Notify("Geannuleerd...", "error")
                                    gestart = false
                                end)
                            else
                                QBCore.Functions.Notify("Je hebt niet genoeg vies geld bij je, je moet minimaal €1000 vies geld hebben", "error")
                            end
                        end)
                    end
                end
            else
                TriggerEvent("fortis-afkkick:client:resetTimer")
            end
        end

        if letsleep then
            Wait(1000)
        end
    end
end)


RegisterNetEvent("fortis-witwas:client:gepaktZemmel")
AddEventHandler("fortis-witwas:client:gepaktZemmel", function()
    -- Run wanneer de zemmel gecatched wordt :)
    TriggerServerEvent("fortis-witwas:server:kauloHacker", "#ccc")
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end