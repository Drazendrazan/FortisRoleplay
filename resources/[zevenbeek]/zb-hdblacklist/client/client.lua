QBCore = nil

Citizen.CreateThread(function() 
    if QBCore == nil then
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

local group = "user"

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
    Citizen.Wait(1000)
    QBCore.Functions.TriggerCallback('zb-hdblacklist:server:GetPermissions', function(UserGroup)
        group = UserGroup
    end)
end)

RegisterNetEvent('QBCore:Client:OnPermissionUpdate')
AddEventHandler('QBCore:Client:OnPermissionUpdate', function(UserGroup)
    group = UserGroup
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        local ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped, false) and group == 'user' then
            local voertuigModel = GetVehiclePedIsIn(ped)
            if PlayerData.job.name ~= "police" and PlayerData.job.name ~= "ambulance" and PlayerData.job.name ~= "mechanic" then
                if GetVehicleClass(voertuigModel) == 18 and GetPedInVehicleSeat(voertuigModel, -1) == ped then
                    QBCore.Functions.Notify("Het is niet toegestaan om een hulpdiensten voertuig te stelen.", "error", 10000)
                    local voertuig = GetVehiclePedIsIn(ped, false)
                    TaskLeaveVehicle(ped, voertuig, 16)
                else -- Checken of het niet toevallig geen emergency class is, maar wel blacklisted!
                    if GetPedInVehicleSeat(voertuigModel, -1) == ped then
                        for k, v in pairs(Config.blacklist) do
                            if GetHashKey(GetVehiclePedIsIn(GetPlayerPed(-1))) == v then
                                QBCore.Functions.Notify("Het is niet toegestaan om een hulpdiensten voertuig te stelen.", "error", 10000)
                                local voertuig = GetVehiclePedIsIn(ped, false)
                                TaskLeaveVehicle(ped, voertuig, 16)
                            end
                        end
                    end
                end
            end
        end
    end
end)