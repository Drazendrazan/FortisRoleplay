QBCore = nil
Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(1)
	end
end)

local beveiliger = true
local bezig = false
local plekNummer = nil
local prijs = 0

-- Spawn NPC
Citizen.CreateThread(function()
    local blippie = AddBlipForCoord(52.22, -805.79, 31.53)
    SetBlipSprite(blippie, 120)
    SetBlipColour(blippie, 11)
    SetBlipScale(blippie, 0.5)
    SetBlipAsShortRange(blippie, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Shisha Lounge")
    EndTextCommandSetBlipName(blippie)

    while true do
        Citizen.Wait(1)
        if beveiliger == true then
            Citizen.Wait(500)
            local hash = GetHashKey('s_m_y_doorman_01')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end
    
            beveiligerNPC1 = CreatePed(4, hash, 56.51, -800.13, 31.58 - 1.00, 341.90, false, true)
            beveiligerNPC2 = CreatePed(4, hash, 53.16, -798.90, 31.59 - 1.00, 341.90, false, true)
    
            FreezeEntityPosition(beveiligerNPC1, true)    
            SetEntityInvincible(beveiligerNPC1, true)
            SetBlockingOfNonTemporaryEvents(beveiligerNPC1, true)

            FreezeEntityPosition(beveiligerNPC2, true)    
            SetEntityInvincible(beveiligerNPC2, true)
            SetBlockingOfNonTemporaryEvents(beveiligerNPC2, true)
    
            loadAnimDict("amb@world_human_stand_guard@male@base")
            TaskPlayAnim(beveiligerNPC1, "amb@world_human_stand_guard@male@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
            TaskPlayAnim(beveiligerNPC2, "amb@world_human_stand_guard@male@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
    
    
            beveiliger = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local pedPos = GetEntityCoords(GetPlayerPed(-1))

        local letsleep = true

        for k, v in pairs(Config.loungeLocaties) do
            if GetDistanceBetweenCoords(pedPos, Config.loungeLocaties[k].x, Config.loungeLocaties[k].y, Config.loungeLocaties[k].z) < 10 and not bezig then
                letsleep = false
                DrawMarker(2, Config.loungeLocaties[k].x, Config.loungeLocaties[k].y, Config.loungeLocaties[k].z + 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                if GetDistanceBetweenCoords(pedPos, Config.loungeLocaties[k].x, Config.loungeLocaties[k].y, Config.loungeLocaties[k].z) < .6 then
                    QBCore.Functions.DrawText3D(Config.loungeLocaties[k].x, Config.loungeLocaties[k].y, Config.loungeLocaties[k].z + 0.8, "~g~[E]~w~ Zitten")
                    if IsControlJustPressed(0, 38) then
                        QBCore.Functions.TriggerCallback("zb-shisha:server:reserveerPlek", function(status)
                            if not status then
                                bezig = true
                                SetEntityCoords(GetPlayerPed(-1), Config.loungeLocaties[k].x, Config.loungeLocaties[k].y, Config.loungeLocaties[k].z)
                                SetEntityHeading(GetPlayerPed(-1), Config.loungeLocaties[k].h)
                                ExecuteCommand("e sitchair")
                                loadAnimDict("anim@heists@humane_labs@finale@keycards")
                                TaskPlayAnim(GetPlayerPed(-1), "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)

                                bone = GetPedBoneIndex(PlayerPedId(), 18905)
                                handje = GetWorldPositionOfEntityBone(PlayerPedId(), bone)
                                slang = CreateObject(GetHashKey("v_corp_lngestoolfd"), pedPos.x, pedPos.y, pedPos.z, true, false, false)
                                AttachEntityToEntity(slang, GetPlayerPed(-1), bone, 0.49, -0.60, 0.10, -100.0, 0.0, -10.0, false, false, false, false, 0, 15)
                                
                                plekNummer = k
                            else
                                QBCore.Functions.Notify("Hier zit al iemand, zoek een ander plekje", "error")
                            end
                        end, k)
                    end
                end
            end
            -- if GetDistanceBetweenCoords(pedPos, Config.loungeLocaties[k].)
        end

        if letsleep then
            Wait(1000)
        end
    end
end)

-- Make some variables for the particle dictionary and particle name.
local dict = "core"
local particleName = "ent_anim_cig_exhale_nse_car"
local smoking = false

-- Create a new thread.
AddEventHandler("zb-shisha:client:smoke", function()
    -- Request the particle dictionary.
    RequestNamedPtfxAsset(dict)
    -- Wait for the particle dictionary to load.
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end
    
    -- Get the position of the player, this will be used as the
    -- starting position of the particle effects.
    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped, true))

    local a = 0
    ExecuteCommand("e eat")
    while a < 3 do
        smoking = true
        -- Tell the game that we want to use a specific dictionary for the next particle native.
        UseParticleFxAssetNextCall(dict)
        -- Create a new non-looped particle effect, we don't need to store the particle handle because it will
        -- automatically get destroyed once the particle has finished it's animation (it's non-looped).
        local pedCoords = GetOffsetFromEntityGivenWorldCoords(GetPlayerPed(-1), x, y, z)
        -- StartNetworkedParticleFxNonLoopedAtCoord(particleName, pedCoords.x + x + 0.15, pedCoords.y + y + 0.30, pedCoords.z + z + 0.7, -85.0, 0.0, 0.0, 3.5, 90, 0.3, 140)
        local lipcoords = GetPedBoneCoords(GetPlayerPed(-1), 0xAA10)
        StartNetworkedParticleFxNonLoopedAtCoord(particleName, lipcoords, -85.0, 0.0, 0.0, 3.5, 90, 0.3, 140)
    
        a = a + 1
        
        -- Wait 500ms before triggering the next particle.
        Citizen.Wait(500)
    end
    smoking = false
end)


Citizen.CreateThread(function() -- Persoon is bezig en kan stoppen
    while true do
        Citizen.Wait(1)

        local letsleep = true

        if bezig then
            letsleep = false

            if not smoking then
                if IsEntityPlayingAnim(GetPlayerPed(-1), 'anim@heists@humane_labs@finale@keycards', 'ped_a_enter_loop', 3) ~= 1 then
                    TaskPlayAnim(GetPlayerPed(-1), "anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
                end
            end
            local pedPos = GetEntityCoords(GetPlayerPed(-1))
            
            DisableControlAction(0, 73, true)
            DisableControlAction(0, 170, true)

            if GetDistanceBetweenCoords(pedPos, Config.loungeLocaties[plekNummer].x, Config.loungeLocaties[plekNummer].y, Config.loungeLocaties[plekNummer].z) > 3 then
                ClearPedTasks(GetPlayerPed(-1))
                SetEntityCoords(GetPlayerPed(-1), pedPos.x, pedPos.y, pedPos.z + 0.05)
                TriggerServerEvent("zb-shisha:server:maakPlekVrij", plekNummer)
                DetachEntity(slang, false, false)
                DeleteObject(slang)
                bezig = false
                plekNummer = nil
                QBCore.Functions.Notify("Wat probeer je mijn shisha pijp te stelen, ben je gek? Je krijgt een boete van €300.", "error")
                prijs = prijs + 300
                TriggerServerEvent("zb-shisha:server:betaal", prijs)
                prijs = 0
            end

            QBCore.Functions.DrawText3D(pedPos.x, pedPos.y, pedPos.z - 0.35, "~g~[E]~w~ Poffen")
            QBCore.Functions.DrawText3D(pedPos.x, pedPos.y, pedPos.z - 0.5, "~r~[G]~w~ Opstaan")

            if IsControlJustPressed(0, 38) and not smoking then
                TriggerEvent("zb-shisha:client:smoke")
                TriggerEvent("zb-afkkick:client:resetTimer")
                if math.random(1, 3) == 2 then
                    TriggerServerEvent('qb-hud:Server:RelieveStress', math.random(1, 2))
                end
            end

            if IsControlJustPressed(0, 58) then -- Stoppen
                ClearPedTasks(GetPlayerPed(-1))
                SetEntityCoords(GetPlayerPed(-1), pedPos.x, pedPos.y, pedPos.z + 0.05)
                TriggerServerEvent("zb-shisha:server:maakPlekVrij", plekNummer)
                DetachEntity(slang, false, false)
                DeleteObject(slang)
                bezig = false
                plekNummer = nil
                QBCore.Functions.Notify("Je bent gestopt met shisha roken, dit koste je: €"..prijs)
                TriggerServerEvent("zb-shisha:server:betaal", prijs)
                prijs = 0
            end
        end

        if letsleep then
            Wait(1500)
        end
    end
end)


Citizen.CreateThread(function() -- Prijs berekenaar
    while true do
        Citizen.Wait(1)
        if bezig then
            prijs = prijs + Config.prijs
            Citizen.Wait(5000)
        else
            Citizen.Wait(1000)
        end
    end
end)

-- Losse functies
function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end