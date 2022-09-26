QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
local xSound = exports.fortissound

QBCore.Functions.CreateUseableItem("boombox", function(source, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	
	TriggerClientEvent('fortis-boombox:client:placeBoombox', src)
end)

RegisterNetEvent("fortis-boombox:server:plaatsen", function()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('boombox', 1, false)
end)

RegisterNetEvent("fortis-boombox:server:Drop", function()
    DropPlayer(source, "nee")
end)

RegisterNetEvent('fortis-boombox:server:playMusic', function(song, entity, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    xSound:PlayUrlPos(-1, tostring(entity), song, Config.DefaultVolume, coords)
    xSound:Distance(-1, tostring(entity), Config.radius)
    isPlaying = true
    TriggerEvent("qb-log:server:CreateLog", "boomboxLogs", "Link ingevoerd voor het afspelen van een liedje", "green", "**"..GetPlayerName(Player.PlayerData.source) .. " (BSN: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")**\nLiedje: "..song, false)
end)

RegisterNetEvent('fortis-boombox:server:pickedup', function(entity)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    xSound:Destroy(-1, tostring(entity))
    Player.Functions.AddItem("boombox", 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["boombox"], 'add')
end) 

RegisterNetEvent('fortis-boombox:server:stopMusic', function(data)
    local src = source
    xSound:Destroy(-1, tostring(data.entity))
    TriggerClientEvent('fortis-boombox:client:playMusic', src)
end)

RegisterNetEvent('fortis-boombox:server:pauseMusic', function(data)
    local src = source
    xSound:Pause(-1, tostring(data.entity))
end)

RegisterNetEvent('fortis-boombox:server:resumeMusic', function(data)
    local src = source
    xSound:Resume(-1, tostring(data.entity))
end)

RegisterNetEvent('fortis-boombox:server:changeVolume', function(volume, entity)
    local src = source
    if not tonumber(volume) then return end
    xSound:setVolume(-1, tostring(entity), volume)
end)