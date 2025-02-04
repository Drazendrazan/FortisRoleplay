QBCore = nil

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(1)
	end
end)

-- Code

local PlayerJob = {}
local twitterGeluid = true

local heeftBereik = true
local eilandLocatie = {x = 5017.99, y = -5120.99, z = 5.23}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        letsleep = true
		local pedCoords = GetEntityCoords(GetPlayerPed(-1))

        if GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, eilandLocatie.x, eilandLocatie.y, eilandLocatie.z) < 1800 then
            heeftBereik = false
        elseif GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, eilandLocatie.x, eilandLocatie.y, eilandLocatie.z) > 1800 then
            heeftBereik = true
		end

        if letsleep then
            Wait(3000)
        end
	end
end)


phoneProp = 0
local phoneModel = `prop_npc_phone_02`

PhoneData = {
    MetaData = {},
    isOpen = false,
    PlayerData = nil,
    Contacts = {},
    Tweets = {},
    MentionedTweets = {},
    Hashtags = {},
    Chats = {},
    Invoices = {},
    CallData = {},
    RecentCalls = {},
    Garage = {},
    Mails = {},
    Adverts = {},
    GarageVehicles = {},
    AnimationData = {
        lib = nil,
        anim = nil,
    },
    SuggestedContacts = {},
    CryptoTransactions = {},
}

RegisterNetEvent('qb-phone_new:client:RaceNotify')
AddEventHandler('qb-phone_new:client:RaceNotify', function(message)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Racing",
                text = message,
                icon = "fas fa-flag-checkered",
                color = "#353b48",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Racing", 
                content = message, 
                icon = "fas fa-flag-checkered", 
                timeout = 3500, 
                color = "#353b48",
            },
        })
    end
end)

RegisterNetEvent('qb-phone_new:client:AddRecentCall')
AddEventHandler('qb-phone_new:client:AddRecentCall', function(data, time, type)
    table.insert(PhoneData.RecentCalls, {
        name = IsNumberInContacts(data.number),
        time = time,
        type = type,
        number = data.number,
        anonymous = data.anonymous
    })
    TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "phone")
    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    SendNUIMessage({ 
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    SendNUIMessage({
        action = "UpdateApplications",
        JobData = JobInfo,
        applications = Config.PhoneApplications
    })

    PlayerJob = JobInfo
end)

RegisterNUICallback('ClearRecentAlerts', function(data, cb)
    TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "phone", 0)
    Config.PhoneApplications["phone"].Alerts = 0
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('SetBackground', function(data)
    local background = data.background

    PhoneData.MetaData.background = background
    TriggerServerEvent('qb-phone_new:server:SaveMetaData', PhoneData.MetaData)
end)

RegisterNUICallback('GetMissedCalls', function(data, cb)
    cb(PhoneData.RecentCalls)
end)

RegisterNUICallback('GetSuggestedContacts', function(data, cb)
    cb(PhoneData.SuggestedContacts)
end)

function IsNumberInContacts(num)
    local retval = num
    for _, v in pairs(PhoneData.Contacts) do
        if num == v.number then
            retval = v.name
        end
    end
    return retval
end

local isLoggedIn = false

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, Config.OpenPhone) then
            if not PhoneData.isOpen then
                local IsHandcuffed = exports['police']:IsHandcuffed()
                if not IsHandcuffed then
                    OpenPhone()
                else
                    QBCore.Functions.Notify("Je kan momenteel niet je telefoon openen!", "error")
                end
            end
        end
        Citizen.Wait(3)
    end
end)

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

Citizen.CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = "UpdateTime",
                InGameTime = CalculateTimeToDisplay(),
            })
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        if isLoggedIn then
            QBCore.Functions.TriggerCallback('qb-phone_new:server:GetPhoneDataContactenZebie', function(contactenData)   
                -- if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then 
                --     PhoneData.Contacts = pData.PlayerContacts
                -- end
                if contactenData ~= nil then
                    PhoneData.Contacts = contactenData
                end

                SendNUIMessage({
                    action = "RefreshContacts",
                    Contacts = PhoneData.Contacts
                })
            end)
        end
    end
end)

function LoadPhone()
    Citizen.Wait(100)
    isLoggedIn = true
    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetPhoneData', function(pData)
        PlayerJob = QBCore.Functions.GetPlayerData().job
        PhoneData.PlayerData = QBCore.Functions.GetPlayerData()
        local PhoneMeta = PhoneData.PlayerData.metadata["phone"]
        PhoneData.MetaData = PhoneMeta

        if PhoneData.PlayerData.metadata["twittergeluid"] then
            twitterGeluid = true
            SendNUIMessage({
                type = "setTwitter",
                status = true
            })
        else
            twitterGeluid = false
        end

        if pData.InstalledApps ~= nil and next(pData.InstalledApps) ~= nil then
            for k, v in pairs(pData.InstalledApps) do
                local AppData = Config.StoreApps[v.app]
                Config.PhoneApplications[v.app] = {
                    app = v.app,
                    color = AppData.color,
                    icon = AppData.icon,
                    tooltipText = AppData.title,
                    tooltipPos = "right",
                    job = AppData.job,
                    blockedjobs = AppData.blockedjobs,
                    slot = AppData.slot,
                    Alerts = 0,
                }
            end
        end

        if PhoneMeta.profilepicture == nil then
            PhoneData.MetaData.profilepicture = "default"
        else
            PhoneData.MetaData.profilepicture = PhoneMeta.profilepicture
        end

        if pData.Applications ~= nil and next(pData.Applications) ~= nil then
            for k, v in pairs(pData.Applications) do 
                Config.PhoneApplications[k].Alerts = v 
            end
        end

        if pData.MentionedTweets ~= nil and next(pData.MentionedTweets) ~= nil then 
            PhoneData.MentionedTweets = pData.MentionedTweets 
        end

        if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then 
            PhoneData.Contacts = pData.PlayerContacts
        end

        if pData.Chats ~= nil and next(pData.Chats) ~= nil then
            local Chats = {}
            for k, v in pairs(pData.Chats) do
                Chats[v.number] = {
                    name = IsNumberInContacts(v.number),
                    number = v.number,
                    messages = json.decode(v.messages)
                }
            end

            PhoneData.Chats = Chats
        end

        if pData.Invoices ~= nil and next(pData.Invoices) ~= nil then
            for _, invoice in pairs(pData.Invoices) do
                invoice.name = IsNumberInContacts(invoice.number)
            end
            PhoneData.Invoices = pData.Invoices
        end

        if pData.Hashtags ~= nil and next(pData.Hashtags) ~= nil then
            PhoneData.Hashtags = pData.Hashtags
        end

        if pData.Tweets ~= nil and next(pData.Tweets) ~= nil then
            PhoneData.Tweets = pData.Tweets
        end

        if pData.Mails ~= nil and next(pData.Mails) ~= nil then
            PhoneData.Mails = pData.Mails
        end

        if pData.Adverts ~= nil and next(pData.Adverts) ~= nil then
            PhoneData.Adverts = pData.Adverts
        end

        if pData.CryptoTransactions ~= nil and next(pData.CryptoTransactions) ~= nil then
            PhoneData.CryptoTransactions = pData.CryptoTransactions
        end

        SendNUIMessage({ 
            action = "LoadPhoneData", 
            PhoneData = PhoneData, 
            PlayerData = PhoneData.PlayerData,
            PlayerJob = PhoneData.PlayerData.job,
            applications = Config.PhoneApplications 
        })
    end)
