QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
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


Citizen.CreateThread(function()
    local kaasje = false

    while true do
        Citizen.Wait(1)
        while PlayerData == nil do Wait(500) end
        while PlayerData.job == nil do Wait(500) end
        if PlayerData.job.name == "slotenmaker" then
            if not kaasje then
                winkelBlip = AddBlipForCoord(Config.winkel.x, Config.winkel.y, Config.winkel.z)
                SetBlipSprite(winkelBlip, 134)
                SetBlipColour(winkelBlip, 46)
                SetBlipScale(winkelBlip, 0.8)
                SetBlipAsShortRange(winkelBlip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Slotenmaker")
                EndTextCommandSetBlipName(winkelBlip)
                kaasje = true
            end
        else
            kaasje = false
            RemoveBlip(winkelBlip)
            Citizen.Wait(2000)
        end
    end
end)


NPCSpawn = true
starten = false
bezig = false
lockpicked = false
successLockpick = false
kangoo = false
vrijMail = true
successvervangen = false
vervangen = false
text = true
kaas = true
success = false
hackPraat = true
praten = false
gehaald = false


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        letsleep = true

        while PlayerData == nil do Wait(500) end
        while PlayerData.job == nil do Wait(500) end
        if PlayerData.job.name == "slotenmaker" then
            local pedPos = GetEntityCoords(GetPlayerPed(-1))
            if GetDistanceBetweenCoords(pedPos, Config.winkel.x, Config.winkel.y, Config.winkel.z, false) <6 then
                letsleep = false
                DrawMarker(2, Config.winkel.x, Config.winkel.y, Config.winkel.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 125, 195, 37, 155, false, false, false, true, false, false, false)
                if GetDistanceBetweenCoords(pedPos, Config.winkel.x, Config.winkel.y, Config.winkel.z, false) <3 then
                    if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        if not bezig then
                            QBCore.Functions.DrawText3D(Config.StartMarker.x, Config.StartMarker.y, Config.StartMarker.z + 0.20, "~g~[E]~w~ Aan het werk!")

                            if IsControlJustPressed(0, 38) and not bezig then
                                starten = true
                                TriggerEvent("zb-sleutelmaker:client:startWerk")
                                QBCore.Functions.Notify("Wil je gebruik maken van de bedrijfsauto druk dan op G", "success", 2500)
                                bezig = true
                            end

                            if kangoo then
                                QBCore.Functions.DrawText3D(Config.StartMarker.x, Config.StartMarker.y, Config.StartMarker.z, "~g~[G]~w~ Bedrijfs auto inleveren")
                                if IsControlJustPressed(0, 47) then
                                    DeleteVehicle(voertuig2)
                                    kangoo = false
                                    Citizen.Wait(10)
                                end
                            end
                        else
                            QBCore.Functions.DrawText3D(Config.StartMarker.x, Config.StartMarker.y, Config.StartMarker.z + 0.20, "Stoppen met werken ~g~[E]~w~")
                            if IsControlJustPressed(0, 38) then
                                DeleteEntity(NPC)
                                bezig = false
                                QBCore.Functions.Notify("Je hebt je jas opgehangen! Tot de volgende keer!")
                                RemoveBlip(locatieBlip)
                                starten = false
                                vrijMail = true
                            end

                            if kangoo then
                                QBCore.Functions.DrawText3D(Config.StartMarker.x, Config.StartMarker.y, Config.StartMarker.z, "~g~[G]~w~ Bedrijfs auto inleveren")
                                if IsControlJustPressed(0, 47) then
                                    DeleteVehicle(voertuig2)
                                    kangoo = false
                                    Citizen.Wait(10)
                                end
                            end
                        end
                        if GetDistanceBetweenCoords(pedPos,  Config.StartMarker.x, Config.StartMarker.y, Config.StartMarker.z, false) <6 then
                            if IsControlJustPressed(0, 47) and bezig then
                                local nummer = math.random(1, 200)
                                local spawnLocatie = {x = 175.32, y = -1805.80, z = 29.14, h = 228.5}

                                QBCore.Functions.SpawnVehicle("kangoo", function(voertuig)
                                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(voertuig))
                                    exports['LegacyFuel']:SetFuel(voertuig, 100)
                                    SetEntityHeading(voertuig, spawnLocatie.h)
                                    SetVehicleDoorsLocked(voertuig, 2) 
                                    voertuig2 = voertuig
                                end, spawnLocatie, true)
                                QBCore.Functions.Notify("Pak de bedrijfs auto en veel succes!", "success")
                                kangoo = true
                            end
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

