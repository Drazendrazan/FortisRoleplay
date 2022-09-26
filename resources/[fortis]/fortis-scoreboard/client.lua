QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code
scoreboardData = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true

    QBCore.Functions.TriggerCallback("fortis-scoreboard:server:haalEersteDataOp", function(cbData)
        scoreboardData = cbData["scoreData"]
        Config.IllegalActions = cbData["config"]
    end)
end)

local scoreboardOpen = false

local PlayerOptin = {}

data = true

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

GetClosestPlayer = function()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

GetPlayers = function()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            table.insert(players, player)
        end
    end
    return players
end

GetPlayersFromCoords = function(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(GetPlayerPed(-1))
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
		if targetdistance <= distance then
			table.insert(closePlayers, player)
		end
    end
    
    return closePlayers
end

RegisterNetEvent("fortis-scoreboard:client:updateScoreboard")
AddEventHandler("fortis-scoreboard:client:updateScoreboard", function(tmpscoreboardData)
    scoreboardData = tmpscoreboardData
end)

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, Config.OpenKey) then
            if not scoreboardOpen and scoreboardData ~= nil then
                PlayerOptin = scoreboardData["playerList"]
                Config.CurrentCops = scoreboardData["hulpdiensten"]["police"]
                SendNUIMessage({
                    action = "open",
                    players = #GetActivePlayers(),
                    maxPlayers = Config.MaxPlayers,
                    requiredCops = Config.IllegalActions,
                    currentCops = Config.CurrentCops,
                    currentAmbulance = scoreboardData["hulpdiensten"]["ambulance"],
                    currentANWB = scoreboardData["hulpdiensten"]["anwb"],
                    currentMakelaar = scoreboardData["hulpdiensten"]["makelaar"],
                    uptimeHours = scoreboardData["uptime"]["hours"],
                    uptimeMinutes = scoreboardData["uptime"]["minutes"]
                })
                scoreboardOpen = true
            end
        end

        if IsControlJustReleased(0, Config.OpenKey) then
            if scoreboardOpen then
                SendNUIMessage({
                    action = "close",
                })
                scoreboardOpen = false
            end
        end

        if scoreboardOpen then
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(GetPlayerPed(-1)), 10.0)) do
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerName = GetPlayerName(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)

                if not PlayerOptin[PlayerId].permission then
                    DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '['..PlayerId..']')
                end
            end
        end

        if IsControlPressed(0, 20) and scoreboardData ~= nil then
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(GetPlayerPed(-1)), 10.0)) do
                PlayerOptin = scoreboardData["playerList"]
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerName = GetPlayerName(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)
                if PlayerOptin[PlayerId] ~= nil then
                    if not PlayerOptin[PlayerId].permission then
                        DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '['..PlayerId..']')
                    end
                end
            end 
        end

 
        Citizen.Wait(3)
    end
end)

function GetCurrentPlayers()
    return 69
end

RegisterNetEvent('qb-scoreboard:client:SetActivityBusy')
AddEventHandler('qb-scoreboard:client:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)
 
RegisterNetEvent("fortis-scoreboard:client:openScoreboard")
AddEventHandler("fortis-scoreboard:client:openScoreboard", function()
    if not scoreboardOpen and scoreboardData ~= nil then
        PlayerOptin = scoreboardData["playerList"]
        Config.CurrentCops = scoreboardData["hulpdiensten"]["police"]
        SendNUIMessage({
            action = "open",
            players = #GetActivePlayers(),
            maxPlayers = Config.MaxPlayers,
            requiredCops = Config.IllegalActions,
            currentCops = Config.CurrentCops,
            currentAmbulance = scoreboardData["hulpdiensten"]["ambulance"],
            currentANWB = scoreboardData["hulpdiensten"]["anwb"],
            currentMakelaar = scoreboardData["hulpdiensten"]["makelaar"],
            uptimeHours = scoreboardData["uptime"]["hours"],
            uptimeMinutes = scoreboardData["uptime"]["minutes"]
        })
        scoreboardOpen = true
    elseif scoreboardOpen then
        SendNUIMessage({
            action = "close",
        })
        scoreboardOpen = false
    end
end)

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end