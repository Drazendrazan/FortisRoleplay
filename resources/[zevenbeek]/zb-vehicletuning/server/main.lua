QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local VehicleStatus = {}
local VehicleDrivingDistance = {}

QBCore.Functions.CreateCallback('qb-vehicletuning:server:GetDrivingDistances', function(source, cb)
    cb(VehicleDrivingDistance)
end)

-- QBCore.Commands.Add("anwb", "Maakt een melding voor de anwb medewerkers.", {{name="message", help="Meldingomschrijving"}}, true, function(source, args)
--     local message = table.concat(args, " ")
--     local Player = QBCore.Functions.GetPlayer(source)

--     if Player.Functions.GetItemByName("phone") ~= nil then
--         TriggerClientEvent("zb-vehicletuning:client:SendEmergencyMessage", source, message)
--         TriggerEvent("qb-log:server:CreateLog", "112", "ANWB Melding", "blue", "**"..GetPlayerName(source).."** (BSN: "..Player.PlayerData.citizenid.." | ID: "..source..") **Melding:** " ..message, false)
--     else
--         TriggerClientEvent('QBCore:Notify', source, 'Je hebt geen telefoon!', 'error')
--     end
-- end)

-- RegisterServerEvent('police:server:SendEmergencyMessage')
-- AddEventHandler('police:server:SendEmergencyMessage', function(coords, message)
--     local src = source
--     local MainPlayer = QBCore.Functions.GetPlayer(src)
--     local alertData = {
--         title = "112 Melding - "..MainPlayer.PlayerData.charinfo.phone,
--         coords = {x = coords.x, y = coords.y, z = coords.z},
--         description = message,
--     }

--     TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, alertData)
--     TriggerClientEvent('police:server:SendEmergencyMessageCheck', -1, MainPlayer, message, coords)
-- end)


RegisterServerEvent('zb-vehicletuning:server:SendEmergencyMessage')
AddEventHandler('zb-vehicletuning:server:SendEmergencyMessage', function(coords, message)
    local src = source
    local MainPlayer = QBCore.Functions.GetPlayer(src)
    local phoneNumber = MainPlayer.PlayerData.charinfo.phone
    local citizenid = MainPlayer.PlayerData.citizenid
    local fullname = MainPlayer.PlayerData.charinfo.firstname .. " " .. MainPlayer.PlayerData.charinfo.lastname
    local alertData = { 
        title = phoneNumber, 
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message, 
    }

    TriggerClientEvent("qb-phone:client:AddAnwbAlert", -1, alertData)
    TriggerClientEvent('zb-vehicletuning:server:SendEmergencyMessageCheck', -1, MainPlayer, message, coords)
    QBCore.Functions.ExecuteSql(true, "INSERT INTO `anwb_meldingen` (`fullname`, `message`, `phone`, `citizenid`) VALUES ('"..fullname.."', '"..message.."', '"..phoneNumber.."','"..citizenid.."')")
end)

RegisterServerEvent("vehiclemod:server:setupVehicleStatus")
AddEventHandler("vehiclemod:server:setupVehicleStatus", function(plate, engineHealth, bodyHealth)
    local src = source
    local engineHealth = engineHealth ~= nil and engineHealth or 1000.0
    local bodyHealth = bodyHealth ~= nil and bodyHealth or 1000.0
    if VehicleStatus[plate] == nil then 
        if IsVehicleOwned(plate) then
            local statusInfo = GetVehicleStatus(plate)
            if statusInfo == nil then 
                statusInfo =  {
                    ["engine"] = engineHealth,
                    ["body"] = bodyHealth,
                    ["radiator"] = Config.MaxStatusValues["radiator"],
                    ["axle"] = Config.MaxStatusValues["axle"],
                    ["brakes"] = Config.MaxStatusValues["brakes"],
                    ["clutch"] = Config.MaxStatusValues["clutch"],
                    ["fuel"] = Config.MaxStatusValues["fuel"],
                }
            end
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        else
            local statusInfo = {
                ["engine"] = engineHealth,
                ["body"] = bodyHealth,
                ["radiator"] = Config.MaxStatusValues["radiator"],
                ["axle"] = Config.MaxStatusValues["axle"],
                ["brakes"] = Config.MaxStatusValues["brakes"],
                ["clutch"] = Config.MaxStatusValues["clutch"],
                ["fuel"] = Config.MaxStatusValues["fuel"],
            }
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        end
    else
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent('qb-vehicletuning:server:UpdateDrivingDistance')
AddEventHandler('qb-vehicletuning:server:UpdateDrivingDistance', function(amount, plate)
    VehicleDrivingDistance[plate] = amount

    TriggerClientEvent('qb-vehicletuning:client:UpdateDrivingDistance', -1, VehicleDrivingDistance[plate], plate)

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `drivingdistance` = '"..amount.."' WHERE `plate` = '"..plate.."'")
        end
    end)
end)

QBCore.Functions.CreateCallback('qb-vehicletuning:server:IsVehicleOwned', function(source, cb, plate)
    local retval = false
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
        cb(retval)
    end)
end)

RegisterServerEvent('qb-vehicletuning:server:LoadStatus')
AddEventHandler('qb-vehicletuning:server:LoadStatus', function(veh, plate)
    VehicleStatus[plate] = veh
    TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, veh)
end)

