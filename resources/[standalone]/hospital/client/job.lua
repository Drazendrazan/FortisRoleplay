RedeVanOverlijden = {
	["WEAPON_UNARMED"] = "Neergeslagen",
	["WEAPON_KNIFE"] = "Steekwond",
    ["WEAPON_SWITCHBLADE"] = "Steekwond",
    ["WEAPON_NIGHTSTICK"] = "Slagwapen",
	["WEAPON_BAT"] = "Slagwapen",
	["WEAPON_GOLFCLUB"] = "Slagwapen",
	["WEAPON_CROWBAR"] = "Slagwapen",
	["WEAPON_PISTOL"] = "Neergeschoten",
    ["WEAPON_VINTAGEPISTOL"] = "Neergeschoten",
	["WEAPON_COMBATPISTOL"] = "Neergeschoten",
	["WEAPON_APPISTOL"] = "Neergeschoten",
	["WEAPON_PISTOL50"] = "Neergeschoten",
	["WEAPON_MICROSMG"] = "Neergeschoten",
	["WEAPON_SMG"] = "SNeergeschoten",
	["WEAPON_ASSAULTSMG"] = "Neergeschoten",
	["WEAPON_ASSAULTRIFLE"] = "Neergeschoten",
	["WEAPON_CARBINERIFLE"] = "Neergeschoten",
	["WEAPON_ADVANCEDRIFLE"] = "Neergeschoten",
	["WEAPON_MG"] = "Neergeschoten",
	["WEAPON_COMBATMG"] = "Neergeschoten",
	["WEAPON_PUMPSHOTGUN"] = "Neergeschoten",
	["WEAPON_SAWNOFFSHOTGUN"] = "Neergeschoten",
	["WEAPON_ASSAULTSHOTGUN"] = "Neergeschoten",
	["WEAPON_BULLPUPSHOTGUN"] = "Neergeschoten",
	["WEAPON_STUNGUN"] = "Getaserd",
	["WEAPON_SNIPERRIFLE"] = "Neergeschoten",
	["WEAPON_HEAVYSNIPER"] = "Neergeschoten",
	["WEAPON_DROWNING"] = "Verdonken",
	["WEAPON_DROWNING_IN_VEHICLE"] = "Verdronken",
	["WEAPON_BLEEDING"] = "Doodgebloed",
	["WEAPON_EXPLOSION"] = "Explosie",
	["WEAPON_FALL"] = "Gevallen",
	["WEAPON_RAMMED_BY_CAR"] = "Auto ongeluk",
	["WEAPON_RUN_OVER_BY_CAR"] = "Auto ongeluk",
	["WEAPON_FIRE"] = "Verbrand",
}

BodyParts = {
    ['HEAD'] = { label = 'hoofd', causeLimp = false, isDamaged = false, severity = 0 },
    ['NECK'] = { label = 'nek', causeLimp = false, isDamaged = false, severity = 0 },
    ['SPINE'] = { label = 'rug', causeLimp = true, isDamaged = false, severity = 0 },
    ['UPPER_BODY'] = { label = 'boven rug', causeLimp = false, isDamaged = false, severity = 0 },
    ['LOWER_BODY'] = { label = 'onder rug', causeLimp = true, isDamaged = false, severity = 0 },
    ['LARM'] = { label = 'linker arm', causeLimp = false, isDamaged = false, severity = 0 },
    ['LHAND'] = { label = 'linker hand', causeLimp = false, isDamaged = false, severity = 0 },
    ['LFINGER'] = { label = 'linker vingers', causeLimp = false, isDamaged = false, severity = 0 },
    ['LLEG'] = { label = 'linker been', causeLimp = true, isDamaged = false, severity = 0 },
    ['LFOOT'] = { label = 'linker voet', causeLimp = true, isDamaged = false, severity = 0 },
    ['RARM'] = { label = 'rechter arm', causeLimp = false, isDamaged = false, severity = 0 },
    ['RHAND'] = { label = 'rechter hand', causeLimp = false, isDamaged = false, severity = 0 },
    ['RFINGER'] = { label = 'rechter vingers', causeLimp = false, isDamaged = false, severity = 0 },
    ['RLEG'] = { label = 'rechter been', causeLimp = true, isDamaged = false, severity = 0 },
    ['RFOOT'] = { label = 'rechter voet', causeLimp = true, isDamaged = false, severity = 0 },
}

