QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("rockstar", "Maak gebruik van Rockstar Editor, voorbeeld: /rockstar aan of /rockstar uit", {}, false, function(source, args)
    if args[1] ~= nil then
        if args[1] == "aan" then
            status = "aan"
            TriggerClientEvent("fortis-smallresources:rockstarEditor", source, status)
        end
        if args[1] == "uit" then
            status = "uit"
            TriggerClientEvent("fortis-smallresources:rockstarEditor", source, status)
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Geen argumenten ingevuld, gebruik aan of uit")
    end
end)