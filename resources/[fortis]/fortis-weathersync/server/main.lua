AvailableWeatherTypes = {
    'EXTRASUNNY', 
    'CLEAR', 
    'NEUTRAL', 
    'SMOG', 
    'FOGGY', 
    'OVERCAST', 
    'CLOUDS', 
    'CLEARING', 
    'RAIN', 
    'THUNDER', 
    'SNOW', 
    'BLIZZARD', 
    'SNOWLIGHT', 
    'XMAS', 
    'HALLOWEEN',
}

AvailableTimeTypes = {
    'MORNING',
    'NOON',
    'EVENING',
    'NIGHT',
}

local CurrentWeather = "EXTRASUNNY"
local DynamicWeather = false
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false
-- Weer app
local regenVoorspeld = false
local onweerVoorspeld = false
local bewolkt = false

QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--CODE

RegisterServerEvent('qb-weathersync:server:RequestStateSync')
AddEventHandler('qb-weathersync:server:RequestStateSync', function()
    TriggerClientEvent('qb-weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('qb-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
end)

function FreezeElement(element)
    if element == 'weather' then
        DynamicWeather = not DynamicWeather
    else
        freezeTime = not freezeTime
    end
end

RegisterServerEvent('qb-weathersync:server:setWeather')
AddEventHandler('qb-weathersync:server:setWeather', function(type)
    local src = source
    if src ~= nil then
        TriggerEvent("qb-log:server:CreateLog", "weather", "Weer Aangepast", "red", "**".. GetPlayerName(src) .. "**")
    end
    CurrentWeather = string.upper(type)
    TriggerEvent('qb-weathersync:server:RequestStateSync')
end)

RegisterServerEvent('qb-weathersync:server:toggleBlackout')
AddEventHandler('qb-weathersync:server:toggleBlackout', function()
    ToggleBlackout()
end)

RegisterServerEvent('qb-weathersync:server:setTime')
AddEventHandler('qb-weathersync:server:setTime', function(hour, minute)
    SetExactTime(hour, minute)
end)

function SetWeather(type)
    CurrentWeather = string.upper(type)
    TriggerEvent('qb-weathersync:server:RequestStateSync')
end

function SetTime(type)
    if type:upper() == AvailableTimeTypes[1] then
        ShiftToMinute(0)
        ShiftToHour(9)
        TriggerEvent('qb-weathersync:server:RequestStateSync')
    elseif type:upper() == AvailableTimeTypes[2] then
        ShiftToMinute(0)
        ShiftToHour(12)
        TriggerEvent('qb-weathersync:server:RequestStateSync')
    elseif type:upper() == AvailableTimeTypes[3] then
        ShiftToMinute(0)
        ShiftToHour(18)
        TriggerEvent('qb-weathersync:server:RequestStateSync')
    else
        ShiftToMinute(0)
        ShiftToHour(23)
        TriggerEvent('qb-weathersync:server:RequestStateSync')
    end
end

function SetExactTime(hour, minute)
    local argh = tonumber(hour)
    local argm = tonumber(minute)
    if argh < 24 then
        ShiftToHour(argh)
    else
        ShiftToHour(0)
    end
    if argm < 60 then
        ShiftToMinute(argm)
    else
        ShiftToMinute(0)
    end
    local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
    local minute = math.floor((baseTime+timeOffset)%60)
    if minute < 10 then
        newtime = newtime .. "0" .. minute
    else
        newtime = newtime .. minute
    end
    TriggerEvent('qb-weathersync:server:RequestStateSync')
end

function ToggleBlackout()
    blackout = not blackout
    TriggerEvent('qb-weathersync:server:RequestStateSync')
end

function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        TriggerClientEvent('qb-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('qb-weathersync:client:SyncWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        -- Kijken voor sneeuwtijd perk
        local s_dag = tonumber(os.date("%d"))
        local s_maand = tonumber(os.date("%m"))
        if s_dag >= 19 and s_maand == 12 then
            -- December
            print("december")
            CurrentWeather = "XMAS"
            TriggerEvent("qb-weathersync:server:RequestStateSync")
            Wait(2000)
            return
        elseif s_dag < 2 and s_maand == 1 then
            -- Januari
            print("januari")
            CurrentWeather = "XMAS"
            TriggerEvent("qb-weathersync:server:RequestStateSync")
            Wait(2000)
            return
        end
        
        local regenGetal = math.random(1, 10)
        if regenGetal == 1 then -- Regen!
            regenVoorspeld = true
            if math.random(1, 2) == 1 then
                CurrentWeather = "OVERCAST"
            else
                CurrentWeather = "CLOUDS"
            end
            TriggerEvent("qb-weathersync:server:RequestStateSync")
            Wait(math.random(180000, 300000)) -- 3 tot 5 minuten wachten voordat we het echt laten regenen
            CurrentWeather = "RAIN"
            TriggerEvent("qb-weathersync:server:RequestStateSync")
            Wait(math.random(300000, 780000)) -- Minimaal 5, maximaal 13 minuten regen
            regenVoorspeld = false
            if math.random(1, 2) == 1 then
                bewolkt = true
                CurrentWeather = "CLEARING"
                TriggerEvent("qb-weathersync:server:RequestStateSync")
                Wait(math.random(120000, 360000)) -- Minimaal 2, maximaal 6 minuten
            else
                bewolkt = true
                CurrentWeather = "FOGGY"
                TriggerEvent("qb-weathersync:server:RequestStateSync")
            end
        else
            local onweerGetal = math.random(1, 20)
            if onweerGetal == 1 then -- Onweer!
                onweerVoorspeld = true
                CurrentWeather = "OVERCAST"
                TriggerEvent("qb-weathersync:server:RequestStateSync")
                Wait(math.random(180000, 300000)) -- Minimaal 3, maximaal 5 minuten
                CurrentWeather = "THUNDER"
                if math.random(1, 10) == 1 then
                    blackout = true
                end
                TriggerEvent("qb-weathersync:server:RequestStateSync")
                Wait(math.random(300000, 480000)) -- Minimaal 3, maximaal 8 minuten
                blackout = false
            end
        end
        CurrentWeather = "EXTRASUNNY"
        regenVoorspeld = false
        onweerVoorspeld = false
        bewolkt = false
        TriggerEvent("qb-weathersync:server:RequestStateSync")
        Wait(2700000) -- Elke 45 minuten nieuwe weers omstandigheden :)
    end
end)

QBCore.Commands.Add("sneeuwbal", "Raapt een sneeuwbal op!", {}, false, function(source, args)
    if CurrentWeather == "XMAS" then
        TriggerClientEvent("inventory:client:PickupSnowballs", source)
    else
        TriggerClientEvent('QBCore:Notify', source, "Er ligt geen sneeuw!", "error")
    end
end)

QBCore.Functions.CreateCallback("fortis-weathersync:server:weerAppData", function(source, cb)
    local weerAppData = {
        ["CurrentWeather"] = CurrentWeather,
        ["regenVoorspeld"] = regenVoorspeld,
        ["onweerVoorspeld"] = onweerVoorspeld,
        ["bewolkt"] = bewolkt
    }
    cb(weerAppData)
end)