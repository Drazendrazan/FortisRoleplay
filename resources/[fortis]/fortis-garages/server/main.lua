QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local OutsideVehicles = {}
local OutsidePlanes = {}

-- code

RegisterServerEvent('qb-garages:server:UpdateOutsideVehicles')
AddEventHandler('qb-garages:server:UpdateOutsideVehicles', function(Vehicles)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local CitizenId = Ply.PlayerData.citizenid

    OutsideVehicles[CitizenId] = Vehicles
end)

QBCore.Functions.CreateCallback("qb-garage:server:GetOutsideVehicles", function(source, cb)
    local Ply = QBCore.Functions.GetPlayer(source)
    local CitizenId = Ply.PlayerData.citizenid

    if OutsideVehicles[CitizenId] ~= nil and next(OutsideVehicles[CitizenId]) ~= nil then
        cb(OutsideVehicles[CitizenId])
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback("qb-garage:server:GetUserVehicles", function(source, cb, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE citizenid = @citizenid AND garage = @garage', {['@citizenid'] = pData.PlayerData.citizenid, ['@garage'] = garage}, function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end 
    end)
end)

QBCore.Functions.CreateCallback("qb-garage:server:GetVehicleProperties", function(source, cb, plate)
    local src = source
    local properties = {}
    QBCore.Functions.ExecuteSql(false, "SELECT `mods` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            properties = json.decode(result[1].mods)
        end
        cb(properties)
    end)
end) 

QBCore.Functions.CreateCallback("qb-garage:server:GetDepotVehicles", function(source, cb)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE citizenid = @citizenid AND state = 0', {['@citizenid'] = pData.PlayerData.citizenid, ['@state'] = 0}, function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-garage:server:GetHouseVehicles", function(source, cb, house)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE garage = @garage', {['@garage'] = house}, function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-garage:server:checkVehicleHouseOwner", function(source, cb, plate, house)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local CitizenId = pData.PlayerData.citizenid

    QBCore.Functions.ExecuteSql(true, "SELECT `citizenid` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if #result > 0 then
            if result[1].citizenid ~= nil then
                cb(result)
                QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_houses` WHERE `citizenid` = '"..CitizenId.."'", function(resultHouse)
                    if #resultHouse > 0 then
                        cb(result)
                    end
                end)
            else
                cb(nil)
            end
        end 
    end)
end)

QBCore.Functions.CreateCallback("qb-garage:server:checkVehicleOwner", function(source, cb, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql(true, "SELECT `citizenid` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if #result > 0 then
            if result[1].citizenid ~= nil then
                cb(result)
                Player.Functions.RemoveMoney("bank", 1000, "Voertuigen oververschepen")
            else
                cb(nil)
            end
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('fortis-garages:server:verscheep')
AddEventHandler('fortis-garages:server:verscheep', function(plate)
    QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET state = '1', garage = 'cayo' WHERE plate = '"..plate.."'")
end)

RegisterServerEvent('qb-garage:server:PayDepotPrice')
AddEventHandler('qb-garage:server:PayDepotPrice', function(vehicle, garage)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local bankBalance = Player.PlayerData.money["bank"]
    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE plate = @plate', {['@plate'] = vehicle.plate}, function(result)
        if result[1] ~= nil then
            if Player.Functions.RemoveMoney("cash", result[1].depotprice, "paid-depot") then
                TriggerClientEvent("qb-garages:client:takeOutDepot", src, vehicle, garage)
            elseif bankBalance >= result[1].depotprice then
                Player.Functions.RemoveMoney("bank", result[1].depotprice, "paid-depot")
                TriggerClientEvent("qb-garages:client:takeOutDepot", src, vehicle, garage)
            end
        end
    end)
end)

RegisterServerEvent('qb-garage:server:updateVehicleState')
AddEventHandler('qb-garage:server:updateVehicleState', function(state, plate, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('UPDATE player_vehicles SET state = @state, garage = @garage, depotprice = @depotprice WHERE plate = @plate', {['@state'] = state, ['@plate'] = plate, ['@depotprice'] = 0, ['@citizenid'] = pData.PlayerData.citizenid, ['@garage'] = garage})
end)

RegisterServerEvent('qb-garage:server:updateVehicleStatus')
AddEventHandler('qb-garage:server:updateVehicleStatus', function(fuel, engine, body, plate, garage, props)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    if engine > 1000 then
        engine = engine / 1000
    end

    if body > 1000 then
        body = body / 1000
    end

    if props ~= 0 then
        exports['ghmattimysql']:execute("UPDATE `player_vehicles` SET `fuel` = '" .. fuel .. "', `mods` = '" .. json.encode(props) .. "', `engine` = '" .. engine .. "', `body` = '" .. body .. "' WHERE `plate` = '" .. plate .. "' AND `citizenid` = '" .. pData.PlayerData.citizenid .. "' AND `garage` = '" .. garage .. "'")
    else
        exports['ghmattimysql']:execute('UPDATE `player_vehicles` SET `fuel` = "' .. fuel .. '", `engine` = "' .. engine .. '", `body` = "' .. body .. '" WHERE `plate` = "' .. plate .. '" AND `citizenid` = "' .. pData.PlayerData.citizenid .. '" AND `garage` = "' .. garage .. '"')
    end
end)

RegisterServerEvent('qb-garage:server:checkVehicleOwner')
AddEventHandler('qb-garage:server:checkVehicleOwner', function()
    print("okeh")
end)


QBCore.Functions.CreateCallback("qb-garage:server:chechAnwb", function(source, cb)
    local anwb = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty == true then
                anwb = anwb + 1
            end
        end
    end
    cb(anwb)
end)

-- Vliegtuigen torrie
QBCore.Functions.CreateCallback("qb-garages:server:getVliegtuigen", function(source, cb, hangar)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local steam = Player.PlayerData.steam

    if hangar ~= "depot" then
        -- Normale hangar
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_planes` WHERE citizenid = '"..citizenid.."' AND steam = '"..steam.."' AND hangar = '"..hangar.."'", function(vliegtuigen)
            if #vliegtuigen > 0 then
                cb(vliegtuigen)
            else
                cb(nil)
            end
        end)
        return
    else
        -- Depot stad
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `player_planes` WHERE citizenid = '"..citizenid.."' AND steam = '"..steam.."' AND state = '0'", function(vliegtuigen)
            if #vliegtuigen > 0 then
                cb(vliegtuigen)
            else
                cb(nil)
            end
        end)
        return
    end

end)

