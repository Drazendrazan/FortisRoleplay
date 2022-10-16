QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
SpectateData = {}

-- [ Code ] --

-- [ Callbacks ] --

QBCore.Functions.CreateCallback('mc-adminmenu/server/get-permission', function(source, Cb)
    -- local Group = QBCore.Functions.GetPermission(source)

    local Group = 'User'
    
    if QBCore.Functions.HasPermission(source, 'god') then 
        Group = 'god'
    end
    if QBCore.Functions.HasPermission(source, 'admin') then 
        Group = "admin"
    end
    if QBCore.Functions.HasPermission(source, 'mod') then 
        Group = "mod"
    end
    
    Cb(Group)
end)

QBCore.Functions.CreateCallback('pg-drugs/server/get-active-players-in-radius', function(Source, Cb, Coords, Radius)
	local Coords, Radius = Coords ~= nil and vector3(Coords.x, Coords.y, Coords.z) or GetEntityCoords(GetPlayerPed(Source)), Radius ~= nil and Radius or 5.0
    local ActivePlayers = {}
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local TargetCoords = GetEntityCoords(GetPlayerPed(v))
        local TargetDistance = #(TargetCoords - Coords)
        if TargetDistance <= Radius then
            ActivePlayers[#ActivePlayers + 1] = {
                ['ServerId'] = v,
                ['Name'] = GetPlayerName(v)
            }
        end
	end
	Cb(ActivePlayers)
end)

QBCore.Functions.CreateCallback('pg-drugs/server/get-bans', function(source, Cb)
    local BanList = {}
    -- local BansData = MySQL.Sync.fetchAll('SELECT * FROM bans', {})
    -- if BansData and BansData[1] ~= nil then
    --     for k, v in pairs(BansData) do
    --         local TPlayer = GetPlayerFromLicense(v.license)
    --         if TPlayer ~= nil then
    --             BanList[#BanList + 1] = {
    --                 Text = v.name.." ("..v.banid..")",
    --                 BanId = v.banid,
    --                 Source = TPlayer.Source,
    --                 Name = v.name,
    --                 Reason = v.reason,
    --                 Expires = os.date('*t', tonumber(v.expire)),
    --                 BannedOn = os.date('*t', tonumber(v.bannedon)),
    --                 BannedOnN = v.bannedon,
    --                 BannedBy = v.bannedby,
    --                 License = v.license,
    --                 Discord = v.discord,
    --             }
    --         end
    --     end
    -- end
    Cb(BanList)
end)

QBCore.Functions.CreateCallback('pg-drugs/server/get-logs', function(source, Cb)
    local LogsList = {}
    -- local LogsData = MySQL.query.await('SELECT * FROM logs', {})
    -- if LogsData and LogsData[1] ~= nil then
    --     for k, v in pairs(LogsData) do
    --         LogsList[#LogsList + 1] = {
    --             Type = v.Type ~= nil and v.Type or Lang:t('logs.no_type'),
    --             license = v.license ~= nil and v.license  or Lang:t('logs.no_desc'),
    --             Desc = v.Log ~= nil and v.Log or Lang:t('logs.no_Desc'),
    --             Date = v.Date ~= nil and v.Date or Lang:t('logs.no_date'),
    --             Cid = v.Cid ~= nil and v.Cid or Lang:t('logs.no_cid'),
    --             Data = v.Data ~= nil and v.Data or Lang:t('logs.no_data'),
    --         }
    --     end
    -- end
    Cb(LogsList)
end)
 
QBCore.Functions.CreateCallback('pg-drugs/server/get-players', function(source, Cb)
    local PlayerList = {}
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        PlayerList[#PlayerList + 1] = {
            ServerId = v,
            Name = GetPlayerName(v),
            license = QBCore.Functions.GetIdentifier(v, "license"),
            License = QBCore.Functions.GetIdentifier(v, "license")
        }
    end
    Cb(PlayerList)
end)

