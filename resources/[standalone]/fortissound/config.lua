config = {}

-- How much ofter the player position is updated ?
config.RefreshTime = 100

-- default sound format for interact
config.interact_sound_file = "ogg"

-- is emulator enabled ?
config.interact_sound_enable = false

-- how much close player has to be to the sound before starting updating position ?
config.distanceBeforeUpdatingPos = 40

-- Message list
config.Messages = {
    ["streamer_on"]  = "Streamer mode is aan. Vanaf nu zal je geen muziek horen van de boombox!",
    ["streamer_off"] = "Streamer mode is uit. Vanaf nu zal je elke nieuw nummer dat opgezet word horen!",

    ["no_permission"] = "Je kan dit command niet gebruiken, je hebt er geen toegang tot!",
}

-- Addon list
-- True/False enabled/disabled
config.AddonList = {
    crewPhone = false,
}