QBCore = nil

local citizenid = nil
local playerData = nil
local updateInterval = 30000

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(100)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1000) 

        if QBCore ~= nil then
            if citizenid == nil then
                citizenid = QBCore.Functions.GetPlayerData().citizenid
            else
                local playerCoords = GetEntityCoords(GetPlayerPed(-1))
                local get = string.format("?x=%s&y=%s&cid=%s", round(playerCoords.x), round(playerCoords.y), citizenid)
                
                SendNUIMessage({
                    action = "http",
                    url = get
                })

                Citizen.Wait(updateInterval)
            end
        end
    end
end)