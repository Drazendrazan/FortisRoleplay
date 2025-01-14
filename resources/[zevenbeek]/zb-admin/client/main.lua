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

--- CODE

local PlayerBlips = {}
QBAdmin = {}
QBAdmin.Functions = {}
in_noclip_mode = false

QBAdmin.Functions.DrawText3D = function(x, y, z, text, lines)
    if lines == nil then
        lines = 1
    end

	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125 * lines, 0.017+ factor, 0.03 * lines, 0, 0, 0, 20)
    ClearDrawOrigin()
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

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("qb-admin:server:loadPermissions")
end)

RegisterNetEvent('fr-admin:client:getCoords')
AddEventHandler('fr-admin:client:getCoords', function()
	local coords = GetEntityCoords(GetPlayerPed(-1))
    local heading = GetEntityHeading(GetPlayerPed(-1))
	local msg = coords.x .. ', ' .. coords.y .. ', ' .. coords.z
	print(msg, heading)
	QBCore.Functions.Notify(msg)
end)

AvailableWeatherTypes = {
    {label = "Extra Sunny",         weather = 'EXTRASUNNY',}, 
    {label = "Clear",               weather = 'CLEAR',}, 
    {label = "Neutral",             weather = 'NEUTRAL',}, 
    {label = "Smog",                weather = 'SMOG',}, 
    {label = "Foggy",               weather = 'FOGGY',}, 
    {label = "Overcast",            weather = 'OVERCAST',}, 
    {label = "Clouds",              weather = 'CLOUDS',}, 
    {label = "Clearing",            weather = 'CLEARING',}, 
    {label = "Rain",                weather = 'RAIN',}, 
    {label = "Thunder",             weather = 'THUNDER',}, 
    {label = "Snow",                weather = 'SNOW',}, 
    {label = "Blizzard",            weather = 'BLIZZARD',}, 
    {label = "Snowlight",           weather = 'SNOWLIGHT',}, 
    {label = "XMAS",   weather = 'XMAS',}, 
    {label = "Halloween",  weather = 'HALLOWEEN',},
}

BanTimes = {
    [1] = 3600,
    [2] = 21600,
    [3] = 43200,
    [4] = 86400,
    [5] = 259200,
    [6] = 604800,
    [7] = 2678400,
    [8] = 8035200,
    [9] = 16070400,
    [10] = 32140800,
    [11] = 99999999999,
}

ServerTimes = {
    [1] = {hour = 0, minute = 0},
    [2] = {hour = 1, minute = 0},
    [3] = {hour = 2, minute = 0},
    [4] = {hour = 3, minute = 0},
    [5] = {hour = 4, minute = 0},
    [6] = {hour = 5, minute = 0},
    [7] = {hour = 6, minute = 0},
    [8] = {hour = 7, minute = 0},
    [9] = {hour = 8, minute = 0},
    [10] = {hour = 9, minute = 0},
    [11] = {hour = 10, minute = 0},
    [12] = {hour = 11, minute = 0},
    [13] = {hour = 12, minute = 0},
    [14] = {hour = 13, minute = 0},
    [15] = {hour = 14, minute = 0},
    [16] = {hour = 15, minute = 0},
    [17] = {hour = 16, minute = 0},
    [18] = {hour = 17, minute = 0},
    [19] = {hour = 18, minute = 0},
    [20] = {hour = 19, minute = 0},
    [21] = {hour = 20, minute = 0},
    [22] = {hour = 21, minute = 0},
    [23] = {hour = 22, minute = 0},
    [24] = {hour = 23, minute = 0},
}

PermissionLevels = {
    [1] = {rank = "user", label = "User"},
    [2] = {rank = "admin", label = "Staff"},
    [3] = {rank = "god", label = "Management"},
}

isNoclip = false
isFreeze = false
isSpectating = false
showNames = false
showBlips = false
isInvisible = false
deleteLazer = false
hasGodmode = false

lastSpectateCoord = nil

myPermissionRank = "user"

local DealersData = {}

