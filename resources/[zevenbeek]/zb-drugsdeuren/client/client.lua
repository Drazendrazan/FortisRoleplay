QBCore = nil
local test = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
       
    end
    PlayerData = QBCore.Functions.GetPlayerData()

 
  
  
    
      

end)

-- Standaard variables
local missieStatus = false
local CurrentCops = 0
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Citizen.Wait(5000)
    TriggerServerEvent('qb-anticheat:server:GetLocations')
   
          
   
 
end)
RegisterNetEvent('qb-anticheat:client:GetLocations')
AddEventHandler('qb-anticheat:client:GetLocations', function(cb) 
    Config.DeurLocaties =cb    

end)

-- Main loop
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
       
        while Config.DeurLocaties["deuren"] == nil do 
            Citizen.Wait(10000)
            TriggerServerEvent('qb-anticheat:server:GetLocations')
        end
       
        local ped = GetPlayerPed(-1)
        local pedPos = GetEntityCoords(ped)

        letsleep = true -- Optimizen

        for k, deur in pairs(Config.DeurLocaties["deuren"]) do
            local deurDistance = GetDistanceBetweenCoords(pedPos, deur["coords"]["x"], deur["coords"]["y"], deur["coords"]["z"])

            if deurDistance <= 4 then
                letsleep = false
                DrawMarker(2, deur["coords"]["x"], deur["coords"]["y"], deur["coords"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 222, 11, 11, 155, false, false, false, true, false, false, false)
                if deurDistance < 2 then
                    QBCore.Functions.DrawText3D(deur["coords"]["x"], deur["coords"]["y"], deur["coords"]["z"] - 0.10, "~g~[E]~w~ Inkopen / ~g~[G]~w~ Missie")
                    -- Controls: 38=E  //  47=G
                    -- Inkopen
                    if IsControlJustPressed(0, 38) then
                        local PlayerData = QBCore.Functions.GetPlayerData()
                        local job = PlayerData.job.name
                        if job == ("police") or job == ("ambulance") then
                            QBCore.Functions.Notify("Dit is niet toegestaan als hulpdienst.", "error")
                        else
                            local currentHours = GetClockHours()
                            local dealerUurMin = deur["tijd"]["min"]
                            local dealerUurMax = deur["tijd"]["max"]

                            if currentHours >= dealerUurMin and currentHours <= dealerUurMax then
                                local items = {}
                                items.label = deur["naam"].."'s aanbod"
                                items.items = {}
                                items.slots = 10
                                -- Load alle items
                                for a, item in pairs(Config.DeurLocaties["producten"]) do
                                    items.items[a] = Config.DeurLocaties["producten"][a]
                                end
                                -- Open de inventory met de items erin
                                TriggerServerEvent("inventory:server:OpenInventory", "shop", "DeurDealer", items) 
                            else
                                QBCore.Functions.Notify("Er is niemand aanwezig... Kom later terug!", "error")
                            end
                        end
                    end
                    -- Missie
                    if IsControlJustPressed(0, 47) then
                        if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                            local PlayerData = QBCore.Functions.GetPlayerData()
                            local job = PlayerData.job.name
                            if job == ("police") or job == ("ambulance") then
                                QBCore.Functions.Notify("Dit is niet toegestaan als hulpdienst.", "error")
                            else
                                local currentHours = GetClockHours()
                                local dealerUurMin = deur["tijd"]["min"]
                                local dealerUurMax = deur["tijd"]["max"]

                                if currentHours >= dealerUurMin and currentHours <= dealerUurMax then
                                    if missieStatus == false then
                                        QBCore.Functions.Notify("Ik stuur je zo de locatie in je mail.", "success")
                                        missieStatus = true
                                        Wait(4500)

                                        -- Maak data aan voor de missie
                                        local missieDataData = math.random(1, #Config.DeurLocaties["missies"])
                                        local missieBrickAmount = math.random(1, 3)
                                        missieData = {
                                            ["naam"] = Config.DeurLocaties["missies"][missieDataData]["naam"],
                                            ["coords"] = Config.DeurLocaties["missies"][missieDataData]["coords"],
                                            ["aantal"] = missieBrickAmount,
                                        }

                                        -- Stuur server event voor items
                                        TriggerServerEvent("zb-drugsdeuren:server:geefBricks", missieBrickAmount)
                                        TriggerServerEvent("qb-phone:server:sendNewMail", {
                                            sender = deur["naam"],
                                            subject = "Lever locatie",
                                            message = "Breng wat ik je heb gegeven, push die shit snel man broer.<br><br>Klik op het vinkje hieronder om de locatie in je GPS te zetten.",
                                            button = {
                                                enabled = true,
                                                buttonEvent = "zb-drugsdeuren:client:setMissieLocatie",
                                                buttonData = missieData
                                            }
                                        })
                                    else
                                        QBCore.Functions.Notify("Je hebt al een missie gestart!", "error")
                                    end
                                else
                                    QBCore.Functions.Notify("Er is niemand aanwezig... Kom later terug!", "error")
                                end
                            end
                        else
                            QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
                        end
                    end

                end
            end
        end

        if letsleep then
            Wait(500)
        end
    end
end)

-- Missie zetten, wanneer de telefoon vinkje getriggerd wordt
RegisterNetEvent("zb-drugsdeuren:client:setMissieLocatie")
AddEventHandler("zb-drugsdeuren:client:setMissieLocatie", function(missieData)
    local missieData = missieData

    -- Zet blip neer + route ernaar toe
    missieBlip = AddBlipForCoord(missieData["coords"].x, missieData["coords"].y, missieData["coords"].z)
    SetBlipColour(missieBlip, 3)
    SetBlipRoute(missieBlip, true)
    SetBlipRouteColour(missieBlip, 3)

    Citizen.CreateThread(function()
        while missieStatus do
            Citizen.Wait(1)

            local missiePed = GetPlayerPed(-1)
            local missiePedPositie = GetEntityCoords(missiePed)
            letsleep = true

            local missieDistance = GetDistanceBetweenCoords(missiePedPositie, missieData["coords"].x, missieData["coords"].y, missieData["coords"].z)
            if missieDistance < 10 then
                letsleep = false
                DrawMarker(2, missieData["coords"].x, missieData["coords"].y, missieData["coords"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 222, 11, 11, 155, false, false, false, true, false, false, false)
                if missieDistance < 3 then
                    QBCore.Functions.DrawText3D(missieData["coords"].x, missieData["coords"].y, missieData["coords"].z - 0.10, "~g~E~w~ - Afleveren")
                    if IsControlJustPressed(0, 38) then
                        if IsPedInAnyVehicle(missiePed, false) then
                            QBCore.Functions.Notify("Stap eerst uit je voertuig!", "error")
                        else
                            -- Kijk of de speler de bricks wel heeft tijdens het afleveren
                            QBCore.Functions.TriggerCallback("zb-drugsdeuren:server:requestBrickAantal", function(aantal)
                                if aantal < missieData["aantal"] then
                                    QBCore.Functions.Notify("Je hebt de verwachte levering niet bij je!", "error")
                                else
                                    ExecuteCommand("e lookout")
                                    doPoliceAlert()
                                    QBCore.Functions.Progressbar("drugsdeuren", "Producten afleveren...", 5500, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function() -- Done
                                        TriggerServerEvent("zb-drugsdeuren:server:missieAfleveren", missieData["aantal"])
                                        ClearPedTasks(GetPlayerPed(-1))
                                        RemoveBlip(missieBlip)
                                        QBCore.Functions.Notify("Goed werk geleverd, hier heb je wat geld.")
                                        missieStatus = false
                                        return
                                    end, function() -- Cancel
                                        ClearPedTasks(GetPlayerPed(-1))
                                        QBCore.Functions.Notify("Geannuleerd..", "error")
                                    end)
                                end
                            end)
                        end
                    end
                end
            end

            -- Optimizing
            if letsleep then
                Wait(500)
            end
        end
    end)

end)


function doPoliceAlert()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 ~= nil then 
        streetLabel = streetLabel .. " " .. street2
    end

    TriggerServerEvent('qb-drugs:server:callCops', streetLabel, pos)
end