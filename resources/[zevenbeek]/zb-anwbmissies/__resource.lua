resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

data_file 'DLC_ITYP_REQUEST' 'nacelle.ytyp'

file 'nacelle.ytyp'

client_scripts {
    'client/client.lua',
    'config.lua',
    'client/gui.lua',
    'config.lua',
}

server_scripts {
    'server/server.lua',
    'config.lua',
}
client_script '@zb-guard/03923.lua'