function getPlayers()
    local players = {}
    for k, player in pairs(GetActivePlayers()) do
        local playerId = GetPlayerServerId(player)
        players[k] = {
            ['ped'] = GetPlayerPed(player),
            ['name'] = GetPlayerName(player),
            ['id'] = player,
            ['serverid'] = playerId,
        }
    end

    table.sort(players, function(a, b)
        return a.serverid < b.serverid
    end)

    return players
end



RegisterNetEvent('qb-admin:client:openMenu')
AddEventHandler('qb-admin:client:openMenu', function(group, dealers)
	QBCore.Functions.TriggerCallback('qb-admin:server:hasPerms', function(perms)
		if perms then
			WarMenu.OpenMenu('admin')
			myPermissionRank = group
			DealersData = dealers
		else
			QBCore.Functions.Notify("Je hebt geen permissies!", "error", 5000)
		end
	end)
end)

local currentPlayerMenu = nil
local currentPlayer = 0

Citizen.CreateThread(function()
    local menus = {
        "admin",
        "playerMan",
        "serverMan",
        currentPlayer,
        "playerOptions",
        "teleportOptions",
        "permissionOptions",
        "weatherOptions",
        "adminOptions",
        "adminOpt",
        "selfOptions",
        "dealerManagement",
        "allDealers",
        "createDealer",
    }

    local bans = {
        "1 uur",
        "6 uur",
        "12 uur",
        "1 dag",
        "3 dagen",
        "1 week",
        "1 maand",
        "3 maanden",
        "6 maanden",
        "1 jaar",
        "Perm",
        "Zelf",
    }

    local times = {
        "00:00",
        "01:00",
        "02:00",
        "03:00",
        "04:00",
        "05:00",
        "06:00",
        "07:00",
        "08:00",
        "09:00",
        "10:00",
        "11:00",
        "12:00",
        "13:00",
        "14:00",
        "15:00",
        "16:00",
        "17:00",
        "18:00",
        "19:00",
        "20:00",
        "21:00",
        "22:00",
        "23:00",
    }

    local perms = {
        "User",
        "Admin",
        "God"
    }

    
    local currentBanIndex = 1
    local selectedBanIndex = 1
    
    local currentMinTimeIndex = 1
    local selectedMinTimeIndex = 1

    local currentMaxTimeIndex = 1
    local selectedMaxTimeIndex = 1

    local currentPermIndex = 1
    local selectedPermIndex = 1

    WarMenu.CreateMenu('admin', 'Fortis Roleplay')
    WarMenu.CreateSubMenu('playerMan', 'admin')
    WarMenu.CreateSubMenu('serverMan', 'admin')
    WarMenu.CreateSubMenu('adminOpt', 'admin')
    WarMenu.CreateSubMenu('selfOptions', 'adminOpt')

    WarMenu.CreateSubMenu('weatherOptions', 'serverMan')
    
    for k, v in pairs(menus) do
        WarMenu.SetMenuX(v, 0.71)
        WarMenu.SetMenuY(v, 0.15)
        WarMenu.SetMenuWidth(v, 0.23)
        WarMenu.SetTitleColor(v, 255, 255, 255, 255)
        WarMenu.SetTitleBackgroundColor(v, 125, 195, 37, 150)
    end

    while true do
        if WarMenu.IsMenuOpened('admin') then
            WarMenu.MenuButton('Admin Opties', 'adminOpt')
            WarMenu.MenuButton('Speler Management', 'playerMan')
            WarMenu.MenuButton('Server Management', 'serverMan')

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('adminOpt') then
            WarMenu.MenuButton('Zelf Options', 'selfOptions')
            -- WarMenu.MenuButton("Coords kopieren", "kopieerCoords")
            WarMenu.CheckBox("Spelernamen", showNames, function(checked) showNames = checked end)
            if WarMenu.CheckBox("Spelerblips", showBlips, function(checked) showBlips = checked end) then
                toggleBlips()
            end

            if WarMenu.Button("kopieerCoords") then
                local coords = GetEntityCoords(GetPlayerPed(-1))
                local heading = GetEntityHeading(GetPlayerPed(-1))
                SendNUIMessage({
                    type = "kopieerCoords",
                    coords = coords,
                    heading = heading
                })
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('selfOptions') then
            if WarMenu.CheckBox("Noclip", isNoclip, function(checked) isNoclip = checked end) then
                local target = PlayerId()
                local targetId = GetPlayerServerId(target)
                TriggerServerEvent("qb-admin:server:togglePlayerNoclip", targetId)
            end
            if WarMenu.Button('Revive') then
                local target = PlayerId()
                local targetId = GetPlayerServerId(target)
                TriggerServerEvent('qb-admin:server:revivePlayer', targetId)
            end
            if WarMenu.CheckBox("Onzichtbaar", isInvisible, function(checked) isInvisible = checked end) then
                local myPed = GetPlayerPed(-1)
                
                if isInvisible then
                    SetEntityVisible(myPed, false, false)
                else
                    SetEntityVisible(myPed, true, false)
                end
            end
            if WarMenu.CheckBox("Godmode", hasGodmode, function(checked) hasGodmode = checked end) then
                local myPlayer = PlayerId()
                
                SetPlayerInvincible(myPlayer, hasGodmode)
            end
            if WarMenu.CheckBox("Verwijder Lazer", deleteLazer, function(checked) deleteLazer = checked end) then
            end
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('houseOptions') then
        elseif WarMenu.IsMenuOpened('playerMan') then
            local players = getPlayers()

            for k, v in pairs(players) do
                WarMenu.CreateSubMenu(v["id"], 'playerMan', v["serverid"].." | "..v["name"])
            end
            if WarMenu.MenuButton('#'..GetPlayerServerId(PlayerId()).." | "..GetPlayerName(PlayerId()), PlayerId()) then
                currentPlayer = PlayerId()
                if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                    currentPlayerMenu = 'playerOptions'
                elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                    currentPlayerMenu = 'teleportOptions'
                elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                    currentPlayerMenu = 'adminOptions'
                end

                if myPermissionRank == "god" then
                    if WarMenu.CreateSubMenu('permissionOptions', currentPlayer) then
                        currentPlayerMenu = 'permissionOptions'
                    end
                end
            end
            for k, v in pairs(players) do
                if v["id"] ~= PlayerId() then
                    if WarMenu.MenuButton('#'..v["serverid"].." | "..v["name"], v["id"]) then
                        currentPlayer = v["id"]
                        if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                            currentPlayerMenu = 'playerOptions'
                        elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                            currentPlayerMenu = 'teleportOptions'
                        elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                            currentPlayerMenu = 'adminOptions'
                        end
                    end
                end
            end

            if myPermissionRank == "god" then
                if WarMenu.CreateSubMenu('permissionOptions', currentPlayer) then
                    currentPlayerMenu = 'permissionOptions'
                end
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('serverMan') then
            WarMenu.MenuButton('Dealer Management', 'dealerManagement')
            if WarMenu.ComboBox('In-game Tijd', times, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
                currentBanIndex = currentIndex
                selectedBanIndex = selectedIndex
            end) then
                local time = ServerTimes[currentBanIndex]
                TriggerServerEvent("qb-weathersync:server:setTime", time.hour, time.minute)
            end
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened(currentPlayer) then
            WarMenu.MenuButton('Speler Opties', 'playerOptions')
            WarMenu.MenuButton('Teleport Opties', 'teleportOptions')
            WarMenu.MenuButton('Admin Opties', 'adminOptions')
            if myPermissionRank == "god" then
                WarMenu.MenuButton('Permissie Opties', 'permissionOptions')
            end
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('playerOptions') then
		    if WarMenu.CheckBox("Spectate", isSpectating, function(checked) isSpectating = checked end) then
                local target = GetPlayerFromServerId(GetPlayerServerId(currentPlayer))
                local targetPed = GetPlayerPed(target)
                local targetCoords = GetEntityCoords(targetPed)

                SpectatePlayer(targetPed, isSpectating)
            end
            if WarMenu.MenuButton('Kill', currentPlayer) then
                TriggerServerEvent("qb-admin:server:killPlayer", GetPlayerServerId(currentPlayer))
            end
            if WarMenu.MenuButton('Revive', currentPlayer) then
                local target = GetPlayerServerId(currentPlayer)
                TriggerServerEvent('qb-admin:server:revivePlayer', target)
            end
            if WarMenu.CheckBox("Freeze", isFreeze, function(checked) isFreeze = checked end) then
                local target = GetPlayerServerId(currentPlayer)
                TriggerServerEvent("qb-admin:server:Freeze", target, isFreeze)
            end
            if WarMenu.MenuButton("Open Inventaris", currentPlayer) then
                local targetId = GetPlayerServerId(currentPlayer)

                OpenTargetInventory(targetId)
            end
            if WarMenu.MenuButton("Open House Inventory", currentPlayer) then
                local targetId = GetPlayerServerId(currentPlayer)

                OpenHouseInventory(targetId)
            end
            if WarMenu.MenuButton("Geef Kledingmenu", currentPlayer) then
                local targetId = GetPlayerServerId(currentPlayer)

                TriggerServerEvent('qb-admin:server:OpenSkinMenu', targetId)
            end
            if WarMenu.MenuButton("Screenshot", currentPlayer) then
                local targetId = GetPlayerServerId(currentPlayer)

                TriggerServerEvent('zb-screenshots:server:adminMenuMaakScreen', targetId)
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('teleportOptions') then
            if WarMenu.MenuButton('Teleporteer', currentPlayer) then
                local target = GetPlayerPed(currentPlayer)
                local ply = GetPlayerPed(-1)
                if in_noclip_mode then
                    turnNoClipOff()
                    SetEntityCoords(ply, GetEntityCoords(target))
                    turnNoClipOn()
                else
                    SetEntityCoords(ply, GetEntityCoords(target))
                end
            end
            if WarMenu.MenuButton('Breng Persoon', currentPlayer) then
                local target = GetPlayerPed(currentPlayer)
                local plyCoords = GetEntityCoords(GetPlayerPed(-1))

                TriggerServerEvent('qb-admin:server:bringTp', GetPlayerServerId(currentPlayer), plyCoords)
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('permissionOptions') then
            if WarMenu.ComboBox('Permissie', perms, currentPermIndex, selectedPermIndex, function(currentIndex, selectedIndex)
                currentPermIndex = currentIndex
                selectedPermIndex = selectedIndex
            end) then
                local group = PermissionLevels[currentPermIndex]
                local target = GetPlayerServerId(currentPlayer)

                TriggerServerEvent('qb-admin:server:setPermissions', target, group)

                QBCore.Functions.Notify('Je hebt '..GetPlayerName(currentPlayer)..'\'s permissie veranderd naar '..group.label)
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('adminOptions') then
            if WarMenu.ComboBox('Ban', bans, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
                currentBanIndex = currentIndex
                selectedBanIndex = selectedIndex
            end) then
                local time = BanTimes[currentBanIndex]
                local index = currentBanIndex
                if index == 12 then
                    DisplayOnscreenKeyboard(1, "Tijd", "", "Lengte", "", "", "", 128 + 1)
                    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                        Citizen.Wait(7)
                    end
                    time = tonumber(GetOnscreenKeyboardResult())
                    time = time * 3600
                end
                DisplayOnscreenKeyboard(1, "Reden", "", "Reden", "", "", "", 128 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(7)
				end
                local reason = GetOnscreenKeyboardResult()
                if reason ~= nil and reason ~= "" and time ~= 0 then
                    local target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent("qb-admin:server:banPlayer", target, time, reason)
                end
            end
            if WarMenu.MenuButton('Kick', currentPlayer) then
                DisplayOnscreenKeyboard(1, "Reden", "", "Reden", "", "", "", 128 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(7)
				end
                local reason = GetOnscreenKeyboardResult()
                if reason ~= nil and reason ~= "" then
                    local target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent("qb-admin:server:kickPlayer", target, reason)
                end
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('weatherOptions') then
            for k, v in pairs(AvailableWeatherTypes) do
                if WarMenu.MenuButton(AvailableWeatherTypes[k].label, 'weatherOptions') then
                    TriggerServerEvent('qb-weathersync:server:setWeather', AvailableWeatherTypes[k].weather)
                    QBCore.Functions.Notify('Weer is veranderd naar: '..AvailableWeatherTypes[k].label)
                end
            end
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('dealerManagement') then
            WarMenu.MenuButton('Dealers', 'allDealers')
            WarMenu.MenuButton('Dealer Toevoegen', 'createDealer')

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('allDealers') then
            for k, v in pairs(DealersData) do
                if WarMenu.MenuButton(v.name, 'allDealers') then
                    print(v.name)
                end
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('createDealer') then
            if WarMenu.ComboBox('Min. Tijd', times, currentMinTimeIndex, selectedMinTimeIndex, function(currentIndex, selectedIndex)
                currentMinTimeIndex = currentIndex
                selectedMinTimeIndex = selectedIndex
            end) then
                QBCore.Functions.Notify('Tijd ingesteld!', 'success')
            end
            if WarMenu.ComboBox('Max. Tijd', times, currentMaxTimeIndex, selectedMaxTimeIndex, function(currentIndex, selectedIndex)
                currentMaxTimeIndex = currentIndex
                selectedMaxTimeIndex = selectedIndex
            end) then
                QBCore.Functions.Notify('Tijd ingesteld!', 'success')
            end

            if WarMenu.MenuButton("Bevestig", 'createDealer') then
                DisplayOnscreenKeyboard(1, "Dealer Name", "Dealer Name", "", "", "", "", 128 + 1)
                while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                    Citizen.Wait(7)
                end
                local reason = GetOnscreenKeyboardResult()
            end
            WarMenu.Display()
        end

        Citizen.Wait(3)
    end
end)


function SpectatePlayer(targetPed, toggle)
    local myPed = GetPlayerPed(-1)

    if toggle then
        showNames = true
        lastSpectateCoord = GetEntityCoords(myPed)
		-- SetEntityVisible(myPed, false)
        SetEntityCoords(myPed, GetOffsetFromEntityInWorldCoords(targetPed, 0.0, 0.45, 0.0))
		NetworkSetInSpectatorMode(true, targetPed)
        AttachEntityToEntity(myPed, targetPed, 11816, 0.0, -5.3, -2.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		SetEntityInvincible(myPed, true)
        SetEntityVisible(myPed, false)
    else
		NetworkSetInSpectatorMode(false, targetPed)
        DetachEntity(myPed, true, false)
		SetEntityVisible(myPed, true)
        SetEntityCoords(myPed, lastSpectateCoord)
        lastSpectateCoord = nil
    end
end

function OpenTargetInventory(targetId)
    WarMenu.CloseMenu()

    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", targetId)
end

function OpenHouseInventory(targetId)
    WarMenu.CloseMenu()
    QBCore.Functions.TriggerCallback('qb-admin:server:getStash', function(stashid)
        TriggerServerEvent("inventory:server:OpenInventory", "stash", stashid)
		TriggerEvent("inventory:client:SetCurrentStash", stashid)
    end, targetId)
end

RegisterNetEvent("Admin:Toggle:showNames")
AddEventHandler("Admin:Toggle:showNames", function()
    showNames = not showNames
end)

Citizen.CreateThread(function()
    while true do

        if showNames then
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(GetPlayerPed(-1)), 45.0)) do
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerName = GetPlayerName(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)
                local praten = NetworkIsPlayerTalking(player)

                if not IsPedInAnyVehicle(PlayerPed) then
                    if praten and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), PlayerCoords.x, PlayerCoords.y, PlayerCoords.z) < 10 then
                        QBAdmin.Functions.DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.2, '🟢\n['..PlayerId..'] '..PlayerName)
                    else
                        QBAdmin.Functions.DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '['..PlayerId..'] '..PlayerName)
                    end
                elseif praten and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), PlayerCoords.x, PlayerCoords.y, PlayerCoords.z) < 10 then
                        QBAdmin.Functions.DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.8, '🟢\n['..PlayerId..'] '..PlayerName)
                else
                    QBAdmin.Functions.DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.5, '['..PlayerId..'] '..PlayerName)
                end
            end
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)
RegisterNetEvent('Admin:Client:ToggleBlips')
AddEventHandler("Admin:Client:ToggleBlips", function()

    if showBlips then
        Citizen.CreateThread(function()
            local Players = getPlayers()

            for k, v in pairs(Players) do
                local playerPed = v["ped"]
                if DoesEntityExist(playerPed) then
                    if PlayerBlips[k] == nil then
                        local playerName = v["name"]
            
                        PlayerBlips[k] = AddBlipForEntity(playerPed)
            
                        SetBlipSprite(PlayerBlips[k], 1)
                        SetBlipColour(PlayerBlips[k], 0)
                        SetBlipScale  (PlayerBlips[k], 0.75)
                        SetBlipAsShortRange(PlayerBlips[k], true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString('['..v["serverid"]..'] '..playerName)
                        EndTextCommandSetBlipName(PlayerBlips[k])
                    end
                else
                    if PlayerBlips[k] ~= nil then
                        RemoveBlip(PlayerBlips[k])
                        PlayerBlips[k] = nil
                    end
                end
            end

            Citizen.Wait(5000)
        end)
    else
        if next(PlayerBlips) ~= nil then
            for k, v in pairs(PlayerBlips) do
                RemoveBlip(PlayerBlips[k])
            end
            PlayerBlips = {}
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()	
	while true do
		Citizen.Wait(0)

        if deleteLazer then
            local color = {r = 255, g = 255, b = 255, a = 200}
            local position = GetEntityCoords(GetPlayerPed(-1))
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            
            -- If entity is found then verifie entity
            if hit and (IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)) then
                local entityCoord = GetEntityCoords(entity)
                local minimum, maximum = GetModelDimensions(GetEntityModel(entity))
                
                DrawEntityBoundingBox(entity, color)
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
                QBAdmin.Functions.DrawText3D(entityCoord.x, entityCoord.y, entityCoord.z, "Obj: " .. entity .. " Model: " .. GetEntityModel(entity).. " \nPress [~g~E~s~] to delete the object!", 2)

                -- When E pressed then remove targeted entity
                if IsControlJustReleased(0, 38) then
                    -- Set as missionEntity so the object can be remove (Even map objects)
                    SetEntityAsMissionEntity(entity, true, true)
                    --SetEntityAsNoLongerNeeded(entity)
                    --RequestNetworkControl(entity)
                    DeleteEntity(entity)
                end
            -- Only draw of not center of map
            elseif coords.x ~= 0.0 and coords.y ~= 0.0 then
                -- Draws line to targeted position
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
                DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
            end
        else
            Citizen.Wait(1000)
        end
	end
end)

