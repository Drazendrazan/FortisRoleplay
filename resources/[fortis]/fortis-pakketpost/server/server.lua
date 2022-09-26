QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local borg = false

RegisterServerEvent("fortis-pakketpost:server:addPakketje")
AddEventHandler("fortis-pakketpost:server:addPakketje", function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("pakketje", 1)
end)

RegisterServerEvent("fortis-pakketpost:server:addVerpaktPakketje")
AddEventHandler("fortis-pakketpost:server:addVerpaktPakketje", function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem("pakketje", 5)
    Player.Functions.AddItem("verpaktpakketje", 1)
end)

QBCore.Functions.CreateCallback("fortis-pakketpost:server:requestPakketjesAantal", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("pakketje") ~= nil and Player.Functions.GetItemByName("pakketje").amount >= 5 then
        cb(1) -- Goed, genoeg pakketjes
    else
        cb(0) -- Fout, niet genoeg pakketjes
    end
end)

QBCore.Functions.CreateCallback("fortis-pakketpost:server:requestVerpaktePakketjesAantal", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("verpaktpakketje") ~= nil and Player.Functions.GetItemByName("verpaktpakketje").amount >= 5 then
        -- Persoon heeft 5 of meer pakketjes
        cb(1, Player.Functions.GetItemByName("verpaktpakketje").amount)
    else
        -- Persoon heeft minder dan 50 pakketjes, mag geen bezorg ronde starten
        cb(0)
    end
end)

QBCore.Functions.CreateCallback("fortis-pakketpost:server:requestMissieVerpaktePakketjesAantal", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("verpaktpakketje") ~= nil and Player.Functions.GetItemByName("verpaktpakketje").amount > 0 then
        cb(Player.Functions.GetItemByName("verpaktpakketje").amount)
    else
        cb(0)
    end
end)

RegisterServerEvent("fortis-pakketpost:server:missieBetaal")
AddEventHandler("fortis-pakketpost:server:missieBetaal", function()
    local Player = QBCore.Functions.GetPlayer(source)

    local missieBetaalBedrag = math.random(450, 700)
    Player.Functions.RemoveItem("verpaktpakketje", 1)
    Player.Functions.AddMoney('bank', missieBetaalBedrag, "Pakketpost pakketje afgeleverd")
    TriggerClientEvent("QBCore:Notify", source, "Je hebt het pakketje afgeleverd, je kreeg €"..missieBetaalBedrag, "success")
end)

-- Borg

RegisterServerEvent("fortis-pakketpost:server:borg")
AddEventHandler("fortis-pakketpost:server:borg", function(status)
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