QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local BankStatus = {}

RegisterServerEvent('qb-banking:server:SetBankClosed')
AddEventHandler('qb-banking:server:SetBankClosed', function(BankId, bool)
  BankStatus[BankId] = bool
  TriggerClientEvent('qb-banking:client:SetBankClosed', -1, BankId, bool)
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local bankamount = ply.PlayerData.money["bank"]
    local amount = tonumber(amount)
    if bankamount >= amount and amount > 0 then
      ply.Functions.RemoveMoney('bank', amount, "Bank withdraw")
      TriggerEvent("qb-log:server:CreateLog", "banking", "Geld Opgenomen", "red", "**"..GetPlayerName(src) .. "** heeft €"..amount.." opgenomen van zijn/haar bankrekening.")
      ply.Functions.AddMoney('cash', amount, "Bank withdraw")
    else
      TriggerClientEvent('QBCore:Notify', src, 'Je hebt onvoldoende saldo!', 'error')
    end
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local cashamount = ply.PlayerData.money["cash"]
    local amount = tonumber(amount)
    if cashamount >= amount and amount > 0 then
      ply.Functions.RemoveMoney('cash', amount, "Bank depost")
      TriggerEvent("qb-log:server:CreateLog", "banking", "Deposit", "green", "**"..GetPlayerName(src) .. "** has deposited €"..amount.." to their bank account.")
      ply.Functions.AddMoney('bank', amount, "Bank depost")
    else
      TriggerClientEvent('QBCore:Notify', src, 'Je hebt onvoldoende saldo!', 'error')
    end
end)

QBCore.Commands.Add("givecash", "Geeft geld aan een speler.", {{name="id", help="Player ID"},{name="amount", help="Amount of money"}}, true, function(source, args)
  local src = source
  local Player = QBCore.Functions.GetPlayer(source)
  local TargetId = tonumber(args[1])
  local Target = QBCore.Functions.GetPlayer(TargetId)
  local amount = tonumber(args[2])
  
  if Target ~= nil then
    if amount ~= nil then
      if amount > 0 then
        if Player.PlayerData.money.cash >= amount and amount > 0 then
          if TargetId ~= src then
            TriggerClientEvent('banking:client:CheckDistance', src, TargetId, amount)
          else
            TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "You cannot give money to yourself.")     
          end
        else
          TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "You dont have enough money.")
        end
      else
        TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "The amount must be higher then 0.")
      end
    else
      TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Enter an amount.")
    end
  else
    TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Player is not online.")
  end    
end)

RegisterServerEvent('banking:server:giveCash')
AddEventHandler('banking:server:giveCash', function(trgtId, amount)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  local Target = QBCore.Functions.GetPlayer(trgtId)

  if src ~= trgtId then
    Player.Functions.RemoveMoney('cash', amount, "Geld succesvol overgemaakt naar "..Player.PlayerData.citizenid.."!")
    Target.Functions.AddMoney('cash', amount, "Geld succesvol overgemaakt naar "..Target.PlayerData.citizenid.."!")

    TriggerEvent("qb-log:server:CreateLog", "banking", "Give cash", "blue", "**"..GetPlayerName(src) .. "** heeft €"..amount.." cash gegeven aan **" .. GetPlayerName(trgtId) .. "**")
    
    TriggerClientEvent('QBCore:Notify', trgtId, "Je hebt €"..amount.." ontvangen van "..Player.PlayerData.charinfo.firstname.."!", 'success')
    TriggerClientEvent('QBCore:Notify', src, "Je hebt succesvol €"..amount.." overgemaakt naar "..Target.PlayerData.charinfo.firstname.."!", 'success')
  else
    TriggerEvent("qb-anticheat:server:banPlayer", "Cheating")
    TriggerEvent("qb-log:server:CreateLog", "anticheat", "Speler verbannen!", "red", "** @everyone " ..GetPlayerName(player).. "** heeft geprobeerd **€"..amount.." aan hemzelf te geven!")  
  end
end)
