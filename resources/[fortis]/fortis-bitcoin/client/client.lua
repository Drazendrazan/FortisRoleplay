QBCore = nil
Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(1)
	end
end)

-- Locals
local serverKasten = {}
local huidigHuis = nil
local inside = false

-- Spawnen/despawnen van kasten
RegisterNetEvent("fortis-bitcoin:client:betreedHuis")
AddEventHandler("fortis-bitcoin:client:betreedHuis", function(osso)
    TriggerEvent("fortis-bitcoin:client:kastcoords")
    spawnServerKasten(osso)
    huidigHuis = osso
    inside = true
end)

RegisterNetEvent("fortis-bitcoin:client:verlaatHuis")
AddEventHandler("fortis-bitcoin:client:verlaatHuis", function(osso)
    despawnServerKasten(osso)
    huidigHuis = nil
    inside = false
end)

function spawnServerKasten(huidigHuis)
    QBCore.Functions.TriggerCallback('fortis-bitcoin:server:vraagKastenOp', function(cb)
        serverKasten[huidigHuis] = cb
        for k, v in pairs(serverKasten[huidigHuis]) do
            local serverData = {
                ["coords"] = {["x"] = json.decode(serverKasten[huidigHuis][k].coords).x, ["y"] = json.decode(serverKasten[huidigHuis][k].coords).y, ["z"] = json.decode(serverKasten[huidigHuis][k].coords).z, ["h"] = json.decode(serverKasten[huidigHuis][k].coords).h},
            }
            local hash = "hei_prop_mini_sever_01"
            
            serverProp = CreateObject(hash, serverData["coords"]["x"], serverData["coords"]["y"], serverData["coords"]["z"], false, false, false)
            PlaceObjectOnGroundProperly(serverProp)
            SetEntityHeading(serverProp, serverData["coords"]["h"])
            FreezeEntityPosition(serverProp, true)
        end
    end, huidigHuis)
end

function despawnServerKasten(huidigHuis)
    QBCore.Functions.TriggerCallback('fortis-bitcoin:server:vraagKastenOp', function(cb)
        serverKasten[huidigHuis] = cb
        for k, v in pairs(serverKasten[huidigHuis]) do
            local serverData = {
                ["coords"] = {["x"] = json.decode(serverKasten[huidigHuis][k].coords).x, ["y"] = json.decode(serverKasten[huidigHuis][k].coords).y, ["z"] = json.decode(serverKasten[huidigHuis][k].coords).z},
            }
            local hash = "hei_prop_mini_sever_01"
            
            serverDelete = GetClosestObjectOfType(serverData["coords"]["x"], serverData["coords"]["y"], serverData["coords"]["z"], 3.5, hash, false, false, false)

            DeleteObject(serverDelete)
        end
        serverKasten[huidigHuis] = {}
    end, huidigHuis)
end

function refreshServerKasten(huidigHuis)
    despawnServerKasten(huidigHuis)
    Wait(500)
    spawnServerKasten(huidigHuis)
end

-- Rack ID's showen boven kast
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if inside and #serverKasten[huidigHuis] > 0 then
            local pedPos = GetEntityCoords(PlayerPedId())
            for k, v in pairs(serverKasten[huidigHuis]) do
                local coords = json.decode(v.coords)
                if GetDistanceBetweenCoords(pedPos, coords.x, coords.y, coords.z, true) < 2 then
                    QBCore.Functions.DrawText3D(coords.x, coords.y, coords.z + 1.2, "Rack ID: "..v.rackid)
                end
            end
        else
            Citizen.Wait(5000)
        end
    end
end)

