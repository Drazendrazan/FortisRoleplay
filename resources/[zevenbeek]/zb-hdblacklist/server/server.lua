QBcore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback("zb-hdblacklist:server:GetPermissions", function(source, cb)
    group = QBCore.Functions.GetPermission(source)
    cb(group)
end) 