end

Citizen.CreateThread(function()
    Wait(500)
    LoadPhone()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    PhoneData = {
        MetaData = {},
        isOpen = false,
        PlayerData = nil,
        Contacts = {},
        Tweets = {},
        MentionedTweets = {},
        Hashtags = {},
        Chats = {},
        Invoices = {},
        CallData = {},
        RecentCalls = {},
        Garage = {},
        Mails = {},
        Adverts = {},
        GarageVehicles = {},
        AnimationData = {
            lib = nil,
            anim = nil,
        },
        SuggestedContacts = {},
        CryptoTransactions = {},
    }

    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    LoadPhone()
end)

RegisterNUICallback('HasPhone', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone_new:server:HasPhone', function(HasPhone)
        cb(HasPhone)
    end)
end)

RegisterNUICallback('setTwitterGeluid', function(data, cb)
    if data.twitterGeluid then
        twitterGeluid = true
        TriggerServerEvent("qb-phone_new:server:SetTwitterGeluid", true)

    else
        twitterGeluid = false
        TriggerServerEvent("qb-phone_new:server:SetTwitterGeluid", false)

    end
end)


function OpenPhone()
    QBCore.Functions.TriggerCallback('qb-phone_new:server:HasPhone', function(HasPhone)
        if HasPhone then
            PhoneData.PlayerData = QBCore.Functions.GetPlayerData()
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "open",
                Tweets = PhoneData.Tweets,
                AppData = Config.PhoneApplications,
                CallData = PhoneData.CallData,
                PlayerData = PhoneData.PlayerData,
                bereik = heeftBereik
            })
            PhoneData.isOpen = true

            Citizen.CreateThread(function()
                while PhoneData.isOpen do
                    DisableDisplayControlActions()
                    Citizen.Wait(1)
                end
            end)

            if not PhoneData.CallData.InCall then
                DoPhoneAnimation('cellphone_text_in')
            else
                DoPhoneAnimation('cellphone_call_to_text')
            end

            SetTimeout(250, function()
                newPhoneProp()
            end)
    
            QBCore.Functions.TriggerCallback('qb-phone_new:server:GetGarageVehicles', function(vehicles)
                PhoneData.GarageVehicles = vehicles
            end)
        else
            QBCore.Functions.Notify("Je hebt geen telefoon!", "error")
        end
    end)
end

RegisterNUICallback('SetupGarageVehicles', function(data, cb)
    cb(PhoneData.GarageVehicles)
end)

RegisterNUICallback('Close', function()
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SetTimeout(500, function()
        PhoneData.isOpen = false
    end)
end)

RegisterNUICallback('RemoveMail', function(data, cb)
    local MailId = data.mailId

    TriggerServerEvent('qb-phone_new:server:RemoveMail', MailId)
    cb('ok')
end)

RegisterNetEvent('qb-phone_new:client:UpdateMails')
AddEventHandler('qb-phone_new:client:UpdateMails', function(NewMails)
    SendNUIMessage({
        action = "UpdateMails",
        Mails = NewMails
    })
    PhoneData.Mails = NewMails
end)

RegisterNUICallback('AcceptMailButton', function(data)
    TriggerEvent(data.buttonEvent, data.buttonData)
    TriggerServerEvent('qb-phone_new:server:ClearButtonData', data.mailId)
end)

RegisterNUICallback('AddNewContact', function(data, cb)
    table.insert(PhoneData.Contacts, {
        name = data.ContactName,
        number = data.ContactNumber,
        iban = data.ContactIban
    })
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[data.ContactNumber] ~= nil and next(PhoneData.Chats[data.ContactNumber]) ~= nil then
        PhoneData.Chats[data.ContactNumber].name = data.ContactName
    end
    TriggerServerEvent('qb-phone_new:server:AddNewContact', data.ContactName, data.ContactNumber, data.ContactIban)
end)

RegisterNUICallback('GetMails', function(data, cb)
    cb(PhoneData.Mails)
end)

RegisterNUICallback('GetWhatsappChat', function(data, cb)
    if PhoneData.Chats[data.phone] ~= nil then
        cb(PhoneData.Chats[data.phone])
    else
        cb(false)
    end
end)

RegisterNUICallback('GetProfilePicture', function(data, cb)
    local number = data.number

    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetPicture', function(picture)
        cb(picture)
    end, number)
end)

RegisterNUICallback('GetBankContacts', function(data, cb)
    cb(PhoneData.Contacts)
end)

RegisterNUICallback('GetInvoices', function(data, cb)
    if PhoneData.Invoices ~= nil and next(PhoneData.Invoices) ~= nil then
        cb(PhoneData.Invoices)
    else
        cb(nil)
    end
end)

function GetKeyByDate(Number, Date)
    local retval = nil
    if PhoneData.Chats[Number] ~= nil then
        if PhoneData.Chats[Number].messages ~= nil then
            for key, chat in pairs(PhoneData.Chats[Number].messages) do
                if chat.date == Date then
                    retval = key
                    break
                end
            end
        end
    end
    return retval
end

function GetKeyByNumber(Number)
    local retval = nil
    if PhoneData.Chats then
        for k, v in pairs(PhoneData.Chats) do
            if v.number == Number then
                retval = k
            end
        end
    end
    return retval
end

function ReorganizeChats(key)
    local ReorganizedChats = {}
    ReorganizedChats[1] = PhoneData.Chats[key]
    for k, chat in pairs(PhoneData.Chats) do
        if k ~= key then
            table.insert(ReorganizedChats, chat)
        end
    end
    PhoneData.Chats = ReorganizedChats
end

local function findVehFromPlateAndLocate(plate)
    local gameVehicles = QBCore.Functions.GetVehicles()
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            if QBCore.Functions.GetPlate(vehicle) == plate then
                local vehCoords = GetEntityCoords(vehicle)
                SetNewWaypoint(vehCoords.x, vehCoords.y)
                return true
            end
        end
    end
end

