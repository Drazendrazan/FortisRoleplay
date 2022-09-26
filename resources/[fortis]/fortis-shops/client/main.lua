QBCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

-- code

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

Citizen.CreateThread(function()
    while true do
        local InRange = false
        local PlayerPed = GetPlayerPed(-1)
        local PlayerPos = GetEntityCoords(PlayerPed)

        for shop, _ in pairs(Config.Locations) do
            local position = Config.Locations[shop]["coords"]
            for _, loc in pairs(position) do
                local dist = GetDistanceBetweenCoords(PlayerPos, loc["x"], loc["y"], loc["z"])
                if dist < 10 then
                    InRange = true
                    DrawMarker(2, loc["x"], loc["y"], loc["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 28, 202, 155, 155, 0, 0, 0, 1, 0, 0, 0)
                    if dist < 0.8 then
                        DrawText3Ds(loc["x"], loc["y"], loc["z"] + 0.15, '~g~E~w~ - Winkel')
                        if IsControlJustPressed(0, Config.Keys["E"]) then
                            local ShopItems = {}
                            ShopItems.label = Config.Locations[shop]["label"]
                            ShopItems.items = Config.Locations[shop]["products"]
                            ShopItems.slots = 30
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
                        end
                    end
                end
            end
        end

        if not InRange then
            Citizen.Wait(5000)
        end
        Citizen.Wait(5)
    end
end)

RegisterNetEvent('qb-shops:client:UpdateShop')
AddEventHandler('qb-shops:client:UpdateShop', function(shop, itemData, amount)
    TriggerServerEvent('qb-shops:server:UpdateShopItems', shop, itemData, amount)
end)

RegisterNetEvent('qb-shops:client:SetShopItems')
AddEventHandler('qb-shops:client:SetShopItems', function(shop, shopProducts)
    Config.Locations[shop]["products"] = shopProducts
end)

RegisterNetEvent('qb-shops:client:RestockShopItems')
AddEventHandler('qb-shops:client:RestockShopItems', function(shop, amount)
    if Config.Locations[shop]["products"] ~= nil then 
        for k, v in pairs(Config.Locations[shop]["products"]) do 
            Config.Locations[shop]["products"][k].amount = Config.Locations[shop]["products"][k].amount + amount
        end
    end
end)

Citizen.CreateThread(function()
    for store,_ in pairs(Config.Locations) do
        StoreBlip = AddBlipForCoord(Config.Locations[store]["coords"][1]["x"], Config.Locations[store]["coords"][1]["y"], Config.Locations[store]["coords"][1]["z"])
        SetBlipColour(StoreBlip, 0)

        if Config.Locations[store]["products"] == Config.Products["normal"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.5)
        elseif Config.Locations[store]["products"] == Config.Products["coffeeplace"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.5)
        elseif Config.Locations[store]["products"] == Config.Products["gearshop"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.5)
        elseif Config.Locations[store]["products"] == Config.Products["hardware"] then
            SetBlipSprite(StoreBlip, 402)
            SetBlipScale(StoreBlip, 0.6)
        -- elseif Config.Locations[store]["products"] == Config.Products["weapons"] then
        --     SetBlipSprite(StoreBlip, 110)
        --     SetBlipScale(StoreBlip, 0.6)
        elseif Config.Locations[store]["products"] == Config.Products["leisureshop"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.5)
            SetBlipColour(StoreBlip, 3)           
        elseif Config.Locations[store]["products"] == Config.Products["mustapha"] then
            SetBlipSprite(StoreBlip, 225)
            SetBlipScale(StoreBlip, 0.5)
            SetBlipColour(StoreBlip, 3)              
        elseif Config.Locations[store]["products"] == Config.Products["coffeeshop"] then
            SetBlipSprite(StoreBlip, 140)
            SetBlipScale(StoreBlip, 0.55)
        elseif Config.Locations[store]["products"] == Config.Products["ifruit"] then
            SetBlipSprite(StoreBlip, 208)
            SetBlipScale(StoreBlip, 0.6)
        elseif Config.Locations[store]["products"] == Config.Products["drones"] then
            SetBlipSprite(StoreBlip, 589)
            SetBlipScale(StoreBlip, 0.7)
            SetBlipColour(StoreBlip, 32)  
        elseif Config.Locations[store]["products"] == Config.Products["pizzeria"] then
            SetBlipSprite(StoreBlip, 267)
            SetBlipScale(StoreBlip, 0.6)
            SetBlipColour(StoreBlip, 25)  
        elseif  Config.Locations[store]["products"] == Config.Products["cayoperico"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.6)
        elseif  Config.Locations[store]["products"] == Config.Products["servershop"] then
            SetBlipSprite(StoreBlip, 521)
            SetBlipScale(StoreBlip, 0.7)
            SetBlipColour(StoreBlip, 32) 
        elseif  Config.Locations[store]["products"] == Config.Products["giambone"] then
            SetBlipSprite(StoreBlip, 93)
            SetBlipScale(StoreBlip, 0.7)
            SetBlipColour(StoreBlip, 63) 
        end

        SetBlipDisplay(StoreBlip, 4)
        SetBlipAsShortRange(StoreBlip, true)
    

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations[store]["label"])
        EndTextCommandSetBlipName(StoreBlip)
    end

    local bioscoop = AddBlipForCoord(337.38, 178.27, 103.07)
    SetBlipSprite(bioscoop, 135)
    SetBlipColour(bioscoop, 0)
    SetBlipScale(bioscoop, 0.7)
    SetBlipAsShortRange(bioscoop, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Bioscoop")
    EndTextCommandSetBlipName(bioscoop)

    local veiling = AddBlipForCoord(-1091.26,-1270.09, 5.88)
    SetBlipSprite(veiling, 605)
    SetBlipColour(veiling, 0)
    SetBlipScale(veiling, 0.7)
    SetBlipAsShortRange(veiling, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Veiling")
    EndTextCommandSetBlipName(veiling)

end)