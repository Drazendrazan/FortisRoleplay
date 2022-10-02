QBCore = nil

autoData = nil
cam = 0
previewVoertuig = nil

proefrit = false
proefritTimer = 0
proefritVoertuig = nil
proefritPed = nil
stuurOverGenomen = false
inCarDealer = false
aanHetSpawnen = false

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
	QBCore.Functions.TriggerCallback("zb-cardealer:server:ontvangConfig", function(config)
        SendNUIMessage({
            type = "importeer",
            data = config
        })
	end)

    for k,v in pairs(Config.Spots) do
        RequestModel(GetHashKey(Config.Spots[k].auto))
        while not HasModelLoaded(GetHashKey(Config.Spots[k].auto)) do
            Citizen.Wait(10)
        end
        local spotVoertuig = CreateVehicle(GetHashKey(Config.Spots[k].auto), Config.Spots[k].x, Config.Spots[k].y, Config.Spots[k].z, Config.Spots[k].h, false, false)
        SetVehicleDoorsLocked(spotVoertuig, 2)
        SetVehicleHasBeenOwnedByPlayer(spotVoertuig, true)
        SetModelAsNoLongerNeeded(spotVoertuig)
    end
end)


-- Blip
Citizen.CreateThread(function()
    local CarDealerBlipje = AddBlipForCoord(-801.22, -222.85, 37.15)
    SetBlipSprite(CarDealerBlipje, 225)
    SetBlipColour(CarDealerBlipje, 11)
    SetBlipScale(CarDealerBlipje, 0.9)
    SetBlipAsShortRange(CarDealerBlipje, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cardealer")
    EndTextCommandSetBlipName(CarDealerBlipje)
end)

--Tijdelijk
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    Wait(5000)
    QBCore.Functions.TriggerCallback("zb-cardealer:server:ontvangConfig", function(config)
        SendNUIMessage({
            type = "importeer",
            data = config
        })
	end)

    for k,v in pairs(Config.Spots) do
        RequestModel(GetHashKey(Config.Spots[k].auto))
        while not HasModelLoaded(GetHashKey(Config.Spots[k].auto)) do
            Citizen.Wait(10)
        end
        local spotVoertuig = CreateVehicle(GetHashKey(Config.Spots[k].auto), Config.Spots[k].x, Config.Spots[k].y, Config.Spots[k].z, Config.Spots[k].h, false, false)
        SetVehicleDoorsLocked(spotVoertuig, 2)
        SetVehicleHasBeenOwnedByPlayer(spotVoertuig, true)
        SetModelAsNoLongerNeeded(spotVoertuig)
    end
end)
--Tijdelijk

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local pedPos = GetEntityCoords(GetPlayerPed(-1))

        if GetDistanceBetweenCoords(pedPos, Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z, true) < 30 then
            DrawMarker(2, Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
            
            if GetDistanceBetweenCoords(pedPos, Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z, true) < 15 and GetDistanceBetweenCoords(pedPos, Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z, true) > 1.5 then
                QBCore.Functions.DrawText3D(Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z - 0.10, "~w~Open cardealer")
            else
                if GetDistanceBetweenCoords(pedPos, Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z, true) < 1.5 then
                    QBCore.Functions.DrawText3D(Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z - 0.10, "~g~[E]~w~ Open cardealer")
                    if IsControlJustPressed(0, 38) then
                        SendNUIMessage({
                            type = "open"
                        })
                        SetNuiFocus(true, true)
                        inCarDealer = true
                        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                        SetCamCoord(cam, Config.Coords["preview"].x, Config.Coords["preview"].y, Config.Coords["preview"].z)
                        SetCamRot(cam, -10.0, 0.0, 40.0, 2)
                        RenderScriptCams(true, true, 1)
                    end
                end
            end
        end
        

    end
end)