local deadAnimDict = "dead"
local mortuarium = {x = 308.62, y = -566.67, z = 43.44}
local deadAnim = "dead_d"

QBCore = nil

isLoggedIn = false

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    isLoggedIn = true
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        SetPedArmour(GetPlayerPed(-1), PlayerData.metadata["armor"])
        isDead = PlayerData.metadata["isdead"]
        if isDead then 
            deathTime = Config.DeathTime
            DeathTimer()
        end
    end)
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

local currentGarage = 1
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isLoggedIn and QBCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if PlayerJob.name == "doctor" or PlayerJob.name == "ambulance" then
                for k, v in pairs(Config.Locations["duty"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 5) then
                        if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                            if onDuty then
                                DrawText3D(v.x, v.y, v.z, "~r~E~w~ - Uitklokken")
                            else
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Inklokken")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                onDuty = not onDuty
                                TriggerServerEvent("QBCore:ToggleDuty")
                            end
                        elseif (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 4.5) then
                            DrawText3D(v.x, v.y, v.z, "In/Uit dienst")
                        end  
                    end
                end

                for k, v in pairs(Config.Locations["armory"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 4.5) then
                        if onDuty then
                            if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Kluis")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    TriggerServerEvent("inventory:server:OpenInventory", "shop", "hospital", Config.Items)
                                end
                            elseif (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 2.5) then
                                DrawText3D(v.x, v.y, v.z, "Kluis")
                            end  
                        end
                    end
                end
        
                for k, v in pairs(Config.Locations["vehicle"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 8.5) then
                        DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 125, 195, 37, 222, false, false, false, true, false, false, false)
                        if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Opbergen")
                            else
                                DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Garage")
                            end
                            if IsControlJustReleased(0, Keys["E"]) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                else
                                    MenuGarage()
                                    currentGarage = k
                                end
                            end
                            Menu.renderGUI()
                        end
                    end
                end
        
                for k, v in pairs(Config.Locations["helicopter"]) do
                    if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 7.5) then
                        if onDuty then
                            DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 125, 195, 37, 222, false, false, false, true, false, false, false)
                            if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Opbergen")
                                else
                                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Helicopter")
                                end
                                if IsControlJustReleased(0, Keys["E"]) then
                                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                        QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                    else
                                        local coords = Config.Locations["helicopter"][k]
                                        QBCore.Functions.SpawnVehicle(Config.Helicopter, function(veh)
                                            SetVehicleNumberPlateText(veh, "LL"..tostring(math.random(1000, 9999)))
                                            SetEntityHeading(veh, coords.h)
                                            exports['LegacyFuel']:SetFuel(veh, 100.0)
                                            closeMenuFull()
                                            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                                            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                                            SetVehicleEngineOn(veh, true, true)
                                        end, coords, true)
                                    end
                                end
                            end  
                        end
                    end
                end
            end

            local currentHospital = 1

            for k, v in pairs(Config.Locations["main"]) do
                if (GetDistanceBetweenCoords(pos,v.x,v.y,v.z, true) < 1.5) then
                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Lift")
                    if IsControlJustReleased(0, Keys["E"]) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end

                        currentHospital = k

                        local coords = Config.Locations["roof"][currentHospital]
                        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
                        SetEntityHeading(PlayerPedId(), coords.h)

                        Citizen.Wait(100)

                        DoScreenFadeIn(1000)
                    end
                end
            end

            for k, v in pairs(Config.Locations["roof"]) do
                if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 1.5) then
                    DrawText3D(v.x, v.y, v.z, "~g~E~w~ - Lift")
                    if IsControlJustReleased(0, Keys["E"]) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end

                        currentHospital = k

                        local coords = Config.Locations["main"][currentHospital]
                        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
                        SetEntityHeading(PlayerPedId(), coords.h)

                        Citizen.Wait(100)

                        DoScreenFadeIn(1000)
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isStatusChecking then
            for k, v in pairs(statusChecks) do
                local x,y,z = table.unpack(GetPedBoneCoords(statusCheckPed, v.bone))
                DrawText3D(x, y, z, v.label)
            end
        end

        if isHealingPerson then
            if not IsEntityPlayingAnim(GetPlayerPed(-1), healAnimDict, healAnim, 3) then
                loadAnimDict(healAnimDict)	
                TaskPlayAnim(GetPlayerPed(-1), healAnimDict, healAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
        end
    end
end)

