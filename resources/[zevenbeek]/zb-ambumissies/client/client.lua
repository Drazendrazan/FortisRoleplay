QBCore = nil

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

local PlayerJob = {}
local CurrentLocation = {}
local bezig = false

-- NPC Ophalen -- 
RegisterNetEvent('ambu:client:ToggleNpc')
AddEventHandler('ambu:client:ToggleNpc', function()
    if QBCore.Functions.GetPlayerData().job.name == "ambulance" then
        letsleep = true
        npcSpawned = false

        if bezig then
            QBCore.Functions.Notify("Haal eerst de vorige patient op!", "error")
        else
            bezig = true
            local pos = GetEntityCoords(GetPlayerPed(-1))
            local randomLocation = math.random(1, #Config.Locations["npcs"])
            CurrentLocation.x = Config.Locations["npcs"][randomLocation].coords.x
            CurrentLocation.y = Config.Locations["npcs"][randomLocation].coords.y
            CurrentLocation.z = Config.Locations["npcs"][randomLocation].coords.z
            CurrentLocation.ped = Config.Locations["npcs"][randomLocation].ped
            CurrentLocation.id = randomLocation

            CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
            SetBlipColour(CurrentBlip, 3)
            SetBlipRoute(CurrentBlip, true)
            SetBlipRouteColour(CurrentBlip, 3)

            while true do
                Citizen.Wait(1)
                local pos = GetEntityCoords(GetPlayerPed(-1))

                if not npcSpawned and GetDistanceBetweenCoords(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z, pos.x, pos.y, pos.z, true) < 40.0 then
                    Citizen.Wait(500)
                    local hash = GetHashKey(CurrentLocation.ped)
                    RequestModel(hash)
                    
                    while not HasModelLoaded(hash) do
                        Wait(1)
                    end
        
                    missieNpc = CreatePed(4, hash, CurrentLocation.x, CurrentLocation.y, CurrentLocation.z - 0.6, 161.45, false, true)
        
                    FreezeEntityPosition(missieNpc, true)    
                    SetEntityInvincible(missieNpc, true)
                    SetBlockingOfNonTemporaryEvents(missieNpc, true)
        
                    loadAnimDict("missarmenian2")
                    TaskPlayAnim(missieNpc, "missarmenian2", "corpse_search_exit_ped", 8.0, -8, -1, 3, 0, 0, 0, 0)

                    npcSpawned = true
                end

                if GetDistanceBetweenCoords(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z, pos.x, pos.y, pos.z, true) < 5.0 then
                    letsleep = false
                    QBCore.Functions.DrawText3D(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z + 0.10, "~g~[E]~w~ Persoon reanimeren")
                    if IsControlJustPressed(0, 38) then
                        QBCore.Functions.Progressbar("ambumissie", "Persoon reanimeren...", 10000, false, false, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "mini@cpr@char_a@cpr_str",
                            anim = "cpr_pumpchest",
                            flags = 1,
                        }, {}, {}, function() -- Done
                            ClearPedTasks(GetPlayerPed(-1))
                            DeleteEntity(missieNpc)
                            RemoveBlip(CurrentBlip)
                            QBCore.Functions.Notify("De persoon ligt in de ambulance, breng hem/haar snel naar het ziekenhuis!", "success")
                            TriggerEvent("ambu:client:leverNpcAf", CurrentLocation)
                        end)
                        return
                    end
                end

                if letsleep then
                    Citizen.Wait(500)
                end
            end
        end
    end
end)

-- NPC afzetten --
RegisterNetEvent("ambu:client:leverNpcAf")
AddEventHandler("ambu:client:leverNpcAf", function(CurrentLocation)
    local npcSpawned = false
    local heeftNpc = true
    local yes = true
    while true do
        Citizen.Wait(1)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local letsleep = true
        if not npcSpawned then
            if GetDistanceBetweenCoords(293.21, -584.13, 43.19, pos, true) < 30 then
                letsleep = false
                DrawMarker(25, 293.21, -584.13, 43.19 - 1.0, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.5001, 255, 0, 0,100, 0, 0, 0,0)
                if GetDistanceBetweenCoords(293.21, -584.13, 43.19, pos.x, pos.y, pos.z, true) < 5 then
                    QBCore.Functions.DrawText3D(293.21, -584.13, 43.19 + 0.20, "~g~[E]~w~ Persoon uitladen")
                    if IsControlJustPressed (0,38) then
                        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                            QBCore.Functions.Notify("Breng de persoon naar de balie.")
                            Citizen.Wait(500)
                            local hash = GetHashKey(CurrentLocation.ped)
                            RequestModel(hash)

                            while not HasModelLoaded(hash) do
                                Wait(1)
                            end
                        
                            missieNpc = CreatePed(4, hash, pos.x + 0.2, pos.y, pos.z - 0.6, 161.45, false, true)
                        
                            SetEntityInvincible(missieNpc, true)
                            SetBlockingOfNonTemporaryEvents(missieNpc, true)
                            npcSpawned = true
                        else
                            QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
                        end
                    end
                end
            end
        end

        local npcCoords = GetEntityCoords(missieNpc)
        if heeftNpc then
            TaskGoStraightToCoord(missieNpc, pos, 1.2, -1, 0.0, 0.0)
            if yes then
                if GetDistanceBetweenCoords(307.07, -595.10, 43.28, pos, true) < 10 then
                    letsleep = false
                    QBCore.Functions.DrawText3D(307.07, -595.10, 43.28 + 0.20, "Persoon inchecken")
                end
            end

            if GetDistanceBetweenCoords(307.07, -595.10, 43.28, npcCoords, true) < 3 then
                letsleep = false
                yes = false
                QBCore.Functions.DrawText3D(307.07, -595.10, 43.28 + 0.20, "~g~[E]~w~ Persoon inchecken")
                 if IsControlJustPressed(0,38) then
                    DeleteEntity(missieNpc)
                    TriggerServerEvent("ambu:server:krijggeld")
                    heeftNpc = false
                    bezig = false
                end
            end 
        end
        
        if letsleep then
            Citizen.Wait(500)
        end
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end