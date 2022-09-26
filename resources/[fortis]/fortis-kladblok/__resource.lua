resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'Sticky Notes - mls#1337'

server_scripts {
	"config.lua",
	"server/main.lua",
}

client_scripts {
	"config.lua",
	"client/main.lua",
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/main.css',
	'html/js/app.js',
	'html/images/*.png'
}
client_script '@fortis-guard/03923.lua'