QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local sleutels = {}

RegisterServerEvent("fortis-voertuigsleutels:server:setVoertuigOwner")
AddEventHandler("fortis-voertuigsleutels:server:setVoertuigOwner", function(kenteken)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local kenteken = kenteken

    if sleutels ~= nil then
        for k, value in pairs(sleutels) do
            if k == kenteken then
                return
            end
        end
    end

    if kenteken ~= nil then
        sleutels[kenteken] = {
            owners = {}
        }
        sleutels[kenteken].owners[1] = Player.PlayerData.citizenid
    end
end)
 

QBCore.Functions.CreateCallback("fortis-voertuigsleutels:server:checkOwner",function(source, cb, kenteken)
    local Player = QBCore.Functions.GetPlayer(source)
    local kenteken = kenteken
    local citizenid = Player.PlayerData.citizenid

    local resultaat = false

    if sleutels ~= nil then
        for k, value in pairs(sleutels) do
            if k == kenteken then
                for sleutel, owner in pairs(sleutels[k].owners) do
                    if owner == citizenid then
                        resultaat = true
                    end
                end
            end
        end
    end
    cb(resultaat)
end)

RegisterServerEvent("fortis-voertuigsleutels:server:verwijderSleutel")
AddEventHandler("fortis-voertuigsleutels:server:verwijderSleutel", function(kenteken)
    table.verwijderSleutel(sleutels, kenteken)
end)

function table.verwijderSleutel(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

RegisterServerEvent("fortis-voertuigsleutels:server:geefSleutels")
AddEventHandler("fortis-voertuigsleutels:server:geefSleutels", function(kenteken, target)
    local src = source
    local kenteken = kenteken
    local target = target
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    if QBCore.Functions.GetPlayer(target) ~= nil then
        local resultaat = false

        if sleutels ~= nil then
            for k, value in pairs(sleutels) do
                if k == kenteken then
                    for sleutel, owner in pairs(sleutels[k].owners) do
                        if owner == citizenid then
                            resultaat = true
                        end
                    end
                end
            end
        end

        if resultaat then
            -- TriggerEvent("fortis-voertuigsleutels:server:setVoertuigOwner", target, kenteken)
            setOwner(target, kenteken, src)
        else
            TriggerClientEvent('chatMessage', src, "SYSTEEM", "error", "Je hebt de sleutels van dit voertuig niet!")
        end
    else
        TriggerClientEvent('chatMessage', src, "SYSTEEM", "error", "Speler niet gevonden!")
    end
end)

function setOwner(source, kenteken, geven)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local kenteken = kenteken

    for k, v in pairs(sleutels) do
        if k == kenteken then
            local checkOwner = checkSleutels(k, Player.PlayerData.citizenid)
            if checkOwner == true then
                table.insert(v.owners, Player.PlayerData.citizenid)
                TriggerClientEvent("QBCore:Notify", src, "Je kreeg de sleutel van "..kenteken)
                TriggerClientEvent('QBCore:Notify', geven, "Je hebt de sleutels gegeven!", "success")
                return
            else
                TriggerClientEvent("QBCore:Notify", geven, "Deze persoon heeft de sleutel van dit voertuig al!", "error")
                return
            end
        end
    end
end

function checkSleutels(title, citizenid)
    local owners = sleutels[title]["owners"]
    for k, v in pairs(owners) do
        if v == citizenid then
            return false
        end
    end
    return true
end

-- Commands
QBCore.Commands.Add("geefsleutels", "Geeft de sleutels van het voertuig.", {{name = "id", help = "ID"}}, true, function(source, args)
	local src = source
    local target = tonumber(args[1])
    TriggerClientEvent('fortis-voertuigsleutels:client:geefSleutels', src, target)
end)

QBCore.Commands.Add("motor", "Start/stopt de motor van de auto.", {}, true, function(source, args)
	local src = source
    TriggerClientEvent('fortis-voertuigsleutels:client:startStopMotor', src)
    dump(sleutels)
end)

QBCore.Commands.Add("adminsleutel", "Krijg sleutel van het voertuig naast je (staff)", {}, false, function(source, args)
    local src = source
    TriggerClientEvent("fortis-voertuigsleutels:server:maakSleutelMogelijk", src)
    TriggerClientEvent("fortis-voertuigsleutels:client:adminSleutel", src)
end, "admin")

-- Items

QBCore.Functions.CreateUseableItem("lockpick", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, false)
end)

QBCore.Functions.CreateUseableItem("advancedlockpick", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, true)
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