RegisterNetEvent('hospital:client:SendAlert')
AddEventHandler('hospital:client:SendAlert', function(msg, balies)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    TriggerEvent("chatMessage", "PAGER", "error", msg)
end)

RegisterNetEvent('112:client:SendAlert')
AddEventHandler('112:client:SendAlert', function(msg, blipSettings)
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData ~= nil then
        if (PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "doctor") and PlayerData.job.onduty then
            PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
            TriggerEvent("chatMessage", "112-MELDING", "error", msg)
        
            if blipSettings ~= nil then
                local transG = 250
                local blip = AddBlipForCoord(blipSettings.x, blipSettings.y, blipSettings.z)
                SetBlipSprite(blip, blipSettings.sprite)
                SetBlipColour(blip, blipSettings.color)
                SetBlipDisplay(blip, 4)
                SetBlipAlpha(blip, transG)
                SetBlipScale(blip, blipSettings.scale)
                SetBlipAsShortRange(blip, false)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(blipSettings.text)
                EndTextCommandSetBlipName(blip)
                while transG ~= 0 do
                    Wait(180 * 4)
                    transG = transG - 1
                    SetBlipAlpha(blip, transG)
                    if transG == 0 then
                        SetBlipSprite(blip, 2)
                        RemoveBlip(blip)
                        return
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('hospital:client:AiCall')
AddEventHandler('hospital:client:AiCall', function()
    local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(PlayerPeds, ped)
    end
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
    local closestPed, closestDistance = QBCore.Functions.GetClosestPed(coords, PlayerPeds)
    local gender = QBCore.Functions.GetPlayerData().gender
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    if closestDistance < 50.0 and closestPed ~= 0 then
        MakeCall(closestPed, gender, street1, street2)
    end
end)

AddEventHandler("hospital:maakMeldingDood", function()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local gender = QBCore.Functions.GetPlayerData().gender
    local blipsettings = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        sprite = 280,
        color = 4,
        scale = 0.9,
        text = "112 - Gewond persoon"
    }
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    TriggerServerEvent("hospital:server:MakeDeadCall", blipsettings, male, street1, street2)
end)

function MakeCall(ped, male, street1, street2)
    local callAnimDict = "cellphone@"
    local callAnim = "cellphone_call_listen_base"
    local rand = (math.random(6,9) / 100) + 0.3
    local rand2 = (math.random(6,9) / 100) + 0.3
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local blipsettings = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        sprite = 280,
        color = 4,
        scale = 0.9,
        text = "112 - Gewond persoon"
    }

    if math.random(10) > 5 then
        rand = 0.0 - rand
    end

    if math.random(10) > 5 then
        rand2 = 0.0 - rand2
    end

    local moveto = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), rand, rand2, 0.0)

    TaskGoStraightToCoord(ped, moveto, 2.5, -1, 0.0, 0.0)
    SetPedKeepTask(ped, true) 

    local dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(ped), false)

    while dist > 3.5 and isDead do
        TaskGoStraightToCoord(ped, moveto, 2.5, -1, 0.0, 0.0)
        dist = GetDistanceBetweenCoords(moveto, GetEntityCoords(ped), false)
        Citizen.Wait(100)
    end

    ClearPedTasksImmediately(ped)
    TaskLookAtEntity(ped, GetPlayerPed(-1), 5500.0, 2048, 3)
    TaskTurnPedToFaceEntity(ped, GetPlayerPed(-1), 5500)

    Citizen.Wait(3000)

    --TaskStartScenarioInPlace(ped,"WORLD_HUMAN_STAND_MOBILE", 0, 1)
    loadAnimDict(callAnimDict)
    TaskPlayAnim(ped, callAnimDict, callAnim, 1.0, 1.0, -1, 49, 0, 0, 0, 0)

    SetPedKeepTask(ped, true) 

    Citizen.Wait(5000)

    TriggerServerEvent("hospital:server:MakeDeadCall", blipsettings, male, street1, street2)

    SetEntityAsNoLongerNeeded(ped)
    ClearPedTasks(ped)
