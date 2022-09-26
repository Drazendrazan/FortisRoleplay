QBCore = nil

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(335.19, -915.78, 29.25)
    SetBlipSprite(blip, 521)
    SetBlipColour(blip, 0)
    SetBlipScale(blip, 0.7)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Arcade baan")
    EndTextCommandSetBlipName(blip)
end)

-------------------
-- Exports
-------------------
MenuAPI = exports.fortismenu
-------------------
-- variables for arcade and time left
-------------------
gotTicket = false

minutes = 0
seconds = 0
-------------------
function doesPlayerHaveTicket()
    return gotTicket
end

exports('doesPlayerHaveTicket', doesPlayerHaveTicket)

--count time
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if gotTicket then
            if hasPlayerRunOutOfTime() then
                QBCore.Functions.Notify("Je ticket is verlopen! Als je opnieuw wilt spelen moet je een nieuwe ticket kopen!", "error")
                gotTicket = false

                SendNUIMessage({
                    type = "off",
                    game = "",
                })
                SetNuiFocus(false, false)
            end

            countTime()
        end
    end
end)

--create npc, blip, marker
Citizen.CreateThread(function()
    for k, v in pairs(Config.Arcade) do
        local newPos = v.marker.markerPosition - vector3(0, 0, 0.4)
        local computerMarker = createMarker()

        computerMarker.setKeys({38})

        computerMarker.setRenderDistance(5)
        computerMarker.setPosition(newPos)

        computerMarker.render()

        computerMarker.setColor(v.marker.options.color)
        computerMarker.setScale(v.marker.options.scale)
        computerMarker.setType(v.marker.markerType)
 
        computerMarker.on('key', function()
            if gotTicket == false then
                playerBuyTicketMenu()
            else
                returnTicketMenu()
            end 
        end) 

        if v.blip and v.blip.enable then
            createBlip(v.blip.name, v.blip.blipId, v.blip.position, v.blip)
        end

        createLocalPed(4, v.NPC.model, v.NPC.position, v.NPC.heading, function(ped)
            SetEntityAsMissionEntity(ped)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
        end)
    end
end) 

--create markers for computers
Citizen.CreateThread(function()
    for k, v in pairs(Config.computerList) do
        local newPos = v.position - vector3(0, 0, 0.4)
        local computerMarker = createMarker()

        computerMarker.setKeys({38})

        computerMarker.setRenderDistance(5)
        computerMarker.setPosition(newPos)

        computerMarker.render()

        computerMarker.setColor(v.markerOptions.color)
        computerMarker.setScale(v.markerOptions.scale)
        computerMarker.setType(v.markerType)
 
        computerMarker.setRotation(v.markerOptions.rotate)
        computerMarker.on('key', function()
            openComputerMenu(v.computerType, v)
        end)
    end
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