-- Draws boundingbox around the object with given color parms
function DrawEntityBoundingBox(entity, color)
    local model = GetEntityModel(entity)
    local min, max = GetModelDimensions(model)
    local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity)

    -- Calculate size
    local dim = 
	{ 
		x = 0.5*(max.x - min.x), 
		y = 0.5*(max.y - min.y), 
		z = 0.5*(max.z - min.z)
	}

    local FUR = 
    {
		x = position.x + dim.y*rightVector.x + dim.x*forwardVector.x + dim.z*upVector.x, 
		y = position.y + dim.y*rightVector.y + dim.x*forwardVector.y + dim.z*upVector.y, 
		z = 0
    }

    local FUR_bool, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    FUR.z = FUR_z
    FUR.z = FUR.z + 2 * dim.z

    local BLL = 
    {
        x = position.x - dim.y*rightVector.x - dim.x*forwardVector.x - dim.z*upVector.x,
        y = position.y - dim.y*rightVector.y - dim.x*forwardVector.y - dim.z*upVector.y,
        z = 0
    }
    local BLL_bool, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    BLL.z = BLL_z

    -- DEBUG
    local edge1 = BLL
    local edge5 = FUR

    local edge2 = 
    {
        x = edge1.x + 2 * dim.y*rightVector.x,
        y = edge1.y + 2 * dim.y*rightVector.y,
        z = edge1.z + 2 * dim.y*rightVector.z
    }

    local edge3 = 
    {
        x = edge2.x + 2 * dim.z*upVector.x,
        y = edge2.y + 2 * dim.z*upVector.y,
        z = edge2.z + 2 * dim.z*upVector.z
    }

    local edge4 = 
    {
        x = edge1.x + 2 * dim.z*upVector.x,
        y = edge1.y + 2 * dim.z*upVector.y,
        z = edge1.z + 2 * dim.z*upVector.z
    }

    local edge6 = 
    {
        x = edge5.x - 2 * dim.y*rightVector.x,
        y = edge5.y - 2 * dim.y*rightVector.y,
        z = edge5.z - 2 * dim.y*rightVector.z
    }

    local edge7 = 
    {
        x = edge6.x - 2 * dim.z*upVector.x,
        y = edge6.y - 2 * dim.z*upVector.y,
        z = edge6.z - 2 * dim.z*upVector.z
    }

    local edge8 = 
    {
        x = edge5.x - 2 * dim.z*upVector.x,
        y = edge5.y - 2 * dim.z*upVector.y,
        z = edge5.z - 2 * dim.z*upVector.z
    }

    DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, color.r, color.g, color.b, color.a)
    DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
