QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local tunedVehicles = {}
local VehicleNitrous = {}

QBCore.Functions.CreateUseableItem("tunerlaptop", function(source, item)
    TriggerClientEvent('fortis-tunerchip:client:openChip', source)
end)

RegisterServerEvent('fortis-tunerchip:server:TuneStatus')
AddEventHandler('fortis-tunerchip:server:TuneStatus', function(plate, bool)
    if bool then
        tunedVehicles[plate] = bool
    else
        tunedVehicles[plate] = nil
    end
end)

RegisterServerEvent("fortis-tunerchip:server:foei")
AddEventHandler("fortis-tunerchip:server:foei", function()
    local src = source
    DropPlayer(src, 'Foei zo makkelijk gaat het abusen van de tunerchip niet, groetjes Damian aka fortis staff!')
end)

QBCore.Functions.CreateCallback("fortis-tunerchip:server:HasChip", function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local Chip = Ply.Functions.GetItemByName('tunerlaptop')
    if Chip ~= nil then
        cb(true)
    else
        DropPlayer(src, 'This is not the idea, is it?')
        cb(true)
    end
end)

QBCore.Functions.CreateCallback('fortis-tunerchip:server:GetStatus', function(source, cb, plate)
    cb(tunedVehicles[plate])
end)

QBCore.Functions.CreateUseableItem("nitrous", function(source, item)
    TriggerClientEvent('smallresource:client:LoadNitrous', source)
end)

RegisterServerEvent('nitrous:server:LoadNitrous')
AddEventHandler('nitrous:server:LoadNitrous', function(Plate)
    VehicleNitrous[Plate] = {
        hasnitro = true,
        level = 100,
    }
    TriggerClientEvent('nitrous:client:LoadNitrous', -1, Plate)
end)

RegisterServerEvent('nitrous:server:SyncFlames')
AddEventHandler('nitrous:server:SyncFlames', function(netId)
    TriggerClientEvent('nitrous:client:SyncFlames', -1, netId, source)
end)

RegisterServerEvent('nitrous:server:UnloadNitrous')
AddEventHandler('nitrous:server:UnloadNitrous', function(Plate)
    VehicleNitrous[Plate] = nil
    TriggerClientEvent('nitrous:client:UnloadNitrous', -1, Plate)
end)
RegisterServerEvent('nitrous:server:UpdateNitroLevel')
AddEventHandler('nitrous:server:UpdateNitroLevel', function(Plate, level)
    VehicleNitrous[Plate].level = level
    TriggerClientEvent('nitrous:client:UpdateNitroLevel', -1, Plate, level)
end)

RegisterServerEvent('nitrous:server:StopSync')
AddEventHandler('nitrous:server:StopSync', function(plate)
    TriggerClientEvent('nitrous:client:StopSync', -1, plate)
end)
