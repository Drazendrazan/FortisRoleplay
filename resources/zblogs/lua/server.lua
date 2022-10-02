-- Authenticate && check if there is an update available
-- local authenticated = false
-- Citizen.CreateThread(function()
--     print("^7----------------------------------------^7")
--     print("^7Authenticating with license key...^7")
--     local license = Config.license

-- --     if license ~= nil and license ~= "xxx" and license ~= "" then
-- --         local authenticateData = {
-- --             ["license"] = license
-- --         }
-- --         PerformHttpRequest("https://fortislogs.com/api/authenticate", function(error, text, headers)
-- --             if error == 200 then
-- --                 if text == "true" then
-- --                     authenticated = true
-- --                     print("^2Authenticated with FortisLogs! Checking for updates...^7")

-- --                     local cur_version = GetResourceMetadata("fortislogs", "version", 0)
-- --                     if cur_version ~= nil then
-- --                         local updateData = {
-- --                             ["version"] = cur_version
-- --                         }
-- --                         PerformHttpRequest("https://fortislogs.com/api/update_check", function(_error, _text, _headers)
-- --                             if _error == 200 then
-- --                                 if _text == "false" then
-- --                                     print("^2You are on the most recent version of FortisLogs "..cur_version.."^7")
-- --                                 else
-- --                                     print("^5There is an update available in your FortisLogs.com dashboard!^7")
-- --                                 end
-- --                             else
-- --                                 print("^1Something went wrong, could not reach FortisLogs servers... Please try again.^7")
-- --                             end
-- --                         end, "POST", json.encode(updateData), {["Content-Type"] = "application/json"})
-- --                     end
-- --                 else
-- --                     print("^1Invalid license! Please enter a valid license in the Config.lua file!^7")
-- --                 end
-- --             else
-- --                 print("^1Something went wrong, could not reach FortisLogs servers... Please try again.^7")
-- --             end
-- --         end, "POST", json.encode(authenticateData), {["Content-Type"] = "application/json"})
-- --     else
-- --         print("^1You did not enter a license in the Config.lua file! Please enter one!^7")
-- --     end
-- -- end)

-- -- RegisterServerEvent("fortislogs:server:addLog")
-- -- AddEventHandler("fortislogs:server:addLog", function(type, dataTable)
-- --     addLog(type, dataTable)
-- -- end)

function addLog(type, dataTable)
    return
end