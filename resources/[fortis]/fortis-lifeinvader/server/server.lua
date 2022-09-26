QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
local xSound = exports.fortissound

local timeOut = false 

RegisterServerEvent('fortis-lifeinvader:server:setComputerState')
AddEventHandler('fortis-lifeinvader:server:setComputerState', function(stateType, state, k)
    Config.ComputerLocaties[k][stateType] = state
    TriggerClientEvent('fortis-lifeinvader:client:setComputerState', -1, stateType, state, k)
end)

-- Koop sleutel bij goon
RegisterNetEvent("fortis-lifeinvader:server:KoopSleutel")
AddEventHandler("fortis-lifeinvader:server:KoopSleutel", function()
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.PlayerData.money.cash >= Config.SleutelPrijs then 
        Player.Functions.RemoveMoney('cash', Config.SleutelPrijs, "Lifeinvader sleutel gekocht")  
        Player.Functions.AddItem("sleutel", 1)
        TriggerClientEvent("QBCore:Notify", source, "Je hebt een sleutel gekocht", "success")
    else 
        TriggerClientEvent("QBCore:Notify", source, "Je hebt niet genoeg cash bij je!", "error")
    end
end)

-- verkoop harde schijven bij goon 
RegisterNetEvent("fortis-lifeinvader:server:VerkoopHardeSchijf")
AddEventHandler("fortis-lifeinvader:server:VerkoopHardeSchijf", function()
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("harde_schijf_2") ~= nil then
        Player.Functions.RemoveItem("harde_schijf_2", 1)
        Player.Functions.AddMoney("cash", Config.HardeSchijfPrijs_2, "Harde schijf verkocht")
        TriggerClientEvent("QBCore:Notify", source, "Je hebt succesvol een harde schijf verkocht en kreeg 35.000", "success")
    elseif Player.Functions.GetItemByName("harde_schijf_3") ~= nil then
        Player.Functions.RemoveItem("harde_schijf_3", 1)
        Player.Functions.AddMoney("cash", Config.HardeSchijfPrijs_3, "Harde schijf verkocht")
        TriggerClientEvent("QBCore:Notify", source, "Je hebt succesvol een harde schijf verkocht en kreeg 45.000", "success")  
    elseif Player.Functions.GetItemByName("harde_schijf_4") ~= nil then
        Player.Functions.RemoveItem("harde_schijf_4", 1)
        Player.Functions.AddMoney("cash", Config.HardeSchijfPrijs_4, "Harde schijf verkocht")
        TriggerClientEvent("QBCore:Notify", source, "Je hebt succesvol een harde schijf verkocht en kreeg 60.000", "success")
    else  
        TriggerClientEvent("QBCore:Notify", source, "Je hebt geen harde schijven!", "error")
    end 
end)

-- Maak sleutel een usable item
QBCore.Functions.CreateUseableItem("sleutel", function(source, item)
    TriggerClientEvent("sleutel:UseSleutel", source)
end)

RegisterNetEvent("fortis-lifeinvader:server:verwijderSleutel")
AddEventHandler("fortis-lifeinvader:server:verwijderSleutel", function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem("sleutel", 1) 
end)

-- Geef speler reward bij succesvolle hack
RegisterServerEvent("fortis-lifeinvader:server:computerReward")
AddEventHandler("fortis-lifeinvader:server:computerReward", function()
    local Player = QBCore.Functions.GetPlayer(source)
    local aantal = math.random(4, 8)
    TriggerClientEvent("QBCore:Notify", source, "De computer is uitgeschakeld en je hebt er " ..aantal.. " bitoins van gehaald! Ga door naar de volgende.", "success")
    Player.Functions.AddMoney("crypto", aantal, "lifeinvader reward")
end)
 
RegisterServerEvent("fortis-lifeinvader:server:computerNetwerkReward")
AddEventHandler("fortis-lifeinvader:server:computerNetwerkReward", function()
    local Player = QBCore.Functions.GetPlayer(source)
    local yeet = math.random(1, 3)
    if yeet == 1 then
        Player.Functions.AddItem("harde_schijf_2", 1)
    elseif yeet == 2 then
        Player.Functions.AddItem("harde_schijf_3", 1)
    elseif yeet == 3 then 
        Player.Functions.AddItem("harde_schijf_4", 1)
    end
end)

RegisterServerEvent("fortis-lifeinvader:server:unlockdeur")
AddEventHandler("fortis-lifeinvader:server:unlockdeur", function()
    TriggerClientEvent("fortis-lifeinvader:client:unlockdeur", -1)
end)
 
