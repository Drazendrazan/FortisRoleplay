QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)
    
-- [Blips] --
Citizen.CreateThread(function()
    RadiusBlip = AddBlipForRadius(-2838.8, -376.1, 3.55, 100.0)
    
    SetBlipRotation(RadiusBlip, 0)
    SetBlipColour(RadiusBlip, 15)
    SetBlipAlpha(RadiusBlip, 64)

    LabelBlip = AddBlipForCoord(-2838.8, -376.1, 3.55)
    SetBlipSprite (LabelBlip, 597)
    SetBlipDisplay(LabelBlip, 4)
    SetBlipScale  (LabelBlip, 0.7)
    SetBlipColour(LabelBlip, 0)
    SetBlipAsShortRange(LabelBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Duikplaats')
    EndTextCommandSetBlipName(LabelBlip)

    verkoopBlip = AddBlipForCoord(182.41, -1319.21, 29.31)
    SetBlipSprite (verkoopBlip, 568)
    SetBlipDisplay(verkoopBlip, 4)
    SetBlipScale  (verkoopBlip, 0.6)
    SetBlipColour(verkoopBlip, 16)
    SetBlipAsShortRange(verkoopBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Onderwatervondsten verkoop')
    EndTextCommandSetBlipName(verkoopBlip)

end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

-- [Locaties]
local coralLocaties = {
    ["locaties"] = {
        [1] = {x = -2849.25, y = -377.58, z = -40.23},
        [2] = {x = -2838.43, y = -363.63, z = -39.45},
        [3] = {x = -2823.07, y = -406.53, z = -37.86},
        [4] = {x = -2799.48, y = -459.41, z = -49.26},
        [5] = {x = -2855.09, y = -448.17, z = -37.66},
        [6] = {x = -2900.32, y = -424.06, z = -35.15},
        [7] = {x = -2892.15, y = -370.00, z = -40.05},
        [8] = {x = -2873.61, y = -322.29, z = -41.75},
        [9] = {x = -2809.60, y = -356.18, z = -34.55},
        [10] = {x = -2779.77, y = -436.82, z = -43.36},
        [11] = {x = -2782.14, y = -412.05, z = -34.05},
        [12] = {x = -2829.08, y = -430.74, z = -38.89},
        [13] = {x = -2792.12, y = -388.06, z = -26.44},
        [14] = {x = -2837.50, y = -330.40, z = -38.84},
        [15] = {x = -2828.70, y = -451.47, z = -40.16},
        [16] = {x = -2884.37, y = -431.20, z = -36.57},
        [17] = {x = -2919.12, y = -332.92, z = -38.64},
        [18] = {x = -2867.86, y = -308.59, z = -28.68},
        [19] = {x = -2846.98, y = -325.46, z = -32.61},
        [20] = {x = -2818.23, y = -341.49, z = -19.21},
        [21] = {x = -2799.18, y = -313.11, z = -18.84},
        [22] = {x = -2769.27, y = -330.41, z = -7.73},
        [23] = {x = -2766.25, y = -369.40, z = -13.24},
        [24] = {x = -2788.86, y = -384.03, z = -25.15},
    }
}

local oppakkenMogelijk = false
local letsleep = true
local npcSpawn = true

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local Ped = GetPlayerPed(-1)
        local Pos = GetEntityCoords(Ped)

        local AreaDistance = GetDistanceBetweenCoords(Pos, -2838.8, -376.1, 3.55)

        if oppakkenMogelijk == false then
            if AreaDistance < 100 then
                oppakkenMogelijk = true
                TriggerEvent("fortis-diving:client:krijgLocatie")
                Citizen.Wait(500)
            end
        else
            Citizen.Wait(2500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if npcSpawn == true then
            Citizen.Wait(500)

            local hash = GetHashKey('cs_lestercrest')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            local npc = CreatePed(4, hash, 182.41, -1319.21, 28.35, 244.0, false, true)

            FreezeEntityPosition(npc, true)	
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)	

            npcSpawn = false
        end

        local Ped = GetPlayerPed(-1)
        local Pos = GetEntityCoords(Ped)
        local verkoopDistance = GetDistanceBetweenCoords(Pos, 182.41, -1319.21, 28.35)

        if verkoopDistance <= 2 then
            QBCore.Functions.DrawText3D(182.41, -1319.21, 29.35, '~g~[E]~w~ - Verkopen')
            if IsControlJustPressed(0, 38) then
                QBCore.Functions.TriggerCallback("fortis-duiken:server:requestOnderwatervondst", function(onderwatervondstAantal)
                    if onderwatervondstAantal >= 1 then
                        TriggerServerEvent('fortis-duiken:server:verkopen')
                    else
                        QBCore.Functions.Notify("Je hebt geen onderwatervondsten bij je!", "error")
                    end
                    return
                end)
            end
        end
    end
end)

AddEventHandler("fortis-diving:client:krijgLocatie", function()

    local randomLocatie = math.random(1, #coralLocaties["locaties"])
    local missieLocatie = coralLocaties["locaties"][randomLocatie]

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            local missiePedPositie = GetEntityCoords(GetPlayerPed(-1))
            local Ped = GetPlayerPed(-1)

            local coralDistance = GetDistanceBetweenCoords(missiePedPositie, missieLocatie.x, missieLocatie.y, missieLocatie.z)

            if oppakkenMogelijk == true then
                if coralDistance <= 100 then
                    letsleep = false
                    DrawMarker(32, missieLocatie.x, missieLocatie.y, missieLocatie.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 2.5, 0.9, 255, 0, 0, 255, true, false, false, false, false, false, false)
                    if coralDistance <= 1.5 then
                        QBCore.Functions.DrawText3D(missieLocatie.x, missieLocatie.y, missieLocatie.z, '~g~[E]~w~ - Oppakken')
                        if IsControlJustPressed(0, 38) then
                            FreezeEntityPosition(Ped, true)
                            QBCore.Functions.Progressbar("take_coral", "Oppakken...", 5000, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
                                anim = "plant_floor",
                                flags = 16,
                            }, {}, {}, function() -- Done
                                TriggerServerEvent('qb-diving:server:TakeCoral')
                                ClearPedTasks(Ped)
                                FreezeEntityPosition(Ped, false)

                                oppakkenMogelijk = false
                            end, function() -- Cancel
                                ClearPedTasks(Ped)
                                FreezeEntityPosition(Ped, false)
                            end)
                            return
                        end
                    end
                end
            end
        end
    end)
end)

-- [Duikpak] --

local currentGear = {
    mask = 0,
    tank = 0,
    enabled = false
}

function DeleteGear()
	if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, 0, 1)
        DeleteEntity(currentGear.mask)
		currentGear.mask = 0
    end
    
	if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, 0, 1)
        DeleteEntity(currentGear.tank)
		currentGear.tank = 0
	end