RegisterNUICallback('SendMessage', function(data, cb)
    local ChatMessage = data.ChatMessage
    local ChatDate = data.ChatDate
    local ChatNumber = data.ChatNumber
    local ChatTime = data.ChatTime
    local ChatType = data.ChatType

    if string.find(ChatMessage:lower(), "<script") or string.find(ChatMessage:lower(), "<iframe") then
        TriggerServerEvent("zb-smallresources:server:banSpelerPerm")
    else

        local Ped = GetPlayerPed(-1)
        local Pos = GetEntityCoords(Ped)
        local NumberKey = GetKeyByNumber(ChatNumber)
        local ChatKey = GetKeyByDate(NumberKey, ChatDate)
        if PhoneData.Chats[NumberKey] ~= nil then
            if(PhoneData.Chats[NumberKey].messages == nil) then
                PhoneData.Chats[NumberKey].messages = {}
            end
            if PhoneData.Chats[NumberKey].messages[ChatKey] ~= nil then
                if ChatType == "message" then
                    table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                        message = ChatMessage,
                        time = ChatTime,
                        sender = PhoneData.PlayerData.citizenid,
                        type = ChatType,
                        data = {},
                    })
                elseif ChatType == "location" then
                    table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                        message = "Gedeelde Locatie",
                        time = ChatTime,
                        sender = PhoneData.PlayerData.citizenid,
                        type = ChatType,
                        data = {
                            x = Pos.x,
                            y = Pos.y,
                        },
                    })
                end
                TriggerServerEvent('qb-phone_new:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, false)
                NumberKey = GetKeyByNumber(ChatNumber)
                ReorganizeChats(NumberKey)
            else
                table.insert(PhoneData.Chats[NumberKey].messages, {
                    date = ChatDate,
                    messages = {},
                })
                ChatKey = GetKeyByDate(NumberKey, ChatDate)
                if ChatType == "message" then
                    table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                        message = ChatMessage,
                        time = ChatTime,
                        sender = PhoneData.PlayerData.citizenid,
                        type = ChatType,
                        data = {},
                    })
                elseif ChatType == "location" then
                    table.insert(PhoneData.Chats[NumberKey].messages[ChatDate].messages, {
                        message = "Gedeelde Locatie",
                        time = ChatTime,
                        sender = PhoneData.PlayerData.citizenid,
                        type = ChatType,
                        data = {
                            x = Pos.x,
                            y = Pos.y,
                        },
                    })
                end
                TriggerServerEvent('qb-phone_new:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
                NumberKey = GetKeyByNumber(ChatNumber)
                ReorganizeChats(NumberKey)
            end
        else
            table.insert(PhoneData.Chats, {
                name = IsNumberInContacts(ChatNumber),
                number = ChatNumber,
                messages = {},
            })
            NumberKey = GetKeyByNumber(ChatNumber)
            table.insert(PhoneData.Chats[NumberKey].messages, {
                date = ChatDate,
                messages = {},
            })
            ChatKey = GetKeyByDate(NumberKey, ChatDate)
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = "Gedeelde Locatie",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            end
            TriggerServerEvent('qb-phone_new:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber, true)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        end

        QBCore.Functions.TriggerCallback('qb-phone_new:server:GetContactPicture', function(Chat)
            SendNUIMessage({
                action = "UpdateChat",
                chatData = Chat,
                chatNumber = ChatNumber,
            })
        end,  PhoneData.Chats[GetKeyByNumber(ChatNumber)])
    end
end)

RegisterNUICallback('SharedLocation', function(data)
    local x = data.coords.x
    local y = data.coords.y

    SetNewWaypoint(x, y)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Whatsapp",
            text = "Locatie is ingesteld!",
            icon = "fab fa-whatsapp",
            color = "#25D366",
            timeout = 1500,
        },
    })
end)

RegisterNetEvent('qb-phone_new:client:UpdateMessages')
AddEventHandler('qb-phone_new:client:UpdateMessages', function(ChatMessages, SenderNumber, New)
    local Sender = IsNumberInContacts(SenderNumber)

    local NumberKey = GetKeyByNumber(SenderNumber)

    if New then
		local NumberKey = SenderNumber
        PhoneData.Chats[NumberKey] = {
            name = IsNumberInContacts(SenderNumber),
            number = SenderNumber,
            messages = ChatMessages
        }

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen and heeftBereik then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone and heeftBereik then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Nieuw bericht ontvangen van "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            elseif heeftBereik then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Je kan geen berichten naar jezelf versturen!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            ReorganizeChats(NumberKey)

            Wait(100)
            QBCore.Functions.TriggerCallback('qb-phone_new:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        elseif heeftBereik then
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "Whatsapp", 
                    content = "Je hebt een nieuw bericht ontvangen van "..IsNumberInContacts(SenderNumber).."!", 
                    icon = "fab fa-whatsapp", 
                    timeout = 3500, 
                    color = "#25D366",
                },
            })
            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "whatsapp")
        end
    else
        PhoneData.Chats[NumberKey].messages = ChatMessages

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen and heeftBereik then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone and heeftBereik then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Je hebt een nieuw bericht ontvangen van"..IsNumberInContacts(SenderNumber).."!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 1500,
                    },
                })
            elseif heeftBereik then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Whatsapp",
                        text = "Je kan geen berichten naar jezelf versturen!",
                        icon = "fab fa-whatsapp",
                        color = "#25D366",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)
            
            Wait(100)
            QBCore.Functions.TriggerCallback('qb-phone_new:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "Whatsapp", 
                    content = "Je hebt een nieuw bericht ontvangen van "..IsNumberInContacts(SenderNumber).."!", 
                    icon = "fab fa-whatsapp", 
                    timeout = 3500, 
                    color = "#25D366",
                },
            })

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Config.PhoneApplications['whatsapp'].Alerts = Config.PhoneApplications['whatsapp'].Alerts + 1
            TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "whatsapp")
        end
    end
end)

RegisterNetEvent("qb-phone-new:client:BankNotify")
AddEventHandler("qb-phone-new:client:BankNotify", function(text)
    SendNUIMessage({
        action = "Notification",
        NotifyData = {
            title = "Bank", 
            content = text, 
            icon = "fas fa-university", 
            timeout = 3500, 
            color = "#ff002f",
        },
    })
end)

RegisterNUICallback('track-vehicle', function(data, cb)
    local veh = data.veh
    if findVehFromPlateAndLocate(veh.plate) then
        QBCore.Functions.Notify("Je voertuig is gemarkeerd op de map!", "success")
    else
        QBCore.Functions.Notify("Dit voertuig kon niet gevonden worden!", "error")
    end
end)

RegisterNetEvent('qb-phone_new:client:NewMailNotify')
AddEventHandler('qb-phone_new:client:NewMailNotify', function(MailData)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Mail",
                text = "Je hebt een nieuwe mail ontvangen!",
                icon = "fas fa-envelope",
                color = "#ff002f",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Mail", 
                content = "Je hebt een nieuwe mail ontvangen!", 
                icon = "fas fa-envelope", 
                timeout = 3500, 
                color = "#ff002f",
            },
        })
    end
    Config.PhoneApplications['mail'].Alerts = Config.PhoneApplications['mail'].Alerts + 1
    TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "mail")
end)

RegisterNUICallback('PostAdvert', function(data)
    if string.find(data.message:lower(), "<script") or string.find(data.message, "<iframe") then
        TriggerServerEvent("zb-smallresources:server:banSpelerPerm")
    else
        TriggerServerEvent('qb-phone_new:server:AddAdvert', data.message)
    end
end)

RegisterNetEvent('qb-phone_new:client:UpdateAdverts')
AddEventHandler('qb-phone_new:client:UpdateAdverts', function(Adverts, LastAd)
    PhoneData.Adverts = Adverts

    if PhoneData.isOpen and heeftBereik then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Advertentie",
                text = "Er is een nieuwe advertentie geplaatst door "..LastAd,
                icon = "fas fa-ad",
                color = "#ff8f1a",
                timeout = 2500,
            },
        })
    elseif heeftBereik then
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Advertentie", 
                content = "Er is een nieuwe advertentie geplaatst door "..LastAd,
                icon = "fas fa-ad", 
                timeout = 2500, 
                color = "#ff8f1a",
            },
        })
    end

    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('LoadAdverts', function()
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('ClearAlerts', function(data, cb)
    local chat = data.number
    local ChatKey = GetKeyByNumber(chat)

    if PhoneData.Chats[ChatKey].Unread ~= nil then
        local newAlerts = (Config.PhoneApplications['whatsapp'].Alerts - PhoneData.Chats[ChatKey].Unread)
        Config.PhoneApplications['whatsapp'].Alerts = newAlerts
        TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "whatsapp", newAlerts)

        PhoneData.Chats[ChatKey].Unread = 0

        SendNUIMessage({
            action = "RefreshWhatsappAlerts",
            Chats = PhoneData.Chats,
        })
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end
end)