end

-- Embed direction in rotation vector
function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

-- Raycast function for "Admin Lazer"
function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

RegisterNetEvent('qb-admin:client:bringTp')
AddEventHandler('qb-admin:client:bringTp', function(coords)
    local ped = GetPlayerPed(-1)

    SetEntityCoords(ped, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('qb-admin:client:Freeze')
AddEventHandler('qb-admin:client:Freeze', function(toggle)
    local ped = GetPlayerPed(-1)

    local veh = GetVehiclePedIsIn(ped)

    if veh ~= 0 then
        FreezeEntityPosition(ped, toggle)
        FreezeEntityPosition(veh, toggle)
    else
        FreezeEntityPosition(ped, toggle)
    end
end)

RegisterNetEvent('qb-admin:client:SendReport')
AddEventHandler('qb-admin:client:SendReport', function(name, src, msg)
    TriggerServerEvent('qb-admin:server:SendReport', name, src, msg)
end)

RegisterNetEvent("qb-admin:client:reportMelding")
AddEventHandler("qb-admin:client:reportMelding", function()
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "staffmelding", 0.5)
end)

RegisterNetEvent('qb-admin:client:SendStaffChat')
AddEventHandler('qb-admin:client:SendStaffChat', function(name, msg)
    TriggerServerEvent('qb-admin:server:StaffChatMessage', name, msg)
end)

RegisterNetEvent('qb-admin:client:SaveCar')
AddEventHandler('qb-admin:client:SaveCar', function()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)

    if veh ~= nil and veh ~= 0 then
        local plate = GetVehicleNumberPlateText(veh)
        local props = QBCore.Functions.GetVehicleProperties(veh)
        local hash = props.model
        if QBCore.Shared.VehicleModels[hash] ~= nil and next(QBCore.Shared.VehicleModels[hash]) ~= nil then
            TriggerServerEvent('qb-admin:server:SaveCar', props, QBCore.Shared.VehicleModels[hash], GetHashKey(veh), plate)
        else
            QBCore.Functions.Notify('You cant store this vehicle in your garage..', 'error')
        end
    else
        QBCore.Functions.Notify('You are not in a vehicle..', 'error')
    end
end)

