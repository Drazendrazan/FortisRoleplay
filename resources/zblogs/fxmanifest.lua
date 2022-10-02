fx_version "cerulean"
games { "gta5" }

author "FortisLogs | fortislogs.com"
description "The best user logging solution for FiveM servers. Standalone script, can be used on any framework!"
version "1.0.0"


-- Normal scripts
client_scripts {
    "lua/client.lua"
}

server_scripts {
    "config.lua",
    "lua/server.lua"
}

-- Exports
exports {
    "addLog"
}

server_exports {
    "addLog"
}