QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

print("test!")

QBCore.Commands.Add("binds", "Opent het menu om commando's te binden.", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
	TriggerClientEvent("fortis-custombinds:client:openUI", source)
end)

RegisterServerEvent('fortis-custombinds:server:setKeyMeta')
AddEventHandler('fortis-custombinds:server:setKeyMeta', function(keyMeta)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    ply.Functions.SetMetaData("commandbinds", keyMeta)
end)

print("dit werkt!")