RegisterServerEvent("vehiclemod:server:updatePart")
AddEventHandler("vehiclemod:server:updatePart", function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        if part == "engine" or part == "body" then
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 1000 then
                VehicleStatus[plate][part] = 1000.0
            end
        else
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 100 then
                VehicleStatus[plate][part] = 100
            end
        end
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent('qb-vehicletuning:server:SetPartLevel')
AddEventHandler('qb-vehicletuning:server:SetPartLevel', function(plate, part, level)
    if VehicleStatus[plate] ~= nil then
        VehicleStatus[plate][part] = level
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent("vehiclemod:server:fixEverything")
AddEventHandler("vehiclemod:server:fixEverything", function(plate)
    if VehicleStatus[plate] ~= nil then 
        for k, v in pairs(Config.MaxStatusValues) do
            VehicleStatus[plate][k] = v
        end
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

RegisterServerEvent("vehiclemod:server:saveStatus")
AddEventHandler("vehiclemod:server:saveStatus", function(plate)
    if VehicleStatus[plate] ~= nil then
        exports['ghmattimysql']:execute('UPDATE player_vehicles SET status = @status WHERE plate = @plate', {['@status'] = json.encode(VehicleStatus[plate]), ['@plate'] = plate})
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end

function GetVehicleStatus(plate)
    local retval = nil
    QBCore.Functions.ExecuteSql(true, "SELECT `status` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = result[1].status ~= nil and json.decode(result[1].status) or nil
        end
    end)
    return retval
end

QBCore.Commands.Add("setvehiclestatus", "Zet vehicle status", {{name="part", help="Type status dat je wilt bewerken"}, {name="amount", help="Level van de status"}}, true, function(source, args)
    local part = args[1]:lower()
    local level = tonumber(args[2])
    TriggerClientEvent("vehiclemod:client:setPartLevel", source, part, level)
end, "god")

QBCore.Functions.CreateCallback('qb-vehicletuning:server:GetAttachedVehicle', function(source, cb)
    cb(Config.Plates)
end)

QBCore.Functions.CreateCallback('qb-vehicletuning:server:IsMechanicAvailable', function(source, cb)
	local amount = 0
	for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)

RegisterServerEvent('qb-vehicletuning:server:SetAttachedVehicle')
AddEventHandler('qb-vehicletuning:server:SetAttachedVehicle', function(veh, k)
    if veh ~= false then
        Config.Plates[k].AttachedVehicle = veh
        TriggerClientEvent('qb-vehicletuning:client:SetAttachedVehicle', -1, veh, k)
    else
        Config.Plates[k].AttachedVehicle = nil
        TriggerClientEvent('qb-vehicletuning:client:SetAttachedVehicle', -1, false, k)
    end
end)

RegisterServerEvent('qb-vehicletuning:server:CheckForItems')
AddEventHandler('qb-vehicletuning:server:CheckForItems', function(part)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local RepairPart = Player.Functions.GetItemByName(Config.RepairCostAmount[part].item)

    if RepairPart ~= nil then
        if RepairPart.amount >= Config.RepairCostAmount[part].costs then
            TriggerClientEvent('qb-vehicletuning:client:RepaireeePart', src, part)
            Player.Functions.RemoveItem(Config.RepairCostAmount[part].item, Config.RepairCostAmount[part].costs)

            for i = 1, Config.RepairCostAmount[part].costs, 1 do
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.RepairCostAmount[part].item], "remove")
                Citizen.Wait(500)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Je hebt niet genoeg "..QBCore.Shared.Items[Config.RepairCostAmount[part].item]["label"].." (min. "..Config.RepairCostAmount[part].costs.."x)", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Je hebt geen "..QBCore.Shared.Items[Config.RepairCostAmount[part].item]["label"].." bij je!", "error")
    end
end)

function IsAuthorized(CitizenId)
    local retval = false
    for _, cid in pairs(Config.AuthorizedIds) do
        if cid == CitizenId then
            retval = true
            break
        end
    end
    return retval
end

QBCore.Commands.Add("setmechanic", "Geeft iemand de ANWB baan.", {{name="id", help="ID"}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)

    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = QBCore.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                TargetData.Functions.SetJob("mechanic")
                TriggerClientEvent('QBCore:Notify', TargetData.PlayerData.source, "Je bent aangenomen als ANWB medewerker!")
                TriggerClientEvent('QBCore:Notify', source, "Je hebt ("..TargetData.PlayerData.charinfo.firstname..") aangenomen als ANWB medewerker!")
            end
        else
            TriggerClientEvent('QBCore:Notify', source, "Er is geen ID opgegeven!")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "Je hebt hier geen rechten voor!", "error") 
    end
end)

QBCore.Commands.Add("kickmechanic", "Ontslaat iemand van de ANWB.", {{name="id", help="ID"}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)

    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = QBCore.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                if TargetData.PlayerData.job.name == "mechanic" then
                    TargetData.Functions.SetJob("unemployed")
                    TriggerClientEvent('QBCore:Notify', TargetData.PlayerData.source, "Je bent ontslagen als ANWB mederwerker!")
                    TriggerClientEvent('QBCore:Notify', source, "Je hebt ("..TargetData.PlayerData.charinfo.firstname..") ontslagen als ANWB mederwerker!")
                else
                    TriggerClientEvent('QBCore:Notify', source, "Deze persoon is geen ANWB medewerker!", "error")
                end
            end
        else
            TriggerClientEvent('QBCore:Notify', source, "Er is geen ID opgegeven!", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "Je hebt hier geen rechten voor!", "error")
    end
end)

QBCore.Functions.CreateCallback('qb-vehicletuning:server:GetStatus', function(source, cb, plate)
    if VehicleStatus[plate] ~= nil and next(VehicleStatus[plate]) ~= nil then
        cb(VehicleStatus[plate])
    else
        cb(nil)
    end
end)

RegisterServerEvent('zb-vehicletuning:server:SaveVehicleProps')
AddEventHandler('zb-vehicletuning:server:SaveVehicleProps', function(vehicleProps)
    local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end