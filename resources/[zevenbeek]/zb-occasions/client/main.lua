Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

function DrawText3Ds(x, y, z, text)
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

local occasionVehicles = {}
local inRange
local vehiclesSpawned = false
local isConfirming = false
local isConfirming2 = false

Citizen.CreateThread(function()
    while true do
        inRange = false
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        if QBCore ~= nil then
            for _,slot in pairs(Config.OccasionSlots) do
                local dist = GetDistanceBetweenCoords(pos, slot["x"], slot["y"], slot["z"])

                if dist <= 100 then
                    inRange = true
                    if not vehiclesSpawned then
                        vehiclesSpawned = true

                        QBCore.Functions.TriggerCallback('qb-occasions:server:getVehicles', function(vehicles)
                            occasionVehicles = vehicles
                            despawnOccasionsVehicles()
                            spawnOccasionsVehicles(vehicles)
                        end)
                    end
                end
            end

            if inRange then
                for i = 1, #Config.OccasionSlots, 1 do
                    local vehPos = GetEntityCoords(Config.OccasionSlots[i]["occasionid"])
                    local dstCheck = GetDistanceBetweenCoords(pos, vehPos, true)
                    if dstCheck <= 2 then
                        if not IsPedInAnyVehicle(ped) then
                            if not isConfirming and not isConfirming2 then
                                DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.25, '~g~E~w~ Om het voertuig te kopen')
                                DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.45, QBCore.Shared.Vehicles[Config.OccasionSlots[i]["model"]]["name"]..', Prijs: €'..Config.OccasionSlots[i]["price"]..',-')
                                -- DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.45, "Nieuwprijs: "..QBCore.Shared.Vehicles[Config.OccasionSlots[i]["model"]]["price"])
                                if Config.OccasionSlots[i]["owner"] == QBCore.Functions.GetPlayerData().citizenid then
                                    DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.05, '~g~G~w~ Neem voertuig terug')
                                    if IsControlJustPressed(0, Keys["G"]) then
                                        isConfirming = true
                                    end
                                end
                                if IsControlJustPressed(0, Keys["E"]) then
                                    isConfirming2 = true                                        
                                    -- currentVehicle = i
                                    -- local vehData = Config.OccasionSlots[currentVehicle]
                                    -- TriggerServerEvent('qb-occasions:server:buyVehicle', vehData)
                                end
                            else
                                if not isConfirming2 and isConfirming then
                                    DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.45, 'Weet je zeker dat je je auto uit de verkoop wilt halen?')
                                    DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.25, '~g~7~w~ - Ja | ~g~8~w~ - Nee')
                                    if IsDisabledControlJustPressed(0, Keys["7"]) then
                                        isConfirming = false
                                        currentVehicle = i
                                        TriggerServerEvent("qb-occasions:server:ReturnVehicle", Config.OccasionSlots[i])
                                    end
                                    if IsDisabledControlJustPressed(0, Keys["8"]) then
                                        isConfirming = false
                                    end
                                elseif isConfirming2 and not isConfirming then
                                    DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.45, 'Weet je zeker dat je je auto wilt kopen?')
                                    DrawText3Ds(vehPos.x, vehPos.y, vehPos.z + 1.25, '~g~7~w~ - Ja | ~g~8~w~ - Nee')
                                    if IsDisabledControlJustPressed(0, Keys["7"]) then
                                        isConfirming2 = false
                                        currentVehicle = i
                                        local vehData = Config.OccasionSlots[currentVehicle]
                                        TriggerServerEvent('qb-occasions:server:buyVehicle', vehData)
                                    end
                                    if IsDisabledControlJustPressed(0, Keys["8"]) then
                                        isConfirming2 = false
                                    end
                                end
                            end
                        end
                    end
                end

                local sellDist = GetDistanceBetweenCoords(pos, Config.SellVehicle["x"], Config.SellVehicle["y"], Config.SellVehicle["z"])
                if sellDist <= 13.0 and IsPedInAnyVehicle(ped) then 
                    DrawMarker(2, Config.SellVehicle["x"], Config.SellVehicle["y"], Config.SellVehicle["z"] + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                    if sellDist <= 1.5 and IsPedInAnyVehicle(ped) then
                        DrawText3Ds(Config.SellVehicle["x"], Config.SellVehicle["y"], Config.SellVehicle["z"], "Gebruik /verkoop2ehands met de prijs erachter.")
                    end
                end
            end

            if not inRange then
                if vehiclesSpawned then
                    vehiclesSpawned = false
                    despawnOccasionsVehicles()
                end
                Citizen.Wait(1000)
            end
        end

        Citizen.Wait(3)
    end
end)