end

RegisterNetEvent('hospital:client:RevivePlayer')
AddEventHandler('hospital:client:RevivePlayer', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerJob.name == "ambulance" or PlayerJob.name == "police" then
            
            QBCore.Functions.TriggerCallback("zb-hospital:checkAmbulanceAantal", function(aantal)
                if aantal >= 1 then
                    QBCore.Functions.Notify("Er is teveel ambulance in dienst!", "error")
                else
                    local player, distance = GetClosestPlayer()
                    if player ~= -1 and distance < 5.0 then
                        local playerId = GetPlayerServerId(player)
                        isHealingPerson = true
                        QBCore.Functions.Progressbar("hospital_revive", "Persoon omhoog helpen..", 5000, false, true, {
                            disableMovement = false,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = healAnimDict,
                            anim = healAnim,
                            flags = 16,
                        }, {}, {}, function() -- Done
                            isHealingPerson = false
                            StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                            QBCore.Functions.Notify("Je hebt de persoon geholpen!")
                            TriggerServerEvent("hospital:server:RevivePlayer", playerId)
                        end, function() -- Cancel
                            isHealingPerson = false
                            StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                            QBCore.Functions.Notify("Mislukt!", "error")
                        end)
                    end    
                end

            end)
        end
    end)
end)


RegisterNetEvent('hospital:client:CheckStatus')
AddEventHandler('hospital:client:CheckStatus', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerJob.name == "doctor" or PlayerJob.name == "ambulance" or PlayerJob.name == "police" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                statusCheckPed = GetPlayerPed(player)
                QBCore.Functions.TriggerCallback('hospital:GetPlayerStatus', function(result)
                    if result ~= nil then
                        for k, v in pairs(result) do
                            if k ~= "BLEED" and k ~= "WEAPONWOUNDS" then
                                table.insert(statusChecks, {bone = Config.BoneIndexes[k], label = v.label .." (".. Config.WoundStates[v.severity] ..")"})
                            elseif result["WEAPONWOUNDS"] ~= nil then 
                                for k, v in pairs(result["WEAPONWOUNDS"]) do
                                    TriggerEvent("chatMessage", "STATUS CHECK", "error", WeaponDamageList[v])
                                end
                            elseif result["BLEED"] > 0 then
                                TriggerEvent("chatMessage", "STATUS CHECK", "error", "Is "..Config.BleedingStates[v].label)
                            end
                        end
                        isStatusChecking = true
                        statusCheckTime = Config.CheckTime
                    end
                end, playerId)
            end
        end
    end)
end)

RegisterNetEvent('hospital:client:TreatWounds')
AddEventHandler('hospital:client:TreatWounds', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerJob.name == "doctor" or PlayerJob.name == "ambulance" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                QBCore.Functions.Progressbar("hospital_healwounds", "Persoon helpen..", 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    QBCore.Functions.Notify("Je hebt de persoon geholpen!")
                    TriggerServerEvent("hospital:server:TreatWounds", playerId)
                end, function() 
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    QBCore.Functions.Notify("Mislukt!", "error")
                end)
            end
        end
    end)
end) 

-- doodsoorzaak formulier

RegisterNetEvent("hospital:client:doodsoorzaak")
AddEventHandler("hospital:client:doodsoorzaak", function()
    pijnLedemaat = {}
    local targetPed, targetDistance = QBCore.Functions.GetClosestPlayer()
    local PlayerId = GetPlayerServerId(targetPed)
    if PlayerId ~= 0 then
        TriggerServerEvent("hospital:server:checkIsDead", PlayerId)
    elseif PlayerId == 0 then
        TriggerServerEvent("hospital:server:checkIsDead", 1)
        QBCore.Functions.Notify("Geen speler in de buurt!", "error")
    end
end)


