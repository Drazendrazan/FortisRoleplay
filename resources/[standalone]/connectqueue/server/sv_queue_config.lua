Config = {}

QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
Config.Priority = {}

-- require people to run steam
Config.RequireSteam = true

-- "whitelist" only server
Config.PriorityOnly = false

-- disables hardcap, should keep this true
Config.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
Config.ConnectTimeOut = 180

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
Config.QueueTimeOut = 90

-- will give players temporary priority when they disconnect and when they start loading in
Config.EnableGrace = true

-- how much priority power grace time will give
Config.GracePower = 99

-- how long grace time lasts in seconds
Config.GraceTime = 300

-- on resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing
Config.JoinDelay = 30000

-- will show how many people have temporary priority in the connection message
Config.ShowTemp = false

-- simple localization
Config.Language = {
    joining = "\xF0\x9F\x8E\x89 Inladen...",
    connecting = "\xE2\x8F\xB3 Verbinden...",
    idrr = "\xE2\x9D\x97[QUEUE] Fout: Mislukt om data op te halen, start FiveM opnieuw op.",
    err = "\xE2\x9D\x97[QUEUE] Er is een fout opgetreden.",
    pos = "\xF0\x9F\x90\x8CJe staat momenteel %d/%d in de wachtrij \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[QUEUE] Fout: Kan geen verbinding maken met de wachtrij.",
    timedout = "\xE2\x9D\x97[QUEUE] Fout: Verbinding Timed Out",
    wlonly = "\xE2\x9D\x97[QUEUE] Je hebt geen rechten om verbinding te maken met de server.",
    steam = "\xE2\x9D\x97 [QUEUE] Fout: Momenteel loopt er geen steam applicatie."
}

Citizen.CreateThread(function()
	loadDatabaseQueue()
end)

function loadDatabaseQueue()
	QBCore.Functions.ExecuteSql(false, "SELECT * FROM `queue`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				Config.Priority[v.steam] = tonumber(v.priority)
			end
		end
	end)
end

QBCore.Commands.Add("reloadqueuepriority", "Refresh de queue priority van een persoon.", {{name="id", help="ID"}, {name="priority", help="Priority Level"}}, true, function(source, args)
	loadDatabaseQueue()
	TriggerClientEvent('chatMessage', source, "SYSTEEM", "normal", "REFRESH")	
end, "god")

QBCore.Commands.Add("addpriority", "Geeft queue priority.", {{name="id", help="ID"}, {name="priority", help="Priority Level"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	local level = tonumber(args[2])
	if Player ~= nil then
        AddPriority(Player.PlayerData.source, level)
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "normal", "Je gaf " .. GetPlayerName(Player.PlayerData.source) .. " prioriteitsniveau ("..level..").")	
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler niet online!")	
	end
end, "god")

QBCore.Commands.Add("removepriority", "Verwijderd de queue priority van een persoon.", {{name="id", help="ID"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
        RemovePriority(Player.PlayerData.source)
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "normal", "Je hebt zojuist de priority verwijderd van " .. GetPlayerName(Player.PlayerData.source))	
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler is niet online!")	
	end
end, "god")

function AddPriority(source, level)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		Config.Priority[GetPlayerIdentifiers(source)[1]] = level
		QBCore.Functions.ExecuteSql(true, "DELETE FROM `queue` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		QBCore.Functions.ExecuteSql(true, "INSERT INTO `queue` (`name`, `steam`, `license`, `priority`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..level.."')")
		Player.Functions.UpdatePlayerData()
	end
end

function RemovePriority(source)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		Config.Priority[GetPlayerIdentifiers(source)[1]] = nil
		QBCore.Functions.ExecuteSql(true, "DELETE FROM `queue` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
	end
end