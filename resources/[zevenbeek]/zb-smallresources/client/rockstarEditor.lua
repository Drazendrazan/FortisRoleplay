local actief = false

RegisterNetEvent("zb-smallresources:rockstarEditor")
AddEventHandler("zb-smallresources:rockstarEditor", function(status)
    if status == "aan" then
        if actief then
            QBCore.Functions.Notify("Rockstar editor opname staat al aan!", "error")
        else
            StartRecording(1)
            QBCore.Functions.Notify("Je hebt de opname gestart", "success")
            actief = true
        end
    elseif status == "uit" then
        if not actief then
            QBCore.Functions.Notify("Rockstar editor opname staat al uit, zet het eerst aan!", "error")
        else
            StopRecordingAndSaveClip()
            QBCore.Functions.Notify("Je hebt de opname gestopt en opgeslagen", "success")
            actief = false
        end
    end
end)