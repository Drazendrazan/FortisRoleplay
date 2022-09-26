QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

-- Zet de blip op de kaart
Citizen.CreateThread(function ()
    local Blip = AddBlipForCoord(370.21, -1027.37, 29.33)
    SetBlipSprite(Blip, 273)
    SetBlipColour(Blip, 2)
    SetBlipScale(Blip, 0.6)
    SetBlipAsShortRange(Blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Daggoe Uitlaat Service")
    EndTextCommandSetBlipName(Blip)
end)

-- Locals
local vrij = true
local kaas = false
dierSpawn = false
letsleep = true
local timer = 0
local laatsteDeur = nil

-- Dienst starten
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local deur = GetDistanceBetweenCoords(pos, 370.21, -1027.37, 29.33)

        if deur < 7 then
            letsleep = false
            DrawMarker(2, 562.30, 2741.60, 42.46, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 255, 255, 255, 155, false, false, false, true, false, false, false)
            if deur < 2 then
                if vrij then
                    QBCore.Functions.DrawText3D(370.21, -1027.37, 29.5, "~g~E~w~ - Beschikbaar maken")
                    if IsControlJustPressed(0, 38) then
                        QBCore.Functions.Notify("Je bent nu beschikbaar om opgeroepen te worden, als iemand je nodig hebt krijg je een mail!", "success")
                        vrij = false
                        timer = math.random(15, 30)
                    end
                else
                    QBCore.Functions.DrawText3D(370.21, -1027.37, 29.5, "~r~E~w~ - Ronde stoppen")
                    if IsControlJustPressed(0, 38) then
                        QBCore.Functions.Notify("Je bent nu niet meer beschikbaar opgeroepen te worden!", "error")
                        vrij = true
                        timer = 1
                    end
                end
            end
        end

        if letsleep then
            Wait(500)
        end
    end
end)

-- Krijg mail
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if timer > 0 then
            if not vrij then
                timer = timer - 1
                Citizen.Wait(1000)
                if timer == 0 then
                    TriggerServerEvent("qb-phone:server:sendNewMail", {
                        sender = "Daggoe",
                        subject = "Uitlaat service",
                        message = "Goedemiddag, ik ben op zoek naar iemand die mijn hond kan uitlaten. Heb jij hier misschien tijd voor?<br><br>Druk op het vinkje hieronder om de locatie naar mijn huis in te stellen.<br><br>Alvast bedankt en tot zo!",
                        button = {
                            enabled = true,
                            buttonEvent = "fortis-hondjes:client:krijglocatie",
                        }
                    })
                end
            else
                timer = 0
            end
        end
    end
end)

