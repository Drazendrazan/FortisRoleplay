QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
local xSound = exports.fortissound

radius = 35
DefaultVolume = 0.3

-- QBCore.Commands.Add("vuurwerkshow", "Start de vuurwerk show, alleen voor staff.", {{name="muziek? true of false meegeven", help="ID"}}, true, function(source, args)
--     TriggerClientEvent("vuurwerk:client:startShow", -1, tonumber(args[1]))
--     print(tonumber(args[1]))
-- end, 'admin') 

QBCore.Commands.Add("vuurwerkshow", "Start de vuurwerk show, alleen voor staff.", {{name="true/false of je er muziek bij wilt of niet", help="true of false voor de muziek"}}, true, function(source, args)
    TriggerClientEvent("vuurwerk:client:startShow", -1, args[1])
    print(args[1])
    -- print(os.time(1640995170))
end, "admin")


Citizen.CreateThread(function()
    while true do
        Wait(2000)
        if os.time() >= 1640991590 then
            TriggerClientEvent("vuurwerk:client:startShow", -1, false)
            return
        end
    end
end)

RegisterNetEvent('vuurwerk:server:playMusic', function(song, entity, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    xSound:PlayUrlPos(-1, tostring(entity), song, DefaultVolume, coords)
    xSound:Distance(-1, tostring(entity), radius)
end)

-- RegisterNetEvent('vuurwerk:server:changeVolume', function(volume, entity)
--     local src = source
--     if not tonumber(volume) then return end
--     xSound:setVolume(-1, tostring(entity), volume)
-- end)