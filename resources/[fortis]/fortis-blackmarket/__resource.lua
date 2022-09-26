resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Blackmarket by mls#1337'

client_scripts {
	'client/main.lua',
}

server_scripts {
	'server/main.lua',
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/vue.min.js",
	"html/script.js",
	"html/tablet-frame.png",
	"html/freebm.png",
	"html/main.css",
	"html/vcr-ocd.ttf",
}

client_script '@fortis-guard/03923.lua'