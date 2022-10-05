Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

QBCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

-- Settings
local depositAtATM = true -- Allows the player to deposit at an ATM rather than only in banks (Default: false)
local giveCashAnywhere = false -- Allows the player to give CASH to another player, no matter how far away they are. (Default: false)
local withdrawAnywhere = false -- Allows the player to withdraw cash from bank account anywhere (Default: false)
local depositAnywhere = false -- Allows the player to deposit cash into bank account anywhere (Default: false)
local displayBankBlips = true -- Toggles Bank Blips on the map (Default: true)
local displayAtmBlips = false -- Toggles ATM blips on the map (Default: false) // THIS IS UGLY. SOME ICONS OVERLAP BECAUSE SOME PLACES HAVE MULTIPLE ATM MACHINES. NOT RECOMMENDED
local enableBankingGui = true -- Enables the banking GUI (Default: true) // MAY HAVE SOME ISSUES

-- ATMS
local atms = {
  [1] = {name="ATM", id=277,x=380.84, y=323.43, z=103.57},
  [2] = {name="ATM", id=277, x=1153.75, y=-326.8, z=69.21},
  [3] = {name="ATM", id=277, x=-56.92, y=-1752.18, z=29.42},
  [4] = {name="ATM", id=277, x=-717.71, y=-915.6, z=19.22},
  [5] = {name="ATM", id=277, x=-1827.27, y=784.84, z=138.3},
  [6] = {name="ATM", id=277, x=289.01, y=-1256.91, z=29.44},
  [7] = {name="ATM", id=277, x=-3044.0, y=594.65, z=7.74},
  [8] = {name="ATM", id=277, x=-3040.81, y=593.1, z=7.91},
  [9] = {name="ATM", id=277, x=-2959.0, y=487.82, z=15.46},
  [10] = {name="ATM", id=277, x=-2956.83, y=487.65, z=15.46},
  [11] = {name="ATM", id=277, x=-3241.09, y=997.53, z=12.55},
  [12] = {name="ATM", id=277, x=-3240.67, y=1008.62, z=12.83},
  [13] = {name="ATM", id=277, x=-386.82, y=6046.15, z=31.5},
  [14] = {name="ATM", id=277, x=-95.55, y=6457.09, z=31.46},
  [15] = {name="ATM", id=277, x=-97.25, y=6455.38, z=31.47},
  [16] = {name="ATM", id=277, x=155.86, y=6642.8, z=31.6},
  [17] = {name="ATM", id=277, x=1701.35, y=6426.52, z=32.76},
  [18] = {name="ATM", id=277, x=1735.22, y=6410.53, z=35.04},
  [19] = {name="ATM", id=277, x=1702.93, y=4933.59, z=42.06},
  [20] = {name="ATM", id=277, x=1968.04, y=3743.55, z=32.34},
  [21] = {name="ATM", id=277, x=540.37, y=2671.11, z=42.16},
  [22] = {name="ATM", id=277, x=-256.13, y=-716.02, z=33.52},
  [23] = {name="ATM", id=277, x=-258.78, y=-723.41, z=33.47},
  [24] = {name="ATM", id=277, x=-537.9, y=-854.42, z=29.28},
  [25] = {name="ATM", id=277, x=-301.74, y=-830.0, z=32.42},
  [26] = {name="ATM", id=277, x=-303.34, y=-829.81, z=32.42},
  [27] = {name="ATM", id=277, x=147.62, y=-1035.75, z=29.34},
  [28] = {name="ATM", id=277, x=145.99, y=-1035.19, z=29.34},
  [29] = {name="ATM", id=277, x=-30.31, y=-723.68, z=44.23},
  [30] = {name="ATM", id=277, x=-28.0, y=-724.6, z=44.23},
  [31] = {name="ATM", id=277, x=-254.31, y=-692.44, z=33.61},
  [32] = {name="ATM", id=277, x=33.21, y=-1348.25, z=29.49},
  [33] = {name="ATM", id=277, x=24.29, y=-946.13, z=29.35},
  [34] = {name="ATM", id=277, x=-2975.10, y=380.18, z=14.99},
  [35] = {name="ATM", id=277, x=129.63, y=-1291.95, z=29.26},
  [36] = {name="ATM", id=277, x=114.45, y=-776.40, z=31.41},
  [37] = {name="ATM", id=277, x=111.22, y=-775.24, z=31.4},
  [38] = {name="ATM", id=277, x=296.40, y=-894.04, z=29.22},
  [39] = {name="ATM", id=277, x=295.78, y=-896.06, z=29.21},
  [40] = {name="ATM", id=277, x=-526.61, y=-1222.87, z=18.45},
  [41] = {name="ATM", id=277, x=-2072.36, y=-317.22, z=13.31},
  [42] = {name="ATM", id=277, x=-203.78, y=-861.38, z=30.26},
  [43] = {name="ATM", id=277, x=161.23, y=-1278.19, z=14.19},
}