RegisterNUICallback('PayInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    QBCore.Functions.TriggerCallback('qb-phone_new:server:PayInvoice', function(CanPay, Invoices)
        if CanPay then PhoneData.Invoices = Invoices end
        cb(CanPay)
    end, sender, amount, invoiceId)
end)

RegisterNUICallback('DeclineInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    QBCore.Functions.TriggerCallback('qb-phone_new:server:DeclineInvoice', function(CanPay, Invoices)
        PhoneData.Invoices = Invoices
        cb('ok')
    end, sender, amount, invoiceId)
end)

RegisterNUICallback('EditContact', function(data, cb)
    local NewName = data.CurrentContactName
    local NewNumber = data.CurrentContactNumber
    local NewIban = data.CurrentContactIban
    local OldName = data.OldContactName
    local OldNumber = data.OldContactNumber
    local OldIban = data.OldContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == OldName and v.number == OldNumber then
            v.name = NewName
            v.number = NewNumber
            v.iban = NewIban
        end
    end
    if PhoneData.Chats[NewNumber] ~= nil and next(PhoneData.Chats[NewNumber]) ~= nil then
        PhoneData.Chats[NewNumber].name = NewName
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    TriggerServerEvent('qb-phone_new:server:EditContact', NewName, NewNumber, NewIban, OldName, OldNumber, OldIban)
end)

local function escape_str(s)
	-- local in_char  = {'\\', '"', '/', '\b', '\f', '\n', '\r', '\t'}
	-- local out_char = {'\\', '"', '/',  'b',  'f',  'n',  'r',  't'}
	-- for i, c in ipairs(in_char) do
	--   s = s:gsub(c, '\\' .. out_char[i])
	-- end
	return s
end

function GenerateTweetId()
    local tweetId = "TWEET-"..math.random(11111111, 99999999)
    return tweetId
end

RegisterNetEvent('qb-phone_new:client:UpdateHashtags')
AddEventHandler('qb-phone_new:client:UpdateHashtags', function(Handle, msgData)
    if PhoneData.Hashtags[Handle] ~= nil then
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    else
        PhoneData.Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    end

    SendNUIMessage({
        action = "UpdateHashtags",
        Hashtags = PhoneData.Hashtags,
    })
end)

RegisterNUICallback('GetHashtagMessages', function(data, cb)
    if PhoneData.Hashtags[data.hashtag] ~= nil and next(PhoneData.Hashtags[data.hashtag]) ~= nil then
        cb(PhoneData.Hashtags[data.hashtag])
    else
        cb(nil)
    end
end)

RegisterNUICallback('GetTweets', function(data, cb)
    cb(PhoneData.Tweets)
end)

RegisterNUICallback('UpdateProfilePicture', function(data)
    local pf = data.profilepicture

    PhoneData.MetaData.profilepicture = pf
    
    TriggerServerEvent('qb-phone_new:server:SaveMetaData', PhoneData.MetaData)
end)

local patt = "[?!@#]"

AddEventHandler("qb-phone_new:client:plaatsAnonTweet", function(date, message)
    local tweet = {
        firstName = "Anonieme",
        lastName = "Tweet",
        message = message,
        time = date,
        tweetId = GenerateTweetId(),
        picture = "https://img.icons8.com/ios-filled/100/000000/anonymous-mask.png"
    }

    if string.find(message:lower(), "<script") or string.find(message, "<iframe") then
        TriggerServerEvent("zb-smallresources:server:banSpelerPerm")
    else
        table.insert(PhoneData.Tweets, tweet)
        Citizen.Wait(100)
        TriggerServerEvent('qb-phone_new:server:UpdateTweets', PhoneData.Tweets, tweet)
        TriggerServerEvent("qb-phone:server:stuurTweetLog", "**[ANONIEME TWEET]**\n\n"..message)
    end
end)


RegisterNUICallback('PostNewTweet', function(data, cb)
    local TweetMessage = {
        firstName = PhoneData.PlayerData.charinfo.firstname,
        lastName = PhoneData.PlayerData.charinfo.lastname,
        message = escape_str(data.Message),
        time = data.Date,
        tweetId = GenerateTweetId(),
        picture = data.Picture
    }

    if string.find(data.Message:lower(), "<script") or string.find(data.Message, "<iframe" or string.find.data.Message:lower(), "</script>") then
        TriggerServerEvent("zb-smallresources:server:banSpelerPerm")
    else
    

        local TwitterMessage = data.Message
        local MentionTag = TwitterMessage:split("@")
        local Hashtag = TwitterMessage:split("#")

        TriggerServerEvent("qb-phone:server:stuurTweetLog", TwitterMessage)

        for i = 2, #Hashtag, 1 do
            local Handle = Hashtag[i]:split(" ")[1]
            if Handle ~= nil or Handle ~= "" then
                local InvalidSymbol = string.match(Handle, patt)
                if InvalidSymbol then
                    Handle = Handle:gsub("%"..InvalidSymbol, "")
                end
                TriggerServerEvent('qb-phone_new:server:UpdateHashtags', Handle, TweetMessage)
            end
        end

        for i = 2, #MentionTag, 1 do
            local Handle = MentionTag[i]:split(" ")[1]
            if Handle ~= nil or Handle ~= "" then
                local Fullname = Handle:split("_")
                local Firstname = Fullname[1]
                table.remove(Fullname, 1)
                local Lastname = table.concat(Fullname, " ")

                if (Firstname ~= nil and Firstname ~= "") and (Lastname ~= nil and Lastname ~= "") then
                    if Firstname ~= PhoneData.PlayerData.charinfo.firstname and Lastname ~= PhoneData.PlayerData.charinfo.lastname then
                        TriggerServerEvent('qb-phone_new:server:MentionedPlayer', Firstname, Lastname, TweetMessage)
                    else
                        SetTimeout(2500, function()
                            SendNUIMessage({
                                action = "PhoneNotification",
                                PhoneNotify = {
                                    title = "Twitter", 
                                    text = "Je kan jezelf niet vermelden!", 
                                    icon = "fab fa-twitter",
                                    color = "#1DA1F2",
                                },
                            })
                        end)
                    end
                end
            end
        end

        table.insert(PhoneData.Tweets, TweetMessage)
        Citizen.Wait(100)
        cb(PhoneData.Tweets)

        TriggerServerEvent('qb-phone_new:server:UpdateTweets', PhoneData.Tweets, TweetMessage)
    end
end)

RegisterNetEvent('qb-phone_new:client:TransferMoney')
AddEventHandler('qb-phone_new:client:TransferMoney', function(amount, newmoney)
    PhoneData.PlayerData.money.bank = newmoney
    if PhoneData.isOpen then
        SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "Bank", text = "&euro;"..amount.." is toegevoegd op je account!", icon = "fas fa-university", color = "#8c7ae6", }, })
        SendNUIMessage({ action = "UpdateBank", NewBalance = PhoneData.PlayerData.money.bank })
    else
        SendNUIMessage({ action = "Notification", NotifyData = { title = "Bank", content = "&euro;"..amount.." is toegevoegd op je account!", icon = "fas fa-university", timeout = 2500, color = nil, }, })
    end
end)


