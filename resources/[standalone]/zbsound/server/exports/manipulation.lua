function Position(source, name_, pos)
    TriggerClientEvent("fortissound:stateSound", source, "position", {
        soundId = name_,
        position = pos,
    })
end

exports('Position', Position)

function Distance(source, name_, distance_)
    TriggerClientEvent("fortissound:stateSound", source, "distance", {
        soundId = name_,
        distance = distance_,
    })
end

exports('Distance', Distance)

function Destroy(source, name_)
    TriggerClientEvent("fortissound:stateSound", source, "destroy", {
        soundId = name_,
    })
end

exports('Destroy', Destroy)

function Pause(source, name_)
    TriggerClientEvent("fortissound:stateSound", source, "pause", {
        soundId = name_,
    })
end

exports('Pause', Pause)

function Resume(source, name_)
    TriggerClientEvent("fortissound:stateSound", source, "resume", {
        soundId = name_,
    })
end

exports('Resume', Resume)

function setVolume(source, name_, vol)
    TriggerClientEvent("fortissound:stateSound", source, "volume", {
        soundId = name_,
        volume = vol,
    })
end

exports('setVolume', setVolume)

function setTimeStamp(source, name_, time_)
    TriggerClientEvent("fortissound:stateSound", source, "timestamp", {
        soundId = name_,
        time = time_
    })
end

exports('setTimeStamp', setTimeStamp)

function destroyOnFinish(id, bool)
    TriggerClientEvent("fortissound:stateSound", source, "destroyOnFinish", {
        soundId = id,
        value = bool
    })
end

exports('destroyOnFinish', destroyOnFinish)