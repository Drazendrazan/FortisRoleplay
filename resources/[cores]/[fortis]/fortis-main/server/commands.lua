QBCore.Commands = {}
QBCore.Commands.List = {}

QBCore.Commands.Add = function(name, help, arguments, argsrequired, callback, permission) 
	QBCore.Commands.List[name:lower()] = {
		name = name:lower(),
		permission = permission ~= nil and permission:lower() or "user",
		help = help,
		arguments = arguments,
		argsrequired = argsrequired,
		callback = callback,
	}
end

QBCore.Commands.Refresh = function(source)
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
	if Player ~= nil then
		for command, info in pairs(QBCore.Commands.List) do
			if QBCore.Functions.HasPermission(source, "god") or QBCore.Functions.HasPermission(source, QBCore.Commands.List[command].permission) then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

QBCore.Commands.Add("tp", "Teleporteer naar een locatie of persoon.", {{name="id/x", help="ID/X"}, {name="y", help="Y"}, {name="z", help="Z"}}, false, function(source, args)
	if (args[1] ~= nil and (args[2] == nil and args[3] == nil)) then
		-- tp to player
		local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('QBCore:Command:TeleportToPlayer', source, Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler is niet online!")
		end
	else
		-- tp to location
		if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
			local x = tonumber(args[1])
			local y = tonumber(args[2])
			local z = tonumber(args[3])
			TriggerClientEvent('QBCore:Command:TeleportToCoords', source, x, y, z)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Niet elk argument is opgegeven! (x, y, z)")
		end
	end
end, "admin")

QBCore.Commands.Add("addpermission", "Geeft adminrechten aan een speler.", {{name="id", help="ID"}, {name="permission", help="god/admin"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	local permission = tostring(args[2]):lower()
	if Player ~= nil then
		QBCore.Functions.AddPermission(Player.PlayerData.source, permission)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler is niet online!")	
	end
end, "god")

QBCore.Commands.Add("removepermission", "Verwijdert adminrechten van een speler.", {{name="id", help="ID"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		QBCore.Functions.RemovePermission(Player.PlayerData.source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler is niet online!")	
	end
end, "god")

QBCore.Commands.Add("sv", "Spawnt een voertuig door middel van modelnaam.", {{name="model", help="Modelnaam"}}, true, function(source, args)
	TriggerClientEvent('QBCore:Command:SpawnVehicle', source, args[1])
end, "admin")

QBCore.Commands.Add("debug", "Zet debug aan/uit.", {}, false, function(source, args)
	TriggerClientEvent('koil-debug:toggle', source)
end, "admin")

QBCore.Commands.Add("dv", "Despawnt een voertuig.", {}, false, function(source, args)
	TriggerClientEvent('QBCore:Command:DeleteVehicle', source)
end, "admin")

QBCore.Commands.Add("tpm", "Teleporteert naar je waypoint.", {}, false, function(source, args)
	TriggerClientEvent('QBCore:Command:GoToMarker', source)
end, "admin")

QBCore.Commands.Add("givemoney", "Geeft geld aan een speler.", {{name="id", help="ID"},{name="moneytype", help="(cash, bank, crypto)"}, {name="amount", help="Hoeveelheid"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]), "Givemoney command")
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Commands.Add("setmoney", "Verandert het aantal geld van een speler.", {{name="id", help="ID"},{name="moneytype", help="(cash, bank, crypto)"}, {name="amount", help="Hoeveelheid"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]), "Setmoney command")
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Commands.Add("setjob", "Verandert de baan van een speler.", {{name="id", help="ID"}, {name="job", help="Baan"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetJob(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Commands.Add("baan", "Laat zien welke baan je hebt.", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
	-- print(Player.PlayerData.job.onduty)
	if Player.PlayerData.job.onduty then
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "warning", "Indienst als: "..Player.PlayerData.job.label)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "warning", "Baan: "..Player.PlayerData.job.label)
	end
end)

QBCore.Commands.Add("setgang", "Verandert de gangjob van een speler.", {{name="id", help="ID"}, {name="job", help="Gangnaam"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetGang(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Commands.Add("gang", "Laat zien in welke gang je zit.", {}, false, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)

	if Player.PlayerData.gang.name ~= "geen" then
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "warning", "Gang: "..Player.PlayerData.gang.label)
	else
		TriggerClientEvent('QBCore:Notify', source, "Je zit niet in een gang!", "error")
	end
end)

QBCore.Commands.Add("testnotify", "test notify", {{name="text", help="Tekst enzo"}}, true, function(source, args)
	TriggerClientEvent('QBCore:Notify', source, table.concat(args, " "), "success")
end, "god")

QBCore.Commands.Add("clearinv", "Verwijdert de inventory van een speler.", {{name="id", help="ID"}}, false, function(source, args)
	local playerId = args[1] ~= nil and args[1] or source 
	local Player = QBCore.Functions.GetPlayer(tonumber(playerId))
	if Player ~= nil then
		Player.Functions.ClearInventory()
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Commands.Add("ooc", "Out of Character Bericht", {}, false, function(source, args)
	local message = table.concat(args, " ")
	local tijd = os.date("%H:%M")
	TriggerClientEvent("QBCore:Client:LocalOutOfCharacter", -1, source, GetPlayerName(source), message, tijd)
	TriggerEvent("qb-log:server:CreateLog", "ooc", "L-OOC", "white", "**"..GetPlayerName(source).."** (BSN: "..Player.PlayerData.citizenid.." | ID: "..source..") **Bericht:** " ..message, false)			

	-- Logs begin
	local fortisLogsTable = {
		["steamid"] = GetPlayerIdentifiers(source)[1],
		["steamnaam"] = GetPlayerName(source),
		["citizenid"] = Player.PlayerData.citizenid,
		["bericht"] = message
	}
	exports["fortislogs"]:addLog("ooc", fortisLogsTable)
	-- Logs einde
end)

QBCore.Commands.Add("openen", "Opent een auto (Alleen voor staff)", {}, false, function(source, args)
	TriggerClientEvent("police:client:autoOpenen", source)
end, "admin")