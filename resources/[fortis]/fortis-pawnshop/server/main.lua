QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local ItemList = {
    -- ["goldchain"] = math.random(100, 250),
    ["diamond_ring"] = math.random(750, 1000),
    -- ["rolex"] = math.random(300, 500),
	-- ["10kgoldchain"] = math.random(251, 400),
}

local MeltItems = {
    ["rolex"] = 15,
    ["goldchain"] = 25,
	["10kgoldchain"] = 20,
}

QBCore.Functions.CreateCallback('fortis-pawnshop:server:checksiraden', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.GetItemByName("rolex") ~= nil then
        local aantal = Player.Functions.GetItemByName("rolex").amount
        if aantal >= 10 then
            Player.Functions.RemoveItem("rolex", 10)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["rolex"], "remove")
            cb(true)
            return
        end
    end

    if Player.Functions.GetItemByName("goldchain") ~= nil then
        local aantal = Player.Functions.GetItemByName("goldchain").amount
        if aantal >= 10 then
            Player.Functions.RemoveItem("goldchain", 10)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["goldchain"], "remove")
            cb(true)
            return
        end
    end
    
    if Player.Functions.GetItemByName("10kgoldchain") ~= nil then
        local aantal = Player.Functions.GetItemByName("10kgoldchain").amount
        if aantal >= 10 then
            Player.Functions.RemoveItem("10kgoldchain", 10)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["10kgoldchain"], "remove")
            cb(true)
            return
        end
    end

    cb(false)
end)

RegisterServerEvent("fortis-pawnshop:sever:geefgoud")
AddEventHandler("fortis-pawnshop:sever:geefgoud", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem("goldbar", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["goldbar"], "add")
end)

RegisterServerEvent("qb-pawnshop:server:sellPawnItems")
AddEventHandler("qb-pawnshop:server:sellPawnItems", function()
    local src = source
    local price = 0
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-pawn-items")
        TriggerClientEvent('QBCore:Notify', src, "Je hebt je spullen verkocht!")
    end
end)

RegisterServerEvent("qb-pawnshop:server:sellGold")
AddEventHandler("qb-pawnshop:server:sellGold", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local price = 0
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if Player.PlayerData.items[k].name == "goldbar" then 
                    price = price + (math.random(2000, 5000) * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-gold")
        TriggerClientEvent('QBCore:Notify', src, "Je hebt je spullen verkocht!")
    end
end)

QBCore.Functions.CreateCallback('qb-pawnshop:server:getSellPrice', function(source, cb)
    local retval = 0
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    retval = retval + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                end
            end
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback('qb-pawnshop:server:hasGold', function(source, cb)
	local retval = false
    local Player = QBCore.Functions.GetPlayer(source)
    local gold = Player.Functions.GetItemByName('goldbar')
    if gold ~= nil and gold.amount > 0 then
        retval = true
    end
    cb(retval)
end)