QBCore.Functions.CreateCallback('pg-drugs/server/get-player-data', function(source, Cb, LicenseData)
    local PlayerInfo = {}
    for license, _ in pairs(LicenseData) do
        local TPlayer = GetPlayerFromLicense(license)
        if TPlayer ~= nil then
            PlayerInfo = {
                Name = TPlayer.PlayerData.name,
                license = QBCore.Functions.GetIdentifier(TPlayer.PlayerData.source, "license"),
                CharName = TPlayer.PlayerData.charinfo.firstname..' '..TPlayer.PlayerData.charinfo.lastname,
                Source = TPlayer.PlayerData.source,
                CitizenId = TPlayer.PlayerData.citizenid
            }
        end
        Cb(PlayerInfo)
    end
end)

QBCore.Functions.CreateCallback('pg-drugs/server/get-date-difference', function(source, Cb, Bans, Type)
    local FilteredBans, BanAmount = GetDateDifference(Type, Bans) 
    Cb(FilteredBans, BanAmount)
end)

QBCore.Functions.CreateCallback("pg-drugs/server/create-log", function(source, Cb, Type, Log, Data)
    if Type == nil or Log == nil then return end

    local Player = QBCore.Functions.GetPlayer(source)
    local license = QBCore.Functions.GetIdentifier(source, "license")
    if Player ~= nil then
        -- MySQL.insert('INSERT INTO logs (Type, license, Log, Cid, Data) VALUES (?, ?, ?, ?, ?)', {
        --     Type,
        --     license,
        --     Log,
        --     Player.PlayerData.citizenid ~= nil and Player.PlayerData.citizenid or "Not found",
        --     Data,
        -- })
    end
end)

-- [ Events ] --

RegisterNetEvent("pg-drugs/server/try-open-menu", function(KeyPress)
    local src = source
    if not AdminCheck(src) then return end
    
    TriggerClientEvent('pg-drugs/client/try-open-menu', src, KeyPress)
end)

-- User Actions

RegisterNetEvent("pg-drugs/server/unban-player", function(BanId)
    local src = source
    if not AdminCheck(src) then return end

    -- local BanData = MySQL.query.await('SELECT * FROM bans WHERE banid = ?', {BanId})
    -- if BanData and BanData[1] ~= nil then
    --     MySQL.query('DELETE FROM bans WHERE banid = ?', {BanId})
    --     TriggerClientEvent('QBCore:Notify', src, Lang:t('bans.unbanned'), 'success')
    -- else
    --     TriggerClientEvent('QBCore:Notify', src, Lang:t('bans.not_banned'), 'error')
    -- end
end)

RegisterNetEvent("pg-drugs/server/ban-player", function(ServerId, Expires, Reason)
    local src = source
    if not AdminCheck(src) then return end

    local License = QBCore.Functions.GetIdentifier(ServerId, 'license')
    -- local BanData = MySQL.query.await('SELECT * FROM bans WHERE license = ?', {License})
    -- if BanData and BanData[1] ~= nil then
    --     for k, v in pairs(BanData) do
    --         TriggerClientEvent('QBCore:Notify', src, Lang:t('bans.already_banned', {player = GetPlayerName(ServerId), reason = v.reason}), 'error')
    --     end
    -- else
    --     local Expiring, ExpireDate = GetBanTime(Expires)
    --     local Time = os.time()
    --     local BanId = "BAN-"..math.random(11111, 99999)
    --     -- MySQL.insert('INSERT INTO bans (banid, name, license, discord, ip, reason, bannedby, expire, bannedon) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
    --     --     BanId,
    --     --     GetPlayerName(ServerId),
    --     --     License,
    --     --     QBCore.Functions.GetIdentifier(ServerId, 'discord'),
    --     --     QBCore.Functions.GetIdentifier(ServerId, 'ip'),
    --     --     Reason,
    --     --     GetPlayerName(src),
    --     --     ExpireDate,
    --     --     Time,
    --     -- })
    --     -- TriggerClientEvent('QBCore:Notify', src, Lang:t('bans.success_banned', {player = GetPlayerName(ServerId), reason = Reason}), 'success')
    --     local ExpireHours = tonumber(Expiring['hour']) < 10 and "0"..Expiring['hour'] or Expiring['hour']
    --     local ExpireMinutes = tonumber(Expiring['min']) < 10 and "0"..Expiring['min'] or Expiring['min']
    --     local ExpiringDate = Expiring['day'] .. '/' .. Expiring['month'] .. '/' .. Expiring['year'] .. ' | '..ExpireHours..':'..ExpireMinutes
    --     if Expires == "Permanent" then
    --         DropPlayer(ServerId,  Lang:t('bans.perm_banned', {reason = Reason}))
    --     else
    --         DropPlayer(ServerId, Lang:t('bans.banned', {reason = Reason, expires = ExpiringDate}))
    --     end
    -- end