RegisterNetEvent("hospital:client:GetInfo")
AddEventHandler("hospital:client:GetInfo", function(playerId, isdead, voornaam, achternaam, pijnlijkeplekken, soortPijn)
    local document = false
    if isdead then
        -- dit runnen als de persoon dood is
        local targetPed, targetDistance = QBCore.Functions.GetClosestPlayer()
        local botjeeeesssss = GetPlayerPed(targetPed)
        local serverID = GetPlayerServerId(targetPed)
    
        for k, v in pairs(soortPijn) do
            for i = 1, #soortPijn do
                -- loopen door de soort pijn en indexxes
                if next(soortPijn[i]) == nil then
                    -- als de soortpijn table {} is dan dit
                    mogelijkOorzaak = "Gevallen"
                elseif next(soortPijn[i]) ~= nil then
                    -- als de soortpijn table niet {} is dan dit
                    mogelijkOorzaak_tmp = v[1]
                end
            end
        end
    
        for k, v in pairs(RedeVanOverlijden) do
            if k == mogelijkOorzaak_tmp then
                -- kopel de niet nette oorzaak aan een nette oorzaak
                mogelijkOorzaak = v
            end
        end

        local tableTarget = pijnlijkeplekken[1]

        if targetDistance < 1.5 then
            -- als de ambu dichter is dan 1.5
            local keys = #tableTarget
            if keys > 0 then
                -- als er meer dan 0 pijnlijke bones zijn dan runnen
                QBCore.Functions.Progressbar("hospital_revive", "Wonden onderzoeken..", 6000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    ExecuteCommand("e medic"),
                    ExecuteCommand("e notepad"),
                }, {}, {}, function() -- Done
                    ExecuteCommand("e c")
                    document = true
                    documentbeschikbaar = false
                    QBCore.Functions.Notify("Je weet nu de plek waar de doodsoorzaak vandaan komt, druk op G om het doodsoorzaak formulier in te zien!")
                    for k, v in pairs(tableTarget) do
                        bone = v.part
                        boneId = Config.BoneIndexes[bone]
                        pijnLedemaat = GetPedBoneCoords(botjeeeesssss, boneId, 0, 0, 0)
                        -- bekend maken van welke bone bijv LLEG // boneid is de boneid waarvan de coords woorden opgehaald in pijnLedemaat
                    end
                    if pijnLedemaat ~= nil then
                        while true do
                            Citizen.Wait(1)
                            DrawMarker(2, pijnLedemaat.x, pijnLedemaat.y, pijnLedemaat.z + 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 255, 0, 0, 155, true, false, false, true, false, false, false)
                            local pedPos = GetEntityCoords(GetPlayerPed(-1))
                            if GetDistanceBetweenCoords(pijnLedemaat.x, pijnLedemaat.y, pijnLedemaat.z, pedPos.x, pedPos.y, pedPos.z) > 4 then
                                pijnLedemaat = nil
                                return
                            end
                        end
                    end
                end) 
            else
                -- als er geen pijnlijke bones zijn dan runnen // vaak bij doodvallen
                QBCore.Functions.Progressbar("hospital_revive", "Wonden onderzoeken..", 6000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    ExecuteCommand("e medic"),
                    ExecuteCommand("e notepad"),
                }, {}, {}, function() -- Done
                    ExecuteCommand("e c")
                    document = true
                    documentbeschikbaar = false
                    QBCore.Functions.Notify("Je kon niet uitvinden wat de oorzaak van overlijden is, druk op G om het doodsoorzaak formulier in te zien!")
                end)
            end

            local keys = #tableTarget

            while true do 
                Citizen.Wait(1)
                local pedPos = GetEntityCoords(PlayerPedId())
                if document == true then
                    if IsControlJustPressed(0, 47) and keys > 0 then
                        -- if not documentbeschikbaar then
                        --     documentbeschikbaar = true
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            type = "openOverlijden",
                            ledemaat = bone,
                            voornaam = voornaam,
                            achternaam = achternaam,
                        })
                        -- end
                        document = false
                    elseif  IsControlJustPressed(0, 47) and keys == 0 then
                        documentbeschikbaar = true
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            type = "openOverlijden",
                            ledemaat = "Onbekend, mogelijk gevallen?",
                            voornaam = voornaam,
                            achternaam = achternaam,
                            reden = "Mogelijk gevallen",
                        })
                        document = false
                    end
                else
                    Citizen.Wait(1000)
                end
            end
        end
    end 
