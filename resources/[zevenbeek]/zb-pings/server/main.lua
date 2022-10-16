QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local Pings = {}

QBCore.Commands.Add("ping", "", {{name = "actie", help="id | accept | deny"}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local task = args[1]
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if task == "accept" then
            if Pings[src] ~= nil then
                TriggerClientEvent('qb-pings:client:AcceptPing', src, Pings[src], QBCore.Functions.GetPlayer(Pings[src].sender), Pings[src].sender)
                TriggerClientEvent('QBCore:Notify', Pings[src].sender, "ID " .. src .. " heeft je ping geaccepteerd!")
                Pings[src] = nil
            else
                TriggerClientEvent('QBCore:Notify', src, "Je hebt geen Pings open!", "error")
            end
        elseif task == "deny" then
            if Pings[src] ~= nil then
                TriggerClientEvent('QBCore:Notify', Pings[src].sender, "Je ping is geweigerd!", "error")
                TriggerClientEvent('QBCore:Notify', src, "Tiy heeft de ping geweigerd!", "success")
                Pings[src] = nil
            else
                TriggerClientEvent('QBCore:Notify', src, "Je hebt geen ping om te accepteren!", "error")
            end
        else
            TriggerClientEvent('qb-pings:client:DoPing', src, tonumber(args[1]))
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Je hebt geen telefoon!", "error")
    end
end)

RegisterServerEvent('qb-pings:server:SendPing')
AddEventHandler('qb-pings:server:SendPing', function(id, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(id)
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if Target ~= nil then
            local OtherItem = Target.Functions.GetItemByName("phone")
            if OtherItem ~= nil then
                TriggerClientEvent('QBCore:Notify', src, "Je hebt een ping verstuurd naar ID " .. id .. "!")
                Pings[id] = {
                    coords = coords,
                    sender = src
                }
                TriggerClientEvent('QBCore:Notify', id, "Je hebt een ping ontvangen van ID " .. src .. ", /ping 'accept | deny'")
            else
                TriggerClientEvent('QBCore:Notify', src, "Kon de ping niet verzenden, misschien heeft de persoon geen internet verbinding!", "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Deze persoon is niet online!", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Je hebt geen telefoon!", "error")
    end
end)

RegisterServerEvent('qb-pings:server:SendLocation')
AddEventHandler('qb-pings:server:SendLocation', function(PingData, SenderData)
    TriggerClientEvent('qb-pings:client:SendLocation', PingData.sender, PingData, SenderData)
end)