-- Kast plaatsen
RegisterNetEvent("fortis-bitcoin:client:gebruikServerkast")
AddEventHandler("fortis-bitcoin:client:gebruikServerkast", function()
    if inside then
        QBCore.Functions.TriggerCallback('fortis-bitcoin:server:vraagHoeveelheidKastenOp', function(resultaat)
            if resultaat < 10 then
                QBCore.Functions.Notify("Let op! Je kan de server niet meer herplaatsen!", "error")
                local ped = PlayerPedId()
                local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.75, -1.0)
                local pedHeading = GetEntityHeading(PlayerPedId())
                
                QBCore.Functions.Progressbar("fortis-bitcoin", "Serverkast aan het aansluiten...", 6500, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    ExecuteCommand("e mechanic3"),
                }, {}, {}, function() -- Done
                    ClearPedTasks(PlayerPedId())
                    ExecuteCommand("e c")
                    
                    local serverData = {
                        ["serverData"] = {["x"] = plyCoords.x, ["y"] = plyCoords.y, ["z"] = plyCoords.z, ["h"] = pedHeading}, 
                        ["warmth"] = 0
                    }
                    TriggerServerEvent("fortis-bitcoin:server:slaKastOp", huidigHuis, json.encode(serverData["serverData"]))
                    refreshServerKasten(huidigHuis)

                end, function() -- Cancel
                    ExecuteCommand("e c")
                    TriggerServerEvent("fortis-bitcoin:server:serverkast")
                    QBCore.Functions.Notify("Plaasting geanuleerd!", "error")
                end)
            else
                TriggerServerEvent("fortis-bitcoin:server:serverkast")
                QBCore.Functions.Notify("Je hebt niet genoeg stroomkracht voor zoveel servers!", "error")
            end
        end, huidigHuis)
    else
        QBCore.Functions.Notify("Je bent niet in een huis waar je een server kast kwijt kan!", "error")
        TriggerServerEvent("fortis-bitcoin:server:itemterug", "serverkast")
    end
end)

-- Serverkast verwijderen
RegisterNUICallback("verwijderKast", function(data, cb)
    local verwijderRackId = data.verwijderRackId
    TriggerEvent("fortis-bitcoin:client:verwijderServerKast", verwijderRackId)
end)

RegisterNetEvent("fortis-bitcoin:client:verwijderServerKast")
AddEventHandler("fortis-bitcoin:client:verwijderServerKast", function(verwijderRackId)
    local serverkast = {}
    QBCore.Functions.Notify("Deze actie is permanent, dit kan NIET teruggedraaid worden!", "error", 5000)
    QBCore.Functions.Notify("Je kan je kast gaan afsluiten! Je kan de afsluiting annuleren met G!")
    QBCore.Functions.TriggerCallback('fortis-bitcoin:server:zoekRackID', function(serverkast)
        local coords = json.decode(serverkast.coords)
        while true do
            Citizen.Wait(1)
            local pedPos = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(pedPos, coords.x, coords.y, coords.z, true) < 7 then
                DrawMarker(2, coords.x, coords.y, coords.z + 1.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                if GetDistanceBetweenCoords(pedPos, coords.x, coords.y, coords.z, true) < 2 then
                    QBCore.Functions.DrawText3D(coords.x, coords.y, coords.z + 1.0, "~g~[E]~w~ Serverkast afsluiten")
                    if IsControlJustPressed(0, 38) then
                        QBCore.Functions.Progressbar("fortis-bitcoin", "Serverkast aan het afsluiten...", 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            ExecuteCommand("e mechanic3"),
                        }, {}, {}, function() -- Done
                            ClearPedTasks(PlayerPedId())
                            ExecuteCommand("e c")
                            TriggerServerEvent("fortis-bitcoin:server:verwijderKast", verwijderRackId, huidigHuis)
                            refreshServerKasten(huidigHuis)
                            serverkast = nil
                        end, function() -- Cancel
                            ExecuteCommand("e c")
                            QBCore.Functions.Notify("Geannuleerd!", "error")
                        end)
                        return
                    end
                end
            end
    
            if IsControlJustPressed(0, 47) then
                serverkast = nil
                QBCore.Functions.Notify("Geannuleerd!", "error")
                return
            end
        end
    end, verwijderRackId)
end)

