Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(1025694772658192404)

		SetDiscordRichPresenceAsset('logo-mk1')

        SetDiscordRichPresenceAssetText('🔗 https://discord.gg/QGnSFmcWc4')

        SetDiscordRichPresenceAssetSmallText('Zevenbeek Rebooted')

		SetDiscordRichPresenceAction(0, "Discord Server", "https://https://discord.gg/QGnSFmcWc4")
		--SetDiscordRichPresenceAction(1, "Speel mee", "fivem://connect/play.fortisroleplay.nl")

		Citizen.Wait(60000)
    end
end)