-- Deur torrie
AddEventHandler("fortis-hondjes:client:krijglocatie", function()
    local randomDeur = math.random(1, #Config.Locaties)
    local deurLocatie = Config.Locaties[randomDeur]
 
    if randomDeur == laatsteDeur then
        TriggerEvent("fortis-hondjes:client:krijglocatie")
        return
    else
        local randomDier = math.random(1, #Config.Honden)
        local randomPed = math.random(1, #Config.Peds)
        laatsteDeur = randomDeur
    
        DeurBlip = AddBlipForCoord(deurLocatie["deur"].x, deurLocatie["deur"].y, deurLocatie["deur"].z)
        SetBlipColour(DeurBlip, 2)
        SetBlipRoute(DeurBlip, true)
        SetBlipRouteColour(DeurBlip, 2)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Huis")
        EndTextCommandSetBlipName(DeurBlip)
        
        local klaar = false
        local bezig = false
    
        while true do
            Citizen.Wait(1)
            local ped = GetPlayerPed(-1)
            pos = GetEntityCoords(ped)
            poshond = GetEntityCoords(dierntie)
            
            -- Dier en ped spawn
            if GetDistanceBetweenCoords(pos, deurLocatie["deur"].x, deurLocatie["deur"].y, deurLocatie["deur"].z) < 30 then
                letsleep = false
                if dierSpawn == false then 
                    local hash = GetHashKey(Config.Honden[randomDier].d)
                    local hashped = GetHashKey(Config.Peds[randomPed].p)
    
                    RequestModel(hash)
                    RequestModel(hashped)
    
                    while not HasModelLoaded(hash) do
                        Wait(1)
                    end
                    while not HasModelLoaded(hashped) do
                        Wait(1)
                    end
    
                    dierntie = CreatePed(4, hash, deurLocatie["deur"].x + 0.7, deurLocatie["deur"].y + 0.7, deurLocatie["deur"].z, deurLocatie["deur"].h, true, true)
                    pendtie = CreatePed(4, hashped, deurLocatie["deur"].x, deurLocatie["deur"].y, deurLocatie["deur"].z, deurLocatie["deur"].h, false, true)
      
                    SetEntityInvincible(dierntie, true)
                    SetBlockingOfNonTemporaryEvents(dierntie, true)
                    FreezeEntityPosition(pendtie, true)    
                    SetEntityInvincible(pendtie, true)
                    SetBlockingOfNonTemporaryEvents(pendtie, true)
    
                    dierSpawn = true
                end
            end
    
            if not klaar then
                if not bezig then
                    if GetDistanceBetweenCoords(pos, deurLocatie["deur"].x, deurLocatie["deur"].y, deurLocatie["deur"].z) < 3 then
                        letsleep = false
                        QBCore.Functions.DrawText3D(deurLocatie["deur"].x, deurLocatie["deur"].y, deurLocatie["deur"].z + 0.4, "~g~E~w~ - Hond meenemen")
                        if IsControlJustPressed (0, 38) then
                            QBCore.Functions.Notify("Bedankt voor het ophalen van mijn hond, loop naar de locatie op je GPS en kom dan terug!", "success")
                            LoopPed()
                            einde = AddBlipForCoord(deurLocatie["einde"].x, deurLocatie["einde"].y, deurLocatie["einde"].z)
                            SetBlipRoute(einde, true)
                            bezig = true
                        end
                    end
                else
                    if GetDistanceBetweenCoords(poshond, deurLocatie["einde"].x, deurLocatie["einde"].y, deurLocatie["einde"].z) < 10 then
                        letsleep = false
                        QBCore.Functions.Notify("De hond begint moe te worden, breng hem terug naar huis")
                        TriggerServerEvent('qb-hud:Server:RelieveStress', math.random(1, 2))
                        RemoveBlip(einde)
                        klaar = true
                    end
    
                    if IsControlJustPressed(0, 38) then
                        QBCore.Functions.Notify("Je hebt de hond al opgehaald, loop naar de locatie op je GPS en kom dan terug!", "error")
                    end 
    
                    -- Loopt weg met hond (stop)
                    if GetDistanceBetweenCoords(pos, deurLocatie["deur"].x, deurLocatie["deur"].y, deurLocatie["deur"].z) > 500 then
                        QBCore.Functions.Notify("Waar ga je naar toe met m'n hond? Dat is niet de bedoeling! Geef die hond maar terug en zoek iemand anders!", "error")
                        RemoveBlip(DeurBlip)
                        RemoveBlip(einde)
                        DeleteEntity(dierntie)
                        SetPedAsNoLongerNeeded(pendtie)
                        dierSpawn = false
                        bezig = false
                        timer = math.random(15, 30)
                        return
                    end
    
                    -- Zit in auto (stop)
                    if IsPedSittingInAnyVehicle(ped) then
                        QBCore.Functions.Notify("In de auto? Zo kan ik het ook, geef die hond maar terug en zoek iemand anders!", "error")
                        RemoveBlip(DeurBlip)
                        RemoveBlip(einde)
                        DeleteEntity(dierntie)
                        SetPedAsNoLongerNeeded(pendtie)
                        dierSpawn = false
                        bezig = false
                        timer = math.random(15, 30)
                        return
                    end
                end
            else
                if GetDistanceBetweenCoords(pos, deurLocatie["deur"].x, deurLocatie["deur"].y, deurLocatie["deur"].z) < 3 then
                    letsleep = false
                    QBCore.Functions.DrawText3D(deurLocatie["deur"].x, deurLocatie["deur"].y, deurLocatie["deur"].z + 0.4, "~r~E~w~ - Hond terugbrengen")
                    if IsControlJustPressed (0, 38) then
                        TriggerServerEvent("fortis-hondjes:server:krijggeld")
                        RemoveBlip(DeurBlip)
                        DeleteEntity(dierntie)
                        SetPedAsNoLongerNeeded(pendtie)
                        dierSpawn = false
                        bezig = false
                        timer = math.random(15, 30)
                        return
                    end
                end
            end
    
            if letsleep then
                Citizen.Wait(500)
            end
        end
    end
end)

-- Functies
function LoopPed()
    local ped = GetPlayerPed(-1)
    local group = math.random(000000000000000,99999999999999)

    ClearPedTasks(dierntie)
    TaskSetBlockingOfNonTemporaryEvents(dierntie, true)
    SetPedAsGroupLeader(ped, group)
    SetPedAsGroupMember(dierntie, group)
    TaskFollowToOffsetOfEntity(dierntie, ped, 0.5, 0.0, 0.0, 100.0, -1, 0.0, 1)
    SetPedNeverLeavesGroup(dierntie, true)
    SetPedCanBeTargetted(dierntie, false)
    SetEntityAsMissionEntity(dierntie, true,true)
    SetGroupSeparationRange(group, 1.9)
end