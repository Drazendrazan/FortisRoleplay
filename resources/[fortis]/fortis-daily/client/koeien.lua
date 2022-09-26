QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

-- Locals
local npcSpawn = true
local emmer = false


-- Koe locaties
local koeLocaties = {
    ["locaties"] = {
        [1] = {x = 2384.74, y = 5048.02, z = 45.43, h = 120.0},
        [2] = {x = 2379.06, y = 5046.92, z = 45.45, h = 80.0},
        [3] = {x = 2370.87, y = 5048.3, z = 45.4, h = 190.0},
        [4] = {x = 2372.86, y = 5052.45, z = 45.45, h = 20.0},
        [5] = {x = 2380.86, y = 5054.73, z = 45.44, h = 380.0},
        [6] = {x = 2378.06, y = 5060.97, z = 45.44, h = 210.0},
    }
}

-- Zet de blip op de kaart
Citizen.CreateThread(function ()
    local BoerderijBlip = AddBlipForCoord(2359.66, 5016.64, 43.91)
    SetBlipSprite(BoerderijBlip, 141)
    SetBlipColour(BoerderijBlip, 0)
    SetBlipScale(BoerderijBlip, 0.9)
    SetBlipAsShortRange(BoerderijBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Boerderij")
    EndTextCommandSetBlipName(BoerderijBlip)

    while true do
        Citizen.Wait(1)
        if npcSpawn == true then
            Citizen.Wait(1000)

            local hash = GetHashKey('cs_old_man2')
            RequestModel(hash)

            local hashkoe = GetHashKey('a_c_cow')
            RequestModel(hashkoe)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            while not HasModelLoaded(hashkoe) do
                Wait(1)
            end

            local npc = CreatePed(4, hash, 2416.35, 4993.90, 45.22, 140.0, false, true)

            FreezeEntityPosition(npc, true)    
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)    

            for k, locatie in pairs(koeLocaties["locaties"]) do
                local heading = math.random(0, 500)
                local koe = CreatePed(4, hashkoe, locatie.x, locatie.y, locatie.z, locatie.h, false, true)

                FreezeEntityPosition(koe, true)    
                SetEntityInvincible(koe, true)
                SetBlockingOfNonTemporaryEvents(koe, true) 
            end
            npcSpawn = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local letsleep = true
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
       
        if GetDistanceBetweenCoords(pos, 2416.35, 4993.90, 45.22) < 3 then
            letsleep = false
            QBCore.Functions.DrawText3D(2416.35, 4993.90, 47.22, "~g~E~w~ - Praten")
            if IsControlJustPressed(0, 38) then
                QBCore.Functions.TriggerCallback("fortis-daily:server:dailycheckkoe", function(callback)
                    if callback == 1 then
                        QBCore.Functions.Notify("Je hebt de koeien al gemolken vandaag, kom morgen terug!", "error")
                    else
                        if emmer == false then
                            TriggerEvent("fortis-daily:client:koeien")
                            QBCore.Functions.Notify("Howdy! Bedankt dat je me wilt helpen met de koeien melken. Hier heb je wat emmers, vul ze met melk en breng ze dan terug naar mij!")
                            TriggerServerEvent("fortis-daily:server:geefemmer")
                            emmer = true
                        else
                            QBCore.Functions.TriggerCallback("fortis-daily:server:requestemmers", function(aantal)
                                if aantal == 6 then
                                    TriggerServerEvent("fortis-daily:server:eindekoe")
                                    emmer = false
                                else
                                    QBCore.Functions.Notify("Vul eerst alle emmers en breng ze dan pas terug naar mij.", "error")
                                end
                            end)
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

AddEventHandler("fortis-daily:client:koeien", function(aantal)
    Citizen.CreateThread(function()
        if #koeLocaties["locaties"] > 0 then
            local randomLocatie = math.random(1, #koeLocaties["locaties"])
            local koeinLocatie = koeLocaties["locaties"][randomLocatie]

            while true do
                Citizen.Wait(1)
                
                local letsleep = true
                local ped = GetPlayerPed(-1)
                local pos = GetEntityCoords(ped)

                if GetDistanceBetweenCoords(pos, koeinLocatie.x, koeinLocatie.y, koeinLocatie.z) < 25 then
                    letsleep = false
                    DrawMarker(0, koeinLocatie.x, koeinLocatie.y, koeinLocatie.z + 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.1, 255, 255, 255, 155, true, false, false, true, false, false, false)
                    if GetDistanceBetweenCoords(pos, koeinLocatie.x, koeinLocatie.y, koeinLocatie.z) < 2 then
                        QBCore.Functions.DrawText3D(koeinLocatie.x, koeinLocatie.y, koeinLocatie.z + 0.50, "~g~E~w~ - Melken")
                        if IsControlJustPressed(0, 38) then
                            QBCore.Functions.TriggerCallback("fortis-daily:server:requestemmer", function(emmerAantal)
                                if emmerAantal > 0 then
                                    TriggerServerEvent("fortis-daily:server:emmervol")
                                    QBCore.Functions.Progressbar("kaas", "Aan het melken...", 7000, false, false, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {
                                        animDict = "amb@world_human_bum_wash@male@low@idle_a",
                                        anim = "idle_a",
                                        flags = 3,
                                    }, {}, {}, function()
                                        QBCore.Functions.Notify("Je hebt de koe gemolken!", "success")
                                        ClearPedTasksImmediately(ped)
                                        TriggerEvent("fortis-daily:client:koeien")
                                        table.remove(koeLocaties["locaties"], randomLocatie)
                                        dump(koeLocaties["locaties"])
                                    end)
                                else 
                                    QBCore.Functions.Notify("Je hebt geen emmmer bij je, of ga je het meteen opdrinken?", "error")
                                    TriggerEvent("fortis-daily:client:koeien")
                                end
                            end)
                            return
                        end
                    end
                end

                if letsleep then
                    Wait(1000)
                end
            end
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