function spawnOccasionsVehicles(vehicles)
    local oSlot = Config.OccasionSlots

    if vehicles ~= nil then
        for i = 1, #vehicles, 1 do
            local model = GetHashKey(vehicles[i].model)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end

            oSlot[i]["occasionid"] = CreateVehicle(model, oSlot[i]["x"], oSlot[i]["y"], oSlot[i]["z"], false, false)

            oSlot[i]["price"] = vehicles[i].price
            oSlot[i]["owner"] = vehicles[i].seller
            oSlot[i]["model"] = vehicles[i].model
            oSlot[i]["plate"] = vehicles[i].plate
            oSlot[i]["oid"]   = vehicles[i].occasionid
            oSlot[i]["desc"]  = vehicles[i].description
            oSlot[i]["mods"]  = vehicles[i].mods

            QBCore.Functions.SetVehicleProperties(oSlot[i]["occasionid"], json.decode(oSlot[i]["mods"]))

            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(oSlot[i]["occasionid"])
            SetEntityInvincible(oSlot[i]["occasionid"],true)
            SetEntityHeading(oSlot[i]["occasionid"], oSlot[i]["h"])
            SetVehicleDoorsLocked(oSlot[i]["occasionid"], 3)

            SetVehicleNumberPlateText(oSlot[i]["occasionid"], vehicles[i].occasionid)
            FreezeEntityPosition(oSlot[i]["occasionid"],true)
        end
    end
end

function despawnOccasionsVehicles()
    local oSlot = Config.OccasionSlots
    for i = 1, #Config.OccasionSlots, 1 do
        local oldVehicle = GetClosestVehicle(Config.OccasionSlots[i]["x"], Config.OccasionSlots[i]["y"], Config.OccasionSlots[i]["z"], 1.3, 0, 70)
        if oldVehicle ~= 0 then
            QBCore.Functions.DeleteVehicle(oldVehicle)
        end
    end
end

function openSellContract(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "sellVehicle",
        pData = QBCore.Functions.GetPlayerData(),
        plate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1)))
    })
end 

function openBuyContract(sellerData, vehicleData)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "buyVehicle",
        sellerData = sellerData,
        vehicleData = vehicleData
    })
end

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('error', function(data)
    QBCore.Functions.Notify(data.message, 'error')
end)

RegisterNUICallback('buyVehicle', function()
    local vehData = Config.OccasionSlots[currentVehicle]
    TriggerServerEvent('qb-occasions:server:buyVehicle', vehData)
end)

DoScreenFadeIn(250)

RegisterNetEvent('qb-occasions:client:ReturnOwnedVehicle')
AddEventHandler('qb-occasions:client:ReturnOwnedVehicle', function(vehdata)
    QBCore.Functions.Notify("Je auto is terug naar de rode garage gebracht")
end)

RegisterNetEvent("zb-occasions:client:verkoopAuto")
AddEventHandler("zb-occasions:client:verkoopAuto", function(prijs)
    if IsPedInAnyVehicle(PlayerPedId()) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) ~= 0 then
            local kenteken = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()))
            TriggerServerEvent("zb-occasions:server:dataCheck", kenteken, prijs)
        else
            QBCore.Functions.Notify("Je kan alleen als bestuurder auto's verkopen!", "error")
        end
    else
        QBCore.Functions.Notify("Je moet in het voertuig zitten die je wilt verkopen!", "error")
    end            
end)

RegisterNetEvent("zb-occasions:client:goedkeuringAuto")
AddEventHandler("zb-occasions:client:goedkeuringAuto", function(prijs)
    local vehicleData = {}
    local PlayerData = QBCore.Functions.GetPlayerData()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local model = GetEntityModel(vehicle)
    local spawnNaam = GetDisplayNameFromVehicleModel(model):lower() 
    local model2 = QBCore.Shared.Vehicles[spawnNaam].model
    local desc = "placeholder"
    vehicleData.ent = GetVehiclePedIsIn(PlayerPedId())
    vehicleData.model = model2
    vehicleData.plate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1)))
    vehicleData.mods = QBCore.Functions.GetVehicleProperties(vehicleData.ent)
    vehicleData.desc = desc

    TriggerServerEvent('qb-occasions:server:sellVehicle', prijs, vehicleData)
    sellVehicleWait(prijs)
end)


function sellVehicleWait(price)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
    Citizen.Wait(1500)
    DoScreenFadeIn(250)
    QBCore.Functions.Notify('Je auto staat nu te koop voor €'..price..',-', 'success')
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end

RegisterNetEvent('qb-occasion:client:refreshVehicles')
AddEventHandler('qb-occasion:client:refreshVehicles', function()
    if inRange then
        QBCore.Functions.TriggerCallback('qb-occasions:server:getVehicles', function(vehicles)
            occasionVehicles = vehicles
            despawnOccasionsVehicles()
            spawnOccasionsVehicles(vehicles)
        end)
    end
end) 

Citizen.CreateThread(function()
    OccasionBlip = AddBlipForCoord(Config.SellVehicle["x"], Config.SellVehicle["y"], Config.SellVehicle["z"])

    SetBlipSprite (OccasionBlip, 326)
    SetBlipDisplay(OccasionBlip, 4)
    SetBlipScale  (OccasionBlip, 0.75)
    SetBlipAsShortRange(OccasionBlip, true)
    SetBlipColour(OccasionBlip, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("2e hands cardealer")
    EndTextCommandSetBlipName(OccasionBlip)
end)