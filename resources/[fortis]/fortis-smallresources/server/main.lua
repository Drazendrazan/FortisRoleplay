QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local VehicleNitrous = {}

RegisterServerEvent('tackle:server:TacklePlayer')
AddEventHandler('tackle:server:TacklePlayer', function(playerId)
    TriggerClientEvent("tackle:client:GetTackled", playerId)
end)

QBCore.Functions.CreateCallback('repaira:server:RepareerAuto', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.money["bank"] >= 325 then
        Player.Functions.RemoveMoney("bank", 325, "Voertuig gerepareerd met Iris haar mooie script")
        cb(true)
    else
        TriggerClientEvent('QBCore:Notify', src, "Je hebt niet genoeg geld om je voertuig te repareren!", "error")
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('nos:GetNosLoadedVehs', function(source, cb)
    cb(VehicleNitrous)
end)

QBCore.Commands.Add("id", "Laat je server-id zien.", {}, false, function(source, args)
    TriggerClientEvent('chatMessage', source, "SYSTEEM", "succes", "ID: "..source)
end)

QBCore.Functions.CreateCallback("schild:server:wapenininventory", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("weapon_combatpistol") ~= nil then
        cb(true)
        return
    else
        cb(false)
        return
    end
end)

QBCore.Commands.Add("me", "", {}, false, function(source, args)
	local text = table.concat(args, ' ')
	local Player = QBCore.Functions.GetPlayer(source)
    if string.find(text, "<font") then
        DropPlayer(source, "Ja dit doen we dus even niet... (font size/color in /me)")
    else
	    TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
        TriggerEvent("qb-log:server:CreateLog", "me", "Me", "white", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..")** " ..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.. " **" ..text, false)

        -- Logs begin
	    local fortisLogsTable = {
	    	["steamid"] = GetPlayerIdentifiers(source)[1],
	    	["steamnaam"] = GetPlayerName(source),
	    	["citizenid"] = Player.PlayerData.citizenid,
	    	["bericht"] = text
	    }
	    exports["fortislogs"]:addLog("me", fortisLogsTable)
	    -- Logs einde
    end
end)