RegisterNetEvent('qb-phone_new:client:UpdateTweets')
AddEventHandler('qb-phone_new:client:UpdateTweets', function(src, Tweets, NewTweetData)
    PhoneData.Tweets = Tweets
    local MyPlayerId = PhoneData.PlayerData.source


    if src ~= MyPlayerId then
        if string.find(NewTweetData.message, "<img src") then
            NewTweetData.message = "Foto"
        end
        if not PhoneData.isOpen and heeftBereik then
            if twitterGeluid then
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "tweet", 0.2)
            end
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "Nieuwe tweet van (@"..NewTweetData.firstName.." "..NewTweetData.lastName..")", 
                    content = NewTweetData.message, 
                    icon = "fab fa-twitter", 
                    timeout = 3500, 
                    color = "#1DA1F2",
                },
            })
        elseif heeftBereik then
            SendNUIMessage({
                action = "PhoneNotification",
                PhoneNotify = {
                    title = "Nieuwe tweet van (@"..NewTweetData.firstName.." "..NewTweetData.lastName..")", 
                    text = NewTweetData.message, 
                    icon = "fab fa-twitter",
                    color = "#1DA1F2",
                },
            })
        end
    else
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Twitter", 
                text = "De tweet is succesvol geplaatst!", 
                icon = "fab fa-twitter",
                color = "#1DA1F2",
                timeout = 1000,
            },
        })
    end
end)

RegisterNUICallback('GetMentionedTweets', function(data, cb)
    cb(PhoneData.MentionedTweets)
end)

RegisterNUICallback('GetHashtags', function(data, cb)
    if PhoneData.Hashtags ~= nil and next(PhoneData.Hashtags) ~= nil then
        cb(PhoneData.Hashtags)
    else
        cb(nil)
    end
end)

RegisterNetEvent('qb-phone_new:client:GetMentioned')
AddEventHandler('qb-phone_new:client:GetMentioned', function(TweetMessage, AppAlerts)
    Config.PhoneApplications["twitter"].Alerts = AppAlerts
    if not PhoneData.isOpen and heeftBereik then
        SendNUIMessage({ action = "Notification", NotifyData = { title = "Je bent zojuist vermeld in een tweet!", content = TweetMessage.message, icon = "fab fa-twitter", timeout = 3500, color = nil, }, })
    elseif heeftBereik then
        SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "Je bent zojuist vermeld in een tweet!", text = TweetMessage.message, icon = "fab fa-twitter", color = "#1DA1F2", }, })
    end
    local TweetMessage = {firstName = TweetMessage.firstName, lastName = TweetMessage.lastName, message = escape_str(TweetMessage.message), time = TweetMessage.time, picture = TweetMessage.picture}
    table.insert(PhoneData.MentionedTweets, TweetMessage)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    SendNUIMessage({ action = "UpdateMentionedTweets", Tweets = PhoneData.MentionedTweets })
end)

RegisterNUICallback('ClearMentions', function()
    Config.PhoneApplications["twitter"].Alerts = 0
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
    TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "twitter", 0)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('ClearGeneralAlerts', function(data)
    SetTimeout(400, function()
        Config.PhoneApplications[data.app].Alerts = 0
        SendNUIMessage({
            action = "RefreshAppAlerts",
            AppData = Config.PhoneApplications
        })
        TriggerServerEvent('qb-phone:server:SetPhoneAlerts', data.app, 0)
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end)
end)

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end

RegisterNUICallback('TransferMoney', function(data, cb)
    data.amount = tonumber(data.amount)
    if tonumber(PhoneData.PlayerData.money.bank) >= data.amount then
        local amaountata = PhoneData.PlayerData.money.bank - data.amount
        TriggerServerEvent('qb-phone_new:server:TransferMoney', data.iban, data.amount)
        local cbdata = {
            CanTransfer = true,
            NewAmount = amaountata 
        }
        cb(cbdata)
    else
        local cbdata = {
            CanTransfer = false,
            NewAmount = nil,
        }
        cb(cbdata)
    end
end)

RegisterNUICallback('CanTransferMoney', function(data, cb)
    local amount = tonumber(data.amountOf)
    local iban = data.sendTo
    local PlayerData = QBCore.Functions.GetPlayerData()

    if (PlayerData.money.bank - amount) >= 0 then
        QBCore.Functions.TriggerCallback('qb-phone_new:server:CanTransferMoney', function(Transferd)
            if Transferd then
                cb({TransferedMoney = true, NewBalance = (PlayerData.money.bank - amount)})
            else
                cb({TransferedMoney = false})
            end
        end, amount, iban)
    else
        cb({TransferedMoney = false})
    end
end)

RegisterNUICallback('GetWhatsappChats', function(data, cb)
    cb(PhoneData.Chats)
end)

RegisterNUICallback('CallContact', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetCallState', function(CanCall, IsOnline)
        local status = { 
            CanCall = CanCall, 
            IsOnline = IsOnline,
            InCall = PhoneData.CallData.InCall,
        }
        cb(status)
        if CanCall and not status.InCall and (data.ContactData.number ~= PhoneData.PlayerData.charinfo.phone) then
            CallContact(data.ContactData, data.Anonymous)
        end
    end, data.ContactData)
end)

function GenerateCallId(caller, target)
    local CallId = math.ceil(((tonumber(caller) + tonumber(target)) / 100 * 1))
    return CallId
end

CallContact = function(CallData, AnonymousCall)
    local RepeatCount = 0
    PhoneData.CallData.CallType = "outgoing"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.CallId = GenerateCallId(PhoneData.PlayerData.charinfo.phone, CallData.number)

    TriggerServerEvent('qb-phone_new:server:CallContact', PhoneData.CallData.TargetData, PhoneData.CallData.CallId, AnonymousCall)
    TriggerServerEvent('qb-phone_new:server:SetCallState', true)
    
    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
                else
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                CancelCall()
                break
            end
        else
            break
        end
    end
end

CancelCall = function()
    TriggerServerEvent('qb-phone_new:server:CancelCall', PhoneData.CallData)
    if PhoneData.CallData.CallType == "ongoing" then
        exports["pma-voice"]:SetCallChannel(PhoneData.CallData.CallId)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}
    PhoneData.CallData.CallId = nil

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('qb-phone_new:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({ 
            action = "Notification", 
            NotifyData = { 
                title = "Telefoon",
                content = "Het gesprek is beeindigd!", 
                icon = "fas fa-phone", 
                timeout = 3500, 
                color = "#e84118",
            }, 
        })            
    else
        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Telefoon", 
                text = "Het gesprek is beeindigd!", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
    exports["pma-voice"]:SetCallChannel(0)
end

RegisterNetEvent('qb-phone_new:client:CancelCall')
AddEventHandler('qb-phone_new:client:CancelCall', function()
    if PhoneData.CallData.CallType == "ongoing" then
        SendNUIMessage({
            action = "CancelOngoingCall"
        })
        exports["pma-voice"]:SetCallChannel(0)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('qb-phone_new:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({ 
            action = "Notification", 
            NotifyData = { 
                title = "Telefoon",
                content = "Het gesprek is beeindigd!", 
                icon = "fas fa-phone", 
                timeout = 3500, 
                color = "#e84118",
            }, 
        })            
    else
        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Telefoon", 
                text = "Het gesprek is beeindigd!", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end)

