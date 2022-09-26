function showSubtitle(message, time)
    BeginTextCommandPrint('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandPrint(time, 1)
end

function playerBuyTicketMenu()
    local arcadeTickets = {
        {
            header = "🎫 - Arcade tickets",
            isMenuHeader = true
        } 
    }
    shouldContinue = true
    for _ , v in pairs(Config.ticketPrice) do
        local vname = v.name
        arcadeTickets[#arcadeTickets+1] = {
            header = vname.." ",
            txt = "",
            params = {
                event = "rcore_arcade:client:buyTicket",
                args = {
                    k = _
                }
            }
        }
    end

    if shouldContinue then
        arcadeTickets[#arcadeTickets+1] = {
            header = "⬅ Sluit Menu",
            txt = "",
            params = {
                event = "fortis-menu:client:closeMenu"
            }

        }
        exports['fortis-menu']:openMenu(arcadeTickets)
    end
end

function returnTicketMenu()
    minutes = 0
    seconds = 0
    gotTicket = false
    QBCore.Functions.Notify("Je hebt de ticket ingeleverd!", "success")
end

function showNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(0, 1)
end

function createBlip(name, blip, coords, options)
    local x, y, z = table.unpack(coords)
    local ourBlip = AddBlipForCoord(x, y, z)
    SetBlipSprite(ourBlip, blip)
    if options.type then SetBlipDisplay(ourBlip, options.type) end
    if options.scale then SetBlipScale(ourBlip, options.scale) end
    if options.color then SetBlipColour(ourBlip, options.color) end
    if options.shortRange then SetBlipAsShortRange(ourBlip, options.shortRange) end
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(ourBlip)
    return ourBlip
end

function createLocalPed(pedType, model, position, heading, cb)
    requestModel(model, function()
        local ped = CreatePed(pedType, model, position.x, position.y, position.z, heading, false, false)
        SetModelAsNoLongerNeeded(model)
        cb(ped)
    end)
end

function requestModel(modelName, cb)
    if type(modelName) ~= 'number' then
        modelName = GetHashKey(modelName)
    end

    local breaker = 0

    RequestModel(modelName)

    while not HasModelLoaded(modelName) do
        Citizen.Wait(1)
        breaker = breaker + 1
        if breaker >= 100 then
            break
        end
    end

    if breaker >= 100 then
        cb(false)
    else
        cb(true)
    end
end

function openComputerMenu(listGames, computer_)
    computer = computer_
    if not gotTicket and computer.isInGamingHouse then
        QBCore.Functions.Notify("Je hebt een ticket nodig om op deze machine te spelen!", "error")
        Citizen.Wait(100)
        return
    end

    local arcadeGames = {
        {
            header = "🕹️ - Arcade games",
            isMenuHeader = true
        } 
    }
    shouldContinue = true

    for _ , v in pairs(listGames) do
        local vname = v.name
        value = v
        arcadeGames[#arcadeGames+1] = {
            header = vname.." ",
            txt = "",
            params = { 
                event = "rcore_arcade:client:startGame",
                args = {
                    cid = v
                }
            } 
        }
    end

    if shouldContinue then
        arcadeGames[#arcadeGames+1] = {
            header = "⬅ Sluit Menu",
            txt = "",
            params = {
                event = "fortis-menu:client:closeMenu"
            }

        }
        exports['fortis-menu']:openMenu(arcadeGames)
    end

    -- local gameMenu = MenuAPI:CreateMenu("gamelist")

    -- gameMenu.SetMenuTitle(_U("computer_menu"))

    -- gameMenu.SetProperties({
    --     float = "right",
    --     position = "middle",
    -- })

    -- for key, value in pairs(listGames) do
    --     index = index + 1
        -- gameMenu.AddItem(index, value.name, function()
            -- SendNUIMessage({
            --     type = "on",
            --     game = value.link,
            --     gpu = computer.computerGPU,
            --     cpu = computer.computerCPU
            -- })
            -- SetNuiFocus(true, true)
    --         gameMenu.Close()
    --     end)
    -- end

    -- gameMenu.Open()
end

function hasPlayerRunOutOfTime()
    return (minutes == 0 and seconds <= 1)
end

function countTime()
    seconds = seconds - 1
    if seconds == 0 then
        seconds = 59
        minutes = minutes - 1
    end

    if minutes == -1 then
        minutes = 0
        seconds = 0
    end
end

AddEventHandler("rcore_arcade:client:buyTicket", function(k)
    TriggerServerEvent("rcore_arcade:server:buyTicket", k)
end)

AddEventHandler("rcore_arcade:client:startGame", function(cid)
    local GPU = computer.computerGPU
    local CPU = computer.computerCPU
    SendNUIMessage({
        type = "on",
        game = cid.cid.link,
        gpu = GPU,
        cpu = computer.computerCPU,
    })
    SetNuiFocus(true, true)
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