function LoadPlayerModel(skin)
    RequestModel(skin)
    while not HasModelLoaded(skin) do
        
        Citizen.Wait(0)
    end
end


local blockedPeds = {
    "mp_m_freemode_01",
    "mp_f_freemode_01",
    "tony",
    "g_m_m_chigoon_02_m",
    "u_m_m_jesus_01",
    "a_m_y_stbla_m",
    "ig_terry_m",
    "a_m_m_ktown_m",
    "a_m_y_skater_m",
    "u_m_y_coop",
    "ig_car3guy1_m",
}

function isPedAllowedRandom(skin)
    local retval = false
    for k, v in pairs(blockedPeds) do
        if v ~= skin then
            retval = true
        end
    end
    return retval
end

RegisterNetEvent('qb-admin:client:SetModel')
AddEventHandler('qb-admin:client:SetModel', function(skin)
    local ped = GetPlayerPed(-1)
    local model = GetHashKey(skin)
    SetEntityInvincible(ped, true)

    if IsModelInCdimage(model) and IsModelValid(model) then
        LoadPlayerModel(model)
        SetPlayerModel(PlayerId(), model)

        if isPedAllowedRandom() then
            SetPedRandomComponentVariation(ped, true)
        end
        
		SetModelAsNoLongerNeeded(model)
	end
	SetEntityInvincible(ped, false)
end)

