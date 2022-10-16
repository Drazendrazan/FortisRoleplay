QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local VehicleList = {}

QBCore.Functions.CreateCallback('vehiclekeys:CheckHasKey', function(source, cb, plate)
    local Player = QBCore.Functions.GetPlayer(source)
    cb(CheckOwner(plate, Player.PlayerData.citizenid))
end)

RegisterServerEvent('vehiclekeys:server:SetVehicleOwner')
AddEventHandler('vehiclekeys:server:SetVehicleOwner', function(plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if VehicleList ~= nil then
        if DoesPlateExist(plate) then
            for k, val in pairs(VehicleList) do
                if val.plate == plate then
                    table.insert(VehicleList[k].owners, Player.PlayerData.citizenid)
                    return
                end
            end
            makeTable(Player.PlayerData.citizenid)
        else
            local vehicleId = #VehicleList+1 ~= 0 and #VehicleList ~= nil and #VehicleList or 1
            VehicleList[vehicleId] = {
                plate = plate, 
                owners = {},
            }
            VehicleList[vehicleId].owners[1] = Player.PlayerData.citizenid
        end
    else
        local vehicleId = #VehicleList+1 ~= 0 and #VehicleList ~= nil and #VehicleList or 1
        VehicleList[vehicleId] = {
            plate = plate, 
            owners = {},
        }
        VehicleList[vehicleId].owners[1] = Player.PlayerData.citizenid
    end
end)

makeTable = function(cid)
    local vehicleId = #VehicleList+1 ~= 0 and #VehicleList ~= nil and #VehicleList or 1
    VehicleList[vehicleId] = {
        plate = plate, 
        owners = {},
    }
    VehicleList[vehicleId].owners[1] = cid
end

RegisterServerEvent('vehiclekeys:server:GiveVehicleKeys')
AddEventHandler('vehiclekeys:server:GiveVehicleKeys', function(plate, target)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if CheckOwner(plate, Player.PlayerData.citizenid) then
        if QBCore.Functions.GetPlayer(target) ~= nil then
            TriggerClientEvent('vehiclekeys:client:SetOwner', target, plate)
            TriggerClientEvent('QBCore:Notify', src, "Je hebt de sleutels succesvol overhandigd!")
            TriggerClientEvent('QBCore:Notify', target, "Je hebt de sleutels ontvangen!")
        else
            TriggerClientEvent('chatMessage', src, "SYSTEEM", "error", "Speler niet online!")
        end
    else
        TriggerClientEvent('chatMessage', src, "SYSTEEM", "error", "Je hebt de sleutels niet!")
    end
end)

QBCore.Commands.Add("motor", "Schakelt de motor van het inzittende voertuig aan/uit.", {}, false, function(source, args)
	TriggerClientEvent('vehiclekeys:client:ToggleEngine', source)
end)

QBCore.Commands.Add("geefsleutels", "Overhandigt de sleutels van het voertuig.", {{name = "id", help = "ID"}}, true, function(source, args)
	local src = source
    local target = tonumber(args[1])
    TriggerClientEvent('vehiclekeys:client:GiveKeys', src, target)
end)

function DoesPlateExist(plate)
    if VehicleList ~= nil then
        for k, val in pairs(VehicleList) do
            if val.plate == plate then
                return true
            end
        end
    end
    return false
end

function CheckOwner(plate, identifier)
    local retval = false
    if VehicleList ~= nil then
        for k, val in pairs(VehicleList) do
            if val.plate == plate then
                for key, owner in pairs(VehicleList[k].owners) do
                    if owner == identifier then
                        retval = true
                    end
                end
            end
        end
    end
    return retval
end

QBCore.Functions.CreateUseableItem("lockpick", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, false)
end)

QBCore.Functions.CreateUseableItem("advancedlockpick", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("lockpicks:UseLockpick", source, true)
end)