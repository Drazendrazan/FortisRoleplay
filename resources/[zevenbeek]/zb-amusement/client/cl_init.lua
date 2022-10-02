QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


local hasActivePins = false
local currentLane = 0
local totalThrown = 0
local totalDowned = 0
local lastBall = 0
local lanes = Config.BowlingLanes
local inBowlingZone = false
local lastlane = 0

local function canUseLane(pLaneId)
    local shit = false

    QBCore.Functions.TriggerCallback('bp-bowling:getLaneAccess', function(response)
        if(response == true) then
            shit = true
        end
    end , pLaneId)
    Citizen.Wait(300)
    return shit
 
end

local function drawStatusHUD(state, pValues)
    local title = "Bowling - Lane #" .. currentLane
    local values = {}
  
    table.insert(values, "Throws: " .. totalThrown)
    table.insert(values, "Downed: " .. totalDowned)

    if (pValues) then
        for k, v in pairs(pValues) do
        table.insert(values, v)
        end
    end
    
    SendNUIMessage({show = state , t = title , v = values})
end


local function resetBowling()
    removePins()
    hasActivePins = false
    drawStatusHUD(false)
    hasActivePins = false
    currentLane = 0
    totalThrown = 0
    totalDowned = 0
    lastBall = 0
    inBowlingZone = false
    lastlane = 0
end

local function canUseBall()
    local pedPos = GetEntityCoords(PlayerPedId())
    if #(pedPos - lanes[lastlane].pos) < 3 then
        inBowlingZone = true
    else
        inBowlingZone = false
    end
    return (lastBall == 0 or lastBall + 6000 < GetGameTimer()) and (inBowlingZone)
end

Citizen.CreateThread(function()
    for k, v in pairs(lanes) do
        if (not v.enabled) then

        end
    end

    local data = {
        id = 'bowling_npc_vendor',
        position = {
            coords = vector3(756.39, -774.74, 25.34),
            heading = 102.85,
        },
        pedType = 4,
        model = "a_m_y_cyclist_01",
        networked = false,
        distance = 25.0,
        settings = {
            { mode = 'invincible', active = true },
            { mode = 'ignore', active = true },
            { mode = 'freeze', active = true },
        },
        flags = {
            isNPC = true,
        },
    }
    RequestModel(GetHashKey(data.model))
	while not HasModelLoaded(GetHashKey(data.model)) do
		Citizen.Wait( 1 )
	end
    created_ped = CreatePed(data.pedType, data.model , data.position.coords.x,data.position.coords.y,data. position.coords.z, data.position.heading, data.networked, false)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
    local BowlingPed = {
        GetHashKey("a_m_y_cyclist_01"),
    }
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local pedPos = GetEntityCoords(ped)
        if #(vector3(755.01, -774.94, 26.33) - pedPos) < 5 then
            DrawMarker(2, 755.01, -774.94, 26.33, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
            if #(vector3(755.01, -774.94, 26.33) - pedPos) < 1 then
                DrawText3Ds(755.01, -774.94, 26.33 + 0.3, '~g~[E]~w~ - Open Menu')
                if IsControlJustPressed(0, 38) then
                    TriggerEvent("bp-bowling:client:openMenu")
                end
            end
        elseif #(vector3(755.01, -774.94, 26.33) - pedPos) > 10 then
            resetBowling()
            Citizen.Wait(1500)
        end
    end
end)

RegisterNetEvent('bp-bowling:client:openMenu')
AddEventHandler('bp-bowling:client:openMenu' , function()
    local options = Config.BowlingVendor
    local data = {}
    local menuOptions = {}
    -- local uNwinDTestMenu = { }

    local uNwinDTestMenu = {
        {
            header = "🎳 - Bowling baan",
            isMenuHeader = true
        } 
    }
    for itemId, item in pairs(options) do
        uNwinDTestMenu[#uNwinDTestMenu+1] = {
            id = itemId,
            header = item.name,
            txt = "Prijs "..item.price.."$",
            params = {
                event = "bp-bowling:openMenu2",
                args = {
                    data = itemId,
                }
            }
        }
    end
    exports['zb-menu']:openMenu(uNwinDTestMenu)
end)


RegisterNetEvent('bp-bowling:openMenu2')
AddEventHandler('bp-bowling:openMenu2' , function(data)
    if(data.data == 'bowlingreceipt') then
        local lanesSorted = {}
        for k, v in ipairs(lanes) do
            if(lanes[k].enabled == false) then
                return
            end

            local uNwinDTestMenu2 = { }

            for k, v in ipairs(lanes) do
                uNwinDTestMenu2[#uNwinDTestMenu2+1] = {
                    id = k,
                    header = "Baan #"..k,
                    txt = "",
                    params = {
                        event = "bp-bowling:bowlingPurchase",
                        args = {
                            key = k
                        } 
                    }
                }
            end
            exports['zb-menu']:openMenu(uNwinDTestMenu2)
        end

    else
        TriggerEvent("bp-bowling:bowlingPurchase" , 'd')
    end
end)

local sheesh = false
function shit(k,v) 
    Citizen.CreateThread(function()
        while sheesh == true do
            Citizen.Wait(1)
            local pedPos = GetEntityCoords(PlayerPedId())
            if #(pedPos - v.pos) < 5 then
                DrawMarker(2, v.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                if #(pedPos - v.pos) < 1 then
                    DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], '~g~[E]~w~ - Start met bowlen!')
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent("bp-bowling:setupPins", k)
                        sheesh = false
                    end
                end
            end

        end
    end)