RegisterServerEvent("fortis-lifeinvader:server:lockbuitendeuren")
AddEventHandler("fortis-lifeinvader:server:lockbuitendeuren", function()
    TriggerClientEvent("fortis-lifeinvader:client:lockbuitendeuren", -1)
    Citizen.Wait(Config.LockedIn)
    TriggerClientEvent("fortis-lifeinvader:client:lockbuitendeuren", -1)
end)

-- Scoreboard torrie
RegisterServerEvent("fortis-lifeinvader:server:setTimeout")
AddEventHandler("fortis-lifeinvader:server:setTimeout", function()
    local src = source
    if not timeOut then 
        timeOut = true 
        Citizen.Wait(Config.Timeout)
        for k, v in pairs(Config.ComputerLocaties) do 
            TriggerClientEvent('fortis-lifeinvader:client:setComputerState', -1, 'isHacked', false, k)
            if k < 3 then
                TriggerClientEvent('fortis-lifeinvader:client:setNetwerkComputerState', -1, 'isHacked', false, k)
            end
        end
        TriggerClientEvent("fortis-lifeinvader:client:setUseState", -1, "isBusy", false, 1)
        TriggerClientEvent("fortis-lifeinvader:client:setUseState", -1, "isOpened", false, 1)
        TriggerClientEvent("fortis-lifeinvader:client:resetVariables", -1)
        TriggerEvent('qb-scoreboard:server:SetActivityBusy', "lifeinvader", false)
        timeOut = false
    end
end) 

RegisterServerEvent("fortis-lifeinvader:server:startNoodstroom")
AddEventHandler("fortis-lifeinvader:server:startNoodstroom", function()
    local src = source
    TriggerEvent("fortis-lifeinvader:server:lockbuitendeuren")
    TriggerEvent("fortis-lifeinvader:server:verwijderSleutel", source)
    TriggerEvent('qb-scoreboard:server:SetActivityBusy', "lifeinvader", true)
    TriggerClientEvent("fortis-lifeinvader:client:setNoodstroom", -1, true)
    Config.Noodstroom = true
    Citizen.Wait(Config.AlarmTijd)
    TriggerClientEvent("QBCore:Notify", src, "Je hoort de noodstroom uitschakelen, je kan geen computers meer hacken!", "error")

    for k, v in pairs(Config.ComputerLocaties) do 
        TriggerClientEvent('fortis-lifeinvader:client:setComputerState', -1, 'isHacked', true, k)
        if k < 3 then
            TriggerClientEvent('fortis-lifeinvader:client:setNetwerkComputerState', -1, 'isHacked', true, k)
        end
        TriggerClientEvent("fortis-lifeinvader:client:setUseState", -1, "isOpened", true, 1)    end
    timeOut = false
end)

RegisterServerEvent("fortis-lifeinvader:client:sethackedcomputer")
AddEventHandler("fortis-lifeinvader:client:sethackedcomputer", function(status, key)
    TriggerClientEvent('fortis-lifeinvader:client:sethackedcomputer', -1, status, key)
end)

RegisterServerEvent("fortis-lifeinvader:client:sethackednetwerkcomputer")
AddEventHandler("fortis-lifeinvader:client:sethackednetwerkcomputer", function(status, key)
    TriggerClientEvent('fortis-lifeinvader:client:sethackednetwerkcomputer', -1, status, key)
end)

-- Politie melding
RegisterNetEvent("fortis-lifeinvader:server:belPolitie")
AddEventHandler("fortis-lifeinvader:server:belPolitie", function(straat, coords)
    local msg = "Overval gaande op Lifeinvader"
    local alertData = {
        title = "Lifeinvader Overal.",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg
    }
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("fortis-lifeinvader:client:belPolitieBericht", Player.PlayerData.source, msg, straat, coords)
                TriggerClientEvent("qb-phone:client:addPoliceAlert", Player.PlayerData.source, alertData)
            end
        end
	end
end)

QBCore.Functions.CreateCallback('fortis-lifeinvader:server:checkTrojan', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("trojan_usb") ~= nil then
        Player.Functions.RemoveItem("trojan_usb", 1)
        cb(true)
    else
        cb(false)
    end 
end)

-- geluid

RegisterNetEvent('fortis-lifeinvader:server:playMusic', function(song, entity, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    xSound:PlayUrlPos(-1, tostring(entity), song, Config.DefaultVolume, coords)
    xSound:Distance(-1, tostring(entity), Config.radius)
end)

RegisterNetEvent('fortis-boombox:server:changeVolume', function(volume, entity)
    local src = source
    if not tonumber(volume) then return end
    xSound:setVolume(-1, tostring(entity), volume)
end)