RegisterNetEvent('qb-phone_new:client:GetCalled')
AddEventHandler('qb-phone_new:client:GetCalled', function(CallerNumber, CallId, AnonymousCall)
    if heeftBereik then
        local RepeatCount = 0
        local CallData = {
            number = CallerNumber,
            name = IsNumberInContacts(CallerNumber),
            anonymous = AnonymousCall
        }

        if AnonymousCall then
            CallData.name = "Anoniem"
        end

        PhoneData.CallData.CallType = "incoming"
        PhoneData.CallData.InCall = true
        PhoneData.CallData.AnsweredCall = false
        PhoneData.CallData.TargetData = CallData
        PhoneData.CallData.CallId = CallId

        TriggerServerEvent('qb-phone_new:server:SetCallState', true)

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        for i = 1, Config.CallRepeats + 1, 1 do
            if not PhoneData.CallData.AnsweredCall then
                if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                    if PhoneData.CallData.InCall then
                        QBCore.Functions.TriggerCallback('qb-phone_new:server:HasPhone', function(HasPhone)
                            if HasPhone and heeftBereik then
                                RepeatCount = RepeatCount + 1
                                TriggerServerEvent("InteractSound_SV:PlayOnSource", "ringing", 0.2)

                                if not PhoneData.isOpen and heeftBereik then
                                    SendNUIMessage({
                                        action = "IncomingCallAlert",
                                        CallData = PhoneData.CallData.TargetData,
                                        Canceled = false,
                                        AnonymousCall = AnonymousCall,
                                    })
                                end
                            end
                        end)
                    elseif heeftBereik then
                        SendNUIMessage({
                            action = "IncomingCallAlert",
                            CallData = PhoneData.CallData.TargetData,
                            Canceled = true,
                            AnonymousCall = AnonymousCall,
                        })
                        if not AnonymousCall then
                            TriggerServerEvent('qb-phone_new:server:AddRecentCall', "missed", CallData)
                        end
                        break
                    end
                    Citizen.Wait(Config.RepeatTimeout)
                elseif heeftBereik then
                    SendNUIMessage({
                        action = "IncomingCallAlert",
                        CallData = PhoneData.CallData.TargetData,
                        Canceled = true,
                        AnonymousCall = AnonymousCall,
                    })
                    if not AnonymousCall then
                        TriggerServerEvent('qb-phone_new:server:AddRecentCall', "missed", CallData)
                    end
                    break
                end
            else
                if not AnonymousCall then
                    TriggerServerEvent('qb-phone_new:server:AddRecentCall', "missed", CallData)
                end
                break
            end
        end
    end
end)

RegisterNUICallback('CancelOutgoingCall', function()
    CancelCall()
end)

RegisterNUICallback('DenyIncomingCall', function()
    CancelCall()
end)

RegisterNUICallback('CancelOngoingCall', function()
    CancelCall()
end)

RegisterNUICallback('AnswerCall', function()
    AnswerCall()
end)

function AnswerCall()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('qb-phone_new:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        TriggerServerEvent('qb-phone_new:server:AnswerCall', PhoneData.CallData)

        exports["pma-voice"]:SetCallChannel(PhoneData.CallData.CallId, 'Phone')
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Telefoon", 
                text = "Je hebt geen inkomende oproep!", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })
    end
end

RegisterNetEvent('qb-phone_new:client:AnswerCall')
AddEventHandler('qb-phone_new:client:AnswerCall', function()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('qb-phone_new:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        exports["pma-voice"]:SetCallChannel(PhoneData.CallData.CallId, 'Phone')
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Telefoon", 
                text = "Je hebt geen inkomende oproep!", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
     end
end)

RegisterNUICallback('FetchSearchResults', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone_new:server:FetchResult', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchAnwbSearchResults', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone:server:FetchAnwbResult', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('SendAnwbFactuur', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone:server:SendAnwbFactuur', function(result)
        cb(result)
    end, data)
end)

RegisterNUICallback('FetchVehicleResults', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetVehicleSearchResults', function(result)
        if result ~= nil then 
            for k, v in pairs(result) do
                QBCore.Functions.TriggerCallback('police:IsPlateFlagged', function(flagged)
                    result[k].isFlagged = flagged
                end, result[k].plate)
                Citizen.Wait(50)
            end
        end
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleScan', function(data, cb)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = tostring(GetEntityModel(vehicle))
    local modelint = GetEntityModel(vehicle)

    QBCore.Functions.TriggerCallback('qb-phone_new:server:ScanPlate', function(result)
        QBCore.Functions.TriggerCallback('police:IsPlateFlagged', function(flagged)
            result.isFlagged = flagged
            
            
            for k, v in pairs(QBCore.Shared.Vehicles) do
                if v.hash == model or v.hash == modelint then
                    local vehicleInfo = v
                    result.label = vehicleInfo["name"]
                    cb(result)
                end
            end
        end, plate)
    end, plate)
end)

RegisterNetEvent('qb-phone:client:addPoliceAlert')
AddEventHandler('qb-phone:client:addPoliceAlert', function(alertData)
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob ~= nil then
        if PlayerJob.name == 'police' and PlayerJob.onduty then
            SendNUIMessage({
                action = "AddPoliceAlert",
                alert = alertData,
            })
        end
    end
end)

RegisterNetEvent('qb-phone:client:AddAnwbAlert')
AddEventHandler('qb-phone:client:AddAnwbAlert', function(alertData)
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob ~= nil then
        if PlayerJob.name == 'mechanic' and PlayerJob.onduty then
            SendNUIMessage({
                action = "AddAnwbAlert",
                alert = alertData,
            })
        end
    end
end)

RegisterNUICallback('SetAlertWaypoint', function(data)
    local coords = data.alert.coords

    QBCore.Functions.Notify('GPS Locatie succesvol ingesteld!')
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNUICallback('RemoveSuggestion', function(data, cb)
    local data = data.data

    if PhoneData.SuggestedContacts ~= nil and next(PhoneData.SuggestedContacts) ~= nil then
        for k, v in pairs(PhoneData.SuggestedContacts) do
            if (data.name[1] == v.name[1] and data.name[2] == v.name[2]) and data.number == v.number and data.bank == v.bank then
                table.remove(PhoneData.SuggestedContacts, k)
            end
        end
    end
end)

function GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

RegisterNetEvent('qb-phone_new:client:GiveContactDetails')
AddEventHandler('qb-phone_new:client:GiveContactDetails', function()
    local ped = GetPlayerPed(-1)

    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local PlayerId = GetPlayerServerId(player)
        TriggerServerEvent('qb-phone_new:server:GiveContactDetails', PlayerId)
    else
        QBCore.Functions.Notify("Geen speler dichtbij!", "error")
    end
end)

-- Citizen.CreateThread(function()
--     Wait(1000)
--     TriggerServerEvent('qb-phone_new:server:GiveContactDetails', 1)
-- end)

RegisterNUICallback('DeleteContact', function(data, cb)
    local Name = data.CurrentContactName
    local Number = data.CurrentContactNumber
    local Account = data.CurrentContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == Name and v.number == Number then
            table.remove(PhoneData.Contacts, k)
            if PhoneData.isOpen then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Telefoon",
                        text = "Contact succesvol verwijderd!", 
                        icon = "fa fa-phone-alt",
                        color = "#04b543",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "Notification",
                    NotifyData = {
                        title = "Telefoon", 
                        content = "Contact succesvol verwijderd!", 
                        icon = "fa fa-phone-alt", 
                        timeout = 3500, 
                        color = "#04b543",
                    },
                })
            end
            break
        end
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[Number] ~= nil and next(PhoneData.Chats[Number]) ~= nil then
        PhoneData.Chats[Number].name = Number
    end
    TriggerServerEvent('qb-phone_new:server:RemoveContact', Name, Number)
end)