end

RegisterNetEvent('bp-bowling:bowlingPurchase')
AddEventHandler("bp-bowling:bowlingPurchase", function(data)
    local isLane = type(data.key) == "number"
    QBCore.Functions.TriggerCallback('bp-bowling:purchaseItem', function(response)
        if response == true then
            if(isLane == true) then
                for k, v in pairs(lanes) do
                    if(canUseLane(data.key) == true) then
                        sheesh = true
                        shit(data.key, lanes[data.key])
                        break
                    end
                end
                lanes[data.key].enabled = false
                lastlane = data.key
                QBCore.Functions.Notify("Je hebt toegang gekregen tot | Baan: "..data.key.."#")
            else
                QBCore.Functions.Notify("Je hebt een bowling bal gekocht!")
            end
            return
        end
    
    end , data.key , isLane)

   
end)

AddEventHandler('bp-bowling:setupPins', function(pParameters)
    local lane = pParameters
    if (not lanes[lane]) then return end
    if (hasActivePins) then return end
    hasActivePins = true
    currentLane = lane
    drawStatusHUD(true)
    createPins(lanes[lane].pins)
end)


local gameState = {}
gameState[1] = {
    onState = function()
        if (totalDowned >= 10) then
            QBCore.Functions.Notify("Strike!")

            drawStatusHUD(true, {"Strike!"})

            Citizen.Wait(1500)

            resetBowling()
            totalDowned = 0
            totalThrown = 0
        elseif (totalDowned < 10) then
            removeDownedPins()
            drawStatusHUD(true, {"Gooi opnieuw!"})
        end
    end
}
gameState[2] = {
    onState = function()
        if (totalDowned >= 10) then
            drawStatusHUD(true, {"Spare!"})
            QBCore.Functions.Notify("Spare!")


            Citizen.Wait(500)

            resetBowling()
        elseif (totalDowned < 10) then
            QBCore.Functions.Notify("Je gooide " .. totalDowned .. " pinnen om!")

            Citizen.Wait(1500)

            resetBowling()
        end

        totalDowned = 0
        totalThrown = 0
    end
}

RegisterNetEvent('bp-bowling:client:itemused')
AddEventHandler('bp-bowling:client:itemused' , function()
    if (IsPedInAnyVehicle(PlayerPedId(), true)) then return end
    -- Cooldown
    if not (canUseBall()) then return end
    startBowling(false, function(ballObject)
        lastBall = GetGameTimer()
        if (hasActivePins) then
            totalThrown = totalThrown + 1
            local isRolling = true
            local timeOut = false
            while (isRolling and not timeOut) do
                Citizen.Wait(100)
                local ballPos = GetEntityCoords(ballObject)
                if (lastBall == 0 or lastBall + 10000 < GetGameTimer()) then
                    timeOut = true
                end 
                if (ballPos.x < 730.0) then
                    -- Finish line baby
                    isRolling = false
                end
            end
            Citizen.Wait(5000)
            totalDowned = getPinsDownedCount()
            if (timeOut) then
                drawStatusHUD(true, {"Tijd is voorbij!!"})
                timeOut = false
            end
            if (gameState[totalThrown]) then
                gameState[totalThrown].onState()
            end
            removeBowlingBall()
        end
    end)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    drawStatusHUD(false)
end)


function DrawText3Ds(x, y, z, text)
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