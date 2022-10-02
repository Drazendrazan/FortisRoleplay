QBCore = nil
Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

-- Locals
local npcSpawn = true

Citizen.CreateThread(function() -- Spawnt de NPC.
    while true do
        Citizen.Wait(1)
        if npcSpawn == true then
            Citizen.Wait(500)
            local hash = GetHashKey('s_m_y_ammucity_01')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            local npc = CreatePed(4, hash, 2942.81, 4626.68, 48.72 - 1, 173.01, false, true)

            FreezeEntityPosition(npc, true)    
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)    

            npcSpawn = false
            return
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local ped = GetPlayerPed(-1)
        local pedPos = GetEntityCoords(ped)

        letsleep = true

        for k, deur in pairs(Config.Locaties["bmdeur"]) do
            local deurDistance = GetDistanceBetweenCoords(pedPos, deur["coords"]["x"], deur["coords"]["y"], deur["coords"]["z"])
            if deurDistance <= 4 then
                letsleep = false
                DrawMarker(2, deur["coords"]["x"], deur["coords"]["y"], deur["coords"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                if deurDistance < 2 then
                    QBCore.Functions.DrawText3D(deur["coords"]["x"], deur["coords"]["y"], deur["coords"]["z"] - 0.10, "~g~[E]~w~ Inkopen")
                    if IsControlJustPressed(0, 38) then
                        local currentHours = GetClockHours()
                        local uurMin = 1
                        local uurMax = 6

                        if currentHours >= uurMin and currentHours <= uurMax then
                            local items = {}
                            items.label = "Blackmarket"
                            items.items = {}
                            items.slots = 10
                            for a, item in pairs(Config.Locaties["producten"]) do
                                items.items[a] = Config.Locaties["producten"][a]
                            end
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", "FamWong", items) 
                        else
                            QBCore.Functions.Notify("Ik heb op dit moment geen tijd, kom een andere keer terug", "error")
                        end
                    end
                end
            end
        end

        if letsleep then
            Wait(500)
        end
    end
end)

-- Attachments

-- Verkoop dealer
local dealerSpawn = true
local dealerLocatie = nil

Citizen.CreateThread(function()
    QBCore.Functions.TriggerCallback("zb-bmshop:server:checkDealer", function(locatie)
        dealerLocatie = locatie
        while true do
            Citizen.Wait(1)
            if dealerSpawn == true then
                Citizen.Wait(500)
                local hash = GetHashKey('s_m_y_armymech_01')
                RequestModel(hash)
                
                while not HasModelLoaded(hash) do
                    Wait(1)
                end
    
                npc = CreatePed(4, hash, dealerLocatie.dealer.x, dealerLocatie.dealer.y, dealerLocatie.dealer.z - 1, dealerLocatie.dealer.h, false, true)
    
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
            QBCore.Functions.DrawText3D(dealerLocatie.dealer.x, dealerLocatie.dealer.y, dealerLocatie.dealer.z + 1, "~g~[E]~w~ Inkopen")
            if IsControlJustPressed(0, 38) then
                SendNUIMessage({
                    type = "open",
                })
                SetNuiFocus(true, true)
            end
        end
        if letsleep then
            Citizen.Wait(1000)
        end
    end
end)

RegisterNUICallback("kopen", function(data, cb)
    local id = data.id
    SetNuiFocus(false, false)
    TriggerServerEvent("zb-bmshop:server:koopAttachment", id)
end)

RegisterNUICallback("sluiten", function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNetEvent("zb-bmshop:client:emote")
AddEventHandler("zb-bmshop:client:emote", function()
    local ped = GetPlayerPed(-1)

    loadAnimDict("mp_ped_interaction")
    ClearPedTasks(npc)
    TaskPlayAnim(ped, "mp_ped_interaction", "handshake_guy_a", 8.0, -8, -1, 16, 0, 0, 0, 0)
    TaskPlayAnim(npc, "mp_ped_interaction", "handshake_guy_a", 8.0, -8, -1, 16, 0, 0, 0, 0)
    Citizen.Wait(2000)
    ClearPedTasks(ped)
    ClearPedTasks(npc)
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end