ATMObjects = {
  "prop_atm_01",
  "prop_atm_02",
  "prop_atm_03",
  "prop_fleeca_atm",
}

-- Banks
local banks = {
  [1] = {name="Bank", Closed = false, id=108, x = 314.187,   y = -278.621,  z = 54.170},
  [2] = {name="Bank", Closed = false, id=108, x = 150.266,   y = -1040.203, z = 29.374},
  [3] = {name="Bank", Closed = false,  id=108, x = -351.534,  y = -49.529,   z = 49.042},
  [4] = {name="Bank", Closed = false, id=108, x = -1212.980, y = -330.841,  z = 37.787},
  [5] = {name="Bank", Closed = false, id=108, x = -2962.582, y = 482.627,   z = 15.703},
  [6] = {name="Bank", Closed = false, id=108, x = -112.202,  y = 6469.295,  z = 31.626},
  [7] = {name="Bank", Closed = false, id=108, x = 237.413,   y = 217.766,   z = 106.286},
  [8] = {name="Bank", Closed = false, id=108, x = 1175.23, y = 2706.35, z = 38.09},
  
}

RegisterNetEvent('qb-banking:client:SetBankClosed')
AddEventHandler('qb-banking:client:SetBankClosed', function(BankId, bool)
  banks[BankId].Closed = bool
end)

-- Display Map Blips
Citizen.CreateThread(function()
  Wait(2000)
  if (displayBankBlips == true) then
    for _, item in pairs(banks) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, item.id)
        SetBlipColour(item.blip, 0)
        SetBlipScale(item.blip, 0.5)
        SetBlipAsShortRange(item.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)
    end
  end

  if (displayAtmBlips == true) then
    for _, item in pairs(atms) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipScale(item.blip, 0.65)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
  end
end)

-- NUI Variables
local atBank = false
local atATM = false
local bankOpen = false
local atmOpen = false

-- Open Gui and Focus NUI
function openGui()
  local ped = GetPlayerPed(-1)
  local playerPed = GetPlayerPed(-1)
  local PlayerData = QBCore.Functions.GetPlayerData()
  TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_ATM", 0, true)
  QBCore.Functions.Progressbar("use_bank", "Kaart insteken..", 2500, false, true, {}, {}, {}, {}, function() -- Done
      ClearPedTasksImmediately(ped)
      SetNuiFocus(true, true)
      SendNUIMessage({
        openBank = true,
        PlayerData = PlayerData
      })
  end, function() -- Cancel
      ClearPedTasksImmediately(ped)
      QBCore.Functions.Notify("Geannuleerd..", "error")
  end)
end

-- Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false, false)
  SendNUIMessage({openBank = false})
  bankOpen = false
  atmOpen = false
