QBCore = nil 

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local ResetStress = false

QBCore.Commands.Add('cash', 'Check Cash Balance', {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local cashamount = Player.PlayerData.money.cash
	TriggerClientEvent('hud:client:ShowAccounts', source, 'cash', cashamount)
end)

QBCore.Commands.Add('bank', 'Check Bank Balance', {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local bankamount = Player.PlayerData.money.bank
	TriggerClientEvent('hud:client:ShowAccounts', source, 'bank', bankamount)
end)
 
RegisterServerEvent('qb-hud:server:GainStress')
AddEventHandler('qb-hud:server:GainStress', function(amount, vehileClass)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil and Player.PlayerData.job.name ~= 'police' then
        if vehileClass ~= 15 and vehileClass ~= 16 and vehileClass ~= 8 then
            if not ResetStress then
                if Player.PlayerData.metadata['stress'] == nil then
                    Player.PlayerData.metadata['stress'] = 0
                end
                newStress = Player.PlayerData.metadata['stress'] + amount
                if newStress <= 0 then newStress = 0 end
            else
                newStress = 0
            end
            if newStress > 100 then
                newStress = 100
            end
            Player.Functions.SetMetaData('stress', newStress)
            TriggerClientEvent('hud:client:UpdateStress', src, newStress)
            TriggerClientEvent('QBCore:Notify', src, 'Stress opgedaan', 'error', 1500)
        end
	end
end)

RegisterServerEvent('qb-hud:Server:RelieveStress')
AddEventHandler('qb-hud:Server:RelieveStress', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil then 
        if not ResetStress then
            if Player.PlayerData.metadata['stress'] == nil then
                Player.PlayerData.metadata['stress'] = 0
            end
            newStress = Player.PlayerData.metadata['stress'] - amount
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData('stress', newStress)
        TriggerClientEvent('hud:client:UpdateStress', src, newStress)
        TriggerClientEvent('QBCore:Notify', src, 'Stress verlicht, je voelt je kalmer')
	end
end)

QBCore.Commands.Add("hud", "Zet hud aan of uit", {}, false, function(source, args)
    TriggerClientEvent("hud:client:hudZichtbaarheid", source)
end)