RegisterNUICallback("previewVoertuig", function(data)
    verwijderPreviewVoertuig()
    RequestModel(GetHashKey(data.voertuig))
    while not HasModelLoaded(GetHashKey(data.voertuig)) do
        Citizen.Wait(10)
    end
    previewVoertuig = CreateVehicle(GetHashKey(data.voertuig), -791.66, -217.90, 37.41, 170.0, false, false)
    SetVehicleHasBeenOwnedByPlayer(previewVoertuig, true)
    SetVehicleDoorsLocked(previewVoertuig, 2)
    SetModelAsNoLongerNeeded(previewVoertuig)
    SendNUIMessage({
        type = "geladen"
    })
end)

RegisterNUICallback("proefrit", function(data)
    if proefrit then
        TriggerServerEvent("zb-cardealer:server:kauloHacker")
    else
        QBCore.Functions.TriggerCallback("zb-cardealer:server:ontvangConfig", function(config)
            local bestaat = false
            local voertuigen = json.decode(config)
            for k, v in pairs(voertuigen["voertuigen"]) do
                for a, b in pairs(v) do
                    if b.spawnNaam == data.voertuig then
                        bestaat = true
                    end
                end
            end

            if not bestaat then
                TriggerServerEvent("zb-cardealer:server:kauloHacker")
            end
        end)

        local pedCoords = GetEntityCoords(GetPlayerPed(-1))
        if GetDistanceBetweenCoords(pedCoords, Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z) > 15 then
            TriggerServerEvent("zb-cardealer:server:kauloHacker")
        end

        verwijderPreviewVoertuig()
        proefrit = true
        proefritTimer = Config.Coords["proefrittijd"].seconden
        QBCore.Functions.SpawnVehicle(data.voertuig, function(voertuig)
            SetEntityHeading(voertuig, Config.Coords["spawn"].h)
            exports['LegacyFuel']:SetFuel(voertuig, 100.0)
            SetEntityAsMissionEntity(voertuig, true, true)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), voertuig, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(voertuig))
            SetVehicleEngineOn(voertuig, true, true)
            proefritVoertuig = voertuig
        end, Config.Coords["spawn"], true)
        local pedHash = GetHashKey('a_m_m_prolhost_01')
        RequestModel(pedHash)
        while not HasModelLoaded(pedHash) do
            Wait(1)
        end
        Wait(500)
        if IsAnyVehicleSeatEmpty(proefritVoertuig) then
            proefritPed = CreatePed(4, pedHash, Config.Coords["spawn"].x, Config.Coords["spawn"].y, Config.Coords["spawn"].z - 0.85, 0.0, true, true)
            TaskWarpPedIntoVehicle(proefritPed, proefritVoertuig, 0)
        else
            QBCore.Functions.Notify("Er zijn geen plekken vrij om een medewerker van de car dealer mee te nemen, daarom rijd je alleen!")
        end
        while proefritTimer >= 0 do
            Citizen.Wait(1000)
            if proefritTimer == 0 and proefrit then
                if proefritPed ~= nil then
                    QBCore.Functions.Notify("Je proefrit is afgelopen, de cardealer werknemer neemt het stuur over, en zal terug rijden naar de cardealer.", "success")
                    DeleteEntity(proefritPed)
                    proefritPed = nil
                    SetPedIntoVehicle(GetPlayerPed(-1), proefritVoertuig, 0)
                    local pedCoords = GetEntityCoords(GetPlayerPed(-1))
                    proefritPed = CreatePed(4, pedHash, pedCoords.x, pedCoords.y, pedCoords.z + 10.0, 0.0, true, true)
                    SetPedIntoVehicle(proefritPed, proefritVoertuig, -1)
                    TaskVehicleDriveToCoord(proefritPed, GetVehiclePedIsIn(GetPlayerPed(-1)), Config.Coords["inleverLocatie"].x, Config.Coords["inleverLocatie"].y, Config.Coords["inleverLocatie"].z, 25.0, true, GetHashKey(data.voertuig), 786603)
                    stuurOverGenomen = true
                    return
                else
                    proefrit = false
                    proefritTimer = 0
                    DeleteVehicle(proefritVoertuig)
                    DeleteEntity(proefritPed)
                    proefritVoertuig = nil
                    stuurOverGenomen = false
                    proefritPed = nil
                    QBCore.Functions.Notify("Proefrit abrupt beeindigd!", "error")
                end
            else
                proefritTimer = proefritTimer - 1
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local letsleep = true

        if proefrit and proefritTimer > 0 then
            letsleep = false
            DrawTxt(0.80, 0.00, 0.05, 0.00, 0.6, "De cardealer medewerker neemt het voertuig over binnen "..proefritTimer.." seconden", 255, 255, 255, 255)

            if IsPedInAnyVehicle(GetPlayerPed(-1)) and GetVehiclePedIsIn(GetPlayerPed(-1)) ~= proefritVoertuig then
                proefrit = false
                proefritTimer = 0
                DeleteVehicle(proefritVoertuig)
                DeleteEntity(proefritPed)
                proefritVoertuig = nil
                stuurOverGenomen = false
                proefritPed = nil
                QBCore.Functions.Notify("Proefrit abrupt beeindigd!", "error")
            end

            if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                proefrit = false
                proefritTimer = 0
                DeleteVehicle(proefritVoertuig)
                DeleteEntity(proefritPed)
                proefritVoertuig = nil
                stuurOverGenomen = false
                proefritPed = nil
                QBCore.Functions.Notify("Proefrit abrupt beeindigd!", "error")
            end

            if proefritPed ~= nil and proefritTimer < 115 then
                if not IsPedInAnyVehicle(proefritPed) then
                    proefrit = false
                    proefritTimer = 0
                    DeleteVehicle(proefritVoertuig)
                    DeleteEntity(proefritPed)
                    proefritVoertuig = nil
                    stuurOverGenomen = false
                    proefritPed = nil
                    QBCore.Functions.Notify("Proefrit abrupt beeindigd!", "error")
                end
            end

            if proefritPed ~= nil and proefritTimer < 115 and IsPedDeadOrDying(proefritPed) then
                proefrit = false
                proefritTimer = 0
                DeleteVehicle(proefritVoertuig)
                DeleteEntity(proefritPed)
                proefritVoertuig = nil
                stuurOverGenomen = false
                proefritPed = nil
                QBCore.Functions.Notify("Proefrit abrupt beeindigd!", "error")
            end

        elseif proefrit and stuurOverGenomen then
            letsleep = false
            if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                proefrit = false
                proefritTimer = 0
                DeleteVehicle(proefritVoertuig)
                -- DeleteEntity(proefritPed)
                SetPedAsNoLongerNeeded(proefritPed)
                proefritVoertuig = nil
                stuurOverGenomen = false
                proefritPed = nil
                QBCore.Functions.Notify("Proefrit abrupt beeindigd!", "error")
            else
                local pedCoords = GetEntityCoords(GetPlayerPed(-1))
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)
                if GetDistanceBetweenCoords(pedCoords, Config.Coords["inleverLocatie"].x, Config.Coords["inleverLocatie"].y, Config.Coords["inleverLocatie"].z) < 7 then
                    proefrit = false
                    proefritTimer = 0
                    DeleteVehicle(proefritVoertuig)
                    -- DeleteEntity(proefritPed)
                    SetPedAsNoLongerNeeded(proefritPed)
                    proefritVoertuig = nil
                    stuurOverGenomen = false
                    proefritPed = nil
                    QBCore.Functions.Notify("Proefrit succesvol beeindigd!", "success")
                end

                if proefritPed ~= nil and proefritTimer < 115 and IsPedDeadOrDying(proefritPed) then
                    proefrit = false
                    proefritTimer = 0
                    DeleteVehicle(proefritVoertuig)
                    DeleteEntity(proefritPed)
                    proefritVoertuig = nil
                    stuurOverGenomen = false
                    proefritPed = nil
                    QBCore.Functions.Notify("Proefrit abrupt beeindigd!", "error")
                end

                if proefritPed ~= nil and proefritTimer < 115 then
                    if not IsPedInAnyVehicle(proefritPed) then
                        proefrit = false
                        proefritTimer = 0
                        DeleteVehicle(proefritVoertuig)
                        DeleteEntity(proefritPed)
                        proefritVoertuig = nil
                        stuurOverGenomen = false
                        proefritPed = nil
                        QBCore.Functions.Notify("Proefrit abrupt beeindigd!", "error")
                    end
                end

            end
        end

        if letsleep then
            Wait(1000)
        end
    end
