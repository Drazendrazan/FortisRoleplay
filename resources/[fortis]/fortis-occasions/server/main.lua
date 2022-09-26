QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

QBCore.Commands.Add("verkoop2ehands", "Zet je auto in de 2e hands dealer", {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local prijs = args[1]
    if prijs ~= nil then
        if tonumber(prijs) ~= nil then
            TriggerClientEvent("fortis-occasions:client:verkoopAuto", src, prijs)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Je moet de prijs invullen in nummers, zonder letters!', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Je moet een prijs invullen!', 'error')
    end
end)

RegisterNetEvent("fortis-occasions:server:dataCheck")
AddEventHandler("fortis-occasions:server:dataCheck", function(kenteken, prijs)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE citizenid = '"..citizenid.."' AND plate = '"..kenteken.."'", function(resultaat)
        if resultaat[1] ~= nil then
            TriggerClientEvent("fortis-occasions:client:goedkeuringAuto", src, prijs)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Dit voertuig is niet van jou!', 'error')
        end
    end)
end)

QBCore.Functions.CreateCallback('qb-occasions:server:getVehicles', function(source, cb)
    QBCore.Functions.ExecuteSql(true, 'SELECT * FROM `occasion_vehicles`', function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)
 
RegisterServerEvent('qb-occasions:server:ReturnVehicle')
AddEventHandler('qb-occasions:server:ReturnVehicle', function(vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."' AND `occasionid` = '"..vehicleData["oid"].."'", function(result)
        if result[1] ~= nil then 
            if result[1].seller == Player.PlayerData.citizenid then
                QBCore.Functions.ExecuteSql(true, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..result[1].model.."', '"..GetHashKey(result[1].model).."', '"..result[1].mods.."', '"..result[1].plate.."', 'sapcounsel', '1')")
                QBCore.Functions.ExecuteSql(true, "DELETE FROM `occasion_vehicles` WHERE `occasionid` = '"..vehicleData["oid"].."' and `plate` = '"..vehicleData['plate'].."'")
                TriggerClientEvent("qb-occasions:client:ReturnOwnedVehicle", src, result[1])
                TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
            else
                TriggerClientEvent('QBCore:Notify', src, 'Dit is niet jouw voertuig...', 'error', 3500)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'Dit voertuig bestaat niet?!?...', 'error', 3500)
        end
    end)
end)

