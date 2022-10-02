QBCore = nil
Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

-- Global variables
local groothandel = nil
local groothandelHandelData = nil
local groothandelBlip = nil

local groothandelWerknemers = nil -- Alleen voor eigenaren bruhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
local groothandelEigenaar = false

local enteringMagazijn = false
local inMagazijnData = nil
local magazijnShellHash = nil
local spotKeyID = nil


-- Na het kiezen van karakter / restarten van script data ophalen
RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    Wait(5000)
    TriggerServerEvent("zb-groothandel:server:playerLoggedIn")
end)

-- NIET VERGETEN TE VERWIJDEREN
-- NIET VERGETEN TE VERWIJDEREN
-- NIET VERGETEN TE VERWIJDEREN
-- NIET VERGETEN TE VERWIJDEREN
-- NIET VERGETEN TE VERWIJDEREN
-- NIET VERGETEN TE VERWIJDEREN
-- NIET VERGETEN TE VERWIJDEREN
-- NIET VERGETEN TE VERWIJDEREN
-- NIET VERGETEN TE VERWIJDEREN
-- NIET VERGETEN TE VERWIJDEREN
AddEventHandler("onResourceStart", function(resourceName) -- Dev shit only
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    Wait(1000)
    print("Script restart!")

    -- Alle data ophalen
    TriggerServerEvent("zb-groothandel:server:playerLoggedIn")
end)

-- Laptop sluiten
RegisterNUICallback("sluitLaptop", function(data)
    SetNuiFocus(false, false)
end)

-- Groothandel kopen via makelaar
RegisterNUICallback("koopGroothandel", function()
    TriggerServerEvent("zb-groothandel:server:koopGroothandel")
end)