end)

-- Kopen
RegisterNUICallback("kopen", function(data)
    local voertuig = data.voertuig
    local categorie = data.categorie

    if inCarDealer then
        QBCore.Functions.TriggerCallback("zb-cardealer:server:koopVoertuig", function(cb)

        end, voertuig, categorie)
    else
        TriggerServerEvent("zb-cardealer:server:kauloHacker")
    end
end)

RegisterNetEvent("zb-cardealer:client:voertuigGekocht")
AddEventHandler("zb-cardealer:client:voertuigGekocht", function(voertuig, kenteken)
    SendNUIMessage({
        type = "gekocht"
    })
    QBCore.Functions.SpawnVehicle(voertuig, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, kenteken)
        SetEntityHeading(veh, Config.Coords["spawn"].h)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        TriggerServerEvent("vehicletuning:server:SaveVehicleProps", QBCore.Functions.GetVehicleProperties(veh))
        SetEntityAsMissionEntity(veh, true, true)
    end, Config.Coords["spawn"], false)
end)

RegisterNUICallback("verwijderVoertuig", function(data)
    verwijderPreviewVoertuig()
end)

RegisterNUICallback("sluiten", function(data)
    SetNuiFocus(false, false)
    inCarDealer = false
    DestroyCam(cam, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    verwijderPreviewVoertuig()
end)


-- Verkoop cirkel

local verkoopEcht = false
local verkoopBlock = false

Citizen.CreateThread(function()
    while true do
        Wait(1)
        local pedCoords = GetEntityCoords(GetPlayerPed(-1))
        local letsleep = true

        if GetDistanceBetweenCoords(pedCoords, Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z, true) < 20 then
            letsleep = false
            DrawMarker(25, Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.5001, 28, 202, 155, 100, 0, 0, 0, 0)
            
            if GetDistanceBetweenCoords(pedCoords, Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z, true) < 4 and IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if not verkoopEcht then
                    if not verkoopBlock then
                        QBCore.Functions.DrawText3D(Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z - 0.10, "~g~[E]~w~ Verkoop voertuig voor 50%")
                    else
                        QBCore.Functions.DrawText3D(Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z - 0.10, "~r~De cardealer neemt tijdelijk geen nieuwe voertuigen aan")
                    end
                    if IsControlJustPressed(0, 38) and not verkoopBlock then
                        verkoopEcht = true
                    end
                else
                    QBCore.Functions.DrawText3D(Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z - 0.10, "~r~[7]~w~ Verkoop definitief")
                    if IsControlJustPressed(0, 161) or IsDisabledControlJustPressed(0, 161) and not verkoopBlock then
                        verkoopBlock = true
                        TriggerEvent("zb-cardealer:client:blockVoertuigVerkoop")
                        verkoopEcht = false

                        local kenteken = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)))
                        
                        QBCore.Functions.TriggerCallback("zb-cardealer:server:verkoopVoertuig", function(owner, prijs)
                            if owner then
                                QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                QBCore.Functions.Notify("Je hebt je voertuig verkocht voor €"..prijs, "success")
                            else
                                QBCore.Functions.Notify("Dit voertuig staat niet onder jou naam!", "error")
                            end
                        end, kenteken)

                    end
                end
            end
        end

        if letsleep then
            verkoopEcht = false
            Wait(1500)
        end
    end
end)


AddEventHandler("zb-cardealer:client:blockVoertuigVerkoop", function()
    Wait(120000)
    verkoopBlock = false
end)

-- Losse functies :)
function verwijderPreviewVoertuig()
    if previewVoertuig ~= nil then
        DeleteVehicle(previewVoertuig)
        previewVoertuig = nil
    end
end

function DrawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

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

-- Anti cheat
RegisterNetEvent("zb-cardealer:client:hackerZemmer")
AddEventHandler("zb-cardealer:client:hackerZemmer", function()
    TriggerServerEvent("zb-cardealer:server:kauloHacker")
end)
