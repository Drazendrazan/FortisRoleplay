QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    Wait(8000)
    TriggerServerEvent("zb-daily:server:eenJaarBestaan")
end)

-- Citizen.CreateThread(function()
--     TriggerServerEvent("zb-daily:server:eenJaarBestaan")
-- end)