-- Groothandel syncen vanaf server side
RegisterNetEvent("zb-groothandel:client:syncMagazijn")
AddEventHandler("zb-groothandel:client:syncMagazijn", function(tmp_groothandel_data)
    if tmp_groothandel_data ~= nil then

        if groothandel ~= nil then
            -- Heeft al een groothandel INGELADEN, dit is alleen een sync!
            print("[DEV] syncMagazijn binnengekomen...")
            tmp_groothandel_data.data = json.decode(tmp_groothandel_data.data)
            groothandel = tmp_groothandel_data
            if groothandelEigenaar then
                groothandel.werknemer = false
            end

            -- Sync naar laptop live sync yeet
            local specialisatieNamen = {}
            for k, v in pairs(tmp_groothandel_data.data.specialisaties) do
                local tmp_table_tmp_tmp = {nummer = v, naam = Config.categorieen[v].label}
                table.insert(specialisatieNamen, tmp_table_tmp_tmp)
            end
            SendNUIMessage({
                type = "openLaptop",
                handelAppData = json.encode(groothandelHandelData),
                groothandelData = json.encode(groothandel),
                werknemersData = json.encode(groothandelWerknemers),
                specialisatieData = json.encode(specialisatieNamen),

                syncOnly = true
            })

            -- Herplaats alle opslag kisten
            updateRekken()
        else
            -- Heeft nog geen groothandel INGELADEN, zet alles op kaart etc.
            if not tmp_groothandel_data.werknemer then
                groothandelEigenaar = true
            end
            tmp_groothandel_data.data = json.decode(tmp_groothandel_data.data)
            groothandel = tmp_groothandel_data

            groothandelBlip = AddBlipForCoord(groothandel.data.coords["deur"].x, groothandel.data.coords["deur"].y, groothandel.data.coords["deur"].z)
            SetBlipSprite(groothandelBlip, 569)
            SetBlipScale(groothandelBlip, 0.8)
            SetBlipColour(groothandelBlip, 50)
            SetBlipAsShortRange(groothandelBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Groothandel magazijn")
            EndTextCommandSetBlipName(groothandelBlip)
        end
    end
end)

RegisterNetEvent("zb-groothandel:client:syncWerknemers")
AddEventHandler("zb-groothandel:client:syncWerknemers", function(tmp_werknemer_data)
    if tmp_werknemer_data ~= nil then
        groothandelWerknemers = json.decode(tmp_werknemer_data)

        -- Sync naar laptop live sync yeet
        local specialisatieNamen = {}
        if groothandel ~= nil then
            for k, v in pairs(groothandel.data.specialisaties) do
                local tmp_table_tmp_tmp = {nummer = v, naam = Config.categorieen[v].label}
                table.insert(specialisatieNamen, tmp_table_tmp_tmp)
            end
        end
        SendNUIMessage({
            type = "openLaptop",
            handelAppData = json.encode(groothandelHandelData),
            groothandelData = json.encode(groothandel),
            werknemersData = json.encode(groothandelWerknemers),
            specialisatieData = json.encode(specialisatieNamen),

            syncOnly = true
        })
    end
end)

-- Ontvangst als de speler ontslagen wordt (leeg magazijdnata)
RegisterNetEvent("zb-groothandel:client:spelerOntslagen")
AddEventHandler("zb-groothandel:client:spelerOntslagen", function()
    if inMagazijnData ~= nil then
        -- Persoon zit in magazijn, zet zn moeder eruit en despawn
        SetEntityCoords(PlayerPedId(), groothandel.data.coords["deur"].x, groothandel.data.coords["deur"].y, groothandel.data.coords["deur"].z)
        despawnGroothandel()
    end
    RemoveBlip(groothandelBlip)
    groothandel = nil
    groothandelHandelData = nil
    groothandelBlip = nil
    enteringMagazijn = false
    inMagazijnData = nil
    magazijnShellHash = nil
    SendNUIMessage({
        type = "ontslagenQuit"
    })

    QBCore.Functions.Notify("Je bent ontslagen uit de groothandel!", "error", 9500)

end)

-- Groot handel specialisaties of handel data wordt opnieuw gegenereerd, sync!
RegisterNetEvent("zb-groothandel:client:syncMagazijnHandelData")
AddEventHandler("zb-groothandel:client:syncMagazijnHandelData", function(tmp_groothandelHandel_data)
    if tmp_groothandelHandel_data ~= nil then
        groothandelHandelData = tmp_groothandelHandel_data
        print("[DEV] Handel app sync ontvangen")
        SendNUIMessage({
            type = "syncHandelApp",
            handelAppData = json.encode(groothandelHandelData)
        })
    end
end)

-- Werknemer aannemen
RegisterNUICallback("werknemerAannemen", function(data, cb)
    if data.bsn ~= nil then
        QBCore.Functions.TriggerCallback("zb-groothandel:server:werknemerAannemen", function(resultaat, bericht)
            if resultaat == true then
                local tmp_table = {
                    ["resultaat"] = true,
                    ["bericht"] = bericht
                }
                cb(tmp_table)
            else
                local tmp_table = {
                    ["resultaat"] = false,
                    ["bericht"] = bericht
                }
                cb(tmp_table)
            end
        end, data.bsn, groothandel.id)
    else
        cb(false)
    end
end)

-- Werknemer ontslaan
RegisterNUICallback("werknemerOntslaan", function(data, cb)
    if data.cid ~= nil then
        TriggerServerEvent("zb-groothandel:server:werknemerOntslaan", data.cid, groothandel.id)
    end
end)

AddEventHandler("zb-groothandel:client:joinGroothandel", function(magazijnInviteData)
    if magazijnInviteData ~= nil then
        TriggerServerEvent("zb-groothandel:server:joinGroothandel", magazijnInviteData.magazijnID)
    else
        QBCore.Functions.Notify("Er is iets fout gegaan, vraag een nieuwe uitnodiging aan!", "error", 6500)
    end
end)

-- Werknemer slot bijkopen
RegisterNUICallback("koopWerknemerSlot", function(data, cb)
    if groothandelEigenaar and groothandel ~= nil then
        if groothandel.data.werknemerspots < 5 then
            TriggerServerEvent("zb-groothandel:server:koopWerknemerSlot", groothandel.id)
        else
            QBCore.Functions.Notify("Je hebt al het maximaal aantal werknemer spots!", "error")
        end
    end
end)

RegisterNUICallback("balansOpnemen", function(data, cb)
    if groothandelEigenaar and groothandel ~= nil then
        TriggerServerEvent("zb-groothandel:server:balansOpnemen")
    end
end)

RegisterNUICallback("koopVoertuig", function(data, cb)
    if groothandelEigenaar and groothandel ~= nil then
        TriggerServerEvent("zb-groothandel:server:koopVoertuig", data.voertuig)
    end
end)

RegisterNUICallback("veranderSpecialisaties", function (data, cb)
    if groothandelEigenaar and groothandel ~= nil then
        TriggerServerEvent("zb-groothandel:server:veranderSpecialisaties", groothandel.id)
    end
end)

-- Loop om groothandel binnen te gaan
Citizen.CreateThread(function()
    while true do
        Wait(1)
        letsleep = true
        if groothandel ~= nil then
            -- Heeft groothandel
            local pedCoords = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(pedCoords, groothandel.data.coords["deur"].x, groothandel.data.coords["deur"].y, groothandel.data.coords["deur"].z, true) < 15 then
                letsleep = false
                DrawMarker(2, groothandel.data.coords["deur"].x, groothandel.data.coords["deur"].y, groothandel.data.coords["deur"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                if GetDistanceBetweenCoords(pedCoords, groothandel.data.coords["deur"].x, groothandel.data.coords["deur"].y, groothandel.data.coords["deur"].z, true) < 1.5 then
                    QBCore.Functions.DrawText3D(groothandel.data.coords["deur"].x, groothandel.data.coords["deur"].y, groothandel.data.coords["deur"].z + 0.2, "~g~[E]~w~ Magazijn betreden")
                    if IsControlJustPressed(0, 38) and not enteringMagazijn then
                        enteringMagazijn = true
                        QBCore.Functions.TriggerCallback("zb-groothandel:server:getMagazijnSpots", function(_spotKeyID)
                            if _spotKeyID ~= nil then
                                spotKeyID = _spotKeyID
                                -- Begin
                                if groothandelHandelData == nil then
                                    TriggerServerEvent("zb-groothandel:server:vraagHandelData", groothandel.id)
                                end
                                QBCore.Functions.Notify("Je gaat naar binnen...", "success")
                                print("[DEV] Magazijn ID: "..spotKeyID)
                                
                                DoScreenFadeOut(500)
                                while not IsScreenFadedOut() do
                                    Citizen.Wait(10)
                                end
                                RequestModel(`shell_warehouse2`)
                                while not HasModelLoaded(`shell_warehouse2`) do
                                    Citizen.Wait(1000)
                                end
                                
                                local shellConfigData = Config.shellSpots[spotKeyID]
                                local tmp_shell = CreateObject(`shell_warehouse2`, shellConfigData.x, shellConfigData.y, shellConfigData.z, false, false, false)
                                magazijnShellHash = tmp_shell
                                FreezeEntityPosition(tmp_shell, true)

                                -- Spawn tafel, laptop etc.
                                local tmp_tafel_coords = GetOffsetFromEntityInWorldCoords(tmp_shell, -12.29254, 0.3675537, -3.059021)
                                local tmp_tafel = CreateObject(`bkr_prop_weed_table_01b`, tmp_tafel_coords.x, tmp_tafel_coords.y, tmp_tafel_coords.z, false, false, false)
                                SetEntityHeading(tmp_tafel, 92.25)
                                FreezeEntityPosition(tmp_shell, true)

                                local tmp_laptop_coords = GetOffsetFromEntityInWorldCoords(tmp_shell, -12.29254, 0.3675537, -2.240000)
                                local tmp_laptop = CreateObject(`p_laptop_02_s`, tmp_laptop_coords.x, tmp_laptop_coords.y, tmp_laptop_coords.z, false, false, false)
                                SetEntityHeading(tmp_laptop, 92.25)
                                FreezeEntityPosition(tmp_laptop, true)

                                -- Kanker rekken
                                -- local tmp_rek_coords = GetOffsetFromEntityInWorldCoords(tmp_shell, -5.00, 7.79, -3.05)
                                -- local tmp_rek = CreateObject(`imp_prop_impexp_rack_01a`, tmp_rek_coords.x, tmp_rek_coords.y, tmp_rek_coords.z, false, false, false)
                                -- SetEntityHeading(tmp_rek, 270.0)
                                -- FreezeEntityPosition(tmp_rek, true)
                                local tmp_alleMagazijnRekken = {}
                                for k, v in pairs (Config.rekkenPOIS) do
                                    local tmp_rek_coords = GetOffsetFromEntityInWorldCoords(tmp_shell, v.x, v.y, v.z)
                                    local tmp_rek = CreateObject(`imp_prop_impexp_rack_01a`, tmp_rek_coords.x, tmp_rek_coords.y, tmp_rek_coords.z, false, false, false)
                                    SetEntityHeading(tmp_rek, v.h)
                                    FreezeEntityPosition(tmp_rek, true)
                                    table.insert(tmp_alleMagazijnRekken, tmp_rek) -- Zet in tabel dingus
                                end
                                

                                -- Spawn de voertuigen die het lab heeft
                                -- Vrachtwagen
                                local tmp_vrachtwagen_coords = GetOffsetFromEntityInWorldCoords(tmp_shell, 9.38, -4.58, -2.82)
                                local tmp_vrachtwagen = nil

                                if groothandel.data.voertuigen.vrachtwagen then

                                    RequestModel(GetHashKey("mule"))
                                    while not HasModelLoaded(GetHashKey("mule")) do
                                        Citizen.Wait(10)
                                    end

                                    tmp_vrachtwagen = CreateVehicle(GetHashKey("mule"), tmp_vrachtwagen_coords.x, tmp_vrachtwagen_coords.y, tmp_vrachtwagen_coords.z, 37.85, false, false)
                                    SetVehicleDoorsLocked(tmp_vrachtwagen, 2)
                                    SetVehicleHasBeenOwnedByPlayer(tmp_vrachtwagen, true)
                                    SetModelAsNoLongerNeeded(tmp_vrachtwagen)
                                    FreezeEntityPosition(tmp_vrachtwagen, true)
                                end
                                -- Busje
                                local tmp_busje_coords = GetOffsetFromEntityInWorldCoords(tmp_shell, 5.00, -5.41, -3.27)
                                local tmp_busje = nil

                                if groothandel.data.voertuigen.busje then

                                    RequestModel(GetHashKey("pony"))
                                    while not HasModelLoaded(GetHashKey("pony")) do
                                        Citizen.Wait(10)
                                    end

                                    tmp_busje = CreateVehicle(GetHashKey("pony"), tmp_busje_coords.x, tmp_busje_coords.y, tmp_busje_coords.z, 37.85, false, false)
                                    SetVehicleDoorsLocked(tmp_busje, 2)
                                    SetVehicleHasBeenOwnedByPlayer(tmp_busje, true)
                                    SetModelAsNoLongerNeeded(tmp_busje)
                                    FreezeEntityPosition(tmp_busje, true)
                                end
                                -- Auto
                                local tmp_auto_coords = GetOffsetFromEntityInWorldCoords(tmp_shell, 1.81, -6.69, -3.86)
                                local tmp_auto = nil

                                if groothandel.data.voertuigen.auto then

                                    RequestModel(GetHashKey("brioso"))
                                    while not HasModelLoaded(GetHashKey("brioso")) do
                                        Citizen.Wait(10)
                                    end

                                    tmp_auto = CreateVehicle(GetHashKey("brioso"), tmp_auto_coords.x, tmp_auto_coords.y, tmp_auto_coords.z, 37.85, false, false)
                                    SetVehicleDoorsLocked(tmp_auto, 2)
                                    SetVehicleHasBeenOwnedByPlayer(tmp_auto, true)
                                    SetModelAsNoLongerNeeded(tmp_auto)
                                    FreezeEntityPosition(tmp_auto, true)
                                end



                                local PlayerSpawn = GetOffsetFromEntityInWorldCoords(tmp_shell, -12.37964, 5.582153, -3.059174)
                                SetEntityCoords(PlayerPedId(), PlayerSpawn.x, PlayerSpawn.y, PlayerSpawn.z, 0, 0, 0, false)
                                SetEntityHeading(PlayerPedId(), 273.00)
                                Citizen.Wait(100)
                                DoScreenFadeIn(1000)

                                inMagazijnData = {
                                    ["tafel"] = tmp_tafel,
                                    ["rekken"] = tmp_alleMagazijnRekken,
                                    ["vrachtwagen"] = {x = tmp_vrachtwagen_coords.x, y = tmp_vrachtwagen_coords.y, z = tmp_vrachtwagen_coords.z, entity = tmp_vrachtwagen},
                                    ["busje"] = {x = tmp_busje_coords.x, y = tmp_busje_coords.y, z = tmp_busje_coords.z, entity = tmp_busje},
                                    ["auto"] = {x = tmp_auto_coords.x, y = tmp_auto_coords.y, z = tmp_auto_coords.z, entity = tmp_auto},
                                    ["laptop"] = {x = tmp_laptop_coords.x, y = tmp_laptop_coords.y, z = tmp_laptop_coords.z, entity = tmp_laptop},
                                    ["exit"] = {x = PlayerSpawn.x, y = PlayerSpawn.y, z = PlayerSpawn.z + 1}
                                }

                                TriggerEvent("zb-weathersync:client:regenUit", true)
                                updateRekken()
                                enteringMagazijn = false
                                -- Eind
                            end
                        end, groothandel.id)
                    end
                end
            end
        end

        if letsleep then
            Wait(1500)
        end
    end
end)

-- Loop die gedraaid wordt als je in een magazijn bent voor markers etc.
Citizen.CreateThread(function()
    while true do
        Wait(1)
        letsleep = false

        if groothandel ~= nil and inMagazijnData ~= nil then
            -- Speler is in magazijn! Poggers
            letsleep = false
            local pedCoords = GetEntityCoords(PlayerPedId())
            local exitCoords = inMagazijnData.exit
            local laptopCoords = inMagazijnData.laptop

            -- Magazijn verlaten
            if GetDistanceBetweenCoords(pedCoords, exitCoords.x, exitCoords.y, exitCoords.z, true) < 10 then
                letsleep = false
                DrawMarker(2, exitCoords.x, exitCoords.y, exitCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                if GetDistanceBetweenCoords(pedCoords, exitCoords.x, exitCoords.y, exitCoords.z, true) < 1.5 then
                    QBCore.Functions.DrawText3D(exitCoords.x, exitCoords.y, exitCoords.z + 0.2, "~g~[E]~w~ Magazijn verlaten")
                    if IsControlJustPressed(0, 38) and not enteringMagazijn then
                        TriggerServerEvent("zb-groothandel:server:verlaatMagazijn", spotKeyID)
                        enteringMagazijn = true
                        TriggerEvent("zb-weathersync:client:regenUit", false)
                        QBCore.Functions.Notify("Je gaat naar buiten...", "success")
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end
                        SetEntityCoords(PlayerPedId(), groothandel.data.coords["deur"].x, groothandel.data.coords["deur"].y, groothandel.data.coords["deur"].z)

                        despawnGroothandel() -- Verwijderd alle entities, shell etc.

                        Wait(1000)
                        DoScreenFadeIn(1000)
                        enteringMagazijn = false
                        spotKeyID = nil
                    end
                end
            end

            -- Laptop openen
            if GetDistanceBetweenCoords(pedCoords, laptopCoords.x, laptopCoords.y, laptopCoords.z, true) < 1.5 then
                letsleep = false
                QBCore.Functions.DrawText3D(laptopCoords.x, laptopCoords.y, laptopCoords.z + 0.2, "~g~[E]~w~ Laptop openen")
                if IsControlJustPressed(0, 38) then
                    local specialisatieNamen = {}
                    for k, v in pairs(groothandel.data.specialisaties) do
                        local tmp_table_tmp_tmp = {nummer = v, naam = Config.categorieen[v].label}
                        table.insert(specialisatieNamen, tmp_table_tmp_tmp)
                    end
                    SendNUIMessage({
                        type = "openLaptop",
                        handelAppData = json.encode(groothandelHandelData),
                        groothandelData = json.encode(groothandel),
                        werknemersData = json.encode(groothandelWerknemers),
                        specialisatieData = json.encode(specialisatieNamen),
                    })
                    SetNuiFocus(true, true)
                end
            end

            -- Rekken met aantalen
            local tmp_opslag_rekken = json.decode(groothandel.opslag)
            if inMagazijnData ~= nil then
                for k, v in pairs (inMagazijnData.rekken) do
                    local aantal = tmp_opslag_rekken[k].gevuld
                    local categorie_nummer = tmp_opslag_rekken[k].categorie
                    local categorie = "Leeg"
                    if categorie_nummer ~= 0 then
                        categorie = Config.categorieen[categorie_nummer].label
                    end
                    local coordjes = GetOffsetFromEntityInWorldCoords(magazijnShellHash, Config.rekkenPOIS[k].x, Config.rekkenPOIS[k].y, Config.rekkenPOIS[k].z)
                    if GetDistanceBetweenCoords(pedCoords, coordjes.x, coordjes.y, coordjes.z, true) < 2.0 then
                        if aantal == 0 then
                            -- Wit
                            QBCore.Functions.DrawText3D(coordjes.x, coordjes.y, coordjes.z + 1.5, aantal.."/3 ~w~- Leeg")
                        elseif aantal == 1 then
                            -- Groen
                            QBCore.Functions.DrawText3D(coordjes.x, coordjes.y, coordjes.z + 1.5, "~g~"..aantal.."/3 ~w~- "..categorie)
                        elseif aantal == 2 then
                            -- Oranje
                            QBCore.Functions.DrawText3D(coordjes.x, coordjes.y, coordjes.z + 1.5, "~o~"..aantal.."/3 ~w~- "..categorie)
                        elseif aantal == 3 then
                            -- Rood
                            QBCore.Functions.DrawText3D(coordjes.x, coordjes.y, coordjes.z + 1.5, "~r~"..aantal.."/3 ~w~- "..categorie)
                        end
                    end
                end
            end

        end

        if letsleep then
            Wait(1500)
        end
    end
end)

local bezigMetRonde = false
local npcSpawn = true
local rondeVoertuig = nil
local rondeType = nil

-- Inkoop/verkoop ronde starten
RegisterNUICallback("startRonde", function(data, cb)
    rondeType = data.type
    local rijId = data.id + 1
    local rondeData = nil 

    if rondeType == "inkopen" then
        -- Inkopen
        rondeData = groothandelHandelData.inkopen[rijId]
    else
        -- Verkopen
        rondeData = groothandelHandelData.verkopen[rijId]

        -- Check of hij specialisatie bezit
        local canStart = false
        for k, v in pairs (groothandel.data.specialisaties) do
            if v == rondeData.product_cfg_nummer then
                canStart = true
            end
        end

        if not canStart then
            QBCore.Functions.Notify("Je hebt deze specialisatie niet gekozen!", "error")
            return
        end
    end

    if not bezigMetRonde then
        if rondeData.transport == 1 and groothandel.data.voertuigen.auto or 
        rondeData.transport == 2 and groothandel.data.voertuigen.busje or 
        rondeData.transport == 3 and groothandel.data.voertuigen.vrachtwagen then
            QBCore.Functions.TriggerCallback("zb-groothandel:server:verwijderHandelRij", function(resultaat)
                if resultaat.correct == true then
                    QBCore.Functions.Notify("Je bent gestart met je ronde. Stap in het voertuig!", "success")
                    TriggerEvent("zb-groothandel:client:startRonde", rondeData, rondeType)
                else
                    QBCore.Functions.Notify(resultaat.message, "error")
                    return
                end
            end, rijId, data.type, groothandel.id, rondeData.transport)
        else
            QBCore.Functions.Notify("Je hebt dit voertuig niet!", "error")
            return
        end
    else
        QBCore.Functions.Notify("Je bent al bezig met een ronde!", "error")
        return
    end
end)

AddEventHandler("zb-groothandel:client:startRonde", function(rondeData, rondeType)
    bezigMetRonde = true

    local voertuigNaam = nil
    local voertuigCoords = nil
    if rondeData.transport == 1 then 
        voertuigNaam = "brioso"
        voertuigCoords = {x = inMagazijnData["auto"].x, y = inMagazijnData["auto"].y, z = inMagazijnData["auto"].z} 
    end 
    if rondeData.transport == 2 then 
        voertuigNaam = "pony"
        voertuigCoords = {x =  inMagazijnData["busje"].x, y = inMagazijnData["busje"].y, z = inMagazijnData["busje"].z} 
    end 
    if rondeData.transport == 3 then 
        voertuigNaam = "mule"
        voertuigCoords = {x =  inMagazijnData["vrachtwagen"].x, y = inMagazijnData["vrachtwagen"].y, z = inMagazijnData["vrachtwagen"].z} 
    end

    while true do
        Wait(1)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        DrawMarker(0, voertuigCoords.x, voertuigCoords.y, voertuigCoords.z + 4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.6, 0.2, 28, 202, 155, 155, true, false, false, true, false, false, false)
        if GetDistanceBetweenCoords(pos, voertuigCoords.x, voertuigCoords.y, voertuigCoords.z) < 4 then
            if IsControlJustPressed(0, 49) then
                DoScreenFadeOut(500)
                while not IsScreenFadedOut() do
                    Citizen.Wait(10)
                end

                TriggerEvent("zb-weathersync:client:regenUit", false)

                despawnGroothandel() -- Verwijderd alle entities, shell etc.

                local tmp_voertuig_coords = {x = groothandel.data.coords["voertuig"].x, y = groothandel.data.coords["voertuig"].y, z = groothandel.data.coords["voertuig"].z}
                
                QBCore.Functions.SpawnVehicle(voertuigNaam, function(voertuig)
                    SetEntityHeading(voertuig, groothandel.data.coords["voertuig"].h)
                    exports['LegacyFuel']:SetFuel(voertuig, 100.0)
                    SetEntityAsMissionEntity(voertuig, true, true)
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), voertuig, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(voertuig))
                    SetVehicleEngineOn(voertuig, true, true)
                    rondeVoertuig = voertuig
                end, tmp_voertuig_coords, true)

                DoScreenFadeIn(500)

                TriggerEvent("zb-groothandel:client:bezigMetRonde", rondeData, rondeType)
                return
            end
        end
    end
end)

AddEventHandler("zb-groothandel:client:bezigMetRonde", function(rondeData, rondeType)
    local voertuig = nil
    local randomLocatie = math.random(1, #Config.npcLocaties)
    local aantalDozen = rondeData.transport * 2
    local locatieDozen = true
    local bezig = false
    local klaar = false

    eindLocatie = Config.npcLocaties[randomLocatie]
    npcSpawn = true
    bezig = false
 
    if randomLocatie == laatsteLocatie then -- Zelfde locatie als vorige keer, pakt een nieuwe.
        TriggerEvent("zb-groothandel:client:bezigMetRonde", rondeData, rondeType)
        return
    else
        local randomNpc = math.random(1, #Config.Peds)
        local npcNaam = Config.Peds[randomNpc]

        laatsteLocatie = eindLocatie
    
        npcBlip = AddBlipForCoord(eindLocatie.x, eindLocatie.y, eindLocatie.z) -- Blip en route naar de NPC.
        SetBlipColour(npcBlip, 50)
        SetBlipRoute(npcBlip, true)
        SetBlipRouteColour(npcBlip, 50)

        while true do 
            Wait(1)
            local letsleep = true
            local pos = GetEntityCoords(GetPlayerPed(-1))
            local voertuigPos = GetEntityCoords(rondeVoertuig)

            local trunkpos = nil
            if rondeData.transport == 1 then
                trunkpos = GetOffsetFromEntityInWorldCoords(rondeVoertuig, 0, -1.4, 0) -- Auto!
            elseif rondeData.transport == 2 then
                trunkpos = GetOffsetFromEntityInWorldCoords(rondeVoertuig, 0, -2.5, 0) -- Busje!
            else
                trunkpos = GetOffsetFromEntityInWorldCoords(rondeVoertuig, 0, -4.0, 0) -- Vrachtwagen!
            end

            if npcSpawn then -- Spawnt de NPC.
                letsleep = false
                
                local hash = GetHashKey(npcNaam) -- NPC.
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Wait(1)
                end

                npc = CreatePed(4, hash, eindLocatie.x, eindLocatie.y, eindLocatie.z - 1, eindLocatie.h, false, true)
                FreezeEntityPosition(npc, true)    
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)    

                npcSpawn = false
            end

            if not bezig and not klaar then
                if GetDistanceBetweenCoords(pos, eindLocatie.x, eindLocatie.y, eindLocatie.z, true) < 2 then
                    letsleep = false
                    QBCore.Functions.DrawText3D(eindLocatie.x, eindLocatie.y, eindLocatie.z + 1, "~g~[E]~w~ Aanspreken")
                    if IsControlJustPressed(0, 38) then
                        bezig = true
                        RemoveBlip(npcBlip)
                        if rondeType == "inkopen" then
                            ExecuteCommand("e box")
                            QBCore.Functions.Notify("Breng de dozen naar je voertuig!", "success")
                            locatieDozen = true
                            Wait(2500)
                        else
                            QBCore.Functions.Notify("Haal de dozen uit je voertuig!", "success")
                            locatieDozen = true
                            Wait(2500)
                        end
                    end
                end
            end

            if bezig then
                if locatieDozen == true then -- Doos moet naar het voertuig.
                    if GetDistanceBetweenCoords(pos, trunkpos.x, trunkpos.y, trunkpos.z, true) < 30 and not IsPedInAnyVehicle(PlayerPedId()) then
                        letsleep = false
                        DrawMarker(20, trunkpos.x, trunkpos.y, trunkpos.z + 2, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.3, 0.5, 0.3, 28, 202, 155, 155, true, false, false, true, false, false, false)
                        if GetDistanceBetweenCoords(pos, trunkpos.x, trunkpos.y, trunkpos.z, true) < 2 then
                            if rondeType == "inkopen" then
                                QBCore.Functions.DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z + 1, "~g~[E]~w~ Doos plaatsen")
                                if IsControlJustPressed(0, 38) then
                                    QBCore.Functions.Progressbar("khankerdingus", "Doos plaatsen..", 1500, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function() -- Done
                                        ExecuteCommand("e c")
                                        aantalDozen = aantalDozen - 1
                                        if aantalDozen > 0 then
                                            QBCore.Functions.Notify("Je hebt de doos in je voertuig geplaatst. Je moet er nog "..aantalDozen..".", "success")
                                        end
                                        locatieDozen = false
                                    end)
                                end
                            else
                                QBCore.Functions.DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z + 1, "~g~[E]~w~ Doos pakken")
                                if IsControlJustPressed(0, 38) then
                                    QBCore.Functions.Progressbar("khankerdingus", "Doos pakken..", 1500, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function() -- Done
                                        ExecuteCommand("e box")
                                        QBCore.Functions.Notify("Je hebt de doos uit je voertuig gepakt.", "success")
                                        locatieDozen = false
                                    end)
                                    
                                end
                            end
                        end
                    end
                else -- Doos moet naar de NPC.
                    if GetDistanceBetweenCoords(pos, eindLocatie.x, eindLocatie.y, eindLocatie.z, true) < 30 and not IsPedInAnyVehicle(PlayerPedId()) then
                        letsleep = false
                        DrawMarker(20, eindLocatie.x, eindLocatie.y, eindLocatie.z + 2, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.3, 0.5, 0.3, 28, 202, 155, 155, true, false, false, true, false, false, false)
                        if GetDistanceBetweenCoords(pos, eindLocatie.x, eindLocatie.y, eindLocatie.z, true) < 2.5 then
                            if rondeType == "inkopen" then
                                QBCore.Functions.DrawText3D(eindLocatie.x, eindLocatie.y, eindLocatie.z + 1, "~g~[E]~w~ Doos pakken")
                                if IsControlJustPressed(0, 38) then
                                    QBCore.Functions.Progressbar("khankerdingus", "Doos aanpakken..", 1500, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function() -- Done
                                        ExecuteCommand("e box")
                                        QBCore.Functions.Notify("Je hebt de doos van de verkoper gepakt.", "success")
                                        locatieDozen = true
                                    end)
                                end
                            else
                                QBCore.Functions.DrawText3D(eindLocatie.x, eindLocatie.y, eindLocatie.z + 1, "~g~[E]~w~ Doos afgeven")
                                if IsControlJustPressed(0, 38) then
                                    QBCore.Functions.Progressbar("khankerdingus", "Doos afgeven..", 1500, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function() -- Done
                                        ExecuteCommand("e c")
                                        aantalDozen = aantalDozen - 1
                                        if aantalDozen > 0 then
                                            QBCore.Functions.Notify("Je hebt de doos aan de inkoper gegeven. Je moet er nog "..aantalDozen..".", "success")
                                        end
                                        locatieDozen = true
                                    end)
                                end
                            end
                        end
                    end
                end

                if aantalDozen == 0 then
                    eindBlip = AddBlipForCoord(groothandel.data.coords["deur"].x, groothandel.data.coords["deur"].y, groothandel.data.coords["deur"].z) -- Blip en route naar de NPC.

                    SetBlipColour(eindBlip, 50)
                    SetBlipRoute(eindBlip, true)
                    SetBlipRouteColour(eindBlip, 50)
                    FreezeEntityPosition(npc, false)
                    SetEntityAsNoLongerNeeded(npc)
                    npc = nil

                    if rondeType == "inkopen" then
                        ExecuteCommand("e c")
                        QBCore.Functions.Notify("Dat waren alle dozen, breng ze terug naar je groothandel!", "success")
                        bezig = false
                        klaar = true
                    else
                        ExecuteCommand("e c")
                        QBCore.Functions.Notify("Je hebt alle dozen gebracht, rijd terug naar je groothandel!", "success")
                        bezig = false
                        klaar = true
                    end
                end
            end

            if GetDistanceBetweenCoords(pos, groothandel.data.coords["voertuig"].x, groothandel.data.coords["voertuig"].y, groothandel.data.coords["voertuig"].z, true) < 15 then
                letsleep = false
                DrawMarker(25, groothandel.data.coords["voertuig"].x, groothandel.data.coords["voertuig"].y, groothandel.data.coords["voertuig"].z - 1.2, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.5001, 28, 202, 155, 100, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(pos, groothandel.data.coords["voertuig"].x, groothandel.data.coords["voertuig"].y, groothandel.data.coords["voertuig"].z, true) < 3 then
                    QBCore.Functions.DrawText3D(groothandel.data.coords["voertuig"].x, groothandel.data.coords["voertuig"].y, groothandel.data.coords["voertuig"].z, "~g~[E]~w~ Ronde stoppen")
                    if IsControlJustPressed(0, 38) then
                        if GetVehiclePedIsIn(GetPlayerPed(-1)) == rondeVoertuig then
                            if klaar then
                                if rondeType == "inkopen" then
                                    -- Je hebt je inkoop ronde goed gestopt, krijg shit.
                                    TriggerServerEvent("zb-groothandel:server:inkoopklaar", groothandel.id, rondeData)
                                    QBCore.Functions.Notify("Alles is veilig aangekomen, er is/zijn "..rondeData.transport.." dozen aan "..rondeData["product"].label.." toegevoegd!", "success")
                                else
                                    -- Je hebt je verkoop ronde goed gestopt, krijg geld.
                                    TriggerServerEvent("zb-groothandel:server:verkoopklaar", groothandel.id, rondeData)
                                    QBCore.Functions.Notify("Je hebt het voertuig netjes ingeleverd, het geld is op de bedrijfsrekening gestort!", "success")
                                end
                            else
                                QBCore.Functions.Notify("Je hebt geen spullen geleverd.", "error")
                                -- Je ben halverwege gestopt, krijg niks.
                            end
                        else
                            QBCore.Functions.Notify("Dit is niet het juiste voertuig.", "error")
                            -- Je hebt niet het goede voertuig.
                        end

                        RemoveBlip(eindBlip)
                        RemoveBlip(npcBlip)
                        DeleteVehicle(rondeVoertuig)
                        bezigMetRonde = false
                        npcSpawn = true
                        rondeVoertuig = nil
                        rondeType = nil
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

-- Groothandel verlaten, elke entity verwijderen basically
function despawnGroothandel()
    if inMagazijnData ~= nil then
        DeleteEntity(magazijnShellHash)
        DeleteEntity(inMagazijnData["tafel"])
        DeleteEntity(inMagazijnData["laptop"].entity)
        -- Rekken
        for k, v in pairs (inMagazijnData.rekken) do
            DeleteEntity(v)
        end
        -- Dozen
        for k, v in pairs (inMagazijnData.dozen) do
            DeleteEntity(v)
        end

        -- Delete voertuigen als ze bestaan
        if inMagazijnData["vrachtwagen"].entity ~= nil then DeleteVehicle(inMagazijnData["vrachtwagen"].entity) end
        if inMagazijnData["busje"].entity ~= nil then DeleteVehicle(inMagazijnData["busje"].entity) end
        if inMagazijnData["auto"].entity ~= nil then DeleteVehicle(inMagazijnData["auto"].entity) end

        -- Set alles weer naar leeg
        inMagazijnData = nil
        magazijnShellHash = nil
    end
end

-- Rekken updaten, plaats dozen
function updateRekken()
    if inMagazijnData ~= nil then
        -- Check of dozen al geplaatst zijn
        if inMagazijnData["dozen"] ~= nil then
            -- Dozen zijn al geplaatst, delete deze eerst, daarna replacen
            for k, v in pairs (inMagazijnData.dozen) do
                DeleteEntity(v)
            end
        end
        inMagazijnData["dozen"] = {} -- Set die kanker tabel
        local tmp_dozen = {}

        local tmp_opslag = json.decode(groothandel.opslag)

        for k, v in pairs (inMagazijnData.rekken) do
            -- Dit zijn alle KANKER rekken
            local aantalDozen = tmp_opslag[k].gevuld
            if aantalDozen > 0 then
                -- Er zijn dozen, loop en plaats
                for i = 1, aantalDozen, 1 do
                    
                    if i == 1 then
                        zje = -2.85
                    elseif i == 2 then
                        zje = -1.45
                    elseif i == 3 then
                        zje = 0.00
                    end

                    local doos_hash = `prop_boxpile_02d`
                    if math.random(1, 2) == 1 then
                        doos_hash = `prop_boxpile_02c`
                    end

                    local tmp_doos_coords = GetOffsetFromEntityInWorldCoords(magazijnShellHash, Config.rekkenPOIS[k].x, Config.rekkenPOIS[k].y, zje)
                    local tmp_doos = CreateObject(doos_hash, tmp_doos_coords.x, tmp_doos_coords.y, tmp_doos_coords.z, false, false, false)
                    FreezeEntityPosition(tmp_doos, true)
                    table.insert(tmp_dozen, tmp_doos)
                end
            end
        end

        inMagazijnData["dozen"] = tmp_dozen
    end
end

-- Default NUI notify die we gebruiken als er alleen een notifier vanuit JS moet komen
RegisterNUICallback("NuiNotify", function(data, cb)
    QBCore.Functions.Notify(data.msg, data.type, data.time)
end)



-- Shit functies
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