end

RegisterNetEvent('qb-diving:client:UseGear')
AddEventHandler('qb-diving:client:UseGear', function(bool)
    if bool then
        GearAnim()
        QBCore.Functions.Progressbar("equip_gear", "Duikpak aantrekken...", 5000, false, true, {}, {}, {}, {}, function() -- Done
            DeleteGear()
            local maskModel = GetHashKey("p_d_scuba_mask_s")
            local tankModel = GetHashKey("p_s_scuba_tank_s")
    
            RequestModel(tankModel)
            while not HasModelLoaded(tankModel) do
                Citizen.Wait(1)
            end
            TankObject = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone1 = GetPedBoneIndex(GetPlayerPed(-1), 24818)
            AttachEntityToEntity(TankObject, GetPlayerPed(-1), bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.tank = TankObject
    
            RequestModel(maskModel)
            while not HasModelLoaded(maskModel) do
                Citizen.Wait(1)
            end
            
            MaskObject = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone2 = GetPedBoneIndex(GetPlayerPed(-1), 12844)
            AttachEntityToEntity(MaskObject, GetPlayerPed(-1), bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.mask = MaskObject
    
            SetEnableScuba(GetPlayerPed(-1), true)
            SetPedMaxTimeUnderwater(GetPlayerPed(-1), 9000.00)
            currentGear.enabled = true
            TriggerServerEvent('qb-diving:server:RemoveGear')
            ClearPedTasks(GetPlayerPed(-1))
            TriggerEvent('chatMessage', "SYSTEEM", "error", "/wetsuit - Duikpak uittrekken")
        end)
    else
        if currentGear.enabled then
            GearAnim()
            QBCore.Functions.Progressbar("remove_gear", "Duikpak uittrekken...", 5000, false, true, {}, {}, {}, {}, function() -- Done
                DeleteGear()

                SetEnableScuba(GetPlayerPed(-1), false)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), 120.00)
                currentGear.enabled = false
                TriggerServerEvent('qb-diving:server:GiveBackGear')
                ClearPedTasks(GetPlayerPed(-1))
                QBCore.Functions.Notify('Je hebt je duikpak uitgetrokken!')
            end)
        else
            QBCore.Functions.Notify('Je hebt geen duikpak aan!', 'error')
        end
    end
end)

function GearAnim()
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end