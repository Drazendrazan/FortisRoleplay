QBCore = nil

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

-- Variabelen
local busy = false
local spelen = false
local ignoreplayers = {}
local frozenped = {}
local GebruiktePeds = {}

-- Item gebruiken
RegisterNetEvent("fortis-gitaar:client:speelgitaar")
AddEventHandler("fortis-gitaar:client:speelgitaar", function()
    if not IsPedInAnyVehicle(PlayerPedId(), true) then
        busy = not busy
        if not busy then
            QBCore.Functions.Notify("Je bent gestopt met gitaar spelen!", "error")
            ExecuteCommand("e c")
            ignoreplayers = {}
        else
            for _, player in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(player)
                table.insert(ignoreplayers, ped)
            end
            QBCore.Functions.Notify("Je bent gitaar aan het spelen, wat prachtig!", "success")
            ExecuteCommand("e guitar")
        end
    else
        QBCore.Functions.Notify("Stap eerst uit je voertuig om gitaar te kunnen spelen!", "error")
    end
end)

-- NPC's komen
Citizen.CreateThread(function()
    while true do
        Wait(1)
        if busy then
            if IsPedInAnyVehicle(PlayerPedId(), true) then
                QBCore.Functions.Notify("Stap uit je voertuig als je verder wilt spelen!", "error")
                ExecuteCommand("e c")
                busy = false
            end
            
            BlokkeerToetsen()
            local pos = GetEntityCoords(GetPlayerPed(-1))
            local closestPed, closestDistance = QBCore.Functions.GetClosestPed(pos, ignoreplayers)

            if closestPed ~= 0 and closestDistance < 15 and GebruiktePeds[closestPed] == nil and not spelen then
                local npcPos = GetEntityCoords(closestPed)

                if closestDistance > 1.2 then
                    TaskGoStraightToCoord(closestPed, pos, 1.2, -1, 0.0, 0.0)
                    Wait(250)
                end

                if GetDistanceBetweenCoords(npcPos, pos) < 1.2 then
                    local npcTextCoords = GetEntityCoords(closestPed)

                    if not frozenped[closestPed] then
                        ClearPedTasks(closestPed)
                        FreezeEntityPosition(closestPed, true)
                        TaskTurnPedToFaceEntity(closestPed, PlayerPedId(), -1)
                        frozenped[closestPed] = {}
                    end

                    QBCore.Functions.DrawText3D(npcTextCoords.x, npcTextCoords.y, npcTextCoords.z - 0.10, "~g~[E]~w~ - Speel gitaar")

                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent("InteractSound_SV:PlayOnSource", "gitaar", 0.2)
                        SpeelGitaar(closestPed)
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

BlokkeerToetsen = function()
    DisableControlAction(1, 73, true) -- X
    DisableControlAction(0, 73, true) -- X
    DisableControlAction(0, 186, true) -- X
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

-- Skillbar
SpeelGitaar = function(closestPed)
    local Skillbar = exports['fortis-skillbar']:GetSkillbarObject()

    local SucceededAttempts = 0
    local NeededAttempts = math.random(2, 4)
    
    spelen = true

    if spelen then
        loadAnimDict("anim@amb@nightclub@mini@dance@dance_solo@male@var_b@")
        TaskPlayAnim(closestPed, "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "low_center", 8.0, -8, -1, 49, 0, 0, 0, 0)

        Skillbar.Start({
            duration = math.random(1200, 1400),
            pos = math.random(10, 40),
            width = math.random(10, 13),
        }, function()
            if SucceededAttempts + 1 >= NeededAttempts then
                TriggerServerEvent("fortis-gitaar:server:geefGeld")
                FreezeEntityPosition(closestPed, false)
                ClearPedTasks(closestPed)
                SetEntityAsNoLongerNeeded(closestPed)
                GebruiktePeds[closestPed] = {}
                frozenped[closestPed] = nil
                spelen = false
                SucceededAttempts = 0
            else
                Skillbar.Repeat({
                    duration = math.random(900, 1250),
                    pos = math.random(10, 40),
                    width = math.random(10, 13),
                })
                SucceededAttempts = SucceededAttempts + 1
            end
        end, function()
            QBCore.Functions.Notify("Dat waren de verkeerde snaren... Volgende keer beter!", "error")
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "gitaar2", 20.0)
            FreezeEntityPosition(closestPed, false)
            ClearPedTasks(closestPed)
            SetEntityAsNoLongerNeeded(closestPed)
            GebruiktePeds[closestPed] = {}
            frozenped[closestPed] = nil
            spelen = false
            SucceededAttempts = 0
        end)
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end