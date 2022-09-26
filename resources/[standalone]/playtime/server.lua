QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local timesync = {}

QBCore.Functions.CreateCallback('fortis-playtime:server:getPlaytime', function(source, cb)
    local src = source
    local steam = GetSteam(source)

    if steam ~= nil then
        QBCore.Functions.ExecuteSql(false, "SELECT `playtime` FROM `players` WHERE `steam` = '" .. steam .. "'", function(result)
            if result[1]['playtime'] ~= '' and result[1]['playtime'] ~= nil then
                QBCore.Functions.ExecuteSql(false, "INSERT INTO `playtime` (`steam`, `playtime`) VALUES ('" .. steam .. "', '" .. result[1]['playtime'] .. "')")
                timesync[steam] = {
                    ['time'] = json.decode(result[1]['playtime'])
                }
                cb(result[1]['playtime'])
                QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `playtime` = NULL WHERE `steam` = '" .. steam .. "'")
            else
                QBCore.Functions.ExecuteSql(false, "SELECT `playtime` FROM `playtime` WHERE `steam` = '" .. steam .. "'", function(result)
                    if result[1] ~= nil and result[1] ~= '' then
                        timesync[steam] = {
                            ['time'] = json.decode(result[1]['playtime'])
                        }        
                        cb(result[1]['playtime'])
                    else
                        QBCore.Functions.ExecuteSql(false, "INSERT INTO `playtime` (`steam`, `playtime`) VALUES ('" .. steam .. "', '')")
                        cb(nil)
                    end
                end)
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(420000)
        SaveTimeAll()
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(v, "steam:") then
           SaveTime(v)
           return
        end
     end
end)

SaveTimeAll = function()
    if next(timesync) ~= nil then
        for k,v in pairs(timesync) do
            local steam = k
            local time = json.encode(v['time'])
            QBCore.Functions.ExecuteSql(false, "UPDATE `playtime` SET `playtime` = '" .. time .. "' WHERE `steam` = '" .. steam .. "'")
            Wait(1000)
        end
    end
end

SaveTime = function(steamid)
    if timesync[steamid] ~= nil then
        if timesync[steamid]['time']['identifier'] ~= nil then timesync[steamid]['time']['identifier'] = nil end
        local time = json.encode(timesync[steamid]['time'])
        QBCore.Functions.ExecuteSql(false, "UPDATE `playtime` SET `playtime` = '" .. time .. "' WHERE `steam` = '" .. steamid .. "'", function(done)
            if done then
                timesync[steamid] = nil
            end
        end)
    end
end

RegisterNetEvent('fortis-playtime:server:saveTime')
AddEventHandler('fortis-playtime:server:saveTime', function(seconds, minutes, hours, days)
    local src = source
    local steam = GetSteam(src)

    if steam ~= nil then
        local table = {
            ['seconds'] = seconds,
            ['minutes'] = minutes,
            ['hours'] = hours,
            ['days'] = days,
        }
        local timestamp = json.encode(table)
        timesync[steam] = {
            ['time'] = table
        }
    end
end)

GetSteam = function(id)
    local identifiers = GetPlayerIdentifiers(id)
    for k,v in pairs(identifiers) do
        if string.find(v, "steam:") then
            return v
        end
    end
end