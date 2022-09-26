--[[ Chat Protection ]]

RS.chatProtection = false -- Masterswitch
RS.chat_antifakemessage = false -- Detects on using a fake name (in-game text chat)

RS.chat_antispam = false -- Detects on spamming messages 
RS.chat_antispamMaxMessages = 10 -- Trigger antispam after 10 messages
RS.chat_antispamResetTime = 7000 -- Reset antispam trigger every 7 seconds

RS.chat_antiblacklistedwords = false -- Detects on writing a blacklisted word (commands like /ooc are included)
RS.chat_detection_mode = 1 -- 1 Kick, 2 Ban (Do not use 0 `Warning` to avoid spamming)

RS.chat_blacklistedwords = {    
	"Desudo",
    "Brutan",
    "EulenCheats",
    "Lynx 8",
    "www.lynxmenu.com",
    "HamHaxia",
    "Ham Mafia",
    "www.renalua.com",
    "HamHaxia", 
    "Ham Mafia", 
    ">:D Player Crash",  
    "34ByTe Community", 
    "lynxmenu.com", 
    "Anti-Lynx",
    "hammafia.com",
    "vjuton.pl",
    "nigger",
    "motherfucker",
    "fuck off"
}
