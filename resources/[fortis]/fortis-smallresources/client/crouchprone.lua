local stage = 0
local movingForward = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        DisableControlAction(0, 36, true) 
        if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
            if IsDisabledControlJustPressed( 0, Keys["LEFTCTRL"]) then
                stage = stage + 1

                if stage == 1 then
                    -- Crouch stuff
                    ClearPedSecondaryTask(GetPlayerPed(-1))
                    RequestAnimSet("move_ped_crouched")
                    while not HasAnimSetLoaded("move_ped_crouched") do
                        Citizen.Wait(0)
                    end

                    SetPedMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)    
                    SetPedWeaponMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)
                    SetPedStrafeClipset(GetPlayerPed(-1), "move_ped_crouched_strafing",1.0)
                elseif stage > 1 then
                    stage = 0
                    ClearPedSecondaryTask(GetPlayerPed(-1))
                    ResetAnimSet()
                    SetPedStealthMovement(GetPlayerPed(-1),0,0)
                end
            end

            if stage == 1 then
                if GetEntitySpeed(GetPlayerPed(-1)) > 1.0 then
                    SetPedWeaponMovementClipset(GetPlayerPed(-1), "move_ped_crouched",1.0)
                    SetPedStrafeClipset(GetPlayerPed(-1), "move_ped_crouched_strafing",1.0)
                elseif GetEntitySpeed(GetPlayerPed(-1)) < 1.0 and (GetFollowPedCamViewMode() == 4 or GetFollowVehicleCamViewMode() == 4) then
                    ResetPedWeaponMovementClipset(GetPlayerPed(-1))
                    ResetPedStrafeClipset(GetPlayerPed(-1))
                end
            end
        else
            stage = 0
            Citizen.Wait(1000)
        end
    end
end)

local walkSet = "default"
RegisterNetEvent("crouchprone:client:SetWalkSet")
AddEventHandler("crouchprone:client:SetWalkSet", function(clipset)
    walkSet = clipset
end)


function ResetAnimSet()
    if walkSet == "default" then
        ResetPedMovementClipset(GetPlayerPed(-1))
        ResetPedWeaponMovementClipset(GetPlayerPed(-1))
        ResetPedStrafeClipset(GetPlayerPed(-1))
    else
        ResetPedMovementClipset(GetPlayerPed(-1))
        ResetPedWeaponMovementClipset(GetPlayerPed(-1))
        ResetPedStrafeClipset(GetPlayerPed(-1))
        Citizen.Wait(100)
        RequestWalking(walkSet)
        SetPedMovementClipset(PlayerPedId(), walkSet, 1)
        RemoveAnimSet(walkSet)
    end
end

function RequestWalking(set)
    RequestAnimSet(set)
    while not HasAnimSetLoaded(set) do
        Citizen.Wait(1)
    end 
end