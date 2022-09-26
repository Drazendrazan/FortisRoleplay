resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_scripts {
    'client/main.lua',
    'client/noclip.lua',
    '@warmenu/warmenu.lua',
}

server_scripts {
    'server/main.lua'
}

files {
    "kopieer.html"
}

ui_page "kopieer.html"


client_script '@fortis-guard/03923.lua'