local aanHetRepairen = false
-- Repareren van onderdelen
RegisterNetEvent("fortis-bitcoin:client:repair")
AddEventHandler("fortis-bitcoin:client:repair", function(type)
    if not aanHetRepairen then
        if inside and #serverKasten[huidigHuis] > 0 then        
            local closestKastBetween = 100000
            local closestKastID = 0

            for k, v in pairs(serverKasten[huidigHuis]) do
                local kastCoords = json.decode(v.coords)
                local pedPos = GetEntityCoords(PlayerPedId())

                if GetDistanceBetweenCoords(pedPos, kastCoords.x, kastCoords.y, kastCoords.z, true) <= closestKastBetween then
                    closestKastBetween = GetDistanceBetweenCoords(pedPos, kastCoords.x, kastCoords.y, kastCoords.z, true)
                    closestKastID = v.rackid
                end
            end

            if closestKastID ~= 0 and closestKastBetween < 3 then
                if closestKastID ~= 0 then
                    aanHetRepairen = true
                    QBCore.Functions.Progressbar("fortis-bitcoin", type.." vervangen...", 5000, false, false, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        ExecuteCommand("e mechanic3"),
                    }, {}, {}, function() -- Done
                        QBCore.Functions.Notify("Je hebt de "..type.." vervangen!", "success")
                        TriggerServerEvent("fortis-bitcoin:server:vervangKastDone", closestKastID, type)
                        ClearPedTasks(PlayerPedId())
                        aanHetRepairen = false
                        ExecuteCommand("e c")
                    end)
                end
            else
                TriggerServerEvent("fortis-bitcoin:server:retourOnderdeel", type)
            end
        else
            TriggerServerEvent("fortis-bitcoin:server:retourOnderdeel", type)
        end
    else
        QBCore.Functions.Notify("Je bent al iets aan het vervangen!", "error")
        TriggerServerEvent("fortis-bitcoin:server:itemterug", type)
    end
end)

-- Laptop data
local serverDataLaptop = nil
RegisterNUICallback("laptopData", function(data, cb)
    QBCore.Functions.TriggerCallback('fortis-bitcoin:server:vraagKastenOp', function(cb)
        serverDataLaptop = cb
    end, huidigHuis)

    Citizen.Wait(300)
    cb(serverDataLaptop)
end)

RegisterNetEvent("fortis-bitcoin:client:openlaptop")
AddEventHandler("fortis-bitcoin:client:openlaptop", function()
    if inside then
        SendNUIMessage({
            type = "open",
        })
        SetNuiFocus(true, true)
    else
        QBCore.Functions.Notify("Je bent niet op een plek waar je een goede wifi verbinding hebt!", "error")
    end
end)

RegisterNUICallback("sluiten", function(data, cb)
    SetNuiFocus(false, false)
end)

-- Bitcoins uitbetalen
RegisterNUICallback("minenUitbetalenCrypto", function(data, cb)
    TriggerServerEvent("fortis-bitcoin:server:coinsBetalen", huidigHuis)
end)




local bestelling = {}
local leverTijd = nil
local leverBlipGeplaatst = false
local leverBlipLocatie = nil

RegisterNUICallback("bestellingStarten", function(data, cb)
    local tmp_type = data.type
    local tmp_amount = tonumber(data.amount)


    if #bestelling > 0 then
        -- Er staat al een bestelling open
        for k, v in pairs(bestelling) do
            if v.type == tmp_type then
                local endAmount = v.amount + tmp_amount
                if v.amount >= 10 then
                    -- Niet door gaan, limiet bereikt
                    QBCore.Functions.Notify("De voorraad van dit onderdeel is op, kom later terug!", "error")
                    return
                elseif endAmount <= 10 then
                    -- Je mag door gaan met je bestelling, tel het erbij op
                    local tmp_data = {
                        type = tmp_type,
                        amount = tmp_amount
                    }
                    if betaalVoorProducten(tmp_data) then
                        bestelling[k].amount = v.amount + tmp_amount
                        stuurMailMetLevering()
                    end
                    return
                else
                    -- Niet door gaan
                    QBCore.Functions.Notify("De voorraad van dit onderdeel is op, kom later terug!", "error")
                    return
                end
            end
        end

        -- Heeft wel bestellingen, maar product komt er niet in voor
        local tmp_data = {
            type = tmp_type,
            amount = tmp_amount
        }
        
        if betaalVoorProducten(tmp_data) then
            table.insert(bestelling, tmp_data)
            stuurMailMetLevering()
        end
    else
        -- Heeft nog geen bestellingen open staan
        local tmp_data = {
            type = tmp_type,
            amount = tmp_amount
        }

        if betaalVoorProducten(tmp_data) then
            leverTijd = math.random(7, 15)
            table.insert(bestelling, tmp_data)
            stuurMailMetLevering()
        end
    end

end)

