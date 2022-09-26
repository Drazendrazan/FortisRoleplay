-- Animation Variables
local loadedAnims = false
local noclip_ANIM_A = "amb@world_human_stand_impatient@male@no_sign@base"
local noclip_ANIM_B = "base"

-- Noclip Variables
local travelSpeed = 4
local curLocation
local curRotation
local curHeading
local target

function drawNotification(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function LoadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function getTableLength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function getEntity(player)
    local result, entity = GetEntityPlayerIsFreeAimingAt(player)
    return entity
end

function bulletCoords()
local result, coord = GetPedLastWeaponImpactCoord(GetPlayerPed(-1))
return coord
end

function getGroundZ(x, y, z)
        local result, groundZ = GetGroundZFor_3dCoord(x + 0.0, y + 0.0, z + 0.0, Citizen.ReturnResultAnyway())
        return groundZ
end

function toggleNoClipMode()
    if(in_noclip_mode)then
        turnNoClipOff()
    else
        turnNoClipOn()
    end
end

function turnNoClipOff()
    local playerPed = PlayerPedId()
    local myPed = GetPlayerPed(-1)
    local voertuig = nil

    if IsPedInAnyVehicle(playerPed) then
        voertuig = GetVehiclePedIsIn(playerPed)
        SetEntityVisible(voertuig, true, 0)
    end

    
    SetEntityVisible(playerPed, true)
    ResetEntityAlpha(playerPed)
    QBCore.Functions.Notify("Noclip uitgeschakeld!", "error")
    -- ClearPedTasksImmediately(myPed)
	-- ClearPedTasksImmediately( playerPed )

    SetUserRadioControlEnabled( true )
    SetPlayerInvincible( PlayerId(), false )
    SetEntityInvincible( target, false )

    in_noclip_mode = false

end

RegisterNetEvent('qb-admin:client:toggleNoclip')
AddEventHandler('qb-admin:client:toggleNoclip', function()
    toggleNoClipMode()
end)

function turnNoClipOn()
    blockinput = true -- Prevent Trainer access while in noclip mode.
    local playerPed = PlayerPedId()
    local myPed = GetPlayerPed(-1)
    local voertuig = nil

    SetEntityVisible(playerPed, false)
    SetPlayerInvincible(playerPed, true)
    QBCore.Functions.Notify("Noclip ingeschakeld!", "success")

    if IsPedInAnyVehicle(playerPed) then
        voertuig = GetVehiclePedIsIn(playerPed)
        SetEntityVisible(voertuig, false, 0)
    end

    local x, y, z = table.unpack( GetEntityCoords( playerPed, false ) )
    curLocation = { x = x, y = y, z = z }
    curRotation = GetEntityRotation( playerPed, false )
    curHeading = GetEntityHeading( playerPed )

    in_noclip_mode = true
    SetEntityAlpha(playerPed, 150)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if in_noclip_mode then
            SetEntityLocallyVisible(GetPlayerPed(-1))
        else
            Citizen.Wait(500)
        end
    end
end)

function degToRad( degs )
    return degs * 3.141592653589793 / 180
end

Citizen.CreateThread( function()
    local rotationSpeed = 2.5
    local forwardPush = 1.8

    local speeds = { 0.05, 0.2, 0.8, 1.8, 3.6, 5.4, 15.0 }

    local moveUpKey = 44      -- Q
    local moveDownKey = 46    -- E
    local moveForwardKey = 32 -- W
    local moveBackKey = 33    -- S
    local rotateLeftKey = 34  -- A
    local rotateRightKey = 35 -- D
    local changeSpeedKey = 21 -- LSHIFT

    function updateForwardPush()
        forwardPush = speeds[ travelSpeed ]

    end

    -- Updates the players position
    function handleMovement(xVect,yVect)
        if ( IsControlJustPressed( 1, changeSpeedKey ) or IsDisabledControlJustPressed( 1, changeSpeedKey ) ) then
            travelSpeed = travelSpeed + 1

            if ( travelSpeed > getTableLength(speeds) ) then
                travelSpeed = 1
            end

            QBCore.Functions.Notify("Snelheid aangepast: ".. speeds[travelSpeed])

            updateForwardPush();
        end

        if ( IsControlPressed( 1, moveUpKey ) or IsDisabledControlPressed( 1, moveUpKey ) ) then
            curLocation.z = curLocation.z + forwardPush / 2
        elseif ( IsControlPressed( 1, moveDownKey ) or IsDisabledControlPressed( 1, moveDownKey ) ) then
            curLocation.z = curLocation.z - forwardPush / 2
        end

        if ( IsControlPressed( 1, moveForwardKey ) or IsDisabledControlPressed( 1, moveForwardKey ) ) then
            curLocation.x = curLocation.x + xVect
            curLocation.y = curLocation.y + yVect
        elseif ( IsControlPressed( 1, moveBackKey ) or IsDisabledControlPressed( 1, moveBackKey ) ) then
            curLocation.x = curLocation.x - xVect
            curLocation.y = curLocation.y - yVect
        end

        if ( IsControlPressed( 1, rotateLeftKey ) or IsDisabledControlPressed( 1, rotateLeftKey ) ) then
            curHeading = curHeading + rotationSpeed
        elseif ( IsControlPressed( 1, rotateRightKey ) or IsDisabledControlPressed( 1, rotateRightKey ) ) then
            curHeading = curHeading - rotationSpeed
        end
    end

     while true do
        Citizen.Wait( 3 )

        if ( in_noclip_mode ) then
            local playerPed = PlayerPedId()

            if ( IsEntityDead( playerPed ) ) then
                turnNoClipOff()

                -- Ensure we get out of noclip mode
                Citizen.Wait( 100 )
            else
                target = playerPed

                -- Handle Noclip Movement.
                local inVehicle = IsPedInAnyVehicle( playerPed, true )

                if ( inVehicle ) then
                    target = GetVehiclePedIsUsing( playerPed )
                end

                SetEntityVelocity( playerPed, 0.0, 0.0, 0.0 )
                SetEntityRotation( playerPed, 0, 0, 0, 0, false )

                -- Prevent Conflicts/Damage
                SetUserRadioControlEnabled( false )
                SetPlayerInvincible( PlayerId(), true )
                SetEntityInvincible( target, true )

                -- Play animation on foot.

                local xVect = forwardPush * math.sin( degToRad( curHeading ) ) * -1.0
                local yVect = forwardPush * math.cos( degToRad( curHeading ) )

                handleMovement( xVect, yVect )

                -- Update player postion.
                SetEntityCoordsNoOffset( target, curLocation.x, curLocation.y, curLocation.z, true, true, true )
                SetEntityHeading( target, curHeading - rotationSpeed )
            end
        end
     end
end )
