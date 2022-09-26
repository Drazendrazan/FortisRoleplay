QBCore = nil
Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(1)
	end
end)

gang = false
bezig = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback("fortis-gangs:server:vraagGang", function(status, naam)
        if status then
            gang = naam
        end
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    Wait(1500)
    QBCore.Functions.TriggerCallback("fortis-gangs:server:vraagGang", function(status, naam)
        if status then
            gang = naam
        end
    end)
end)

Citizen.CreateThread(function()
    -- Blips
    -- local ElGarajeGuiliano = AddBlipForCoord(-33.02, -1395.02, 33.84)
    -- SetBlipSprite(ElGarajeGuiliano, 50)
    -- SetBlipColour(ElGarajeGuiliano, 28)
    -- SetBlipScale(ElGarajeGuiliano, 0.7)
    -- SetBlipAsShortRange(ElGarajeGuiliano, true)
    -- BeginTextCommandSetBlipName("STRING")
    -- AddTextComponentString("El Garaje Guiliano")
    -- EndTextCommandSetBlipName(ElGarajeGuiliano)

    -- local DeBaron= AddBlipForCoord(743.52, -813.42, 35.69)
    -- SetBlipSprite(DeBaron, 439)
    -- SetBlipColour(DeBaron, 1)
    -- SetBlipScale(DeBaron, 0.7)
    -- SetBlipAsShortRange(DeBaron, true)
    -- BeginTextCommandSetBlipName("STRING")
    -- AddTextComponentString("De Baron")
    -- EndTextCommandSetBlipName(DeBaron)

    -- local SONSBlip = AddBlipForCoord(908.67, 3579.61, 37.58)
    -- SetBlipSprite(SONSBlip, 429)
    -- SetBlipColour(SONSBlip, 0)
    -- SetBlipScale(SONSBlip, 0.6)
    -- SetBlipAsShortRange(SONSBlip, true)
    -- BeginTextCommandSetBlipName("STRING")
    -- AddTextComponentString("Motorclub SONS of Anarchy")
    -- EndTextCommandSetBlipName(SONSBlip)
    Wait(2000)
    local BratvaBlip = AddBlipForCoord(185.35, -1272.69, 29.19)
    SetBlipSprite(BratvaBlip, 311)
    SetBlipColour(BratvaBlip, 45)
    SetBlipScale(BratvaBlip, 0.6)
    SetBlipAsShortRange(BratvaBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Boytsovskiy klub")
    EndTextCommandSetBlipName(BratvaBlip)
    Wait(2000)
    -- local GebrWBlip = AddBlipForCoord(-42.94, -1101.17, 26.42)
    -- SetBlipSprite(GebrWBlip, 524)
    -- SetBlipColour(GebrWBlip, 47)
    -- SetBlipScale(GebrWBlip, 0.6)
    -- SetBlipAsShortRange(GebrWBlip, true)
    -- BeginTextCommandSetBlipName("STRING")
    -- AddTextComponentString("Gebr. W voertuighandel")
    -- EndTextCommandSetBlipName(GebrWBlip)
    -- Wait(2000)
    -- local DiamondCasinoBlip = AddBlipForCoord(-1830.38, -1190.30, 28.82)
    -- SetBlipSprite(DiamondCasinoBlip, 679)
    -- SetBlipColour(DiamondCasinoBlip, 26)
    -- SetBlipScale(DiamondCasinoBlip, 0.6)
    -- SetBlipAsShortRange(DiamondCasinoBlip, true)
    -- BeginTextCommandSetBlipName("STRING")
    -- AddTextComponentString("Diamond Casino")
    -- EndTextCommandSetBlipName(DiamondCasinoBlip)
     
    while true do
        Citizen.Wait(1)
        letsleep = true
        
        if gang ~= false then
            local ped = GetPlayerPed(-1)
            local pedPos = GetEntityCoords(ped)

            -- Stash
            if GetDistanceBetweenCoords(pedPos, Config.gangs[gang].stash.x, Config.gangs[gang].stash.y, Config.gangs[gang].stash.z, true) < 5 then
                letsleep = false
                DrawMarker(2, Config.gangs[gang].stash.x, Config.gangs[gang].stash.y, Config.gangs[gang].stash.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                if GetDistanceBetweenCoords(pedPos, Config.gangs[gang].stash.x, Config.gangs[gang].stash.y, Config.gangs[gang].stash.z, true) < 1 then
                    QBCore.Functions.DrawText3D(Config.gangs[gang].stash.x, Config.gangs[gang].stash.y, Config.gangs[gang].stash.z - 0.10, "~g~[E]~w~ Stash openen")
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("inventory:server:OpenInventory", "stash", gang)
                        TriggerEvent("inventory:client:SetCurrentStash", gang)
                    end
                end
            end

            -- Outfits
            if GetDistanceBetweenCoords(pedPos, Config.gangs[gang].kleding.x, Config.gangs[gang].kleding.y, Config.gangs[gang].kleding.z, true) < 5 then
                letsleep = false
                DrawMarker(2, Config.gangs[gang].kleding.x, Config.gangs[gang].kleding.y, Config.gangs[gang].kleding.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                if GetDistanceBetweenCoords(pedPos, Config.gangs[gang].kleding.x, Config.gangs[gang].kleding.y, Config.gangs[gang].kleding.z, true) < 1 then
                    QBCore.Functions.DrawText3D(Config.gangs[gang].kleding.x, Config.gangs[gang].kleding.y, Config.gangs[gang].kleding.z - 0.10, "~g~[E]~w~ Kledingkast openen")
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('qb-clothing:client:openOutfitMenu')
                    end
                end
            end

            -- Guiliano repareer dinges
            -- if gang == "guiliano" then
            --     if GetDistanceBetweenCoords(pedPos, Config.gangs[gang].repareer.x, Config.gangs[gang].repareer.y, Config.gangs[gang].repareer.z) < 8 then
            --         letsleep = false
            --         DrawMarker(25, Config.gangs[gang].repareer.x, Config.gangs[gang].repareer.y, Config.gangs[gang].repareer.z - 0.98, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5001, 255, 0, 0,100, 0, 0, 0,0)
            --         if GetDistanceBetweenCoords(pedPos, Config.gangs[gang].repareer.x, Config.gangs[gang].repareer.y, Config.gangs[gang].repareer.z) < 2 then
            --             QBCore.Functions.DrawText3D(Config.gangs[gang].repareer.x, Config.gangs[gang].repareer.y, Config.gangs[gang].repareer.z - 0.10, "~g~[K]~w~ Auto repareren [€300]")
            --             if IsControlJustPressed(0, 311) then
            --                 if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            --                     if not bezig then
            --                         QBCore.Functions.TriggerCallback("fortis-gangs:server:checkGeld", function(resultaat)
            --                             if resultaat then
            --                                 bezig = true


            --                                 SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1)), 4)
            --                                 QBCore.Functions.Progressbar("repareerwaggie", "Auto repareren...", 8000, false, false, {
            --                                     disableMovement = true,
            --                                     disableCarMovement = true,
            --                                     disableMouse = false,
            --                                     disableCombat = true,
            --                                 }, {}, {}, {}, function() -- Done
            --                                     SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1)))
            --                                     SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1)), 4)
            --                                     bezig = false
            --                                     QBCore.Functions.Notify("Je hebt het voertuig gerepareerd!", "success")
            --                                 end)


            --                             else
            --                                 QBCore.Functions.Notify("Je hebt niet genoeg geld om dit voertuig te repareren!", "error")
            --                             end
            --                         end)
            --                     else
            --                         QBCore.Functions.Notify("Je bent al bezig met repareren.", "error")
            --                     end
            --                 else
            --                     QBCore.Functions.Notify("Je zit niet in een voertuig!", "error")
            --                 end
            --             end
            --         end
            --     end

            --     if GetDistanceBetweenCoords(pedPos, Config.gangs[gang].kleding2.x, Config.gangs[gang].kleding2.y, Config.gangs[gang].kleding2.z, true) < 5 then
            --         letsleep = false
            --         DrawMarker(2, Config.gangs[gang].kleding2.x, Config.gangs[gang].kleding2.y, Config.gangs[gang].kleding2.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
            --         if GetDistanceBetweenCoords(pedPos, Config.gangs[gang].kleding2.x, Config.gangs[gang].kleding2.y, Config.gangs[gang].kleding2.z, true) < 1 then
            --             QBCore.Functions.DrawText3D(Config.gangs[gang].kleding2.x, Config.gangs[gang].kleding2.y, Config.gangs[gang].kleding2.z - 0.10, "~g~[E]~w~ Kledingkast openen")
            --             if IsControlJustPressed(0, 38) then
            --                 TriggerEvent('qb-clothing:client:openOutfitMenu')
            --             end
            --         end
            --     end
            -- end

        end

        if letsleep then
            Citizen.Wait(1500)
        end
    end
end)