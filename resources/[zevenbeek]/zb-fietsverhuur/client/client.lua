QBCore = nil
cayoVerhuurStatus = false
verhuurStatus = false
allowed = true
verhuurdVoertuig = "kaas"

verhuurLocaties = {
    ["locatie"] = {
        [1] = {x = 1853.2731933594, y = 2615.0769042969, z = 45.672035217285}, -- Gevangenis
        [2] = {x = 1193.1198730469, y = 2659.8916015625, z = 37.841430664062}, -- Sandy
        [3] = {x = 216.86325073242, y = -869.95910644531, z = 30.492088317871}, -- Blokkenpark
        [4] = {x = -92.311294555664, y = 6326.5322265625, z = 31.490200042725}, -- Paleto
        [5] = {x = 261.697265625, y = -632.68267822266, z = 41.069366455078}, -- Apartement intergrity way
        [6] = {x = 294.93936157227, y = -1074.1016845703, z = 29.411088943481}, -- Apartement fantastic plaza
        [7] = {x = -1283.2368164062, y = -426.89233398438, z = 34.769176483154}, -- Apartement morningwood blvd
        [8] = {x = -630.13708496094, y = 25.476728439331, z = 40.390068054199}, -- Apartement tinsel towers
        [9] = {x = -681.5576171875, y = -1109.8208007812, z = 14.66788482666}, -- Apartement South rockford drive
        [10] = {x = -9.2778844833374, y = -1097.6270751953, z = 26.672052383423}, -- Car dealer stad
        [11] = {x = 4953.40, y = -5207.57, z = 2.52}, -- cayo perico
        [12] = {x = 4429.47, y = -4484.14, z = 4.24}, -- cayo perico2
    }
}

local blips = {
    {title="Fietsverhuur", colour = 11, id = 376, x = 1853.2731933594, y = 2615.0769042969, z = 45.672035217285}, -- Gevangenis
    {title="Fietsverhuur", colour = 11, id = 376, x = 1193.1198730469, y = 2659.8916015625, z = 37.841430664062}, -- Sandy
    {title="Fietsverhuur", colour = 11, id = 376, x = 216.86325073242, y = -869.95910644531, z = 30.492088317871}, -- Blokkenpark
    {title="Fietsverhuur", colour = 11, id = 376, x = -92.311294555664, y = 6326.5322265625, z = 31.490200042725}, -- Paleto
    {title="Fietsverhuur", colour = 11, id = 376, x = 261.697265625, y = -632.68267822266, z = 41.069366455078}, -- Apartement intergrity way
    {title="Fietsverhuur", colour = 11, id = 376, x = 294.93936157227, y = -1074.1016845703, z = 29.411088943481}, -- Apartement fantastic plaza
    {title="Fietsverhuur", colour = 11, id = 376, x = -1283.2368164062, y = -426.89233398438, z = 34.769176483154}, -- Apartement morningwood blvd
    {title="Fietsverhuur", colour = 11, id = 376, x = -630.13708496094, y = 25.476728439331, z = 40.390068054199}, -- Apartement tinsel towers
    {title="Fietsverhuur", colour = 11, id = 376, x = -681.5576171875, y = -1109.8208007812, z = 14.66788482666}, -- Apartement South rockford drive
    {title="Fietsverhuur", colour = 11, id = 376, x = -9.2778844833374, y = -1097.6270751953, z = 26.672052383423}, -- Car dealer stad
    {title="Fietsverhuur", colour = 11, id = 376, x = 4953.40, y = -5207.57, z = 2.52}, -- Cayo Perico
    {title="Fietsverhuur", colour = 11, id = 376, x = 4427.22, y = -4474.18, z = 4.32}, -- Cayo Perico2
}

Citizen.CreateThread(function() 
    Citizen.Wait(1)
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
        PlayerData = QBCore.Functions.GetPlayerData()
    end
    
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.5)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
      end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
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

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

AddEventHandler("zb-fietsverhuur:client:veranderDuty", function(duty2)
    duty = duty2
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local ped = GetPlayerPed(-1)

        letsleep = true
        
        for k, locatie in pairs(verhuurLocaties["locatie"]) do
            if (GetDistanceBetweenCoords(pos, locatie.x, locatie.y, locatie.z, true) < 4) then
                letsleep = false
                if k == 11 or k == 12 then -- cayo kanker hond
                    if not cayoVerhuurStatus then
                        DrawText3D(locatie.x, locatie.y, locatie.z, "~g~E~w~ - Quad huren")
                        allowed = true
                    else
                        DrawText3D(locatie.x, locatie.y, locatie.z, "~g~E~w~ - Quad terugbrengen") 
                        allowed = false
                    end
                else
                    if not verhuurStatus then-- Gewoon stad kanker kind
                        DrawText3D(locatie.x, locatie.y, locatie.z, "~g~E~w~ - Fiets huren")
                        allowed = true
                    else
                        DrawText3D(locatie.x, locatie.y, locatie.z, "~g~E~w~ - Fiets terugbrengen")
                        allowed = false
                    end
                end

                if IsControlJustReleased(0, 51) then
                    local opVoertuig = IsPedInAnyVehicle(ped, false)
                    local voertuigType = "kaas"
                    if not opVoertuig then
                        if k == 11 or k == 12 then
                            voertuigType = "blazer"
                            cayoVerhuurStatus = true
                        else
                            voertuigType = "fixter"
                            verhuurStatus = true
                        end

                        if allowed then
                            QBCore.Functions.SpawnVehicle(voertuigType, function(voertuigje)
                                TaskWarpPedIntoVehicle(GetPlayerPed(-1), voertuigje, -1)
                                if voertuigType ~= "fixter" then
                                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(voertuigje))
                                    exports['LegacyFuel']:SetFuel(voertuigje, 100)
                                end
                                verhuurdVoertuig = voertuigType
                            end)
                        else
                        end
                    else
                        local voertuig = GetEntityModel(GetVehiclePedIsIn(ped))
                        if voertuig == GetHashKey(verhuurdVoertuig) then
                            DeleteVehicle(GetVehiclePedIsIn(ped))
                            verhuurStatus = false
                            cayoVerhuurStatus = false
                            QBCore.Functions.Notify('Je hebt je '..verhuurdVoertuig..' in goede orde teruggebracht!', 'success')
                        else
                            QBCore.Functions.Notify('Dit is niet het juiste voertuig!', 'error')
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

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end