RegisterNetEvent('qb-admin:client:SetSpeed')
AddEventHandler('qb-admin:client:SetSpeed', function(speed)
    local ped = PlayerId()
    if speed == "fast" then
        SetRunSprintMultiplierForPlayer(ped, 1.49)
        SetSwimMultiplierForPlayer(ped, 1.49)
    else
        SetRunSprintMultiplierForPlayer(ped, 1.0)
        SetSwimMultiplierForPlayer(ped, 1.0)
    end
end)

RegisterNetEvent('qb-weapons:client:SetWeaponAmmoManual')
AddEventHandler('qb-weapons:client:SetWeaponAmmoManual', function(weapon, ammo)
    local ped = GetPlayerPed(-1)
    if weapon ~= "current" then
        local weapon = weapon:upper()
        SetPedAmmo(ped, GetHashKey(weapon), ammo)
        QBCore.Functions.Notify('+'..ammo..' Ammo for the '..QBCore.Shared.Weapons[GetHashKey(weapon)]["label"], 'success')
    else
        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= nil then
            SetPedAmmo(ped, weapon, ammo)
            QBCore.Functions.Notify('+'..ammo..' Ammo for the '..QBCore.Shared.Weapons[weapon]["label"], 'success')
        else
            QBCore.Functions.Notify('You dont have a weapon in your hands..', 'error')
        end
    end
end)

