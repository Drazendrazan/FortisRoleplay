QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
    -- Paleto cove
    local VisLocatie1 = AddBlipForCoord(-1611.15, 5260.41, 3.97)
    SetBlipSprite(VisLocatie1, 68)
    SetBlipColour(VisLocatie1, 2)
    SetBlipScale(VisLocatie1, 0.6)
    SetBlipAsShortRange(VisLocatie1, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vis locatie")
    EndTextCommandSetBlipName(VisLocatie1)

    -- Kanaalstad
    local VisLocatie2 = AddBlipForCoord(-889.26, -1536.47, 5.17)
    SetBlipSprite(VisLocatie2, 68)
    SetBlipColour(VisLocatie2, 2)
    SetBlipScale(VisLocatie2, 0.6)
    SetBlipAsShortRange(VisLocatie2, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vis locatie")
    EndTextCommandSetBlipName(VisLocatie2)

    -- Vinewood
    local VisLocatie3 = AddBlipForCoord(-191.35, 792.71, 198.10)
    SetBlipSprite(VisLocatie3, 68)
    SetBlipColour(VisLocatie3, 2)
    SetBlipScale(VisLocatie3, 0.6)
    SetBlipAsShortRange(VisLocatie3, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vis locatie")
    EndTextCommandSetBlipName(VisLocatie3)

    -- Cayo perico
    local VisLocatie4 = AddBlipForCoord(4768.04, -4774.83, 4.85)
    SetBlipSprite(VisLocatie4, 68)
    SetBlipColour(VisLocatie4, 2)
    SetBlipScale(VisLocatie4, 0.6)
    SetBlipAsShortRange(VisLocatie4, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vis locatie")
    EndTextCommandSetBlipName(VisLocatie4)

    -- Verkoop
    local verkoopBlip = AddBlipForCoord(-1813.97, -1213.32, 13.01)
    SetBlipSprite(verkoopBlip, 68)
    SetBlipColour(verkoopBlip, 46)
    SetBlipScale(verkoopBlip, 0.6)
    SetBlipAsShortRange(verkoopBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vis verkoop")
    EndTextCommandSetBlipName(verkoopBlip)
end)

local bezig = false
local vangen = false
local stopTekst = false
local npcSpawn = true
local restartWacht = 0



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local ped = GetPlayerPed(-1)
        local pedPositie = GetEntityCoords(ped)

        letsleep = true
        
        for k, locaties in pairs(Config.Data["vislocaties"]) do
            local distance = GetDistanceBetweenCoords(pedPositie, locaties["coords"]["x"], locaties["coords"]["y"], locaties["coords"]["z"])

            if distance <= 8 then
                letsleep = false
                DrawMarker(2, locaties["coords"]["x"], locaties["coords"]["y"], locaties["coords"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                if distance <= 3 and not gestart then
                    QBCore.Functions.DrawText3D(locaties["coords"]["x"], locaties["coords"]["y"], locaties["coords"]["z"] - 0.10, "~g~[E]~w~ Start met vissen")


                    if IsControlJustPressed(0, 38) then
                        if restartWacht > 0 then
                            QBCore.Functions.Notify("Je moet nog "..restartWacht.." seconden wachten voordat je weer kan vissen.", "error")
                        else
                            QBCore.Functions.TriggerCallback("zb-vissen:server:checkHengel", function(callback)
                                if callback then
                                    local visspotNaam = locaties["naam"]
                                    TriggerEvent("zb-vissen:client:prepareVissen", visspotNaam)
                                else
                                    QBCore.Functions.Notify("Je hebt geen vishengel, koop deze bij de vrijetijdswinkel.", "error")
                                end
                            end)
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

-- Check start van vissen
AddEventHandler("zb-vissen:client:prepareVissen", function(visspotNaam)
    QBCore.Functions.TriggerCallback("zb-vissen:server:vraagSpotAantal", function(visspotAantal)
        if visspotAantal <= 3 then
            TriggerServerEvent("zb-vissen:server:reserveerVisspot", visspotNaam)
            QBCore.Functions.Notify("Je bent gestart met vissen!", "success")
        else
            QBCore.Functions.Notify("Er staan hier al 3 mensen te vissen, ga naar een andere locatie.", "error")
        end
    end, visspotNaam)
end)

-- Start vissen
RegisterNetEvent("zb-vissen:server:startVissen")
AddEventHandler("zb-vissen:server:startVissen", function(visspot, visspotPlek)
    gestart = true
    local ped = GetPlayerPed(-1)
    local pedPositie = GetEntityCoords(ped)
    local visspotData = Config.Data["vislocaties"][visspot]["spot"..visspotPlek]
    local visspotNaam = Config.Data["vislocaties"][visspot].naam

    SetEntityCoords(ped, visspotData.x, visspotData.y, visspotData.z)
    local heading = Config.Data["vislocaties"][visspot].heading
    SetEntityHeading(ped, heading)
    FreezeEntityPosition(ped, true)
    loadAnimDict("amb@lo_res_idles@")
    TaskPlayAnim(ped, "amb@lo_res_idles@", "world_human_stand_fishing_lo_res_base", 8.0, 1.0, -1, 2, 0, false, false, false)
    vishengel = AttachEntityToPed('prop_fishing_rod_01',60309, 0,0,0, 0,0,0)

    while true do
        Citizen.Wait(1)


        if not stopTekst then
            QBCore.Functions.DrawText3D(visspotData.x, visspotData.y, visspotData.z + 1, "~g~G~w~ - Stoppen")
    
            if IsControlJustPressed(0, 47) then
                restartWacht = 60
                verwijderSpotNummer = visspotPlek - 1
                TriggerServerEvent("zb-vissen:server:verwijderVisspot", visspotNaam, verwijderSpotNummer)
                Wait(100)
                QBCore.Functions.Notify("Je bent gestopt met vissen, je plek is vrijgemaakt voor iemand anders.")
                gestart = false
                vangen = false
                FreezeEntityPosition(ped, false)
                DeleteEntity(vishengel)
                ClearPedTasks(GetPlayerPed(-1))
                return
            end
        end

        if not vangen then
            local wachtTijd = math.random(8000, 35000)
            TriggerEvent("zb-vissen:client:vangen", wachtTijd)
        end

        DisableControlAction(0, 24, true) -- Attack
		DisableControlAction(0, 257, true) -- Attack 2
		DisableControlAction(0, 25, true) -- Aim
		DisableControlAction(0, 263, true) -- Melee Attack 1
		DisableControlAction(0, 45, true) -- Reload
		DisableControlAction(0, 44, true) -- Cover
		DisableControlAction(0, 37, true) -- Select Weapon
        DisableControlAction(0, 264, true) -- Disable melee
		DisableControlAction(0, 257, true) -- Disable melee
		DisableControlAction(0, 140, true) -- Disable melee
		DisableControlAction(0, 141, true) -- Disable melee
		DisableControlAction(0, 142, true) -- Disable melee
		DisableControlAction(0, 143, true) -- Disable melee
		DisableControlAction(0, 75, true)  -- Disable exit vehicle
		DisableControlAction(27, 75, true) -- Disable exit vehicle
        
    end
end)

-- Start vang missie balkie
AddEventHandler("zb-vissen:client:vangen", function(wachtTijd)
    local Skillbar = exports['zb-skillbar']:GetSkillbarObject()

    local SucceededAttempts = 0
    local NeededAttempts = math.random(1, 3)

    vangen = true
    Wait(wachtTijd)
    if vangen then
        stopTekst = true
        ClearPedTasks(GetPlayerPed(-1))
        -- PlayAnim(GetPlayerPed(-1),'amb@world_human_stand_fishing@idle_a','idle_c',10,0)
        loadAnimDict("amb@world_human_stand_fishing@idle_a")
        TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a", "idle_c", 8.0, 1.0, -1, 2, 0, false, false, false)

        Skillbar.Start({
            duration = math.random(3500, 4000),
            pos = math.random(10, 30),
            width = math.random(15, 20),
        }, function()
            if SucceededAttempts + 1 >= NeededAttempts then
                -- Finish
                -- QBCore.Functions.Notify("Je hebt de vis binnen gehaald!", "success")
                TriggerServerEvent("zb-vissen:server:geefVis")
                SucceededAttempts = 0
                vangen = false
                stopTekst = false
                loadAnimDict("amb@lo_res_idles@")
                TaskPlayAnim(GetPlayerPed(-1), "amb@lo_res_idles@", "world_human_stand_fishing_lo_res_base", 8.0, 1.0, -1, 2, 0, false, false, false)
                if math.random(1, 3) == 2 then
                    TriggerServerEvent('qb-hud:Server:RelieveStress', math.random(1, 2))
                end
                TriggerEvent("zb-afkkick:client:resetTimer")
            else
                -- Repeat
                Skillbar.Repeat({
                    duration = math.random(500, 1250),
                    pos = math.random(10, 40),
                    width = math.random(5, 13),
                })
                SucceededAttempts = SucceededAttempts + 1
            end
        end, function()
            -- Fail
            QBCore.Functions.Notify("Je hebt de vis niet aan de haak gehouden... Volgende keer beter!", "error")
            SucceededAttempts = 0
            vangen = false
            stopTekst = false
            loadAnimDict("amb@lo_res_idles@")
            TaskPlayAnim(GetPlayerPed(-1), "amb@lo_res_idles@", "world_human_stand_fishing_lo_res_base", 8.0, 1.0, -1, 2, 0, false, false, false)
        end)
    else

    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if npcSpawn == true then
            Citizen.Wait(500)

            local hash = GetHashKey('s_m_m_ammucountry')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            local npc = CreatePed(4, hash, -1813.97, -1213.32, 12.01, 30.0, false, true)

            FreezeEntityPosition(npc, true)    
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)    

            npcSpawn = false
        end

        -- Verkopen
        local ped = GetPlayerPed(-1)
        local pedPositie = GetEntityCoords(ped)
        if GetDistanceBetweenCoords(pedPositie, -1813.97, -1213.32, 13.01, true) < 2 then
            QBCore.Functions.DrawText3D(-1813.97, -1213.32, 13.01 - 0.10, "~g~E~w~ - Praten")
            if IsControlJustPressed(0, 38) then
                TriggerServerEvent("zb-vissen:server:verkoopVissen")
            end
        end

    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if restartWacht > 0 then
            restartWacht = restartWacht - 1
            Wait(1000)
        else
            Wait(2000)
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

function AttachEntityToPed(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
	BoneID = GetPedBoneIndex(GetPlayerPed(-1), bone_ID)
	obj = CreateObject(GetHashKey(prop),  1729.73,  6403.90,  34.56,  true,  true,  true)
	vX,vY,vZ = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
	xRot, yRot, zRot = table.unpack(GetEntityRotation(GetPlayerPed(-1),2))
	AttachEntityToEntity(obj,  GetPlayerPed(-1),  BoneID, x,y,z, RotX,RotY,RotZ,  false, false, false, false, 2, true)
	return obj
end