end)

RegisterNetEvent("pg-drugs/server/kick-player", function(ServerId, Reason)
    local src = source
    if not AdminCheck(src) then return end

    DropPlayer(ServerId, Reason)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('info.banned'), 'success')
end)

RegisterNetEvent("pg-drugs/server/give-item", function(ServerId, ItemName, ItemAmount)
    local src = source
    if not AdminCheck(src) then return end

    local TPlayer = QBCore.Functions.GetPlayer(ServerId)
    TPlayer.Functions.AddItem(ItemName, ItemAmount, 'Admin-Menu-Give')
    TriggerClientEvent('QBCore:Notify', src, Lang:t('info.gaveitem', {amount = ItemAmount, name = ItemName}), 'success')
end)

RegisterNetEvent("pg-drugs/server/request-job", function(ServerId, JobName)
    local src = source
    if not AdminCheck(src) then return end

    local TPlayer = QBCore.Functions.GetPlayer(ServerId)
    TPlayer.Functions.SetJob(JobName, 1)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('info.setjob', {jobname = JobName}), 'success')
end)

RegisterNetEvent('pg-drugs/server/start-spectate', function(ServerId)
    local src = source
    if not AdminCheck(src) then return end

    -- Check if Person exists
    local Target = GetPlayerPed(ServerId)
    if not Target then
        return TriggerClientEvent('QBCore:Notify', src, Lang:t('spectate.not_found'), 'error')
    end

    -- Make Check for Spectating
    local licenseIdentifier = QBCore.Functions.GetIdentifier(src, "license")
    if SpectateData[licenseIdentifier] ~= nil then
        SpectateData[licenseIdentifier]['Spectating'] = true
    else
        SpectateData[licenseIdentifier] = {}
        SpectateData[licenseIdentifier]['Spectating'] = true
    end

    local tgtCoords = GetEntityCoords(Target)
    TriggerClientEvent('QBCore/client/specPlayer', src, ServerId, tgtCoords)
end)

RegisterNetEvent('pg-drugs/server/stop-spectate', function()
    local src = source
    if not AdminCheck(src) then return end

    local licenseIdentifier = QBCore.Functions.GetIdentifier(src, "license")
    if SpectateData[licenseIdentifier] ~= nil and SpectateData[licenseIdentifier]['Spectating'] then
        SpectateData[licenseIdentifier]['Spectating'] = false
    end
end)

RegisterNetEvent("pg-drugs/server/drunk", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end

    TriggerClientEvent('pg-drugs/client/drunk', ServerId)
end)

RegisterNetEvent("pg-drugs/server/animal-attack", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end

    TriggerClientEvent('pg-drugs/client/animal-attack', ServerId)
end)

RegisterNetEvent("pg-drugs/server/set-fire", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end

    TriggerClientEvent('pg-drugs/client/set-fire', ServerId)
end)

RegisterNetEvent("pg-drugs/server/fling-player", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end

    TriggerClientEvent('pg-drugs/client/fling-player', ServerId)
end)

RegisterNetEvent("pg-drugs/server/play-sound", function(ServerId, SoundId)
    local src = source
    if not AdminCheck(src) then return end

    TriggerClientEvent('pg-drugs/client/play-sound', ServerId, SoundId)
end)

-- Utility Actions

RegisterNetEvent("pg-drugs/server/toggle-blips", function()
    local src = source
    if not AdminCheck(src) then return end

    local BlipData = {}
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        BlipData[#BlipData + 1] = {
            ServerId = v,
            Name = GetPlayerName(v),
            Coords = GetEntityCoords(GetPlayerPed(v)),
        }
    end
    TriggerClientEvent('pg-drugs/client/UpdatePlayerBlips', src, BlipData)
end)