RegisterServerEvent('qb-occasions:server:sellVehicle')
AddEventHandler('qb-occasions:server:sellVehicle', function(vehiclePrice, vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    QBCore.Functions.ExecuteSql(true, "DELETE FROM `player_vehicles` WHERE `plate` = '"..vehicleData.plate.."' AND `citizenid` = '"..citizenid.."'")
    QBCore.Functions.ExecuteSql(true, "INSERT INTO `occasion_vehicles` (`seller`, `price`, `description`, `plate`, `model`, `mods`, `occasionid`) VALUES ('"..Player.PlayerData.citizenid.."', '"..vehiclePrice.."', '"..escapeSqli(vehicleData.desc).."', '"..vehicleData.plate.."', '"..vehicleData.model.."', '"..json.encode(vehicleData.mods).."', '"..generateOID().."')")

    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehiclesold", {model=vehicleData.model, vehiclePrice=vehiclePrice})
    TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Vehicle for  sale", "red", "**"..GetPlayerName(src) .. "** heeft een " .. vehicleData.model .. " List on sale for "..vehiclePrice)

    TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
end)

RegisterServerEvent('qb-occasions:server:buyVehicle')
AddEventHandler('qb-occasions:server:buyVehicle', function(vehicleData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local NewPrice = vehicleData['price']
    local SellerCitizenId = vehicleData['owner']

    if citizenid ~= SellerCitizenId then
        QBCore.Functions.ExecuteSql(true, "SELECT * FROM `occasion_vehicles` WHERE `plate` = '"..vehicleData['plate'].."' AND `occasionid` = '"..vehicleData["oid"].."'", function(result)
            if result[1] ~= nil and next(result[1]) ~= nil then
                if Player.PlayerData.money.cash >= result[1].price then
                    local SellerData = QBCore.Functions.GetPlayerByCitizenId(SellerCitizenId)
                    -- New price calculation minus tax
                    Player.Functions.RemoveMoney('cash', result[1].price, "Auto gekocht in 2e hands dealer")

                    -- Insert vehicle for buyer
                    QBCore.Functions.ExecuteSql(true, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..result[1].model.."', '"..GetHashKey(result[1].model).."', '"..result[1].mods.."', '"..result[1].plate.."', 'sapcounsel', '1')")


                    -- Handle money transfer
                    if SellerData ~= nil then
                        -- Add money for online
                        SellerData.Functions.AddMoney('bank', NewPrice, "Auto verkocht in 2e hands dealer")
                    else
                        -- Add money for offline
                        QBCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..SellerCitizenId.."'", function(BuyerData)
                            if BuyerData[1] ~= nil then
                                local BuyerMoney = json.decode(BuyerData[1].money)
                                BuyerMoney.bank = BuyerMoney.bank + NewPrice
                                QBCore.Functions.ExecuteSql(true, "UPDATE `players` SET `money` = '"..json.encode(BuyerMoney).."' WHERE `citizenid` = '"..SellerCitizenId.."'")
                            end
                        end)
                    end
                
                    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model = result[1].model, from = SellerCitizenId, moneyType = "cash", vehiclePrice = result[1].price, plate = result[1].plate})
                    TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Occasion bought", "green", "**"..GetPlayerName(src) .. "** Bought a occasion for "..result[1].price .. " (" .. result[1].plate .. ") of **"..SellerCitizenId.."**")
                    TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
                
                    -- Delete vehicle from Occasion
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `occasion_vehicles` WHERE `plate` = '"..result[1].plate.."' and `occasionid` = '"..result[1].occasionid.."'")

                    -- Send selling mail to seller
                    TriggerClientEvent('QBCore:Notify', src, "Je hebt de "..QBCore.Shared.Vehicles[result[1].model].name.." gekocht voor €"..result[1].price.." en hij is in de rode garage zet!", 'success')
                    -- TriggerEvent('qb-phone:server:sendNewMailToOffline', SellerCitizenId, {
                    --     sender = "2e hands dealer",
                    --     subject = "Verkocht voertuig!",
                    --     message = "Je "..QBCore.Shared.Vehicles[result[1].model].name.." is verkocht voor €"..result[1].price..",-!"
                    -- })
                elseif Player.PlayerData.money.bank >= result[1].price then
                    local SellerCitizenId = result[1].seller
                    local SellerData = QBCore.Functions.GetPlayerByCitizenId(SellerCitizenId)
                    -- New price calculation minus tax

                    Player.Functions.RemoveMoney('bank', result[1].price, "Auto gekocht in 2e hands dealer")

                    -- Insert vehicle for buyer
                    QBCore.Functions.ExecuteSql(true, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..result[1].model.."', '"..GetHashKey(result[1].model).."', '"..result[1].mods.."', '"..result[1].plate.."', 'sapcounsel', '1')")

                    -- Handle money transfer
                    if SellerData ~= nil then
                        -- Add money for online
                        SellerData.Functions.AddMoney('bank', NewPrice, "Auto gekocht in 2e hands dealer")
                    else
                        -- Add money for offline
                        QBCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..SellerCitizenId.."'", function(BuyerData)
                            if BuyerData[1] ~= nil then
                                local BuyerMoney = json.decode(BuyerData[1].money)
                                BuyerMoney.bank = BuyerMoney.bank + NewPrice
                                QBCore.Functions.ExecuteSql(true, "UPDATE `players` SET `money` = '"..json.encode(BuyerMoney).."' WHERE `citizenid` = '"..SellerCitizenId.."'")
                            end
                        end)
                    end

                    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "vehiclebought", {model = result[1].model, from = SellerCitizenId, moneyType = "cash", vehiclePrice = result[1].price, plate = result[1].plate})
                    TriggerEvent("qb-log:server:CreateLog", "vehicleshop", "Occasion bought", "green", "**"..GetPlayerName(src) .. "** Bought a occasion for "..result[1].price .. " (" .. result[1].plate .. ") of **"..SellerCitizenId.."**")
                    TriggerClientEvent('qb-occasion:client:refreshVehicles', -1)
                
                    -- Delete vehicle from Occasion
                    QBCore.Functions.ExecuteSql(true, "DELETE FROM `occasion_vehicles` WHERE `plate` = '"..result[1].plate.."' and `occasionid` = '"..result[1].occasionid.."'")

                    -- Send selling mail to seller
                    TriggerClientEvent('QBCore:Notify', src, "Je hebt de "..QBCore.Shared.Vehicles[result[1].model].name.." gekocht voor €"..result[1].price.." en hij is in de rode garage zet!", 'success')
                    -- TriggerEvent('qb-phone:server:sendNewMailToOffline', SellerCitizenId, {
                    --     sender = "Mosleys Occasions",
                    --     subject = "You sold a vehicle!",
                    --     message = "Je "..QBCore.Shared.Vehicles[result[1].model].name.." has been sold for €"..result[1].price..",-!"
                    -- })
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Je hebt niet genoeg geld!', 'error', 3500)
                end
            end
        end)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Je kan je eigen voertuig niet kopen!', 'error', 3500)
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

function generateOID()
    local num = math.random(1, 10)..math.random(111, 999)

    return "OC"..num
end

function round(number)
    return number - (number % 1)
end

function escapeSqli(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end