end

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)

        inRange = false

        local pos = GetEntityCoords(GetPlayerPed(-1))
        local nearbank, bankkey = IsNearBank()
        local nearatm, atmkey = IsNearATM()

        if nearbank then
          atBank = true
          inRange = true
          if not banks[bankkey].Closed then
            DrawMarker(2, banks[bankkey].x, banks[bankkey].y, banks[bankkey].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 125, 195, 37, 255, 0, 0, 0, 1, 0, 0, 0)
            DrawText3Ds(banks[bankkey].x, banks[bankkey].y, banks[bankkey].z + 0.3, '~g~E~w~ - Pas insteken')
            if IsControlJustPressed(1, Keys["E"])  then
                if (not IsInVehicle()) then
                    if bankOpen then
                        closeGui()
                        bankOpen = false
                    else
                        openGui()
                        bankOpen = true
                    end
                end
            end
          else
            DrawText3Ds(banks[bankkey].x, banks[bankkey].y, banks[bankkey].z + 0.3, 'Deze bank is momenteel gesloten.')
            DrawMarker(2, banks[bankkey].x, banks[bankkey].y, banks[bankkey].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.1, 125, 195, 37, 255, 0, 0, 0, 1, 0, 0)
          end
        elseif nearatm then
          atBank = true
          inRange = true
          DrawText3Ds(pos.x, pos.y, pos.z, '~g~E~w~ - Pas insteken')
          if IsControlJustPressed(1, Keys["E"])  then
              if (not IsInVehicle()) then
                  if bankOpen then
                      closeGui()
                      bankOpen = false
                  else
                      openGui()
                      bankOpen = true
                  end
              end
          end
        end

        if not inRange then
          Citizen.Wait(1500)
        end
    end
end)

-- Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if bankOpen or atmOpen then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisableControlAction(0, 24, active) -- Attack
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
    end
    Citizen.Wait(0)
  end
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('balance', function(data, cb)
  SendNUIMessage({openSection = "balance"})
  cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
  SendNUIMessage({openSection = "withdraw"})
  cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
  local nearatm, atmkey = IsNearATM()
  if not nearatm then
    SendNUIMessage({openSection = "deposit"})
    cb('ok')
  else
    QBCore.Functions.Notify('Je kan niet storten bij een pinautomaat!', 'error')
  end
end)

RegisterNUICallback('withdrawSubmit', function(data, cb)
  TriggerServerEvent('bank:withdraw', data.amount)
  SetTimeout(500, function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    SendNUIMessage({
      updateBalance = true,
      PlayerData = PlayerData
    })
  end)
  cb('ok')
end)

RegisterNUICallback('depositSubmit', function(data, cb)
  TriggerServerEvent('bank:deposit', data.amount)
  SetTimeout(500, function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    SendNUIMessage({
      updateBalance = true,
      PlayerData = PlayerData
    })
  end)
  cb('ok')
end)

RegisterNUICallback('transferSubmit', function(data, cb)
  local fromPlayer = GetPlayerServerId();
  TriggerEvent('bank:transfer', tonumber(fromPlayer), tonumber(data.toPlayer), tonumber(data.amount))
  cb('ok')
end)

-- Check if player is near an atm
function IsNearATM(key)
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply)
  for key, item in pairs(atms) do
    local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if(distance <= 0.75) then
      return true, key
    end
  end
end


-- Check if player is in a vehicle
function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-- Check if player is near a bank
function IsNearBank()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  for key, item in pairs(banks) do
    local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if(distance <= 2) then
      return true, key
    end
  end
end

-- Check if player is near another player
function IsNearPlayer(player)
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  local ply2 = GetPlayerPed(GetPlayerFromServerId(player))
  local ply2Coords = GetEntityCoords(ply2, 0)
  local distance = GetDistanceBetweenCoords(ply2Coords["x"], ply2Coords["y"], ply2Coords["z"],  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
  if(distance <= 5) then
    return true
  end
end

function GetClosestPlayer()
  local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
  local closestDistance = -1
  local closestPlayer = -1
  local coords = GetEntityCoords(GetPlayerPed(-1))

  for i=1, #closestPlayers, 1 do
      if closestPlayers[i] ~= PlayerId() then
          local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
          local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

          if closestDistance == -1 or closestDistance > distance then
              closestPlayer = closestPlayers[i]
              closestDistance = distance
          end
      end
end

return closestPlayer, closestDistance
end

RegisterNetEvent('banking:client:CheckDistance')
AddEventHandler('banking:client:CheckDistance', function(targetId, amount)
  local player, distance = GetClosestPlayer()
  if player ~= -1 and distance < 2.5 then
    local playerId = GetPlayerServerId(player)
    if targetId == playerId then
      TriggerServerEvent('banking:server:giveCash', playerId, amount)
    end
  else
    QBCore.Functions.Notify('Je bent niet in de buurt van de persoon!', 'error')
  end
end)