QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Geef bricks als missie wordt gestart
RegisterServerEvent("fortis-drugsdeuren:server:geefBricks")
AddEventHandler("fortis-drugsdeuren:server:geefBricks", function(missieBrickAmount)
    local Player = QBCore.Functions.GetPlayer(source)
    local missieBrickAmount = missieBrickAmount
    Player.Functions.AddItem("weed_brick", missieBrickAmount)
end)

-- Check hoeveel bricks de player heeft als hij het aflevert
QBCore.Functions.CreateCallback("fortis-drugsdeuren:server:requestBrickAantal", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName("weed_brick") ~= nil then
        local aantal = Player.Functions.GetItemByName("weed_brick").amount
        cb(aantal)
    else
        -- Persoon heeft geen weed bricks in zn inventory
        cb(0)
    end
end)

-- Afleveren
RegisterServerEvent("fortis-drugsdeuren:server:missieAfleveren")
AddEventHandler("fortis-drugsdeuren:server:missieAfleveren", function(aantal)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if Player.Functions.GetItemByName("weed_brick") ~= nil and Player.Functions.GetItemByName("weed_brick").amount >= aantal then
        Player.Functions.RemoveItem("weed_brick", aantal)
        local politie = GetCurrentCops()
        local prijs = 50
        if politie == 1 then
            prijs = math.random(250, 500)
        elseif politie == 2 then
            prijs = math.random(500, 600)
        elseif politie >= 3 then
            prijs = math.random(750,1000)
        end

        -- Betaal de speler
        Player.Functions.AddMoney("cash", (aantal * prijs), "drugs-aflevering")
    end
end)

-- Haal het aantal Politie agenten op
function GetCurrentCops()
    local politie = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                politie = politie + 1
            end
        end
    end
    return politie
end