AddEventHandler("zb-sleutelmaker:client:startWerk", function()
    local nietGebruikt = true

    if starten then
        letsleep = false
        local Afzender = math.random(1, #Config.Afzender)
        local Afzender = Config.Afzender[Afzender].afzender

        
        local aantal = math.random(9000, 20000)
        if vrijMail then
            Citizen.Wait(aantal)
            TriggerServerEvent("qb-phone:server:sendNewMail", {
                sender = Afzender,
                subject = "Slotenmaker nodig!",
                message = "Ik heb een slotenmaker op locatie nodig, ik heb gehoord dat jullie snel kunnen komen dus daarom benader ik jullie! Tot zo!",
                button = {
                    enabled = true,
                    buttonEvent = "zb-sleutelmaker:client:acepteer", Oorzaak1
                }
            })
            vrijMail = false
            return
        end
    end
end)

AddEventHandler("zb-sleutelmaker:client:acepteer", function(Oorzaak1)
    if starten then
        DeleteEntity(NPC)
        Citizen.Wait(10)
        DeleteEntity(NPC)

        uitleg = math.random(1, #Config.Uitleg)
        locatie = math.random(1, #Config.huisLocatie)
        gekozenUitleg = Config.Uitleg[uitleg]
        gekozenVoordeur = Config.Voordeur[locatie]
        tekst = gekozenUitleg.uitleg
        voordeur = gekozenVoordeur.locatie
        if uitleg == 1 or uitleg == 2 then
            locatie2 = Config.huisLocatie[locatie]
            locatie3 = locatie2.locatie
        elseif uitleg == 3 then
            locatieBeveiliging = math.random(1, #Config.beveiligingLocatie)
            beveiligingPad1 = Config.beveiligingPad[locatieBeveiliging]
            locatie2 = Config.beveiligingLocatie[locatieBeveiliging]
            locatie3 = locatie2.locatie
            beveiligingPad = beveiligingPad1.beveiligingPad
        end
        if locatieBeveiliging == nil then
            locatieBeveiliging = 2
        else
            locatieBeveiliging = locatieBeveiliging
        end
        NPCSpawn = true
        
        locatieBlip = AddBlipForCoord(locatie3.x, locatie3.y, locatie3.z)
        SetBlipColour(locatieBlip, 44)
        SetBlipRoute(locatieBlip, true)
        SetBlipRouteColour(locatieBlip, 44)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Adres")
        EndTextCommandSetBlipName(locatieBlip)


        while true do
            Citizen.Wait(1)
            letsleep = true
            local pedPos = GetEntityCoords(GetPlayerPed(-1))

            if GetDistanceBetweenCoords(pedPos, locatie3.x, locatie3.y, locatie3.z, false) <50 and starten then
                letsleep = false
                if NPCSpawn then
                    Citizen.Wait(500)
                    local randomHash = math.random(1, #Config.NPC)
                    local npcHash = Config.NPC[randomHash].model
                    local hash = GetHashKey(npcHash)
                    RequestModel(hash)

                    while not HasModelLoaded(hash) do
                        Wait(1)
                    end
                
                    NPC = CreatePed(4, hash, locatie3.x, locatie3.y, locatie3.z, locatie3.h, false, true)
                
                    FreezeEntityPosition(NPC, true)    
                    SetEntityInvincible(NPC, true)
                    SetBlockingOfNonTemporaryEvents(NPC, true)

                    NPCSpawn = false
                end

                if GetDistanceBetweenCoords(pedPos, locatie3.x, locatie3.y, locatie3.z, false) < 2 then
                    QBCore.Functions.DrawText3D(locatie3.x, locatie3.y, locatie3.z + 1.00, "~g~[E]~w~ Praten")
                    RemoveBlip(locatieBlip)
                    if IsControlJustPressed(0, 38) then
                        QBCore.Functions.Notify("Dit is er gebeurd: " ..tekst.."!", "success", 5000)
                        Citizen.Wait(2500)
                        TriggerEvent("zb-sleutelmaker:client:startWerk2", gekozenUitleg, gekozenVoordeur, uitleg, locatie, locatieBeveiliging)
                        return
                    end    
                end
            end
            if letsleep then
                Citizen.Wait(1000)
            end
        end
    end
end)

AddEventHandler("zb-sleutelmaker:client:startWerk2", function(gekozenUitleg, gekozenVoordeur, uitleg, locatie, locatieBeveiliging)
    local voordeur = gekozenVoordeur.locatie
    local locatie2 = Config.huisLocatie[locatie]
    local locatie3 = locatie2.locatie

    local locatietje = Config.beveiligingLocatie[locatieBeveiliging]
    local locatie4 = locatietje.locatie
    local beveiligingPad1 = Config.beveiligingPad[locatieBeveiliging]
    local beveiligingPad = beveiligingPad1.beveiligingPad

    while true do
        Citizen.Wait(1)
        letsleep = true
        local pedPos = GetEntityCoords(GetPlayerPed(-1))
        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            if uitleg == 1 then
                if not lockpicked then
                    if GetDistanceBetweenCoords(pedPos, voordeur.x, voordeur.y, voordeur.z, false) <2 then
                        letsleep = false
                        DrawMarker(2, voordeur.x, voordeur.y, voordeur.z + 1.00, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 125, 195, 37, 155, false, false, false, true, false, false, false)
                        QBCore.Functions.DrawText3D(voordeur.x, voordeur.y, voordeur.z + 1.20, "~g~[E]~w~ Begin het werk!")
                        QBCore.Functions.DrawText3D(voordeur.x, voordeur.y, voordeur.z + 1.00, "~g~[G]~w~ Geef het op")

                        if IsControlJustPressed(0, 38) then
                            TriggerEvent('qb-lockpick:client:openLockpick', lockpickFinish)
                        end
                        if IsControlJustPressed(0, 47) then
                            QBCore.Functions.Notify('Je hebt het opgegeven, leg het uit bij de klant...', 'error')
                            lockpicked = true
                            successLockpick = false
                        end
                    end
                else
                    if GetDistanceBetweenCoords(pedPos, locatie3.x, locatie3.y, locatie3.z, false) <2 then
                        letsleep = false
                        QBCore.Functions.DrawText3D(locatie3.x, locatie3.y, locatie3.z + 1.00, "~g~[E]~w~ Praten")
                        if IsControlJustPressed(0, 38) and successLockpick then
                            lockpicked = false
                            successLockpick = false
                            vrijMail = true
                            NPCSpawn = false
                            letsleep = true
                            FreezeEntityPosition(NPC, false)    
                            SetEntityInvincible(NPC, false)
                            TriggerEvent("zb-sleutelmaker:client:startWerk")
                            if math.random(1, 10) ~= 8 then
                                TriggerServerEvent("zb-sleutelmaker:server:successBetaald")
                                return
                            else
                                TriggerServerEvent("zb-sleutelmaker:server:successBetaaldExtra")
                                return
                            end
                        elseif IsControlJustPressed(0, 38) and not successLockpick then
                            QBCore.Functions.Notify("Lekker dan... ik zoek wel een ander...", 'error')
                            lockpicked = false
                            successLockpick = false
                            vrijMail = true
                            NPCSpawn = false
                            letsleep = true
                            FreezeEntityPosition(NPC, false)    
                            SetEntityInvincible(NPC, false)
                            TriggerEvent("zb-sleutelmaker:client:startWerk")
                            return
                        end
                    end
                end
            elseif uitleg == 2 then
                if not vervangen and text then
                    if GetDistanceBetweenCoords(pedPos, voordeur.x, voordeur.y, voordeur.z, false) <2 and kaas then
                        letsleep = false
                        DrawMarker(2, voordeur.x, voordeur.y, voordeur.z + 1.00, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 125, 195, 37, 155, false, false, false, true, false, false, false)
                        QBCore.Functions.DrawText3D(voordeur.x, voordeur.y, voordeur.z + 1.20, "~g~[E]~w~ Begin te vervangen!")
                        QBCore.Functions.DrawText3D(voordeur.x, voordeur.y, voordeur.z + 1.00, "~g~[G]~w~ Geef het vervangen op")

                        if IsControlJustPressed(0, 38) then
                            Citizen.Wait(10)
                            kaas = false
                            slotVervangen()
                        end

                        if IsControlJustPressed(0, 47) then
                            QBCore.Functions.Notify('Je hebt het opgegeven, leg het uit bij de klant...', 'error')
                            vervangen = false
                            successvervangen = false
                            text = false
                        end
                    end
                else 
                    if GetDistanceBetweenCoords(pedPos, locatie3.x, locatie3.y, locatie3.z, false) <2 and not text then
                        letsleep = false
                        QBCore.Functions.DrawText3D(locatie3.x, locatie3.y, locatie3.z + 1.00, "~g~[E]~w~ Praten")
                        if vervangen then
                            if IsControlJustPressed(0, 38) then
                                if math.random(1, 8) ~= 8 then
                                    TriggerServerEvent("zb-sleutelmaker:server:successBetaald", vervangen)
                                    vrijMail = true
                                    NPCSpawn = false
                                    vervangen = false
                                    text = true
                                    kaas = true
                                    FreezeEntityPosition(NPC, false)    
                                    SetEntityInvincible(NPC, false)
                                    TriggerEvent("zb-sleutelmaker:client:startWerk")
                                    return
                                else
                                    TriggerServerEvent("zb-sleutelmaker:server:successBetaaldExtra", vervangen)
                                    letsleep = true
                                    vrijMail = true
                                    NPCSpawn = false
                                    vervangen = false
                                    text = true
                                    kaas = true
                                    FreezeEntityPosition(NPC, false)    
                                    SetEntityInvincible(NPC, false)
                                    TriggerEvent("zb-sleutelmaker:client:startWerk")
                                    return
                                end
                            end
                        elseif IsControlJustPressed(0, 38) then
                            QBCore.Functions.Notify('Lekker dan, ik zoek wel een ander...', 'error')
                            letsleep = true
                            vrijMail = true
                            NPCSpawn = false
                            TriggerEvent("zb-sleutelmaker:client:startWerk")
                            vervangen = false
                            text = true
                            kaas = true
                            return
                        end
                    end
                end
            elseif uitleg == 3 then
                letsleep = false

                local pedCoords = GetEntityCoords(GetPlayerPed(-1))
                if GetDistanceBetweenCoords(locatie4.x, locatie4.y, locatie4.z , pedCoords.x, pedCoords.y, pedCoords.z, false) <50 then
                    if NPCSpawn then
                        Citizen.Wait(500)
                        local randomHash = math.random(1, #Config.NPC)
                        local npcHash = Config.NPC[randomHash].model
                        local hash = GetHashKey(npcHash)
                        RequestModel(hash)
    
                        while not HasModelLoaded(hash) do
                            Wait(1)
                        end
                    
                        NPC = CreatePed(4, hash, locatie3.x, locatie3.y, locatie3.z, locatie3.h, false, true)
                    
                        FreezeEntityPosition(NPC, true)    
                        SetEntityInvincible(NPC, true)
                        SetBlockingOfNonTemporaryEvents(NPC, true)
    
                        NPCSpawn = false
                        praten = true
                    end
                end
                if praten then
                    if GetDistanceBetweenCoords(locatie4.x, locatie4.y, locatie4.z , pedCoords.x, pedCoords.y, pedCoords.z, false) <2 then
                        QBCore.Functions.DrawText3D(locatie4.x, locatie4.y, locatie4.z, "~g~[E]~w~ Praten")
                        if IsControlPressed(0, 38) then
                            QBCore.Functions.Notify('Het systeem is gehacked, ik heb je nodig om het terug te hacken', 'success')
                            hackPraat = true
                            praten = false
                        end
                    end
                end
                if hackPraat then
                    if GetDistanceBetweenCoords(beveiligingPad.x, beveiligingPad.y, beveiligingPad.z , pedCoords.x, pedCoords.y, pedCoords.z, false) <2 then
                        QBCore.Functions.DrawText3D(beveiligingPad.x, beveiligingPad.y, beveiligingPad.z, "~g~[E]~w~ Hacken")
                        if IsControlJustPressed(0, 38) then
                            QBCore.Functions.Progressbar("leipetorrie", "Apparatuur aan het connecten...", math.random(4000, 5000), false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "cellphone@",
                                anim = "cellphone_text_read_base",
                                flags = 3,
                            }, {}, {}, function() -- Done
                                ClearPedTasks(GetPlayerPed(-1))
                                hackPraat = false
                                TriggerEvent("mhacking:show")
                                TriggerEvent("mhacking:start", math.random(4, 7), math.random(20, 30), OnHackDone)
                                ClearPedTasksImmediately(ped)
                                FreezeEntityPosition(ped, false)
                            end)
                        end
                    end
                end
                if gehaald then
                    QBCore.Functions.DrawText3D(locatie4.x, locatie4.y, locatie4.z + 1, "~g~[E]~w~ Praten")
                    if IsControlJustPressed(0, 38) then
                        if math.random(1, 8) ~= 8 then
                            TriggerServerEvent("zb-sleutelmaker:server:successBetaald")
                            vrijMail = true
                            NPCSpawn = false
                            vervangen = false
                            text = true
                            kaas = true
                            hackPraat = true
                            praten = false
                            gehaald = false
                            FreezeEntityPosition(NPC, false)    
                            SetEntityInvincible(NPC, false)
                            TriggerEvent("zb-sleutelmaker:client:startWerk")
                            return
                        else
                            TriggerServerEvent("zb-sleutelmaker:server:successBetaaldExtra")
                            letsleep = true
                            vrijMail = true
                            NPCSpawn = false
                            vervangen = false
                            text = true
                            kaas = true
                            hackPraat = true
                            praten = false
                            gehaald = false
                            FreezeEntityPosition(NPC, false)    
                            SetEntityInvincible(NPC, false)
                            TriggerEvent("zb-sleutelmaker:client:startWerk")
                            return
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

slotVervangen = function()
    local Skillbar = exports['zb-skillbar']:GetSkillbarObject()

    local SucceededAttempts = 0
    local NeededAttempts = math.random(2, 5)
    
    local ped = GetPlayerPed(-1)
    local pedPositie= GetEntityCoords(ped)

    if not vervangen then
        RequestAnimDict("mini@repair")
        TaskPlayAnim(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 8.0, -8, -1, 3, 0, 0, 0, 0)
        Skillbar.Start({
            duration = math.random(1400, 1700),
            pos = math.random(10, 40),
            width = math.random(9, 13),
        }, function()
            if SucceededAttempts + 1 >= NeededAttempts then
                ClearPedTasks(ped)
                SucceededAttempts = 0
                vervangen = true
                text = false
                successLockpick = true
                QBCore.Functions.Notify('Het is je gelukt, ga met de klant praten!', 'success')
            else
                Skillbar.Repeat({
                    duration = math.random(1100, 1400),
                    pos = math.random(10, 40),
                    width = math.random(9, 12),
                })
                SucceededAttempts = SucceededAttempts + 1
            end
        end, function()
            QBCore.Functions.Notify('Niet gelukt... probeer het nog eens', 'error')
            ClearPedTasksImmediately(ped)
            SucceededAttempts = 0
            vervangen = false
            text = true
            kaas = true
        end)
    end
end

function lockpickFinish(success)
    if success then
		QBCore.Functions.Notify('Het is je gelukt, ga met de klant praten!', 'success')
        lockpicked = true
        successLockpick = true
    else
        QBCore.Functions.Notify('Niet gelukt... probeer het nog eens', 'error')

    end
end

function OnHackDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        QBCore.Functions.Notify('Super! We kunnen weer naar binnen! Dankjewel! Je kan je betaling bij me ophalen', 'success')
        gehaald = true
        hackPraat = false
        return
    else
		TriggerEvent('mhacking:hide')
        ClearPedTasksImmediately(GetPlayerPed(-1))
        QBCore.Functions.Notify("Dat ging niet helemaal goed, schiet op!", "error")
        hackPraat = true
	end
end