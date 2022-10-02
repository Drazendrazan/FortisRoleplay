QBCore = nil

local seconds = 0
local minutes = 0
local hours = 0
local days = 0

Citizen.CreateThread(function() 
    while QBCore == nil do
        Citizen.Wait(200)
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
    end
    QBCore.Functions.TriggerCallback('zb-playtime:server:getPlaytime', function(result)
        if result ~= nil then
            local table = json.decode(result)
            seconds = table['seconds']
            minutes = table['minutes']
            hours = table['hours']
            days = table['days']
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        seconds = seconds + 1
        if seconds > 59 then
            seconds = 0
            minutes = minutes + 1
            TriggerServerEvent('zb-playtime:server:saveTime', seconds, minutes, hours, days)
        end
        if minutes > 59 then
            minutes = 0
            hours = hours + 1
        end
        if hours > 23 then
            hours = 0
            days = days + 1
        end
    end
end)

RegisterCommand('playtime', function(source, args)
    TriggerEvent("chat:addMessage", {
        args = {
            "Playtime",
            "Je playtime is "..days.." dagen, "..hours.." uren, "..minutes.." minuten en "..seconds.." seconden."
        },
        color = {5, 255, 255}
    })
end, false)