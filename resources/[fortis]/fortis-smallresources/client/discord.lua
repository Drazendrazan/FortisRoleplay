Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(811194725159141396)

		SetDiscordRichPresenceAsset('logo-mk1')

        SetDiscordRichPresenceAssetText('🔗 fortisroleplay.nl/discord')

        SetDiscordRichPresenceAssetSmallText('FortisRP')

		SetDiscordRichPresenceAction(0, "Discord Server", "https://fortisroleplay.nl/discord")
		SetDiscordRichPresenceAction(1, "Speel mee", "fivem://connect/play.fortisroleplay.nl")

		Citizen.Wait(60000)
    end
end)