function stuurMailMetLevering()
    local bestelItems = ""

    for k, v in pairs(bestelling) do
        bestelItems = bestelItems.."<br>x"..v.amount.." "..v.type
    end

    TriggerServerEvent("qb-phone:server:sendNewMail", {
        sender = "Fortech.nl",
        subject = "Jouw bestellingen",
        message = "Bedankt voor je bestelling(en) bij Fortech.nl!<br><br>Bestelde items:<br>"..bestelItems.."<br><br>Wij zijn hard bezig om jouw bestelling te verwerken, je kan hem om: "..leverTijd.." uur bij de telefoonwinkel ophalen.<br><br>Met vriendelijke groet,<br>Fortech.nl"
    })
end

function betaalVoorProducten(producten)
    local afrekenBedrag = 0
    heeftGenoegSaaf = false
    
    if producten.type == "processor" then
        local tmp_bedrag = producten.amount * 880
        afrekenBedrag = afrekenBedrag + tmp_bedrag
    elseif producten.type == "gpu" then
        local tmp_bedrag = producten.amount * 1300
        afrekenBedrag = afrekenBedrag + tmp_bedrag
    elseif producten.type == "koelpasta" then
        local tmp_bedrag = producten.amount * 250
        afrekenBedrag = afrekenBedrag + tmp_bedrag
    end


    QBCore.Functions.TriggerCallback("fortis-bitcoin:sever:betaalProducten", function(heeftBetaald)
        heeftGenoegSaaf = heeftBetaald
        if not heeftGenoegSaaf then
            QBCore.Functions.Notify("Je hebt niet genoeg geld op je bank staan!", "error")
        end
    end, afrekenBedrag)
    
    Wait(1500)

    return heeftGenoegSaaf
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if #bestelling > 0 then
            -- Bestellingen zijn er kijk of het al tijd is om te leveren oulleh
            if GetClockHours() == leverTijd and not leverBlipGeplaatst then
                -- Het is tijd om te leveren plaats blip, en stuur bericht
                leverBlip = AddBlipForCoord(-661.80, -861.62, 24.49)
                SetBlipSprite(leverBlip, 501)
                SetBlipScale(leverBlip, 0.8)
                SetBlipColour(leverBlip, 11)
                SetBlipAsShortRange(leverBlip, true)
                SetBlipRoute(leverBlip, true)
                SetBlipRouteColour(leverBlip, 11)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Fortech onderdelen ophalen")
                EndTextCommandSetBlipName(leverBlip)

                QBCore.Functions.Notify("Je server onderdelen zijn klaar, haal ze op bij de telefoon winkel!", "success")

                leverBlipGeplaatst = true
            elseif leverBlipGeplaatst then
                -- Blip geplaatst, tijd is dus al geweests, hij mag ophalen, wacht op marker
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -661.80, -861.62, 24.49, true) < 10 then
                    DrawMarker(2, -661.80, -861.62, 24.49, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.3, 0.1, 28, 202, 155, 155, false, false, false, true, false, false, false)
                    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -661.80, -861.62, 24.49, true) < 1.3 then
                        QBCore.Functions.DrawText3D(-661.80, -861.62, 24.49 + 0.3, "~g~[E]~w~ Order afhalen")
                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent("fortis-bitcoin:server:ontvangLevering", bestelling)
                            leverBlipGeplaatst = false
                            bestelling = {}
                            leverTijd = nil
                            RemoveBlip(leverBlip)
                            leverBlip = nil
                        end
                    end
                end
            else
                -- Wachten is leuk
                Wait(1000)
            end
        else
            Wait(1000)
        end
    end
end)


RegisterNUICallback("alert", function(data, cb)
    QBCore.Functions.Notify("Het aantal moet tussen de 1 en 10 zijn.", "error") 
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