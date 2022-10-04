LoggedIn, Group = false, nil
 
QBCore = nil
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        RefreshMenu('All')
        QBCore.Functions.TriggerCallback('mc-adminmenu/server/get-permission', function(PGroup)
            Group = PGroup
        end)
        exports['pg-drugs']:CreateLog('Player Logged In', 'Player Logged In')
        LoggedIn = true
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    QBCore.Functions.TriggerCallback('mc-adminmenu/server/get-permission', function(PGroup)
        Group = PGroup
    end)
    exports['pg-drugs']:CreateLog('Player Logged Out', 'Player Logged Out')
    LoggedIn = false
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if BlipsEnabled then
                if BlipData ~= nil then
                    DeletePlayerBlips()
                    local ServerId = GetPlayerServerId(PlayerId())
                    for k, v in pairs(BlipData) do
                        if tonumber(v.ServerId) ~= tonumber(ServerId) then
                            local PlayerPed = GetPlayerPed(GetPlayerFromServerId(v.ServerId))
                            local PlayerBlip = AddBlipForEntity(PlayerPed) 
                            SetBlipSprite(PlayerBlip, 1)
                            SetBlipColour(PlayerBlip, 0)
                            SetBlipScale(PlayerBlip, 0.75)
                            SetBlipAsShortRange(PlayerBlip, true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString('['..v.ServerId..'] '..v.Name)
                            EndTextCommandSetBlipName(PlayerBlip)
                            table.insert(AllPlayerBlips, PlayerBlip)
                        end
                    end    
                end
                Citizen.Wait(5000)
            else
                if AllPlayerBlips ~= nil then
                    DeletePlayerBlips()
                    Citizen.Wait(450)
                end
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Mapping ] --

RegisterKeyMapping('adminmenu', Lang:t('info.keymapping_desc'), 'keyboard', Config.Settings['DefaultOpenKeybind'])
RegisterCommand('adminmenu', function(source, args, RawCommand) TriggerServerEvent('pg-drugs/server/try-open-menu', true) end, false)

-- [ Events ] --

RegisterNetEvent('pg-drugs/client/try-open-menu', function(KeyPress)
    if not IsPlayerAdmin() then return end
    if KeyPress then if not CanBind() then return end end

    local Bans = GetBans()
    local Players = GetPlayers()
    local Logs = GetLogs()

    SetCursorLocation(0.87, 0.15)
    SetNuiFocus(true, true)
    SendNUIMessage({
        Action = 'Open',
        Debug = Config.Settings['Debug'],

        Bans = Bans,
        AllPlayers = Players,
        Logs = Logs,
        AdminItems = Config.AdminMenus,
        Favorited = Config.FavoritedItems,
        PinnedPlayers = Config.PinnedTargets,
        MenuOptions = Config.AdminOptions,
        BanTypes = Config.BanTimeCategories,
    })
end)

RegisterNetEvent('pg-drugs/client/force-close', function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        Action = 'Close',
    })
end)

RegisterNetEvent("pg-drugs/client/reset-menu", function()
    if not IsPlayerAdmin() then return end

    ResetMenuKvp()
end)

-- [ NUI Callbacks ] --

RegisterNUICallback('Admin/ToggleFavorite', function(Data, Cb)
    Config.FavoritedItems[Data.Id] = Data.Toggle
    SetKvp("mc-adminmenu-favorites", json.encode(Config.FavoritedItems), "Favorites")
    Cb('Ok')
end)

RegisterNUICallback('Admin/TogglePinnedTarget', function(Data, Cb)
    Config.PinnedTargets[Data.Id] = Data.Toggle
    SetKvp("mc-adminmenu-pinned_targets", json.encode(Config.PinnedTargets), "Targets")
    Cb('Ok')
end)

RegisterNUICallback('Admin/ToggleOption', function(Data, Cb)
    Config.AdminOptions[Data.Id] = Data.Toggle
    SetKvp("mc-adminmenu-options", json.encode(Config.AdminOptions), "Options")
    Cb('Ok')
end)

RegisterNUICallback("Admin/UnbanPlayer", function(Data, Cb)
    TriggerServerEvent('pg-drugs/server/unban-player', Data.PData.BanId)
    SetTimeout(500, function()
        UpdateMenu()
    end)
    Cb('Ok')
end)

RegisterNUICallback('Admin/GetCharData', function(Data, Cb)
    QBCore.Functions.TriggerCallback('pg-drugs/server/get-player-data', function(PlayerData)
        Cb(PlayerData)
    end, Data.License)
end)

RegisterNUICallback("Admin/Close", function(Data, Cb)
   SetNuiFocus(false, false)
   Cb('Ok')
end)

RegisterNUICallback("Admin/DevMode", function(Data, Cb)
    local Bool = Data.Toggle
    ToggleDevMode(Bool)
    Cb('Ok')
end)

RegisterNUICallback("Admin/GetDateDifference", function(Data, Cb)
    QBCore.Functions.TriggerCallback('pg-drugs/server/get-date-difference', function(FBans, CAmount)
        Cb({
            Bans = FBans, 
            Amount = CAmount,
        })
    end, Data.BanList, Data.CType)
end)

RegisterNUICallback('Admin/TriggerAction', function(Data, Cb) 
    if IsPlayerAdmin() then
        if Data.EventType == nil then Data.EventType = 'Client' end
        if Data.Event ~= nil and Data.EventType ~= nil then
            if Data.EventType == 'Client' then
                TriggerEvent(Data.Event, Data.Result)
            else
                TriggerServerEvent(Data.Event, Data.Result)
            end
        end
    end
    Cb('Ok')
end)