RegisterNetEvent('qb-phone_new:client:AddNewSuggestion')
AddEventHandler('qb-phone_new:client:AddNewSuggestion', function(SuggestionData)
    table.insert(PhoneData.SuggestedContacts, SuggestionData)

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Telefoon",
                text = "Je hebt een nieuw voorgesteld contact!", 
                icon = "fa fa-phone-alt",
                color = "#04b543",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Telefoon", 
                content = "Je hebt een nieuw voorgesteld contact!", 
                icon = "fa fa-phone-alt", 
                timeout = 3500, 
                color = "#04b543",
            },
        })
    end

    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "phone", Config.PhoneApplications["phone"].Alerts)
end)

RegisterNUICallback('GetCryptoData', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-bitcoin:server:GetCryptoData', function(CryptoData)
        cb(CryptoData)
    end, data.crypto)
end)

RegisterNUICallback('BuyCrypto', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-bitcoin:server:BuyCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('SellCrypto', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-bitcoin:server:SellCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('TransferCrypto', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-bitcoin:server:TransferCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNetEvent('qb-phone_new:client:RemoveBankMoney')
AddEventHandler('qb-phone_new:client:RemoveBankMoney', function(amount)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Bank",
                text = "Er is €"..amount..",- van je bank afgeschreven!", 
                icon = "fas fa-university", 
                color = "#ff002f",
                timeout = 3500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Betaling",
                content = "Je hebt €"..amount..",- betaald!", 
                icon = "fas fa-university",
                timeout = 3500, 
                color = "#ff002f",
            },
        })
    end
end)

RegisterNetEvent('qb-phone_new:client:AddTransaction')
AddEventHandler('qb-phone_new:client:AddTransaction', function(SenderData, TransactionData, Message, Title)
    local Data = {
        TransactionTitle = Title,
        TransactionMessage = Message,
    }
    
    table.insert(PhoneData.CryptoTransactions, Data)

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Crypto",
                text = Message, 
                icon = "fas fa-chart-pie",
                color = "#04b543",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Crypto",
                content = Message, 
                icon = "fas fa-chart-pie",
                timeout = 3500, 
                color = "#04b543",
            },
        })
    end

    SendNUIMessage({
        action = "UpdateTransactions",
        CryptoTransactions = PhoneData.CryptoTransactions
    })

    TriggerServerEvent('qb-phone_new:server:AddTransaction', Data)
end)

RegisterNUICallback('GetCryptoTransactions', function(data, cb)
    local Data = {
        CryptoTransactions = PhoneData.CryptoTransactions
    }
    cb(Data)
end)

RegisterNUICallback('GetAvailableRaces', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-lapraces:server:GetRaces', function(Races)
        cb(Races)
    end )
end)

RegisterNUICallback('JoinRace', function(data)
    TriggerServerEvent('zb-lapraces:server:JoinRace', data.RaceData)
end)

RegisterNUICallback('LeaveRace', function(data)
    TriggerServerEvent('zb-lapraces:server:LeaveRace', data.RaceData)
end)

RegisterNUICallback('StartRace', function(data)
    TriggerServerEvent('zb-lapraces:server:StartRace', data.RaceData.RaceId)
end)

RegisterNetEvent('qb-phone_new:client:UpdateLapraces')
AddEventHandler('qb-phone_new:client:UpdateLapraces', function()
    SendNUIMessage({
        action = "UpdateRacingApp",
    })
end)

RegisterNUICallback('GetRaces', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-lapraces:server:GetListedRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('GetTrackData', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-lapraces:server:GetTrackData', function(TrackData, CreatorData)
        TrackData.CreatorData = CreatorData
        cb(TrackData)
    end, data.RaceId)
end)

RegisterNUICallback('SetupRace', function(data, cb)
    TriggerServerEvent('zb-lapraces:server:SetupRace', data.RaceId, tonumber(data.AmountOfLaps))
end)

RegisterNUICallback('HasCreatedRace', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-lapraces:server:HasCreatedRace', function(HasCreated)
        cb(HasCreated)
    end)
end)

RegisterNUICallback('IsInRace', function(data, cb)
    local InRace = exports['zb-lapraces']:IsInRace()
    cb(InRace)
end) 

RegisterNUICallback('IsAuthorizedToCreateRaces', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-lapraces:server:IsAuthorizedToCreateRaces', function(IsAuthorized, NameAvailable)
        local data = {
            IsAuthorized = IsAuthorized,
            IsBusy = exports['zb-lapraces']:IsInEditor(),
            IsNameAvailable = NameAvailable,
        }
        cb(data)
    end, data.TrackName)
end)

RegisterNUICallback('StartTrackEditor', function(data, cb)
    TriggerServerEvent('zb-lapraces:server:CreateLapRace', data.TrackName)
end)

RegisterNUICallback('GetRacingLeaderboards', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-lapraces:server:GetRacingLeaderboards', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('RaceDistanceCheck', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-lapraces:server:GetRacingData', function(RaceData)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local checkpointcoords = RaceData.Checkpoints[1].coords
        local dist = GetDistanceBetweenCoords(coords, checkpointcoords.x, checkpointcoords.y, checkpointcoords.z, true)
        if dist <= 115.0 then
            if data.Joined then
                TriggerEvent('zb-lapraces:client:WaitingDistanceCheck')
            end
            cb(true)
        else
            QBCore.Functions.Notify('Je bent te ver weg van de race, locatie is ingesteld op de race!', 'error', 5000)
            SetNewWaypoint(checkpointcoords.x, checkpointcoords.y)
            cb(false)
        end
    end, data.RaceId)
end)

RegisterNUICallback('IsBusyCheck', function(data, cb)
    if data.check == "editor" then
        cb(exports['zb-lapraces']:IsInEditor())
    else
        cb(exports['zb-lapraces']:IsInRace())
    end
end)

RegisterNUICallback('CanRaceSetup', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-lapraces:server:CanRaceSetup', function(CanSetup)
        cb(CanSetup)
    end)
end)

RegisterNUICallback('GetPlayerHouses', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetPlayerHouses', function(Houses)
        cb(Houses)
    end)
end)

RegisterNUICallback('GetPlayerKeys', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetHouseKeys', function(Keys)
        cb(Keys)
    end)
end)

RegisterNUICallback('SetHouseLocation', function(data, cb)
    SetNewWaypoint(data.HouseData.HouseData.coords.enter.x, data.HouseData.HouseData.coords.enter.y)
    QBCore.Functions.Notify("GPS is succesvol ingesteld op " .. data.HouseData.HouseData.adress .. "!", "success")
end)

RegisterNUICallback('RemoveKeyholder', function(data)
    TriggerServerEvent('qb-houses:server:removeHouseKey', data.HouseData.name, {
        citizenid = data.HolderData.citizenid,
        firstname = data.HolderData.charinfo.firstname,
        lastname = data.HolderData.charinfo.lastname,
    })
end)

RegisterNUICallback('TransferCid', function(data, cb)
    local TransferedCid = data.newBsn

    QBCore.Functions.TriggerCallback('qb-phone_new:server:TransferCid', function(CanTransfer)
        cb(CanTransfer) 
    end, TransferedCid, data.HouseData)
end) 

RegisterNUICallback('FetchPlayerHouses', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone_new:server:MeosGetPlayerHouses', function(result)
        cb(result)
    end, data.input)
end)

RegisterNUICallback('SetGPSLocation', function(data, cb)
    local ped = GetPlayerPed(-1)

    SetNewWaypoint(data.coords.x, data.coords.y)
    QBCore.Functions.Notify('Locatie is succesvol ingesteld!', 'success')
end)

