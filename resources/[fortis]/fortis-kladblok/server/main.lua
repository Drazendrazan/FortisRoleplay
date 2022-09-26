QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
local Notes = {}

RegisterServerEvent("notes:server:SaveNoteData")
AddEventHandler('notes:server:SaveNoteData', function(text, noteId)
	noteId = noteId ~= nil and noteId or CreateNoteId()
	if Notes[noteId] == nil then
		Notes[noteId] = text
		TriggerClientEvent("notes:client:AddNoteDrop", -1, noteId, source)
		local name = GetPlayerName(source)
		print("[Note-New]: "..name.." > "..Notes[noteId])
	else
		Notes[noteId] = text
		TriggerClientEvent("notes:client:SetActiveStatus", -1, noteId, false)
		local name = GetPlayerName(source)
		print("[Note-Edit]: "..name.." > "..Notes[noteId])
	end
end)

RegisterServerEvent("notes:server:SetActiveStatus")
AddEventHandler('notes:server:SetActiveStatus', function(noteId, status)
	TriggerClientEvent("notes:client:SetActiveStatus", -1, noteId, status)
end)

RegisterServerEvent("notes:server:OpenNoteData")
AddEventHandler('notes:server:OpenNoteData', function(noteId)
	if Notes[noteId] ~= nil then
		TriggerClientEvent("notes:client:OpenNotepad", source, noteId, Notes[noteId])
		TriggerClientEvent("notes:client:SetActiveStatus", -1, noteId, true)
		local name = GetPlayerName(source)
		print("[Note-Open]: "..name.." > "..Notes[noteId])
	end
end)

RegisterServerEvent("notes:server:RemoveNoteData")
AddEventHandler('notes:server:RemoveNoteData', function(noteId)
	Notes[noteId] = nil
	TriggerClientEvent("notes:client:RemoveNote", -1, noteId)
end)

function CreateNoteId()
	local noteId = math.random(1, 9999)
	while (Notes[noteId] ~= nil) do 
		noteId = math.random(1, 9999)
	end
	return noteId
end

QBCore.Commands.Add("note", "Opent een kladblok.", {}, false, function(source, args)
	TriggerClientEvent("notes:client:OpenNotepad", source)
end)

QBCore.Functions.CreateUseableItem("stickynote", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
  	TriggerClientEvent("notes:client:OpenNotepad", source)
end)
