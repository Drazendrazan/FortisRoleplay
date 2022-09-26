QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent("qb-tow:server:krijggeld")
AddEventHandler("qb-tow:server:krijggeld", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local geld = math.random(200, 400)

    Player.Functions.AddMoney('bank', geld, "ANWB Missie")
    TriggerClientEvent("QBCore:Notify", source, "Je hebt de auto netjes ingeleverd, je kreeg €"..geld, "success")
end)

QBCore.Commands.Add("npc", "Zet npc werk aan/uit.", {}, false, function(source, args)
	TriggerClientEvent("jobs:client:ToggleNpc", source)
end)

QBCore.Commands.Add("tow", "Plaatst het dichtsbijzijnde voertuig achter op de  berger.", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "gebroedersw" or Player.PlayerData.job.name == "mechanic" or Player.PlayerData.job.name == "police" then
        TriggerClientEvent("qb-tow:client:TowVehicle", source)
    end
end)

QBCore.Commands.Add("trailer", "Plaatst het geselecteerde voertuig op de trailer.", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "tow" or Player.PlayerData.job.name == "mechanic" then
        TriggerClientEvent("fortis-anwbmissies:client:trailer", source)
    end
end) 

QBCore.Commands.Add("anwbalert", "Maakt een melding voor de anwb.", {{name="alert", help="De melding die je wilt maken."}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if (Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty) then
        if args[1] ~= nil then
            local msg = table.concat(args, " ")
            TriggerClientEvent("chatMessage", -1, "ANWB MELDING", "success", msg)
            TriggerEvent("qb-log:server:CreateLog", "112", "Anwb Melding", "blue", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Alert:** " ..msg, false)
            TriggerClientEvent('police:PlaySound', -1)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Je hebt geen meldingbeschrijving gemaakt!")
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is voor hulpdiensten!")
    end
end)

QBCore.Commands.Add("trailer", "Plaatst het geselecteerde voertuig op de trailer.", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "tow" or Player.PlayerData.job.name == "mechanic" then
        TriggerClientEvent("fortis-anwbmissies:client:trailer", source)
    end
end) 

QBCore.Functions.CreateCallback("fortis-anwbmissies:server:check", function(source, cb, kenteken, hash, spawnNaam)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local citizenid = Player.PlayerData.citizenid

    -- QBCore.Functions.ExecuteSql(false, "SELECT `mods` FROM `player_vehicles` WHERE plate = '"..kenteken.."'", function(resultaat)
    --     if resultaat[1] ~= nil then
    --         properties = json.decode(resultaat[1].mods)
    --         local callback = {properties["modTurbo"], properties["modBrakes"], properties["neonEnabled"], properties["neonColor"]}
    --         cb(callback)
    --     else
    --         cb("straatvoertuig")
    --     end
    -- end)   

    QBCore.Functions.ExecuteSql(false, "SELECT `citizenid` FROM `player_vehicles` WHERE plate = '"..kenteken.."'", function(resultaat)
        if resultaat[1] ~= nil then
            if resultaat[1].citizenid ~= citizenid then
                QBCore.Functions.ExecuteSql(false, "SELECT `mods` FROM `player_vehicles` WHERE plate = '"..kenteken.."'", function(resultaat)
                    if resultaat[1] ~= nil then
                        properties = json.decode(resultaat[1].mods)
                        local callback = {properties["modTurbo"], properties["modBrakes"], properties["neonEnabled"], properties["neonColor"]}
                        cb(callback)
                    else
                        cb("straatvoertuig")
                    end
                end)  
            else
                TriggerClientEvent("QBCore:Notify", source, "Je kan geen upgrades op je eigen auto plaatsen!", "error")
                cb(annuleren)
            end
        else
            cb("straatvoertuig")

        end
    end) 
end)

QBCore.Functions.CreateCallback("fortis-anwbmissies:server:checkNeon", function(source, cb, kenteken, hash, spawnNaam)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local citizenid = Player.PlayerData.citizenid

    if kenteken ~= nil then
        QBCore.Functions.ExecuteSql(false, "SELECT `mods` FROM `player_vehicles` WHERE plate = '"..kenteken.."'", function(resultaat)
            if resultaat[1] ~= nil then
                properties = json.decode(resultaat[1].mods)
                local callback = {properties["modTurbo"], properties["modBrakes"], properties["neonEnabled"], properties["neonColor"]}
                cb(callback)
            else
                cb("straatvoertuig")
            end
        end)  
    end

    -- QBCore.Functions.ExecuteSql(false, "SELECT `mods` FROM `player_vehicles` WHERE plate = '"..kenteken.."'", function(resultaat)
    --     if resultaat[1] ~= nil then
    --         properties = json.decode(resultaat[1].mods)
    --         local callback = {properties["modTurbo"], properties["modBrakes"], properties["neonEnabled"], properties["neonColor"]}
    --         cb(callback)
    --     else
    --         cb("straatvoertuig")
    --     end
    -- end)   

    -- QBCore.Functions.ExecuteSql(false, "SELECT `citizenid` FROM `player_vehicles` WHERE plate = '"..kenteken.."'", function(resultaat)
    --     if resultaat[1] ~= nil then
    --         if resultaat[1].citizenid ~= citizenid then
    --             QBCore.Functions.ExecuteSql(false, "SELECT `mods` FROM `player_vehicles` WHERE plate = '"..kenteken.."'", function(resultaat)
    --                 if resultaat[1] ~= nil then
    --                     properties = json.decode(resultaat[1].mods)
    --                     local callback = {properties["modTurbo"], properties["modBrakes"], properties["neonEnabled"], properties["neonColor"]}
    --                     cb(callback)
    --                 else
    --                     cb("straatvoertuig")
    --                 end
    --             end)  
    --         else
    --             TriggerClientEvent("QBCore:Notify", source, "Je kan geen upgrades op je eigen auto plaatsen!", "error")
    --             cb(annuleren)
    --         end
    --     else
    --         cb("straatvoertuig")

    --     end
    -- end) 
end)

RegisterServerEvent('fortis-anwbmissies:server:updateVehicleStatus')
AddEventHandler('fortis-anwbmissies:server:updateVehicleStatus', function(plate, props)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if props ~= 0 then
        QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `mods` = '" .. json.encode(props) .. "' WHERE `plate` = '" .. plate .. "'", function(resultaat)
        end)
    end
end)

RegisterServerEvent('fortis-anwbmissies:server:geefuitrusting')
AddEventHandler('fortis-anwbmissies:server:geefuitrusting', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem("weapon_fireextinguisher", 1)
    Player.Functions.AddItem("weapon_flashlight", 1)
    Player.Functions.AddItem("jerry_can", 1)
end)

RegisterServerEvent('fortis-anwbmissies:server:geeftunerofnitro')
AddEventHandler('fortis-anwbmissies:server:geeftunerofnitro', function(item)
    print(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = item
    Player.Functions.AddItem(item, 1)
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