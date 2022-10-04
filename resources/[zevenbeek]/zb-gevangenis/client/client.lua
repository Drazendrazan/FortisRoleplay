QBCore = nil

-- Communicatie middelen
local telefoon = false
local reboot = false
local portofoon = false
local maanden = 0
local klaar = false
local uitgebroken = false

Citizen.CreateThread(function() 
    Citizen.Wait(1)
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

-- NPCs
local balieGoonSpawn = true
local gymGoonSpawn = true
local kokGoonSpawn = true
local guardGoonSpawn = true
local guardGoonSpawn2 = true
local schoonmaakGoonSpawn = true

-- Tafels
local tafels = {
    ["locaties"] = {
        [1] = {x = 1775.13, y = 2577.57, z = 44.8},
        [2] = {x = 1778.85, y = 2585.23, z = 44.8},
        [3] = {x = 1784.16, y = 2578.96, z = 44.8},
    }
}

local onkruidTaken = {
	[1] = {x = 1771.42, y = 2565.33, z = 45.59},
    [2] = {x = 1771.37, y = 2546.51, z = 45.59},
	[3] = {x = 1754.46, y = 2542.74, z = 45.56},
	[4] = {x = 1736.91, y = 2563.57, z = 45.56},
	[5] = {x = 1699.02, y = 2552.81, z = 45.56},
    [6] = {x = 1728.91, y = 2510.74, z = 45.56},
	[7] = {x = 1757.06, y = 2508.22, z = 45.56},
	[8] = {x = 1759.78, y = 2516.29, z = 45.56},
	[9] = {x = 1698.69, y = 2518.78, z = 45.56},
	[10] = {x = 1686.58, y = 2526.20, z = 45.56},
}

local bezemTaken = {
	[1] = {x = 1769.43, y = 2573.76, z = 50.55, h = 87.62},
    [2] = {x = 1779.59, y = 2573.01, z = 48.58, h = 176.732},
	[3] = {x = 1769.93, y = 2594.91, z = 45.80, h = 39.23},
	[4] = {x = 1779.22, y = 2593.85, z = 45.80, h = 276.78},
	[5] = {x = 1784.81, y = 2594.13, z = 45.80, h = 169.92},
    [6] = {x = 1786.68, y = 2572.96, z = 45.80, h = 41.76},
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        -- Balie Goon Spawn
        if balieGoonSpawn == true then
            Citizen.Wait(500)
            local hash = GetHashKey('cs_molly')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            balieGoon = CreatePed(4, hash, 1789.20, 2597.13, 44.78, 190.0, false, true)

            FreezeEntityPosition(balieGoon, true)    
            SetEntityInvincible(balieGoon, true)
            SetBlockingOfNonTemporaryEvents(balieGoon, true)

            loadAnimDict("timetable@ron@ig_5_p3")
            TaskPlayAnim(balieGoon, "timetable@ron@ig_5_p3", "ig_5_p3_base", 8.0, -8, -1, 3, 0, 0, 0, 0)


            balieGoonSpawn = false
        end

        -- Gym Goon Spawn
        if gymGoonSpawn == true then
            Citizen.Wait(500)
            local hash = GetHashKey('csb_rashcosvki')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            gymGoon = CreatePed(4, hash, Config.Locaties["gymLocatie"].x, Config.Locaties["gymLocatie"].y, Config.Locaties["gymLocatie"].z, -30.0, false, true)

            FreezeEntityPosition(gymGoon, true)    
            SetEntityInvincible(gymGoon, true)
            SetBlockingOfNonTemporaryEvents(gymGoon, true)

            loadAnimDict("amb@world_human_push_ups@male@idle_a")
            TaskPlayAnim(gymGoon, "amb@world_human_push_ups@male@idle_a", "idle_d", 8.0, -8, -1, 3, 0, 0, 0, 0)


            gymGoonSpawn = false
        end

        -- Kok Goon Spawn
        if kokGoonSpawn == true then
            Citizen.Wait(500)
            local hash = GetHashKey('csb_chef')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            kokGoon = CreatePed(4, hash, Config.Locaties["kokLocatie"].x, Config.Locaties["kokLocatie"].y, Config.Locaties["kokLocatie"].z, 180.0, false, true)

            FreezeEntityPosition(kokGoon, true)    
            SetEntityInvincible(kokGoon, true)
            SetBlockingOfNonTemporaryEvents(kokGoon, true)

            loadAnimDict("rcmme_tracey1")
            TaskPlayAnim(kokGoon, "rcmme_tracey1", "nervous_loop", 8.0, -8, -1, 3, 0, 0, 0, 0)


            kokGoonSpawn = false
        end

        -- Guards Goon Spawn
        if guardGoonSpawn == true then
            Citizen.Wait(500)
            local hash = GetHashKey('csb_cop')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            guardGoon = CreatePed(4, hash, Config.Locaties["guardLocatie"].x, Config.Locaties["guardLocatie"].y, Config.Locaties["guardLocatie"].z, 180.0, false, true)

            FreezeEntityPosition(guardGoon, true)    
            SetEntityInvincible(guardGoon, true)
            SetBlockingOfNonTemporaryEvents(guardGoon, true)

            loadAnimDict("anim@amb@nightclub@peds@")
            TaskPlayAnim(guardGoon, "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", 8.0, -8, -1, 3, 0, 0, 0, 0)


            guardGoonSpawn = false
        end

        if guardGoonSpawn2 == true then
            Citizen.Wait(500)
            local hash = GetHashKey('csb_cop')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            guardGoon2 = CreatePed(4, hash, Config.Locaties["guardLocatie2"].x, Config.Locaties["guardLocatie2"].y, Config.Locaties["guardLocatie2"].z, 30.0, false, true)

            FreezeEntityPosition(guardGoon2, true)    
            SetEntityInvincible(guardGoon2, true)
            SetBlockingOfNonTemporaryEvents(guardGoon2, true)

            loadAnimDict("anim@amb@nightclub@peds@")
            TaskPlayAnim(guardGoon2, "anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop", 8.0, -8, -1, 3, 0, 0, 0, 0)


            guardGoonSpawn2 = false
        end
        
        -- Schoonmaker Spawn (soon)
        if schoonmaakGoonSpawn == true then
            Citizen.Wait(500)
            local hash = GetHashKey('s_m_y_winclean_01')
            RequestModel(hash)
            
            while not HasModelLoaded(hash) do
                Wait(1)
            end

            schoonmaakGoon = CreatePed(4, hash, Config.Locaties["schoonLocatie"].x, Config.Locaties["schoonLocatie"].y, Config.Locaties["schoonLocatie"].z, 180.0, false, true)

            FreezeEntityPosition(schoonmaakGoon, true)    
            SetEntityInvincible(schoonmaakGoon, true)
            SetBlockingOfNonTemporaryEvents(schoonmaakGoon, true)

            loadAnimDict("amb@world_human_maid_clean@")
            TaskPlayAnim(schoonmaakGoon, "amb@world_human_maid_clean@", "base", 8.0, -8, -1, 3, 0, 0, 0, 0)


            schoonmaakGoonSpawn = false
        end
    end
end)

RegisterNetEvent('zb-gevangenis:client:stuurGevangenis')
AddEventHandler('zb-gevangenis:client:stuurGevangenis', function(maandenGeven, spelerID)
    Player = QBCore.Functions.GetPlayerData()
    if Player.job.name == "police" then
        if Player.job.onduty then
            -- Speler mag mensen naar de gevangenis sturen
            if maandenGeven > 0 then
                TriggerServerEvent("zb-gevangenis:server:stuurGevangenis", maandenGeven, spelerID)
            else
                QBCore.Functions.Notify("Je moet minimaal 1 maand celstraf geven!", "error")
            end
        else
            QBCore.Functions.Notify("Je moet in dienst zijn om dit te kunnen doen!", "error")
        end
    else
        QBCore.Functions.Notify("Je moet agent zijn om dit te kunnen doen!", "error")
    end
end) 

RegisterNetEvent("zb-gevangenis:client:uitzitten")
AddEventHandler("zb-gevangenis:client:uitzitten", function(maandenDB, communicatieAfpakken)
    QBCore.Functions.Notify("Je bent naar de gevangenis gestuurd voor "..maandenDB.." maanden!", "error", 10000)
    
    if communicatieAfpakken then -- Gebeurt alleen als je eerste keer jilla in gaat
        TriggerServerEvent("zb-gevangenis:server:pakTelliesAf")
        QBCore.Functions.Notify("Je communicatie middelen zijn afgepakt, die krijg je aan het einde van je straf terug.", "error", 10000)
    end

    local ped = PlayerPedId(-1)
    SetEntityCoords(ped, 1774.31, 2568.39, 50.54, false, false, false, true)
    SetEntityHeading(ped, 1.0)
    ExecuteCommand("e passout5")
    maanden = maandenDB
    TriggerEvent("zb-gevangenis:client:jobs")

    while maanden > 0 do
        if not uitgebroken then
            QBCore.Functions.Notify("Je moet nog "..maanden.." maanden.")
            Citizen.Wait(60000)
            maanden = maanden - 1
            TriggerServerEvent("zb-gevangenis:server:updateMaanden", maanden)
        else
            return
        end
    end

    if not uitgebroken then
        TriggerEvent("zb-gevangenis:client:uitchecken")
    end
end)


AddEventHandler("zb-gevangenis:client:jobs", function()
    local opdrukken = true
    local smeren = true
    local kanOmkopen = true
    local kanOmkopen2 = true
    local schoonmaken = true
    local bezig = false

    local kans = math.random(1,3)
    local ped = GetPlayerPed(-1)
    local Skillbar = exports['zb-skillbar']:GetSkillbarObject()

    while true do
        Citizen.Wait(1)
        local pos = GetEntityCoords(ped)
        local letsleep = true

        if not klaar then
            if not bezig then
                -- Opdrukken
                if GetDistanceBetweenCoords(pos, Config.Locaties["gymLocatie"].x, Config.Locaties["gymLocatie"].y, Config.Locaties["gymLocatie"].z) < 2.5 then
                    letsleep = false
                    QBCore.Functions.DrawText3D(Config.Locaties["gymLocatie"].x, Config.Locaties["gymLocatie"].y, Config.Locaties["gymLocatie"].z + 1.0, "~g~[G]~w~ Wedstrijdje opdrukken")
                    if IsControlJustPressed(0, 47) then
                        if not opdrukken then
                            QBCore.Functions.Notify("De gevangene is moe en wilt geen wedstrijdje meer doen.", "error")
                        else
                            local SucceededAttempts = 0
                            local NeededAttempts = 10
                            opdrukken = false
                            QBCore.Functions.Notify("Druk 10x achter elkaar op en win de wedstrijd!")
                            
                            QBCore.Functions.Progressbar("opdrukken", "Aan het voorbereiden...", 5000, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "mini@triathlon",
                                anim = "idle_e",
                                flags = 3,
                            }, {}, {}, function()
                                loadAnimDict("amb@world_human_push_ups@male@idle_a")
                                TaskPlayAnim(ped, "amb@world_human_push_ups@male@idle_a", "idle_d", 8.0, -8, -1, 3, 0, 0, 0, 0)
                                Skillbar.Start({
                                    duration = math.random(1400, 2000),
                                    pos = math.random(10, 40),
                                    width = math.random(9, 13),
                                }, function()
                                    if SucceededAttempts + 1 >= NeededAttempts then
                                        ClearPedTasks(ped)
                                        SucceededAttempts = 0
                                        TriggerServerEvent("zb-gevangenis:server:krijgGeld")
                                    else
                                        Skillbar.Repeat({
                                            duration = math.random(1200, 1600),
                                            pos = math.random(10, 40),
                                            width = math.random(9, 12),
                                        })
                                        SucceededAttempts = SucceededAttempts + 1
                                    end
                                end, function()
                                    QBCore.Functions.Notify("Oei dat ging niet helemaal goed, volgende keer beter!", "error")
                                    ClearPedTasks(ped)
                                    SucceededAttempts = 0
                                end)
                            end)
                        end
                    end
                end

                -- Broodjes smeren
                if GetDistanceBetweenCoords(pos, Config.Locaties["kokLocatie"].x, Config.Locaties["kokLocatie"].y, Config.Locaties["kokLocatie"].z) < 2.5 then
                    letsleep = false
                    QBCore.Functions.DrawText3D(Config.Locaties["kokLocatie"].x, Config.Locaties["kokLocatie"].y, Config.Locaties["kokLocatie"].z + 1.0, "~g~[G]~w~ Broodjes maken")
                    if IsControlJustPressed(0, 47) then
                        if not smeren then
                            QBCore.Functions.Notify("De kok heeft geen hulp meer nodig.", "error")
                        else
                            smeren = false
                            QBCore.Functions.Notify("Smeer 5 broodjes en neem ze daarna mee naar huis!")
                            SetEntityHeading(ped, 277.0)

                            QBCore.Functions.Progressbar("smeren", "Broodjes aan het uitpakken...", 10000, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                                anim = "machinic_loop_mechandplayer",
                                flags = 16,
                            }, {}, {}, function()
                                local SucceededAttempts = 0
                                local NeededAttempts = 5
                                loadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
                                TaskPlayAnim(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8, -1, 16, 0, 0, 0, 0)
                                Skillbar.Start({
                                    duration = math.random(1500, 1600),
                                    pos = math.random(10, 40),
                                    width = math.random(9, 12),
                                }, function()
                                    if SucceededAttempts + 1 >= NeededAttempts then
                                        ClearPedTasks(ped)
                                        TriggerServerEvent("zb-gevangenis:server:krijgBroodjes")
                                    else
                                        Skillbar.Repeat({
                                            duration = math.random(1200, 1600),
                                            pos = math.random(10, 40),
                                            width = math.random(9, 12),
                                        })
                                        SucceededAttempts = SucceededAttempts + 1
                                    end
                                end, function()
                                    -- Fail
                                    QBCore.Functions.Notify("Je hebt de broodjes laten vallen, de kok heeft je hulp niet meer nodig.", "error")
                                    SucceededAttempts = 0
                                    ClearPedTasks(ped)
                                end)
                            end)
                        end
                    end
                end

                -- Beveiliger omkopen 1
                if kanOmkopen then
                    if GetDistanceBetweenCoords(pos, Config.Locaties["guardLocatie"].x, Config.Locaties["guardLocatie"].y, Config.Locaties["guardLocatie"].z) < 2.5 then
                        letsleep = false
                        QBCore.Functions.DrawText3D(Config.Locaties["guardLocatie"].x, Config.Locaties["guardLocatie"].y, Config.Locaties["guardLocatie"].z + 1.0, "~g~[E]~w~ Beveiliger omkopen (€1.000)")
                        if IsControlJustPressed(0, 38) then
                            kanOmkopen = false
                            if maanden > 5 then
                                TriggerServerEvent("zb-gevangenis:server:guardOmkopen")
                                if kans == 3 then
                                    maanden = maanden - 3
                                    TriggerServerEvent("zb-gevangenis:server:updateMaanden", maanden)
                                    QBCore.Functions.Notify("De beveiliger accepteert je aanbod en haalt 3 maanden van je straf af!", "success")
                                else
                                    maanden = maanden + 3
                                    TriggerServerEvent("zb-gevangenis:server:updateMaanden", maanden)
                                    QBCore.Functions.Notify("De beveiliger vindt dit niet kunnen en geeft je 3 maanden extra straf!", "error")
                                end
                            else 
                                QBCore.Functions.Notify("Je moet minder dan 5 maanden zitten, je kan geen beveiliger omkopen.", "error")
                            end
                        end
                    end
                end

                -- Beveiliger omkopen 2
                if kanOmkopen2 then
                    if GetDistanceBetweenCoords(pos, Config.Locaties["guardLocatie2"].x, Config.Locaties["guardLocatie2"].y, Config.Locaties["guardLocatie2"].z) < 2.5 then
                        letsleep = false
                        QBCore.Functions.DrawText3D(Config.Locaties["guardLocatie2"].x, Config.Locaties["guardLocatie2"].y, Config.Locaties["guardLocatie2"].z + 1.0, "~g~[E]~w~ Beveiliger omkopen (€1.000)")
                        if IsControlJustPressed(0, 38) then
                            kanOmkopen2 = false
                            if maanden > 5 then
                                TriggerServerEvent("zb-gevangenis:server:guardOmkopen")
                                if kans == 3 then
                                    maanden = maanden - 3
                                    TriggerServerEvent("zb-gevangenis:server:updateMaanden", maanden)
                                    QBCore.Functions.Notify("De beveiliger accepteert je aanbod en haalt 3 maanden van je straf af!", "success")
                                else
                                    maanden = maanden + 3
                                    TriggerServerEvent("zb-gevangenis:server:updateMaanden", maanden)
                                    QBCore.Functions.Notify("De beveiliger vindt dit niet kunnen en geeft je 3 maanden extra straf!", "error")
                                end
                            else 
                                QBCore.Functions.Notify("Je moet minder dan 5 maanden zitten, je kan geen beveiliger omkopen.", "error")
                            end
                        end
                    end
                end
            end

            -- Schoonmaken
            if GetDistanceBetweenCoords(pos, Config.Locaties["schoonLocatie"].x, Config.Locaties["schoonLocatie"].y, Config.Locaties["schoonLocatie"].z) < 2.5 then
                letsleep = false
                QBCore.Functions.DrawText3D(Config.Locaties["schoonLocatie"].x, Config.Locaties["schoonLocatie"].y, Config.Locaties["schoonLocatie"].z + 1.0, "~g~[G]~w~ Help met schoonmaken")
                if IsControlJustPressed(0, 47) then
                    if schoonmaken then 
                        schoonmaken = false
                        TriggerEvent("zb-gevangenis:client:schoonmaken")
                        QBCore.Functions.Notify("Help de schoonmaker met het schoon maken van de tafels!")
                    else
                        QBCore.Functions.Notify("De schoonmaker heeft geen hulp meer nodig!", "error")
                    end
                end
            end

            if maanden > 0 then
                local ped = PlayerPedId()
                local pCoords = GetEntityCoords(ped)
                for k, v in pairs(onkruidTaken) do
                    local distance = #vector3(vector3(pCoords) - vector3(onkruidTaken[k].x, onkruidTaken[k].y, onkruidTaken[k].z))
                    if distance < 5 then
                        letsleep = false
                        DrawMarker(2, onkruidTaken[k].x, onkruidTaken[k].y, onkruidTaken[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 125, 195, 37, 155, false, false, false, true, false, false, false)
                        if distance < 1 then
                            DrawMarker(2, onkruidTaken[k].x, onkruidTaken[k].y, onkruidTaken[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 125, 195, 37, 155, false, false, false, true, false, false, false)
                            QBCore.Functions.DrawText3D(onkruidTaken[k].x, onkruidTaken[k].y, onkruidTaken[k].z, "~g~E~w~ - Begin met onkruid weg scheppen")
                            if (IsControlJustReleased(1, 38)) then
                                key = k
                                QBCore.Functions.Progressbar("untowing_vehicle", "Onkruid aan het wegscheppen..", 5000, false, false, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_GARDENER_PLANT', 0, false),
                                    -- animDict = "amb@world_human_gardener_plant@male@idle_a",
                                    -- anim = "idle_a",
                                    -- flags = 16,
                                }, {}, {}, function() -- Done
                                    QBCore.Functions.Notify("Je hebt het onkruid weg gehaald!", "success")
                                    table.remove(onkruidTaken, key)
                                    if maanden > 3 then
                                        if math.random(1, 10) == 10 then
                                            QBCore.Functions.Notify("De beveiliger ziet dat je goed je best doet en haalt 3 maanden van je straf af!", "success")
                                            maanden = maanden - 3
                                            TriggerServerEvent("zb-gevangenis:server:updateMaanden", maanden)
                                        end
                                    end
                                    ClearPedTasks(ped)
                                    ExecuteCommand("e c")
                                    return
                                end)
                            end
                        end
                        
                    end
                end
            else 
                Wait(1000)
            end
 
            if maanden > 0 then
                local ped = PlayerPedId()
                local pCoords = GetEntityCoords(ped)
                for k, v in pairs(bezemTaken) do
                    local distance = #vector3(vector3(pCoords) - vector3(bezemTaken[k].x, bezemTaken[k].y, bezemTaken[k].z))
                    if distance < 5 then
                        letsleep = false
                        DrawMarker(2, bezemTaken[k].x, bezemTaken[k].y, bezemTaken[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 125, 195, 37, 155, false, false, false, true, false, false, false)
                        if distance < 1 then
                            DrawMarker(2, bezemTaken[k].x, bezemTaken[k].y, bezemTaken[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 125, 195, 37, 155, false, false, false, true, false, false, false)
                            QBCore.Functions.DrawText3D(bezemTaken[k].x, bezemTaken[k].y, bezemTaken[k].z, "~g~E~w~ - Begin de grond te vegen")
                            if (IsControlJustReleased(1, 38)) then
                                local bezemModel = "prop_tool_broom"
                                key = k
                                QBCore.Functions.Progressbar("untowing_vehicle", "Grond aan het vegen..", 5000, false, false, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    TaskStartScenarioInPlace(ped, 'world_human_janitor', 0, false),
									-- AttachEntityToEntity(bezmpieee, ped,GetPedBoneIndex(ped, 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1),
									-- bezemnetID = netid
                                }, {}, {}, function() -- Done
                                    QBCore.Functions.Notify("Je hebt alles netjes geveegd!", "success")
                                    QBCore.Functions.Notify("Mocht de bezem vastzitten in je hand doen dan even /e janitor en dan X", "error", 5000)
                                    table.remove(bezemTaken, key)
                                    if maanden > 3 then
                                        if math.random(1, 10) == 10 then
                                            QBCore.Functions.Notify("De beveiliger ziet dat je goed je best doet en haalt 3 maanden van je straf af!", "success")
                                            maanden = maanden - 3
                                            TriggerServerEvent("zb-gevangenis:server:updateMaanden", maanden)
                                        end
                                    end
                                    ClearPedTasks(ped)
                                    ExecuteCommand("e c")
                                    return
                                end)
                            end
                        end
                        
                    end
                end
            else 
                Wait(1000)
            end

        end

        if letsleep then
            Wait(1000)
        end
        if maanden < 1 then
            return
        end
        if uitgebroken then
            return
        end

    end
end)

AddEventHandler("zb-gevangenis:client:schoonmaken", function()
    Citizen.CreateThread(function()
        if #tafels["locaties"] > 0 then
            local randomLocatie = math.random(1, #tafels["locaties"])
            local tafelLocatie = tafels["locaties"][randomLocatie]

            while true do
                Citizen.Wait(1)

                local ped = GetPlayerPed(-1)
                local pos = GetEntityCoords(ped)
                local letsleep = true

                local tafelAfstand = GetDistanceBetweenCoords(pos, tafelLocatie.x, tafelLocatie.y, tafelLocatie.z)
                if tafelAfstand < 15 then
                    letsleep = false
                    DrawMarker(0, tafelLocatie.x, tafelLocatie.y, tafelLocatie.z + 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 255, 255, 255, 155, false, false, false, true, false, false, false)
                    if tafelAfstand < 2 then
                        QBCore.Functions.DrawText3D(tafelLocatie.x, tafelLocatie.y, tafelLocatie.z + 0.50, "~g~E~w~ - Schoonmaken")
                        if IsControlJustPressed(0, 38) then
                            ExecuteCommand("e clean")
                            QBCore.Functions.Progressbar("kaas", "Aan het schoonmaken...", 7000, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function()
                                QBCore.Functions.Notify("Je hebt de tafel schoon gemaakt!", "success")
                                ExecuteCommand("e c")
                                TriggerEvent("zb-gevangenis:client:schoonmaken")
                                table.remove(tafels["locaties"], randomLocatie)
                            end)
                            return
                        end
                    end
                end

                if letsleep then
                    Wait(1000)
                end
            end
        else 
            TriggerServerEvent("zb-gevangenis:server:krijgGeld")
        end
        return
    end)
end)

AddEventHandler("zb-gevangenis:client:uitchecken", function()
    if not uitgebroken then
        QBCore.Functions.Notify("Je hebt je straf netjes uitgezeten, loop naar de balie om jezelf uit te checken!", "success", 20000)
        while true do
            Citizen.Wait(1)

            klaar = true
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local letsleep = true

            if GetDistanceBetweenCoords(pos, 1789.09, 2596.48, 46.00, true) < 3 and klaar then
                letsleep = false
                QBCore.Functions.DrawText3D(1789.09, 2596.48, 46.00, "~g~[E]~w~ Uitchecken")
                if IsControlJustPressed(0, 38) then
                    QBCore.Functions.Progressbar("uitchecken", "Aan het uitchecken...", 4500, false, false, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "anim@arena@celeb@podium@no_prop@",
                        anim = "flip_off_a_1st",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        klaar = false
                        ClearPedTasksImmediately(ped)
                        TriggerServerEvent("zb-gevangenis:server:klaarMetStraf")
                        QBCore.Functions.Notify("Je hebt je spullen terug gekregen en je bent weer op vrije voeten!", "success")
                        SetEntityCoords(ped, 1832.17, 2584.75, 45.95, false, false, false, true)
                    end)
                    return
                end
            end

            if letsleep then
                Citizen.Wait(1000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if maanden > 0 then
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1779.20, 2583.55, 45.79) > 350 then
                uitgebroken = true
                klaar = false
                maanden = -1
                bezig = false
                TriggerServerEvent("zb-gevangenis:server:klaarUitbraak")
            end
        else
            Wait(1500)
        end
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end