RegisterServerEvent("qb-garages:server:setVliegtuigState")
AddEventHandler("qb-garages:server:setVliegtuigState", function(vliegtuig, state)
    local src = source
    QBCore.Functions.ExecuteSql(false, "UPDATE `player_planes` SET state = '"..state.."' WHERE plate = '"..vliegtuig.plate.."'")
    OutsidePlanes[vliegtuig.plate] = vliegtuig
end)

RegisterServerEvent("qb-garages:server:putVliegtuig")
AddEventHandler("qb-garages:server:putVliegtuig", function(vliegtuig, state)
    local src = source
    QBCore.Functions.ExecuteSql(false, "UPDATE `player_planes` SET state = '"..state.."', fuel = '"..vliegtuig.fuel.."', hangar = '"..vliegtuig.hangar.."' WHERE plate = '"..vliegtuig.plate.."'")
    OutsidePlanes[vliegtuig.plate] = nil
end)


QBCore.Functions.CreateCallback("qb-garages:server:checkVliegtuigBestaan", function(source, cb, vliegtuig)
    for k, v in pairs(OutsidePlanes) do
        if k == vliegtuig.plate then
            cb(false)
            return
        end
    end
    cb(true)
end)


QBCore.Functions.CreateCallback("qb-garages:server:tankVliegtuig", function(source, cb, benzineLevel)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Harde waardes
    local prijsPerProcent = 15 -- 15€ per procentje/liter
    local aantalBenzine = 100 - benzineLevel
    local subTotaal = math.floor(aantalBenzine * prijsPerProcent)

    if Player.PlayerData.money["bank"] >= subTotaal then
        Player.Functions.RemoveMoney("bank", subTotaal, "Vliegtuig bijgevuld met benzine")
        cb(true, subTotaal)
    else
        cb(false, subTotaal)
    end

end)


-- Tunings opslaan
RegisterServerEvent("qb-garage:server:updateVliegtuigTuning")
AddEventHandler("qb-garage:server:updateVliegtuigTuning", function(data, props)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if props ~= 0 then
        QBCore.Functions.ExecuteSql(false, "UPDATE `player_planes` SET mods = '"..json.encode(props).."' WHERE plate = '"..data.plate.."'")
    end

end)

QBCore.Functions.CreateCallback("fortis-garages:server:haalVliegtuigTuningsOp", function(source, cb, kenteken)
    local src = source
    local properties = {}
    
    QBCore.Functions.ExecuteSql(false, "SELECT `mods` FROM `player_planes` WHERE plate = '"..kenteken.."'", function(resultaat)
        if resultaat[1] ~= nil then
            properties = json.decode(resultaat[1].mods)
        end
        cb(properties)
    end)
end)

RegisterNetEvent("qb-garage:server:betaalReparatie")
AddEventHandler("qb-garage:server:betaalReparatie", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney("bank", 375, "Garage reparatie betaald")
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