RegisterNetEvent('qb-admin:client:GiveNuiFocus')
AddEventHandler('qb-admin:client:GiveNuiFocus', function(focus, mouse)
    SetNuiFocus(focus, mouse)
end)

-- Compensatie systeempie
RegisterNetEvent("compensatie:openstash")
AddEventHandler("compensatie:openstash", function(stash)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", stash)
    TriggerEvent("inventory:client:SetCurrentStash", stash)
end)


RegisterNetEvent("qb-admin:client:brengNaarStaff")
AddEventHandler("qb-admin:client:brengNaarStaff", function(staff)
    local staffPed = GetPlayerFromServerId(staff)
    local coords = GetEntityCoords(GetPlayerPed(staffPed))
    SetEntityCoords(GetPlayerPed(-1), coords.x, coords.y, coords.z - 1)
    QBCore.Functions.Notify("Je bent geteleporteerd door staff!", "error")
end)

RegisterNetEvent("qb-admin:client:freezeSpeler")
AddEventHandler("qb-admin:client:freezeSpeler", function()
    isFreeze = not isFreeze
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        FreezeEntityPosition(GetPlayerPed(-1), isFreeze)
        FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1)), isFreeze)
    else
        FreezeEntityPosition(GetPlayerPed(-1), isFreeze)
    end
end)

RegisterNetEvent("qb-admin:client:printHashKey")
AddEventHandler("qb-admin:client:printHashKey", function(voertuigNaam)
    if voertuigNaam ~= nil then
        QBCore.Functions.Notify("De hash is: "..GetHashKey(voertuigNaam).." (staat ook in je F8)")
        print(GetHashKey(voertuigNaam))
    end
end)


RegisterNUICallback("gekopieerd", function()
    QBCore.Functions.Notify("Gekopieerd naar klembord!", "success")
end)