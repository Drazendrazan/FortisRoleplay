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
	QBCore.Functions.TriggerCallback("zb-vliegtuigdealer:server:ontvangConfig", function(config)
        SendNUIMessage({
            type = "importeer",
            data = config
        })
	end)
end)


-- Blip
Citizen.CreateThread(function()
    local CarDealerBlipje = AddBlipForCoord(-1371.44, -3282.19, 12.94)
    SetBlipSprite(CarDealerBlipje, 307)
    SetBlipColour(CarDealerBlipje, 11)
    SetBlipScale(CarDealerBlipje, 0.9)
    SetBlipAsShortRange(CarDealerBlipje, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vliegtuigdealer")
    EndTextCommandSetBlipName(CarDealerBlipje)
    local pedSpawn = true

    while true do
        Citizen.Wait(1)
        local letsleep = true

        local ped = GetPlayerPed(-1)
        local pedCoords = GetEntityCoords(ped)

        if pedSpawn == true then
            local hash = GetHashKey('a_m_m_prolhost_01')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            pedje = CreatePed(4, hash, -1371.44, -3282.19, 12.94, 335.28, false, true)

            FreezeEntityPosition(pedje, true)    
            SetEntityInvincible(pedje, true)
            SetBlockingOfNonTemporaryEvents(pedje, true)

            loadAnimDict("anim@amb@nightclub@peds@")
            TaskPlayAnim(pedje, "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", 8.0, -8, -1, 3, 0, 0, 0, 0)


            pedSpawn = false
        else
            return
        end
    end
end)

--Tijdelijk
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    Wait(5000)
    QBCore.Functions.TriggerCallback("zb-vliegtuigdealer:server:ontvangConfig", function(config)
        SendNUIMessage({
            type = "importeer",
            data = config
        })
	end)
end)
--Tijdelijk

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local pedPos = GetEntityCoords(GetPlayerPed(-1))
        if GetDistanceBetweenCoords(pedPos, Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z, true) < 8 and GetDistanceBetweenCoords(pedPos, Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z, true) > 1.5 then
            QBCore.Functions.DrawText3D(Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z + 0.10, "~w~Vliegtuigdealer")
        else
            if GetDistanceBetweenCoords(pedPos, Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z, true) < 1.5 then
                QBCore.Functions.DrawText3D(Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z + 0.10, "~g~[E]~w~ Open vliegtuigdealer")
                QBCore.Functions.DrawText3D(Config.Coords["open"].x, Config.Coords["open"].y, Config.Coords["open"].z - 0.01, "~g~[G]~w~ Koop vliegbrevet [€100]")
                if IsControlJustPressed(0, 38) then -- Shop openen
                    SendNUIMessage({
                        type = "open"
                    })
                    TriggerEvent('qb-weathersync:client:DisableSync')
                    SetWeatherTypePersist('EXTRASUNNY')
                    SetWeatherTypeNow('EXTRASUNNY')
                    SetWeatherTypeNowPersist('EXTRASUNNY')
                    NetworkOverrideClockTime(23, 0, 0)
                    SetNuiFocus(true, true)
                    inCarDealer = true
                    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                    SetCamCoord(cam, Config.Coords["preview"].x, Config.Coords["preview"].y, Config.Coords["preview"].z)
                    SetCamRot(cam, 0.0, 0.0, 150.0, 2)
                    RenderScriptCams(true, true, 1)
                end

                if IsControlJustPressed(0, 47) then -- Vliegbevret
                    QBCore.Functions.TriggerCallback("zb-vliegtuigdealer:server:koopBevret", function(resultaat)
                        if resultaat then
                            QBCore.Functions.Notify("Vliegbrevet gekocht!", "success")
                        else
                            QBCore.Functions.Notify("Je hebt geen €100 op je bank!", "error")
                        end
                    end)
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
    previewVoertuig = CreateVehicle(GetHashKey(data.voertuig), -1388.99, -3258.57, 12.94, 30.0, false, false)
    SetVehicleHasBeenOwnedByPlayer(previewVoertuig, true)
    SetVehicleDoorsLocked(previewVoertuig, 2)
    SetModelAsNoLongerNeeded(previewVoertuig)
    SendNUIMessage({
        type = "geladen"
    })
end)

-- Kopen
RegisterNUICallback("kopen", function(data)
    local voertuig = data.voertuig
    local categorie = data.categorie
    if inCarDealer then
        QBCore.Functions.TriggerCallback("zb-vliegtuigdealer:server:koopVoertuig", function(cb)

        end, voertuig, categorie)
    else
        TriggerServerEvent("zb-vliegtuigdealer:server:kauloHacker")
    end
end)

RegisterNetEvent("zb-vliegtuigdealer:client:voertuigGekocht")
AddEventHandler("zb-vliegtuigdealer:client:voertuigGekocht", function()
    SendNUIMessage({
        type = "gekocht"
    })
end)

RegisterNUICallback("verwijderVoertuig", function(data)
    verwijderPreviewVoertuig()
end)

RegisterNUICallback("sluiten", function(data)
    SetNuiFocus(false, false)
    TriggerEvent('qb-weathersync:client:EnableSync')
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

        if GetDistanceBetweenCoords(pedCoords, Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z, true) < 35 then
            letsleep = false
            DrawMarker(25, Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 0.5001, 125, 195, 37, 100, 0, 0, 0, 0)
            
            if GetDistanceBetweenCoords(pedCoords, Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z, true) < 4 then
                if IsPedInAnyHeli(GetPlayerPed(-1)) or IsPedInAnyPlane(GetPlayerPed(-1)) then
                    if not verkoopEcht then
                        if not verkoopBlock then
                            QBCore.Functions.DrawText3D(Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z - 0.10, "~g~[E]~w~ Verkoop vliegtuig voor 50%")
                        else
                            QBCore.Functions.DrawText3D(Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z - 0.10, "~r~De vliegtuigdealer neemt tijdelijk geen nieuwe vliegtuigen aan")
                        end
                        if IsControlJustPressed(0, 38) and not verkoopBlock then
                            verkoopEcht = true
                        end
                    else
                        QBCore.Functions.DrawText3D(Config.Coords["verkoopCirkel"].x, Config.Coords["verkoopCirkel"].y, Config.Coords["verkoopCirkel"].z - 0.10, "~r~[7]~w~ Verkoop definitief")
                        if IsControlJustPressed(0, 161) or IsDisabledControlJustPressed(0, 161) and not verkoopBlock then
                            verkoopBlock = true
                            TriggerEvent("zb-vliegtuigdealer:client:blockVoertuigVerkoop")
                            verkoopEcht = false

                            local kenteken = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            local spawnNaam = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))))
                            local hash = GetHashKey(spawnNaam)


                            QBCore.Functions.TriggerCallback("zb-vliegtuigdealer:server:verkoopVoertuig", function(owner, prijs)
                                if owner then
                                    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                    QBCore.Functions.Notify("Je hebt je vliegtuig verkocht voor €"..prijs, "success")
                                else
                                    QBCore.Functions.Notify("Dit vliegtuig staat niet onder jou naam!", "error")
                                end
                            end, kenteken, hash, spawnNaam)

                        end
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


AddEventHandler("zb-vliegtuigdealer:client:blockVoertuigVerkoop", function()
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

 
function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

-- Anti cheat
RegisterNetEvent("zb-vliegtuigdealer:client:hackerZemmer")
AddEventHandler("zb-vliegtuigdealer:client:hackerZemmer", function()
    TriggerServerEvent("zb-vliegtuigdealer:server:kauloHacker")
end)