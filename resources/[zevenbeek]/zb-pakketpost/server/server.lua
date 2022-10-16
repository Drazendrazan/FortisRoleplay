QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local borg = false

RegisterServerEvent("zb-pakketpost:server:addPakketje")
AddEventHandler("zb-pakketpost:server:addPakketje", function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("pakketje", 1)
end)

RegisterServerEvent("zb-pakketpost:server:addVerpaktPakketje")
AddEventHandler("zb-pakketpost:server:addVerpaktPakketje", function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem("pakketje", 5)
    Player.Functions.AddItem("verpaktpakketje", 1)
end)

QBCore.Functions.CreateCallback("zb-pakketpost:server:requestPakketjesAantal", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("pakketje") ~= nil and Player.Functions.GetItemByName("pakketje").amount >= 5 then
        cb(1) -- Goed, genoeg pakketjes
    else
        cb(0) -- Fout, niet genoeg pakketjes
    end
end)

QBCore.Functions.CreateCallback("zb-pakketpost:server:requestVerpaktePakketjesAantal", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("verpaktpakketje") ~= nil and Player.Functions.GetItemByName("verpaktpakketje").amount >= 5 then
        -- Persoon heeft 5 of meer pakketjes
        cb(1, Player.Functions.GetItemByName("verpaktpakketje").amount)
    else
        -- Persoon heeft minder dan 50 pakketjes, mag geen bezorg ronde starten
        cb(0)
    end
end)

QBCore.Functions.CreateCallback("zb-pakketpost:server:requestMissieVerpaktePakketjesAantal", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("verpaktpakketje") ~= nil and Player.Functions.GetItemByName("verpaktpakketje").amount > 0 then
        cb(Player.Functions.GetItemByName("verpaktpakketje").amount)
    else
        cb(0)
    end
end)

RegisterServerEvent("zb-pakketpost:server:missieBetaal")
AddEventHandler("zb-pakketpost:server:missieBetaal", function()
    local Player = QBCore.Functions.GetPlayer(source)

    local missieBetaalBedrag = math.random(450, 700)
    Player.Functions.RemoveItem("verpaktpakketje", 1)
    Player.Functions.AddMoney('bank', missieBetaalBedrag, "Pakketpost pakketje afgeleverd")
    TriggerClientEvent("QBCore:Notify", source, "Je hebt het pakketje afgeleverd, je kreeg €"..missieBetaalBedrag, "success")
end)

-- Borg

RegisterServerEvent("zb-pakketpost:server:borg")
AddEventHandler("zb-pakketpost:server:borg", function(status)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if status and not borg then
        borg = true
        Player.Functions.RemoveMoney("bank", 1000, "Borg pakketpost busje betaald")
    elseif not status and borg then
        borg = false
        Player.Functions.AddMoney("bank", 1000, "Borg pakketpost busje terug")
    end
end)