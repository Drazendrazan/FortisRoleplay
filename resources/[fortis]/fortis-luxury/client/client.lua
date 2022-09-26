Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    local intmem = 0
    for k,v in pairs(Config.Showroom) do
        RequestModel(Config.Showroom[k].auto)

        while not HasModelLoaded(Config.Showroom[k].auto) do
            if (intmem < 5000) then
                intmem = intmem + 100 
                Citizen.Wait(100)
            else
                Citizen.Trace(string.format("Het model van key %s duurde te lang om het voertuig op te halen, bad model?\n", tostring(k)))
                break
            end
        end

        local showroomAuto = CreateVehicle(Config.Showroom[k].auto, Config.Showroom[k].x, Config.Showroom[k].y, Config.Showroom[k].z, Config.Showroom[k].h, false, false)
        SetVehicleDoorsLocked(showroomAuto, 2)
        SetVehicleHasBeenOwnedByPlayer(showroomAuto, true)
        SetModelAsNoLongerNeeded(showroomAuto)
    end
end)

-- Blip
Citizen.CreateThread(function()
    Wait(2000)
    local CarDealerBlipje = AddBlipForCoord(112.17, -1510.07, 29.26) 
    SetBlipSprite(CarDealerBlipje, 225)
    SetBlipColour(CarDealerBlipje, 1)
    SetBlipScale(CarDealerBlipje, 0.7)
    SetBlipAsShortRange(CarDealerBlipje, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Luxury Cardealer")
    EndTextCommandSetBlipName(CarDealerBlipje)
end)

RegisterNetEvent("fortis-luxury:client:verkoopAuto")
AddEventHandler("fortis-luxury:client:verkoopAuto", function(tier, verkoperID)
    local naam = Config.AutoTier[tier].name
    local model = Config.AutoTier[tier].auto   
    local prijs = Config.AutoTier[tier].price
    local tier = tier
    local verkoperID = verkoperID
    SendNUIMessage({
        type = "verkoopVoertuig",
        naam = naam,
        tier = tier,
        prijs = prijs,
        verkoperID = verkoperID,
        model = model
    }) 
    SetNuiFocus(true, true)
end)

RegisterNetEvent("fortis-luxury:client:verkoopHeli")
AddEventHandler("fortis-luxury:client:verkoopHeli", function(tier, verkoperID)
    local naamHeli = Config.HeliTier[tier].name
    local modelHeli = Config.HeliTier[tier].heli   
    local prijsHeli = Config.HeliTier[tier].price   
    local tierHeli = tier
    local verkoperID = verkoperID
    SendNUIMessage({
        type = "verkoopVoertuig",
        naam = naamHeli,
        tier = tierHeli,
        prijs = prijsHeli,
        verkoperID = verkoperID,
    })
    SetNuiFocus(true, true)
 
end)
 
RegisterNUICallback("bevestigen", function(data, cb)
    local tier = data.tier2
    local verkoperID = data.verkoperID2
    local spawn = data.model2
    QBCore.Functions.TriggerCallback('fortis-luxury:server:koopVoertuig', function(resultaat, kenteken)
        if resultaat then
            TriggerServerEvent("fortis-luxury:server:notifyVerkoperSucces", verkoperID)
            QBCore.Functions.SpawnVehicle(""..spawn.."", function(voertuig)
                SetVehicleNumberPlateText(voertuig, kenteken)
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(voertuig))
                exports['LegacyFuel']:SetFuel(voertuig, 100)
                SetEntityHeading(voertuig, Config.Aankoop[1].h)
                SetVehicleDoorsLocked(voertuig, 2) 
            end, Config.Aankoop[1], true)
        else
            TriggerServerEvent("fortis-luxury:server:notifyVerkoperFout", verkoperID)
        end
    end, tier)
    SetNuiFocus(false, false)
end)

RegisterNUICallback("annuleer", function(data, cb)
    local tier = data.tier2
    local verkoperID = data.verkoperID2
    TriggerServerEvent("fortis-luxury:server:notifyVerkoperFout", verkoperID)
    SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
    local notified = false
    local snelheid = 0.05
    while true do
        Citizen.Wait(0)
        if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) == 15 then
            SetPlayerCanDoDriveBy(PlayerId(), false)
            if IsPedGettingIntoAVehicle(PlayerPedId()) and not notified then
                QBCore.Functions.Notify("Voer de snelheid van de heli op met pijltje omhoog en pijltje omlaag voordat je opstijgt!")
                notified = true
            end
            if GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(), false)) > 965 then
                SetHeliBladesSpeed(GetVehiclePedIsIn(PlayerPedId(), false), snelheid)
                if IsControlJustPressed(0, 172) then
                    snelheid = snelheid + 0.05
                    Citizen.Wait(200)
                elseif IsControlJustPressed(0, 173) then
                    snelheid = snelheid - 0.05
                end
                if snelheid > 1.0 then snelheid = 1.0 end
                if snelheid < 0.0 then snelheid = 0.0 end
            else
                snelheid = 5.0
            end
        else
            snelheid = 0.0
            notified = false
            SetPlayerCanDoDriveBy(PlayerId(), true)
        end
    end
end)