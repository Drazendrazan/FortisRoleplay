QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Kalm water
local eilandLocatie = {x = 5017.99, y = -5120.99, z = 5.23}
local kalmWater = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        letsleep = true
		local pedCoords = GetEntityCoords(GetPlayerPed(-1))
		if GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, eilandLocatie.x, eilandLocatie.y, eilandLocatie.z) < 2000 and not kalmWater then
            letsleep = false
			Citizen.InvokeNative(0xC54A08C85AE4D410, 0.4)
            kalmWater = true
        elseif kalmWater and GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, eilandLocatie.x, eilandLocatie.y, eilandLocatie.z) > 2000 then
            letsleep = false
			Citizen.InvokeNative(0xB96B00E976BE977F, 1.0)
            kalmWater = false
		end
        if letsleep then
            Wait(3000)
        end
	end
end)


-- Locals
local npcSpawn = true
local plantjesSpawn = true

local bezig = false
local aantalPlantjes = 0

-- Blip & NPC / Plantjes Spawn
Citizen.CreateThread(function()
    Wait(2000)
    local weedBlip = AddBlipForCoord(Config.Locaties["dealer"].x, Config.Locaties["dealer"].y, Config.Locaties["dealer"].z)
    SetBlipSprite(weedBlip, 469)
    SetBlipColour(weedBlip, 25)
    SetBlipScale(weedBlip, 0.9)
    SetBlipAsShortRange(weedBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wiet Pluk")
    EndTextCommandSetBlipName(weedBlip)
    Wait(2000)
    local verpakBlip = AddBlipForCoord(Config.Locaties["verpak"].x, Config.Locaties["verpak"].y, Config.Locaties["verpak"].z)
    SetBlipSprite(verpakBlip, 514)
    SetBlipColour(verpakBlip, 16)
    SetBlipScale(verpakBlip, 0.8)
    SetBlipAsShortRange(verpakBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wiet Verpak")
    EndTextCommandSetBlipName(verpakBlip)

    while true do
        Citizen.Wait(1)
        if npcSpawn == true then
            Citizen.Wait(500)
            local hash = GetHashKey('mp_f_weed_01')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            npcSpawnPed = CreatePed(4, hash, Config.Locaties["dealer"].x, Config.Locaties["dealer"].y, Config.Locaties["dealer"].z, Config.Locaties["dealer"].h, false, true)

            FreezeEntityPosition(npcSpawnPed, true)    
            SetEntityInvincible(npcSpawnPed, true)
            SetBlockingOfNonTemporaryEvents(npcSpawnPed, true)

            loadAnimDict("amb@world_human_smoking@male@male_a@base")
            TaskPlayAnim(npcSpawnPed, "amb@world_human_smoking@male@male_a@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)


            npcSpawn = false
        end
        if plantjesSpawn == true then
            Citizen.Wait(500)
            local hash = GetHashKey('bkr_prop_weed_lrg_01b')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            for k, locatie in pairs(Config.Plantjes["locaties"]) do
                local plantjes = CreateObject(hash, locatie.x, locatie.y, locatie.z - 3.0, 0.0, false, false)
            end

            plantjesSpawn = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local letsleep = false

        -- Plukken
        if GetDistanceBetweenCoords(pos, Config.Locaties["dealer"].x, Config.Locaties["dealer"].y, Config.Locaties["dealer"].z, true) < 2.5 then
            letsleep = false
            QBCore.Functions.DrawText3D(Config.Locaties["dealer"].x, Config.Locaties["dealer"].y, Config.Locaties["dealer"].z + 1.0, "~g~[E]~w~ Wiet plukken")
            if IsControlJustPressed(0, 38) then
                local PlayerData = QBCore.Functions.GetPlayerData()
                local job = PlayerData.job.name
                if job == ("police") or job == ("ambulance") then
                    QBCore.Functions.Notify("Dit is niet toegestaan als hulpdienst.", "error")
                else
                    if not IsPedInAnyVehicle(ped) then
                        if not bezig then
                            QBCore.Functions.TriggerCallback("zb-cayoweed:server:checkPlukken", function(magPlukken, tijdOver)
                                if magPlukken then
                                    -- Heeft nog geen 5 rondjes gedaan
                                    QBCore.Functions.Notify("Pluk 10 plantjes achter je, als je klaar bent mag je ze houden!", "success")
                                    TriggerEvent("zb-cayoweed:client:plukwiet")
                                    bezig = true
                                    aantalPlantjes = 0
                                else
                                    -- Heeft al 5 rondes gedaan, en tijd is niet voorbij
                                    if tijdOver <= 1 then
                                        QBCore.Functions.Notify("De plantjes moeten nog even verder groeien, kom over "..tijdOver.." minuut terug.", "error")
                                    else
                                        QBCore.Functions.Notify("De plantjes moeten nog even verder groeien, kom over "..tijdOver.." minuten terug.", "error")
                                    end
                                end
                            end)
                        else
                            QBCore.Functions.Notify("Je bent al bezig met wiet plukken!", "error")
                        end
                    else
                        QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
                    end
                end
            end
        end

        -- Verpakken
        if GetDistanceBetweenCoords(pos, Config.Locaties["verpak"].x, Config.Locaties["verpak"].y, Config.Locaties["verpak"].z) < 8.0 then
            letsleep = false
            DrawMarker(2, Config.Locaties["verpak"].x, Config.Locaties["verpak"].y, Config.Locaties["verpak"].z - 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
            if GetDistanceBetweenCoords(pos, Config.Locaties["verpak"].x, Config.Locaties["verpak"].y, Config.Locaties["verpak"].z, true) < 2.5 then
                QBCore.Functions.DrawText3D(Config.Locaties["verpak"].x, Config.Locaties["verpak"].y, Config.Locaties["verpak"].z, "~g~[E]~w~ Wiet verpakken")
                if IsControlJustPressed(0, 38) then
                    local PlayerData = QBCore.Functions.GetPlayerData()
                    local job = PlayerData.job.name
                    if job == ("police") or job == ("ambulance") then
                        QBCore.Functions.Notify("Dit is niet toegestaan als hulpdienst.", "error")
                    else
                        if not IsPedInAnyVehicle(ped) then
                            QBCore.Functions.TriggerCallback("zb-cayoweed:server:checkSpullen", function(resultaat, notificatie)
                                if resultaat then
                                    SetNuiFocus(true, true)
                                    SendNUIMessage({
                                        type = "verpak"
                                    })
                                    loadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                                    TaskPlayAnim(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8, -1, 49, 0, 0, 0, 0)
                                else
                                    QBCore.Functions.Notify(notificatie, "error")
                                end
                            end)
                        else
                            QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
                        end
                    end
                end
            end
        end

        if GetDistanceBetweenCoords(pos, Config.Locaties["verpak2"].x, Config.Locaties["verpak2"].y, Config.Locaties["verpak2"].z) < 8.0 then
            letsleep = false
            DrawMarker(2, Config.Locaties["verpak2"].x, Config.Locaties["verpak2"].y, Config.Locaties["verpak2"].z - 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
            if GetDistanceBetweenCoords(pos, Config.Locaties["verpak2"].x, Config.Locaties["verpak2"].y, Config.Locaties["verpak2"].z, true) < 2.5 then
                QBCore.Functions.DrawText3D(Config.Locaties["verpak2"].x, Config.Locaties["verpak2"].y, Config.Locaties["verpak2"].z, "~g~[E]~w~ Wiet verpakken")
                if IsControlJustPressed(0, 38) then
                    local PlayerData = QBCore.Functions.GetPlayerData()
                    local job = PlayerData.job.name
                    if job == ("police") or job == ("ambulance") then
                        QBCore.Functions.Notify("Dit is niet toegestaan als hulpdienst.", "error")
                    else
                        if not IsPedInAnyVehicle(ped) then
                            QBCore.Functions.TriggerCallback("zb-cayoweed:server:checkSpullen", function(resultaat, notificatie)
                                if resultaat then
                                    SetNuiFocus(true, true)
                                    SendNUIMessage({
                                        type = "verpak"
                                    })
                                    loadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                                    TaskPlayAnim(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8, -1, 49, 0, 0, 0, 0)
                                else
                                    QBCore.Functions.Notify(notificatie, "error")
                                end
                            end)
                        else
                            QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
                        end
                    end
                end
            end
        end

        if letsleep then
            Citizen.Wait(1000)
        end
    end
end)

RegisterNUICallback("verpakGeslaagd", function(data)
    TriggerServerEvent("zb-cayoweed:server:verpakWiet")
    ClearPedTasks(GetPlayerPed(-1))
    SetNuiFocus(false, false)
end)

RegisterNUICallback("verpakGefaald", function(data)
    TriggerServerEvent("zb-cayoweed:server:verpakFaal")
    ClearPedTasks(GetPlayerPed(-1))
    if data.reden == 1 then
        QBCore.Functions.Notify("Je hebt het zakje te snel dicht gedaan, het zakje is gescheurd!", "error")
    elseif data.reden == 2 then
        QBCore.Functions.Notify("Je hebt hem niet goed dicht gemaakt, alles is eruit gevallen!", "error")
    end
    SetNuiFocus(false, false)
end)


-- Plukken
local moetReturnen = false
local bezigPluk = false
AddEventHandler("zb-cayoweed:client:plukwiet", function()
    Citizen.CreateThread(function()
        if aantalPlantjes < 10 then
            local randomLocatie = math.random(1, 43)
            local plantLocatie = Config.Plantjes["locaties"][randomLocatie]
            while true do
                Citizen.Wait(1)
                local ped = GetPlayerPed(-1)
                local pos = GetEntityCoords(ped)

                if GetDistanceBetweenCoords(pos, plantLocatie.x, plantLocatie.y, plantLocatie.z) < 45 then
                    letsleep = false
                    DrawMarker(0, plantLocatie.x, plantLocatie.y, plantLocatie.z + 2.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.55, 0.55, 0.25, 255, 0, 0, 155, true, false, false, true, false, false, false)
                    if GetDistanceBetweenCoords(pos, plantLocatie.x, plantLocatie.y, plantLocatie.z) < 2 then
                        QBCore.Functions.DrawText3D(plantLocatie.x, plantLocatie.y, plantLocatie.z + 1.0, "~g~E~w~ - Plukken")
                        if IsControlJustPressed(0, 38) then
                            if not IsPedInAnyVehicle(ped) then
                                loadAnimDict("amb@world_human_bum_wash@male@low@idle_a")
                                bezigPluk = true
                                TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_bum_wash@male@low@idle_a", "idle_a", 8.0, -8, -1, 15, 0, 0, 0, 0)
                                SetNuiFocus(true, true)
                                SendNUIMessage({
                                    type = "pluk"
                                })
                            else
                                QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
                            end
                        end
                    end
                end

                if moetReturnen then
                    moetReturnen = false
                    return
                end

                if letsleep then
                    Citizen.Wait(1000)
                end
            end
        else
            bezig = false
            QBCore.Functions.Notify("Je hebt alle plantjes geplukt, vergeet ze niet te verpakken!", "success")
            return
        end
    end)
end)

RegisterNUICallback("plukGeslaagd", function(data)
    if bezigPluk then
        bezigPluk = false
        ClearPedTasks(GetPlayerPed(-1))
        local pedCoords = GetEntityCoords(GetPlayerPed(-1))
        SetEntityCoords(GetPlayerPed(-1), pedCoords.x, pedCoords.y, pedCoords.z)
        moetReturnen = true
        SetNuiFocus(false, false)
        aantalPlantjes = aantalPlantjes + 1
        TriggerServerEvent("zb-cayoweed:server:krijgwiet")
        TriggerEvent("zb-cayoweed:client:plukwiet")
    else
        TriggerServerEvent("zb-cayoweed:server:kauloHacker")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        SetRadarAsExteriorThisFrame()
        SetRadarAsInteriorThisFrame(GetHashKey("h4_fake_islandx"), 4700.0, -5145.0, 0, 0)
    end
end)

-- Citizen.CreateThread(function()
--     SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
--     SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
--     SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
--     SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
--     SetMapZoomDataLevel(4, 24.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
--     SetMapZoomDataLevel(5, 55.0, 0.0, 0.1, 2.0, 1.0) -- ZOOM_LEVEL_GOLF_COURSE
--     SetMapZoomDataLevel(6, 450.0, 0.0, 0.1, 1.0, 1.0) -- ZOOM_LEVEL_INTERIOR
--     SetMapZoomDataLevel(7, 4.5, 0.0, 0.0, 0.0, 0.0) -- ZOOM_LEVEL_GALLERY
--     SetMapZoomDataLevel(8, 11.0, 0.0, 0.0, 2.0, 3.0) -- ZOOM_LEVEL_GALLERY_MAXIMIZE
-- end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		if IsPedOnFoot(GetPlayerPed(-1)) then 
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			SetRadarZoom(1100)
		end
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

-- Verkoop dealer
local dealerSpawn = true
local dealerLocatie = nil

Citizen.CreateThread(function()
    QBCore.Functions.TriggerCallback("zb-cayoweed:server:checkDealer", function(locatie)
        dealerLocatie = locatie
        while true do
            Citizen.Wait(1)
            if dealerSpawn == true then
                Citizen.Wait(500)
                local hash = GetHashKey('g_f_y_families_01')
                RequestModel(hash)
                
                while not HasModelLoaded(hash) do
                    Wait(1)
                end
    
                local npc = CreatePed(4, hash, dealerLocatie.dealer.x, dealerLocatie.dealer.y, dealerLocatie.dealer.z - 1, dealerLocatie.dealer.h, false, true)
    
                FreezeEntityPosition(npc, true)    
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)    

                loadAnimDict("amb@world_human_smoking@male@male_a@base")
                TaskPlayAnim(npc, "amb@world_human_smoking@male@male_a@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
    
                dealerSpawn = false
                return
            end
        end
    end)
end)

Citizen.CreateThread(function()
    Wait(3000)
    while true do
        Citizen.Wait(1)
        local letsleep = true
        local pos = GetEntityCoords(GetPlayerPed(-1))

        if GetDistanceBetweenCoords(pos, dealerLocatie.dealer.x, dealerLocatie.dealer.y, dealerLocatie.dealer.z, true) < 2 then
            letsleep = false
            QBCore.Functions.DrawText3D(dealerLocatie.dealer.x, dealerLocatie.dealer.y, dealerLocatie.dealer.z + 1, "~g~[E]~w~ Wiet verkopen")
            if IsControlJustPressed(0, 38) then
                TriggerServerEvent("zb-cayoweed:server:verkoopWiet")
            end
        end
        if letsleep then
            Citizen.Wait(1000)
        end
    end
end)