end)

RegisterNUICallback("annuleer", function(data, cb)
    SetNuiFocus(false, false)
    documentbeschikbaar = false
end)
 
RegisterNUICallback("bevestig", function(data, cb)
    SetNuiFocus(false, false)
    local targetPed, targetDistance = QBCore.Functions.GetClosestPlayer()
    local PlayerId = GetPlayerServerId(targetPed)
    TriggerServerEvent("hospital:server:stopInLijkzakTrigger", PlayerId)
    Citizen.Wait(4000)
    TriggerServerEvent("hospital:server:respawnSpeler", PlayerId)
end) 

RegisterNetEvent("hospital:client:stopInLijkzakTrigger")
AddEventHandler("hospital:client:stopInLijkzakTrigger", function()
    ped = PlayerPedId()
    playerCoords = GetEntityCoords(ped) 
    hash = "xm_prop_body_bag"
    SetEntityVisible(ped, false, false)

    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Citizen.Wait(1)
    end

    bodyBag = CreateObject(hash, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)

    AttachEntityToEntity(bodyBag, ped, 0, -0.2, 0.75, 0, 0.0, 0.0, 0.0, false, false, false, false, 20, false)
end)

RegisterNetEvent("hospital:client:haalTableOp")
AddEventHandler("hospital:client:haalTableOp", function()
    TriggerServerEvent("hospital:server:stuurData", injured, CurrentDamageList)
end)

RegisterNetEvent("hospital:client:stuurnaarbed")
AddEventHandler("hospital:client:stuurnaarbed", function()
    TriggerServerEvent("hospital:server:RespawnAtHospital")
    Citizen.Wait(1000)
    
    DetachEntity(PlayerPedId(), true, false)
    SetEntityVisible(PlayerPedId(), true, true)

    SetEntityAsMissionEntity(bodyBag, false, false)
    SetEntityVisible(bodyBag, false)
    SetModelAsNoLongerNeeded(bodyBag)
    
    DeleteObject(bodyBag)
    DeleteEntity(bodyBag)
end)
-- einde doodsoorzaak 

function MenuGarage(isDown)
    local ambulanceGarage = {
        {
            header = "🚑 - Ambulance voertuigen",
            isMenuHeader = true
        }  
    }
    shouldContinue = true
    for _ , v in pairs(Config.Vehicles) do
        local vname = v
        ambulanceGarage[#ambulanceGarage+1] = {
            header = vname.." ",
            txt = "",
            params = {
                event = "hospital:client:TakeOutGarageVehicle",
                args = {
                    vehicle = _
                }
            }
        }
    end

    if shouldContinue then
        ambulanceGarage[#ambulanceGarage+1] = {
            header = "⬅ Sluit Menu",
            txt = "",
            params = {
                event = "zb-menu:client:closeMenu"
            }

        }
        exports['zb-menu']:openMenu(ambulanceGarage)
    end
end

RegisterNetEvent("hospital:client:TakeOutGarageVehicle", function(vehicledata)
    TakeOutVehicle(vehicledata)
end)

function VehicleList(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Voertuigen:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicle", {k, isDown}, "Garage", " Motor: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Terug", "MenuGarage",nil)
end

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"][currentGarage]
    QBCore.Functions.SpawnVehicle(vehicleInfo.vehicle, function(veh)
        SetVehicleDirtLevel(veh, 0)
        SetVehicleNumberPlateText(veh, "AMBU"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end