RegisterNUICallback('SetApartmentLocation', function(data, cb)
    local ApartmentData = data.data.appartmentdata
    local TypeData = Apartments.Locations[ApartmentData.type]

    SetNewWaypoint(TypeData.coords.enter.x, TypeData.coords.enter.y)
    QBCore.Functions.Notify('Locatie is succesvol ingesteld!', 'success')
end)

RegisterNUICallback('GetCurrentLawyers', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetCurrentLawyers', function(lawyers)
        cb(lawyers)
    end)
end)

RegisterNUICallback('GetCurrentTaxis', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone_new:server:GetCurrentTaxis', function(taxis)
        cb(taxis)
    end) 
end)

RegisterNUICallback('GetPlayerHouses', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-houses:server:GetPlayerHouses', function(Houses)
        cb(Houses)
    end) 
end)

RegisterNUICallback('GetPlayerKeys', function(data, cb)
    QBCore.Functions.TriggerCallback('zb-houses:server:GetHouseKeys', function(Keys)
        cb(Keys)
    end)
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

RegisterNUICallback('SetupStoreApps', function(data, cb)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local data = {
        StoreApps = Config.StoreApps,
        PhoneData = PlayerData.metadata["phonedata"]
    }
    cb(data)
end)

function GetFirstAvailableSlot()
    local retval = 0
    for k, v in pairs(Config.PhoneApplications) do
        retval = retval + 1
    end
    return (retval + 1)
end

local CanDownloadApps = false

RegisterNUICallback('InstallApplication', function(data, cb)
    local ApplicationData = Config.StoreApps[data.app]
    local NewSlot = GetFirstAvailableSlot()

    if not CanDownloadApps then
        return
    end
    
    if NewSlot <= Config.MaxSlots then
        TriggerServerEvent('qb-phone_new:server:InstallApplication', {
            app = data.app,
        })
        cb({
            app = data.app,
            data = ApplicationData
        })
    else
        cb(false)
    end
end)

RegisterNUICallback('RemoveApplication', function(data, cb)
    TriggerServerEvent('qb-phone_new:server:RemoveInstallation', data.app)
end)

RegisterNetEvent('qb-phone_new:RefreshPhone')
AddEventHandler('qb-phone_new:RefreshPhone', function()
    LoadPhone()
    SetTimeout(250, function()
        SendNUIMessage({
            action = "RefreshAlerts",
            AppData = Config.PhoneApplications,
        })
    end)
end)

RegisterNUICallback('GetTruckerData', function(data, cb)
    local TruckerMeta = QBCore.Functions.GetPlayerData().metadata["jobrep"]["trucker"]
    local TierData = exports['qb-trucker']:GetTier(TruckerMeta)
    cb(TierData)
end)

-- Weer app
RegisterNUICallback('GetWeerData', function(data, cb)
    QBCore.Functions.TriggerCallback("zb-weathersync:server:weerAppData", function(data)
        data["uren"] = GetClockHours()
        data["minuten"] = GetClockMinutes()
        cb(data)
    end)
end)

-- Hulpdiensten app
RegisterNUICallback('hulpdienstenMelding112', function(data, cb)
    TriggerEvent("police:client:SendEmergencyMessage", data.bericht)
end)

RegisterNUICallback('hulpdienstenMeldingAmbulance', function(data, cb)
    TriggerEvent("ambulance:client:SendEmergencyMessage", data.bericht)
end)

RegisterNUICallback('hulpdienstenMeldingANWB', function(data, cb)
    TriggerEvent("zb-vehicletuning:client:SendEmergencyMessage", data.bericht)
end)

-- Disables GTA controls when display is active
-- this allows for NUI input with ingame input
function DisableDisplayControlActions()
    DisableControlAction(0, 1, true) -- disable mouse look
    DisableControlAction(0, 2, true) -- disable mouse look
    DisableControlAction(0, 3, true) -- disable mouse look
    DisableControlAction(0, 4, true) -- disable mouse look
    DisableControlAction(0, 5, true) -- disable mouse look
    DisableControlAction(0, 6, true) -- disable mouse look

    DisableControlAction(0, 263, true) -- disable melee
    DisableControlAction(0, 264, true) -- disable melee
    DisableControlAction(0, 257, true) -- disable melee
    DisableControlAction(0, 140, true) -- disable melee
    DisableControlAction(0, 141, true) -- disable melee
    DisableControlAction(0, 142, true) -- disable melee
    DisableControlAction(0, 143, true) -- disable melee

    DisableControlAction(0, 177, true) -- disable escape
    DisableControlAction(0, 200, true) -- disable escape
    DisableControlAction(0, 202, true) -- disable escape
    DisableControlAction(0, 322, true) -- disable escape

    DisableControlAction(0, 245, true) -- disable chat  
end

function InPhone()
    return PhoneData.isOpen
end




-- Twitter dingetjes
local twitterCamActive = false
local twitterFotoGemaakt = false
local twiterCamBericht = ""

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        letsleep = true
        if twitterCamActive then
            letsleep = false
            if IsControlJustPressed(0, 177) then -- Sluiten
                sluitCamera()
                twitterCamActive = false
            end

            if IsControlJustPressed(0, 176) and not twitterFotoGemaakt then -- Foto maken
                twitterFotoGemaakt = true
                QBCore.Functions.TriggerCallback("zb-screenshots:server:twitterMaakFoto", function(gelukt, url)
                    if gelukt then

                        local PlayerData = QBCore.Functions.GetPlayerData()
                        local tweet = {
                            firstName = PlayerData.charinfo.firstname,
                            lastName = PlayerData.charinfo.lastname,
                            message = twiterCamBericht.."  <br><img src='"..url.."' />",
                            time = "kaasje",
                            tweetId = GenerateTweetId(),
                            picture = PlayerData.metadata.phone.profilepicture
                        }
                    
                        table.insert(PhoneData.Tweets, tweet)
                        Citizen.Wait(100)
                        TriggerServerEvent('qb-phone_new:server:UpdateTweets', PhoneData.Tweets, tweet)
                        sluitCamera()
                        QBCore.Functions.Notify("Je foto is geplaatst op Twitter!", "success")
                        twitterCamActive = false
                        twitterFotoGemaakt = false
                    else
                        QBCore.Functions.Notify("Er is een fout opgetreden bij het maken van een foto, reloggen zou dit probleem kunnen verhelpen!", "error")
                        sluitCamera()
                        Wait(300)
                        twitterCamActive = false
                        twitterFotoGemaakt = false
                    end
                end)
            end
        end

        if letsleep then
            Wait(1000)
        end
    end
end)

RegisterNUICallback("twitterMaakFoto", function(data, cb)
    twiterCamBericht = ""
    if string.find(data.bericht:lower(), "<script") or string.find(data.bericht, "<iframe") then
        TriggerServerEvent("zb-smallresources:server:banSpelerPerm")
    else
        CreateMobilePhone(1)
        CellCamActivate(true, true)
        CellFrontCamActivate(true)
        twitterCamActive = true
        twiterCamBericht = data.bericht
        QBCore.Functions.Notify("Je kan een foto maken met ENTER<br>Je kan de camera sluiten met BACKSPACE", "primary", 8000)
    end
end)

function sluitCamera()
    DestroyMobilePhone()
    CellCamActivate(false, false)
    CellFrontCamActivate(false)
end

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

