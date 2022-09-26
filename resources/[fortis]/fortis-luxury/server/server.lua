QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("verkoopauto", "Verkoop een auto aan een speler.", {{name="id", help="ID"},{name="autotier", help="(1-8)"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local verkoperID = source
    local tier = tonumber(args[2])
	if Player ~= nil then
        TriggerClientEvent("fortis-luxury:client:verkoopAuto", tonumber(args[1]), tier, verkoperID)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Commands.Add("verkoopheli", "Verkoop een helikopter aan een speler.", {{name="id", help="ID"},{name="helitier", help="(10-14)"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local tier = tonumber(args[2])
    local verkoperID = source
	if Player ~= nil then
        TriggerClientEvent("fortis-luxury:client:verkoopHeli", tonumber(args[1]), tier, verkoperID)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Speler is niet online!")
	end
end, "admin")

QBCore.Functions.CreateCallback("fortis-luxury:server:koopVoertuig", function(source, cb, tier)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bank = Player.PlayerData.money["bank"]

    local steam = Player.PlayerData.steam
    local citizenid = Player.PlayerData.citizenid

    if tier <10 then
        local naam = Config.AutoTier[tier].name
        local model = Config.AutoTier[tier].auto   
        local prijs = Config.AutoTier[tier].price
        local hash = GetHashKey(model)
        if bank >= prijs then
            Player.Functions.RemoveMoney("bank", prijs, "Voertuig gekocht bij luxury")
            TriggerClientEvent("QBCore:Notify", src, "Je hebt hebt contract geaccepteerd!")
            local kenteken = GeneratePlate()
            QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`) VALUES ('"..steam.."', '"..citizenid.."',  '"..model.."', '"..hash.."', '{}', '"..kenteken.."', 'sapcounsel')")
            TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Cardealer", "green", "**" ..GetPlayerName(source) .. "** heeft een " .. naam .. " gekocht bij de lixury voor €" .. prijs)
            cb(true, kenteken)
        else
            TriggerClientEvent('QBCore:Notify', src, "Je hebt niet genoeg geld om dit voertuig te kopen!")
            cb(false)
        end
    else
        local naam = Config.HeliTier[tier].name
        local model = Config.HeliTier[tier].heli   
        local prijs = Config.HeliTier[tier].price
        local hash = GetHashKey(model)
    
        if bank >= prijs then
            Player.Functions.RemoveMoney("bank", prijs, "Voertuig gekocht bij luxury")
            TriggerClientEvent("QBCore:Notify", src, "Je hebt hebt contract geaccepteerd!")
            local kenteken = GeneratePlate()
            QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_planes` (`steam`, `citizenid`, `plane`, `hash`, `mods`, `plate`, `hangar`, `state`) VALUES ('"..steam.."', '"..citizenid.."',  '"..model.."', '"..hash.."', '{}', '"..kenteken.."', 'lsairport', 1)")
            TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Cardealer", "green", "**" ..GetPlayerName(source) .. "** heeft een " .. naam .. " gekocht bij de lixury voor €" .. prijs)
            cb(true)
        else
            TriggerClientEvent('QBCore:Notify', src, "Je hebt niet genoeg geld om dit voertuig te kopen!")
            cb(false)
        end
    end
end)

RegisterNetEvent("fortis-luxury:server:notifyVerkoperSucces")
AddEventHandler("fortis-luxury:server:notifyVerkoperSucces", function(verkoperID)
    local verkoperID = verkoperID
    TriggerClientEvent("QBCore:Notify", verkoperID, "Je client heeft het voertuig kunnen betalen!")
end)

RegisterNetEvent("fortis-luxury:server:notifyVerkoperFout")
AddEventHandler("fortis-luxury:server:notifyVerkoperFout", function(verkoperID2)
    local verkoperID3 = verkoperID2
    TriggerClientEvent("QBCore:Notify", verkoperID3, "Je client heeft het voertuig niet betaald!")
end)

function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return plate
    end)
    return plate:upper()
end

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end
function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return plate
    end)
    return plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end 
end

QBCore.Commands.Add("ldealeralert", "Maakt een medling voor de cardealer.", {{name="alert", help="De melding die je wilt maken."}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if args[1] ~= nil then
        local msg = table.concat(args, " ")
        TriggerClientEvent("chatMessage", -1, "Luxury Dealer", "success", msg)
        TriggerEvent("qb-log:server:CreateLog", "112", "Luxury Dealer", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Alert:** " ..msg, false)
        TriggerClientEvent('police:PlaySound', -1)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Je hebt geen meldingbeschrijving gemaakt!")
    end
end, "admin")