RegisterNetEvent("pg-drugs/server/teleport-player", function(ServerId, Type)
    local src = source
    if not AdminCheck(src) then return end

    local Msg = ""
    if Type == 'Goto' then
        Msg = Lang:t('info.teleportedto') 
        local TCoords = GetEntityCoords(GetPlayerPed(ServerId))
        TriggerClientEvent('pg-drugs/client/teleport-player', src, TCoords)
    elseif Type == 'Bring' then
        Msg = Lang:t('info.teleportedbrought')
        local Coords = GetEntityCoords(GetPlayerPed(src))
        TriggerClientEvent('pg-drugs/client/teleport-player', ServerId, Coords)
    end
    TriggerClientEvent('QBCore:Notify', src, Lang:t('info.teleported', {tpmsg = Msg}), 'success')
end)

RegisterNetEvent("pg-drugs/server/chat-say", function(Message)
    TriggerClientEvent('chat:addMessage', -1, {
        template = "<div class=chat-message server'><strong>"..Lang:t('info.announcement').." | </strong> {0}</div>",
        args = {Message}
    })
end)

-- Player Actions

RegisterNetEvent("pg-drugs/server/toggle-godmode", function(ServerId)
    TriggerClientEvent('pg-drugs/client/toggle-godmode', ServerId)
end)

RegisterNetEvent("pg-drugs/server/set-food-drink", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end

    local TPlayer = QBCore.Functions.GetPlayer(ServerId)
    if TPlayer ~= nil then
        TPlayer.Functions.SetMetaData('thirst', 100)
        TPlayer.Functions.SetMetaData('hunger', 100)
        TriggerClientEvent('hud:client:UpdateNeeds', ServerId, 100, 100)
        TPlayer.Functions.Save()
        TriggerClientEvent('QBCore:Notify', src, Lang:t('info.gave_needs'), 'success')
    end
end)

RegisterNetEvent("pg-drugs/server/remove-stress", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end

    local TPlayer = QBCore.Functions.GetPlayer(ServerId)
    if TPlayer ~= nil then
        TPlayer.Functions.SetMetaData('stress', 0)
        TriggerClientEvent('hud:client:UpdateStress', ServerId, 0)
        TPlayer.Functions.Save()
        TriggerClientEvent('QBCore:Notify', src, Lang:t('info.removed_stress'), 'success')
    end
end)

RegisterNetEvent("pg-drugs/server/set-armor", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end

    local TPlayer = QBCore.Functions.GetPlayer(ServerId)
    if TPlayer ~= nil then
        SetPedArmour(GetPlayerPed(ServerId), 100)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('info.gave_armor'), 'success')
    end
end)

RegisterNetEvent("pg-drugs/server/reset-skin", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end

    local TPlayer = QBCore.Functions.GetPlayer(ServerId)
    -- local ClothingData = MySQL.Sync.fetchAll('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', { TPlayer.PlayerData.citizenid, 1 })
    if ClothingData[1] ~= nil then
        TriggerClientEvent("pg-clothes:loadSkin", ServerId, false, ClothingData[1].model, ClothingData[1].skin)
    else
        TriggerClientEvent("pg-clothes:loadSkin", ServerId, true)
    end
end)

RegisterNetEvent("pg-drugs/server/set-model", function(ServerId, Model)
    local src = source
    if not AdminCheck(src) then return end

    TriggerClientEvent('pg-drugs/client/set-model', ServerId, Model)
end)

RegisterNetEvent("pg-drugs/server/revive-in-distance", function()
    local src = source
    if not AdminCheck(src) then return end

    local Coords, Radius = GetEntityCoords(GetPlayerPed(src)), 5.0
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
		local Player = QBCore.Functions.GetPlayer(v)
		if Player ~= nil then
			local TargetCoords = GetEntityCoords(GetPlayerPed(v))
			local TargetDistance = #(TargetCoords - Coords)
			if TargetDistance <= Radius then
                TriggerClientEvent('hospital:client:Revive', v, true)
			end
		end
	end
end)

RegisterNetEvent("pg-drugs/server/revive-target", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end

    TriggerClientEvent('hospital:client:Revive', ServerId, true)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('info.revived'), 'success')
end)

RegisterNetEvent("pg-drugs/server/open-clothing", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end

    TriggerClientEvent('pg-clothing:client:openMenu', ServerId)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('info.gave_clothing'), 'success')
end)

