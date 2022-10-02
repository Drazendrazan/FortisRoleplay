QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

-- Locals
local npcSpawn = true
local bezig = false
local appelsOver = 11

-- Zet de blip & NPC neer
Citizen.CreateThread(function ()
    local AppelBlip = AddBlipForCoord(405.76, 6526.24, 27.71)
    SetBlipSprite(AppelBlip, 489)
    SetBlipColour(AppelBlip, 1)
    SetBlipScale(AppelBlip, 0.9)
    SetBlipAsShortRange(AppelBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Appeltuin")
    EndTextCommandSetBlipName(AppelBlip)

    while true do
        Citizen.Wait(1)
        if npcSpawn == true then
            Citizen.Wait(1000)

            local hash = GetHashKey('cs_old_man1a')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            local npc = CreatePed(4, hash, 405.96, 6526.24, 26.71, 80.0, false, true)

            FreezeEntityPosition(npc, true)    
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)    

            npcSpawn = false
        end
    end
end)

-- Boom locaties
local boomLocaties = {
    ["locaties"] = {
        [1] = { x = 353.7, y = 6530.32, z = 27.41},
        [2] = { x = 378.06, y = 6506.38, z = 26.97},
        [3] = { x = 369.99, y = 6506.39, z = 27.44},
        [4] = { x = 363.22, y = 6506.32, z = 27.53},
        [5] = { x = 355.57, y = 6505.67, z = 27.49},
        [6] = { x = 355.22, y = 6516.81, z = 27.2},
        [7] = { x = 363.11, y = 6517.3, z = 27.28},
        [8] = { x = 370.65, y = 6516.99, z = 27.37},
        [9] = { x = 377.85, y = 6517.0, z = 27.38},
        [10] = { x = 369.37, y = 6531.22, z = 27.4},
        [11] = { x = 361.73, y = 6530.96, z = 27.36},
    }
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local letsleep = true
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        
        if GetDistanceBetweenCoords(pos, 405.76, 6526.24, 27.71) < 3 then
            letsleep = false
            QBCore.Functions.DrawText3D(405.76, 6526.24, 28.71, "~g~E~w~ - Praten")
            if IsControlJustPressed(0, 38) then
                QBCore.Functions.TriggerCallback("zb-daily:server:dailycheckappel", function(callback)
                    if callback == 1 then
                        QBCore.Functions.Notify("Je hebt de appels al geplukt vandaag, kom morgen terug!", "error")
                    else
                        if bezig == false then
                            TriggerEvent("zb-daily:client:appels")
                            QBCore.Functions.Notify("Howdy! Bedankt dat je me wilt helpen met de appels plukken. Pluk alle appels en breng ze dan terug naar mij!")
                            bezig = true
                        else
                            if appelsOver <= 0 then
                                TriggerServerEvent("zb-daily:server:eindeappel")
                                bezig = false
                            else
                                QBCore.Functions.Notify("Pluk eerst alle appels en breng ze dan pas terug naar mij.", "error")
                            end
                        end         
                    end
                end)
            end
        end

        if letsleep then
            Wait(1000)
        end
    end
end)


AddEventHandler("zb-daily:client:appels", function()
    Citizen.CreateThread(function()
        if #boomLocaties["locaties"] > 0 then
            local randomLocatie = math.random(1, #boomLocaties["locaties"])
            local boompiesLocatie = boomLocaties["locaties"][randomLocatie]

            while true do
                Citizen.Wait(1)
                local letsleep = true
                local ped = GetPlayerPed(-1)
                local pos = GetEntityCoords(ped)

                if GetDistanceBetweenCoords(pos, boompiesLocatie.x, boompiesLocatie.y, boompiesLocatie.z) < 50 then
                    letsleep = false
                    DrawMarker(2, boompiesLocatie.x, boompiesLocatie.y, boompiesLocatie.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.4, 255, 0, 0, 155, true, false, false, true, false, false, false)
                    if GetDistanceBetweenCoords(pos, boompiesLocatie.x, boompiesLocatie.y, boompiesLocatie.z) < 2 then
                        QBCore.Functions.DrawText3D(boompiesLocatie.x, boompiesLocatie.y, boompiesLocatie.z + 1.50, "~g~E~w~ - Plukken")
                        if IsControlJustPressed(0, 38) then
                            if appelsOver > 0 then
                                TaskStartScenarioInPlace(ped, "PROP_HUMAN_MUSCLE_CHIN_UPS", 0, true)
                                QBCore.Functions.Progressbar("kaas", "Aan het plukken...", 3000, false, false, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function()
                                    appelsOver = appelsOver - 1
                                    QBCore.Functions.Notify("Je hebt de appel geplukt!", "success")
                                    ClearPedTasksImmediately(ped)
                                    TriggerServerEvent("zb-daily:server:krijgappel")
                                    TriggerEvent("zb-daily:client:appels")
                                    table.remove(boomLocaties["locaties"], randomLocatie)
                                    dump(boomLocaties["locaties"])
                                end)
                            end
                            return
                        end
                    end
                end

                if letsleep then
                    Citizen.Wait(1000)
                end
            end
        else 
            QBCore.Functions.Notify("Alle appels zijn geplukt, breng ze terug naar de boer!", "success")
            return
        end
    end)
end)

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