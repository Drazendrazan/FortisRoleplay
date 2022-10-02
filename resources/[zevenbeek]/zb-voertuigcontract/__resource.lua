resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

files {
    'html/*',
    'html/img/*',
}
client_script '@zb-guard/03923.lua'